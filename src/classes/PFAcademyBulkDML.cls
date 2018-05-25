public with sharing class PFAcademyBulkDML {
	
	@future
	static void processOrCreateContacts(Map<Id,String> accountNameIdMap){
		List<Contact> contactList=new List<Contact>();
		for(String accountId:accountNameIdMap.keySet()){
			String accountName=accountNameIdMap.get(accountId);
			Contact contactInstance=new Contact(LastName=accountName+'Contact', FirstName='FutureCreated' , AccountId=accountId);
			contactList.add(contactInstance);
		}
		insert contactList;
	}
	
	@future
	static void processAsyncListAccounts(List<String> accountIds){
		Map<Id,String> accountNameIdMap=new Map<Id,String>();
		for(Account accountInstance:[select Id, Name, Access__c from Account where Id =:accountIds]){
			accountNameIdMap.put(accountInstance.Id,accountInstance.Name);
		}
		 processOrCreateContacts(accountNameIdMap);
		
	}
	
	public PageReference processAsyncAccountsv2(){
		List<String> accountList=new List<String>();
		
		for(Account accountInstance:[select Id, Name, AnnualRevenue 
		                             from Account
		                             where Name like 'Company%']){
		                             	
		     accountList.add(accountInstance.Id);
		}
		processAsyncListAccounts(accountList);
		//return to the same page after executing the update operation
		return null;
	}
	
	public PageReference updateAccounts(){
		//query the accounts and update the records
		for(Account accountInstance:[select Id, Name, AnnualRevenue 
		                             from Account
		                             where Name like 'Company%']){
		     accountInstance.AnnualRevenue=1;
		     update accountInstance;                            	
		 }
		 //return to the same page after executing the update operation
		 return null;
	}
	
	public PageReference updateBulkAccounts(){
		//create a collection to hold the new values of accounts
		List<Account> accountsToBeUpdated=new List<Account>();
		//query the accounts and update the records
		for(Account accountInstance:[select Id, Name, AnnualRevenue 
		                             from Account
		                             where Name like 'Company%']){
		     accountInstance.AnnualRevenue=333;
		     accountsToBeUpdated.add(accountInstance);                            	
		 }
		
		update accountsToBeUpdated; 
		//return to the same page after executing the update operation
		return null;
	}
	
	
	
	@future
	static void processAccounts(String accountId){
		Account accountInstance=[select Id, Access__c from Account where Id =:accountId];
		accountInstance.Access__c='TEST';
		update accountInstance;
	}
	
	public PageReference processAsyncAccounts(){
		for(Account accountInstance:[select Id, Name, AnnualRevenue 
		                             from Account
		                             where Name like 'Company%']){
		                             	
		     processAccounts(accountInstance.Id);
		}
		//return to the same page after executing the update operation
		return null;
	}

}