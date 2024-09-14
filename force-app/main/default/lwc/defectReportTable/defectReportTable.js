import { LightningElement, wire, api, track } from 'lwc';
import getOpenTechnicianDefectReports from '@salesforce/apex/DefectReportTableController.getOpenTechnicianDefectReports';
import getContactDefectReports from '@salesforce/apex/DefectReportTableController.getContactDefectReports';
import getAllDefectReports from '@salesforce/apex/DefectReportTableController.getAllDefectReports';

export default class DefectReportTable extends LightningElement {
    @api recordId;
    @track defectReports = [];
    @track error;
    @track isLoading = true;
    @track isTechnicianView = false; // Flag to track if we're viewing technician-specific records

    connectedCallback() {
        this.fetchDefectReports();
    }

    fetchDefectReports() {
        this.isLoading = true;
        console.log('recordId=========>',this.recordId);
        
        // If a recordId exists, determine whether it's a technician or contact, otherwise load all defect reports
        if (this.recordId) {
            // Fetch technician-specific records
            this.getTechnicianDefectReports()
                .then((data) => {
                    if (data && data.length > 0) {
                        this.isTechnicianView = true;
                        this.defectReports = data;
                    } else {
                        // If no technician defect reports, try to fetch contact-specific records
                        this.getContactDefectReports()
                            .then((data) => {
                                if (data && data.length > 0) {
                                    this.defectReports = data;
                                } else {
                                    this.error = 'No records found for the given technician or contact.';
                                }
                            })
                            .catch((error) => {
                                this.error = error;
                            });
                    }
                })
                .catch((error) => {
                    this.error = error;
                })
                .finally(() => {
                    this.isLoading = false;
                });
        } else {
            // Fetch all defect reports if no recordId
            this.getAllDefectReports()
                .then((data) => {
                    this.defectReports = data;
                })
                .catch((error) => {
                    this.error = error;
                })
                .finally(() => {
                    this.isLoading = false;
                });
        }
    }

    // Promises for fetching data
    getTechnicianDefectReports() {
        return getOpenTechnicianDefectReports({ technicianId: this.recordId })
            .then((result) => {
                return result;
            })
            .catch((error) => {
                throw error;
            });
    }

    getContactDefectReports() {
        return getContactDefectReports({ contactId: this.recordId })
            .then((result) => {
                return result;
            })
            .catch((error) => {
                throw error;
            });
    }

    getAllDefectReports() {
        return getAllDefectReports()
            .then((result) => {
                return result;
            })
            .catch((error) => {
                throw error;
            });
    }

    // Computed properties
    get hasDefectReports() {
        return this.defectReports.length > 0;
    }

    get isNoDefectReports() {
        return !this.isLoading && this.defectReports.length === 0;
    }

    get hasError() {
        return !!this.error;
    }
}