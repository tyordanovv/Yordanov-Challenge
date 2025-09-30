module challenge::marketplace;

use challenge::hero::Hero;
use sui::coin::{Self, Coin};
use sui::event;
use sui::sui::SUI;

// ========= ERRORS =========

const EInvalidPayment: u64 = 1;
const ENotSeller: u64 = 2;

// ========= STRUCTS =========

public struct ListHero has key, store {
    id: UID,
    nft: Hero,
    price: u64,
    seller: address,
}

// ========= CAPABILITIES =========

public struct AdminCap has key, store {
    id: UID,
}

// ========= EVENTS =========

public struct HeroListed has copy, drop {
    list_hero_id: ID,
    price: u64,
    seller: address,
    timestamp: u64,
}

public struct HeroBought has copy, drop {
    list_hero_id: ID,
    price: u64,
    buyer: address,
    seller: address,
    timestamp: u64,
}

public struct HeroDelisted has copy, drop {
    list_hero_id: ID,
    hero_id: ID,
    seller: address,
}

public struct PriceChanged has copy, drop {
    list_hero_id: ID,
    old_price: u64,
    new_price: u64
}

// ========= FUNCTIONS =========

fun init(ctx: &mut TxContext) {

    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    transfer::transfer(admin_cap, tx_context::sender(ctx));
}

public fun list_hero(nft: Hero, price: u64, ctx: &mut TxContext) {
    let seller = tx_context::sender(ctx);

    let list_hero = ListHero {
        id: object::new(ctx),
        nft,
        price,
        seller,
    };
    
    let list_hero_id = object::id(&list_hero);

    event::emit(HeroListed {
        list_hero_id,
        price,
        seller,
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });
    
    transfer::share_object(list_hero);
}

#[allow(lint(self_transfer))]
public fun buy_hero(list_hero: ListHero, payment: Coin<SUI>, ctx: &mut TxContext) {
    let list_hero_id = object::id(&list_hero);
    let ListHero { id, nft, price, seller } = list_hero;
    let buyer = tx_context::sender(ctx);
    
    assert!(buyer != seller, ENotSeller);
    assert!(coin::value(&payment) == price, EInvalidPayment);
    
    transfer::public_transfer(payment, seller);
    transfer::public_transfer(nft, buyer);
    
    event::emit(HeroBought {
        list_hero_id,
        price,
        buyer,
        seller,
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });
    
    object::delete(id);
}

// // ========= ADMIN FUNCTIONS =========

public fun delist(_: &AdminCap, list_hero: ListHero) {
    let list_hero_id = object::id(&list_hero);
    let ListHero { id, nft, price: _, seller } = list_hero;

    
    let hero_id = object::id(&nft);
    
    transfer::public_transfer(nft, seller);
    
    event::emit(HeroDelisted {
        list_hero_id,
        hero_id,
        seller
    });
    object::delete(id);
}

public fun change_the_price(_: &AdminCap, list_hero: &mut ListHero, new_price: u64) {    
    let old_price = list_hero.price;
    list_hero.price = new_price;
    
    event::emit(PriceChanged {
        list_hero_id: object::id(list_hero),
        old_price,
        new_price
    });
}

// // ========= GETTER FUNCTIONS =========

#[test_only]
public fun listing_price(list_hero: &ListHero): u64 {
    list_hero.price
}

// ========= TEST ONLY FUNCTIONS =========

#[test_only]
public fun test_init(ctx: &mut TxContext) {
    let admin_cap = AdminCap {
        id: object::new(ctx),
    };
    transfer::transfer(admin_cap, ctx.sender());
}

