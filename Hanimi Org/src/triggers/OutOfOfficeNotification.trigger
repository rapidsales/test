trigger OutOfOfficeNotification on FeedItem (after insert) {
    String userKeyPrefix = User.sObjectType.getDescribe().getKeyPrefix();
    String currentuserid= UserInfo.getUserId();
    Set<String> userIds = new Set<String> ();
    for (FeedItem f : Trigger.new)
    {
        String parentId = f.parentId ;
        if (parentId.startsWith(userKeyPrefix))
        {
            userIds.add(f.parentId );
        }
    }
    
    if (userIds.size() == 0)
        return;

    Out_Of_Office__c[] ooo = [Select User__c, Start_Time__c, Message__c, End_Time__c, Active__c From Out_Of_Office__c
                              where Active__c = true and User__c in :userIds and User__c !=:currentuserid ];
      System.debug('UserInfo..'+ooo );
        
    if (ooo.size() == 0)
        return;
    
    Map<Id, Out_Of_Office__c> user2OOONotifications = new Map<Id, Out_Of_Office__c>();
    for (Out_Of_Office__c o : ooo)
    {
        user2OOONotifications.put(o.User__c, o);
    }   
    
    List<FeedComment> oooNotifications = new List<FeedComment>();
    
    for (FeedItem post : Trigger.new)
    {
        Datetime now = System.now();
        if (user2OOONotifications.keyset().contains(post.parentId ))
        { 
            Out_Of_Office__c o = user2OOONotifications.get(post.parentId );
            if ( now.getTime() >= o.Start_Time__c.getTime() &&
                 now.getTime() <= o.End_Time__c.getTime())
            {
            System.debug('feeditem number'+post.Id);
                FeedComment notification = new FeedComment(FeedItemId = post.Id,
                                                           CommentBody = o.Message__c,
                                                           CreatedById = post.parentId
                                                        );
                 if(post.parentId!=post.InsertedById){
                    oooNotifications.add(notification);
                }  
            }
        }           
    }
    
    if (oooNotifications.size() > 0)
        insert oooNotifications;
}