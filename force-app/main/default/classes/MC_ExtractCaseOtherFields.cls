public class MC_ExtractCaseOtherFields {
    
    @InvocableMethod(label='Extract Case Other Fields')
    public static List<RequestOutput> execute(List<RequestInput> inputList) {
        RequestInput input = inputList[0];
        Case c = input.caseRecord;
        
        Map<String,String> fields = new Map<String,String>();
        
        Boolean success = true;
        try {
            fields = (Map<String,String>)JSON.deserialize('{ ' + input.otherFields + ' }', Map<String,String>.class);
        } catch(Exception e) {
            System.debug('** Caught error deserializing other fields: ' + e.getMessage());
            success = false;
        }
        
        if(success) {
        	for(String key : fields.keyset()) {
            	try {
                	c.put(key, fields.get(key));
            	} catch(Exception e) {
                	System.debug('** Caught error setting ' + key + ' field: ' + e.getMessage());
                    success = false;
            	}
        	}            
        }
        
        RequestOutput output = new RequestOutput();
        output.caseRecord = c;
        output.success = success;
        
        System.debug('** Extract Case Other Fields Output: '+output);
        
        return new List<RequestOutput>{output};
    }
    
    public class RequestInput {
        @InvocableVariable(required=true label='Case Other Fields') public String otherFields;
        @InvocableVariable(required=true label='Case Record') public Case caseRecord;
    }
    
    public class RequestOutput {
        @InvocableVariable(required=true label='Case Record') public Case caseRecord;
        @InvocableVariable(label='Success') public Boolean success;
    }

}