/*
* @description Task trigger handler example
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class TaskTriggerHandler implements ITriggerHandler {

    public Map<String, List<SObject>> LoadData () { return new Map<String, List<SObject>> ();}

    public void BeforeInsert(List<SObject> newItems, Map<String, List<SObject>> dictionnary) {}

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterUndelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

}