public with sharing class FwServiceLayer extends BaseLayer {
    public FwServiceLayer() {}

    
    private Map <String,Object> handleUserInterfaceOps(Map<String, Object>  inputMap){
        System.debug('Inside service class handleUIoperations...');

        Map<String, Object> outputMap; 

        switch on actionName {
                //Make decision to exec in async at method level
                //@ToDO - revisit dynamic decision for async/sync 
                when 'CREATE_USER' {
                    //DummyQueueable qbl = new DummyQueueable();
                    //System.enqueueJob(qbl); 
                    
                    /*if(FwUtility.isAsyncAllowed()){
                        processAsync(inputMap);
                    } else {
                        createUser(inputMap);   
                    }*/ 
                    createUser(inputMap);                       
                }

                when 'CREATE_OPPTY' {

                }

        }
        
        return outputMap; 
    }


    private void createUser(Map<String, Object>  inputMap){
        System.debug('Inside createUser class....');
    }

  
}
