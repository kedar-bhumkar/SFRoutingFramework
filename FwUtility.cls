public with sharing class FwUtility {
    public static boolean areQueuableJobsAllowed(){
        System.debug('Limits.getLimitQueueableJobs() = '  + Limits.getLimitQueueableJobs()  + ' Limits.getQueueableJobs()' +  Limits.getQueueableJobs());
        return ( (Limits.getLimitQueueableJobs() - Limits.getQueueableJobs() > 0) ); 
    }

    //if the calling process is async then force execution in real time
    public static boolean isAsyncAllowed(){
        return !(System.isBatch() || System.isFuture() || System.isQueueable());
    }
}
