public with sharing class Invoker {
    public Invoker() {}

    public Map<String,Object> invoke(String processName, String actionName, String classRef, Map<String,Object> inputData){
        Map<String, Object> inputMap = new Map<String, Object>();
        inputMap.put('PROCESS_NAME', processName);
        inputMap.put('ACTION_NAME', actionName);
        inputMap.put('DATA', inputData);
        inputMap.put('CLASS_REF', classRef);
        Type t  = Type.forName(classRef);
        BaseLayer base = (BaseLayer)t.newInstance();

        return base.invokeProcess(inputMap);       

    }
}
