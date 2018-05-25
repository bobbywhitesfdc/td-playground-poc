/*
Chad S Kelly & Prakash Ramaswamy 
March 2013
This class is the custom controller for the PFAInsertShowLeads page
This class inserts new lead records based on a new lead form
and presents newly created leads leveraging the standard set controller
*/

public with sharing class PFAInsertShowLeadsController {

    private final Lead ld;
    
    // This is the controller constructor which is executed automatically before each time the page is loaded
    public PFAInsertShowLeadsController(ApexPages.StandardController stdCntrl) {
                // Use the standard controller to set the variable of Type 'Lead' 
                this.ld = (Lead)stdCntrl.getRecord();
    }

 // Method executed when used clicks 'insert' button
   public PageReference saveandnew() {
    
     try { 
         System.debug('=====ld value ===' + ld);
         insert ld; 
         //reset the set controller instance to null so as to trigger the requery process in the set method
         setCon=null;
         //reinitialize the lead id null, to capture the next new lead after insertion 
         ld.Id=null;
         
         //ld.FirstName=null;
        } catch(System.DMLException e) {
            ApexPages.addMessages(e);
            return null;
        } 
        
        return null; 
    
    
    } 



    
    // ApexPages.StandardSetController must be instantiated
    // for standard list controllers
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null) {
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(
                    [SELECT Name, Company, Status, City, CreatedDate FROM Lead ORDER BY CREATEDDATE DESC LIMIT 10]));
            }
            // sets the number of records in each page set
            Setcon.setPageSize(10);
            return setCon;
        }
        set;
    }

    // Initialize setCon and return a list of records
    public List<Lead> getleads() {
        return (List<Lead>) setCon.getRecords();
    }
    

}