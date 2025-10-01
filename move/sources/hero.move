module challenge::hero;

use std::string::String;
use sui::random::Random;

// ========= CONSTANTS =========
const MAX_U64: u64 = 18446744073709551615;
const MIN_RANDOM_POWER: u64 = 0;

// ========= STRUCTS =========
public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

public struct HeroMetadata has key, store {
    id: UID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    
    let hero = Hero {
        id: object::new(ctx),
        name,
        image_url,
        power,
    };

    transfer::transfer(hero, tx_context::sender(ctx));
    
    let metadata = HeroMetadata {
        id: object::new(ctx),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    };

    transfer::freeze_object(metadata);
}

// As the other function accepts any number for hero power, and since the requirements
// do not specify an upper bound, we generate a random number in the full range between
// 0 and 18446744073709551615. Better approaches could be to limit the upper bound to a
// reasonable number: eg 0 to 100
#[allow(lint(self_transfer))]
entry fun create_hero_random_power(r: &Random, name: String, image_url: String, ctx: &mut TxContext) {
    let mut gen = r.new_generator(ctx);
    let random_power = gen.generate_u64_in_range(MIN_RANDOM_POWER, MAX_U64);
    let hero = Hero {
        id: object::new(ctx),
        name,
        image_url,
        power: random_power,
    };

    transfer::transfer(hero, tx_context::sender(ctx));
    
    let metadata = HeroMetadata {
        id: object::new(ctx),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    };

    transfer::freeze_object(metadata);
}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}

