public with sharing class DefectReportController {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getCustomerContacts(String searchKey) {
        return [SELECT Id, Name FROM Contact WHERE Name LIKE :('%' + searchKey + '%') LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Laptop__c> getLaptops(String searchKey) {
        return [SELECT Id, Name FROM Laptop__c WHERE Name LIKE :('%' + searchKey + '%') LIMIT 10];
    }

    @AuraEnabled(cacheable=true)
    public static List<Technician__c> getTechnicians(String searchKey) {
        return [SELECT Id, Name FROM Technician__c WHERE Name LIKE :('%' + searchKey + '%') LIMIT 10];
    }

    @AuraEnabled
    public static Id createDefectReport(String customerContactId, String defectSeverity, String laptopId, Date reportedDate, String technicianId, String status, String defectDescription) {
        Defect_Report__c newDefect = new Defect_Report__c(
            Customer_Contact__c = customerContactId,
            Defect_Severity__c = defectSeverity,
            Laptop__c = laptopId,
            Reported_Date__c = reportedDate,
            Technician__c = technicianId,
            Status__c = status,
            Defect_Description__c = defectDescription
        );
        insert newDefect;
        return newDefect.Id;
    }
}