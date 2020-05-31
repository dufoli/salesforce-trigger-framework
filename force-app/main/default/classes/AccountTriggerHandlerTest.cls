/*
* @description Account trigger handler example test
* @author: Olivier Dufour
* @date May 22, 2020
*/
@isTest
private class AccountTriggerHandler_TST {
    @isTest
    static void testInsert() {
        Account testAccount = new Account(
            Name = 'New Account'
        );
        Test.startTest();
        insert testAccount;
        Test.stopTest();
        System.assertNotEquals(null, testAccount.Id, 'Failed to insert testAccount');
    }
    @isTest
    static void testUpdate() {
        Account testAccount = new Account(
            Name = 'New Account'
        );
        Test.startTest();
        insert testAccount;
        testAccount.Name = 'updated account';
        update testAccount;
        Test.stopTest();
        Account acc = [SELECT id, name from Account where id :testAccount.id limit 1];
        System.assertEquals('updated account', acc.Name, 'Failed to update testAccount');
    }
    @isTest
    static void testDelete() {
        Account testAccount = new Account(
            Name = 'New Account'
        );
        Test.startTest();
        insert testAccount;
        delete testAccount;
        Test.stopTest();
        List<Account> accs = [SELECT id, name from Account where id :testAccount.id];
        System.assertEquals(0, accs.size(), 'Failed to delete testAccount');
    }
}