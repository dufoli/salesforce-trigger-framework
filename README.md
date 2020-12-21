# salesforce-trigger-framework

**_STATUS : WORK IN PROGRESS_**

## GOAL

Avoid all anti pattern of salesforce:
- before insert/update must normalize data => NO DML
- after insert/update is to create linked data => DML
- only one SOQL by object to load data
- only one DML by object
- validation rule trigger system
- rollup summary trigger system


## SUMMARY

<p>Here we have a framework which deal with performance issue we face in Salesforce and avoid worst antipattern:
<ol>
<li>SOQL in loop</li>
<li>SOQL on same object</li>
<li>multiple DML on same object</li>
<li>too many validation rules</li>
</ol>
</p>

## HOW TO

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

## TODO
- [x] doc for IValidable to handle validation rules on trigger side.
- [x] rename pipeline to AObjectWriter
- [x] respect order of execution https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_order_of_execution.htm for VR trigger
- [x] Rollup summary framework
- [x] Rollup summary test class
- [x] trigger framework test class
- [x] rollup: avoid soql on parent just new Parent with id and agg field then update
- [x] rollup: count disctinct
- [x] Validation: support programatic bypass like trigger part
- [ ] rollup: calculate multiple agregate at the same time (multiple alias mapping)
- [ ] rollup: use String.format() with pattern {0} to set value
- [ ] rollup: try to find object from dico first if found
- [ ] rollup: user type instead of string (apexType.newSobject(parentId), apexType.getName()) but stuck with future method
- [ ] rollup: think if switch future method to queueable ? work with complexe type so we can work with type instead of string
- [ ] rollup: write rollup at same time than objectWriter when possible
- [x] trigger: util isChanged to compare old and new value
- [x] trigger: switch dico + new/old to context and add few things (like state Map to pass data between function)
- [ ] trigger: bloc double run
- [ ] trigger: add a write all objectwriter not written at the end (so store if write or not) with a boolean
- [ ] trigger: store all objectWriter in context => by SObjectType
- [ ] Validation: support undelete for IValidable, is it really needed ?
- [ ] provide best practice to avoid static method in service class... factory is the best
- [ ] TODO Salesforce runs user-defined validation rules if multiline items were created, such as quote line items and opportunity line items.
- [ ] TODO If the record was updated with workflow field updates, fires before update triggers and after update triggers one more time (and only one more time), in addition to standard validations. Custom validation rules are not run again.
<br>
<br>
A good example to dig in:<br>
creation of case<br>

- look for account with same email
- if found add accountid to case
- if not found create client and add accountid to case

<br>

pipeline

* search for account ==> LoadData()
* create missing account ==> AccountObjectWriter
* produce a common list of accountid to map to case ==> current implement provide 2 lists in dictionnary. Is it an issue ?
* set up accountid on case ==> a classic service function with dictionnary as param will set case.Accountid
* write
<br>
data exchange on pipeline must be :
loaded data (dictionnary) from init
+ structured data from previous steps
I plan to reuse dictionnary to forward structured data
<br>

## TO THINK

- [ ] Use ObjectWriter class on earch TriggerHandler will avoid spagetti code with because same object will use same subclass but how to garanty that we do not write 2 ObjectWriter for same object ? by naming convention, I think it is better that splitting all in subfunction and it regroup by object all action
- [ ] Can we force that before is only to normalyze record and after must been used to write DML
<br>
