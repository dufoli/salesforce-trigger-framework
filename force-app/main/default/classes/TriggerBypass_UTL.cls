public class TriggerBypass_UTL {
    // for apex run to disable trigger
    public static boolean isBypassAll = false;
    // bypasse all trigger for a user
    private static boolean isUserBypassAll = false;
    // bypass particular trigger
    private static string isUserBypassSpecific = '';

    static {
        //TODO cache
        isUserBypassAll = ByPass__c.getIstance(UserInfo.getUserId());
        User usr = [SELECT byPassTriggers__c from User WHERE id = :UserInfo.getUserId() LIMIT 1];
        isUserBypassSpecific = usr.byPassTriggers__c;
    }
    public static boolean isTriggerDisabled(string trgName) {
        return (isBypassAll || isUserBypassAll.ByPassTRG__c || isUserBypassSpecific.contains(trgName));
    }
}