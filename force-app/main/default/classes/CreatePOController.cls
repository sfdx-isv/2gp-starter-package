/**
 * CreatePOController
 */
public class CreatePOController {
    public String   searchString    {get; set;}
    public String   description     {get; set;}
    public Decimal  totalCost       {get; set;}
//    public List<SelectOption> selectedVendorIds {get; set;}
    public List<ApprovedVendor> approvedVendors {get; set;}
    public String selectedVendorId {get; set;}
    /**
     * Wrapper class for approved vendors
     */
    public class ApprovedVendor {
        public Account  acc         {get; set;}
        public Boolean  isSelected  {get; set;}
        public ApprovedVendor(Account a) {
            acc = a;
            isSelected = false;
        }
    }


    /**
     * Constructor
     */
    public CreatePOController() {
        approvedVendors = new List<ApprovedVendor>();
    }
    /**
     * Search for approved vendors
     */
    public void search() {
        if(String.isBlank(searchString) == false) {
            // Clear the approvedVendors list
            approvedVendors.clear();
            // Create a dynamic search string based on the user's input
            String searchStr = '%' + String.escapeSingleQuotes(searchString) + '%';
            // Use a SOQL for loop to wrap returned accounts as ApprovedVendor objects.
            for(Account a : [SELECT  Id, Name 
                             FROM    Account 
                             WHERE   Name LIKE :searchStr]) 
            {
                approvedVendors.add(new ApprovedVendor(a));
            }
        }
    }
    /**
     * Save the Purchase Order
     */
    public PageReference save() {

        if (selectedVendorId == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select a vendor.'));
            return null;
        }

        Purchase_Order__c po = new Purchase_Order__c();
        po.Description__c = 'Test';
        po.Total_Cost__c = 1000;
//        po.Vendor__c = selectedVendorIds[0].getValue();
        po.Vendor__c = selectedVendorId;
        insert po;
        return null;
    }
}