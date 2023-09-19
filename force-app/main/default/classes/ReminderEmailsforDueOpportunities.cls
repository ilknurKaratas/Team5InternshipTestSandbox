public class ReminderEmailsforDueOpportunities implements Database.Batchable<sObject>, Schedulable {

    public Database.QueryLocator start(Database.BatchableContext BC) {
        String dueOpps = 'SELECT Id, Name, CloseDate, IsClosed, OwnerId FROM Opportunity WHERE IsClosed = False AND (CloseDate = TODAY OR CloseDate = NEXT_N_DAYS:2)';
        return Database.getQueryLocator(dueOpps);
    }

    public void execute(Database.BatchableContext BC, List<Opportunity> oppList) {
        try {
            List<Messaging.SingleEmailMessage> emailsToBeSent = new List<Messaging.SingleEmailMessage>();

            for (Opportunity opp : oppList) {
                User owner = [SELECT Email, Name FROM User WHERE Id = :opp.OwnerId];

                if (owner != null) {
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    List<String> emailAddresses = new List<String>();
                    emailAddresses.add(owner.Email);
                    email.setToAddresses(emailAddresses);
                    email.setSubject(opp.Name + ' Opportunity requires action!');
                    email.setPlainTextBody(
                        'Hello ' + owner.Name + ',\n' +
                        opp.Name + ' Opportunity has to be closed before ' + opp.CloseDate + '.\n' +
                        'Please finalize your sales process.');
                    emailsToBeSent.add(email);
                }
            }

            // Send the reminder emails
            if (emailsToBeSent != null) {
                Messaging.sendEmail(emailsToBeSent);
            }
        } catch (Exception e) {
            System.debug('Exception detected!' + e.getMessage());
        }
    }

    public void finish(Database.BatchableContext BC) {
    }

    public void execute(SchedulableContext SC) {
        ReminderEmailsforDueOpportunities myBatch = new ReminderEmailsforDueOpportunities();
        Database.executeBatch(myBatch);
    }
}