import { LightningElement, wire } from 'lwc';
import getAllContacts from '@salesforce/apex/DefectReportHandler.getAllContacts';
import createDefectReport from '@salesforce/apex/DefectReportHandler.createDefectReport';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class DefectReport extends LightningElement {
    
    contactList;
    selectedContact;
    reportedDate;
    defectDescription;
    defectSeverity;
    defectStatus;
    defectArea;
    technician;
    laptop;
    severityOptions = [{label : 'Minor', value : 'Minor'},
        {label : 'Major', value : 'Major'},
        {label : 'Critical', value : 'Critical'}
    ];
    statusOptions = [{label : 'Open', value : 'Open'},
        {label : 'In Progress', value : 'In Progress'},
        {label : 'Resolved', value : 'Resolved'},
        {label : 'Closed', value : 'Closed'}
    ];
    defectAreaOptions = [{label : 'MotherBoard', value : 'MotherBoard'},
        {label : 'CPU', value : 'CPU'},
        {label : 'Display', value : 'Display'},
        {label : 'Camera', value : 'Camera'},
        {label : 'Sound', value : 'Sound'},
        {label : 'Battery', value : 'Battery'},
        {label : 'Performence', value : 'Performence'},
        {label : 'TouchPad', value : 'TouchPad'},
        {label : 'Connection', value : 'Connection'},
        {label : 'Processor', value : 'Processor'}
    ];

    @wire(getAllContacts)
    wiredContacts({data, error})
    {
        if(data)
        {
            this.contactList = data.map(contact =>{
                return {label : contact.Name, value : contact.Id};
            });
            console.log('contact list-------->',JSON.stringify(this.contactList));  
        }else if(error)
        {
            console.log('error while getting contacts', error);  
        }
    }
    handleSelectedContact(event)
    {
       this.selectedContact = event.target.value;
       console.log('selected contact------>', this.selectedContact);
    }
    handleDefectStatus(event)
    {
        this.defectStatus = event.target.value;
    }
    handleDefectSeverity(event)
    {
        this.defectSeverity = event.target.value;
    }
    handleDefectDescription(event)
    {
        this.defectDescription = event.target.value;
    }
    handleReportedDate(event)
    {
        this.reportedDate = event.target.value;
    }
    handleDefectArea(event)
    {
        this.defectArea = event.target.value;
    }

    handleCancel()
    {
        console.log('handle cancel');
        
    }
    handleSave()
    {
        console.log('handle save');
        const defectReportData = {
                    contact : this.selectedContact,
                    defectDescription : this.defectDescription,
                    defectSeverity : this.defectSeverity,
                    defectArea : this.defectArea
        };
        console.log('defect report data------->', JSON.stringify(defectReportData));
        createDefectReport({defectReportData : defectReportData})
        .then(response =>{
            console.log('response------->', response);
            if(response != null)
            {
               this.dispatchEvent(new ShowToastEvent({title : 'Success!',
                message : 'Defect Report Created Successfully',
                variant : 'success'
               }));
            }else{
                this.dispatchEvent(new ShowToastEvent({title : 'Error!',
                    message : 'Defect Report is not created',
                    variant : 'error'
                   }));
            }
        }).catch(error =>{
            console.log('error while creating defect report', error);
            
        });
        this.selectedContact = '';
        this.defectDescription = '';
        this.defectSeverity = '';
        this.defectArea = '';
    }
   
}