public with sharing class TimesheetEntryTriggerHandler {
    
    public static void beforeInsert(List<Timesheet_Entry__c> newTimesheetEntryList){
        TimesheetEntryTriggerHelper.verifyTimesheetInsert(newTimesheetEntryList);
    }
    
    public static void beforeUpdate(List<Timesheet_Entry__c> newTimesheetEntryList,Map<Id,Timesheet_Entry__c> oldTSEMap){
        List<Timesheet_Entry__c> newTSEList = new List<Timesheet_Entry__c>();
        
        for(Timesheet_Entry__c entry : newTimesheetEntryList){
            if(entry.Resource__c != oldTSEMap.get(entry.Id).Resource__c || entry.Start_Time__c != oldTSEMap.get(entry.Id).Start_Time__c || entry.End_Time__c != oldTSEMap.get(entry.Id).End_Time__c){
            	newTSEList.add(entry);
        	}
        }
        if(!newTSEList.isEmpty()){
           //TimesheetEntryTriggerHelper.verifyTimesheetUpdate(newTSEList,oldTSEMap);
           TimesheetEntryTriggerHelper.verifyTimesheetInsert(newTSEList);
        }
        
    }
    
    public static void afterUndelete(List<Timesheet_Entry__c> newTimesheetEntryList){
        TimesheetEntryTriggerHelper.verifyTimesheetInsert(newTimesheetEntryList);
    }
}