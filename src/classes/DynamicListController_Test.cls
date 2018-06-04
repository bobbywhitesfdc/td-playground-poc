/**
  @Class DynamicListController_Test
  @ClassUnderTest DynamicListController
  @author Bobby White
  @email Bobby.White@salesforce.com
  @date October 27, 2016
  
 **/
@isTest
public class DynamicListController_Test {
    public static final String TEST_COMPANYNAME = 'Acme';
    
    
    @testSetup
    private static void createTestData() {
        // Create Test data
        Account theTestAccount = new Account(Name=TEST_COMPANYNAME);
        insert theTestAccount;
        
        List<Contact> testContacts = new List<Contact>();
        for (integer i=0; i < 250; i++) {
           Contact theTestContact = new Contact(FirstName='Bobby'+i
                                             ,LastName='White'
                                             ,email='bobby.white'+i+'@salesforce.com');
           theTestContact.AccountId = theTestAccount.id;
           testContacts.add(theTestContact);
        }
        
        insert testContacts;   
    }

    public static testMethod void simpleNoParams() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        String baseQuery =  'SELECT id, FirstName,LastName,Email From Contact';
        
        // Instantiate the controller        
        DynamicListController theController = new DynamicListController(baseQuery);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFAPartialPageRefreshV2; 
        //ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        Test.setCurrentPage(ref);  
    }
    
    public static testMethod void sortTests() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        String baseQuery =  'SELECT id, FirstName,LastName,Email From Contact';
        
        // Instantiate the controller        
        DynamicListController theController = new DynamicListController(baseQuery);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFAPartialPageRefreshV2; 
        //ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        Test.setCurrentPage(ref);
        System.AssertEquals(theController.sortAsc,false,'Default must be not sort Asc!');
        theController.sortAsc=true;
        System.AssertEquals(theController.sortAsc,true,'Expected true after toggle');
        
        PageReference refAfterSort = theController.sort();
        
        System.AssertEquals(refAfterSort,null,'Expected null result'); 
        
        theController.sortColumn ='email';
        System.AssertEquals(theController.sortColumn,'email');
        theController.sortColumn = 'LastName';
        System.AssertEquals(theController.sortColumn,'LastName');
        theController.sortAsc=true;
        theController.sort();

    }
    
    public static testMethod void navigationTests() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        String baseQuery =  'SELECT id, FirstName,LastName,Email From Contact';
        
        // Instantiate the controller        
        DynamicListController theController = new DynamicListController(baseQuery);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFAPartialPageRefreshV2; 
        //ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        Test.setCurrentPage(ref);
        
        System.Assert(theController.getPageCount()>0,'Must have non-zero pages!');
        
        theController.last();
        theController.first();
        if (theController.getHasNext()) {
            theController.next();
        }
        if (theController.getHasPrevious()) {
            theController.previous();
        }
        
        System.AssertEquals(theController.getPageNumber(),1);
        System.Assert(theController.getPageCount() > 0);
        Integer targetPage = theController.getPageCount() > 1 ? 2 : 1;

        theController.setPageNumber(targetPage);
        System.AssertEquals(theController.getPageNumber(),targetPage,'Expected Page doesnt match after set');
     
    }
    
    public static testMethod void miscTests() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        String baseQuery =  'SELECT id, FirstName,LastName,Email From Contact';
        
        // Instantiate the controller        
        DynamicListController theController = new DynamicListController(baseQuery);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFAPartialPageRefreshV2; 
        //ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        Test.setCurrentPage(ref);
        
        System.AssertEquals(theController,theController.getController(),'Reference should be equal');
        
        System.AssertEquals(theController.getRenderResults(),true,'Render results must be true!');
        System.Assert(theController.getResultSize()>0,'result size expected to be greater than zero');
        
        theController.search();
        theController.save();
        theController.cancel();
        
    }

    
}