@isTest
public class RollupSummary_UTL_TST {
    @isTest
    public static void testRollup() {
        RollupSummary_UTL.registerRollupDefinition('Task', 'Id', 'WhatId', RollupSummary_UTL.aggregationCount, '', 'NumberOfEmployees', 'Account');
        Test.startTest();
        Account acc = new Account();
        acc.Name = 'test acc';
        insert acc;
        Task t = new task();
        t.WhatId = acc.id;
        insert t;
        Test.stopTest();
        Account acct = [SELECT NumberOfEmployees from Account WHERE Name='test acc' LIMIT 1];

        System.assertEquals(2, acct.NumberOfEmployees);
    }
}