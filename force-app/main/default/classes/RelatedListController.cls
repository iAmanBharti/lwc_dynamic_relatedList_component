/******************************************************************************************************************************************************
 * @name            RelatedListController
 * @description     Provide records for relatedList LWC Component 
 * @date            04/05/2023
 * @createdby       Aman Bharti
 ******************************************************************************************************************************************************
 * Version                  Author                  Date                Comments
 * 1.0                Delta CX Consulting         04/05/2023
 ******************************************************************************************************************************************************/

public with sharing class RelatedListController {
    /**
     * @description
     * @param objName String
     * @param fieldsName String
     * @param recordCount Integer
     * @param sortField String
     * @param filter String
     * @return List<SObject>
     */
    @AuraEnabled(Cacheable = true)
    public static List<SObject> getRelatedRecords(String objName, String fieldsName, Integer recordCount, String sortField, String filter){
        //System.debug('object Name = '+objName+' And count = '+recordCount);
        //String query = 'SELECT '+fieldsName+' FROM '+objName +' ORDER BY '+sortField+' LIMIT '+recordCount;
        String query = 'SELECT '+fieldsName+' FROM '+objName;
        if(filter != null){
            query += ' '+filter;
        }
        if(sortField != null){
            query += ' ORDER BY '+sortField;
        }
        if(recordCount >= 0){
            query += ' LIMIT '+recordCount;
        }

        System.debug('Query => '+query);
       	System.debug(Database.query(query));
        System.debug('ok');
        System.debug('two');
        System.debug('three');
        System.debug('four');
        System.debug('five');
        //test cmt
        //another test data
        //one more cmt////
        /*//
        //
        /

        some addition
        abcdefghijklm
        some addition
        some addition
        some addition
        some addition


         */
        return Database.query(query);
    } 
}