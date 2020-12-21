/*
* @description This is the interface to implement on your handler with validation rules
* @author: Olivier Dufour
* @date May 22, 2020
*/
public abstract class IValidableTriggerHandler extends ITriggerHandler {

    public static Boolean validationDisabled = false;

    public Boolean isValidationDisabled() {
        return validationDisabled;
    }
    void ValidateInsert (List<SObject> newItems);
    void ValidateUpdate (Map<Id, SObject> newItems, Map<Id, SObject> oldItems);
}