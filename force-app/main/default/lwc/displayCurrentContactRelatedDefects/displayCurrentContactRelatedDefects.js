import { LightningElement, api, track } from 'lwc';
import getContactDefectReports from '@salesforce/apex/DefectReportTableController.getContactDefectReports';

export default class DisplayDefectReports extends LightningElement {
    @api recordId;  // The record ID passed to the component
    @track defectReports = [];
    @track error;
    @track isLoading = true;

    connectedCallback() {
        getContactDefectReports({ recordId: this.recordId })
            .then(data => {
                if (data) {
                    console.log('Record ID:', this.recordId);
                    console.log('Assigned defect reports:', JSON.stringify(data));
                    this.defectReports = data;
                } else {
                    console.log('No data returned from Apex.');
                    this.defectReports = [];
                }
            })
            .catch(error => {
                console.error('Error retrieving defect reports:', error);
                this.error = error;
                this.defectReports = [];
            })
            .finally(() => {
                this.isLoading = false;
            });
    }
}