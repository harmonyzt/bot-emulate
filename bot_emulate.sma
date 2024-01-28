#include < amxmodx >
#include < amxmisc >
#include < fun >
#include < cstrike >
#include < csx >

#pragma tabsize 0

new MaxPlayers;
new players_online = 0;

// From 1 to 100
// This describes how populated server is and bot's will to play. The higher the number, the higher the chances of a bot to join the server and not leave.
new popularity = 80;
new will_to_play[32] = 50;

public plugin_init() {
    register_plugin("Bot Decision Overhaul", "0.3dev", "harmony");
    //register_logevent("RoundStart", 2, "1=Round_Start");
    register_event("DeathMsg", "DeathEvent", "a");

    MaxPlayers = get_maxplayers();

    set_task(random_float(25.0, 150.0), "bot_think", _, _, _, "b");
}

public client_putinserver(id) {
    players_online++
}

public client_disconnect(id) {
    players_online--
}

public bot_think(altID) {
    
    // If the function was called with alternative ID of a bot to decide,, pass it here
    if(altID && will_to_play[altID] < random_num(1, 100)){
        botLeave(altID);
    }
    
    if (players_online < MaxPlayers && !altID) {
        if (popularity > 80) {
            addBot(random_num(1, 2), random_num(65, 100))
        } else {
            addBot(1, random_num(10, 100))
        }
    }

    for (new id = 1; id <= MaxPlayers; id++) {
        if (!is_user_bot(id) || altID)
            return;

        if (popularity < 50 && will_to_play[id] < random_num(1, 100)) {
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
    
    will_to_play[victim] -= 3;
    will_to_play[attacker] += 2;
    
    // Force bot to take the action if will  to play is too low
    if(will_to_play[victim] < 5){
        bot_think(victim);
    }
    
}
