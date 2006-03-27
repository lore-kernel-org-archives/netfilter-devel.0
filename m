From: Brad Fisher <brad@info-link.net>
Subject: Re: [PATCH] Re: Setting skb->priority with libnetfilter_queue (patch
 really attached this time)
Date: Mon, 27 Mar 2006 15:40:18 -0600
Message-ID: <44285BC2.3020602@info-link.net>
References: <44283F9F.4010206@info-link.net> <44285B64.1000004@info-link.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090806050009000109070505"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44285B64.1000004@info-link.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090806050009000109070505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Sorry - I got trigger happy and sent without attaching the patch...  
Patches should be attached now.
-Brad

Brad Fisher wrote:
> In case anyone is interested, I have written a couple of small patches 
> to accomplish what I desired.  It adds three new functions to 
> libnetfilter_queue:
>
>   /* Set both mark and priority */
>   int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, u_int32_t 
> id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
>                               u_int32_t data_len, unsigned char *buf)
>
>   /* Sets priority, but leaves mark unchanged */
>   int nfq_set_verdict_priority(struct nfq_q_handle *qh, u_int32_t id, 
> u_int32_t verdict, u_int32_t priority,
>                               u_int32_t data_len, unsigned char *buf)
>
>   /* Get current skb->priority value */
>    u_int32_t nfq_get_priority(struct nfq_data *nfad)
>
> I have performed minimal testing and it appears to work as I had 
> hoped.  If anyone has any better way to do it, I'm open to 
> suggestions.  I would like to see the functionality added to 
> libnetlink_queue at some point, but am not hung up on the 
> implementation.  That said, if the netfilter developers want to use my 
> patch, feel free.  The libnetfilter_queue patch is against current svn 
> (apply with -p0).  The kernel patch is against 2.6.16 (with the 
> nfnetlink_queue: fix nfnetlink message size patch applied) (apply with 
> -p1).
>
> -Brad
>
>
> Brad Fisher wrote:
>> Does anyone know how I could go about setting the skb->priority for 
>> queued packets?  I'd like to have my userspace program be able to 
>> classify packets dynamically, but I believe that would require either 
>> the skb pointer to the enqueued packet so I could use setsockopt, or 
>> a change to the libnetfilter_queue api.  I suppose one could add a 
>> function like:
>>
>>    int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, 
>> u_int32_t id, u_int32_t verdict, u_int32_t mark, u_int32_t priority,
>>                                u_int32_t data_len, unsigned char *buf)
>>
>> (or perhaps it  could be called nfq_set_mark_classify?)
>>
>> Either way, it seems that both the kernel and libnetfilter_queue must 
>> be modified.  I'm hoping I'm wrong and that there is a way to do what 
>> I want without patching the kernel and libnetfilter_queue.  If so 
>> could someone please enlighten me?
>>
>> -Brad
>>
>>
>> !DSPAM:3824,4428404557196205613798!
>>
>
>


--------------090806050009000109070505
Content-Type: text/plain;
 name="libnetfilter_queue-svn_rev6559.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libnetfilter_queue-svn_rev6559.patch"

Index: include/libnetfilter_queue/linux_nfnetlink_queue.h
===================================================================
--- include/libnetfilter_queue/linux_nfnetlink_queue.h	(revision 6559)
+++ include/libnetfilter_queue/linux_nfnetlink_queue.h	(working copy)
@@ -45,6 +45,7 @@
 	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
+	NFQA_PRIORITY,			/* u_int32_t skb->priority */
 
 	__NFQA_MAX
 };
Index: include/libnetfilter_queue/libnetfilter_queue.h
===================================================================
--- include/libnetfilter_queue/libnetfilter_queue.h	(revision 6559)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(working copy)
@@ -62,6 +62,21 @@
 			   	  u_int32_t datalen,
 				  unsigned char *buf);
 
+extern int nfq_set_verdict_priority(struct nfq_q_handle *qh, 
+				  u_int32_t id,
+			   	  u_int32_t verdict, 
+				  u_int32_t priority,
+			   	  u_int32_t datalen,
+				  unsigned char *buf);
+
+extern int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, 
+				  u_int32_t id,
+			   	  u_int32_t verdict, 
+				  u_int32_t mark,
+				  u_int32_t priority,
+			   	  u_int32_t datalen,
+				  unsigned char *buf);
+
 /* message parsing function */
 
 extern struct nfqnl_msg_packet_hdr *
@@ -69,6 +84,8 @@
 
 extern u_int32_t nfq_get_nfmark(struct nfq_data *nfad);
 
+extern u_int32_t nfq_get_priority(struct nfq_data *nfad);
+
 extern int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv);
 
 /* return 0 if not set */
Index: src/libnetfilter_queue.c
===================================================================
--- src/libnetfilter_queue.c	(revision 6559)
+++ src/libnetfilter_queue.c	(working copy)
@@ -290,11 +290,13 @@
 
 static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark, int set_mark,
+		u_int32_t priority, int set_priority,
 		u_int32_t data_len, unsigned char *data)
 {
 	struct nfqnl_msg_verdict_hdr vh;
 	char buf[NFNL_HEADER_LEN
 		+NFA_LENGTH(sizeof(mark))
+		+NFA_LENGTH(sizeof(priority))
 		+NFA_LENGTH(sizeof(vh))];
 	struct nlmsghdr *nmh = (struct nlmsghdr *) buf;
 
@@ -319,6 +321,9 @@
 	if (set_mark)
 		nfnl_addattr32(nmh, sizeof(buf), NFQA_MARK, mark);
 
+	if (set_priority)
+		nfnl_addattr32(nmh, sizeof(buf), NFQA_PRIORITY, priority);
+
 	iov[0].iov_base = nmh;
 	iov[0].iov_len = NLMSG_TAIL(nmh) - (void *)nmh;
 	nvecs = 1;
@@ -341,16 +346,30 @@
 		u_int32_t verdict, u_int32_t data_len, 
 		unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, 0, 0, data_len, buf);
+	return __set_verdict(qh, id, verdict, 0, 0, 0, 0, data_len, buf);
 }	
 
 int nfq_set_verdict_mark(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark,
 		u_int32_t datalen, unsigned char *buf)
 {
-	return __set_verdict(qh, id, verdict, mark, 1, datalen, buf);
+	return __set_verdict(qh, id, verdict, mark, 1, 0, 0, datalen, buf);
 }
 
+int nfq_set_verdict_priority(struct nfq_q_handle *qh, u_int32_t id,
+		u_int32_t verdict, u_int32_t priority,
+		u_int32_t datalen, unsigned char *buf)
+{
+	return __set_verdict(qh, id, verdict, 0, 0, priority, 1, datalen, buf);
+}
+
+int nfq_set_verdict_mark_priority(struct nfq_q_handle *qh, u_int32_t id,
+		u_int32_t verdict, u_int32_t mark, u_int32_t priority,
+		u_int32_t datalen, unsigned char *buf)
+{
+	return __set_verdict(qh, id, verdict, mark, 1, priority, 1, datalen, buf);
+}
+
 /*************************************************************
  * Message parsing functions 
  *************************************************************/
@@ -366,6 +385,11 @@
 	return ntohl(nfnl_get_data(nfad->data, NFQA_MARK, u_int32_t));
 }
 
+u_int32_t nfq_get_priority(struct nfq_data *nfad)
+{
+	return ntohl(nfnl_get_data(nfad->data, NFQA_PRIORITY, u_int32_t));
+}
+
 int nfq_get_timestamp(struct nfq_data *nfad, struct timeval *tv)
 {
 	struct nfqnl_msg_packet_timestamp *qpt;

--------------090806050009000109070505
Content-Type: text/plain;
 name="linux-2.6.16.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.16.patch"

--- linux-2.6.16/include/linux/netfilter/nfnetlink_queue.h	2006-03-19 23:53:29.000000000 -0600
+++ linux-2.6.16.new/include/linux/netfilter/nfnetlink_queue.h	2006-03-27 14:16:47.000000000 -0600
@@ -41,6 +41,7 @@
 	NFQA_IFINDEX_PHYSOUTDEV,	/* u_int32_t ifindex */
 	NFQA_HWADDR,			/* nfqnl_msg_packet_hw */
 	NFQA_PAYLOAD,			/* opaque data payload */
+	NFQA_PRIORITY,			/* u_int32_t skb->priority */
 
 	__NFQA_MAX
 };
--- linux-2.6.16/net/netfilter/nfnetlink_queue.c	2006-03-19 23:53:29.000000000 -0600
+++ linux-2.6.16.new/net/netfilter/nfnetlink_queue.c	2006-03-27 15:11:57.000000000 -0600
@@ -362,6 +362,7 @@
 		+ NFA_SPACE(sizeof(u_int32_t))	/* ifindex */
 #endif
 		+ NFA_SPACE(sizeof(u_int32_t))	/* mark */
+		+ NFA_SPACE(sizeof(u_int32_t))	/* priority */
 		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_hw))
 		+ NFA_SPACE(sizeof(struct nfqnl_msg_packet_timestamp));
 
@@ -484,6 +485,11 @@
 		NFA_PUT(skb, NFQA_MARK, sizeof(u_int32_t), &tmp_uint);
 	}
 
+	if (entskb->priority) {
+		tmp_uint = htonl(entskb->priority);
+		NFA_PUT(skb, NFQA_PRIORITY, sizeof(u_int32_t), &tmp_uint);
+	}
+
 	if (indev && entskb->dev
 	    && entskb->dev->hard_header_parse) {
 		struct nfqnl_msg_packet_hw phw;
@@ -827,7 +833,11 @@
 	if (nfqa[NFQA_MARK-1])
 		entry->skb->nfmark = ntohl(*(u_int32_t *)
 		                           NFA_DATA(nfqa[NFQA_MARK-1]));
-		
+
+	if (nfqa[NFQA_PRIORITY-1])
+		entry->skb->priority = ntohl(*(u_int32_t *)
+		                           NFA_DATA(nfqa[NFQA_PRIORITY-1]));
+
 	issue_verdict(entry, verdict);
 	instance_put(queue);
 	return 0;

--------------090806050009000109070505--
