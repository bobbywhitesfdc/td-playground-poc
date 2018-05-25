/*
Chad S Kelly 
March 2013
Props to Cliff McQuirter for DynamicListController
*/

public with sharing class PFAPartialPageRefreshV2 extends DynamicListController {



    public PFAPartialPageRefreshV2() {
    
            super('select Id, OwnerID, CreatedDate, ParentId, Name, Type, billingCity, billingState from Account  ORDER BY CREATEDDATE DESC');
            pageSize = 5;

    }
    


    // Initialize setCon and return a list of records
    public List<Account> getacts() {
        return (List<Account>) getRecords();
    }
    

}