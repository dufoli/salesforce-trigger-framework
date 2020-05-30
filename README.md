# salesforce-trigger-framework

* STATUS : WORK IN PROGRESS

<p>Here we have a framework which deal with performance issue we face in Salesforce and avoid worst antipattern:
<ol>
<li>SOQL in loop</li>
<li>SOQL on same object</li>
<li>multiple DML on same object</li>
<li>too many validation rules</li>
</ol>
</p>
<h1>How to implement this trigger framework in your org</h1>
<ol>
	<li>Copy the ITriggerHandler and TriggerDispatcher classes into your org.</li>
	<li>Create an <MyObject>TriggerHandler class which implements the ITriggerHandler interface.</li>
	<li>Implement methods of interface.</li>
	<li>Create a trigger for your object (all events). and call the static TriggerDispatcher.Run method with first parameter : a new TriggerHandler</li>
</ol>

To add trigger Validation rules implement Ivalidable on object TriggerHandle
example:
```
public class AccountTriggerHandler implements ITriggerHandler, IValidable {
    public void ValidateInsert (List<SObject> newItems) {
        // implement validation rules only for insert only (ISNEW() in formula)
    }
    public void ValidateUpdate (Map<Id, SObject> newItems, Map<Id, SObject> oldItems) {
        //implement validation rules for update only (ISCHANGED() in formula)
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
    ...
```
rem: you can implement common rules for update and insert in same function and call it from both ValidateInsert and ValidateUpdate

TODO :
[x] doc for IValidable to handle validation rules on trigger side.
[x] rename pipeline to AObjectWriter
[x] respect order of execution https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm for VR trigger
[ ] support undelete for IValidable
[ ] find a way to limit to one object writer by object (best is to use generics and SObjecType for that or a name function of APipelineItem)
[ ] make an full example of dependant pipeline
[ ] try to load all subclass dependant witch implement AObjectWriter
[ ] provide best practice to avoid static method in service class... Nobody heard of factory on salesforce obviously ;-)
[ ] TODO Salesforce runs user-defined validation rules if multiline items were created, such as quote line items and opportunity line items.
[ ] TODO If the record was updated with workflow field updates, fires before update triggers and after update triggers one more time (and only one more time), in addition to standard validations. Custom validation rules are not run again.

pipeline must been used a bit like gstreamer API...
A good example to dig in:
creation of case
- look for account with same email
- if found add accountid to case
- if not found create client and add accountid to case

pipeline
1 search for account ==> LoadData()
2 create missing account ==> AccountObjectWriter
3 produce a common list of accountid to map to case ==> current implement provide 2 lists in dictionnary. Is it an issue ?
4 set up accountid on case ==> a classic service function with dictionnary as param will set case.Accountid
5 write

data exchange on pipeline must be :
loaded data (dictionnary) from init
+ structured data from previous steps
I plan to reuse dictionnary to forward structured data

TO THINK:
Use ObjectWriter class on earch TriggerHandler will avoid spagetti code with because same object will use same subclass
but how to garanty that we do not write 2 ObjectWrite for same object ? That is the bug question.
Not so happy of CreatePipelines, is really needed ? we can just make a new instance when needed in afterUpdate afterInsert
Can we force that before is only to normalyze record and after must been used to write DML

