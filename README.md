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

TODO : 
* doc for IValidable to handle validation rules on trigger side.
* rename pipeline to objectWriter
* find a way to limit to one object writer by object (best is to use generics and SObjecType for that or a name function of APipelineItem)
* make an full example of dependant pipeline
* provide best practice to avoid static method in service class which is very ugly but used by most of Salesforce project.
