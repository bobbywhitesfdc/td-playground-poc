/**
 * An apex page controller that exposes the change password functionality
 
 Refactored to remove Unit test from this implementation class to it's own
 stand alone class  and shan added his play
 
 @author Bobby.White
 @company Salesforce.com
 
 */
public with sharing class ChangePasswordController {
    public String oldPassword {get; set;}
    public String newPassword {get; set;}
    public String verifyNewPassword {get; set;}        
    
    public PageReference changePassword() {
        return Site.changePassword(newPassword, verifyNewPassword, oldpassword);    
    }     
    
    public ChangePasswordController() {}
 }