import { LightningElement,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getObjects from '@salesforce/apex/GetAllSobjects.getObjects';
import getFields  from '@salesforce/apex/GetAllSobjects.getFields';
import fieldData from '@salesforce/apex/GetAllSobjects.fieldData';
//import deleteSObject from '@salesforce/apex/GetAllSobjects.deleteSObject';
import SearchRecordEditModal from 'c/searchRecordEditModal';
import { deleteRecord } from 'lightning/uiRecordApi';

export default class SearchRecord extends NavigationMixin(LightningElement) {

    //Edit Modal
    handleSelectEvent(detail) {
        console.log('detail object======'+JSON.stringify(detail));
        console.log('chekc----'+JSON.stringify(detail.recordDetail.Id));
        
        const originalRecords = this.dataToShow;
        let index = 0;
        originalRecords.forEach(record => {
            index++;
            if(record.Id == detail.recordDetail.Id){
                index--;
                originalRecords[index] = detail.recordDetail;
            }

        });
        this.dataToShow = originalRecords;
        this.template.querySelector('lightning-datatable').data = this.dataToShow;
      }

    async handleClick() {
        console.log('check handle click');
        const result = await SearchRecordEditModal.open({
            size: 'large',
            description: 'Record Edit Form',
            selectedField:this.selectedFields,
            recordsId:this.recordId,
            objectName:this.selectedObject,
            
            onupdateevent:(e)=>{
                e.stopPropagation();
                console.log('-----------inside updateevent');
                this.handleSelectEvent(e.detail);
            }
        });
    }

    actions = [
                {label:'Edit',name:'edit'},
                {label:'View',name:'view'},
                {label:'Delete',name:'delete'}
            ];
    
    selectedObject;
    
    selectedFields = [];//all fields that selected 
    option = [];
    //For sObjects
    @wire(getObjects) 
    sObjects({data,error}){
        if(data){
            let optionData = [];
            console.log('----data-----');
            for(const [key,value] of Object.entries(data)){
                console.log(key+'---'+value);
                optionData.push({label:value,value:key});
                console.log('label'+key+'---value'+value);
            }
            this.option = optionData;
        }
        else if(error){
            console.log('-------------------ERROR FROM Object------------');
            console.log('-------------------ERROR FROM Object------------');
            console.log('-------------------ERROR FROM Object------------');
        }
    };

    get options(){
        return this.option;
    }
    handleObjectChange(event){
        this.selectedObject = event.detail.value;
        console.log('----selected object--->'+this.selectedObject);
    }

    //for sObject's Fields
    dualbox_option = [];
    @wire(getFields,{objectName:'$selectedObject'})
    objectFields({data,error}){
        if(data){
            let dualboxData = [];
            for(const [key,value] of Object.entries(data)){
                dualboxData.push({label:value,value:key});//,
                console.log('label'+value+'---key--'+key);
            }
            this.dualbox_option = dualboxData;
        }
        else if(error){
            console.log('-------------------ERROR FROM Field------------');
            console.log('-------------------ERROR FROM Field------------');
            console.log('-------------------ERROR FROM Field------------');
        }
    };

    get dualbox_options(){
        return this.dualbox_option;
    }

    /*get selected(){
        return this.selectedFields.length? this.selectedFields:'none';
    }*/

    handleFieldChange(e){
        this.selectedFields = e.detail.value;
    }
    searchedData;
    result;
    error;
    totalRecords = 0;
    pageNumber = 1;
    totalPage = 0;
    recordCount= 5;
    dataToShow = [];

    @track recordId;
    @track showEditForm = false;
    @track paginationData = false;
    @track searchFieldsClicked = false;
    handleSearchFields(){
        this.searchFieldsClicked = true;
    }
    columns = [];
    ///
    handleFocus(){
        console.log('inside handleFocus event');
        event.target.className = event.target.className.replace('slds-has-error','');
    }
    /*handleFocus(event) {
        let input = this.template.querySelector('lightning-input-field');
        input.className = input.className.replace('slds-has-error', '');
    }*/
    ///
    handleSubmitClick(){//remove this after editing
        console.log('==inside handle submit click==');
        this.handleFormSubmit();
    }
    handleFormSubmit(){
        console.log('==inside handle form submit==');
        //event.preventDefault();
        const fields = this.template.querySelectorAll('lightning-input-field');//event.detail.fields;
        console.log('==fields=='+fields);
        const fieldDetail = {};
        if(fields){
            fields.forEach(field=>{
                console.log('==field Name=='+field.fieldName);
                console.log('==field Value=='+field.value);
                fieldDetail[field.fieldName]=field.value;
            });
        }

        this.paginationData = true;
        let columnsArr = [];
        for(let key of this.selectedFields){
            console.log('--testing--'+key);
            columnsArr.push({label:key,fieldName:key});
        }
        columnsArr.push({   label:'Action',
                            type:'action',
                            intialWidth:'100px',
                            typeAttributes:{rowActions:this.actions}});
        this.columns = columnsArr;
        //fieldData({records:JSON.stringify(fields),sObjectName:this.selectedObject})
        console.log('fieldDetail==='+fieldDetail);
        console.log('stringify fielddetail'+JSON.stringify(fieldDetail));
        fieldData({records:JSON.stringify(fieldDetail),sObjectName:this.selectedObject})
        .then(result=>{
            this.searchedData = result;
            //this.result = result;
            this.totalRecords = result.length;
            this.totalPage = Math.ceil(this.totalRecords/this.recordCount);
            this.handlePagination();
        })
        .catch(error=>{
            this.error = error;
        })    
    }
    ////////
    /*handleFormSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        console.log('==fields=='+fields);
        

        this.paginationData = true;
        let columnsArr = [];
        for(let key of this.selectedFields){
            console.log('--testing--'+key);
            columnsArr.push({label:key,fieldName:key});
        }
        columnsArr.push({   label:'Action',
                            type:'action',
                            intialWidth:'100px',
                            typeAttributes:{rowActions:this.actions}});
        this.columns = columnsArr;

        fieldData({records:JSON.stringify(fields),sObjectName:this.selectedObject})
        .then(result=>{
            this.searchedData = result;
            this.result = result;
            this.totalRecords = result.length;
            this.totalPage = Math.ceil(this.totalRecords/this.recordCount);
            this.handlePagination();
        })
        .catch(error=>{
            this.error = error;
        })    
    }*/
    ///////

    firstPage(){
        this.pageNumber = 1;
        this.handlePagination();
    }
    lastPage(){
        this.pageNumber = this.totalPage;
        this.handlePagination();
    }
    nextPage(){
        this.pageNumber = this.pageNumber+1;
        this.handlePagination();
    }
    previousPage(){
        this.pageNumber = this.pageNumber-1;
        this.handlePagination();
    }
    get firstPageState(){ 
        return this.pageNumber == 1;
    }
    get lastPageState(){ 
        return this.pageNumber == this.totalPage;
    }


    handlePagination(){
        let paginationDataTable = [];
        for(let i=((this.pageNumber-1)*(this.recordCount));i<(this.pageNumber * this.recordCount) && i<this.totalRecords;i++){
            paginationDataTable.push(this.searchedData[i]);//result[i]
        }
        this.dataToShow = paginationDataTable;
    }

    handleRowActions(event){
        const actionName = event.detail.action.name;
        console.log('=======================================action name'+actionName);
        const row = event.detail.row;
        this.recordId = row.Id;
        switch(actionName){
            case 'view' : this[NavigationMixin.GenerateUrl]({
                type:'standard__recordPage',
                attributes:{recordId:row.Id,actionName:'view'}
            }).then(url =>{
                window.open(url,'_blank');
            });
            break;
            /*case 'edit': this[NavigationMixin.Navigate]({
                type:'standard__recordPage',
                attributes:{recordId:row.Id,actionName:'edit'}
            });*/
            case 'edit': this.handleClick();
            break;
            case 'delete' : //this.deleteRecord(row);
               const id =  row.Id
            deleteRecord(id)
            .then(()=>{
                console.log('record deleted successfully');
                const toastEvent = new ShowToastEvent({
                title: 'Success Message',
                message: 'Record deleted successfully',
                variant: 'success'
                });
                this.dispatchEvent(toastEvent);
                    

                    /*let index = 0;
                    let mainData = this.searchedData;
                    console.log('==Main Data before =='+JSON.stringify(mainData));
                    mainData.forEach(row => {
                        index++;
                        if(row.Id == id){
                            index--;
                            mainData.splice(index,1);
                            this.searchedData = [...mainData];
                        }
                    });
                    console.log('==Main Data after =='+JSON.stringify(searchedData));*/

                    let index = 0;
                    let originalData = this.dataToShow;

                    console.log('==Original data before=='+JSON.stringify(originalData));
                    console.log('==Main Data before=='+JSON.stringify(this.searchedData));
                    //let originalData = this.result;                 //added
                
                    originalData.forEach(row => {
                        index++;
                        if(row.Id == id){
                            index--;
                            originalData.splice(index, 1);
                            this.dataToShow = [...originalData];
                            //this.searchedData = [...this.searchedData];
                            //this.result = [...originalData];            //added
                        }
                    });

                           /* console.log('page number = '+this.pageNumber);
                            console.log('record count = '+this.recordCount);
                            let number = ((this.pageNumber-1)*(this.recordCount))+index;
                            console.log('number = '+number+'index==='+index);
                            console.log('searched Data before ===>'+JSON.stringify(this.searchedData));
                            this.searchedData.splice(number,1);
                            console.log('searched Data after ===>'+JSON.stringify(this.searchedData));

                    console.log('original data after=='+JSON.stringify(originalData));
                    console.log('==Main Data after=='+JSON.stringify(this.searchedData));*/
                    
                                      
            })
            .catch(error =>{
                console.log('error while deleting record');
                const toastEventError = new ShowToastEvent({
                title:'Error Message',
                message:'Error while deleting',
                variant:'error'
                });
                this.dispatchEvent(toastEventError);
            });
            break;
        }
    }
                    

    
   

    /*deleteRecord(selectedRow){
        deleteSObject({detail:selectedRow})
        .then(result =>{
            console.log('record deleted successfully');
            const toastEvent = new ShowToastEvent({
                title: 'Success Message',
                message: 'Record deleted successfully',
                variant: 'success'
            });
            this.dispatchEvent(toastEvent);
        })
        .catch(error =>{
            console.log('error while deleting record');
            const toastEventError = new ShowToastEvent({
                title:'Error Message',
                message:'Error while deleting',
                variant:'error'
            });
            this.dispatchEvent(toastEventError);
        })
    } */
}