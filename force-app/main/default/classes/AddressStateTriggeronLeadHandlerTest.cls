@isTest
public class AddressStateTriggeronLeadHandlerTest {
    
    @isTest
    public static void updateStateTest(){
        lead lead = new lead();
        lead.LeadSource = 'Website';
        lead.State__c = 'NJ: New Jersey';
        lead.LastName = 'Isiktas';
        
        //Test.startTest();
    	insert lead;
        //Test.stopTest();
        //birden fazla method ile birden fazla dml yapacak olsaydik
        //her methoddan sonra governer limitleri sifirlanmasi icin start ve stop eklenir.
        
        Lead leadList = [SELECT id, LeadSource, State FROM Lead WHERE Id =: lead.Id];
        
        system.assertEquals('NJ: New Jersey', leadList.State);
        system.assertEquals('Website', leadList.LeadSource);
    }

}