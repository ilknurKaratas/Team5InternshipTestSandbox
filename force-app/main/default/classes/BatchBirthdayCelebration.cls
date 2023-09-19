public class BatchBirthdayCelebration implements Database.Batchable<sObject>, Schedulable{
    
    
    public Database.QueryLocator start(Database.BatchableContext BC) {
       // collect the batches of records or objects to be passed to execute
       
        Date todaysDate = System.today();
        Integer day = todaysDate.day();
        Integer month = todaysDate.month();
        String query = 'SELECT Id, LastName, FirstName, Email, Birthdate, HasOptedOutOfEmail FROM Contact WHERE CALENDAR_MONTH(Birthdate) =: month AND  DAY_IN_MONTH(Birthdate) =: day';
        
          //CALENDAR_MONTH()	Returns a number representing the calendar month of a date field.(1 for January, 12 for December)
  		  //DAY_IN_MONTH()	Returns a number representing the day in the month of a date field.	(20 for February 20	)
  		    		  
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<Contact> cntList){
        
         try{                          
            List<Messaging.SingleEmailMessage> emailsToBeSend = new List<Messaging.SingleEmailMessage>();
            
            for(Contact cnt : cntList){
                
             if(cnt.Email != null && cnt.HasOptedOutOfEmail != True){		
                    
					Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();  //The instance for the SingleEmailMessage Class                
                   
                 	List<String> listEmails = new List<String>();
                    listEmails.add(cnt.Email);
                 
                    email.setToAddresses(listEmails);
                    email.setSubject('Happy Birthday '+cnt.FirstName+' '+cnt.LastName+'!');
                    email.setPlainTextBody('As Silverline family, we wish you a very happy birthday and'+ '\n'+ ' send you best wishes for much happiness in your life!');              
                
                    emailsToBeSend.add(email);
                 	
                 	          
                }
                
            }               
                Messaging.sendEmail(emailsToBeSend);
                  } catch(exception e){
            
            System.debug('Exception detected!!! ' + e.getMessage());
        }             	
            }
             
    	public void finish(Database.BatchableContext BC){
       
              
    }
    
    public void execute(SchedulableContext SC){
            
            BatchBirthdayCelebration myBatch = new BatchBirthdayCelebration();
            Database.executeBatch(myBatch);
            
        } 
}