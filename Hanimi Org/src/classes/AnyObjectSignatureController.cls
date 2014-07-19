global with sharing class AnyObjectSignatureController 
{  Public Quote quoteid {get;set;}
    static boolean isRecursive = false;
    Public string attachmentid {get;set;}
    public string quoteemail{get;set;}
    public static string signatureid{get;set;}
   public AnyObjectSignatureController(ApexPages.StandardController controller) {
   // quoteid = ApexPages.currentPage().getParameters().get('id');
   quoteid = new Quote ();
    quoteid = (Quote)controller.getRecord();
   
    }

global AnyObjectSignatureController()
{
}
 List<QuoteLineItem> m_lineItems = null;
    global List<QuoteLineItem> getLineItems() {
        if(m_lineItems == null && quoteid!= null){ 
            m_lineItems = [select Id,Product2.Name, Quantity, TotalPrice ,Description ,Quoteid,Subtotal ,UnitPrice from QuoteLineItem where Quoteid=:quoteid.Id];
        }
        return m_lineItems;
    }
   
    
     global PageReference Singedpage() {
                
            return null;
             
     }
     global void saveOnLoad() {
        if(!isRecursive) {
            isRecursive = true;
                Attachment record = new Attachment();
                record.Body =Page.Quote_Signature.getContentasPdf();
                record.ParentId = quoteid.Id;
                record.Name = 'Signature Capture.pdf';
                insert record;
          if(quoteid.Signatureid__c!=null){
          Attachment signed = new Attachment(); 
          signed = [Select id from Attachment where id=:quoteid.Signatureid__c limit 1];
          delete signed;
          Quote quoteobj = new Quote();
          quoteobj = [select id ,name,Email,Signatureid__c from Quote where id=:quoteid.id limit 1];
          quoteemail =quoteobj.Email; 
          quoteobj.Signatureid__c ='';
          update quoteobj;
          /* sending an singed attachment to contact email*/
           Attachment mailpdf = new Attachment();
           mailpdf =[Select id,Name,CreatedDate from Attachment order by CreatedDate desc limit 1];
           Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
            attach.setContentType('application/pdf');
            attach.setFileName(quoteobj.name+'.pdf');
            attach.setInline(false);
            attach.Body = Page.Quote_Signature.getContentasPdf();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setUseSignature(false);
            mail.setToAddresses(new String[] {quoteemail});
            mail.setSubject(quoteobj.name+'Quotation');
            mail.setHtmlBody('Preview of sample Quotation');
            mail.setFileAttachments(new Messaging.EmailFileAttachment[] { attach }); 
            
            // Send the email
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

          } 
        }
    }
    
        @RemoteAction
        global static String saveSignature(String signatureBody, String parentId) 
        {
                try
                {
                
                system.debug('Record Id == ' + parentId);
                system.debug(signatureBody);
                Attachment a = new Attachment();
                a.ParentId = parentId;
                a.Body = EncodingUtil.base64Decode(signatureBody);
                a.ContentType = 'image/png';
                a.Name = 'Signature Capture.png';
                insert a;
                Attachment a1 = new Attachment();
                a1 = [Select id from Attachment where id =:a.Id limit 1];
                signatureid= a1.id;
                system.debug('attachmentid Id == ' + signatureid);
                Quote quoteobj = new Quote();
                quoteobj = [Select id,Name,Signatureid__c from Quote  where id =:parentId];
                quoteobj.Signatureid__c= signatureid;
                update quoteobj;
                //delete a1;
            }catch(Exception e)
            {
                return JSON.serialize(e);
            }
                return null;
            }
            
        }