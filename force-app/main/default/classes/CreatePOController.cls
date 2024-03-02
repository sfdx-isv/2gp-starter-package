/**
 * CreatePOController
 */
public class CreatePOController {
    public String   searchString    {get; set;}
    public String   description     {get; set;}
    public Decimal  totalCost       {get; set;}
    public List<SelectOption> selectedVendorIds {get; set;}
    public List<Account> approvedVendors {get; set;}
    /**
     * Constructor
     */
    public CreatePOController() {
        approvedVendors = new List<Account>();
    }
    /**
     * Search for approved vendors
     */
    public void search() {
        if(String.isBlank(searchString) == false) {
            String searchStr = '%' + String.escapeSingleQuotes(searchString) + '%';
            approvedVendors = [SELECT  Id, Name 
                        FROM    Account 
                        WHERE   Name LIKE :searchStr];
        }
    }
    /**
     * Save the Purchase Order
     */
    public PageReference save() {
        Purchase_Order__c po = new Purchase_Order__c();
        po.Description__c = 'Test';
        po.Total_Cost__c = 1000;
        po.Vendor__c = selectedVendorIds[0].getValue();
        insert po;
        return null;
    }
}