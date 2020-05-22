public class AccountTriggerHandler implements ITriggerHandler {
    public Map<String, List<SObject>> LoadData () {
        // here we load all SOQL/ SOSL for service class
        // populate dictionnary
        return new Map<String, List<SObject>> ();
    }

    public void BeforeInsert(List<SObject> newItems, Map<String, List<SObject>> dictionnary) {
        List<SObject> objectsToInsert = new List<SObject> ();
        List<SObject> objectsToUpdate = new List<SObject> ();
        // call service class and try to avoid SOQL inside them and do it in loadData
        //Account_SVE.AnInsertHandler ((Account[])newItems, dictionnary);
        //Account_SVE.AnOtherInsertHandler ((Account[])newItems, dictionnary);
        //use objectsToInsert.addAll() or objectsToUpdate.addAll() of returned value of service class
        if (objectsToInsert.size() > 0) {
            insert objectsToInsert;
        }
        if (objectsToUpdate.size() > 0) {
            update objectsToUpdate;
        }
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {
        List<SObject> objectsToInsert = new List<SObject> ();
        List<SObject> objectsToUpdate = new List<SObject> ();
        // call service class and try to avoid SOQL inside them and do it in loadData
        // paid attention to write data in a single DML at the very end when possible
        //Account_SVE.AnUpdateHandler ((Account[])newItems, dictionnary);
        //Account_SVE.AnOtherOne ((Account[])newItems, dictionnary);
        if (objectsToInsert.size() > 0) {
            insert objectsToInsert;
        }
        if (objectsToUpdate.size() > 0) {
            update objectsToUpdate;
        }
    }

    public void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterUndelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

}