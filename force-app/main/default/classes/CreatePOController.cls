/**
 * @class       `CreatePOController`
 * @description This class is the controller for the Create Purchase Order page.
 */
public class CreatePOController {
    /** @description A user-provided search string to filter the list of Vendors. */
    public String       searchString        {get; set;}
    /** @description The description of the goods or services being purchased. */
    public String       description         {get; set;}
    /** @description The total cost of the goods or services being purchased. */
    public Decimal      totalCost           {get; set;}
    /** @description The list of Vendors. */
    public List<Vendor> vendors             {get; set;}
    /**
     * @class       `Vendor`
     * @description  Wrapper class for `Accounts` as `Vendors`.
     */
    public class Vendor {
        /** @description The `Account` object wrapped by this Vendor. */
        public Account  acc         {get; set;}
        /** @description A flag to indicate if the user has selected this Vendor. */
        public Boolean  isSelected  {get; set;}
        /**
         * @description Constructor.
         * @param       a   The `Account` object to wrap as a `Vendor`.
         */
        public Vendor(Account a) {
            acc = a;
            isSelected = false;
        }
    }
    /**
     * @description Constructor.
     */
    public CreatePOController() {
        // Initialize the list of vendors.
        vendors = new List<Vendor>();
        // Get a list of default Vendor Accounts.
        List<Account> vendorAccounts = getDefaultVendorAccounts(10);
        // Populate the list of vendors with the Vendor Accounts found.
        for(Account vendorAccount : vendorAccounts) {
            Vendor vendor = new Vendor(vendorAccount);
            this.vendors.add(vendor);
        }
    }
    /**
     * @description Search for `Vendors`.
     */
    public void search() {
        // Save the IDs of any Vendors that user selected.
        Set<Id> selectedVendorIds = new Set<Id>();
        for(Vendor vendor : this.vendors) {
            if(vendor.isSelected == true) {
                selectedVendorIds.add(vendor.acc.Id);
            }
        }
        // Clear the list of Vendors and create a variable to hold new Vendor Accounts.
        this.vendors.clear();
        List<Account> vendorAccounts;

        // If the user provided a search string, use it to build a new list of Vendor Accounts.
        if (String.isBlank(this.searchString) == false) {
            // Escape the search string provided by the user.
            String escapedSearchString = '%' + String.escapeSingleQuotes(this.searchString) + '%';
            // Build a list of Vendor Accounts that match the search string or were already selected (up to a limit of 20).
            vendorAccounts =   [SELECT      Id, Name, Phone, Website 
                                FROM        Account 
                                WHERE       Name LIKE :escapedSearchString 
                                            OR 
                                            Id IN :selectedVendorIds
                                ORDER BY    Name ASC
                                LIMIT       20];
        } else {
            // The user did not provide a search string. Return all Vendor Accounts (up to a limit of 20).
            vendorAccounts = getDefaultVendorAccounts(20);
        }
        // Populate the list of vendors with the Vendor Accounts found.
        for(Account vendorAccount : vendorAccounts) {
            Vendor vendor = new Vendor(vendorAccount);
            // Carry forward the selected state of the Vendor if it was selected before.
            if (selectedVendorIds.contains(vendorAccount.Id)) {
                vendor.isSelected = true;
            }
            this.vendors.add(vendor);
        }
    }
    /**
     * @description Save the Purchase Order
     * @return      The page reference to navigate to after Purchase Orders are saved.
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
        // Iterate through the vendors list and create a purchase order for each selected vendor.
        List<Purchase_Order__c> newPurchaseOrders   = new List<Purchase_Order__c>();
        List<String>            vendorNames         = new List<String>();
        for(Vendor vendor : vendors) {
            if(vendor.isSelected == true) {
                Purchase_Order__c po = new Purchase_Order__c();
                po.Description__c    = description;
                po.Total_Cost__c     = totalCost;
                po.Vendor__c         = vendor.acc.Id;
                newPurchaseOrders.add(po);
                vendorNames.add(vendor.acc.Name);
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

        // Clear the form and the list of vendors.
        description  = null;
        totalCost    = null;
        searchString = null;        
        vendors.clear();

        // Do not navigate to a different page.
        return null;
    }
    /**
     * @description Get a list of default Vendor Accounts.
     * @param       maxRecords  The maximum number of records to return.
     * @return      A list of `Account` objects.
     */
    private List<Account> getDefaultVendorAccounts(Integer maxRecords) {
        return [SELECT      Id, Name, Phone, Website 
                FROM        Account 
                ORDER BY    Name ASC
                LIMIT       :maxRecords];
    }
}