trigger DefectTrigger on Defect_Report__c (before insert, after insert, after update) {
    List<Laptop__c> laptopsToUpdate = new List<Laptop__c>();
    
    for (Defect_Report__c def : Trigger.new) {
        if (def.Status__c == 'Completed' && Trigger.oldMap.get(def.Id).Status__c != 'Completed') {
            Laptop__c laptop = [SELECT Id, Defect_Status__c FROM Laptop__c WHERE Id = :def.Laptop__c LIMIT 1];
            laptop.Defect_Status__c = 'Completed';
            laptopsToUpdate.add(laptop);
        }
    }
    
    if (!laptopsToUpdate.isEmpty()) {
        update laptopsToUpdate;
    }
    if(Trigger.isInsert && Trigger.isBefore)
    {
        Defect_ReportHandler.addDefectReportDate(Trigger.new);
    }
  if(Trigger.isInsert && Trigger.isAfter)
  {
      Defect_ReportHandler.assignTechnicianByDefectArea(Trigger.new);
  }
}