public with sharing class PFAcademyOEVFController {
 

    private final Account account;

      public PFAcademyOEVFController() {
            System.debug('===In the controller constructor====');
            account = [select id, AccountNumber, name, site, NumberOfEmployees, Industry from Account 
                       where AccountNumber = :ApexPages.currentPage().getParameters().get('Acc')];
      }

      public Account getAccount() {
            System.debug('===In the getAccount Method====');
            return account;
      }

      public PageReference save() {
            System.debug('===In the save method====');
            update account;
            return null;
      }

      public PageReference cancel() {
            System.debug('===In the cancel Method====');
            return null;
      }


}