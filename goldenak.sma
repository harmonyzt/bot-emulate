#include <amxmodx>
#include <fakemeta>
#include <fun>
#include <hamsandwich>
#include <cstrike>
#include <colorchat>

#define is_valid_player(%1) (1 <= %1 <= 32)

new const AK47_BIT_SUM = (1<<CSW_AK47)

new AK_V_MODEL[64] = "models/v_golden_ak47.mdl"
new AK_P_MODEL[64] = "models/p_golden_ak47.mdl"

new g_hasZoom[33], gold_damage, golden_model
new bool:g_HasAk[33]

public plugin_init() {
	register_plugin("GoldenAK47 Re-Remake", "1.0", "harmony")
	register_clcmd("say /goldenak", "cmdGoldenAk")
	
	gold_damage = register_cvar("goldenak_dmg", "1.5")
	golden_model = register_cvar("goldenak_custommodel", "1")

       
	register_event("DeathMsg", "Death", "a")
	register_event("WeapPickup", "checkModel", "b","1=19")
	register_event("CurWeapon", "checkWeapon", "be","1=1")

	RegisterHam(Ham_TakeDamage, "player", "fw_TakeDamage")
	RegisterHam(Ham_Spawn, "player", "fwHamPlayerSpawnPost", 1)
		
	register_forward(FM_CmdStart, "fw_CmdStart")
}
 
public client_connect(id)
	g_HasAk[id] = false
 
public client_disconnect(id)
	g_HasAk[id] = false
 
public Death()
	g_HasAk[read_data(2)] = false
 
public fwHamPlayerSpawnPost(id){
    g_HasAk[id] = false

    new iFlags = get_user_flags(id);

    if(iFlags & read_flags("b") && is_user_bot(id)){
        new randomroll
        randomroll = random_num(1,2);
        if(randomroll >= 1){
            cmdGoldenAk(id)
        }

    }
}
 
public plugin_precache() {
	precache_model(AK_V_MODEL)
	precache_model(AK_P_MODEL)
	precache_sound("weapons/zoom.wav")
}

public cmdGoldenAk(id) {
	if(!is_user_alive(id))
        return

        new name[32];
        get_user_name(id, name, 31);
        drop_weapon(id, 1);
        give_item(id, "weapon_ak47");
        cs_set_user_bpammo(id, CSW_AK47, 90);
        ColorChat(0, GREEN, "^x01[^x04FIRE PLAY^x01] %s took^x04 Gold AK-47", name);
        g_HasAk[id] = true
}

public checkModel(id) {      
	new szWeapID = read_data(2)
       
	if(szWeapID == CSW_AK47 && g_HasAk[id] == true && get_pcvar_num(golden_model) == 1) {
		set_pev(id, pev_viewmodel2, AK_V_MODEL)
		set_pev(id, pev_weaponmodel2, AK_P_MODEL)
	}
	return PLUGIN_HANDLED
}

public checkWeapon(id) {
	new plrWeapId 
	plrWeapId = get_user_weapon(id)

	if (plrWeapId == CSW_AK47 && g_HasAk[id])
		checkModel(id)
	else
		return PLUGIN_CONTINUE
	
	return PLUGIN_HANDLED
}

public fw_TakeDamage(victim, inflictor, attacker, Float:damage) {
	if(is_valid_player(attacker) && get_user_weapon(attacker) == CSW_AK47 && g_HasAk[attacker])
		SetHamParamFloat(4, damage * get_pcvar_float(gold_damage))
}

public fw_CmdStart( id, uc_handle, seed ) {
	if(!is_user_alive(id))
		return PLUGIN_HANDLED
       
	if((get_uc(uc_handle, UC_Buttons) & IN_ATTACK2) && !( pev(id, pev_oldbuttons) & IN_ATTACK2)) {
		new szWeapID = get_user_weapon(id)

		if(szWeapID == CSW_AK47 && g_HasAk[id] == true && !g_hasZoom[id] == true) {
			g_hasZoom[id] = true
			cs_set_user_zoom(id, CS_SET_AUGSG552_ZOOM, 0)
			emit_sound(id, CHAN_ITEM, "weapons/zoom.wav", 0.20, 2.40, 0, 100)
		} else if(szWeapID == CSW_AK47 && g_HasAk[id] == true && g_hasZoom[id]) {
			g_hasZoom[id] = false
			cs_set_user_zoom(id, CS_RESET_ZOOM, 0)         
		}
	}
	return PLUGIN_HANDLED
}

stock drop_weapon(id, dropwhat) {
	static weapons[32], num, i, weaponid
	num = 0
	get_user_weapons(id, weapons, num)
	
	for (i = 0; i < num; i++) {
		weaponid = weapons[i]
		
		if ((dropwhat == 1 && ((1<<weaponid) & AK47_BIT_SUM))) {
			static wname[32]
			get_weaponname(weaponid, wname, charsmax(wname))
			engclient_cmd(id, "drop", wname)
		}
	}
}