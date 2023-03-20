public class MC_SendSmsPEAction {

    @InvocableMethod(label='Send SMS Platform Event')
    public static void execute(List<RequestInput> inputList) {
        
        System.debug('* Creating MC_SMS Platform Event');
        
        RequestInput input = inputList[0];
        
        MC_SMS__e ev = new MC_SMS__e();
        ev.mobileNumber__c = input.mobileNumber;
        ev.messageContent__c = input.messageContent.left(160);
        ev.reformatNumber__c = (input.reformatNumber == 1) ? true : false;
        ev.countryCode__c = input.countryCode;
        
        System.debug('** Event Record: ' + ev);
        
        Database.SaveResult result = EventBus.publish(ev);
        System.debug('** Save Result: ' + result);
        
    }
    
    public class RequestInput {
        
        @InvocableVariable public String mobileNumber;
        @InvocableVariable public String messageContent;
        @InvocableVariable public Integer reformatNumber;
        @InvocableVariable public String countryCode;
        
    }
}