import { LightningElement } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DefectReportForm extends LightningElement {
    handleSuccess(event) {
        const evt = new ShowToastEvent({
            title: 'Success',
            message: `Record created with Id: ${event.detail.id}`,
            variant: 'success'
        });
        this.dispatchEvent(evt);
        this.template.querySelector('lightning-record-edit-form').reset();
    }

    handleError(event) {
        const evt = new ShowToastEvent({
            title: 'Error',
            message: event.detail.message,
            variant: 'error'
        });
        this.dispatchEvent(evt);
    }
    
    handleSubmit(event) {
        // Optional: Add custom logic before form submission if needed.
        console.log('Form is being submitted.');
    }

    handleAnotherAction() {
        // Optional: Add custom logic for another button action.
        console.log('Another button clicked');
    }
}