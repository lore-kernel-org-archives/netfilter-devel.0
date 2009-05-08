From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/11] netfilter: xtables: consolidate comefrom debug cast access
Date: Fri,  8 May 2009 11:26:40 +0200
Message-ID: <1241774801-2315-11-git-send-email-jengelh@medozas.de>
References: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53365 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756042AbZEHJ0p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 May 2009 05:26:45 -0400
In-Reply-To: <1241774801-2315-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/ip_tables.c  |   13 +++++++++----
 net/ipv6/netfilter/ip6_tables.c |   13 ++++++++-----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index d91ecd4..7b35c0b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -311,6 +311,8 @@ ipt_do_table(struct sk_buff *skb,
 	     const struct net_device *out,
 	     struct xt_table *table)
 {
+#define tb_comefrom ((struct ipt_entry *)table_base)->comefrom
+
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
 	u_int16_t datalen;
@@ -409,18 +411,19 @@ ipt_do_table(struct sk_buff *skb,
 		   abs. verdicts */
 		tgpar.target   = t->u.kernel.target;
 		tgpar.targinfo = t->data;
+
+
 #ifdef CONFIG_NETFILTER_DEBUG
-		((struct ipt_entry *)table_base)->comefrom = 0xeeeeeeec;
+		tb_comefrom = 0xeeeeeeec;
 #endif
 		verdict = t->u.kernel.target->target(skb, &tgpar);
 #ifdef CONFIG_NETFILTER_DEBUG
-		if (((struct ipt_entry *)table_base)->comefrom != 0xeeeeeeec &&
-		    verdict == IPT_CONTINUE) {
+		if (comefrom != 0xeeeeeeec && verdict == IPT_CONTINUE) {
 			printk("Target %s reentered!\n",
 			       t->u.kernel.target->name);
 			verdict = NF_DROP;
 		}
-		((struct ipt_entry *)table_base)->comefrom = 0x57acc001;
+		tb_comefrom = 0x57acc001;
 #endif
 		/* Target might have changed stuff. */
 		ip = ip_hdr(skb);
@@ -441,6 +444,8 @@ ipt_do_table(struct sk_buff *skb,
 		return NF_DROP;
 	else return verdict;
 #endif
+
+#undef tb_comefrom
 }
 
 /* Figures out from what hook each rule can be called: returns 0 if
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 5a178be..5164e0b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -343,6 +343,8 @@ ip6t_do_table(struct sk_buff *skb,
 	      const struct net_device *out,
 	      struct xt_table *table)
 {
+#define tb_comefrom ((struct ip6t_entry *)table_base)->comefrom
+
 	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	bool hotdrop = false;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
@@ -440,18 +442,17 @@ ip6t_do_table(struct sk_buff *skb,
 		tgpar.targinfo = t->data;
 
 #ifdef CONFIG_NETFILTER_DEBUG
-		((struct ip6t_entry *)table_base)->comefrom = 0xeeeeeeec;
+		tb_comefrom = 0xeeeeeeec;
 #endif
 		verdict = t->u.kernel.target->target(skb, &tgpar);
 
 #ifdef CONFIG_NETFILTER_DEBUG
-		if (((struct ip6t_entry *)table_base)->comefrom != 0xeeeeeeec &&
-		    verdict == IP6T_CONTINUE) {
+		if (tb_comefrom != 0xeeeeeeec && verdict == IP6T_CONTINUE) {
 			printk("Target %s reentered!\n",
 			       t->u.kernel.target->name);
 			verdict = NF_DROP;
 		}
-		((struct ip6t_entry *)table_base)->comefrom = 0x57acc001;
+		tb_comefrom = 0x57acc001;
 #endif
 		if (verdict == IP6T_CONTINUE)
 			e = ip6t_next_entry(e);
@@ -461,7 +462,7 @@ ip6t_do_table(struct sk_buff *skb,
 	} while (!hotdrop);
 
 #ifdef CONFIG_NETFILTER_DEBUG
-	((struct ip6t_entry *)table_base)->comefrom = NETFILTER_LINK_POISON;
+	tb_comefrom = NETFILTER_LINK_POISON;
 #endif
 	xt_info_rdunlock_bh();
 
@@ -472,6 +473,8 @@ ip6t_do_table(struct sk_buff *skb,
 		return NF_DROP;
 	else return verdict;
 #endif
+
+#undef tb_comefrom
 }
 
 /* Figures out from what hook each rule can be called: returns 0 if
-- 
1.6.2.2

