public with sharing class PFAcademyViewStateEx2Soln {



    public PFAcademyViewStateEx2Soln() {

        fields = new list<String> {'Id', 'Name', 'Industry', 'Phone', 'Rating'};

        if(setCon == null) {

            setCon = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Id, Name, Industry, Phone, Rating FROM Account]));

        }

    }



    public ApexPages.StandardSetController setCon{get; set;}

    public list<String> fields;

    

    public Boolean hasNext {

        get {

            return setCon.getHasNext();

        }

        set;

    }

    

    public Boolean hasPrevious {

        get {

            return setCon.getHasPrevious();

        }

        set;

    }

    

    public void next() {

        setCon.next();

    }





    public void previous() {

        setCon.previous();

    }



   public list<String> getFields() {

        return fields;

    }



    public List<Account> getAccts() {

        return (List<Account>) setCon.getRecords();

    }

}