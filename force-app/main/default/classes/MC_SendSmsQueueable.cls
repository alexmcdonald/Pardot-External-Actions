public without sharing class MC_SendSmsQueueable implements System.Queueable, Database.AllowsCallouts {
    
    public final MC_SendSmsFlowAction.RequestInput input;
    
    public MC_SendSmsQueueable(MC_SendSmsFlowAction.RequestInput input) {
    	this.input = input;
  	}
    
    public void execute(System.QueueableContext ctx) {
    	AuthResponse ar = getAccessToken(input.clientId, input.clientSecret, input.mId, input.scope, input.apiPrefix);
        if(!String.isBlank(ar.access_token)) {
            
            if(input.formatNumber && !input.mobileNumber.startsWith('+')) {
                FormattedNumber fn = formatNumber(input.mobileNumber, input.countryCode, input.apiLayerApiKey);
                if(fn.valid) input.mobileNumber = fn.international_format;
            }
            
            Boolean success = SendSMS(ar.rest_instance_url, ar.access_token, input.messageApiKey, input.keyword, input.mobileNumber.removeStart('+'), input.useCustomMsg, input.message, input.contentUrl);
            System.debug('** Send SMS Queuable Success: ' + success);
        }
    }
    
    public static AuthResponse getAccessToken(String clientId, String clientSecret, String mId, String scope, String apiPrefix) {
        
        System.debug('* Send SMS Queueable: Getting Access Token');
        String endpoint = 'https://' + apiPrefix + '.auth.marketingcloudapis.com/v2/token';
        TokenRequest tr = new TokenRequest();
        tr.grant_type = 'client_credentials';
        tr.client_id = clientId;
        tr.client_secret = clientSecret;
        tr.scope = scope;
        tr.account_id = mId;
        
        String body = JSON.serialize(tr);
        System.debug('** Access Token Request Body: ' + body);
        
        AuthResponse ar;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');

            req.setBody(body);

            System.debug('** Access Token Request: ' + req);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            System.debug('** Access Token Response: ' + res.getBody());
                
            ar = (AuthResponse)JSON.deserialize(res.getBody(), AuthResponse.class);

        } catch (Exception e) {
            System.debug('** Caught Error Getting Access Token: ' + e.getMessage());
            ar = new AuthResponse();
            ar.access_token = '';
        }
        
        System.debug('** Access Token: ' + ar.access_token);
        System.debug('** MC Rest API Endpoint: ' + ar.rest_instance_url);
        
        return ar;
    }
    
    public class TokenRequest {
		public String grant_type;
		public String client_id;
		public String client_secret;
		public String scope;
		public String account_id;    
	}

    public class AuthResponse {
        public String access_token;
        public String token_type;
        public Integer expires_in;
        public String scope;
        public String soap_instance_url;
        public String rest_instance_url;
    }
    
    public static FormattedNumber formatNumber(String phoneNumber, String countryCode, String apiKey) {
        
        System.debug('* Send SMS Queuable: Formatting Number');
        String endpoint = 'https://api.apilayer.com/number_verification/validate?number='+phoneNumber+'&country_code='+countryCode;
        
        FormattedNumber fn;
        try {
        	Http http = new Http();
        	HttpRequest req = new HttpRequest();
        	req.setEndPoint(endpoint);
        	req.setMethod('GET');
        	req.setTimeout(5000);
        	req.setHeader('Content-Type','application/json');
        	req.setHeader('apikey', apiKey);
        
        	System.debug('** Format Number Request: ' + req);
        
        	HttpResponse res = http.send(req);
            
            System.debug('** Format Number Response: ' + res.getBody());
        
         	fn = (FormattedNumber)JSON.deserialize(res.getBody(),FormattedNumber.class); 
            
        } catch(Exception e) {
            System.debug('** Caught Error Formatting Number: ' + e.getMessage());
            fn = new FormattedNumber();
            fn.valid = false;
        }
        
        System.debug('** Formatted Number Valid: ' + fn.valid);
        System.debug('** Formatted Number: ' + fn.international_format);

        return fn;
    }
    
    public class FormattedNumber {
        public Boolean valid;
        public String international_format;
        public String local_format;
        public String line_type;
    }
    
    public static Boolean SendSMS(String restInstanceUrl, String token, String messageApiKey, String keyword, String mobileNumber, Boolean useCustomMessage, String message, String contentUrl) {
        
        String endpoint = restInstanceUrl + 'sms/v1/messageContact/'+messageApiKey+'/send';
        
        SmsMessage sms = new SmsMessage();
        sms.mobileNumbers = new List<String>{mobileNumber};
        sms.subscribe = true;
        sms.resubscribe = true;
        sms.keyword = keyword;
        if(useCustomMessage && !String.isBlank(message)) {
            sms.x_override = true;
            sms.messageText = message;
        } else {
            sms.x_override = false;
        }
        if(!String.isBlank(contentUrl)) sms.ContentURL = contentUrl;
        String body = JSON.serialize(sms).replace('x_override','override');
        System.debug('** Send SMS Request Body: ' + body);

        String resBody;
        try {
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'Bearer ' + token);
            
            req.setBody(body);
            
            System.debug('** Send SMS Request: ' + req);
            
            Http http = new Http();
            HttpResponse res = http.send(req);
            
            resBody = res.getBody();
            System.debug('** Send SMS Response Body: ' + resBody);
        } catch (Exception e) {
            System.debug('** Caught Error Sending SMS: ' + e.getMessage());            
        }
        
        return (!String.isBlank(resBody) && resBody.contains('tokenId')) ? true : false;            
    }
    
    public class SmsMessage {
        public List<String> mobileNumbers;
        public String messageText;
        public String ContentURL;
        public Boolean subscribe;
        public Boolean resubscribe;
        public String keyword;
        public Boolean x_override;
    }


}