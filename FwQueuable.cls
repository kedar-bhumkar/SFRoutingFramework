public with sharing class FwQueuable implements Queueable{
    public Map<String, Object> inputMap;
 


    public FwQueuable(Map<String, Object>  inputMap) {
        this.inputMap = inputMap;
    }

    public void execute(QueueableContext context){
        System.debug('Executing queueable....');
        String s = (String)inputMap.get('CLASS_REF');
        Type t  = Type.forName(s);
        BaseLayer base = (BaseLayer)t.newInstance();
        base.invokeProcess(inputMap);
    }
}
