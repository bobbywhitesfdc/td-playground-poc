global with sharing class PartnerHomeController {
    global String username {get; set;}
    global String password {get; set;}

    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
    global PartnerHomeController () {}
    
    global static testMethod void testSiteLoginController () {
        // Instantiate a new controller with all parameters in the page
        PartnerHomeController controller = new PartnerHomeController ();
        controller.username = 'test@salesforce.com';
        controller.password = '123456'; 
                
        System.assertEquals(controller.login(),null);                           
    }
}