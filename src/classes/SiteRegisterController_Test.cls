@isTest
public class SiteRegisterController_Test {
    public testMethod static void testRegistration() {
        SiteRegisterController controller = new SiteRegisterController();
        
        User guestUser = getGuestUser();
        
        System.Assert(guestUser!=null,'No guest user defined!');
        
        System.runAs(guestUser) {
           // registerUser will always return null when the page isn't accessed as a guest user
           controller.username = 'test@force.com';
           controller.email = 'test@force.com';
           controller.communityNickname = 'test';
            
           System.assert(controller.registerUser() == null);    

           
           controller.password = 'abcd1234';
           controller.confirmPassword = 'abcd123';

        

           System.assert(controller.registerUser() == null);  
        }
    }
    
    /** 
     * Allow the test to runAS the Portal Guest User
     **/ 
    private static User getGuestUser() {
        List<User> guestUsers = [SELECT Id, Name, Profile.Name 
                                   From User 
                                  Where ProfileId In (SELECT Id From Profile Where UserType='Guest')];
        
        return guestUsers.isEmpty() ? null : guestUsers[0];
    }

}