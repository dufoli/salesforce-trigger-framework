/*
* @description This is the triggerDispatcher
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class TriggerDispatcher {

     public static void Run(ITriggerHandler handler) {
        Map<String, List<SObject>> dictionnary = new Map<String, List<SObject>> ();

        String trgName = String.valueOf(handler).split(':')[0];
        if(handler.isDisabled() || Bypass_UTL.isTriggerDisabled(trgName)) {
            return;
        }

        dictionnary = handler.LoadData ();

        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                // TODO Salesforce runs user-defined validation rules if multiline items were created, such as quote line items and opportunity line items.
                handler.BeforeInsert(trigger.new, dictionnary);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(trigger.newMap, trigger.oldMap, dictionnary);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(trigger.oldMap, dictionnary);
            }
            if (handler instanceof IValidable) {
                IValidable validable = (IValidable) handler;
                //TODO If the record was updated with workflow field updates, fires before update triggers and after update triggers one more time (and only one more time), in addition to standard validations. Custom validation rules are not run again.
                if (validable.isValidationDisabled() || Bypass_UTL.isValidationRuleDisabled()) {
                    return;
                }
                if (Trigger.IsInsert) {
                    validable.ValidateInsert(trigger.new);
                }
                if (Trigger.isUpdate) {
                    validable.ValidateUpdate(trigger.newMap, trigger.oldMap);
                }
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
            SObjectType triggerType = trigger.isDelete ?  trigger.old.getSObjectType() : trigger.new.getSObjectType();
            List<SObject> objs = trigger.isDelete ?  trigger.old : trigger.new;
            RollupSummary_UTL.refreshRollupSummary (triggerType.getDescribe().getName(), objs);
        }
    }
}