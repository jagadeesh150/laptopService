trigger LaptopOrderTrigger on Purchase_Order__c (after insert, after update){
    
    if (Trigger.isAfter && Trigger.isInsert) {
        LaptopPurchaseService.createLaptopRecords(Trigger.new);
    }
    if (Trigger.isAfter && Trigger.isUpdate) {
        List<Purchase_Order__c> approvedOrders = new List<Purchase_Order__c>();
        for (Purchase_Order__c po : Trigger.new) {
            if (po.Order_Status__c == 'Delivered' && Trigger.oldMap.get(po.Id).Order_Status__c != 'Delivered') {
                approvedOrders.add(po);
            }
        }
        if (!approvedOrders.isEmpty()) {
            LaptopPurchaseService.createLaptopRecords(approvedOrders);
        }
    }
}