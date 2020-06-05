/*
* @description Account trigger handler example
* @author: Olivier Dufour
* @date May 22, 2020
*/
public class AccountTriggerHandler implements ITriggerHandler, IValidable {
    //todo check if we can use generic
    public class TaskMgr extends AObjectWriter {
        TaskMgr(Map<Id, SObject> newItems, Map<String, List<SObject>> dico) {
            super(dico);
            for (Sobject o : newItems.values()) {
                Account acc = (Account)o;
                Task t = new Task();
                t.OwnerId = acc.OwnerId;
                t.WhatId = acc.Id;
                toInsert.add(t);
            }
            for (Sobject t : dico.get('Task')) {
                toUpdate.add(t);
            }
        }
        TaskMgr setDefautPriority() {
            for (SObject t : getAll()) {
                ((Task)t).priority = 'Low';
            }
            return this;
        }
        TaskMgr setDefaultSubject() {
            for (SObject t : toInsert) {
                ((Task)t).subject = 'email';
            }
            return this;
        }
    }
    public void ValidateInsert (List<SObject> newItems) {
        //TODO implement an example
    }
    public void ValidateUpdate (Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        // LOAD HERE ALL Data  needed for validation of records bulkified way
        for (SObject obj : newItems.values()) {
            Account acc = (Account) obj;
            Account old = (Account) oldItems.get(acc.Id);
            //block name modification of client
            // use acc.Name.addError to link error to field Name
            // use acc.addError to add error on UI header linked to record
            if (acc.Name != old.Name) {
                acc.Name.addError('Name can not been changed');
            }
        }
    }

    public Map<String, List<SObject>> LoadData () {
        // here we load all SOQL/ SOSL for service class
        // populate dictionnary
        Map<String, List<SObject>> dico = new Map<String, List<SObject>>();
        //example of user dico
        // you can user trigger.IsUpdate and trigger.IsInsert to have different list depending of insert or update
        dico.put(User.sObjectType.getDescribe().getName(), [Select Id from User LIMIT 1]);
        return dico;
    }

    public void BeforeInsert(List<SObject> newItems, Map<String, List<SObject>> dictionnary) {

    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {

    }

    public void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dictionnary) {
        // call service class and try to avoid SOQL inside them and do it in loadData
        //AnInsertHandler ((Account[])newItems, dictionnary);
        //AnOtherInsertHandler ((Account[])newItems, dictionnary);
        (new TaskMgr(newItems, dictionnary)).setDefautPriority().setDefaultSubject().Write();
    }

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

    public void AfterUndelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary) {}

}