public with sharing class TimesheetEntryTriggerHelper {
    public static void verifyTimesheetInsert(List<Timesheet_Entry__c> newTimesheetEntryList){
        Set<Id> resourceSet 	= new Set<Id>();
        Set<Id> timesheetIdSet	= new Set<Id>();			//added
        Datetime maxDateTime = Datetime.newInstance(1700, 1, 1, 0, 0, 0);
		Datetime minDateTime = Datetime.newInstance(9999, 12, 31, 23, 59, 59);
        
        for(Timesheet_Entry__c entry: newTimesheetEntryList){
           
            datetime myDate = datetime.now();
            if(entry.Start_Time__c == entry.End_Time__c){
                entry.addError('Start and End Time not be same');
                return;
            }
            if(!myDate.isSameDay(entry.Start_Time__c)){
                entry.addError('Only Today\'s Data Entry allow');
                return;
            }
            if(!(entry.Start_Time__c < entry.End_Time__c)){
                entry.addError('End Time must be greater then Start Time');
            }
            
            resourceSet.add(entry.Resource__c);
            timesheetIdSet.add(entry.Timesheet__c);			//added
            if(minDateTime > entry.Start_Time__c){
                minDateTime = entry.Start_Time__c;
            }
            if(maxDateTime < entry.End_Time__c){
                maxDateTime = entry.End_Time__c;
            }
        }
        //System.debug('Set = '+resourceSet);
        //same time(),start end same(10:00,10:00),date same
        /*List<Timesheet_Entry__c> tseList2 = [SELECT Id,Start_Time__c,End_Time__c,Resource__c 
                                            FROM Timesheet_Entry__c 
                                            WHERE Resource__c IN : resourceSet 
                                            	AND (//(Start_Time__c <: minDate AND End_Time__c >: maxDate) OR 
                                            		(Start_Time__c >: minDate AND End_Time__c <: maxDate) OR 
                                            		(Start_Time__c <: minDate AND End_Time__c >: minDate) OR 
                                            		(Start_Time__c <: maxDate AND End_Time__c >: maxDate))];*/
        
        List<TimeSheet_Entry__c> tseList = [SELECT Id,Start_Time__c,End_Time__c,Resource__c,Timesheet__c FROM Timesheet_Entry__c 
                                             WHERE Timesheet__c IN : timesheetIdSet AND Resource__c IN : resourceSet AND (End_Time__c >: minDateTime AND Start_Time__c <: maxDateTime)];
        
        //System.debug(tseList);//////  (10:00-11:00),(11:00-12:00),(12:00-1:00) =>	(10:15-10:45),(09:50-01:20),(10:15-11:15),(09:15-11:15)
        //System.debug(tseList2);
        //end time < tse.start time  && start time > tse.end time//go
        ////add map
        //must works on diff Timesheet -> 
        Map<Id, List<Timesheet_Entry__c>> tseMap = new Map<Id, List<Timesheet_Entry__c>>();
        for(TimeSheet_Entry__c tse: tseList){
            if (!tseMap.containsKey(tse.Resource__c)) {
                tseMap.put(tse.Resource__c, new List<Timesheet_Entry__c>());
            }
            tseMap.get(tse.Resource__c).add(tse);
        }
        
        
        for(Timesheet_Entry__c entry : newTimesheetEntryList){//
            if(tseMap.containsKey(entry.Resource__c)){
               for(Timesheet_Entry__c tse :tseMap.get(entry.Resource__c)){
                   if(!(entry.End_Time__c < tse.Start_Time__c && entry.Start_Time__c > tse.End_Time__c) && entry.Timesheet__c == tse.Timesheet__c){
                       entry.addError('Start Time or End Time don\'t override');
                   }
            	} 
            }
        }
        ////
        /*for(Timesheet_Entry__c tse : tseList){
            for(Timesheet_Entry__c entry : newTimesheetEntryList){
                if((entry.Resource__c == tse.Resource__c) && 
                   ((entry.Start_Time__c > tse.Start_Time__c && entry.Start_Time__c < tse.End_Time__c) ||	//start time in bt
                    (entry.End_Time__c > tse.Start_Time__c && entry.End_Time__c < tse.End_Time__c) ||		//end time in bt
                    (entry.Start_Time__c < tse.Start_Time__c && entry.End_Time__c > tse.End_Time__c) ||		//both outside
                    (entry.Start_Time__c == tse.Start_Time__c && entry.End_Time__c == tse.End_Time__c)		//same time
                   )){
                    	entry.addError('Start Time or End Time don\'t override');
                }
            }
        }*/
    }
}