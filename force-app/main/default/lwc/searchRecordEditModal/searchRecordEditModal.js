import { api } from 'lwc';
import LightningModal from 'lightning/modal';

export default class MyModal extends LightningModal {
    @api selectedField;
    @api objectName;
    @api recordsId;
    

    handleCloseButton(){
        this.close();
    }

    ///
    handleUpdateButton(e) {
        this.template.querySelector('lightning-record-edit-form').submit();
        const inputFields = this.template.querySelectorAll('lightning-input-field');
       
        const recordDetail = {};
        //const allFields = [];
        recordDetail['Id'] = this.recordsId;
        if (inputFields) {

            inputFields.forEach(field => {
                console.log('Field is==> ' + field.fieldName);
                console.log('Field is==> ' + field.value);
                console.log('id---'+this.recordsId);

                recordDetail[field.fieldName] = field.value;
                //allFields.push(field.fieldName);
            });
        }
        
    
        const newEvent = new CustomEvent('updateevent',{detail:{recordDetail}});
        this.dispatchEvent(newEvent);

        this.close(); 
    } 
}