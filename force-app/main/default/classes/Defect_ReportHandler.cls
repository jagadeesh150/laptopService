public class Defect_ReportHandler {
   //    add report date automatically when report creation 
   @AuraEnabled
   public static void addDefectReportDate(List<Defect_Report__c> allReports)
   {
     System.debug(' before insert trigger');
      for(Defect_Report__c dr: allReports)
      {
          dr.Reported_Date__c = system.today();
          System.debug('defect report  before insert trigger' + dr);
      }
   }

// assign technician automatically based on defect area
   @AuraEnabled(cacheable = true)
    public static void assignTechnicianByDefectArea(List<Defect_Report__c> reports)
    {
        System.debug('defect report==========' + reports);
        String defectedItem;
        String defectReportId; 
        List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
        for(Defect_Report__c dr: reports)
        {
           defectedItem = dr.Defect_Area__c ;
           defectReportId = dr.Id;
           if(defectedItem != null && defectReportId != null)
           {
            List<Technician__c> allTechs = [SELECT Id, Name, Skil_Level__c FROM Technician__c WHERE Skil_Level__c =: defectedItem];
            System.debug('all technicians==========' + allTechs); 
               if(!allTechs.isEmpty())
                {
                  Defect_Report__c dre = [SELECT Id,Technician__c,Laptop__c, Owner.Email FROM Defect_Report__c WHERE Id =: defectReportId LIMIT 1];
                  System.debug('defect report==========' + dre);
                if(dre != null)
                 {
                dre.Technician__c = allTechs[0].Id;
                System.debug('updated defect report==========' + dre);
                System.debug('updated technician name==========' + allTechs[0].Name);
                System.debug('user emial' + dre.Owner.Email);
                update dre;
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            	 email.setToAddresses(new String[] {dre.Owner.Email});
            	 email.setSubject('Your Laptop defect was assigned to  ' + allTechs[0].Name);
            	 email.setPlainTextBody('Dear Customer,\n\nYour repair request for laptop ' + dre.Laptop__c + ' has been assigned to ' + allTechs[0].Name  + '.\n\nThank you for your patience.\n\nBest Regards,\nSupport Team');
            	 emails.add(email);
                
                 }else{
                      System.debug(' no defect report==========' );
                 }
                }else{
                     System.debug(' no technicians there for this defect==========');
                }
           }
            else{
                 System.debug(' no defect report created ==========');
            }
        }
    }
}