public class RepairRequestHelper {

    public static void assignWarrantyPerson(List<Repair_Request__c> repairRequests) {
        for(Repair_Request__c repair : repairRequests){
            if (repair.Laptop__c != null) {
            Laptop__c laptop = [SELECT Warranty_Status__c FROM Laptop__c WHERE Id = :repair.Laptop__c LIMIT 1];
            
            if (laptop.Warranty_Status__c) {
                Technician__c warrantyPerson = [SELECT Id, Name ,Skil_Level__c FROM Technician__c WHERE Skil_Level__c = 'Warranty Specialist' LIMIT 1];
                
                if (warrantyPerson != null) {
                    repair.Assigned_To__c = warrantyPerson.Id;
                    repair.Status__c = 'In Progress';
                } else {
                    System.debug('No available warranty specialist found.');
                }
            }
             else {
                repair.Status__c = 'Warranty Expired';
            }
        	}
        } 
    }
    
    
      // Method to notify the customer once the repair or replacement is completed Via Email . 
    public static void notifyCustomers(List<Repair_Request__c> requests) {
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    	for (Repair_Request__c repair : requests) {
            if (repair.Contact__c != null) {
                	Contact customer = [SELECT Email FROM Contact WHERE Id = :repair.Contact__c LIMIT 1];
                	if (customer.Email != null) {
                        if ((repair.Status__c == 'Completed' || repair.Status__c == 'Replaced')) {
            				// Create email notification
            				Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            				email.setToAddresses(new String[] {customer.Email});
            				email.setSubject('Your Laptop Repair Request is ' + repair.Status__c);
            				email.setPlainTextBody('Dear Customer,\n\nYour repair request for laptop ' + repair.Laptop__c + ' has been ' + repair.Status__c + '.\n\nThank you for your patience.\n\nBest Regards,\nSupport Team');
            
            				emails.add(email);
        				}	
                    }   	
    		}
        }
        
        if (!emails.isEmpty()) {
        	Messaging.sendEmail(emails);
    	}
    }

}