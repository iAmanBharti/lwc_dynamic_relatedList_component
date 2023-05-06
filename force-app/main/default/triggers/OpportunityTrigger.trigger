trigger OpportunityTrigger on Opportunity (before insert,after insert,before update,after update,before delete,after delete,after undelete) {
    
    if(Trigger.isAfter && Trigger.isInsert){
        OpportunityTriggerHandler.afterInsert(Trigger.new);
    }

    if(Trigger.isAfter && Trigger.isUpdate){
        OpportunityTriggerHandler.afterUpdate(Trigger.new,Trigger.oldMap);
    }

    if(Trigger.isBefore && Trigger.isDelete){
        OpportunityTriggerHandler.beforeDelete(Trigger.old,Trigger.oldMap);
    }

    if(Trigger.isAfter && Trigger.isUndelete){
        OpportunityTriggerHandler.afterUndelete(Trigger.new);
    }
}