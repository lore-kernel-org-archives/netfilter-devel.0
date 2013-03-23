From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH v2 1/3] NFQUEUE: introduce CPU fanout
Date: Sat, 23 Mar 2013 21:04:03 +0100
Message-ID: <20130323200607.689360263@eitzenberger.org>
References: <20130323200402.209591997@eitzenberger.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:52671 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab3CWUGK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Mar 2013 16:06:10 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UJUhc-000495-0S
	for netfilter-devel@vger.kernel.org; Sat, 23 Mar 2013 21:06:08 +0100
Content-Disposition: inline; filename=net-next/NFQUEUE-cpu-fanout.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The 'flags' are folded into _v2 'bypass'.

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: net-next/include/uapi/linux/netfilter/xt_NFQUEUE.h
===================================================================
--- net-next.orig/include/uapi/linux/netfilter/xt_NFQUEUE.h	2013-03-23 18:08:11.000000000 +0100
+++ net-next/include/uapi/linux/netfilter/xt_NFQUEUE.h	2013-03-23 19:00:54.000000000 +0100
@@ -26,4 +26,13 @@
 	__u16 bypass;
 };
 
+struct xt_NFQ_info_v3 {
+	__u16 queuenum;
+	__u16 queues_total;
+	__u16 flags;
+#define NFQ_FLAG_BYPASS		0x01 /* for compatibility with v2 */
+#define NFQ_FLAG_CPU_FANOUT	0x02 /* use current CPU (no hashing) */
+#define NFQ_FLAG_MASK		0x03
+};
+
 #endif /* _XT_NFQ_TARGET_H */
Index: net-next/net/netfilter/xt_NFQUEUE.c
===================================================================
--- net-next.orig/net/netfilter/xt_NFQUEUE.c	2013-03-23 18:08:11.000000000 +0100
+++ net-next/net/netfilter/xt_NFQUEUE.c	2013-03-23 19:01:11.000000000 +0100
@@ -108,7 +108,7 @@
 
 static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_NFQ_info_v2 *info = par->targinfo;
+	const struct xt_NFQ_info_v3 *info = par->targinfo;
 	u32 maxid;
 
 	if (unlikely(!rnd_inited)) {
@@ -125,11 +125,39 @@
 		       info->queues_total, maxid);
 		return -ERANGE;
 	}
-	if (par->target->revision == 2 && info->bypass > 1)
+	if (par->target->revision == 2 && info->flags > 1)
 		return -EINVAL;
+	if (par->target->revision == 3 && info->flags & ~NFQ_FLAG_MASK)
+		return -EINVAL;
+
 	return 0;
 }
 
+static unsigned int
+nfqueue_tg_v3(struct sk_buff *skb, const struct xt_action_param *par)
+{
+	const struct xt_NFQ_info_v3 *info = par->targinfo;
+	u32 queue = info->queuenum;
+
+	if (info->queues_total > 1) {
+		if (info->flags & NFQ_FLAG_CPU_FANOUT) {
+			int cpu = smp_processor_id();
+
+			queue = info->queuenum + cpu % info->queues_total;
+		} else {
+			if (par->family == NFPROTO_IPV4)
+				queue = (((u64) hash_v4(skb) * info->queues_total) >>
+						 32) + queue;
+#if IS_ENABLED(CONFIG_IP6_NF_IPTABLES)
+			else if (par->family == NFPROTO_IPV6)
+				queue = (((u64) hash_v6(skb) * info->queues_total) >>
+						 32) + queue;
+#endif
+		}
+	}
+	return NF_QUEUE_NR(queue);
+}
+
 static struct xt_target nfqueue_tg_reg[] __read_mostly = {
 	{
 		.name		= "NFQUEUE",
@@ -156,6 +184,15 @@
 		.targetsize	= sizeof(struct xt_NFQ_info_v2),
 		.me		= THIS_MODULE,
 	},
+	{
+		.name		= "NFQUEUE",
+		.revision	= 3,
+		.family		= NFPROTO_UNSPEC,
+		.checkentry	= nfqueue_tg_check,
+		.target		= nfqueue_tg_v3,
+		.targetsize	= sizeof(struct xt_NFQ_info_v3),
+		.me		= THIS_MODULE,
+	},
 };
 
 static int __init nfqueue_tg_init(void)

