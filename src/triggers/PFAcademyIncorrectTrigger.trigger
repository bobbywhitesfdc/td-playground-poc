trigger PFAcademyIncorrectTrigger on Account (before insert, before update) {
    
      
   //For loop to iterate through all the incoming Account records
   for(Account a: Trigger.new) {
      
      if(a.AnnualRevenue >1 && a.AnnualRevenue < 334){    
          //THIS FOLLOWING QUERY IS INEFFICIENT AND DOESN'T SCALE
          //Since the SOQL Query for related Contacts is within the FOR loop, if this trigger is initiated 
          //with more than 100 records, the trigger will exceed the trigger governor limit
          //of maximum 100 SOQL Queries.
              
          List<Contact> contacts = [select id, salutation, firstname, lastname, email 
                            from Contact where accountId =:a.Id];
              
          for(Contact c: contacts) {
             System.debug('Contact Id[' + c.Id + '], FirstName[' + c.firstname + '], LastName[' + c.lastname +']');
             c.Description=c.salutation + ' ' + c.firstName + ' ' + c.lastname;
               
             //THIS FOLLOWING DML STATEMENT IS INEFFICIENT AND DOESN'T SCALE
             //Since the UPDATE dml operation is within the FOR loop, if this trigger is initiated 
             //with more than 150 records, the trigger will exceed the trigger governor limit 
             //of 150 DML Operations maximum.
                                      
             update c;
          }       
      }
   }

    

}