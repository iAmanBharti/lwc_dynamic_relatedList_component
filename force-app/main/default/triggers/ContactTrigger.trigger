trigger ContactTrigger on Contact (before insert,after insert,before update,after update,before delete,after delete) {
    if(Trigger.isBefore){
        System.debug('--Trigger in isBefore--');
        /*if(Trigger.isInsert){
            System.debug('--Trigger in BeforeInsert--');
                ContactTriggerhandler.beforeInsert(Trigger.new);
        }*/
        if(Trigger.isDelete){
            System.debug('--Trigger in BeforeDelete--');
                ContactTriggerHandler.beforeDelete(Trigger.old);
        }
    }
    if(Trigger.isAfter){
        System.debug('--Trigger in isAfter--');
        if(Trigger.isInsert){
            System.debug('--Trigger in AfterInsert--');
            ContactTriggerHandler.afterInsert(Trigger.new,Trigger.newMap);
        }
        /*System.debug('--Trigger in isafter--');
       
            if(Trigger.isUpdate){
                System.debug('--Trigger in AfterUpdate--');
                ContactTriggerHandler.afterUpdate(Trigger.new,Trigger.old);
            }*/
        
    }    
}