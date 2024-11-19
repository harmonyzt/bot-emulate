#include < amxmodx >
#include < amxmisc >
#include < fun >
#include < cstrike >
#include < csx >

#pragma tabsize 0

new MaxPlayers;
new players_online = 0;

// From 1 to 100
// This describes how populated server is and bot's will to play. The higher the number, the higher the chances of a bot to join the server and stay.
new popularity = 83;

// Scales dynamically. Score, deaths and K/D ratio of a bot will affect this.
new will_to_play[32] = 50;

// Extra info for calculations
new deaths[32];
new kills[32];

public plugin_init() {
    register_plugin("Bot Decisions Overhauled", "0.5dev", "harmony");
    //register_logevent("RoundStart", 2, "1=Round_Start");
    register_event("DeathMsg", "DeathEvent", "a");

    MaxPlayers = get_maxplayers();

    set_task(random_float(25.0, 150.0), "bot_think", _, _, _, "b");
}

public client_putinserver(id) {
    players_online++
    
    deaths[id] = 0
    kills[id] = 0
}

public client_disconnect(id) {
    players_online--
    
    deaths[id] = 0
    kills[id] = 0
}

public bot_think(altID) {
    
    // If the function was called with alternative ID of a bot to decide, pass it here
    if(altID){
        botLeave(altID);
    }
    
    if (players_online < MaxPlayers && !altID) {
        if (popularity > 80) {
            addBot(random_num(1, 2), random_num(55, 90))
        } else {
            addBot(1, random_num(10, 100))
        }
    }

    for (new id = 1; id <= MaxPlayers; id++) {
        if (!is_user_bot(id) && !is_user_connected(id) || altID)
            return;
        // If popularity is too low, bot will decide to leave.
        if (popularity < 50 && will_to_play[id] < random_num(1, 100)) {
            botLeave(id);
        }

        if(players_online > 29 && will_to_play[id] < 20){
            botLeave(id);
        }
    }
}

public addBot(amount, skill) {
    if (amount == 1) {
        server_cmd("pb add %d", skill)
    } else {
        for (new botamount = 1; botamount <= amount; botamount++) {
            server_cmd("pb add %d", skill)
        }
    }
}

public botLeave(id) {
    new name[32];
    get_user_name(id, name, 31);

    server_cmd("amx_kick #%s ^"Left^"", name);
}

public DeathEvent() {
    new victim = read_data(1);
    new attacker = read_data(2);
    
    if(!is_user_bot(victim) || !is_user_bot(attacker))
        return;
    
    will_to_play[victim] -= 3
    // Dopamine rush for a killer
    will_to_play[attacker] += 2;
    
    // Force bot to take the action if will  to play gets too low
    if(will_to_play[victim] < 5){
        bot_think(victim);
    }
}