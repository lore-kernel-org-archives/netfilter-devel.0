From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: What happened to struct xt_match_param
Date: Tue, 5 Jun 2012 14:18:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1206051415540.2829@frira.zrqbmnf.qr>
References: <CAGuaRCunyPyyot8jqYj_U_Fh041Y_v9LdcxPfx_37RmNF-F6nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57912 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932623Ab2FEMSt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jun 2012 08:18:49 -0400
In-Reply-To: <CAGuaRCunyPyyot8jqYj_U_Fh041Y_v9LdcxPfx_37RmNF-F6nQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-06-05 14:09, Aft nix wrote:

>-----BEGIN PGP SIGNED MESSAGE-----
>Hash: SHA1
>
>Hi,
>
>It seems in both 2.6 and mainline git tree, there is no reference to
>struct xt_match_param. I verified in lxr, it seems older kernels like
>2.6.32 has struct xt_match_param in <linux/netfilter/x_tables.h>

`git log` to the rescue.


parent ef53d702c3614fb919e8a8291033e3dbccfd1aea (v2.6.34-rc3-1342-gef53d70)
commit de74c16996287250f0d947663127f80c6beebd3c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Jul 5 18:26:37 2009 +0200

netfilter: xtables: combine struct xt_match_param and xt_target_param

The structures carried - besides match/target - almost the same data.
It is possible to combine them, as extensions are evaluated serially,
and so, the callers end up a little smaller.

  text  data  bss  filename
-15318   740  104  net/ipv4/netfilter/ip_tables.o
+15286   740  104  net/ipv4/netfilter/ip_tables.o
-15333   540  152  net/ipv6/netfilter/ip6_tables.o
+15269   540  152  net/ipv6/netfilter/ip6_tables.o

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   42 +++++++++++----------------
 net/bridge/netfilter/ebtables.c    |   30 ++++++++++----------
 net/ipv4/netfilter/arp_tables.c    |   16 +++++-----
 net/ipv4/netfilter/ip_tables.c     |   32 ++++++++++-----------
 net/ipv6/netfilter/ip6_tables.c    |   27 ++++++++---------
 5 files changed, 68 insertions(+), 79 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index eeb4884..5efa375 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -182,13 +182,17 @@ struct xt_counters_info {
 
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
@@ -197,10 +201,15 @@ struct xt_counters_info {
  * @hotdrop:	drop packet if we had inspection problems
  * Network namespace obtainable using dev_net(in/out)
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
@@ -243,23 +252,6 @@ struct xt_mtdtor_param {
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
@@ -298,7 +290,7 @@ struct xt_match {
 	   non-linear skb, using skb_header_pointer and
 	   skb_ip_make_writable. */
 	bool (*match)(const struct sk_buff *skb,
-		      const struct xt_match_param *);
+		      const struct xt_action_param *);
 
 	/* Called when user tries to insert an entry of this type. */
 	int (*checkentry)(const struct xt_mtchk_param *);
@@ -335,7 +327,7 @@ struct xt_target {
 	   must now handle non-linear skbs, using skb_copy_bits and
 	   skb_ip_make_writable. */
 	unsigned int (*target)(struct sk_buff *skb,
-			       const struct xt_target_param *);
+			       const struct xt_action_param *);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1d8c2c0..290d435 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -86,7 +86,7 @@ static struct xt_target ebt_standard_target = {
 
 static inline int
 ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
-	       struct xt_target_param *par)
+	       struct xt_action_param *par)
 {
 	par->target   = w->u.watcher;
 	par->targinfo = w->data;
@@ -95,8 +95,9 @@ ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
 	return 0;
 }
 
-static inline int ebt_do_match (struct ebt_entry_match *m,
-   const struct sk_buff *skb, struct xt_match_param *par)
+static inline int
+ebt_do_match(struct ebt_entry_match *m, const struct sk_buff *skb,
+	     struct xt_action_param *par)
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
@@ -186,14 +187,13 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
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
@@ -214,7 +214,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (ebt_basic_match(point, eth_hdr(skb), in, out))
 			goto letscontinue;
 
-		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &mtpar) != 0)
+		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
 			goto letscontinue;
 		if (hotdrop) {
 			read_unlock_bh(&table->lock);
@@ -227,7 +227,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 
 		/* these should only watch: not modify, nor tell us
 		   what to do with the packet */
-		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &tgpar);
+		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &acpar);
 
 		t = (struct ebt_entry_target *)
 		   (((char *)point) + point->target_offset);
@@ -235,9 +235,9 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
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
index 07a69905..73d924b8 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -265,7 +265,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	const char *indev, *outdev;
 	void *table_base;
 	const struct xt_table_info *private;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -280,10 +280,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
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
@@ -333,9 +333,9 @@ unsigned int arpt_do_table(struct sk_buff *skb,
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
index 265cedf..e1a53c2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -316,8 +316,7 @@ ipt_do_table(struct sk_buff *skb,
 	struct ipt_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
-	struct xt_match_param mtpar;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -329,13 +328,13 @@ ipt_do_table(struct sk_buff *skb,
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
@@ -358,16 +357,16 @@ ipt_do_table(struct sk_buff *skb,
 
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
 
@@ -422,11 +421,10 @@ ipt_do_table(struct sk_buff *skb,
 			continue;
 		}
 
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
index f8ac4a0..076308c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -345,8 +345,7 @@ ip6t_do_table(struct sk_buff *skb,
 	struct ip6t_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
-	struct xt_match_param mtpar;
-	struct xt_target_param tgpar;
+	struct xt_action_param acpar;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -357,11 +356,11 @@ ip6t_do_table(struct sk_buff *skb,
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
 
@@ -381,16 +380,16 @@ ip6t_do_table(struct sk_buff *skb,
 
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
 
@@ -439,10 +438,10 @@ ip6t_do_table(struct sk_buff *skb,
 			continue;
 		}
 
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
# Created with git-export-patch
