/*
* @description This is the bypass system to bypass validation rules or trigger
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class Bypass_UTL {
    // for apex run to disable trigger
    public static boolean isBypassAllTrigger = false;
    // bypasse all trigger for a user
    private static boolean isUserBypassAllTrigger = false;
    // bypasse all trigger for a user
    private static boolean isUserBypassAllVR = false;
    // bypass particular trigger
    private static string isUserBypassSpecificTrigger = '';

    static {
        //TODO cache
        ByPass__c bypass = ByPass__c.getIstance(UserInfo.getUserId());
        isUserBypassAllTrigger = byPass.ByPassTR__c;
        isUserBypassAllVR = byPass.ByPassVR__c;
        User usr = [SELECT byPassTriggers__c from User WHERE id = :UserInfo.getUserId() LIMIT 1];
        isUserBypassSpecificTrigger = usr.byPassTriggers__c;
    }
    public static boolean isTriggerDisabled(string trgName) {
        return (isBypassAllTrigger || isUserBypassAllTrigger || isUserBypassSpecificTrigger.contains(trgName));
    }
    public static boolean isValidationRuleDisabled(string trgName) {
        return (isUserBypassAllVR);
    }
}