public with sharing class AssetInformation {
    @AuraEnabled(cacheable=true)
    
        public static List<Asset> getAllAssets(){
            
    
            
            return [SELECT SerialNumber, Interior_Color__c, Exterior_Color__c, Product2.Name FROM Asset WHERE Opportunity__c = Null];
            
        }
    
        @AuraEnabled
        public static String addAssetToOpportunity(Id opportunityId, List<Id> assetIds) {
    
    
            List<Asset> assets = [SELECT Id, Opportunity__c FROM Asset WHERE Id IN : assetIds];
            List<Asset> newList = new List<Asset>();
            
            // Asset'in Opportunity alanını Opportunity kaydına bağlayın
            for(Asset w : assets){
            w.Opportunity__c = opportunityId;
            newList.add(w);
            }
            // Asset kaydını güncelleyin
            update newList;
    
            
             if (newList.size() != null) {
                return 'successful';
            }else {
                return 'error';
            }
        }
    }