@isTest
public class PFAcademyVFLifecycle_Test {
    public static testMethod void testBasic() {
        
        
       Account testAcc = testSetup();
        
       PageReference ref = Page.PFAcademyVFLifeCycle;
       Test.setCurrentPage(ref);
       ApexPages.currentPage().getParameters().put('Acc',testAcc.AccountNumber);
       ApexPages.currentPage().getParameters().put('name','value');
      
       System.debug('After params - URL: '+ApexPages.currentPage().getUrl());
               
       // Must not create the controller until AFTER the URL parameters are set!
       PFAcademyOEVFController base = new PFAcademyOEVFController();
       PFAcademyVFLifecycle controller = new PFAcademyVFLifecycle(base);
        
        System.Assert(controller.getGreeting().contains(testAcc.name));
        controller.resetEmp();
        Account verifyAcc = [SELECT id,name,AccountNumber,NumberOfEmployees FROM Account where Id = :testAcc.id];
        System.AssertEquals(verifyAcc.NumberOfEmployees,10,'Must have set Employees to 10');
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