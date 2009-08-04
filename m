From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 040/103] netfilter: xtables: combine struct xt_match_param and xt_target_param
Date: Tue,  4 Aug 2009 09:25:24 +0200
Message-ID: <1249370787-17583-41-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50630 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932565AbZHDH1Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:16 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The structures carried - besides match/target - almost the same data.
Combining them makes ip6t_do_table and friends smaller.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   42 ++++++++++++++---------------------
 net/bridge/netfilter/ebtables.c    |   27 +++++++++++------------
 net/ipv4/netfilter/arp_tables.c    |   16 ++++++------
 net/ipv4/netfilter/ip_tables.c     |   32 ++++++++++++--------------
 net/ipv6/netfilter/ip6_tables.c    |   27 +++++++++++------------
 5 files changed, 66 insertions(+), 78 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index d5ff621..e918437 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -192,13 +192,17 @@ struct xt_counters_info
 
 #include <linux/netdevice.h>
 
+#define xt_match_param xt_action_param
+#define xt_target_param xt_action_param
 /**
- * struct xt_match_param - parameters for match extensions' match functions
+ * struct xt_action_param - parameters for matches/targets
  *
+ * @match:	the match extension
+ * @target:	the target extension
+ * @matchinfo:	per-match data
+ * @targetinfo:	per-target data
  * @in:		input netdevice
  * @out:	output netdevice
- * @match:	struct xt_match through which this function was invoked
- * @matchinfo:	per-match data
  * @fragoff:	packet is a fragment, this is the data offset
  * @thoff:	position of transport header relative to skb->data
  * @hook:	hook number given packet came from
@@ -206,10 +210,15 @@ struct xt_counters_info
  * 		(helpful when match->family == NFPROTO_UNSPEC)
  * @hotdrop:	drop packet if we had inspection problems
  */
-struct xt_match_param {
+struct xt_action_param {
+	union {
+		const struct xt_match *match;
+		const struct xt_target *target;
+	};
+	union {
+		const void *matchinfo, *targinfo;
+	};
 	const struct net_device *in, *out;
-	const struct xt_match *match;
-	const void *matchinfo;
 	int fragoff;
 	unsigned int thoff;
 	unsigned int hooknum;
@@ -245,23 +254,6 @@ struct xt_mtdtor_param {
 };
 
 /**
- * struct xt_target_param - parameters for target extensions' target functions
- *
- * @hooknum:	hook through which this target was invoked
- * @target:	struct xt_target through which this function was invoked
- * @targinfo:	per-target data
- *
- * Other fields see above.
- */
-struct xt_target_param {
-	const struct net_device *in, *out;
-	const struct xt_target *target;
-	const void *targinfo;
-	unsigned int hooknum;
-	u_int8_t family;
-};
-
-/**
  * struct xt_tgchk_param - parameters for target extensions'
  * checkentry functions
  *
@@ -299,7 +291,7 @@ struct xt_match
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
 	bool (*match)(const struct sk_buff *skb,
-		      const struct xt_match_param *);
+		      const struct xt_action_param *);
 
 	/* Called when user tries to insert an entry of this type. */
 	bool (*checkentry)(const struct xt_mtchk_param *);
@@ -337,7 +329,7 @@ struct xt_target
 	   must now handle non-linear skbs, using skb_copy_bits and
 	   skb_ip_make_writable. */
 	unsigned int (*target)(struct sk_buff *skb,
-			       const struct xt_target_param *);
+			       const struct xt_action_param *);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 9ed98d9..281a531 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -65,7 +65,7 @@ static struct xt_target ebt_standard_target = {
 
 static inline int
 ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
-	       struct xt_target_param *par)
+	       struct xt_action_param *par)
 {
 	par->target   = w->u.watcher;
 	par->targinfo = w->data;
@@ -75,7 +75,7 @@ ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
 }
 
 static inline int ebt_do_match (struct ebt_entry_match *m,
-   const struct sk_buff *skb, struct xt_match_param *par)
+   const struct sk_buff *skb, struct xt_action_param *par)
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
@@ -165,14 +165,13 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	const char *base;
 	const struct ebt_table_info *private;
 	bool hotdrop = false;
-	struct xt_match_param mtpar;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
-	mtpar.family  = tgpar.family = NFPROTO_BRIDGE;
-	mtpar.in      = tgpar.in  = in;
-	mtpar.out     = tgpar.out = out;
-	mtpar.hotdrop = &hotdrop;
-	mtpar.hooknum = tgpar.hooknum = hook;
+	acpar.family  = NFPROTO_BRIDGE;
+	acpar.in      = in;
+	acpar.out     = out;
+	acpar.hotdrop = &hotdrop;
+	acpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
 	private = table->private;
@@ -193,7 +192,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (ebt_basic_match(point, eth_hdr(skb), in, out))
 			goto letscontinue;
 
-		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &mtpar) != 0)
+		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
 			goto letscontinue;
 		if (hotdrop) {
 			read_unlock_bh(&table->lock);
@@ -206,7 +205,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 
 		/* these should only watch: not modify, nor tell us
 		   what to do with the packet */
-		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &tgpar);
+		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &acpar);
 
 		t = (struct ebt_entry_target *)
 		   (((char *)point) + point->target_offset);
@@ -214,9 +213,9 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
 		else {
-			tgpar.target   = t->u.target;
-			tgpar.targinfo = t->data;
-			verdict = t->u.target->target(skb, &tgpar);
+			acpar.target   = t->u.target;
+			acpar.targinfo = t->data;
+			verdict = t->u.target->target(skb, &acpar);
 		}
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 0150944..f05858c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -258,7 +258,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	const char *indev, *outdev;
 	void *table_base;
 	const struct xt_table_info *private;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -273,10 +273,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
 
-	tgpar.in      = in;
-	tgpar.out     = out;
-	tgpar.hooknum = hook;
-	tgpar.family  = NFPROTO_ARP;
+	acpar.in      = in;
+	acpar.out     = out;
+	acpar.hooknum = hook;
+	acpar.family  = NFPROTO_ARP;
 
 	arp = arp_hdr(skb);
 	do {
@@ -326,9 +326,9 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 		/* Targets which reenter must return
 		 * abs. verdicts
 		 */
-		tgpar.target   = t->u.kernel.target;
-		tgpar.targinfo = t->data;
-		verdict = t->u.kernel.target->target(skb, &tgpar);
+		acpar.target   = t->u.kernel.target;
+		acpar.targinfo = t->data;
+		verdict = t->u.kernel.target->target(skb, &acpar);
 
 		/* Target might have changed stuff. */
 		arp = arp_hdr(skb);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 173b33b..ff90bc4 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -310,8 +310,7 @@ ipt_do_table(struct sk_buff *skb,
 	struct ipt_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
-	struct xt_match_param mtpar;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -323,13 +322,13 @@ ipt_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
-	mtpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
-	mtpar.thoff   = ip_hdrlen(skb);
-	mtpar.hotdrop = &hotdrop;
-	mtpar.in      = tgpar.in  = in;
-	mtpar.out     = tgpar.out = out;
-	mtpar.family  = tgpar.family = NFPROTO_IPV4;
-	mtpar.hooknum = tgpar.hooknum = hook;
+	acpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
+	acpar.thoff   = ip_hdrlen(skb);
+	acpar.hotdrop = &hotdrop;
+	acpar.in      = in;
+	acpar.out     = out;
+	acpar.family  = NFPROTO_IPV4;
+	acpar.hooknum = hook;
 
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 	xt_info_rdlock_bh();
@@ -352,16 +351,16 @@ ipt_do_table(struct sk_buff *skb,
 
 		IP_NF_ASSERT(e);
 		if (!ip_packet_match(ip, indev, outdev,
-		    &e->ip, mtpar.fragoff)) {
+		    &e->ip, acpar.fragoff)) {
  no_match:
 			e = ipt_next_entry(e);
 			continue;
 		}
 
 		xt_ematch_foreach(ematch, e) {
-			mtpar.match     = ematch->u.kernel.match;
-			mtpar.matchinfo = ematch->data;
-			if (!mtpar.match->match(skb, &mtpar))
+			acpar.match     = ematch->u.kernel.match;
+			acpar.matchinfo = ematch->data;
+			if (!acpar.match->match(skb, &acpar))
 				goto no_match;
 		}
 
@@ -418,11 +417,10 @@ ipt_do_table(struct sk_buff *skb,
 
 		/* Targets which reenter must return
 		   abs. verdicts */
-		tgpar.target   = t->u.kernel.target;
-		tgpar.targinfo = t->data;
+		acpar.target   = t->u.kernel.target;
+		acpar.targinfo = t->data;
 
-
-		verdict = t->u.kernel.target->target(skb, &tgpar);
+		verdict = t->u.kernel.target->target(skb, &acpar);
 		/* Target might have changed stuff. */
 		ip = ip_hdr(skb);
 		if (verdict == IPT_CONTINUE)
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d9d5477..296b76d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -339,8 +339,7 @@ ip6t_do_table(struct sk_buff *skb,
 	struct ip6t_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
-	struct xt_match_param mtpar;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -351,11 +350,11 @@ ip6t_do_table(struct sk_buff *skb,
 	 * things we don't know, ie. tcp syn flag or ports).  If the
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
-	mtpar.hotdrop = &hotdrop;
-	mtpar.in      = tgpar.in  = in;
-	mtpar.out     = tgpar.out = out;
-	mtpar.family  = tgpar.family = NFPROTO_IPV6;
-	mtpar.hooknum = tgpar.hooknum = hook;
+	acpar.hotdrop = &hotdrop;
+	acpar.in      = in;
+	acpar.out     = out;
+	acpar.family  = NFPROTO_IPV6;
+	acpar.hooknum = hook;
 
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
 
@@ -375,16 +374,16 @@ ip6t_do_table(struct sk_buff *skb,
 
 		IP_NF_ASSERT(e);
 		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
-		    &mtpar.thoff, &mtpar.fragoff, &hotdrop)) {
+		    &acpar.thoff, &acpar.fragoff, &hotdrop)) {
  no_match:
 			e = ip6t_next_entry(e);
 			continue;
 		}
 
 		xt_ematch_foreach(ematch, e) {
-			mtpar.match     = ematch->u.kernel.match;
-			mtpar.matchinfo = ematch->data;
-			if (!mtpar.match->match(skb, &mtpar))
+			acpar.match     = ematch->u.kernel.match;
+			acpar.matchinfo = ematch->data;
+			if (!acpar.match->match(skb, &acpar))
 				goto no_match;
 		}
 
@@ -435,10 +434,10 @@ ip6t_do_table(struct sk_buff *skb,
 
 		/* Targets which reenter must return
 		   abs. verdicts */
-		tgpar.target   = t->u.kernel.target;
-		tgpar.targinfo = t->data;
+		acpar.target   = t->u.kernel.target;
+		acpar.targinfo = t->data;
 
-		verdict = t->u.kernel.target->target(skb, &tgpar);
+		verdict = t->u.kernel.target->target(skb, &acpar);
 		if (verdict == IP6T_CONTINUE)
 			e = ip6t_next_entry(e);
 		else
-- 
1.6.3.3

