public without sharing class MC_SendSmsFlowAction {
    
    @InvocableMethod(label='Send MC SMS') 
    public static List<String> execute(List<RequestInput> inputList) {
        
        RequestInput input = inputList[0];        
        System.debug('* Send SMS Flow Action: '+input);       
        String jobId = System.enqueueJob(new MC_SendSmsQueueable(input));
        return new List<String>{jobId};
            
    }
    
    public class RequestInput {

		// SFMC Access Token Inputs        
        @InvocableVariable(required=true label='_SFMC API Prefix') public String apiPrefix;
        @InvocableVariable(required=true label='_SFMC Client Id') public String clientId;
        @InvocableVariable(required=true label='_SFMC Client Secret') public String clientSecret;
        @InvocableVariable(required=true label='_SFMC MID') public String mID;
        @InvocableVariable(required=true label='_SFMC Scope') public String scope;
        
        // SMS Message Inputs
        @InvocableVariable(required=true label='_SFMC SMS Message Api Key' description='Api Key for the SFMC Outbound Message') public String messageApiKey;
        @InvocableVariable(required=true label='_SFMC SMS Message Keyword' description='Keyword specified for the SFMC Outbound Message') public String keyword;
		@InvocableVariable(required=true label='Mobile Number') public String mobileNumber;
        @InvocableVariable(required=true label='Use Custom Message') public Boolean useCustomMsg;
        @InvocableVariable(label='Custom Message') public String message;
        @InvocableVariable(label='Content URL (US-Only)' description='Optional link to send in SMS') public String contentUrl;
        
        // API Layer Number Reformatting Inputs
        @InvocableVariable(label='Format Number' description='Option to attempt to reformat the mobile number to the correct format') public Boolean formatNumber;
        @InvocableVariable(label='Format Number Country Code' description='Country Code to use when reformatting number, use 2-char ISO 3166 code') public String countryCode;
        @InvocableVariable(label='Format Number ApiLayer API Key') public String apiLayerApiKey;

    }

}