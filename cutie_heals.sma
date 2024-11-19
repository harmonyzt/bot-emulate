#include < amxmodx >
#include < amxmisc >
#include < fun >

public plugin_init() {
    register_plugin("Cutie Heals", "0.1", "harmony");
    register_event("DeathMsg", "DeathEventer", "a");
}

public DeathEventer() {
    new attacker = read_data(1);
    new iFlags = get_user_flags(attacker);
    
    if(iFlags & read_flags("tb")){
        new healAmount = get_user_health(attacker) + 25;
        set_user_health(attacker, healAmount)

        set_hudmessage(42, 255, 127, -1.0, 0.2, 2, 6.0, 3.0, 0.1, 0.1, -1)
        show_hudmessage(attacker, "+25 Health!")

    } else {
        new healAmount = get_user_health(attacker) + 10;
        set_user_health(attacker, healAmount)

        set_hudmessage(42, 255, 127, -1.0, 0.2, 2, 6.0, 3.0, 0.1, 0.1, -1)
        show_hudmessage(attacker, "+10 Health!")
    }
}