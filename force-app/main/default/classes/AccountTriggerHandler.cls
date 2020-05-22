public class AccountTriggerHandler implements ITriggerHandler {
    Map<String, List<SObject>> dictionnary = new Map<String, List<SObject>> ();
    List<SObject> objectsToInsert = new List<SObject> ();
    List<SObject> objectsToUpdate = new List<SObject> ();
    public void LoadData () {
        // here we load all SOQL/ SOSL for service class
        // populate dictionnary
    }

    public void WriteData () {
        if (objectsToInsert.size() > 0) {
            insert objectsToInsert;
        }
        if (objectsToUpdate.size() > 0) {
            update objectsToUpdate;
        }
    }

    public void BeforeInsert(List<SObject> newItems) {
        // call service class and no SOQL/DML inside them
        //Account_SVE.AnInsertHandler ((Account[])newItems, dictionnary);
        //Account_SVE.AnOtherInsertHandler ((Account[])newItems, dictionnary);
        //use objectsToInsert.addAll() or objectsToUpdate.addAll() of returned value of service class
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // call service class and no SOQL/DML inside them
        //Account_SVE.AnUpdateHandler ((Account[])newItems, dictionnary);
        //Account_SVE.AnOtherOne ((Account[])newItems, dictionnary);
    }

    public void BeforeDelete(Map<Id, SObject> oldItems) {}

    public void AfterInsert(Map<Id, SObject> newItems) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {}

    public void AfterDelete(Map<Id, SObject> oldItems) {}

    public void AfterUndelete(Map<Id, SObject> oldItems) {}

}