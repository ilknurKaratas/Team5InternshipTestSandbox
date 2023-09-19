public class ProductCallout {
    
   @future(callout=true)
    public static VOID productList(){
        
        
       	Http http = new Http();
        
        HttpRequest request = new HttpRequest();
        	request.setMethod('GET');
        	request.setEndpoint('https://wisequarter1--erp.sandbox.my.salesforce.com/services/apexrest/ProductWebService'); 
        	request.setHeader('Authorization', 'Bearer 00D780000008gDM!AQcAQMo61WUBCteiJyUaxyRgqzgXbjPao.GgglFt6puvEisRJpfYEKYOGQxRJx0Qdups3R1CC76cAQtibgbu9zsa2YDhC5ld' );
        
        HttpResponse response = http.send(request);
        
           //ERP den gelen musteri listesi response.getBody() icindedir.
        String productJson = response.getBody();
        
        //Gelen body icerisinde JSON olarak gelen listeyi sObject deserialize ediyoruz.
        ProductResponse proFromJson =  (ProductResponse)JSON.deserialize(productJson, ProductResponse.class);
        List<ProductContainer> productFromJson = proFromJson.prodList;
      
       
        List<Product2> proList = new List<Product2>();
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>() ;
        
        // Get the Id of the standard price book
    /*   Pricebook2 stdPriceBook = [SELECT Id FROM Pricebook2 WHERE IsStandard = true LIMIT 1];
       Id standardPricebookId = stdPriceBook.Id ; */
		              
        for(productContainer myProduct : productFromJson){
            
            Product2 pro = new Product2();
         	            
            pro.Name = myProduct.productName;
            pro.Description = myProduct.description;
            pro.ProductCode = myProduct.productCode;
            pro.Wheel_Drive__c = myProduct.wheelDrive;
            pro.Gear__c = myProduct.gear;
            pro.Body_Type__c = myProduct.bodyType;
            pro.Engine_Capacity_cc__c = myProduct.engineCapacity;
            pro.Fuel_Type__c = myProduct.fuelType;
            pro.IsActive = myProduct.isActive;
            pro.ExternalId = myProduct.productERPId;
           	pro.Helper_Unit_Price__c = myProduct.unitPrice;
            proList.add(pro);
    
      }	
           insert proList;
     /*   
        for (Product2 product : proList) {
            
            PricebookEntry associatedPricebookEntry = new PricebookEntry();
            associatedPricebookEntry.Product2Id = product.Id;
            associatedPricebookEntry.UnitPrice = product.Helper_Unit_Price__c;
            associatedPricebookEntry.Pricebook2Id = standardPricebookId;
            pricebookEntries.add(associatedPricebookEntry);
        }
        
           insert pricebookEntries;
         
*/}

	 		 
        }