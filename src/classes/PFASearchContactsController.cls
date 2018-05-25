public with sharing class PFASearchContactsController {

    // the soql without the order and limit
    private String soql = 'select firstname, lastname, account.name from contact where account.name != null';

    public PFASearchContactsController(ApexPages.StandardSetController controller) {
    
        contactList = new List<ContactWrapper>();    
        contacts = new List<Contact>();
        runQuery();

    }

    // This is our wrapper/container class. A container class is a class, a data structure, or an abstract data type whose instances are collections of other objects. In this example a wrapper class contains both the standard salesforce object Contact and a Boolean value
    public class ContactWrapper {
        public Contact con {get; set;}
        public Boolean selected {get; set;}

        //This is the contructor method. When we create a new cContact object we pass a Contact that is set to the con property. We also set the selected value to false
        public ContactWrapper(Contact c) {
            con = c;
            selected = false;
        }
    }
   
    // the collection of contacts to display
    public List<Contact> contacts {get;set;}  
    
    public List<ContactWrapper> contactList {get;set;}  
    
    // runs the actual query
    public void runQuery() {
   
    try {
      contacts = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20');
      
      if(contactList != null) {contactList.clear();}
      
      for(Contact c: contacts) {
                // As each contact is processed we create a new cContact object and add it to the contactList
                try{
                contactList.add(new ContactWrapper(c));
                }
                catch (Exception e){       
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'UrrrgHHH!' + e));
                }

        }        
      
    // for(Contact c : [select firstname, lastname, account.name, gender__c from contact where account.name != null limit 10]) {
                // As each contact is processed we create a new cContact object and add it to the contactList
    //            contactList.add(new ContactWrapper(c));
    //        }
      
      
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Ooops!'));
    }
    } 
 
 
  // the current sort direction. defaults to asc
  public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
 
  // the current field to sort by. defaults to last name
  public String sortField {
    get  { if (sortField == null) {sortField = 'lastName'; } return sortField;  }
    set;
  }
 
  // format the soql for display on the visualforce page
  public String debugSoql {
    get { return soql + ' order by ' + sortField + ' ' + sortDir + ' limit 20'; }
    set;
  }
 

 
  // toggles the sorting of query from asc<-->desc
  public void toggleSort() {
    // simply toggle the direction
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
    // run the query again
    runQuery();
  }

 
  // runs the search with parameters passed via Javascript
  public PageReference runSearch() {
 
    String firstName = Apexpages.currentPage().getParameters().get('firstname');
    String lastName = Apexpages.currentPage().getParameters().get('lastname');
    String accountName = Apexpages.currentPage().getParameters().get('accountName');
 
    soql = 'select firstname, lastname, account.name from contact where account.name != null';
    if (!firstName.equals(''))
      soql += ' and firstname LIKE \''+String.escapeSingleQuotes(firstName)+'%\'';
    if (!lastName.equals(''))
      soql += ' and lastname LIKE \''+String.escapeSingleQuotes(lastName)+'%\'';
    if (!accountName.equals(''))
      soql += ' and account.name LIKE \''+String.escapeSingleQuotes(accountName)+'%\'';  
 
    // run the query again
    runQuery();
 
    return null;
  }
 

}