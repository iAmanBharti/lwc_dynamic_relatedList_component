public with sharing class GetAllSobjects {//GetAllSobjects.getFields()
    
    @AuraEnabled(Cacheable = true)
    public static Map<String,String> getObjects(){  
        Map<String, Schema.SObjectType> globalObjectMap = Schema.getGlobalDescribe();

        Set<String> sObjectSet = globalObjectMap.keySet();
        List<String> sObjectList = new List<String>(sObjectSet);
        //sObjectList.addAll(sObjectSet);
        sObjectList.sort();
        
        Map<String,String> objectApiNameLabelMap = new Map<String,String>();
        
        for(String obj : sObjectList){//globalObjectMap.keySet()){
            System.debug(obj+'---'+globalObjectMap.get(obj).getDescribe().getLabel());
            //System.debug(globalObjectMap.get(obj).getDescribe());
            if(globalObjectMap.get(obj).getDescribe().isSearchable()){
                //objectApiNameLabelMap.put(obj,String.valueOf(globalObjectMap.get(obj)));
                objectApiNameLabelMap.put(globalObjectMap.get(obj).getDescribe().getName(),globalObjectMap.get(obj).getDescribe().getLabel());
            }   
        }
        
        return objectApiNameLabelMap;
    }

    @AuraEnabled(Cacheable = true)
    public static Map<String,String> getFields(String objectName){
        //String objectName = 'Account';
        System.debug('Object Name-->'+objectName);
        SObjectType sObjectName = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> fieldsMap = sObjectName.getDescribe().fields.getMap();
        //Map<String,Schema.SObjectField> fieldsMap = Schema.SObjectType.Account.fields.getMap();
        Map<String,String> fieldApiNameLabelMap = new Map<String,String>();///////
        for(String field : fieldsMap.keySet()){
            
            //fieldApiNameLabelMap.put(field,String.valueOf(fieldsMap.get(field)));
            fieldApiNameLabelMap.put(fieldsMap.get(field).getDescribe().getName(),fieldsMap.get(field).getDescribe().getLabel());
            System.debug(field+'-----'+fieldsMap.get(field).getDescribe().getLabel()+'----'+fieldsMap.get(field).getDescribe().getName()
            +'---'+fieldsMap.get(field).getDescribe().isNillable());

            
        }
        return fieldApiNameLabelMap;
    }


    // @AuraEnabled(Cacheable = true)
    // public static void getFieldDetails(String objectName,String fieldName){
    //     Schema.DescribeFieldResult field = Account.Rating.getDescribe();
    //     System.debug('--type--'+field.getType());
    //     System.debug('--label--'+field.getLabel());
         
    //     Schema.DescribeFieldResult result =
    //     Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap().get(fieldName).getDescribe();
        
    //     System.debug('---type--'+result.getType());
    //     System.debug('--lable---'+result.getLabel());    
    // }  
    
    @AuraEnabled(Cacheable = true)
    public static List<sObject> fieldData(String records,String sObjectName){
         System.debug('---i am from fieldData----');
         System.debug('Obj Name===>'+sObjectName);
        //Map<String,String> fieldNameValueMap = new Map<String,String>(records);
        // System.debug('-----we are in fieldData method----');
         System.debug('-- first --'+records);
        Map<String,Object> fieldNameValueMap = (Map<String,Object>)JSON.deserializeUntyped(records);
        System.debug('---new Map-'+fieldNameValueMap);
         System.debug('--keyset--'+fieldNameValueMap.keySet());
        //Set<String> columnsSet = fieldNameValueMap.keySet();
        //String columns = String.join((Iterable<String>)columnsSet,', ');
        //System.debug('====columns======'+columns);
        List<String> columnsList = new List<String>(fieldNameValueMap.keySet());
        String columns = String.join(columnsList,', ');
        String objectName = sObjectName;
        //String searchTerm = '%'+String.join(fieldNameValueMap.values(),', ')+'%';
        // System.debug('columns===>'+columns);
        //System.debug('searchTerm===>'+searchTerm);
        //String query = 'SELECT '+columns+' FROM '+objectName+' WHERE '+columns+' LIKE :searchTerm';
        String query = 'SELECT '+columns+' FROM '+objectName;

        //WHERE Name LIKE :'%te%' AND City LIKE :'%ab%'
        //name , city
        Boolean first = true;
        String search= '';
        for(String col : fieldNameValueMap.keySet()){
            if(first && (fieldNameValueMap.get(col) != null)){
                search = '%'+fieldNameValueMap.get(col)+'%';
                query = query + ' WHERE '+col+' LIKE \''+search+'\'';
                first = false;
            }
            else if(!first && (fieldNameValueMap.get(col) != null)){
               search = '%'+fieldNameValueMap.get(col)+'%'; 
                query = query + ' AND '+col+' LIKE \''+search+'\'';
                //search = '';
            }
        }
        System.debug('==query=='+query);
        List<sObject> searchedDataList = Database.query(query);
        System.debug('===>>>'+searchedDataList);
        return searchedDataList;
    }

    

    /*@AuraEnabled(Cacheable = true)
    public static void deleteSObject(SObject detail){
        System.debug('-------------inside delete');
        System.debug('detail----'+detail);
        try {
            System.debug('inside try');
            delete detail;
        } catch (Exception e) {
            System.debug('inside catch');
            throw new AuraHandledException(e.getMessage());
        }
    }*/
}