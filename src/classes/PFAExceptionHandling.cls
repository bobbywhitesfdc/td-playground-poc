/*
Chad S Kelly 
March 2013
This class is the custom controller for the PFAExceptionHandling page
This class demonstrates how parameters can be consumed by a class using URL string paramaters 
and how exception handling can be implemented to present users 
*/


public class PFAExceptionHandling {


    // Set these variables to private and show how references on VF page do not pass type check
    public Id contactId{get;set;}
    public Id caseId{get;set;} 
    private Id accountId{get;set;}
    

    // This is the constructor which is always executed before the page is loaded
    public PFAExceptionHandling(ApexPages.StandardController controller) {
        

        if (Apexpages.currentPage().getParameters().get('contact')!= null)
        // set the contactId variable (of type ID which expects a salesforce record ID) to the value provided in the URL string
        // (e.g. https://na11.salesforce.com/apex/PFAExceptionHandling?id=500G000000BBe4g&contact=003G0000013LexN&account=001G000000pyvRU)
        contactId = Apexpages.currentPage().getParameters().get('contact');
        

        if (Apexpages.currentPage().getParameters().get('id')!= null)
        // It is typical use the syntax ID to pass a record standard controller 
        caseId = Apexpages.currentPage().getParameters().get('id');
        
        if (Apexpages.currentPage().getParameters().get('account')!= null)
        accountId = Apexpages.currentPage().getParameters().get('account');

     }
    
    
    // This method is executed by the action parameter in the pages tag and before the page is loaded (but after the constructor)
    public PageReference ProcessSomething() {
     
        // TODO: Extend this method to check to confirm the page is provided a case, contactId and account ID
        if (contactId != null) {
         return null;
        }
        else
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please include a contact case and account'));
            return null; 
        }

    
    }   
   

}