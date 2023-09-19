public class AddressStateTriggeronLeadHandler {
    
    public static void populateState(List<Lead> leadList){
        for(Lead lead : leadList){
            if(lead.LeadSource == 'Website'){
                lead.State = lead.State__c;
            }
        }
    }
}