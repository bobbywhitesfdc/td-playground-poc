trigger OpportunityTrigger on Opportunity (before insert) {
for (Opportunity Opp :trigger.new)
{
    if(Opp.Due_Date__c != null)
    {}
}
}