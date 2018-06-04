/**
 * PFAcademyOEVController
 **/ 
public with sharing class PFAcademyOEVFController {
 
    public static final String ACCNUM_PARAM = 'Acc';
    private final Account account;

      public PFAcademyOEVFController() {
            debugParams();
            account = [select id, AccountNumber, name, site, NumberOfEmployees, Industry from Account 
                       where AccountNumber = :ApexPages.currentPage().getParameters().get(ACCNUM_PARAM)];
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
    private void debugParams() {
            System.debug('Parameters count=' + ApexPages.currentPage().getParameters().size());
            for (String current : ApexPages.currentPage().getParameters().keySet()) {
               System.debug('Param '+current + '=' + ApexPages.currentPage().getParameters().get(current));
            }

    }

}