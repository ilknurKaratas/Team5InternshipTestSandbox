@isTest
public class ProductCalloutTest {
    
    @isTest
    private static void TestProductCallout(){
        ProductCalloutServiceMock mock = new ProductCalloutServiceMock();
        Test.startTest();
        Test.setMock(HttpCalloutMock.Class, mock);
        //ProductCallout.ProductRest();
        ProductCallout.productList();
        Test.stopTest();
        System.assertEquals(1, [Select Count() From Product2]);
    }
}