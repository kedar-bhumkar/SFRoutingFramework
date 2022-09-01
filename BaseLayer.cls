public with sharing virtual class BaseLayer {
    public String processName {get;set;}
    public String actionName {get;set;}   
    public Map<String, Object> outputMap {get;set;}

    public virtual  Map <String, Object> invokeProcess(Map<String, Object> inputMap){
        System.debug('Inside base class invokeProcess....'); 
        this.processName = (String)inputMap.get('PROCESS_NAME');
        this.actionName = (String)inputMap.get('ACTION_NAME');
        
        System.debug('process Name  ' + processName);
        switch on processName {
            when 'USER_INTERFACE' { 
                return routeUIRequest(inputMap);
            }

            when BaseAppLiterals.RECORD_TRIGGERS { 
                return routeRecordTriggerRequest(inputMap);
            }            
            
            when 'EVENT_TRIGGER' { 
               return routeEventTriggerRequest(inputMap);
            }

            when 'SCHEDULE_TRIGGER' { 
                return routeScheduleTriggerRequest(inputMap);
            }

            when 'API_CALLIN' { 
                 return routeApiCallInRequest(inputMap);
            }

            when 'API_CALLOUT' { 
                 return routeApiCallOutRequest(inputMap);   
            }
            
            when 'BATCH' {
                //Make decision to exec in async at process level
                return routeBatchOpsRequest(inputMap);
            }
            
        }

        return outputMap;      
    }

	private virtual Map<String,Object>  routeUIRequest(Map<String,Object> inputMap){
        System.debug('Inside base class routeUIRequest....'); 

        /*if(FwUtility.isAsyncAllowed()){
            processAsync(inputMap); 
        } else*/ {
            outputMap = handleUserInterfaceOps(inputMap);   
        }
        return outputMap;
	} 

	private virtual Map<String,Object>  routeRecordTriggerRequest(Map<String,Object> inputMap){
        if(FwUtility.isAsyncAllowed()){
            processAsync(inputMap);
        } else {
            outputMap = handleRecordTriggerOps(inputMap);   
        }
        return outputMap;
	} 

    private virtual Map<String,Object>  routeEventTriggerRequest(Map<String,Object> inputMap){
        if(FwUtility.isAsyncAllowed()){
            processAsync(inputMap);
        } else {
            outputMap = handleEventTriggerOps(inputMap);   
        }
        return outputMap;
	} 

    private virtual Map<String,Object>  routeScheduleTriggerRequest(Map<String,Object> inputMap){
        if(FwUtility.isAsyncAllowed()){
            processAsync(inputMap);
        } else {
            outputMap = handleScheduleTriggerOps(inputMap);   
        }
        return outputMap;
	}
    
    private virtual Map<String,Object>  routeApiCallInRequest(Map<String,Object> inputMap){
       
        outputMap = handleApiCallInOps(inputMap);           
        return outputMap;
	}     

    private virtual Map<String,Object>  routeApiCallOutRequest(Map<String,Object> inputMap){
       
        if(FwUtility.isAsyncAllowed()){
            processAsync(inputMap);
        } else {
            outputMap = handleApiCallOutOps(inputMap);   
        }
        return outputMap;
	}   
    
    private virtual Map<String,Object>  routeBatchOpsRequest(Map<String,Object> inputMap){
       
        outputMap = handleBatchOps(inputMap);        
        return outputMap; 
	}       
    
    private virtual Map <String,Object> handleUIoperations(Map<String, Object>  inputMap){
        System.debug('Inside base class handleUIoperations...');
        return null;

    }


    private virtual Map <String, Object> handleBatch(Map<String, Object> inputMap){
        System.debug('Inside base class handleUIoperations...');
        return null;
    }


	private virtual Map<String,Object> handleUserInterfaceOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleRecordTriggerOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleEventTriggerOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleScheduleTriggerOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleApiCallInOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleApiCallOutOps(Map<String,Object> inputMap){
		return null;
	} 

	private virtual Map<String,Object> handleBatchOps(Map<String,Object> inputMap){
		return null;
	} 


    private void processAsync(Map<String, Object> inputMap){
        System.debug('Executing in async...');  
        FwQueuable obj = new FwQueuable(inputMap);
        System.enqueueJob(obj); 
  }    

  
}
