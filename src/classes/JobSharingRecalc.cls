global class JobSharingRecalc implements Database.Batchable<sObject> {
    
    public static final String MSG_SHARECALC_EX = 'Apex Sharing Recalculation Exception';
    public static final String MSG_SHARINGRECALC_COMPLETED = 'Apex Sharing Recalculation Completed.';
    
    // String to hold email address that emails will be sent to. 
    // Replace its value with a valid email address.
    static String emailAddress = 'admin@yourcompany.com';
    
    // The start method is called at the beginning of a sharing recalculation.
    // This method returns a SOQL query locator containing the records 
    // to be recalculated. 
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Hiring_Manager__c, Recruiter__c 
                                         FROM Job__c]);  
    }
    
    // The executeBatch method is called for each chunk of records returned from start.  
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        System.debug('Records in Batch=' + scope.size());
       // Create a map for the chunk of records passed into method.
        Map<ID, Job__c> jobMap = new Map<ID, Job__c>((List<Job__c>)scope);  
        
        // Create a list of Job__Share objects to be inserted.
        List<Job__Share> newJobShrs = new List<Job__Share>();
               
        // Locate all existing sharing records for the Job records in the batch.
        // Only records using an Apex sharing reason for this app should be returned. 
        List<Job__Share> oldJobShrs = [SELECT Id FROM Job__Share WHERE Id IN 
             :jobMap.keySet() AND 
            (RowCause = :Schema.Job__Share.rowCause.Recruiter__c OR
            RowCause = :Schema.Job__Share.rowCause.Hiring_Manager__c)]; 
        
        // Construct new sharing records for the hiring manager and recruiter 
        // on each Job record.
        for(Job__c job : jobMap.values()){
            Job__Share jobHMShr = new Job__Share();
            Job__Share jobRecShr = new Job__Share();
            
            // Set the ID of user (hiring manager) on the Job record being granted access.
            jobHMShr.UserOrGroupId = job.Hiring_Manager__c;
            
            // The hiring manager on the job should always have 'Read Only' access.
            jobHMShr.AccessLevel = 'Read';
            
            // The ID of the record being shared
            jobHMShr.ParentId = job.Id;
            
            // Set the rowCause to the Apex sharing reason for hiring manager.
            // This establishes the sharing record as Apex managed sharing.
            jobHMShr.RowCause = Schema.Job__Share.RowCause.Hiring_Manager__c;
            
            // Add sharing record to list for insertion.
            newJobShrs.add(jobHMShr);
            
            // Set the ID of user (recruiter) on the Job record being granted access.
            jobRecShr.UserOrGroupId = job.Recruiter__c;
            
            // The recruiter on the job should always have 'Read/Write' access.
            jobRecShr.AccessLevel = 'Edit';
            
            // The ID of the record being shared
            jobRecShr.ParentId = job.Id;
            
            // Set the rowCause to the Apex sharing reason for recruiter.
            // This establishes the sharing record as Apex managed sharing.
            jobRecShr.RowCause = Schema.Job__Share.RowCause.Recruiter__c;
            
         // Add the sharing record to the list for insertion.            
            newJobShrs.add(jobRecShr);
        }
        
        try {
           // Delete the existing sharing records.
           // This allows new sharing records to be written from scratch.
            Delete oldJobShrs;
            
           // Insert the new sharing records and capture the save result. 
           // The false parameter allows for partial processing if multiple records are 
           // passed into operation. 
           Database.SaveResult[] lsr = Database.insert(newJobShrs,false);
           
           // Process the save results for insert.
           for(Database.SaveResult sr : lsr){
               if(!sr.isSuccess()){
                   // Get the first save result error.
                   Database.Error err = sr.getErrors()[0];
                   
                   // Check if the error is related to trivial access level.
                   // Access levels equal or more permissive than the object's default 
                   // access level are not allowed. 
                   // These sharing records are not required and thus an insert exception 
                   // is acceptable. 
                   if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                     &&  err.getMessage().contains('AccessLevel'))){
                        sendErrorEmail(MSG_SHARECALC_EX, err.getMessage());
                   }
               }
           }   
        } catch(DmlException e) {
          sendErrorEmail(MSG_SHARECALC_EX,e.getMessage());
        }

    }
    
    // The finish method is called at the end of a sharing recalculation.
    global void finish(Database.BatchableContext BC){
        sendErrorEmail(MSG_SHARINGRECALC_COMPLETED,MSG_SHARINGRECALC_COMPLETED);
    }
    
    public Messaging.SingleEmailMessage sendErrorEmail(String subject, String messageTxt) {
        // Attempt to send the message, but if Email delivery is disabled, just log it
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
       String[] toAddresses = new String[] {emailAddress}; 
       mail.setToAddresses(toAddresses); 
       mail.setSubject(subject);
       mail.setPlainTextBody(messageTxt);
       try {

          Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
       } catch (System.EmailException mailEx) {
          System.debug(messageTxt + ' email disabled'); 
       }
       
       return mail;
        
    }
    
}