/**
 * Bobby was here
 **/ 
@isTest
public class PFADMLBulkificationController_Test {
    public static final Integer BULK_COUNT = 100;
    /**
     * Kitchen sink test method that tests everything that should work when the case list is empty
     **/ 
    public static testMethod void testConstructorEmpty() {
        final String STATUS = 'Closed';
        PageReference ref = Page.PFAMassUpdateCase;
        Test.setCurrentPage(ref);
        
        List<Case> myEmptyCaseList = new List<Case>();
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(myEmptyCaseList);
        PFADMLBulkificationController controller = new PFADMLBulkificationController(setController);
        
        controller.selectedStatus=STATUS;
        System.AssertEquals(controller.selectedStatus,STATUS,'Must match!');
        
        List<SelectOption> options = controller.getCaseStatus();
        System.AssertEquals(options.size(),4,'Must have the right number of options');
        
        System.AssertNotEquals(controller.cancel(),null,'Cannot return null, must return the originating page!');
    }
    
    /**
     * Kitchen sink test method that tests everything that should work when the case list is not-empty
     **/ 
    public static testMethod void testWithCases() {
        final String STATUS = 'Working';
        PageReference ref = Page.PFAMassUpdateCase;
        Test.setCurrentPage(ref);
        
        testSetup();
        
        List<Case> myGoodCaseList = [SELECT Id, Status From Case LIMIT :BULK_COUNT];
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(myGoodCaseList);
        // Tell the controller to "select" every odd case, do it before we initialize our controller
        setController.setSelected(selectOddCases(myGoodCaseList,10));

        PFADMLBulkificationController controller = new PFADMLBulkificationController(setController);
        
        controller.selectedStatus=STATUS;
        System.AssertEquals(controller.selectedStatus,STATUS,'Must match!');
                
        PageReference destinationPage = controller.StartUpdate();
        System.AssertNotEquals(destinationPage,null,'Cannot be null');
        
    }
    
     /**
     * Test for error handling
     **/ 
    public static testMethod void testDMLEx() {
        final String STATUS = 'Working';
        PageReference ref = Page.PFAMassUpdateCase;
        Test.setCurrentPage(ref);
        
        testSetup();
        
        List<Case> myGoodCaseList = [SELECT Id, Status From Case LIMIT :BULK_COUNT];
        ApexPages.StandardSetController setController = new ApexPages.StandardSetController(myGoodCaseList);
        
        // Tell the controller to "select" every odd case, do it before we initialize our controller
        List<Case> selectedCases = selectOddCases(myGoodCaseList,10);
        setController.setSelected(selectedCases);

        PFADMLBulkificationController controller = new PFADMLBulkificationController(setController);
        
        controller.selectedStatus=STATUS;
        System.AssertEquals(controller.selectedStatus,STATUS,'Must match!');
        
        
        User testUser = createTestUser('test@my.silly77.org');
        
        List<Case> lockedCases = [SELECT Id From Case Where Id IN :selectedCases FOR UPDATE];
        
        System.runAs(testUser) {
           PageReference destinationPage = controller.StartUpdate();
           System.AssertNotEquals(destinationPage,null,'Cannot be null');    
        }
        
    }


    /* Select just the odd cases */
    private static List<Case> selectOddCases(List<Case> availableCases, Integer m) {
        System.Debug('select cases');
        if (availableCases == null || availableCases.isEmpty()) {
            return new List<Case>();
        } else {
            List<Case> selectedCases = new List<Case>();
            for (Integer i=0; i < Math.min(availableCases.size(),m*2); i=i+2) { // zero based, so logically "odd" are really even starting with zero
                selectedCases.add(availableCases[i]);
            }
            System.debug('avail=' + availableCases.size() + ' selected = ' + selectedCases.size());
            return selectedCases;
        }
        
    }
    
    private static void testSetup() {
        List<Case> testCases = new List<Case>();
        for (Integer i=0; i < BULK_COUNT; i++)  {
            Case current = new Case(status='New');
            current.subject='Test subj'+i;
            current.description='Test desc' +i;
            testCases.add(current);
        }
        insert testCases;
    }
    
    private static User createTestUser(String userNameTarget) {
                
        Profile theProfile = [SELECT Id from Profile Where Name='Sales User']; 
        
        User myTestUser = new User(FirstName='Test'
                           ,LastName='User'
                           ,Email='test@example.com'
                           ,Username=userNameTarget
                           ,CommunityNickname='testuser'
                           ,Alias='testu'
                           ,TimeZoneSidKey='America/New_York'
                           ,LocaleSidKey='en_US'
                           ,EmailEncodingKey='ISO-8859-1'
                           ,LanguageLocaleKey='en_US'
                           ,ProfileId=theProfile.id);
        insert myTestUser; 
        
        User testUser = [SELECT Id,Name,Username,Email From User where Alias='testu' LIMIT 1];
        return testUser;
    }

}