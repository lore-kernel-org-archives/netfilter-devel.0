From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next 2/4] netfilter: move tee_active to core
Date: Wed,  8 Jul 2015 23:15:37 +0200
Message-ID: <1436390139-4405-3-git-send-email-fw@strlen.de>
References: <1436390139-4405-1-git-send-email-fw@strlen.de>
Cc: eric.dumazet@gmail.com, Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:37538 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758357AbbGHVIb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jul 2015 17:08:31 -0400
In-Reply-To: <1436390139-4405-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This prepares for a TEE like expression in nftables.
We want to ensure only one duplicate is sent, so both will
use the same percpu variable to detect duplication.

The other use case is detection of recursive call to xtables, but since
we don't want dependency from nft to xtables its put into core.c
instead of the x_tables core.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter.h | 11 +++++++++++
 net/netfilter/core.c      |  3 +++
 net/netfilter/xt_TEE.c    | 13 ++++++-------
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 00050df..4881d48 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -385,4 +385,15 @@ extern struct nfq_ct_hook __rcu *nfq_ct_hook;
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
 
+/**
+ * nf_skb_duplicated - TEE target has sent a packet
+ *
+ * When a xtables target sends a packet, the OUTPUT and POSTROUTING
+ * hooks are traversed again, i.e. nft and xtables are invoked recursively.
+ *
+ * This is used by xtables TEE target to prevent the duplicated skb from
+ * being duplicated again.
+ */
+DECLARE_PER_CPU(bool, nf_skb_duplicated);
+
 #endif /*__LINUX_NETFILTER_H*/
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a0e5497..254032d 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -34,6 +34,9 @@ EXPORT_SYMBOL(nf_afinfo);
 const struct nf_ipv6_ops __rcu *nf_ipv6_ops __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ipv6_ops);
 
+DEFINE_PER_CPU(bool, nf_skb_duplicated);
+EXPORT_SYMBOL_GPL(nf_skb_duplicated);
+
 int nf_register_afinfo(const struct nf_afinfo *afinfo)
 {
 	mutex_lock(&afinfo_mutex);
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index a747eb4..8950e79 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -37,7 +37,6 @@ struct xt_tee_priv {
 };
 
 static const union nf_inet_addr tee_zero_address;
-static DEFINE_PER_CPU(bool, tee_active);
 
 static struct net *pick_net(struct sk_buff *skb)
 {
@@ -88,7 +87,7 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	const struct xt_tee_tginfo *info = par->targinfo;
 	struct iphdr *iph;
 
-	if (__this_cpu_read(tee_active))
+	if (__this_cpu_read(nf_skb_duplicated))
 		return XT_CONTINUE;
 	/*
 	 * Copy the skb, and route the copy. Will later return %XT_CONTINUE for
@@ -125,9 +124,9 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
 	ip_send_check(iph);
 
 	if (tee_tg_route4(skb, info)) {
-		__this_cpu_write(tee_active, true);
+		__this_cpu_write(nf_skb_duplicated, true);
 		ip_local_out(skb);
-		__this_cpu_write(tee_active, false);
+		__this_cpu_write(nf_skb_duplicated, false);
 	} else {
 		kfree_skb(skb);
 	}
@@ -170,7 +169,7 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 {
 	const struct xt_tee_tginfo *info = par->targinfo;
 
-	if (__this_cpu_read(tee_active))
+	if (__this_cpu_read(nf_skb_duplicated))
 		return XT_CONTINUE;
 	skb = pskb_copy(skb, GFP_ATOMIC);
 	if (skb == NULL)
@@ -188,9 +187,9 @@ tee_tg6(struct sk_buff *skb, const struct xt_action_param *par)
 		--iph->hop_limit;
 	}
 	if (tee_tg_route6(skb, info)) {
-		__this_cpu_write(tee_active, true);
+		__this_cpu_write(nf_skb_duplicated, true);
 		ip6_local_out(skb);
-		__this_cpu_write(tee_active, false);
+		__this_cpu_write(nf_skb_duplicated, false);
 	} else {
 		kfree_skb(skb);
 	}
-- 
2.1.0

