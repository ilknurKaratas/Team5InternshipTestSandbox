@isTest
public class TestReminderEmailsforDueOpportunities {

    @isTest
    static void testBatch() {
        List<Opportunity> oppList = new List<Opportunity>();
        for (Integer i = 0; i < 10; i++) {
            Opportunity opp = new Opportunity();
            opp.Name = 'CRV' + i;
            opp.CloseDate = Date.today() +2;
            opp.StageName = 'Prospecting'; 
            oppList.add(opp);
        }
        insert oppList;

        User adminUser = [SELECT Id, Name FROM User WHERE Profile.Name = 'System Administrator' LIMIT 1]; // Adjust the profile name as needed

        Test.startTest();

        // Use "RunAs" to run the batch job with the System Administrator user's context
        System.runAs(adminUser) {
            ReminderEmailsforDueOpportunities batch = new ReminderEmailsforDueOpportunities();
            Database.executeBatch(batch);
        }

        Test.stopTest();
        
        
        List<EmailMessage>  sentEmails = [SELECT Subject, TextBody FROM EmailMessage];
         System.assertEquals(10, sentEmails.size());

        // Add assertions for email content based on the specific opportunities and owner data
        EmailMessage sentEmail = sentEmails[0]; 
            System.assertEquals( oppList[0].Name + ' Opportunity requires action!', sentEmail.Subject);
        System.assertEquals('Hello ' + adminUser.Name + ',\n' +  oppList[0].Name + ' Opportunity has to be closed before '+ oppList[0].CloseDate +'.'
                                + '\n' + 'Please finalize your sales process.', sentEmail.TextBody);
            
    

  }
  @isTest
    static void testExecute1() {
    ReminderEmailsforDueOpportunities batch = new ReminderEmailsforDueOpportunities();
    System.SchedulableContext sc = null; 
    batch.execute(sc);
    }
}