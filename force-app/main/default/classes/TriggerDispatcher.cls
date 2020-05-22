public class TriggerDispatcher {

     public static void Run(ITriggerHandler handler) {

        List<SObject> triggerNew = trigger.new;
        Map<Id, SObject> triggerNewMap = trigger.newMap;

        if (handler instanceof IValidable) {
            IValidable validable = (IValidable) handler;
            ByPass__c bypassObj = ByPass__c.getInstance(UserInfo.getUserId());

            if (bypassObj == null || !bypassObj.ByPassVR__c) {
                if (Trigger.IsBefore) {
                    if (Trigger.IsInsert) {
                        triggerNew = validable.ValidateInsert(trigger.new);
                    }
                    if (Trigger.isUpdate) {
                        triggerNewMap = validable.ValidateUpdate(trigger.newMap, trigger.oldMap);
                    }
                }
            }
        }
        String trgName = String.valueOf(handler).split(':')[0];
        if(TriggerBypass_URL.isTriggerDisabled(trgName)) {
            return;
        }

        handler.LoadData ();
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                handler.BeforeInsert(triggerNew);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(triggerNewMap, trigger.oldMap);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(trigger.oldMap);
            }
        }
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert) {
                handler.AfterInsert(Trigger.newMap);
            }
            else if (Trigger.IsUpdate) {
                handler.AfterUpdate(trigger.newMap, trigger.oldMap);
            }
            else if (trigger.IsDelete) {
                handler.AfterDelete(trigger.oldMap);
            }
            else if (trigger.isUndelete) {
                handler.AfterUndelete(trigger.oldMap);
            }
        }
        handler.WriteData ();
    }
}