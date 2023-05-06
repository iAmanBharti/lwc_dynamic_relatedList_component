import { LightningElement,track } from 'lwc';

export default class Child2 extends LightningElement {
    @track username;
    constructor(){
        super();
        let name = 'aman';
        if(name){
            this.userName = 'Aman Bharti';
        }
        //this.template.querySelector('p');
        console.log('in child2 js');
    }
}