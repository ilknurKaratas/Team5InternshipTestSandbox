@isTest
public class ProductCalloutServiceMock implements HttpCalloutMock {
    
    public HTTPResponse respond(HTTPRequest request){
        System.assertEquals('https://wisequarter1--erp.sandbox.my.salesforce.com/services/apexrest/ProductWebService', request.getEndpoint());
        System.assertEquals('GET',request.getMethod());
       
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody('{"prodList":[{"wheelDrive": "Front-Wheel Drive","unitPrice": 100.00,"productName": "Test Product1","productERPId": "01t78000000eME6AAM","productCode": "112233","isActive": true,"gear": "Manual","fuelType": "Diesel","engineCapacity": "1000 to 1500","description": "TESTTT","bodyType": "Sedan"}]}');
        response.setStatusCode(200);
                
        return response;
    }
}