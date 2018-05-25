public with sharing class PFAcademyComponentController {
	//No constructor defined. The instance of the controller is created using the default no argument constructor.
	 
    public String selectedValue {
        get;
        set {
        	System.debug('===Setting selected Value====');
            editMode = (value != null);
            // Side effect here - don't do this!
            selectedValue = value;
        }
    }
    public Boolean editMode {get; private set;}
 

}