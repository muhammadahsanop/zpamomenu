/* Zombie Plague Ammo Menu */

#include <amxmodx>
#include <zombieplague>

new const AMMO_MENU_TITLE[] = "Select Ammo Packs"; // Title of the ammo menu

public plugin_init()
{
    register_plugin("ZP: Ammo Menu", "1.0", "YourName");
    register_clcmd("ammomenu", "CmdAmmoMenu", ADMIN_RCON, "- ammomenu : Open Ammo Menu");
}

public CmdAmmoMenu(id, level)
{
    if (level < ADMIN_RCON)
    {
        return PLUGIN_HANDLED;
    }

    new menu = create_menu(AMMO_MENU_TITLE, "Menu_SelectAmmo");
    if (menu == MENU_INVALID)
    {
        client_print(id, print_console, "(!) Failed to create the ammo menu.");
        return PLUGIN_HANDLED;
    }

    for (new i = 1; i <= 10; i++)
    {
        new option[32];
        format(option, sizeof(option), "Give %d Ammo Packs", i);
        menu_additem(menu, option, i);
    }

    show_menu(id, menu);
    return PLUGIN_HANDLED;
}

public Menu_SelectAmmo(id, menu, item)
{
    new amount = item;
    if (amount <= 0)
        return PLUGIN_CONTINUE;

    new target = read_data_int(id, "user_target", 0);

    if (!is_user_alive(target))
    {
        client_print(id, print_chat, "(!) The target player is not alive.");
        return PLUGIN_HANDLED;
    }

    zp_set_user_ammo_packs(target, amount);
    client_print(id, print_chat, "You have given %s %d ammo packs.", get_user_name(target), amount);
    return PLUGIN_HANDLED;
}

public client_cmd(id, cmd[], const args[])
{
    new amount = str_to_num(args);

    if (equali(cmd, "/amx_selectap", true) && amount > 0)
    {
        write_data_int(id, "user_target", get_user_userid(id));
        CmdAmmoMenu(id, ADMIN_RCON);
    }
    return PLUGIN_HANDLED;
}
