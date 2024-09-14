public class LaptopPurchaseService {
    
    public static void createLaptopRecords(List<Purchase_Order__c> purchaseOrders) {
        List<Laptop__c> laptopsToInsert = new List<Laptop__c>();
        
        for (Purchase_Order__c order : purchaseOrders) {
            	Id vendId = order.Vendor__c;
        		Vendor__c vendItems = [SELECT Id, Name FROM Vendor__c WHERE Id =:vendId];
            	// Example logic for creating laptop from a single order            
            	if(order.Order_Status__c == 'Delivered'){
                    Laptop__c laptop = new Laptop__c();
                	laptop.Laptop_Model__c = order.Order_ModelName__c;
                	laptop.Purchase_Date__c = order.Order_Date__c;
                	laptop.Name = vendItems.Name;
                	laptop.Warranty_ExpirationDate__c = order.Order_Date__c.addYears(1); // Example warranty period
                
                	laptopsToInsert.add(laptop);
                }
        }
        
        if (!laptopsToInsert.isEmpty()) {
            try {
                insert laptopsToInsert;
            } catch (DmlException e) {
                System.debug('Error inserting laptops: ' + e.getMessage());
            }
        }
    }
}