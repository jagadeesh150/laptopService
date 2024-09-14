public with sharing class GetAllAsignedDefectsHandler {
   @AuraEnabled(cacheable = true)
   public static List<Defect_Report__c> getAllDefectsAssinedToTechnicxian(String recordId){
    try {
        System.debug('record id from js---->' + recordId);
        List<Defect_Report__c> allReports = [SELECT Id, Name, Reported_Date__c, Technician__c, Defect_Severity__c, Defect_Description__c, Defect_Area__c, Laptop__c FROM Defect_Report__c WHERE Technician__c =: recordId];
        System.debug('All assigned defect reports to technician ' + allReports);
        if(!allReports.isEmpty())
        {
            return allReports;
        }else{
            return null;
        }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
   }
   @AuraEnabled
   public static string updateDefectStatus(String defectReportId, String defectStatus){
    try {
        System.debug('defect report id------>' + defectReportId + 'defect report status--->' + defectStatus);
        if(defectReportId != null && defectStatus != null)
        {
            Defect_Report__c defectReport = [SELECT Id, Name, Defect_Severity__c, Defect_Area__c, Status__c FROM Defect_Report__c WHERE Id =: defectReportId LIMIT 1];
        System.debug('defect report id and severity------>' + defectReport);
        if(defectReport != null)
        {
             defectReport.Status__c = defectStatus;
             System.debug('defect report id and severity------>' + defectReport);
             update defectReport;
             return 'defect reported updated with status ' + defectReport.Status__c;
        }else{
            return null;
        }
        }else{
            return null;
        }
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
   }
}