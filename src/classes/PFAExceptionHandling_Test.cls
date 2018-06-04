@IsTest
public class PFAExceptionHandling_Test {
    @testSetup
    private static void setup() {
        Account testAccount = new Account(name='Test');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName='Moose'
                                          ,LastName='White'
                                          ,email='Moose@gr.org'
                                          ,AccountId=testAccount.id);
        insert testContact;
        
        Case testCase = new Case(status='New'
                                ,subject='Test'
                                ,ContactId=testContact.id
                                ,AccountId=testAccount.id);
        insert testCase;

    }
    public static testMethod void testNoParams() {
        Case myTestCase = [SELECT id, ContactId, AccountId FROM Case];

        Test.setCurrentPage(Page.PFAExceptionHandling);
        ApexPages.StandardController stdController=new ApexPages.StandardController(myTestCase);
        PFAExceptionHandling controller = new PFAExceptionHandling(stdController);
        
        System.AssertEquals(controller.caseId,null,'must be null');
        System.AssertEquals(controller.contactId,null,'must be null');
        System.AssertEquals(controller.ProcessSomething(),null,'page ref must be null');
        System.AssertEquals(ApexPages.getMessages().size(),1,'Must have 1 error message');
    }
    public static testMethod void testWithParams() {
        Case myTestCase = [SELECT id, ContactId, AccountId FROM Case];
        
        Test.setCurrentPage(Page.PFAExceptionHandling);
        ApexPages.currentPage().getParameters().put('id',myTestCase.id);
        ApexPages.currentPage().getParameters().put('contact',myTestCase.ContactId);
        ApexPages.currentPage().getParameters().put('account',myTestCase.AccountId);
        
        ApexPages.StandardController stdController=new ApexPages.StandardController(myTestCase);
        PFAExceptionHandling controller = new PFAExceptionHandling(stdController);
        
        System.AssertEquals(controller.caseId,myTestCase.id,'must not be null');
        System.AssertEquals(controller.contactId,myTestCase.ContactId,'must not be null');
        System.AssertEquals(controller.ProcessSomething(),null,'page ref must be null');
        System.AssertEquals(ApexPages.getMessages().size(),0,'Should be error free');
    }

}