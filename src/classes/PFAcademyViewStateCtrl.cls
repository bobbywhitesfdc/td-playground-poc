/*
Prakash Ramaswamy
March 2013
*/

public with sharing class PFAcademyViewStateCtrl {
    
    transient list<Account> accounts;
    transient list<String> fields;
    
    public list<string> moreThanThousandVal{get;set;}
    
    public PFAcademyViewStateCtrl(){
        String tempStr='';
        accounts=[select Id, Name, Industry, Phone, Rating from Account];
        fields=new list<String>{'Id','Name', 'Industry','Phone','Rating'};
        moreThanThousandVal=new List<string>();
        for(Integer index=0;index<3000;index++){
            tempStr=' Sample Value ' + index;
            moreThanThousandVal.add(tempStr);
        }
    }
    
    public list<Account> getAccounts(){
        return accounts;
    }
    
    public list<String> getFields(){
        return fields;
    }
}