public class Products_Ext{
     public Products_Ext(ApexPages.StandardController c) {
     
    }
        
    @RemoteAction
    public static List<Product2> getproductRecs(){
        return [select id, name, Available__c, Description, Image__c, ProductCode, Family 
        from Product2 order by name limit 50];
        
    }
    
}