import { LightningElement,api } from 'lwc';
import getRelatedRecords from '@salesforce/apex/RelatedListController.getRelatedRecords';
import { NavigationMixin } from 'lightning/navigation';
import { deleteRecord } from 'lightning/uiRecordApi';



export default class RelatedList extends NavigationMixin(LightningElement) {
    @api objectAPIName;
    @api fieldsName;
    @api actions;
    @api recordCount;
    @api sortField;
    @api objectLabel;
    @api filter;

    data = []; //array of data getting from apex
    columns = [];
    action = [];
    title = '';//object Name + record count , shows as title for related list header
    count = 0;//count of records 
    actions = [
                {label:'Edit',name:'edit'},
                {label:'Delete',name:'delete'}
            ];
    
    // navigate to 'New' record creation page
    navigateNew(){
        this[NavigationMixin.Navigate](
            {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: this.objectAPIName,
                    actionName: 'new'
                }
            }
        );
    }
    
    connectedCallback(){
        let fieldsData = JSON.parse(this.fieldsName);
        let fieldNamesArr = [];
        let fieldNames = '';

        for(let field of fieldsData.fields){
            fieldNamesArr.push(field.queryField);
            this.columns.push({label:field.label,fieldName:field.fieldName,type:field.type,typeAttributes:{
                                                                                                            label:{fieldName:field.queryField.replace('.','_')},
                                                                                                            tooltip:{fieldName:field.queryField.replace('.','_')}}});
        }
        fieldNames = fieldNamesArr.toString();
        this.columns.push({ type:'action',
                            intialWidth:'100px',
                            typeAttributes:{rowActions:this.actions}});   
        getRelatedRecords({objName : this.objectAPIName, fieldsName : fieldNames, recordCount : this.recordCount, sortField : this.sortField, filter : this.filter})
        .then((data)=>{
            this.count  = data.length;
            this.title = this.objectLabel+' '+this.count;
            this.data = data;
                for(let key of this.data){
                   for(let field of fieldsData.fields){
                        if(field.referenceField == 'true'){
                            key[field.fieldName] = '/'+key[field.fieldName];
                        }
                        else{
                            key[field.fieldName] = key[field.fieldName];
                        }
                        if(field.queryField.includes('.')){
                            key[field.queryField.replace('.','_')] = key[field.queryField.split('.')[0]][field.queryField.split('.')[1]];
                        }
                        else{
                            key[field.queryField] = key[field.queryField];                        
                        }  
                    }
                }
        })
        .catch((error)=>{
            const event = new ShowToastEvent({
                title:'Error',
                message:'Records Not Found !'
            });
            this.dispatchEvent(event);
        });
        
    }

    navigateToObjectHome() {
        // Navigate to the Case object home page.
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.objectAPIName,
                actionName: 'home'
            }
        });
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'edit': this[NavigationMixin.Navigate]({
                type:'standard__recordPage',
                attributes: {
                    recordId:row.Id.replace('/',''),
                    objectApiName:this.objectAPIName,
                    actionName:'edit'
                }
            });
            break;
            case 'delete' : 
            const id =  row.Id.replace('/','');
            deleteRecord(id)
            .then(()=>{
                let index = 0;
                let originalData = this.data;            
                originalData.forEach(row => {
                                                index++;
                                                if(row.Id.replace('/','') == id){
                                                    index--;
                                                    originalData.splice(index, 1);
                                                    this.data = [...originalData];
                                                }
                                            });                        
            })
            .catch(error =>{
                const event = new ShowToastEvent({
                    title:'Error',
                    message:'Fail To delete record !'
                });
                this.dispatchEvent(event);
            });
            break;
        }
    }
    
}