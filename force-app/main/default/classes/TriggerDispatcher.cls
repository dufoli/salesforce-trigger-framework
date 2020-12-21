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
                handler.BeforeInsert(Trigger.new, dictionnary);
            }
            else if (Trigger.IsUpdate) {
                handler.BeforeUpdate(Trigger.newMap, Trigger.oldMap, dictionnary);
            }
            else if (Trigger.IsDelete) {
                handler.BeforeDelete(Trigger.oldMap, dictionnary);
            }
            if (handler instanceof IValidable) {
                IValidable validable = (IValidable) handler;
                //TODO If the record was updated with workflow field updates, fires before update triggers and after update triggers one more time (and only one more time), in addition to standard validations. Custom validation rules are not run again.
                if (validable.isValidationDisabled() || Bypass_UTL.isValidationRuleDisabled()) {
                    return;
                }
                if (Trigger.IsInsert) {
                    validable.ValidateInsert(Trigger.new);
                }
                if (Trigger.isUpdate) {
                    validable.ValidateUpdate(Trigger.newMap, Trigger.oldMap);
                }
            }
        }
        if (Trigger.IsAfter) {
            if (Trigger.IsInsert) {
                handler.AfterInsert(Trigger.newMap, dictionnary);
            }
            else if (Trigger.IsUpdate) {
                handler.AfterUpdate(Trigger.newMap, Trigger.oldMap, dictionnary);
            }
            else if (Trigger.IsDelete) {
                handler.AfterDelete(Trigger.oldMap, dictionnary);
            }
            else if (Trigger.isUndelete) {
                handler.AfterUndelete(Trigger.oldMap, dictionnary);
            }
            SObjectType triggerType = Trigger.isDelete ?  Trigger.old.getSObjectType() : Trigger.new.getSObjectType();
            List<SObject> objs = Trigger.isDelete ?  Trigger.old : Trigger.new;
            RollupSummary_UTL.refreshRollupSummary (triggerType.getDescribe().getName(), objs);
        }
    }
    public static List<SObject> getChangedFieldList (string fieldName) {
        List<SObject> filtered = new List<SObject> ();
         for (Integer i = 0; i < Trigger.old.size(); i++) {
            SObject old = Trigger.old[i];
            SObject nw = Trigger.new[i];
            if (old.get(fieldName) != nw.get(fieldName)) {
                filtered.add(nw);
            }
        }
        return filtered;
    }
    public static Map<Id, SObject> getChangedFieldMap (string fieldName) {
        Map<Id, SObject> filtered = new Map<Id, SObject> ();
         for (Integer i = 0; i < Trigger.old.size(); i++) {
            SObject old = Trigger.old[i];
            SObject nw = Trigger.new[i];
            if (old.get(fieldName) != nw.get(fieldName)) {
                filtered.put(nw.Id, nw);
            }
        }
        return filtered;
    }
}