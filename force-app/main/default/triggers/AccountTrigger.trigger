trigger AccountTrigger on Account (after insert,before insert,before update,after update,before delete,after delete,after undelete) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        AccountTriggerHandler.afterInsert(Trigger.new);
    }
    
/*
    if(Trigger.isAfter && Trigger.isUpdate){
        AccountTriggerHandler.afterUpdate(Trigger.newMap,Trigger.oldMap);
    }
    */
    if(Trigger.isBefore && Trigger.isUpdate){
        if(AccountTriggerHelper.isFirstTime){
            System.debug('============================================inside before update');
            AccountTriggerHandler.calloutUpdate(Trigger.new);
        }
        
    }
}