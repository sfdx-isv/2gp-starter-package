@isTest
public class CreatePOControllerTest {
    @isTest static void testCreatePOController() {
        // Create test data
        Account testAccount = new Account(Name = 'Test Vendor', Phone = '1234567890', Website = 'www.test.com');
        insert testAccount;

        // Instantiate the controller
        CreatePOController controller = new CreatePOController();

        // Test the search method
        controller.searchString = 'Test Vendor';
        controller.search();
        Assert.areEqual(1, controller.vendors.size(), 'Expected one vendor to be returned from the search.');

        // Test the save method
        controller.description = 'Test Description';
        controller.totalCost = 100.00;
        controller.vendors[0].isSelected = true;
        PageReference pageRef = controller.save();
        Assert.areEqual(null, pageRef, 'Expected no page navigation.');

        // Check that a Purchase Order was created
        List<Purchase_Order__c> pos = [SELECT Id, Description__c, Total_Cost__c, Vendor__c FROM Purchase_Order__c];
        Assert.areEqual(1, pos.size(), 'Expected one Purchase Order to be created.');
        Assert.areEqual('Test Description', pos[0].Description__c, 'Expected the Purchase Order to have the correct description.');
        Assert.areEqual(100.00, pos[0].Total_Cost__c, 'Expected the Purchase Order to have the correct total cost.');
        Assert.areEqual(testAccount.Id, pos[0].Vendor__c, 'Expected the Purchase Order to be associated with the correct vendor.');
    }
}