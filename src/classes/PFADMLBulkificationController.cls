/*
Chad S Kelly 
March 2013
This class is the custom controller for the PFAMassUpdateCase page
This class accepts a set of Case records provided by the user via a standard list view (such as a related list on standard page) 
and updates the case status field for all records to the status picked by the user
Props to folks who delivered the Mass Update And Mass Edit From List View appexchange app for this code 
*/

public class PFADMLBulkificationController {


    // Variable declarations are set to private as none need to be exposed to the page or outside the class
    private List<SelectOption> picklistValues;
    private final ApexPages.StandardSetController cntr; 
    private final PageReference fromPage;
    private List<Case> cases;        
    private transient ApexPages.Message currentMsg;
    
    // Public declaration to determine status picked by the user
    public String selectedStatus {
        get;
        // The setter method that determines what status the user selected in the visualforce page
        set {
            selectedStatus=value;
        }   
    }

    // This is the constructor that is always executed before the page is loaded
    public PFADMLBulkificationController(ApexPages.StandardSetController controller) {
           
            // Instatiate the standard set controller to determine which records user selected
            cntr = (ApexPages.StandardSetController)controller;
            
            // Capture the source page that initially launched our custom page
            fromPage = cntr.cancel();
            
            if (this.cases == null) {
            // populate a list of sObject type Case with the selected records with a little help from the apex standard set controller
            this.cases = (List<Case>)cntr.getSelected();
            }
            
            // confirm logic received a set of records to update
            if (cases.isEmpty() == true) {
            String msg = 'No record was selected on the list view.  Please click cancel button and select record(s)'; 
            currentMsg = new ApexPages.Message(ApexPages.severity.ERROR, msg);
            ApexPages.addMessage(currentMsg);
            }
            

    }

    // This is the getter method for CaseStatus which is bound to the selectlist on the visualforce page
    public List<SelectOption> getCaseStatus() { 
    
        List<SelectOption> statusoptions = new List<SelectOption>();  
        
        statusoptions = new List<SelectOption>();      
        statusoptions.add(new SelectOption('Closed', 'Closed'));
        statusoptions.add(new SelectOption('New', 'New'));
        statusoptions.add(new SelectOption('Working', 'Working'));                        
        statusoptions.add(new SelectOption('Escalated', 'Escalated'));                        
        return statusoptions;
    
    }
    
    // The page reference method called when the user clicks the 'Update' button
    public PageReference StartUpdate() {
      
        ApexPages.Message currentMsg = new ApexPages.Message(ApexPages.Severity.INFO, updateCases());
        ApexPages.addMessage(currentMsg);        
        return ApexPages.currentPage();
    
    }

    // This method is executed when user clicks 'update' and will return a success or exception message to the page based on the results
    public string updateCases() {
        
        String msg = '';
        
        // This method spins through the case list that was instantiated in the constructor and updates the list based on the value selected by the user in the visualforce page
        try{
            for (Case c: cases) {             
                c.Status = selectedStatus;
            }
        }
        catch (System.SObjectException e){
                System.debug('Type exception: ' + e.getMessage());
                
                msg = e.getMessage() + '<br></br>0 record(s) updated';
        }  
    
        // This method executes the DML update
        try{
            // When you using a list with multiple records only one DML statement is required to update the entire list
            update cases;
            msg = 'Updated ' + cases.size() + ' Record(s)';            
        }
        catch(System.DmlException e){
            msg = e.getDmlMessage(0) + '  No record updated';     
        }
        return msg;
    }

    // The page reference method called when the user clicks the cancel button
    public PageReference cancel() {
        // Navigate to the area of the solution that initially launched our custom page
        return fromPage;
    }

}