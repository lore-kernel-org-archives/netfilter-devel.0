From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Thu, 11 Jun 2015 14:56:34 +0200
Message-ID: <55798582.1040903@samsung.com>
References: <5562F661.5000503@samsung.com> <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com> <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com> <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com> <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia> <557855B2.8030803@samsung.com>
 <20150610160541.GD7125@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31751 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933564AbbFKM4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jun 2015 08:56:41 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPS00AS96MC8F50@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Thu, 11 Jun 2015 13:56:36 +0100 (BST)
In-reply-to: <20150610160541.GD7125@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes applied (i'm not sure how i should use the mask parameter to check if NFQA_CFG_F_SECCTX is set
on the userspace side both the mask and the flag are the same value when i looked at how uid/gid
are set, maybe this could be done better?)

-- cut here

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

v3:
- NULL is not added to the security context anymore
- return 0 when socket is invalid in nfqnl_get_sk_secctx
- small intent change
- removed ret variable in nfqnl_get_sk_secctx

v4:
- removed security dependency, this patch does not
  require any changes in other subsystems
- nfqnl_get_sk_secctx returns seclen
- added IFDEF when using secmark from the sk_buff
  structure

v5:
- added a check to disable security context sending
  if CONFIG_NETWORK_SECMARK is not set
---
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  4 ++-
 net/netfilter/nfnetlink_queue_core.c           | 35 +++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 2 deletions(-)

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
index 0b98c74..380aac6 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -278,6 +278,23 @@ nla_put_failure:
 	return -1;
 }
 
+static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+{
+	u32 seclen = 0;
+#if IS_ENABLED(CONFIG_NETWORK_SECMARK)
+	if (!skb || !sk_fullsock(skb->sk))
+		return 0;
+
+	read_lock_bh(&skb->sk->sk_callback_lock);
+
+	if (skb->secmark)
+		security_secid_to_secctx(skb->secmark, secdata, &seclen);
+
+	read_unlock_bh(&skb->sk->sk_callback_lock);
+#endif
+	return seclen;
+}
+
 static struct sk_buff *
 nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			   struct nf_queue_entry *entry,
@@ -297,6 +314,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	bool csum_verify;
+	char *secdata = NULL;
+	u32 seclen = 0;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -352,6 +371,12 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
+	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
+		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
+		if (seclen)
+			size += nla_total_size(seclen);
+	}
+
 	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
 	if (!skb) {
@@ -479,6 +504,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+		goto nla_put_failure;
+
 	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
 		goto nla_put_failure;
 
@@ -1142,7 +1170,12 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			ret = -EOPNOTSUPP;
 			goto err_out_unlock;
 		}
-
+#if !IS_ENABLED(CONFIG_NETWORK_SECMARK)
+		if (flags == NFQA_CFG_F_SECCTX) {
+			ret = -EOPNOTSUPP;
+			goto err_out_unlock;
+		}
+#endif
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
-- 
1.9.1



On 06/10/2015 06:05 PM, Florian Westphal wrote:
> Roman Kubiak <r.kubiak@samsung.com> wrote:
>> diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
>> index 8dd819e..b67a853 100644
>> --- a/include/uapi/linux/netfilter/nfnetlink_queue.h
>> +++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
>> @@ -49,6 +49,7 @@ enum nfqnl_attr_type {
>>  	NFQA_EXP,			/* nf_conntrack_netlink.h */
>>  	NFQA_UID,			/* __u32 sk uid */
>>  	NFQA_GID,			/* __u32 sk gid */
>> +	NFQA_SECCTX,			/* security context string */
>>  
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
>> index 0b98c74..2c35112 100644
>> --- a/net/netfilter/nfnetlink_queue_core.c
>> +++ b/net/netfilter/nfnetlink_queue_core.c
>> @@ -278,6 +278,24 @@ nla_put_failure:
>>  	return -1;
>>  }
>>  
>> +static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
>> +{
>> +	u32 seclen = 0;
> 
> place
> 
> #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
> 
> here?
> 
> I also think it makes sense to reject NFQA_CFG_F_SECCTX config flag in
> nfqnl_recv_config() when IS_ENABLED(CONFIG_NETWORK_SECMARK) is not set;
> i'd suggest to return EOPNOTSUPP in that case.
> 

-- 
--------------
 Roman Kubiak
--------------
