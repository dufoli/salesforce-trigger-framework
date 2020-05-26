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

            if (Bypass_UTL.isValidationRuleDisabled()) {
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
        if(Bypass_UTL.isTriggerDisabled(trgName)) {
            return;
        }

        dictionnary = handler.LoadData ();
        Map<String, APipelineItem> pipelines = handler.CreatePipelines(dictionnary);

        if (Trigger.IsBefore) {
            if (Trigger.IsInsert) {
                handler.BeforeInsert(triggerNew, dictionnary, pipelines);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(triggerNewMap, trigger.oldMap, dictionnary, pipelines);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(trigger.oldMap, dictionnary, pipelines);
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
        }
    }
}