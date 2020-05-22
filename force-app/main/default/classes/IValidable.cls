/*
* @description This is the interface to implement on your handler with validation rules
* @author: Olivier Dufour
* @date May 22, 2020
*/
public interface IValidable {
    List<SObject> ValidateInsert (List<SObject> newItems);
    Map<Id, SObject> ValidateUpdate (Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
}