/*
* @description This is the interface to implement on your handler
* @author: Olivier Dufour
* @date May 22, 2020
*/
public interface ITriggerHandler {
  public Map<String, List<SObject>> LoadData ();

  void BeforeInsert(SObject[] newItems, Map<String, List<SObject>> dico);

  void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dico);

  void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dico);

  void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dico);

  void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dico);

  void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dico);

  void AfterUndelete(Map<Id, SObject> newItems, Map<String, List<SObject>> dico);
}