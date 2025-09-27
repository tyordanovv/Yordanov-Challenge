module challenge::arena;

use challenge::hero::Hero;
use sui::event;

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

// #[allow(lint(self_transfer))]
// public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {

//     // TODO: Implement battle logic
//         // Hints:
//         // Destructure arena to get id, warrior, and owner
//     // TODO: Compare hero.hero_power() with warrior.hero_power()
//         // Hints: 
//         // If hero wins: both heroes go to ctx.sender()
//         // If warrior wins: both heroes go to battle place owner
//     // TODO:  Emit BattlePlaceCompleted event with winner/loser IDs (Don't forget to use object::id(&warrior) or object::id(&hero) ). 
//         // Hints:  
//         // You have to emit this inside of the if else statements
//     // TODO: Delete the battle place ID 
// }

