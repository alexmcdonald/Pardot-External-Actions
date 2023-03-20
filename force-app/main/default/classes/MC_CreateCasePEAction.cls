public class MC_CreateCasePEAction {

    @InvocableMethod(label='Send Create Case Platform Event')
    public static void execute(List<RequestInput> inputList) {
     
        System.debug('* Creating MC_Case Platform Event');
        
        RequestInput input = inputList[0];
        
        MC_Case__e ev = new MC_Case__e();
        ev.subject__c = input.subject;
        ev.description__c = input.description;
        ev.priority__c = input.priority;
        ev.origin__c = input.origin;
        ev.type__c = input.type;
        ev.recordTypeName__c = input.recordTypeName;
        ev.recipientId__c = input.recipientId;
        ev.otherFields__c = input.otherFields;
        
        System.debug('** Event Record: ' + ev);
        
        Database.SaveResult result = EventBus.publish(ev);
        System.debug('** Save Result: ' + result);
        
    }

    public class RequestInput {
        @InvocableVariable(required=true label='Case Subject') public String subject;
        @InvocableVariable(label='Case Description') public String description;
        @InvocableVariable(label='Case Priority') public String priority;
        @InvocableVariable(label='Case Origin') public String origin;
        @InvocableVariable(label='Case Type') public String type;
        @InvocableVariable(label='Record Type DeveloperName') public String recordTypeName;
        @InvocableVariable(label='Recipient Id') public String recipientId;
        @InvocableVariable(label='Other Fields') public String otherFields;
    }
    
}