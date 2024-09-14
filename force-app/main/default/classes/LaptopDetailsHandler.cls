public with sharing class LaptopDetailsHandler {
   @AuraEnabled(cacheable = true)
   public static List<Purchase_Order__c> getAllPurchaseOrders(){
    try {
        List<Purchase_Order__c> orders = [SELECT Id, Name, Vendor__c, Total_Quantity__c, Order_Status__c, Order_ModelName__c, Order_Date__c, Order_Cost__c FROM Purchase_Order__c];
        if(! orders.isEmpty())
        {
             return orders;
        }
        else{
            return null;
        }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
   }
   @AuraEnabled
   public static string createLaptopDetails(Map<string, Object> laptopData){
    try {
        System.debug('laptop data from java script' + laptopData);
        Laptop__c lap = new Laptop__c();
        lap.Name = (string)laptopData.get('name');
        lap.Status__c = (string)laptopData.get('status');
        lap.Location__c = (string)laptopData.get('location');
        lap.Laptop_Model__c = (string)laptopData.get('model');
        String purchaseDate = (String)laptopData.get('purchaseDate');
        if(purchaseDate != null)
        {
            lap.Purchase_Date__c = date.valueOf(purchaseDate);
        }
        String warrantyExpireData = (String)laptopData.get('warrantyExpirationDate');
        if(warrantyExpireData != null)
        {
            lap.Warranty_ExpirationDate__c = date.valueOf(warrantyExpireData);
        }
        lap.Purchase_Order__c =(Id)laptopData.get('purchaseOrder');

        insert lap;

        System.debug('laptop data in apex' + lap);
        return lap.Id;
        
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
   }
}