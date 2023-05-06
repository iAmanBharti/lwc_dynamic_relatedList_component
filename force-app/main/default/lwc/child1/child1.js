import { LightningElement,track,api } from 'lwc';

export default class Child1 extends LightningElement {
    @track username;
    constructor(){
        super();
        let name = 'aman';
        if(name){
            this.userName = 'Aman Bharti';
        }
        //this.template.querySelector('p');
        console.log('in child1 js');
    }
}