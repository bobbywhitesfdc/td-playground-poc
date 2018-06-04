/**
 * @Class PFAcademyBulkDML_Test
 * @ClassUnderTest PFAcademyBulkDML
 * @Author Bobby White
 * @company Salesforce.com
 * @date Nov 1, 2016
 **/ 
@isTest
public class PFAcademyBulkDML_Test {
    public static final Integer BULK_COUNT = 10;
    
    public static testMethod void testAsync() {
       User testUser = createTestUser('moose@ashworthbucs.org.gr');
        
       Test.startTest();
       System.runAs(testUser) {
           setup();
           PageReference ref = new PFAcademyBulkDML().processAsyncAccounts(); 
           System.AssertEquals(ref,null,'Lame assertion');
       }
       Test.stopTest();
    }
    
    public static testMethod void testAsync2() {
       User testUser = createTestUser('moose@ashworthbucs.org.gr');
        
       Test.startTest();
       System.runAs(testUser) {
           setup();
           PageReference ref = new PFAcademyBulkDML().processAsyncAccountsv2(); 
           System.AssertEquals(ref,null,'Lame assertion');
       }
       Test.stopTest();
    }

    
    public static testMethod void testBulk() {
       User testUser = createTestUser('moose.test2@ashworthbucs.org.gr');
        
       Test.startTest();
       System.runAs(testUser) {
           setup();
           PageReference ref = new PFAcademyBulkDML().updateBulkAccounts(); 
           System.AssertEquals(ref,null,'Lame assertion');
       }
       Test.stopTest();
    }
    
    public static testMethod void testIterative() {
       User testUser = createTestUser('moose.test3@ashworthbucs.org.gr');
        
       Test.startTest();
       System.runAs(testUser) {
           setup();
           PageReference ref = new PFAcademyBulkDML().updateAccounts(); 
           System.AssertEquals(ref,null,'Lame assertion');
       }
       Test.stopTest();
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