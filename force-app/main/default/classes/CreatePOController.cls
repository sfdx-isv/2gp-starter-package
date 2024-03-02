/**
 * CreatePOController
 */
public class CreatePOController {
    /**
     * Properties
     */
    public String   searchString        {get; set;}
    public String   description         {get; set;}
    public Decimal  totalCost           {get; set;}
    public String   selectedVendorId    {get; set;}
    public List<ApprovedVendor> approvedVendors {get; set;}
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
        // Clear any `approvedVendors` that were not selected, and save the IDs of the selected vendors.
        Set<Id> selectedVendorIds = new Set<Id>();
        for(Integer i = 0; i < approvedVendors.size(); i++) {
            if(approvedVendors[i].isSelected == false) {
                approvedVendors.remove(i);
            } else {
                selectedVendorIds.add(approvedVendors[i].acc.Id);
            }
        }
        // Create the appropriate search string based on the user's input.
        String searchStr = 'SELECT  Id, Name, Phone, Website FROM Account ';
        if(String.isBlank(searchString)) {
            searchStr += 'WHERE Name LIKE \'%' + String.escapeSingleQuotes(searchString) + '%\' ';
        }
        // Limit the search to 10 results.
        searchStr += 'LIMIT 10';
        
        // Perform the search
        for(Account a : Database.query(searchStr))
        {
            // If the account is not already in the list of approved vendors, add it.
            if(selectedVendorIds.contains(a.Id) == false) {
                approvedVendors.add(new ApprovedVendor(a));
            }
        }
    }
    /**
     * Save the Purchase Order
     */
    public PageReference save() {
        // Guard against the user not entering a description.
        if(String.isBlank(description)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a description of the goods or services you are purchasing.'));
            return null;
        }
        // Guard against the user not entering a total cost.
        if(totalCost == null || totalCost <= 0) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must enter a total cost greater than zero for the goods or services you are purchasing.'));
            return null;
        }
        // Iterate through the approvedVendors list and create a purchase order for each selected vendor.
        List<Purchase_Order__c> newPurchaseOrders   = new List<Purchase_Order__c>();
        List<String>            vendorNames         = new List<String>();
        for(ApprovedVendor av : approvedVendors) {
            if(av.isSelected == true) {
                Purchase_Order__c po = new Purchase_Order__c();
                po.Description__c = description;
                po.Total_Cost__c = totalCost;
                po.Vendor__c = av.acc.Id;
                newPurchaseOrders.add(po);
                vendorNames.add(av.acc.Name);
            }
        }
        // Ensure at least one purchase order was created. If not, it means the user didn't select any vendors.
        if (newPurchaseOrders.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'You must select at least one vendor.'));
            return null;
        }
        // Insert the list of new purchase orders
        insert newPurchaseOrders;

        // Display a success message
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Successfully created purchase order(s) for the following vendor(s): ' + String.join(vendorNames, ', ')));

        // Do not redirect to a new page, but clear the form and the list of approved vendors.
        approvedVendors.clear();
        description = null;
        totalCost = null;
        searchString = null;        
        return null;
    }
}