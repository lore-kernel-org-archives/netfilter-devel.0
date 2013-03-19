From: holger@eitzenberger.org
Subject: [PATCH RFC 1/3] NFQUEUE: introduce CPU fanout
Date: Tue, 19 Mar 2013 15:14:43 +0100
Message-ID: <20130319141605.158831637@eitzenberger.org>
References: <20130319141442.150005875@eitzenberger.org>
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.187]:63788 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3CSOQI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:16:08 -0400
Received: from holger by kruemel.eitzenberger.org with local (Exim 4.76)
	(envelope-from <holger@eitzenberger.org>)
	id 1UHxKf-0006R7-HH
	for netfilter-devel@vger.kernel.org; Tue, 19 Mar 2013 15:16:05 +0100
Content-Disposition: inline; filename=net-next/NFQUEUE-cpu-fanout.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

---
 include/uapi/linux/netfilter/xt_NFQUEUE.h |    8 ++++++
 net/netfilter/xt_NFQUEUE.c                |   41 ++++++++++++++++++++++++++++-
 2 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/xt_NFQUEUE.h b/include/uapi/linux/netfilter/xt_NFQUEUE.h
index 9eafdbb..1f24680 100644
--- a/include/uapi/linux/netfilter/xt_NFQUEUE.h
+++ b/include/uapi/linux/netfilter/xt_NFQUEUE.h
@@ -26,4 +26,12 @@ struct xt_NFQ_info_v2 {
 	__u16 bypass;
 };
 
+struct xt_NFQ_info_v3 {
+	__u16 queuenum;
+	__u16 queues_total;
+	__u16 bypass;
+	__u16 flags;
+#define NFQ_FLAG_CPU_FANOUT		0x01 /* use current CPU (no hashing) */
+};
+
 #endif /* _XT_NFQ_TARGET_H */
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 817f9e9..cf9c6a1 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -108,7 +108,7 @@ nfqueue_tg_v2(struct sk_buff *skb, const struct xt_action_param *par)
 
 static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_NFQ_info_v2 *info = par->targinfo;
+	const struct xt_NFQ_info_v3 *info = par->targinfo;
 	u32 maxid;
 
 	if (unlikely(!rnd_inited)) {
@@ -125,11 +125,39 @@ static int nfqueue_tg_check(const struct xt_tgchk_param *par)
 		       info->queues_total, maxid);
 		return -ERANGE;
 	}
-	if (par->target->revision == 2 && info->bypass > 1)
+	if (par->target->revision >= 2 && info->bypass > 1)
+		return -EINVAL;
+	if (par->target->revision == 3 && info->flags & ~NFQ_FLAG_CPU_FANOUT)
 		return -EINVAL;
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
@@ -156,6 +184,15 @@ static struct xt_target nfqueue_tg_reg[] __read_mostly = {
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

