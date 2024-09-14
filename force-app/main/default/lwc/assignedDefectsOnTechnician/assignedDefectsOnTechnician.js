import { api, LightningElement, wire } from 'lwc';
import getAllDefectsAssinedToTechnicxian from '@salesforce/apex/GetAllAsignedDefectsHandler.getAllDefectsAssinedToTechnicxian';
import updateDefectStatus from '@salesforce/apex/GetAllAsignedDefectsHandler.updateDefectStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class AssignedDefectsOnTechnician extends LightningElement {
    @api recordId;
    defectReports = [];
    statusValue;
    statusOptions = [
        { label: 'In Progress', value: 'In Progress' },
        { label: 'Resolved', value: 'Resolved' },
        { label: 'Replacement', value: 'Replacement' }
    ];

    handleStatusChange(event) {
        const selectedId = event.target.dataset.id;
        this.statusValue = event.detail.value;
        console.log('Selected record ID:', selectedId);
        console.log('Selected status value:', this.statusValue);
        updateDefectStatus({defectReportId : selectedId, defectStatus : this.statusValue})
        .then(result =>{
            if(result !== null)
            {
                console.log('status was updated', result);
                this.dispatchEvent(new ShowToastEvent({title : 'Success!',
                    message : 'defect status was updated successfully!',
                    variant : 'success'
                }));
            }else{
                console.log('status was not updated');
            } 
        }).catch(error =>{
            console.log('error while updating defect status');
        })
    }

    connectedCallback() {
        getAllDefectsAssinedToTechnicxian({ recordId: this.recordId })
            .then(data => {
                if (data) {
                    console.log('Record ID:', this.recordId);
                    console.log('Assigned defect reports:', JSON.stringify(data));
                    this.defectReports = data;
                } else {
                    console.log('No data returned from Apex.');
                }
            })
            .catch(error => {
                console.error('Error retrieving defect reports:', error);
            });
    }
}