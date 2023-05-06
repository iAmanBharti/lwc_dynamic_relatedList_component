import { LightningElement } from 'lwc';
export default class helloWorld extends LightningElement {
 /*greeting = 'World';
  changeHandler(event) {
    this.greeting = event.target.value;
  }*/
  /*show = true;
  handleClick(){
    this.show = !this.show;
  }*/
  //text = 'This text came from a JS prop';
  /*handleChange(event){
    this.text = event.target.value;
  }*/
  name = 'Electra X4';
  description = 'A bike';
  category='Mountain';
  material='Vibranium';
  price='54321';
  pictureUrl='https://s3-us-west-1.amazonaws.com/sfdc-demo/ebikes/electrax4.jpg';
  ready = false;
  connectedCallback(){
    setTimeout(() => {this.ready = true;},3000)
  }
}