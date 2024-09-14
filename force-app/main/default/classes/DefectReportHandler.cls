public with sharing class DefectReportHandler {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getAllContacts()
    {
     return [SELECT Id, LastName, Name FROM Contact];
    }
    @AuraEnabled
    public static string createDefectReport(Map<String, Object> defectReportData){
     System.debug('defect report data------->'+ defectReportData);
         String laptop;
         String selectedContact = (string)defectReportData.get('contact');
         if(selectedContact != null)
         {
            Contact con = [SELECT Id, Name , Laptop__c FROM Contact WHERE Id =: selectedContact LIMIT 1];
            System.debug('selected contact------->'+ con);
            if(con.Laptop__c != null)
            {
                System.debug('old laptop Id------->'+ con.Laptop__c);
                laptop = con.Laptop__c;
                Defect_Report__c dr = new Defect_Report__c();
                dr.Customer_Contact__c = selectedContact;
                dr.Defect_Area__c = (string)defectReportData.get('defectArea');
                dr.Defect_Description__c = (string)defectReportData.get('defectDescription');
                dr.Defect_Severity__c = (string)defectReportData.get('defectSeverity');
                // String reportedDate = (string)defectReportData.get('reportedDate');
                // if(reportedDate != null)
                // {
                //     dr.Reported_Date__c = date.valueOf(reportedDate);
                // }
                 dr.Laptop__c = con.Laptop__c;
                System.debug('new defect report data------>'+ dr);
                insert dr;
                 return dr.Id;
            }else{
              return  null;
            }
           
         }else{
            return null;
         }
    }
 }