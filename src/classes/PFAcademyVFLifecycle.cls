public with sharing class PFAcademyVFLifecycle {

 

    private final Account acct;
    Integer EmpAdd;

    public PFAcademyVFLifecycle(PFAcademyOEVFController controller) {
    	System.debug('=====In extension constructor ====');
        this.acct = (Account)controller.getAccount();
    }

    public String getGreeting() {
    	System.debug('=====In page action method====');
        return acct.name + ' Current Information';
    }
    
    public void resetEmp() {
    	System.debug('=====In page action method====');
        acct.numberofemployees = 10;
        update acct;
    }


}