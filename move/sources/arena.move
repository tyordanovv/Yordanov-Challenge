module challenge::arena;

use challenge::hero::Hero;
use sui::event;

// Error codes
const EOwnerBattleOwnWarrior: u64 = 1;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: tx_context::sender(ctx),
    };

    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: tx_context::epoch_timestamp_ms(ctx),
    });

    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    let Arena { id, warrior, owner } = arena;
    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);

    if (tx_context::sender(ctx) == owner) {
        abort EOwnerBattleOwnWarrior
    };

    let hero_power = challenge::hero::hero_power(&hero);
    let warrior_power = challenge::hero::hero_power(&warrior);

    if (hero_power > warrior_power) {
        let sender = tx_context::sender(ctx);
        transfer::public_transfer(hero, sender);
        transfer::public_transfer(warrior, sender);

        event::emit(ArenaCompleted {
            winner_hero_id: hero_id,
            loser_hero_id: warrior_id,
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });
    } else if (warrior_power > hero_power) {
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);

        event::emit(ArenaCompleted {
            winner_hero_id: warrior_id,
            loser_hero_id: hero_id,
            timestamp: tx_context::epoch_timestamp_ms(ctx),
        });
    } else {
        transfer::public_transfer(hero, tx_context::sender(ctx));
        transfer::public_transfer(warrior, owner);
    };

    object::delete(id);
}

