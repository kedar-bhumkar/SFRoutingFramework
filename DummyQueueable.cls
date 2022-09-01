public with sharing class DummyQueueable implements Queueable{
 



    public void execute(QueueableContext context){
        System.debug('Executing DummyQueueable....');
       
    }

}
