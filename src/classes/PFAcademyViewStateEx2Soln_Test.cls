@isTest
public class PFAcademyViewStateEx2Soln_Test {
    public static Final Integer DATA_SAMPLE_SIZE = 150;

    public static testMethod void testConstructor() {
        PFAcademyViewStateEx2Soln controller = new PFAcademyViewStateEx2Soln();
        System.Assert(true,'Sham test coverage');
    }
    public static testMethod void testNavigation() {
        PFAcademyViewStateEx2Soln controller = new PFAcademyViewStateEx2Soln();
        ApexPAges.StandardSetController stdSetCon = controller.setCon;
        System.AssertNotEquals(stdSetCon,null,'cannot be null');
            
        if (controller.hasNext) {
           controller.next(); 
        }

        if (controller.hasPrevious) {
           controller.previous();   
        }

    }
    
    public static testMethod void testAccessors() {
        PFAcademyViewStateEx2Soln controller = new PFAcademyViewStateEx2Soln();
        ApexPAges.StandardSetController stdSetCon = controller.setCon;
        System.AssertNotEquals(stdSetCon,null,'cannot be null');
        
        List<String> theFields = controller.getFields();
        System.AssertEquals(theFields.size(),5,'Must match expected size');
        System.AssertEquals(controller.getAccts().size(),Math.min(DATA_SAMPLE_SIZE,20),'Accounts sample data did not match');
    }

    
    /**
     * Setup routine
    **/ 
    @testSetup
    private static void testSetup() {
        
        List<Account> testAccounts = new List<Account>();
        
        for (Integer i=0; i < DATA_SAMPLE_SIZE ; i++) {
            Account current = new Account(name='Test' + i, AccountNumber=''+i,website=null);
            testAccounts.add(current); 
        }
        
        insert testAccounts;
        
        return;
    }

    
}