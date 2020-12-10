public with sharing class AccountMapService {

    @AuraEnabled(cacheable=true)
    public static List<Location> getAccountLocation(String recordId) {

        // ref: https://rajvakati.com/2018/12/30/lightning-web-component-google-maps/

        List< Account> accs =  [SELECT Id, Name,Type, Industry, BillingAddress, BillingStreet,
        BillingCity, BillingCountry, BillingPostalCode, BillingState, BillingLatitude, BillingLongitude FROM Account WHERE Id = :recordId]; 

        List<Location> loc = new List<Location>();
        for(Account acc :accs){
            GeoLocation geoInfo = new GeoLocation();
            geoInfo.Street = acc.BillingStreet;
            geoInfo.PostalCode = acc.BillingPostalCode;
            geoInfo.City = acc.BillingCity;
            geoInfo.State = acc.BillingState;
            geoInfo.Country = acc.BillingCountry;

            Location locDetail = new Location();
            locDetail.icon = 'action:map'; 
            locDetail.title = acc.Name;
            locDetail.description = acc.Name;
            locDetail.latitude = acc.BillingLatitude;
            locDetail.longitude = acc.BillingLongitude;
            locDetail.location = geoInfo;
        
            loc.add(locDetail);

            System.debug('lat: ' + acc.BillingLatitude);
        }
        return loc ;

    }

    public class Location{
        @AuraEnabled 
        public String icon{get;set;} 
        @AuraEnabled 
        public String title{get;set;} 
        @AuraEnabled
        public String description{get;set;} 
        @AuraEnabled
        public Double latitude{get;set;} 
        @AuraEnabled
        public Double longitude{get;set;} 
        @AuraEnabled 
        public GeoLocation location{get;set;} 
    }
    public class GeoLocation{
        @AuraEnabled 
        public String Street{get;set;}
        @AuraEnabled 
        public String PostalCode{get;set;}
        @AuraEnabled 
        public String City{get;set;}
        @AuraEnabled 
        public String State{get;set;}
        @AuraEnabled 
        public String Country{get;set;}
    }
}
