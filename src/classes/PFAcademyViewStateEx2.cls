public with sharing class PFAcademyViewStateEx2 {
	 transient list<Account> accts;
     transient list<String> fields;

     public PFAcademyViewStateEx2() {
         accts = [SELECT Id, Name, Industry, Phone, Rating FROM Account WHERE Name!=null];
         fields = new list<String> {'Id', 'Name', 'Industry', 'Phone', 'Rating'};
     }
     
     public list<Account> getAccts() { return accts; }
     public list<String> getFields() { return fields; }

}