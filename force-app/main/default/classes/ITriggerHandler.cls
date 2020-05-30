/*
* @description This is the interface to implement on your handler
* @author: Olivier Dufour
* @date May 22, 2020
*/
public interface ITriggerHandler {
  Map<String, List<SObject>> LoadData ();

  Map<String, AObjectWriter> CreatePipelines (Map<String, List<SObject>> dico);

  void BeforeInsert(SObject[] newItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);

  void AfterUndelete(Map<Id, SObject> newItems, Map<String, List<SObject>> dico, Map<String, AObjectWriter> pipelines);
}