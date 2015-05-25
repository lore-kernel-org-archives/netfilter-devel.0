From: Roman Kubiak <r.kubiak@samsung.com>
Subject: [PATCH] Security context information added to netfilter_queue
Date: Mon, 25 May 2015 12:16:01 +0200
Message-ID: <5562F661.5000503@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout1.w1.samsung.com ([210.118.77.11]:30454 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbbEYKQE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2015 06:16:04 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout1.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0NOW0049FHUPPF20@mailout1.w1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 25 May 2015 11:16:01 +0100 (BST)
Received: from [106.120.53.13] by eusync1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTPA id <0NOW00BCHHUPB6B0@eusync1.samsung.com> for
 netfilter-devel@vger.kernel.org; Mon, 25 May 2015 11:16:01 +0100 (BST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>From dccc2ca387d7b4dd16fff537ce2cab280517cab5 Mon Sep 17 00:00:00 2001
From: Roman Kubiak <r.kubiak@samsung.com>
Date: Wed, 22 Apr 2015 15:54:20 +0200
Subject: [PATCH] Security context information added to netfilter_queue

This patch adds an additional attribute when sending
packet information via netlink in netfilter_queue module.
It will send additional security context data, so that
userspace applications can verify this context against
their own security databases.

Signed-off-by: Roman Kubiak <r.kubiak@samsung.com>
---
 include/uapi/linux/netfilter/nfnetlink_queue.h |  4 ++-
 net/netfilter/nfnetlink_queue_core.c           | 46 ++++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_queue.h b/include/uapi/linux/netfilter/nfnetlink_queue.h
index 8dd819e..313935a 100644
--- a/include/uapi/linux/netfilter/nfnetlink_queue.h
+++ b/include/uapi/linux/netfilter/nfnetlink_queue.h
@@ -49,6 +49,7 @@ enum nfqnl_attr_type {
 	NFQA_EXP,			/* nf_conntrack_netlink.h */
 	NFQA_UID,			/* __u32 sk uid */
 	NFQA_GID,			/* __u32 sk gid */
+	NFQA_SECCTX,			/* security context, NL_A_STRING */
 
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
index 0b98c74..de3b97a 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -278,6 +278,27 @@ nla_put_failure:
 	return -1;
 }
 
+static int nfqnl_get_sk_secctx(struct sock *sk, char **secdata, u32 *seclen)
+{
+	u32 secid = 0;
+	int ret = -1;
+
+	if (!sk)
+		return ret;
+
+	if (!sk_fullsock(sk))
+		return ret;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	security_sk_getsecid(sk, &secid);
+
+	if (secid)
+		ret = security_secid_to_secctx(secid, secdata, seclen);
+
+	read_unlock_bh(&sk->sk_callback_lock);
+	return ret;
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
@@ -352,6 +376,13 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 			+ nla_total_size(sizeof(u_int32_t)));	/* gid */
 	}
 
+	if (queue->flags & NFQA_CFG_F_SECCTX) {
+		if (nfqnl_get_sk_secctx(entskb->sk, &secdata, &seclen) == 0) {
+			if (seclen > 0)
+				size += nla_total_size(seclen) + 1;
+		}
+	}
+
 	skb = nfnetlink_alloc_skb(net, size, queue->peer_portid,
 				  GFP_ATOMIC);
 	if (!skb) {
@@ -479,6 +510,20 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
+	if ((queue->flags & NFQA_CFG_F_SECCTX) && seclen > 0) {
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
 
@@ -509,6 +554,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 nla_put_failure:
 	skb_tx_error(entskb);
 	kfree_skb(skb);
+	kfree(secdata_nterm);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 	return NULL;
 }
-- 
1.9.1
