global  with sharing class FwClient implements Schedulable  {
    public FwClient(){
       
    }

    global void execute(SchedulableContext sc) {
        run();
     }

    public void run(){
        //collect and load all your input in this inputData map
        Map<String, Object> inputMap = new Map<String, Object>();  
        Invoker theInvoker = new Invoker();
        Map<String, Object> outputMap = theInvoker.invoke(FwAppLiterals.PROCESS_NAME.USER_INTERFACE.name(), FwAppLiterals.ACTION_NAME.CREATE_USER.name(), FwAppLiterals.CLASS_REF.FwServiceLayer.name(),inputMap);
    } 


}
