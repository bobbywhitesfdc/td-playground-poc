/**
Unit test for PFAcademyIncorrectTrigger
**/
@isTest
public class PFAcademyIncorrectTrigger_Test {

    public static testMethod void positiveTest() {
        // Create an Account with Annual Revenue (1 < x > 334)
        // Create a Contact for that Account
        List<Account> testAccts = createAccounts();
        insert testAccts;
        
        List<Contact> testContacts = createContacts(testAccts);
        insert testContacts;
        
        List<Account> existingZeroRev = [SELECT Id,Name,AnnualRevenue From Account Where AnnualRevenue=0];
        List<Account> toUpdate = new List<Account>();
        for (Account current : existingZeroRev) {
            current.annualRevenue=200;
            toUpdate.add(current);
        }
        if (!toUpdate.isEmpty()) {
            System.debug('' + toUpdate.size() + ' accounts updated');
            update toUpdate;
        }
        
        Test.startTest();
        
        // Verify that the Description has been Set as Expected
        List<Contact> verifyContacts = [Select Id,Name,Email,Description, Salutation 
                                         From Contact 
                                        Where account.annualrevenue < 334
                                          and account.annualRevenue > 1 ];
        
        System.assert(verifyContacts.size() > 0,'Must have atleast 1 test Contact');
        
        System.assertNotequals(verifyContacts[0].description,'Default Description','Expected Description to be updated');
        
        Test.stopTest();
        
    }
    
    /**
       Create Test Accounts, but don't persist them
    **/
    private static List<Account> createAccounts() {
        List<Account> testAccts = new List<Account>();
        // Force zero revenue to start
        Account test = new Account(name='Test',AnnualRevenue=0);
        testAccts.add(test);
        
        return testAccts;
    }
    
    /**
       Create Test Contacts
    **/
    private static List<Contact> createContacts(List<Account> parentAccts) {
        List<Contact> testContacts = new List<Contact>();
        
        for (Account parent : parentAccts) {
            Contact current = new Contact();
            current.accountId = parent.id;
            current.firstName = 'Test';
            current.lastName= 'User';
            current.email = 'test@example.com';
            current.salutation = 'Esquire';
            current.description = 'Default Description';
            testContacts.add(current);
        }
        return testContacts;
    }
    
}