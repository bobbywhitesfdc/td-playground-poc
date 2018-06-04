@isTest
public class ForgotPasswordController_Test {
      	
    public static testMethod void testBadUname() {
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = 'test@salesforce.com';     	
    
    	System.assertEquals(controller.forgotPassword(),null); 
    }
    
    public static testMethod void testGoodUname() {
        Long index = System.now().getTime();
        User testUser = createTestUser('test'+ index  +'@salesforce.com.test');
    	// Instantiate a new controller with all parameters in the page
    	ForgotPasswordController controller = new ForgotPasswordController();
    	controller.username = testUser.username;     	
    
    	System.assertEquals(controller.forgotPassword(),null); 
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