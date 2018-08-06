trigger OpportunityTrigger on Opportunity (before insert) 
{
    //Intellectual Notes: Below example is for demo purpose only. Do Not follow :-)
    
    for (Opportunity Opp :trigger.new)
    {
        if(Opp.Due_Date__c == null)
        {
            Opp.addError(system.label.OppDueDateErrorMessage);continue;
        }
    }
}