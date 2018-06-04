/**
 * @class PFAcademyOEVFController_Test
 * @classUnderTest PFAcademyOEVFController
 * @author Bobby White
 * @email bobby.white@salesforce.com
 * @date October 31,2016
 **/ 
@isTest
public class PFAcademyOEVFController_Test {

    public static testMethod void testNoArgs() {
        try {
            PageReference ref = Page.PFAcademyVFLifeCycle;
            Test.setCurrentPage(ref);
            
            PFAcademyOEVFController controller = new PFAcademyOEVFController();
            System.Assert(false,'Should not reach this line');
        } catch(System.QueryException qex) {
            System.Assert(true,'Expected error caught');
        }
    }
    
    public static testMethod void testWithArg() {
        
       Account testAcc = testSetup();
        
       PageReference ref = Page.PFAcademyVFLifeCycle;
       Test.setCurrentPage(ref);
       ApexPages.currentPage().getParameters().put('Acc',testAcc.AccountNumber);
       ApexPages.currentPage().getParameters().put('name','value');
      
       System.debug('After params - URL: '+ApexPages.currentPage().getUrl());
               
       // Must not create the controller until AFTER the URL parameters are set!
       PFAcademyOEVFController controller = new PFAcademyOEVFController();

        
       System.AssertEquals(controller.getAccount(),testAcc);
    }
    
    public static testMethod void testOperations() {
        
       Account testAcc = testSetup();
        
       PageReference ref = Page.PFAcademyVFLifeCycle;
       Test.setCurrentPage(ref);
       ApexPages.currentPage().getParameters().put('Acc',testAcc.AccountNumber);
       ApexPages.currentPage().getParameters().put('name','value');
      
       System.debug('After params - URL: '+ApexPages.currentPage().getUrl());
               
       // Must not create the controller until AFTER the URL parameters are set!
       PFAcademyOEVFController controller = new PFAcademyOEVFController();

        
       System.AssertEquals(controller.getAccount(),testAcc);
       Account modAcct = controller.getAccount();
       modAcct.Description='Modified by the test';
       PageReference ref2 = controller.save();
       System.AssertEquals(ref2,null,'');
        
       PageReference ref3 = controller.cancel();
       System.AssertEquals(ref3,null,'');

        
    }

    
    /**
     * Setup routine
     **/ 
    private static Account testSetup() {
        Account testAccount = new Account(name='Test',AccountNumber='1234');
        insert testAccount;
        
        return [SELECT Id,Name,AccountNumber,Website FROM Account LIMIT 1];
    }

}