trigger RepairRequestTrigger on Repair_Request__c (before insert, after update) {
    
    // To Check the warrantyExpired or Not For Repair the Laptop
    if (Trigger.isBefore && Trigger.isInsert) {
        RepairRequestHelper.assignWarrantyPerson(Trigger.new);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
     	RepairRequestHelper.notifyCustomers(Trigger.new);
    }
	
}