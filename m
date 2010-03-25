From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] netfilter: xtables: make use of caller family rather than target family
Date: Thu, 25 Mar 2010 13:56:44 +0100
Message-ID: <1269521809-29393-2-git-send-email-jengelh@medozas.de>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59861 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783Ab0CYM4w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:56:52 -0400
In-Reply-To: <1269521809-29393-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Supplement to aa5fa3185791aac71c9172d4fda3e8729164b5d1.
The semantic patch for this change is:

// <smpl>
@@
struct xt_target_param *par;
@@
-par->target->family
+par->family

@@
struct xt_tgchk_param *par;
@@
-par->target->family
+par->family

@@
struct xt_tgdtor_param *par;
@@
-par->target->family
+par->family
// </smpl>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ipt_CLUSTERIP.c |    6 +++---
 net/netfilter/xt_NFQUEUE.c         |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 0886f96..a20bee7 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -401,9 +401,9 @@ static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 	}
 	cipinfo->config = config;
 
-	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", par->target->family);
+				    "proto=%u\n", par->family);
 		return false;
 	}
 
@@ -421,7 +421,7 @@ static void clusterip_tg_destroy(const struct xt_tgdtor_param *par)
 
 	clusterip_config_put(cipinfo->config);
 
-	nf_ct_l3proto_module_put(par->target->family);
+	nf_ct_l3proto_module_put(par->family);
 }
 
 #ifdef CONFIG_COMPAT
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index a37e216..7cc0de6 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -71,10 +71,10 @@ nfqueue_tg_v1(struct sk_buff *skb, const struct xt_target_param *par)
 	u32 queue = info->queuenum;
 
 	if (info->queues_total > 1) {
-		if (par->target->family == NFPROTO_IPV4)
+		if (par->family == NFPROTO_IPV4)
 			queue = hash_v4(skb) % info->queues_total + queue;
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-		else if (par->target->family == NFPROTO_IPV6)
+		else if (par->family == NFPROTO_IPV6)
 			queue = hash_v6(skb) % info->queues_total + queue;
 #endif
 	}
-- 
1.7.0.2

