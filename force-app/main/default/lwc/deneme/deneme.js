import { LightningElement, api, track, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import getAllAssets from '@salesforce/apex/AssetInformation.getAllAssets'
import oppBagla from '@salesforce/apex/AssetInformation.addAssetToOpportunity'
import { CloseActionScreenEvent } from "lightning/actions";
import { refreshApex } from '@salesforce/apex';

export default class AssetSelectionComponentForOpportunity extends LightningElement {

    @api recordId;
    @api selectedRows = [];
    @track data;
    @track columns = [
    { label: 'Serial Number', fieldName: 'SerialNumber', type:'text' },
    { label: 'Interior Color', fieldName: 'Interior_Color__c', type: 'text' },
    { label: 'Exterior Color', fieldName: 'Exterior_Color__c', type: 'text' },
    { label: 'Product', fieldName: 'Product2_Name', type: 'text' },
  ];

  @wire (getAllAssets) butunAssetler({error,data}){
    this.refreshPage = data;
    if(data){
      let accParsedData = JSON.parse(JSON.stringify(data));
      accParsedData.forEach(acc=> {
        if(acc.Product2Id){
          acc.Product2_Name =acc.Product2.Name;
        }
      });
      this.data = accParsedData;
    }
    else if(error){
      this.data = undefined;
    }
  }

  LinkSelection() {
    var selectedRecords = this.template.querySelector("lightning-datatable").getSelectedRows();

    if (selectedRecords.length > 0) {
        selectedRecords.forEach(currentItem => {
            this.selectedRows.push(currentItem.Id);
        });
    }
    oppBagla({ opportunityId: this.recordId, assetIds: this.selectedRows })
        .then (response => {
          if(response == 'successful'){
               this.dispatchEvent(new ShowToastEvent({
               title: 'New Connection',
               message : '***** Successful Connection *****',
               variant : 'success'
           }))} 
           else {
           this.dispatchEvent(new ShowToastEvent({
               title: 'Error',
               message : 'something went wrong',
               variant : 'error'
           }));
          }
          this.dispatchEvent(new CloseActionScreenEvent());
          //location.reload();
          this.dispatchEvent(new refreshApex());
          
       })
        .catch(error => {
            console.error(error);
        });
        
    }
    
}