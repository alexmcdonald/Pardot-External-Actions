@isTest
global class MC_TestSmsCalloutMock implements HttpCalloutMock {
    
    global HttpResponse respond(HttpRequest req) {
        
        HttpResponse res = new HttpResponse();
        res.setStatus('OK');
        res.setStatusCode(200);
        if(req.getEndpoint().endsWith('/v2/token')) {
            MC_SendSmsQueueable.AuthResponse ar = new MC_SendSmsQueueable.AuthResponse();
            ar.access_token = 'TESTACCESSTOKEN';
            ar.rest_instance_url = 'https://TESTPREFIX.rest.marketingcloudapis.com/';
            res.setBody(JSON.serialize(ar));            
        } else if(req.getEndpoint().startsWith('https://api.apilayer.com')) {
			MC_SendSmsQueueable.FormattedNumber fn = new MC_SendSmsQueueable.FormattedNumber();
            fn.valid = true;
        	fn.international_format = '+61411123123';
            fn.local_format = '0411123123';
            fn.line_type = 'mobile';
            res.setBody(JSON.serialize(fn));
        } else if(req.getEndpoint().endsWith('/send')) {
	        res.setStatus('OK');
        	res.setStatusCode(200);
            res.setBody('{ "tokenId" : "1234567890" }');
        }
        return res;
        
    }

}