trigger CaseTrigger on Case (before insert,before update){
    
    if(Trigger.isBefore && Trigger.isInsert){
        CaseTriggerHandler.beforeInsert(Trigger.new);
    }
    /*if(!checkRecursive.firstTime){
        checkRecursive.firstTime = true;
        if(Trigger.isBefore && Trigger.isUpdate){
        	System.debug('------>Before update<-------');
        	CaseTriggerHandler.beforeUpdate(Trigger.newMap,Trigger.oldMap);
    	}
    }*/
    
}