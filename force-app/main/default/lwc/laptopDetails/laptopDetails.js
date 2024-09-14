import { api, LightningElement, wire } from 'lwc';
import getAllPurchaseOrders from '@salesforce/apex/LaptopDetailsHandler.getAllPurchaseOrders';
import createLaptopDetails from '@salesforce/apex/LaptopDetailsHandler.createLaptopDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class LaptopDetails extends LightningElement {
    @api recordId;
    isPopUp = false;
    laptopName;
    laptopDescription;
    laptopModel;
    laptopPurchaseDate;
    warrantyExpirationDate;
    laptopStatus;
    location;
    purchaseOrdersData;
    statusValues = [{label : 'Available', value : 'Available'},
        {label : 'In Use', value : 'In Use'},
        {label : 'Defective	', value : 'Defective'},
        {label : 'Replaced', value : 'Replaced'}];

    @wire(getAllPurchaseOrders)
    wiredData({data,error})
    {
        if(data)
        {
           this.purchaseOrdersData = data;
           console.log('purchase order data', JSON.stringify(this.purchaseOrdersData));
           
        }else if(error)
        {
            console.log('error at getting purchase order data', error);
        }
    }

    handleClickOnLaptop()
    {
        this.isPopUp = true;
    }
    handleLaptopNameChange(event)
    {
        this.laptopName = event.target.value;
    }
    handleLaptopDescriptionChange(event)
    {
        this.laptopDescription = event.target.value;
    }
    handleLaptopModelChange(event)
    {
        this.laptopModel = event.target.value;
    }
    handleLaptopPurchaseDateChange(event)
    {
        this.laptopPurchaseDate = event.target.value;
    }
    handleWarrantyExpirationDateChange(event)
    {
        this.warrantyExpirationDate = event.target.value;
    }
    handleLocationChange(event)
    {
        this.location = event.target.value;
    }
    handleLaptopStatusChange(event)
    {
        this.laptopStatus = event.target.value;
    }


    handleSaveOnLaptopDetails()
    {
      console.log('handle save');
      const laptopData = {
            name : this.laptopName,
            description : this.laptopDescription,
            model : this.laptopModel,
            purchaseDate : this.laptopPurchaseDate,
            warrantyExpirationDate : this.warrantyExpirationDate,
            status : this.laptopStatus,
            location : this.location,
            purchaseOrder : this.recordId
      };
      console.log('laptop data--------->',JSON.stringify(laptopData)); 
      createLaptopDetails({laptopData : laptopData}).then(result => {
          console.log('result',JSON.stringify(result));
           if(result)
           {
              this.dispatchEvent(new ShowToastEvent({title : 'Success!',
                message : 'Laptop details saved successfully',
                variant : 'success'
              }));
           }
           else{
            this.dispatchEvent(new ShowToastEvent({title : 'Error!',
                message : 'Error at saving Laptop details  ',
                variant : 'error'
              }));
           }
      });
      this.isPopUp = false;
      
    }
    handleCancelOnLaptopDetails()
    {
        this.isPopUp = false;
    }
}