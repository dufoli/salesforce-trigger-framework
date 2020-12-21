/*
* @description This is the interface to implement on your handler
* @author: Olivier Dufour
* @date May 22, 2020
*/
public interface ITriggerHandler {
  TriggerContext LoadData ();

  Boolean isDisabled();

  void BeforeInsert(SObject[] newItems, TriggerContext ctx);

  void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, TriggerContext ctx);

  void BeforeDelete(Map<Id, SObject> oldItems, TriggerContext ctx);

  void AfterInsert(Map<Id, SObject> newItems, TriggerContext ctx);

  void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, TriggerContext ctx);

  void AfterDelete(Map<Id, SObject> oldItems, TriggerContext ctx);

  void AfterUndelete(Map<Id, SObject> newItems, TriggerContext ctx);
}