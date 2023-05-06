trigger TimesheetEntryTrigger on Timesheet_Entry__c (before insert,after insert,before update,after update,before delete,after delete,after undelete){
    
    if(Trigger.isBefore && Trigger.isInsert){
        TimesheetEntryTriggerHandler.beforeInsert(Trigger.new);
    }
    
    if(Trigger.isBefore && Trigger.isUpdate){
        TimesheetEntryTriggerHandler.beforeUpdate(Trigger.new,Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUndelete){
        TimesheetEntryTriggerHandler.afterUndelete(Trigger.new);
    }
}