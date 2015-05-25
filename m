From: Roman Kubiak <r.kubiak@samsung.com>
Subject: [PATCH v2] nfnetlink_queue: add security context information
Date: Mon, 25 May 2015 18:09:25 +0200
Message-ID: <55634935.4020100@samsung.com>
References: <5562F661.5000503@samsung.com> <20150525131319.GA3529@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:50125 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbbEYQJ2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 12:09:28 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NOW0093EY7QOA90@mailout4.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 25 May 2015 17:09:26 +0100 (BST)
Received: from [106.120.53.13] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTPA id <0NOW00NUCY7P1TA0@eusync1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 25 May 2015 17:09:26 +0100 (BST)
In-reply-to: <20150525131319.GA3529@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[sidenote]
The additional NULL at the end of the security context is there because SMACK does not add this
to it's labels while SELinux does. So in order to avoid checking i just add it always.
This additional byte is also represented when calculating the size.
I did that because we are not transmitting the size of the context and there is no specified
max length so it has to be NULL terminated (at least it seemed like a valid solution)

best regards

This patch adds an additional attribute when sending
packet information via netlink in netfilter_queue module.
It will send additional security context data, so that
userspace applications can verify this context against
their own security databases.

Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
---
v2:
- nfqnl_get_sk_secctx returns seclen now, this changes
- updated size calculation
- changed NFQA_SECCTX comment
- removed duplicate testing of NFQA_CFG_F flags
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  4 ++-
 net/netfilter/nfnetlink_queue_core.c           | 45 ++++++++++++++++++++++++++
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index 8dd819e..b67a853 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -49,6 +49,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,			/* security context string */
 
 	__NFQA_MAX
 };
@@ -102,7 +103,8 @@ enum nfqnl_attr_config {
 #define NFQA_CFG_F_CONNTRACK			(1 << 1)
 #define NFQA_CFG_F_GSO				(1 << 2)
 #define NFQA_CFG_F_UID_GID			(1 << 3)
-#define NFQA_CFG_F_MAX				(1 << 4)
+#define NFQA_CFG_F_SECCTX			(1 << 4)
+#define NFQA_CFG_F_MAX				(1 << 5)
 
 /* flags for NFQA_SKB_INFO */
 /* packet appears to have wrong checksums, but they are ok */
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 0b98c74..60c70fb 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -278,6 +278,27 @@ nla_put_failure:
 	return -1;
 }
 
+static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
+{
+	u32 secid = 0;
+	u32 seclen = 0;
+	int ret = -1;
+
+	if (!sk || !sk_fullsock(sk))
+		return ret;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	security_sk_getsecid(sk, &secid);
+
+	if (secid)
+		ret = security_secid_to_secctx(secid, secdata, &seclen);
+	if (!ret)
+		seclen = 0;
+
+	read_unlock_bh(&sk->sk_callback_lock);
+	return seclen;
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -297,6 +318,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	bool csum_verify;
+	char *secdata = NULL;
+	char *secdata_nterm = NULL;
+	u32 seclen = 0;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -352,6 +376,12 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
+	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
+		seclen = nfqnl_get_sk_secctx(entskb->sk, &secdata);
+			if (seclen > 0)
+				size += nla_total_size(seclen) + 1;
+	}
+
 	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
 	if (!skb) {
@@ -479,6 +509,20 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (seclen > 0) {
+		secdata_nterm = kmalloc(seclen + 1, GFP_ATOMIC);
+
+		if (!secdata_nterm)
+			goto nla_put_failure;
+		memcpy(secdata_nterm, secdata, seclen);
+		secdata_nterm[seclen] = 0;
+
+		if (nla_put(skb, NFQA_SECCTX, seclen + 1, secdata_nterm))
+			goto nla_put_failure;
+
+		kfree(secdata_nterm);
+	}
+
 	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
 		goto nla_put_failure;
 
@@ -509,6 +553,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 nla_put_failure:
 	skb_tx_error(entskb);
 	kfree_skb(skb);
+	kfree(secdata_nterm);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;
 }
-- 
1.9.1


On 05/25/2015 03:13 PM, Pablo Neira Ayuso wrote:
> On Mon, May 25, 2015 at 12:16:01PM +0200, Roman Kubiak wrote:
>> From dccc2ca387d7b4dd16fff537ce2cab280517cab5 Mon Sep 17 00:00:00 2001
>> From: Roman Kubiak <r.kubiak@samsung.com>
>> Date: Wed, 22 Apr 2015 15:54:20 +0200
>> Subject: [PATCH] Security context information added to netfilter_queue
>>
>> This patch adds an additional attribute when sending
>> packet information via netlink in netfilter_queue module.
>> It will send additional security context data, so that
>> userspace applications can verify this context against
>> their own security databases.
> 
> Please prepend the subsystem prefix to the patch title, ie.
> 
>         netfilter: nfnetlink_queue: Add security context information
> 
> A couple of minor comments on top of Florian's.
> 
>> Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
>> ---
>>  include/uapi/linux/netfilter/nfnetlink_queue.h |  4 ++-
>>  net/netfilter/nfnetlink_queue_core.c           | 46 ++++++++++++++++++++++++++
>>  2 files changed, 49 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
>> index 8dd819e..313935a 100644
>> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
>> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
>> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>>  	NFQA_UID,			/* __u32 sk uid */
>>  	NFQA_GID,			/* __u32 sk gid */
>> +	NFQA_SECCTX,			/* security context, NL_A_STRING */
> 
> I'd suggest for this comment.
> 
> /* security context string */
> 
>>  	__NFQA_MAX
>>  };
>> @@ -102,7 +103,8 @@ enum nfqnl_attr_config {
>>  #define NFQA_CFG_F_CONNTRACK			(1 << 1)
>>  #define NFQA_CFG_F_GSO				(1 << 2)
>>  #define NFQA_CFG_F_UID_GID			(1 << 3)
>> -#define NFQA_CFG_F_MAX				(1 << 4)
>> +#define NFQA_CFG_F_SECCTX			(1 << 4)
>> +#define NFQA_CFG_F_MAX				(1 << 5)
>>  
>>  /* flags for NFQA_SKB_INFO */
>>  /* packet appears to have wrong checksums, but they are ok */
>> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
>> index 0b98c74..de3b97a 100644
>> --- a/net/netfilter/nfnetlink_queue_core.c
>> +++ b/net/netfilter/nfnetlink_queue_core.c
>> @@ -278,6 +278,27 @@ nla_put_failure:
>>  	return -1;
>>  }
>>  
>> +static int nfqnl_get_sk_secctx(struct sock *sk, char **secdata, u32 *seclen)
>> +{
>> +	u32 secid = 0;
>> +	int ret = -1;
>> +
>> +	if (!sk)
>> +		return ret;
>> +
>> +	if (!sk_fullsock(sk))
>> +		return ret;
> 
> you can collapse these two if's:
> 
>         if (!sk || !sk_fullsock(sk))
> 

-- 
--------------
 Roman Kubiak
--------------
