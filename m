From: Roman Kubiak <r.kubiak@samsung.com>
Subject: Re: [PATCH v3] nfnetlink_queue: add security context information
Date: Wed, 10 Jun 2015 17:20:18 +0200
Message-ID: <557855B2.8030803@samsung.com>
References: <5562F661.5000503@samsung.com> <20150525131319.GA3529@salvia>
 <55634935.4020100@samsung.com> <20150525205210.GG3629@breakpoint.cc>
 <55646731.9040803@samsung.com> <20150526130623.GD7817@breakpoint.cc>
 <5565A4D2.70701@samsung.com> <5565A6AA.90908@samsung.com>
 <20150527124957.GA19819@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	=?UTF-8?B?UmFmYcWCIEtyeXBh?= <r.krypa@samsung.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:49998 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbbFJPUW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Jun 2015 11:20:22 -0400
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NPQ001CAILV7LC0@mailout3.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Wed, 10 Jun 2015 16:20:19 +0100 (BST)
In-reply-to: <20150527124957.GA19819@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So after some discussion on the security mailing list i had to figure out a way to implement what i wanted
without added security functions and ops.

So the below v4 patch version does that, is uses the secmark field of the sk_buff structure to get the
secid and map that to the security context. I tested it and it works with SMACK and the option:
CONFIG_SECURITY_SMACK_NETFILTER

i don't know about SELinux but it should work assuming that they map secid to secctx.

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
---
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  4 +++-
 net/netfilter/nfnetlink_queue_core.c           | 29 ++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)

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
index 0b98c74..2c35112 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -278,6 +278,24 @@ nla_put_failure:
 	return -1;
 }
 
+static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+{
+	u32 seclen = 0;
+
+	if (!skb || !sk_fullsock(skb->sk))
+		return 0;
+
+#if IS_ENABLED(CONFIG_NETWORK_SECMARK)
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
@@ -297,6 +315,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	bool csum_verify;
+	char *secdata = NULL;
+	u32 seclen = 0;
 
 	size =    nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -352,6 +372,12 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -479,6 +505,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+		goto nla_put_failure;
+
 	if (ct && nfqnl_ct_put(skb, ct, ctinfo) < 0)
 		goto nla_put_failure;
 
-- 
1.9.1


On 05/27/2015 02:49 PM, Pablo Neira Ayuso wrote:
> On Wed, May 27, 2015 at 01:12:42PM +0200, Roman Kubiak wrote:
>> I think i forgot to mention one important thing the function:
>> security_sk_getsecid is not in the kernel yet, i posted a patch to
>> add it on the linux-security-module mailing list:
>> http://marc.info/?t=143254934900006&r=1&w=2
> 
> You shouldn't split the patches between several lists, they are
> interdependent and without that context it is normal that people don't
> understand your intentions.
> 
> So please send the full patchset, Cc'ing the relevant lists so we can
> get feedback from both the netfilter and the linux-security
> communities.
> 
> BTW, another minor nitpick below:
> 
>>> diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
>>> index 0b98c74..ae4f520 100644
>>> --- a/net/netfilter/nfnetlink_queue_core.c
>>> +++ b/net/netfilter/nfnetlink_queue_core.c
>>> @@ -278,6 +278,24 @@ nla_put_failure:
>>>  	return -1;
>>>  }
>>>  
>>> +static u32 nfqnl_get_sk_secctx(struct sock *sk, char **secdata)
>>> +{
>>> +	u32 secid = 0;
>>> +	u32 seclen = 0;
> 
> Merge these two variable declarations in one line.
> 
> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
--------------
 Roman Kubiak
--------------
