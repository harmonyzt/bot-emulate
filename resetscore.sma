
#include <amxmodx>
#include <amxmisc>
#include <cstrike>
#include <fun>

#define adtime	 600.0 //Default of 10 minuites

new pcvar_Advertise
new pcvar_Display

public plugin_init()
{
	register_plugin("Reset Score", "1.0", "None")
	
	//You may type /resetscore or /restartscore
	register_clcmd("say /rs", "reset_score")
	register_clcmd("say /resetscore", "reset_score")
	register_clcmd("say /restartscore", "reset_score")
	
	//This command by default will be set at 0
	//Change it to 1 in server.cfg if you want
	//A message to be shown to advertise this.
	pcvar_Advertise = register_cvar("sv_rsadvertise", "0")
	//This command by default is also 0
	//Change it to 1 in server.cfg if you want
	//It to show who reset their scores when they do it
	pcvar_Display = register_cvar("sv_rsdisplay", "1")
	
	if(get_cvar_num("sv_rsadvertise") == 1)
	{
		set_task(adtime, "advertise", _, _, _, "b")
	}
}

public reset_score(id)
{
	//These both NEED to be done twice, otherwise your frags wont
	//until the next round
	cs_set_user_deaths(id, 0)
	set_user_frags(id, 0)
	cs_set_user_deaths(id, 0)
	set_user_frags(id, 0)
	
	if(get_pcvar_num(pcvar_Display) == 1)
	{
		new name[33]
		get_user_name(id, name, 32)
		client_print(0, print_chat, "%s just reset his score", name)
	}
	else
	{
		client_print(id, print_chat, "Your score was reset successfully")
	}
}

public advertise()
{
	set_hudmessage(255, 0, 0, -1.0, 0.20, 0, 0.2, 12.0)
	show_hudmessage(0, "Type in chat /resetscore or /rs to reset your score!")
}

public client_putinserver(id)
{
	if(get_pcvar_num(pcvar_Advertise) == 1)
	{
		set_task(10.0, "connectmessage", id, _, _, "a", 1)
	}
}

public connectmessage(id)
{
	if(is_user_connected(id))
	{
	client_print(id, print_chat, "Type in chat /resetscore or /rs to reset your score!")
	}
}
