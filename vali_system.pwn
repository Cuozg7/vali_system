#define FILTERSCRIPT
#define MAX_VALI 100

#include <a_samp>
#include <zcmd>

#define DIALOG_MAIN_VALI 103
#define DIALOG_STATS 104
#define DIALOG_INV 106
#define DIALOG_PUTVALI 107
#define DIALOG_TAKEVALI 108
#define DIALOG_VALI_PASS 109
#define DIALOG_PASSWORDVALI 110

enum vali_stats {
	vali_id,
	vali_ispass,
	vali_object,
	Text3D:vali_text,
	vali_item[4],
	vali_slot[4],
	Float:vali_postion[3],
	vali_money
}
new vali_in[MAX_VALI][vali_stats];
new vali_db[MAX_PLAYERS];

public OnFilterScriptInit() {
	print("Vali system 0.0.1 - 'Cuozg'");
}

IsNumeric(string[])
{
    for(new i = 0, j = strlen(string); i < j; i++) {
        if(string[i] > '9' || string[i] < '0') return 0;
    }
    return 1;
}

CMD:muavali(playerid, params[]) {
	new vali_is_id;
    if(vali_db[playerid] != 0) return SendClientMessage(playerid, -1, "[VALI-SYSTEM] You have a suitcase so you can't buy more.");
    if(GetPlayerMoney(playerid) < 0) return SendClientMessage(playerid, -1, "[VALI-SYSTEM] You cannot afford a suitcase");
    for(new i = 1 ; i < MAX_VALI ; i++ ) {
    	if(vali_in[i][vali_id] == 0) {
    	    vali_is_id = i;
    	    break;
    	}
    }
    printf("vali id: %d", vali_is_id);
    vali_in[vali_is_id][vali_id] = vali_is_id;
    vali_in[vali_is_id][vali_money] = 0;
    vali_db[playerid] = vali_is_id;
    SendClientMessage(playerid, -1, "[VALI-SYSTEM] You bought a suitcase.");
    SetPlayerAttachedObject(playerid,1, 1210,6,0.254999,0.084999,0.034999,0.000000,-103.000000,0.000000,1.000000,1.000000,1.000000);
    return 1;
}
CMD:dropvali(playerid, params[])
{
	if(vali_db[playerid] == 0) return SendClientMessage(playerid, -1, "[VALI-SYSTEM] You don't have a suitcase.");
	new Float:postion[3];
	GetPlayerPos(playerid, postion[0], postion[1], postion[2]);
	vali_in[vali_db[playerid]][vali_object] = CreateObject(1210, postion[0], postion[1], postion[2]-0.7, 0,0,0, 10);
	vali_in[vali_db[playerid]][vali_postion][0] = postion[0];
	vali_in[vali_db[playerid]][vali_postion][1] = postion[1];
	vali_in[vali_db[playerid]][vali_postion][2] = postion[2];
	vali_in[vali_db[playerid]][vali_text] = Create3DTextLabel("Vali\nUse: /pickupvali to pickup.", -1, postion[0], postion[1], postion[2]-1, 10, GetPlayerVirtualWorld(playerid),0);
    RemovePlayerAttachedObject(playerid, 1);
    SendClientMessage(playerid, -1, "[VALI-SYSTEM] You have drop suitcase success.");
    vali_db[playerid] = 0;
    return 1;
}
CMD:pickupvali(playerid, params[]) {
	new vali_is_id;
    for(new i = 1 ; i < MAX_VALI ; i++ ) {
        if(vali_in[i][vali_id] != 0) {
        	if(IsPlayerInRangeOfPoint(playerid, 5, vali_in[i][vali_postion][0], vali_in[i][vali_postion][1],vali_in[i][vali_postion][2])) {
                print("alo alo");
                vali_is_id = i;
                break;
        	}
        }
    }
    if(vali_is_id == 0) return 1;
    DestroyObject(vali_in[vali_is_id][vali_object]);
    Delete3DTextLabel(vali_in[vali_is_id][vali_text]);
    SetPlayerAttachedObject(playerid,1, 1210,6,0.254999,0.084999,0.034999,0.000000,-103.000000,0.000000,1.000000,1.000000,1.000000);
    vali_db[playerid] = vali_is_id;
    printf("pickup: %d", vali_is_id);
    vali_in[vali_db[playerid]][vali_postion][0] = -1;
    vali_in[vali_db[playerid]][vali_postion][1] = -1;
    vali_in[vali_db[playerid]][vali_postion][2] = -1;
    return 1;
}
CMD:vali(playerid, params[]) {
	if(vali_db[playerid] == 0) return SendClientMessage(playerid, -1, "[VALI-SYSTEM] You do not have a suitcase in your hand.");
	if(vali_in[vali_db[playerid]][vali_ispass] > 1000) return ShowPlayerDialog(playerid, DIALOG_VALI_PASS, DIALOG_STYLE_INPUT, "VALI PASSWORD", "Please enter the suitcase password to continue", "Enter", "Cancel");
	ShowPlayerDialog(playerid, DIALOG_MAIN_VALI, DIALOG_STYLE_LIST, "Vali System", "Money Stats\nWeapon\nDrop vali\nPut money\nTake money\nDelete Vali\nSetup password", "Enter", "Exit");
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	if(dialogid == DIALOG_STATS) {
		if(!response) ShowPlayerDialog(playerid, DIALOG_MAIN_VALI, DIALOG_STYLE_LIST, "Vali System", "Money Stats\nWeapon\nDrop vali\nPut money\nTake money\nDelete Vali\nSetup password", "Enter", "Exit");
	}
	if(dialogid == DIALOG_INV) {
		if(response) {
			if(listitem == 0) {
 		        if(vali_in[vali_db[playerid]][vali_slot][0] == 0) return SendClientMessage(playerid, -1, "[VALI-WEAPON] This slot is empty and cannot be used.");
 		        GivePlayerWeapon(playerid, vali_in[vali_db[playerid]][vali_item][0], 60000);
 		        vali_in[vali_db[playerid]][vali_slot][0] = 0;
 		        vali_in[vali_db[playerid]][vali_item][0] = 0;
			}
			if(listitem == 1) {
 		        if(vali_in[vali_db[playerid]][vali_slot][1] == 0) return SendClientMessage(playerid, -1, "[VALI-WEAPON] This slot is empty and cannot be used.");
 		        GivePlayerWeapon(playerid, vali_in[vali_db[playerid]][vali_item][1], 60000);
 		        vali_in[vali_db[playerid]][vali_slot][1] = 0;
 		        vali_in[vali_db[playerid]][vali_item][1] = 0;
			}
			if(listitem == 2) {
 		        if(vali_in[vali_db[playerid]][vali_slot][2] == 0) return SendClientMessage(playerid, -1, "[VALI-WEAPON] This slot is empty and cannot be used.");
 		        GivePlayerWeapon(playerid, vali_in[vali_db[playerid]][vali_item][2], 60000);
 		        vali_in[vali_db[playerid]][vali_slot][2] = 0;
 		        vali_in[vali_db[playerid]][vali_item][2] = 0;
			}
			if(listitem == 3) {
 		        if(vali_in[vali_db[playerid]][vali_slot][3] == 0) return SendClientMessage(playerid, -1, "[VALI-WEAPON] This slot is empty and cannot be used.");
 		        GivePlayerWeapon(playerid, vali_in[vali_db[playerid]][vali_item][3], 60000);
 		        vali_in[vali_db[playerid]][vali_slot][3] = 0;
 		        vali_in[vali_db[playerid]][vali_item][3] = 0;
			}
		}
		else if(!response) {
			if(listitem == 0) {
				if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "You do not have a weapon in your hand.");
				if(vali_in[vali_db[playerid]][vali_slot][0] != 0) return SendClientMessage(playerid, -1, "This slot has weapons.");
			    vali_in[vali_db[playerid]][vali_item][0] = GetPlayerWeapon(playerid);
			    vali_in[vali_db[playerid]][vali_slot][0] = 1;
			    ResetPlayerWeapons(playerid);
			}
			if(listitem == 1) {
				if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "You do not have a weapon in your hand.");
				if(vali_in[vali_db[playerid]][vali_slot][1] != 0) return SendClientMessage(playerid, -1, "This slot has weapons.");
			    vali_in[vali_db[playerid]][vali_item][1] = GetPlayerWeapon(playerid);
			    vali_in[vali_db[playerid]][vali_slot][1] = 1;
			    ResetPlayerWeapons(playerid);
			}
			if(listitem == 2) {
				if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "You do not have a weapon in your hand.");
				if(vali_in[vali_db[playerid]][vali_slot][2] != 0) return SendClientMessage(playerid, -1, "This slot has weapons.");
			    vali_in[vali_db[playerid]][vali_item][2] = GetPlayerWeapon(playerid);
			    vali_in[vali_db[playerid]][vali_slot][2] = 1;
			    ResetPlayerWeapons(playerid);
			}
			if(listitem == 3) {
				if(GetPlayerWeapon(playerid) == 0) return SendClientMessage(playerid, -1, "You do not have a weapon in your hand.");
				if(vali_in[vali_db[playerid]][vali_slot][3] != 0) return SendClientMessage(playerid, -1, "This slot has weapons.");
			    vali_in[vali_db[playerid]][vali_item][3] = GetPlayerWeapon(playerid);
			    vali_in[vali_db[playerid]][vali_slot][3] = 1;
			    ResetPlayerWeapons(playerid);
			}
		}
	}
	if(dialogid == DIALOG_VALI_PASS) {
		if(response) {
			if(!IsNumeric(inputtext)) return SendClientMessage(playerid, -1, "An error has occurred, please try again...");
			if(strval(inputtext) != vali_in[vali_db[playerid]][vali_ispass]) return	SendClientMessage(playerid, -1, "mat ma khong hop le");
		    ShowPlayerDialog(playerid, DIALOG_MAIN_VALI, DIALOG_STYLE_LIST, "Vali System", "Money Stats\nWeapon\nDrop vali\nPut money\nTake money\nDelete Vali\nSetup password", "Enter", "Exit");
		}
	}
	if(dialogid == DIALOG_TAKEVALI) {
		if(response) {
			//if(strval(inputtext)) return ShowPlayerDialog(playerid, DIALOG_PUTVALI, DIALOG_STYLE_INPUT, "Vali system", "Hay nhap so tien ban can bo vao vali", "Accept", "Cancel");
            if(!IsNumeric(inputtext)) return SendClientMessage(playerid, -1, "An error has occurred, please try again...");
		    new money = strval(inputtext);
		    if(vali_in[vali_db[playerid]][vali_money] < money) return SendClientMessage(playerid, -1, "Vali does not have money.");
		    GivePlayerMoney(playerid, money);
		    vali_in[vali_db[playerid]][vali_money] -= money;
		    new str[129];
		    format(str, sizeof str, "[VALI-PUT MONEY] you took $%d from the suitcase ((VALI ID: %d)).",  money , vali_db[playerid]);
		    SendClientMessage(playerid, 0x00FF00FF, str);
		}
	}
	if(dialogid == DIALOG_PASSWORDVALI) {
		if(!IsNumeric(inputtext)) return SendClientMessage(playerid, -1, "An error has occurred, please try again...");
		new pass = strval(inputtext);
		if(pass < 10000) return SendClientMessage(playerid, -1, "Ghosts fade over 5 years");
		vali_in[vali_db[playerid]][vali_ispass] = pass;
		SendClientMessage(playerid, -1, "You have setup password vali");
	}
	if(dialogid == DIALOG_PUTVALI) {
		if(response) {
			//if(strval(inputtext)) return ShowPlayerDialog(playerid, DIALOG_PUTVALI, DIALOG_STYLE_INPUT, "Vali system", "Hay nhap so tien ban can bo vao vali", "Accept", "Cancel");
            if(!IsNumeric(inputtext)) return SendClientMessage(playerid, -1, "An error has occurred, please try again...");
		    new money = strval(inputtext);
		    if(GetPlayerMoney(playerid) < money) return SendClientMessage(playerid, -1, "You don't have money.");
		    GivePlayerMoney(playerid, -money);
		    vali_in[vali_db[playerid]][vali_money] += money;
		    new str[129];
		    format(str, sizeof str, "[VALI-PUT MONEY] You put %d dollars on that suitcase ((VALI ID: %d)).",  money , vali_db[playerid]);
		    SendClientMessage(playerid, 0x00FF00FF, str);
		}
	}
	if(dialogid == DIALOG_MAIN_VALI) {
		if(response) {
		    if(listitem == 0) {
			    new string[129];
			    format(string, sizeof string, "The amount of money in the suitcase is: %d", vali_in[vali_db[playerid]][vali_money]);
			    ShowPlayerDialog(playerid, DIALOG_STATS, DIALOG_STYLE_MSGBOX, "Information Suitcase", string, "Exit", "Back");
		    }
		    if(listitem == 1) {
			    new slot[129];
				for(new i = 0; i < 4 ; i++) {
				    if(vali_in[vali_db[playerid]][vali_slot][i] != 0)
				    {
				    	new weaponname[32];
				    	GetWeaponName(vali_in[vali_db[playerid]][vali_item][i], weaponname, 32);
				     	format(slot, sizeof(slot), "%s\n%s[%d]", slot,weaponname,vali_in[vali_db[playerid]][vali_item][i]);
				    }
				    else strcat(slot, "\nEmpty");
				}
				ShowPlayerDialog(playerid, DIALOG_INV, DIALOG_STYLE_LIST, "WEAPONS", slot, "USE", "PUT");
		    }
		    if(listitem == 2) {
		    	cmd_dropvali(playerid, "");
		    }
		    if(listitem == 3) {
		    	ShowPlayerDialog(playerid, DIALOG_PUTVALI, DIALOG_STYLE_INPUT, "Vali system", "Please enter the amount you need to put in the suitcase", "Accept", "Cancel");
		    }
		    if(listitem == 4) {
		    	ShowPlayerDialog(playerid, DIALOG_TAKEVALI, DIALOG_STYLE_INPUT, "Vali system", "Please enter the amount you want to get from the suitcase", "Accept", "Cancel");
		    }
		    if(listitem == 5) {
                for(new i =0 ; i < 4;i++) {
                	vali_in[vali_db[playerid]][vali_slot][i] = 0;
                	vali_in[vali_db[playerid]][vali_item][i] = 0;
                	vali_in[vali_db[playerid]][vali_money] = 0;
                	vali_in[vali_db[playerid]][vali_id] = 0;
                	RemovePlayerAttachedObject(playerid, 1);
                }
                vali_db[playerid] = 0;
                SendClientMessage(playerid, -1, "[VALI-DELETE] You have delete vali success.");
		    }
		    if(listitem == 6) {
		    	if(vali_in[vali_db[playerid]][vali_ispass] >= 10000) return SendClientMessage(playerid, -1, "The suitcase was present.");
 		    	ShowPlayerDialog(playerid, DIALOG_PASSWORDVALI, DIALOG_STYLE_INPUT, "Vali system", "please enter the password you want to set for the VALI", "Accept", "Cancel");
		    }
		}
	}
	return 1;
}

CMD:testwp(playerid, params[]) return GivePlayerWeapon(playerid, 22, 1);
CMD:testmoney(playerid, params[]) return GivePlayerMoney(playerid, 5000);
