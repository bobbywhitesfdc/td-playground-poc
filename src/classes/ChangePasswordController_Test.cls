/**
* ChangePasswordController_Test
* @author Bobby White
* @date September 29, 2016
* 
* Extracted and beefed up test class from implementation class
**/
@istest
public class ChangePasswordController_Test {
    public static final String OLD_PASSWD = '123456';
    public static final String NEW_PASSWD = 'qwerty1';
    
    public testMethod static void testChangePasswordController() {
        // Instantiate a new controller with all parameters in the page
        ChangePasswordController controller = new ChangePasswordController();
        controller.oldPassword = OLD_PASSWD;
        controller.newPassword = NEW_PASSWD; 
        controller.verifyNewPassword = NEW_PASSWD;                
        
        System.assertEquals(controller.changePassword(),null,'Expected Null result'); 
        
        System.assertEquals(controller.oldPassword, OLD_PASSWD,'Old password doesnt match');
        System.assertEquals(controller.newPassword, NEW_PASSWD,'New password doesnt match');
        
    }    

}