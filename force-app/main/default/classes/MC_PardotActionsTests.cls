@isTest
public class MC_PardotActionsTests {
    
    @TestSetup static void setup() {
        
        Account a = new Account(Name='Test Account');
        insert(a);
        
        Contact c = new Contact(AccountId=a.Id, FirstName='Test', LastName='Test', Phone='61411123123', Email='test@example.com');
        insert(c);
        
    }
    
    @isTest static void testSmsPEAction() {
        
        MC_TestSmsCalloutMock mock = new MC_TestSmsCalloutMock();
        Test.setMock(HttpCalloutMock.class, mock);

        MC_SendSmsPEAction.RequestInput input = new MC_SendSmsPEAction.RequestInput();
        input.mobileNumber = '0411123123';
        input.messageContent = 'TEST MESSAGE';
        input.reformatNumber = 1;
        input.countryCode = 'AU';
      
        Test.startTest();
        MC_SendSmsPEAction.execute(new List<MC_SendSmsPEAction.RequestInput>{input});
        Test.stopTest();
        
    }
    
    @isTest static void testSmsFlowAction() {
        
        // Should be redundant, as the PE Action test should kick off the flow that calls this.
        // But, just in case the flow is deactivated or whatever, this tests the action manually.
        
        MC_TestSmsCalloutMock mock = new MC_TestSmsCalloutMock();
        Test.setMock(HttpCalloutMock.class, mock);
        
        MC_SendSmsFlowAction.RequestInput input = new MC_SendSmsFlowAction.RequestInput();
        input.apiPrefix = 'TESTPREFIX';
        input.clientId = 'TESTCLIENTID';
        input.clientSecret = 'TESTCLIENTSECRET';
        input.mID = 'TESTMID';
        input.scope = 'TESTSCOPE';
        input.messageApiKey = 'TESTKEY';
        input.keyword = 'TESTING';
        input.mobileNumber = '0411123123';
        input.useCustomMsg = TRUE;
        input.message = 'TEST MESSAGE';
        input.contentUrl = 'TEST';
        input.formatNumber = TRUE;
        input.countryCode = 'AU';
        input.apiLayerApiKey = 'TESTAPILAYERKEY';
        
        Test.startTest();
        List<String> result = MC_SendSmsFlowAction.execute(new List<MC_SendSmsFlowAction.RequestInput>{input});
        System.debug('Test SMS Flow Action Result: '+result);
        System.assert(result[0].startsWith('7'));
        Test.stopTest();
    }
    
    @isTest static void testCasePEAction() {
        
        MC_CreateCasePEAction.RequestInput input = new MC_CreateCasePEAction.RequestInput();
        input.subject = 'TEST CASE SUBJECT';
        input.description = 'TEST CASE DESCRIPTION';
        input.priority = 'High';
        input.origin = 'Email';
        input.type = '';
        input.recordTypeName = [SELECT DeveloperName FROM RecordType WHERE SObjectType = 'Case' ORDER BY LastModifiedDate DESC LIMIT 1].DeveloperName;
        input.recipientId = [SELECT Id FROM Contact WHERE FirstName = 'Test' AND LastName = 'Test' LIMIT 1].Id;
        input.otherFields = '"Reason" : "New Problem"';
        
        Test.startTest();
        MC_CreateCasePEAction.execute(new List<MC_CreateCasePEAction.RequestInput>{input});
        Test.stopTest();
        
    }
    
    @isTest static void testExtractCaseOtherFields() {
        
        MC_ExtractCaseOtherFields.RequestInput input = new MC_ExtractCaseOtherFields.RequestInput();
        input.otherFields = '"Reason" : "New Problem"';
        input.caseRecord = new Case();
        
        Test.startTest();
        List<MC_ExtractCaseOtherFields.RequestOutput> output = MC_ExtractCaseOtherFields.execute(new List<MC_ExtractCaseOtherFields.RequestInput>{input});
        System.assertEquals(true, output[0].success);
        System.assertEquals('New Problem', output[0].caseRecord.Reason);
        Test.stopTest();
        
    }

}