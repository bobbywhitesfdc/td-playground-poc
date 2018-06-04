@isTest
public class PFAcademyViewStateCtrl_Test {
    public static final Integer BULK_COUNT = 10;
    
    public static testMethod void testCase1() {
        setup();
        Test.setCurrentPage(Page.PFAcademyViewStateVF);
        PFAcademyViewStateCtrl controller = new PFAcademyViewStateCtrl();
        
        System.Assert(!controller.getAccounts().isEmpty(),'Cannot be empty');
        System.AssertEquals(controller.getFields().size(),5,'Must be as expected');
    }
    
   private static void setup() {
        List<Account> testAccounts = new List<Account>();
        for (Integer i=0; i < BULK_COUNT; i++) {
            Account current = new Account(name='Company '+i);
            testAccounts.add(current);
        }
        insert testAccounts;
        
        
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