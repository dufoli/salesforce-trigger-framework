/*
* @description Task trigger handler example
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class TaskTriggerHandler implements ITriggerHandler {

    public static Boolean triggerDisabled = false;

    public Boolean isDisabled() { return triggerDisabled; }

    public TriggerContext LoadData () { return new TriggerContext();}

    public void BeforeInsert(List<SObject> newItems, TriggerContext ctx) {}

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, TriggerContext ctx) {}

    public void BeforeDelete(Map<Id, SObject> oldItems, TriggerContext ctx) {}

    public void AfterInsert(Map<Id, SObject> newItems, TriggerContext ctx) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, TriggerContext ctx) {}

    public void AfterDelete(Map<Id, SObject> oldItems, TriggerContext ctx) {}

    public void AfterUndelete(Map<Id, SObject> oldItems, TriggerContext ctx) {}

}