public class AccountTriggerHandler implements ITriggerHandler, IValidable {
    public Map<String, AObjectWriter> CreatePipelines(Map<String, List<SObject>> dico) {
        Map<String, AObjectWriter> pipelines = new Map<String, AObjectWriter> ();
        pipelines.put('Task', new TaskMgr(dico));
        return pipelines;
    }
    //todo check if we can use generic
    public class TaskMgr extends AObjectWriter {
        TaskMgr(Map<String, List<SObject>> dico) {
            super(dico);
        }
        TaskMgr createTask() {
            toInsert.add(new Task());
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

    public void BeforeInsert(List<SObject> newItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {
        // call service class and try to avoid SOQL inside them and do it in loadData
        //AnInsertHandler ((Account[])newItems, dictionnary);
        //AnOtherInsertHandler ((Account[])newItems, dictionnary);
        ((TaskMgr)pipelines.get('Task')).createTask().setDefaultSubject().Write();
    }

    public void BeforeUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {
        List<SObject> objectsToInsert = new List<SObject> ();
        List<SObject> objectsToUpdate = new List<SObject> ();
        // call service class and try to avoid SOQL inside them and do it in loadData
        // paid attention to write data in a single DML at the very end when possible
        //AnUpdateHandler ((Account[])newItems, dictionnary);
        //AnOtherOne ((Account[])newItems, dictionnary);
        if (objectsToInsert.size() > 0) {
            insert objectsToInsert;
        }
        if (objectsToUpdate.size() > 0) {
            update objectsToUpdate;
        }
    }

    public void BeforeDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {}

    public void AfterInsert(Map<Id, SObject> newItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {}

    public void AfterUpdate(Map<Id, SObject> newItems, Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {}

    public void AfterDelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {}

    public void AfterUndelete(Map<Id, SObject> oldItems, Map<String, List<SObject>> dictionnary, Map<String, APipelineItem> pipelines) {}

}