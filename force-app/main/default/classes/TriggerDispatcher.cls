/*
* @description This is the triggerDispatcher
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class TriggerDispatcher {

     public static void Run(ITriggerHandler handler) {
        Map<String, List<SObject>> dictionnary = new Map<String, List<SObject>> ();

        String trgName = String.valueOf(handler).split(':')[0];
        if(Bypass_UTL.isTriggerDisabled(trgName)) {
            return;
        }

        dictionnary = handler.LoadData ();
        Map<String, AObjectWriter> pipelines = handler.CreatePipelines(dictionnary);

        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                // TODO Salesforce runs user-defined validation rules if multiline items were created, such as quote line items and opportunity line items.
                handler.BeforeInsert(trigger.new, dictionnary, pipelines);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(trigger.newMap, trigger.oldMap, dictionnary, pipelines);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(trigger.oldMap, dictionnary, pipelines);
            }
            if (handler instanceof IValidable) {
                IValidable validable = (IValidable) handler;
                //TODO If the record was updated with workflow field updates, fires before update triggers and after update triggers one more time (and only one more time), in addition to standard validations. Custom validation rules are not run again.
                if (Bypass_UTL.isValidationRuleDisabled()) {
                    if (Trigger.IsInsert) {
                        validable.ValidateInsert(trigger.new);
                    }
                    if (Trigger.isUpdate) {
                        validable.ValidateUpdate(trigger.newMap, trigger.oldMap);
                    }
                }
            }
        }
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert) {
                handler.AfterInsert(Trigger.newMap, dictionnary, pipelines);
            }
            else if (Trigger.IsUpdate) {
                handler.AfterUpdate(trigger.newMap, trigger.oldMap, dictionnary, pipelines);
            }
            else if (trigger.IsDelete) {
                handler.AfterDelete(trigger.oldMap, dictionnary, pipelines);
            }
            else if (trigger.isUndelete) {
                handler.AfterUndelete(trigger.oldMap, dictionnary, pipelines);
            }
            SObjectType triggerType = trigger.isDelete ?  trigger.old.getSObjectType() : trigger.new.getSObjectType();
            List<SObject> objs = trigger.isDelete ?  trigger.old : trigger.new;
            RollupSummary_UTL.refreshRollupSummary (triggerType, objs);
        }
    }
}