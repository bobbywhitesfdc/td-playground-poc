/**
 * Test for the PFASearchContactsController class
 @author Bobby White
 @Company Salesforce.com
 @date   October 27, 2016
 @email  bobby.white@salesforce.com
 **/
@isTest
public class PFASearchContactsController_Test {
    
    public static final String TEST_COMPANYNAME = 'Acme';
    public static final String PARAM_ACCOUNTNAME = 'accountName';
    public static final String PARAM_FNAME = 'firstname';
    public static final String PARAM_LNAME = 'lastname';

    public static testMethod void loadPageNoParams() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        Test.startTest();
        
        // Instantiate the controller
        ApexPages.StandardSetController theStandardSetController = new ApexPages.StandardSetController(theTestData);
        
        PFASearchContactsController theController = new PFASearchContactsController(theStandardSetController);
        
        // Initialize it from the VF Page it's intended to support
        Test.setCurrentPage(Page.PFASearchContacts);
        theController.runSearch();
        
        
        Test.stopTest();
        
        
        // Check the functionality
        
        System.assert(theController!=null,'Controller must not be null');

        
    }
    
    public static testMethod void loadPageCompanyParam() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        Test.startTest();
        
        // Instantiate the controller
        ApexPages.StandardSetController theStandardSetController = new ApexPages.StandardSetController(theTestData);
        
        PFASearchContactsController theController = new PFASearchContactsController(theStandardSetController);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFASearchContacts; 
        ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        
        Test.setCurrentPage(ref);
        
        theController.runSearch();
        
        
        Test.stopTest();
        
        
        // Check the functionality
        
        System.assert(theController!=null,'Controller must not be null');

        
    }
    
        public static testMethod void loadPageAllParams() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        Test.startTest();
        
        // Instantiate the controller
        ApexPages.StandardSetController theStandardSetController = new ApexPages.StandardSetController(theTestData);
        
        PFASearchContactsController theController = new PFASearchContactsController(theStandardSetController);
        
        // Initialize it from the VF Page it's intended to support
        PageReference ref = Page.PFASearchContacts; 
        ref.getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        ref.getParameters().put(PARAM_FNAME, 'Jack');
        ref.getParameters().put(PARAM_LNAME, 'Black');
        
        Test.setCurrentPage(ref);
        
        theController.runSearch();
        
        
        Test.stopTest();
        
        
        // Check the functionality
        
        System.assert(theController!=null,'Controller must not be null');

        
    }
    
    public static testMethod void toggleSort() {
        
        List<Contact> theTestData = [SELECT id, FirstName,LastName,Email From Contact Limit 100];
        
        Test.startTest();
        
        // Instantiate the controller
        ApexPages.StandardSetController theStandardSetController = new ApexPages.StandardSetController(theTestData);
        
        PFASearchContactsController theController = new PFASearchContactsController(theStandardSetController);
        
        // Initialize it from the VF Page it's intended to support
        Test.setCurrentPage(Page.PFASearchContacts);
        ApexPages.currentPage().getParameters().put(PARAM_ACCOUNTNAME, TEST_COMPANYNAME);
        ApexPages.currentPage().getParameters().put(PARAM_FNAME, 'Jack');
        ApexPages.currentPage().getParameters().put(PARAM_LNAME, 'Black');
        

        
        theController.toggleSort();
        System.AssertNotEquals(theController.debugSoql,'','Debug SOQL must not be empty');
        
        
        Test.stopTest();
        
        
        // Check the functionality
        
        System.assert(theController!=null,'Controller must not be null');

        
    }
    
    
    
    
    @testSetup
    private static void createTestData() {
        // Create Test data
        Account theTestAccount = new Account(Name=TEST_COMPANYNAME);
        insert theTestAccount;
        
        Contact theTestContact = new Contact(FirstName='Bobby',LastName='White',email='bobby.white@salesforce.com');
        theTestContact.AccountId = theTestAccount.id;
        insert theTestContact;   
    }
}