@isTest
private class JobSharingTester {
      
    // Test for the JobSharingRecalc class        
    public static testMethod void testApexSharingPos(){
        runSharingScenario(false);
    }
    public static testMethod void testApexSharingNeg() {
        runSharingScenario(true);
    }
    
    public static testMethod void testSendEmail() {
        final String TEST_SUBJECT='MyErrorSubject';
        final String TEST_MESSAGE='MyErrorMessageBody';
        
        JobSharingRecalc recalc = new JobSharingRecalc();
        
        Messaging.SingleEmailMessage mail = recalc.sendErrorEmail(TEST_SUBJECT,TEST_MESSAGE);
        
        System.assert(mail!=null);
        System.assertEquals(mail.subject,TEST_SUBJECT);
        System.assertEquals(mail.plainTextBody,TEST_MESSAGE);
        System.assertNotEquals(mail.toAddresses.size(),0,'To Addresses must not be empty!');
        
    }
    
    @testSetup
    private static void setup() {
        // Select users for the test.
        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];
        ID User1Id = users[0].Id;
        ID User2Id = users[1].Id;
       
        // Insert some test job records.                
        List<Job__c> testJobs = new List<Job__c>();
        for (Integer i=0;i<5;i++) {
        Job__c j = new Job__c();
            j.Name = 'Test Job ' + i;
            j.Recruiter__c = User1Id;
            j.Hiring_Manager__c = User2Id;
            testJobs.add(j);
        }
        insert testJobs;
         
    }
    
    private static User createTestUser() {
                
        Profile theProfile = [SELECT Id from Profile Where Name='Sales User']; 
        
        User myTestUser = new User(FirstName='Test'
                           ,LastName='User'
                           ,Email='test@example.com'
                           ,Username='testuser@example.com.test'
                           ,CommunityNickname='testuser'
                           ,Alias='testu'
                           ,TimeZoneSidKey='America/New_York'
                           ,LocaleSidKey='en_US'
                           ,EmailEncodingKey='ISO-8859-1'
                           ,LanguageLocaleKey='en_US'
                           ,ProfileId=theProfile.id);
        insert myTestUser; 
        
        User testUser = [SELECT Id,Name,Username,Email From User where Alias='testu' LIMIT 1];
        return testUser;
    }
    
    private static void runSharingScenario(boolean lockRecords) {
               // Instantiate the class implementing the Database.Batchable interface.    
        JobSharingRecalc recalc = new JobSharingRecalc();
              
        Test.startTest();
        
       
       String jobId='';
       User testUser = createTestUser();
       System.debug(testUser == null ? ' Test User is null ' : 'Test User is: ' + testUser.username);
       
       List<Job__Share> shares = null;
       
       // Simulate a Lock on all of the Sharing Records
       if (lockRecords) {
        shares= [SELECT Id,AccessLevel,RowCause 
                  From Job__Share FOR UPDATE];
       }
       
       System.runAs(testUser) {
        // Invoke the Batch class.
        jobId = Database.executeBatch(recalc);
       }
       
        Test.stopTest();
       
        // Get the Apex job and verify there are no errors.
        AsyncApexJob aaj = [Select JobType, TotalJobItems, JobItemsProcessed, Status,
                            CompletedDate, CreatedDate, NumberOfErrors
                            from AsyncApexJob where Id = :jobId];
                            
        if (!lockRecords)  {                   
           System.assertEquals(0, aaj.NumberOfErrors);
     
        // This query returns jobs and related sharing records that were inserted               
        // by the batch job's execute method.    
        List<Job__c> jobs = [SELECT Id, Hiring_Manager__c, Recruiter__c,
            (SELECT Id, ParentId, UserOrGroupId, AccessLevel, RowCause FROM Shares
            WHERE (RowCause = :Schema.Job__Share.rowCause.Recruiter__c OR
            RowCause = :Schema.Job__Share.rowCause.Hiring_Manager__c))
            FROM Job__c];      
        
        // Validate that Apex managed sharing exists on jobs.             
        for(Job__c job : jobs){
            // Two Apex managed sharing records should exist for each job            
            // when using the Private org-wide default.
            System.assert(job.Shares.size() == 2);
           
            for(Job__Share jobShr : job.Shares){
               // Test the sharing record for hiring manager on job.                             
               if(jobShr.RowCause == Schema.Job__Share.RowCause.Hiring_Manager__c){
                    System.assertEquals(jobShr.UserOrGroupId,job.Hiring_Manager__c);
                    System.assertEquals(jobShr.AccessLevel,'Read');
                }
                // Test the sharing record for recruiter on job.                
                else if(jobShr.RowCause == Schema.Job__Share.RowCause.Recruiter__c){
                    System.assertEquals(jobShr.UserOrGroupId,job.Recruiter__c);
                    System.assertEquals(jobShr.AccessLevel,'Edit');
                }
            }
        }
        }
        
    }
}