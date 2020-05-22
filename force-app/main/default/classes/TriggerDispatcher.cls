/*
* @description This is the triggerDispatcher
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class TriggerDispatcher {

     public static void Run(ITriggerHandler handler) {
        Map<String, List<SObject>> dictionnary = new Map<String, List<SObject>> ();

        List<SObject> triggerNew = trigger.new;
        Map<Id, SObject> triggerNewMap = trigger.newMap;

        if (handler instanceof IValidable) {
            IValidable validable = (IValidable) handler;

            if (TriggerBypass_URL.isValidationRuleDisabled()) {
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

        dictionnary = handler.LoadData ();
        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                handler.BeforeInsert(triggerNew, dictionnary);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(triggerNewMap, trigger.oldMap, dictionnary);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(trigger.oldMap, dictionnary);
            }
        }
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert) {
                handler.AfterInsert(Trigger.newMap, dictionnary);
            }
            else if (Trigger.IsUpdate) {
                handler.AfterUpdate(trigger.newMap, trigger.oldMap, dictionnary);
            }
            else if (trigger.IsDelete) {
                handler.AfterDelete(trigger.oldMap, dictionnary);
            }
            else if (trigger.isUndelete) {
                handler.AfterUndelete(trigger.oldMap, dictionnary);
            }
        }
    }
}