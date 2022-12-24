#include < amxmodx >
#include < amxmisc >
#include < fun >
#include < cstrike >
#include < csx >

#pragma tabsize 0

new MaxPlayers;
new players_online = 0;

// From 1 to 100
new popularity = 80;
new will_to_play = 80;

public plugin_init(){
	register_plugin("Bot Emulation", "0.1dev", "harmony");
	//register_logevent("RoundStart", 2, "1=Round_Start");
	//register_event("DeathMsg", "DeathEvent", "a");

	MaxPlayers = get_maxplayers();

	set_task(random_float(15.0, 60.0), "bot_join_leave",_,_,_, "b");
}

public client_putinserver(id){
	players_online++
}

public client_disconnect(id){
	players_online--
}

public bot_join_leave(){
	if(players_online < MaxPlayers){
		if(popularity > 50){
			addbot(random_num(1,2), random_num(85,100))
		} else {
			addbot(1, random_num(1,100))
		}
	}

	for(new id = 1; id <= MaxPlayers; id++){
		if(!is_user_bot(id))
			return;

		if(popularity > 50 && will_to_play > random_num(1,100)){
			
		} else {
			leavebot(id);
		}
	}
}

public addbot(amount, skill){
	if(amount == 1){
		server_cmd("pb add %d", skill)
	} else {
		for(new botamount = 1; botamount <= amount; botamount++){
			server_cmd("pb add %d", skill)
		}
	}
}

public leavebot(id){
	new name[32];
	get_user_name(id, name, 31);

	server_cmd("amx_kick #%s ^"Left^"", name);
}