public with sharing class DefectReportTableController {
    public class DefectReportWrapper {
        @AuraEnabled public String Id { get; set; }
        @AuraEnabled public String CustomerContactName { get; set; }
        @AuraEnabled public String DefectDescription { get; set; }
        @AuraEnabled public String Name { get; set; }
        @AuraEnabled public String DefectSeverity { get; set; }
        @AuraEnabled public String LaptopName { get; set; }
        @AuraEnabled public String TechnicianName { get; set; }
        @AuraEnabled public String Status { get; set; }
    }

    @AuraEnabled(cacheable=true)
    public static List<DefectReportWrapper> getAllDefectReports() {
        System.debug('Fetching all defect reports');
        
        List<Defect_Report__c> defectReports = [
            SELECT Id, Customer_Contact__r.Name, Defect_Description__c, Name, Defect_Severity__c, 
                   Laptop__r.Name, Technician__r.Name, Status__c
            FROM Defect_Report__c
        ];
        
        System.debug('Defect Reports fetched: ' + defectReports);
        
        return convertToWrapper(defectReports);
    }

    @AuraEnabled(cacheable=true)
    public static List<DefectReportWrapper> getContactDefectReports(String contactId) {
        System.debug('Fetching defect reports for contactId: ' + contactId);
        
        List<Defect_Report__c> defectReports = [
            SELECT Id, Customer_Contact__r.Name, Defect_Description__c, Name, Defect_Severity__c, 
                   Laptop__r.Name, Technician__r.Name, Status__c
            FROM Defect_Report__c
            WHERE Customer_Contact__c = :contactId
        ];
        
        System.debug('Defect Reports fetched for contact: ' + defectReports);
        
        return convertToWrapper(defectReports);
    }

    @AuraEnabled(cacheable=true)
    public static List<DefectReportWrapper> getOpenTechnicianDefectReports(Id technicianId) {
        System.debug('Fetching open defect reports for technicianId: ' + technicianId);
        
        List<Defect_Report__c> defectReports = [
            SELECT Id, Customer_Contact__r.Name, Defect_Description__c, Name, Defect_Severity__c, 
                   Laptop__r.Name, Technician__r.Name, Status__c
            FROM Defect_Report__c
            WHERE Technician__c = :technicianId AND Status__c = 'Open'
        ];
        
        System.debug('Open Defect Reports fetched for technician: ' + defectReports);
        
        return convertToWrapper(defectReports);
    }

    private static List<DefectReportWrapper> convertToWrapper(List<Defect_Report__c> defectReports) {
        System.debug('Converting defect reports to wrappers');
        
        List<DefectReportWrapper> defectReportWrappers = new List<DefectReportWrapper>();
        for (Defect_Report__c defect : defectReports) {
            DefectReportWrapper wrapper = new DefectReportWrapper();
            wrapper.Id = defect.Id;
            wrapper.CustomerContactName = defect.Customer_Contact__r != null ? defect.Customer_Contact__r.Name : null;
            wrapper.DefectDescription = defect.Defect_Description__c;
            wrapper.Name = defect.Name;
            wrapper.DefectSeverity = defect.Defect_Severity__c;
            wrapper.LaptopName = defect.Laptop__r != null ? defect.Laptop__r.Name : null;
            wrapper.TechnicianName = defect.Technician__r != null ? defect.Technician__r.Name : null;
            wrapper.Status = defect.Status__c;
            defectReportWrappers.add(wrapper);
        }
        
        System.debug('Converted Defect Report Wrappers: ' + defectReportWrappers);
        
        return defectReportWrappers;
    }
}