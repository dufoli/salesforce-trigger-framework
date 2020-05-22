# salesforce-trigger-framework

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