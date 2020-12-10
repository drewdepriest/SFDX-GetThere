import { LightningElement,api,wire,track} from 'lwc';
import getAccountLocation from '@salesforce/apex/AccountMapService.getAccountLocation';
import UberButton from '@salesforce/resourceUrl/UberButton';


//dropoff[latitude]=37.789816&dropoff[longitude]=-122.396905

export default class GetThereMap extends LightningElement {

    @api UBER_CLIENT_ID = '0MTJs5f-0d46tBM4cMBpZeHtjzOSiiqf';

    @track accounts;
    @track error;
    @track showFooter = true ;
    @track currentRecordId;

    uberButtonUrl = UberButton;

    @track uberLinkUrl = 'https://m.uber.com/ul/?action=setPickup&dclient_id=' + '0MTJs5f-0d46tBM4cMBpZeHtjzOSiiqf' + '&pickup=my_location';

    // this record's Id
    @api recordId;

    mapMarkers = [];
    isLoading = true;
    isRendered;

     // get the location list of the account
     @wire(getAccountLocation,{recordId: '$recordId'})
     wiredAccounts({error,data}) {
         if (data) {
             this.accounts = data;
             console.log(data);

             this.uberLinkUrl += '&dropoff[formatted_address]=';
             this.uberLinkUrl += data[0].location.Street + ' ';
             this.uberLinkUrl += data[0].location.City + ' ';
             this.uberLinkUrl += data[0].location.State;
            
            this.uberLinkUrl += '&dropoff[latitude]=' + data[0].latitude;
            this.uberLinkUrl += '&dropoff[longitude]=' + data[0].longitude;

             console.log(JSON.stringify(data, null, '\t'));


         } else if (error) {
             console.log(error);
             this.error = error;
         }
     }
    
     connectedCallback() {
        this.currentRecordId = this.recordId;

    }

    
}
