@isTest
public class testBatchBirthdayCelebration {
        
    @isTest
    public static void setupData() {

         // Create test data for Contacts with birthdays today
        List<Contact> testContacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact contact = new Contact();
            contact.FirstName = 'Test';
            contact.LastName = 'Contact' + i;
            contact.Email = 'test' + i + '@example.com';
            contact.Birthdate = Date.today();
            testContacts.add(contact);
        }
        insert testContacts;


        // Start the batch job
        Test.startTest();
        BatchBirthdayCelebration batch = new BatchBirthdayCelebration();
        Database.executeBatch(batch);
        Test.stopTest();
        
        
        // Verify that emails were sent
        Integer expectedEmailCount = 10; // Only one email should be sent since the second contact has opted out

        // Query sent emails and verify their content
        List<EmailMessage> sentEmails = [SELECT Subject, TextBody FROM EmailMessage];
        System.assertEquals(expectedEmailCount, sentEmails.size());

        EmailMessage sentEmail = sentEmails[0];
        System.assertEquals('Happy Birthday Test Contact0!', sentEmail.Subject);
        System.assertEquals(
            'As Silverline family, we wish you a very happy birthday and'+ '\n'+ ' send you best wishes for much happiness in your life!',
            sentEmail.TextBody);
       		
	}
    @isTest
    static void testExecute1() {
    BatchBirthdayCelebration batch = new BatchBirthdayCelebration();
    System.SchedulableContext sc = null; 
    batch.execute(sc);
    }
       }