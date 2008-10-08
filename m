From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 73/79: xtables: move extension arguments into compound structure (4/6)
Date: Wed,  8 Oct 2008 12:48:00 +0200 (MEST)
Message-ID: <20081008104800.10423.28324.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824AbYJHKsB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:01 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 7eb3558655aaa87a3e71a0c065dfaddda521fa6d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:19 2008 +0200

    netfilter: xtables: move extension arguments into compound structure (4/6)
    
    This patch does this for target extensions' target functions.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c79c883..46d0cb1 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -218,6 +218,22 @@ struct xt_mtdtor_param {
 	void *matchinfo;
 };
 
+/**
+ * struct xt_target_param - parameters for target extensions' target functions
+ *
+ * @hooknum:	hook through which this target was invoked
+ * @target:	struct xt_target through which this function was invoked
+ * @targinfo:	per-target data
+ *
+ * Other fields see above.
+ */
+struct xt_target_param {
+	const struct net_device *in, *out;
+	unsigned int hooknum;
+	const struct xt_target *target;
+	const void *targinfo;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -269,11 +285,7 @@ struct xt_target
 	   must now handle non-linear skbs, using skb_copy_bits and
 	   skb_ip_make_writable. */
 	unsigned int (*target)(struct sk_buff *skb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const struct xt_target *target,
-			       const void *targinfo);
+			       const struct xt_target_param *);
 
 	/* Called when user tries to insert an entry of this type:
            hook_mask is a bitmask of hooks from which it can be
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index baf5510..fc94699 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -16,11 +16,9 @@
 #include <linux/netfilter_bridge/ebt_arpreply.h>
 
 static unsigned int
-ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hook_nr,
-		const struct xt_target *target, const void *data)
+ebt_arpreply_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_arpreply_info *info = data;
+	const struct ebt_arpreply_info *info = par->targinfo;
 	const __be32 *siptr, *diptr;
 	__be32 _sip, _dip;
 	const struct arphdr *ap;
@@ -53,7 +51,7 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
 	if (diptr == NULL)
 		return EBT_DROP;
 
-	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)in,
+	arp_send(ARPOP_REPLY, ETH_P_ARP, *siptr, (struct net_device *)par->in,
 		 *diptr, shp, info->mac, shp);
 
 	return info->target;
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index cb80101..bb5d79e 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -15,11 +15,9 @@
 #include <linux/netfilter_bridge/ebt_nat.h>
 
 static unsigned int
-ebt_dnat_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_dnat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index b40f9ed..87de5fc 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -195,11 +195,9 @@ out:
 }
 
 static unsigned int
-ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
-	   const struct net_device *out, unsigned int hooknr,
-	   const struct xt_target *target, const void *data)
+ebt_log_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_log_info *info = data;
+	const struct ebt_log_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
@@ -207,11 +205,11 @@ ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.log.logflags = info->bitmask;
 
 	if (info->bitmask & EBT_LOG_NFLOG)
-		nf_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
-			      "%s", info->prefix);
+		nf_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
+		              par->out, &li, "%s", info->prefix);
 	else
-		ebt_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
-			       info->prefix);
+		ebt_log_packet(NFPROTO_BRIDGE, par->hooknum, skb, par->in,
+		               par->out, &li, info->prefix);
 	return EBT_CONTINUE;
 }
 
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index dff19fc..aafc456 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -19,11 +19,9 @@
 #include <linux/netfilter_bridge/ebt_mark_t.h>
 
 static unsigned int
-ebt_mark_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_mark_t_info *info = data;
+	const struct ebt_mark_t_info *info = par->targinfo;
 	int action = info->target & -16;
 
 	if (action == MARK_SET_VALUE)
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 74b4fa0..6a28d99 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -20,11 +20,9 @@
 #include <net/netfilter/nf_log.h>
 
 static unsigned int
-ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
-	     const struct net_device *out, unsigned int hooknr,
-	     const struct xt_target *target, const void *data)
+ebt_nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_nflog_info *info = data;
+	const struct ebt_nflog_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_ULOG;
@@ -32,7 +30,8 @@ ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.ulog.group = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
+	nf_log_packet(PF_BRIDGE, par->hooknum, skb, par->in, par->out,
+	              &li, "%s", info->prefix);
 	return EBT_CONTINUE;
 }
 
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index a50ffbe..0cfe2fa 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -16,20 +16,18 @@
 #include <linux/netfilter_bridge/ebt_redirect.h>
 
 static unsigned int
-ebt_redirect_tg(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknr,
-		const struct xt_target *target, const void *data)
+ebt_redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_redirect_info *info = data;
+	const struct ebt_redirect_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
 
-	if (hooknr != NF_BR_BROUTING)
+	if (par->hooknum != NF_BR_BROUTING)
 		memcpy(eth_hdr(skb)->h_dest,
-		       in->br_port->br->dev->dev_addr, ETH_ALEN);
+		       par->in->br_port->br->dev->dev_addr, ETH_ALEN);
 	else
-		memcpy(eth_hdr(skb)->h_dest, in->dev_addr, ETH_ALEN);
+		memcpy(eth_hdr(skb)->h_dest, par->in->dev_addr, ETH_ALEN);
 	skb->pkt_type = PACKET_HOST;
 	return info->target;
 }
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 8a55c7d..f55960e 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -17,11 +17,9 @@
 #include <linux/netfilter_bridge/ebt_nat.h>
 
 static unsigned int
-ebt_snat_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hook_nr,
-	    const struct xt_target *target, const void *data)
+ebt_snat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (!skb_make_writable(skb, 0))
 		return EBT_DROP;
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 25ca646..bfedf12 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -247,13 +247,10 @@ static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 }
 
 static unsigned int
-ebt_ulog_tg(struct sk_buff *skb, const struct net_device *in,
-	    const struct net_device *out, unsigned int hooknr,
-	    const struct xt_target *target, const void *data)
+ebt_ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ebt_ulog_info *uloginfo = data;
-
-	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
+	ebt_ulog_packet(par->hooknum, skb, par->in, par->out,
+	                par->targinfo, NULL);
 	return EBT_CONTINUE;
 }
 
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 0320b52..a1156ba 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -64,11 +64,13 @@ static struct xt_target ebt_standard_target = {
 	.targetsize = sizeof(int),
 };
 
-static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
-   struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
-   const struct net_device *out)
+static inline int
+ebt_do_watcher(const struct ebt_entry_watcher *w, struct sk_buff *skb,
+	       struct xt_target_param *par)
 {
-	w->u.watcher->target(skb, in, out, hooknr, w->u.watcher, w->data);
+	par->target   = w->u.watcher;
+	par->targinfo = w->data;
+	w->u.watcher->target(skb, par);
 	/* watchers don't give a verdict */
 	return 0;
 }
@@ -156,10 +158,12 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	struct ebt_table_info *private;
 	bool hotdrop = false;
 	struct xt_match_param mtpar;
+	struct xt_target_param tgpar;
 
-	mtpar.in      = in;
-	mtpar.out     = out;
+	mtpar.in      = tgpar.in  = in;
+	mtpar.out     = tgpar.out = out;
 	mtpar.hotdrop = &hotdrop;
+	tgpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
 	private = table->private;
@@ -193,17 +197,18 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 
 		/* these should only watch: not modify, nor tell us
 		   what to do with the packet */
-		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, hook, in,
-		   out);
+		EBT_WATCHER_ITERATE(point, ebt_do_watcher, skb, &tgpar);
 
 		t = (struct ebt_entry_target *)
 		   (((char *)point) + point->target_offset);
 		/* standard target */
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
-		else
-			verdict = t->u.target->target(skb, in, out, hook,
-				  t->u.target, t->data);
+		else {
+			tgpar.target   = t->u.target;
+			tgpar.targinfo = t->data;
+			verdict = t->u.target->target(skb, &tgpar);
+		}
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index ae525a9..5b631ad 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -200,15 +200,12 @@ static inline int arp_checkentry(const struct arpt_arp *arp)
 	return 1;
 }
 
-static unsigned int arpt_error(struct sk_buff *skb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       unsigned int hooknum,
-			       const struct xt_target *target,
-			       const void *targinfo)
+static unsigned int
+arpt_error(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("arp_tables: error: '%s'\n", (char *)targinfo);
+		printk("arp_tables: error: '%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -232,6 +229,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	const char *indev, *outdev;
 	void *table_base;
 	const struct xt_table_info *private;
+	struct xt_target_param tgpar;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
@@ -245,6 +243,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	e = get_entry(table_base, private->hook_entry[hook]);
 	back = get_entry(table_base, private->underflow[hook]);
 
+	tgpar.in      = in;
+	tgpar.out     = out;
+	tgpar.hooknum = hook;
+
 	arp = arp_hdr(skb);
 	do {
 		if (arp_packet_match(arp, skb->dev, indev, outdev, &e->arp)) {
@@ -290,11 +292,10 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 				/* Targets which reenter must return
 				 * abs. verdicts
 				 */
+				tgpar.target   = t->u.kernel.target;
+				tgpar.targinfo = t->data;
 				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
+								     &tgpar);
 
 				/* Target might have changed stuff. */
 				arp = arp_hdr(skb);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 3f9e4cc..0bf81b3 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -9,12 +9,9 @@ MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
 MODULE_DESCRIPTION("arptables arp payload mangle target");
 
 static unsigned int
-target(struct sk_buff *skb,
-       const struct net_device *in, const struct net_device *out,
-       unsigned int hooknum, const struct xt_target *target,
-       const void *targinfo)
+target(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct arpt_mangle *mangle = targinfo;
+	const struct arpt_mangle *mangle = par->targinfo;
 	const struct arphdr *arp;
 	unsigned char *arpptr;
 	int pln, hln;
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 12ad4d5..0f8ecf3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -171,15 +171,11 @@ ip_checkentry(const struct ipt_ip *ip)
 }
 
 static unsigned int
-ipt_error(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+ipt_error(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("ip_tables: error: `%s'\n", (char *)targinfo);
+		printk("ip_tables: error: `%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -334,6 +330,7 @@ ipt_do_table(struct sk_buff *skb,
 	struct ipt_entry *e, *back;
 	struct xt_table_info *private;
 	struct xt_match_param mtpar;
+	struct xt_target_param tgpar;
 
 	/* Initialization */
 	ip = ip_hdr(skb);
@@ -349,8 +346,9 @@ ipt_do_table(struct sk_buff *skb,
 	mtpar.fragoff = ntohs(ip->frag_off) & IP_OFFSET;
 	mtpar.thoff   = ip_hdrlen(skb);
 	mtpar.hotdrop = &hotdrop;
-	mtpar.in      = in;
-	mtpar.out     = out;
+	mtpar.in      = tgpar.in  = in;
+	mtpar.out     = tgpar.out = out;
+	tgpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
@@ -414,16 +412,14 @@ ipt_do_table(struct sk_buff *skb,
 			} else {
 				/* Targets which reenter must return
 				   abs. verdicts */
+				tgpar.target   = t->u.kernel.target;
+				tgpar.targinfo = t->data;
 #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ipt_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
 				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
-
+								     &tgpar);
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ipt_entry *)table_base)->comefrom
 				    != 0xeeeeeeec
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 63faddc..67e8aa8 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -281,11 +281,9 @@ clusterip_responsible(const struct clusterip_config *config, u_int32_t hash)
  ***********************************************************************/
 
 static unsigned int
-clusterip_tg(struct sk_buff *skb, const struct net_device *in,
-             const struct net_device *out, unsigned int hooknum,
-             const struct xt_target *target, const void *targinfo)
+clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ipt_clusterip_tgt_info *cipinfo = targinfo;
+	const struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t hash;
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index aee2364..e37f181 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -77,11 +77,9 @@ set_ect_tcp(struct sk_buff *skb, const struct ipt_ECN_info *einfo)
 }
 
 static unsigned int
-ecn_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+ecn_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
+	const struct ipt_ECN_info *einfo = par->targinfo;
 
 	if (einfo->operation & IPT_ECN_OP_SET_IP)
 		if (!set_ect_ip(skb, einfo))
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 1c9785d..e9942ae 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -426,18 +426,16 @@ ipt_log_packet(u_int8_t pf,
 }
 
 static unsigned int
-log_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+log_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ipt_log_packet(NFPROTO_IPV4, hooknum, skb, in, out, &li,
+	ipt_log_packet(NFPROTO_IPV4, par->hooknum, skb, par->in, par->out, &li,
 		       loginfo->prefix);
 	return XT_CONTINUE;
 }
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 65c811b..e0d9d49 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -50,9 +50,7 @@ masquerade_tg_check(const char *tablename, const void *e,
 }
 
 static unsigned int
-masquerade_tg(struct sk_buff *skb, const struct net_device *in,
-              const struct net_device *out, unsigned int hooknum,
-              const struct xt_target *target, const void *targinfo)
+masquerade_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	struct nf_conn_nat *nat;
@@ -62,7 +60,7 @@ masquerade_tg(struct sk_buff *skb, const struct net_device *in,
 	const struct rtable *rt;
 	__be32 newsrc;
 
-	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
+	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
 	nat = nfct_nat(ct);
@@ -76,16 +74,16 @@ masquerade_tg(struct sk_buff *skb, const struct net_device *in,
 	if (ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u3.ip == 0)
 		return NF_ACCEPT;
 
-	mr = targinfo;
+	mr = par->targinfo;
 	rt = skb->rtable;
-	newsrc = inet_select_addr(out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
+	newsrc = inet_select_addr(par->out, rt->rt_gateway, RT_SCOPE_UNIVERSE);
 	if (!newsrc) {
-		printk("MASQUERADE: %s ate my IP address\n", out->name);
+		printk("MASQUERADE: %s ate my IP address\n", par->out->name);
 		return NF_DROP;
 	}
 
 	write_lock_bh(&masq_lock);
-	nat->masq_index = out->ifindex;
+	nat->masq_index = par->out->ifindex;
 	write_unlock_bh(&masq_lock);
 
 	/* Transfer from original range. */
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index f281500..cf18f23 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -41,24 +41,23 @@ netmap_tg_check(const char *tablename, const void *e,
 }
 
 static unsigned int
-netmap_tg(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+netmap_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be32 new_ip, netmask;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING
-		     || hooknum == NF_INET_POST_ROUTING
-		     || hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_POST_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 	ct = nf_ct_get(skb, &ctinfo);
 
 	netmask = ~(mr->range[0].min_ip ^ mr->range[0].max_ip);
 
-	if (hooknum == NF_INET_PRE_ROUTING || hooknum == NF_INET_LOCAL_OUT)
+	if (par->hooknum == NF_INET_PRE_ROUTING ||
+	    par->hooknum == NF_INET_LOCAL_OUT)
 		new_ip = ip_hdr(skb)->daddr & ~netmask;
 	else
 		new_ip = ip_hdr(skb)->saddr & ~netmask;
@@ -70,7 +69,7 @@ netmap_tg(struct sk_buff *skb, const struct net_device *in,
 		  mr->range[0].min, mr->range[0].max });
 
 	/* Hand modified range to generic setup. */
-	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(hooknum));
+	return nf_nat_setup_info(ct, &newrange, HOOK2MANIP(par->hooknum));
 }
 
 static struct xt_target netmap_tg_reg __read_mostly = {
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index ef49610..23adb09 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -45,24 +45,22 @@ redirect_tg_check(const char *tablename, const void *e,
 }
 
 static unsigned int
-redirect_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	__be32 newdst;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 	struct nf_nat_range newrange;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING
-		     || hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 
 	ct = nf_ct_get(skb, &ctinfo);
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
 	/* Local packets: make them go to loopback */
-	if (hooknum == NF_INET_LOCAL_OUT)
+	if (par->hooknum == NF_INET_LOCAL_OUT)
 		newdst = htonl(0x7F000001);
 	else {
 		struct in_device *indev;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index 9f5da0c..b36071b 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -136,11 +136,9 @@ static inline void send_unreach(struct sk_buff *skb_in, int code)
 }
 
 static unsigned int
-reject_tg(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+reject_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ipt_reject_info *reject = targinfo;
+	const struct ipt_reject_info *reject = par->targinfo;
 
 	/* WARNING: This code causes reentry within iptables.
 	   This means that the iptables jump stack is now crap.  We
@@ -168,7 +166,7 @@ reject_tg(struct sk_buff *skb, const struct net_device *in,
 		send_unreach(skb, ICMP_PKT_FILTERED);
 		break;
 	case IPT_TCP_RESET:
-		send_reset(skb, hooknum);
+		send_reset(skb, par->hooknum);
 	case IPT_ICMP_ECHOREPLY:
 		/* Doesn't happen. */
 		break;
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 7d01d42..05cbfd2 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -20,12 +20,10 @@ MODULE_DESCRIPTION("Xtables: IPv4 TTL field modification target");
 MODULE_LICENSE("GPL");
 
 static unsigned int
-ttl_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+ttl_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct iphdr *iph;
-	const struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = par->targinfo;
 	int new_ttl;
 
 	if (!skb_make_writable(skb, skb->len))
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 9065e4a..46c0df0 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -281,14 +281,10 @@ alloc_failure:
 }
 
 static unsigned int
-ulog_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) targinfo;
-
-	ipt_ulog_packet(hooknum, skb, in, out, loginfo, NULL);
-
+	ipt_ulog_packet(par->hooknum, skb, par->in, par->out,
+	                par->targinfo, NULL);
 	return XT_CONTINUE;
 }
 
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index f929352..83170ff 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -67,25 +67,21 @@ static struct xt_table nat_table = {
 };
 
 /* Source NAT */
-static unsigned int ipt_snat_target(struct sk_buff *skb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const struct xt_target *target,
-				    const void *targinfo)
+static unsigned int
+ipt_snat_target(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
-	NF_CT_ASSERT(hooknum == NF_INET_POST_ROUTING);
+	NF_CT_ASSERT(par->hooknum == NF_INET_POST_ROUTING);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
 	/* Connection must be valid and new. */
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED ||
 			    ctinfo == IP_CT_RELATED + IP_CT_IS_REPLY));
-	NF_CT_ASSERT(out);
+	NF_CT_ASSERT(par->out != NULL);
 
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_SRC);
 }
@@ -109,28 +105,24 @@ static void warn_if_extra_mangle(struct net *net, __be32 dstip, __be32 srcip)
 	ip_rt_put(rt);
 }
 
-static unsigned int ipt_dnat_target(struct sk_buff *skb,
-				    const struct net_device *in,
-				    const struct net_device *out,
-				    unsigned int hooknum,
-				    const struct xt_target *target,
-				    const void *targinfo)
+static unsigned int
+ipt_dnat_target(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
-	NF_CT_ASSERT(hooknum == NF_INET_PRE_ROUTING ||
-		     hooknum == NF_INET_LOCAL_OUT);
+	NF_CT_ASSERT(par->hooknum == NF_INET_PRE_ROUTING ||
+		     par->hooknum == NF_INET_LOCAL_OUT);
 
 	ct = nf_ct_get(skb, &ctinfo);
 
 	/* Connection must be valid and new. */
 	NF_CT_ASSERT(ct && (ctinfo == IP_CT_NEW || ctinfo == IP_CT_RELATED));
 
-	if (hooknum == NF_INET_LOCAL_OUT &&
+	if (par->hooknum == NF_INET_LOCAL_OUT &&
 	    mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)
-		warn_if_extra_mangle(dev_net(out), ip_hdr(skb)->daddr,
+		warn_if_extra_mangle(dev_net(par->out), ip_hdr(skb)->daddr,
 				     mr->range[0].min_ip);
 
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 891358e..ee0986c 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -200,15 +200,11 @@ ip6_checkentry(const struct ip6t_ip6 *ipv6)
 }
 
 static unsigned int
-ip6t_error(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+ip6t_error(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	if (net_ratelimit())
-		printk("ip6_tables: error: `%s'\n", (char *)targinfo);
+		printk("ip6_tables: error: `%s'\n",
+		       (const char *)par->targinfo);
 
 	return NF_DROP;
 }
@@ -360,6 +356,7 @@ ip6t_do_table(struct sk_buff *skb,
 	struct ip6t_entry *e, *back;
 	struct xt_table_info *private;
 	struct xt_match_param mtpar;
+	struct xt_target_param tgpar;
 
 	/* Initialization */
 	indev = in ? in->name : nulldevname;
@@ -371,8 +368,9 @@ ip6t_do_table(struct sk_buff *skb,
 	 * rule is also a fragment-specific rule, non-fragments won't
 	 * match it. */
 	mtpar.hotdrop = &hotdrop;
-	mtpar.in      = in;
-	mtpar.out     = out;
+	mtpar.in      = tgpar.in  = in;
+	mtpar.out     = tgpar.out = out;
+	tgpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
 	IP_NF_ASSERT(table->valid_hooks & (1 << hook));
@@ -438,15 +436,15 @@ ip6t_do_table(struct sk_buff *skb,
 			} else {
 				/* Targets which reenter must return
 				   abs. verdicts */
+				tgpar.target   = t->u.kernel.target;
+				tgpar.targinfo = t->data;
+
 #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ip6t_entry *)table_base)->comefrom
 					= 0xeeeeeeec;
 #endif
 				verdict = t->u.kernel.target->target(skb,
-								     in, out,
-								     hook,
-								     t->u.kernel.target,
-								     t->data);
+								     &tgpar);
 
 #ifdef CONFIG_NETFILTER_DEBUG
 				if (((struct ip6t_entry *)table_base)->comefrom
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index 7eebd35..ac759a5 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -19,12 +19,10 @@ MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field modification target");
 MODULE_LICENSE("GPL");
 
 static unsigned int
-hl_tg6(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+hl_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct ipv6hdr *ip6h;
-	const struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = par->targinfo;
 	int new_hl;
 
 	if (!skb_make_writable(skb, skb->len))
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index fd148f3..a31d3ec 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -438,18 +438,16 @@ ip6t_log_packet(u_int8_t pf,
 }
 
 static unsigned int
-log_tg6(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+log_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ip6t_log_info *loginfo = targinfo;
+	const struct ip6t_log_info *loginfo = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_LOG;
 	li.u.log.level = loginfo->level;
 	li.u.log.logflags = loginfo->logflags;
 
-	ip6t_log_packet(NFPROTO_IPV6, hooknum, skb, in, out,
+	ip6t_log_packet(NFPROTO_IPV6, par->hooknum, skb, par->in, par->out,
 			&li, loginfo->prefix);
 	return XT_CONTINUE;
 }
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index f1a9fce..1d5f3a7 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -173,12 +173,10 @@ send_unreach(struct net *net, struct sk_buff *skb_in, unsigned char code,
 }
 
 static unsigned int
-reject_tg6(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ip6t_reject_info *reject = targinfo;
-	struct net *net = dev_net(in ? in : out);
+	const struct ip6t_reject_info *reject = par->targinfo;
+	struct net *net = dev_net((par->in != NULL) ? par->in : par->out);
 
 	pr_debug("%s: medium point\n", __func__);
 	/* WARNING: This code causes reentry within ip6tables.
@@ -186,19 +184,19 @@ reject_tg6(struct sk_buff *skb, const struct net_device *in,
 	   must return an absolute verdict. --RR */
 	switch (reject->with) {
 	case IP6T_ICMP6_NO_ROUTE:
-		send_unreach(net, skb, ICMPV6_NOROUTE, hooknum);
+		send_unreach(net, skb, ICMPV6_NOROUTE, par->hooknum);
 		break;
 	case IP6T_ICMP6_ADM_PROHIBITED:
-		send_unreach(net, skb, ICMPV6_ADM_PROHIBITED, hooknum);
+		send_unreach(net, skb, ICMPV6_ADM_PROHIBITED, par->hooknum);
 		break;
 	case IP6T_ICMP6_NOT_NEIGHBOUR:
-		send_unreach(net, skb, ICMPV6_NOT_NEIGHBOUR, hooknum);
+		send_unreach(net, skb, ICMPV6_NOT_NEIGHBOUR, par->hooknum);
 		break;
 	case IP6T_ICMP6_ADDR_UNREACH:
-		send_unreach(net, skb, ICMPV6_ADDR_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_ADDR_UNREACH, par->hooknum);
 		break;
 	case IP6T_ICMP6_PORT_UNREACH:
-		send_unreach(net, skb, ICMPV6_PORT_UNREACH, hooknum);
+		send_unreach(net, skb, ICMPV6_PORT_UNREACH, par->hooknum);
 		break;
 	case IP6T_ICMP6_ECHOREPLY:
 		/* Do nothing */
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 8cffa29..011bc80 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -27,11 +27,9 @@ MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
 
 static unsigned int
-classify_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+classify_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_classify_target_info *clinfo = targinfo;
+	const struct xt_classify_target_info *clinfo = par->targinfo;
 
 	skb->priority = clinfo->priority;
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index e1415c3..95ed267 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -36,11 +36,9 @@ MODULE_ALIAS("ip6t_CONNMARK");
 #include <net/netfilter/nf_conntrack_ecache.h>
 
 static unsigned int
-connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, unsigned int hooknum,
-               const struct xt_target *target, const void *targinfo)
+connmark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_connmark_target_info *markinfo = targinfo;
+	const struct xt_connmark_target_info *markinfo = par->targinfo;
 	struct nf_conn *ct;
 	enum ip_conntrack_info ctinfo;
 	u_int32_t diff;
@@ -77,11 +75,9 @@ connmark_tg_v0(struct sk_buff *skb, const struct net_device *in,
 }
 
 static unsigned int
-connmark_tg(struct sk_buff *skb, const struct net_device *in,
-            const struct net_device *out, unsigned int hooknum,
-            const struct xt_target *target, const void *targinfo)
+connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_connmark_tginfo1 *info = targinfo;
+	const struct xt_connmark_tginfo1 *info = par->targinfo;
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	u_int32_t newmark;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 5f221c3..2211a2c 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -65,11 +65,9 @@ static void secmark_restore(struct sk_buff *skb)
 }
 
 static unsigned int
-connsecmark_tg(struct sk_buff *skb, const struct net_device *in,
-               const struct net_device *out, unsigned int hooknum,
-               const struct xt_target *target, const void *targinfo)
+connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_connsecmark_target_info *info = targinfo;
+	const struct xt_connsecmark_target_info *info = par->targinfo;
 
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index f0b4958..c78e80a 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -29,11 +29,9 @@ MODULE_ALIAS("ipt_TOS");
 MODULE_ALIAS("ip6t_TOS");
 
 static unsigned int
-dscp_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+dscp_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_DSCP_info *dinfo = targinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv4_get_dsfield(ip_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
@@ -48,11 +46,9 @@ dscp_tg(struct sk_buff *skb, const struct net_device *in,
 }
 
 static unsigned int
-dscp_tg6(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+dscp_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_DSCP_info *dinfo = targinfo;
+	const struct xt_DSCP_info *dinfo = par->targinfo;
 	u_int8_t dscp = ipv6_get_dsfield(ipv6_hdr(skb)) >> XT_DSCP_SHIFT;
 
 	if (dscp != dinfo->dscp) {
@@ -80,11 +76,9 @@ dscp_tg_check(const char *tablename, const void *e_void,
 }
 
 static unsigned int
-tos_tg_v0(struct sk_buff *skb, const struct net_device *in,
-          const struct net_device *out, unsigned int hooknum,
-          const struct xt_target *target, const void *targinfo)
+tos_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct ipt_tos_target_info *info = targinfo;
+	const struct ipt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
 	u_int8_t oldtos;
 
@@ -119,11 +113,9 @@ tos_tg_check_v0(const char *tablename, const void *e_void,
 }
 
 static unsigned int
-tos_tg(struct sk_buff *skb, const struct net_device *in,
-       const struct net_device *out, unsigned int hooknum,
-       const struct xt_target *target, const void *targinfo)
+tos_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_tos_target_info *info = targinfo;
+	const struct xt_tos_target_info *info = par->targinfo;
 	struct iphdr *iph = ip_hdr(skb);
 	u_int8_t orig, nv;
 
@@ -141,11 +133,9 @@ tos_tg(struct sk_buff *skb, const struct net_device *in,
 }
 
 static unsigned int
-tos_tg6(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+tos_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_tos_target_info *info = targinfo;
+	const struct xt_tos_target_info *info = par->targinfo;
 	struct ipv6hdr *iph = ipv6_hdr(skb);
 	u_int8_t orig, nv;
 
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index c8ea7a8..27d03f3 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -25,22 +25,18 @@ MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
 
 static unsigned int
-mark_tg_v0(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+mark_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = par->targinfo;
 
 	skb->mark = markinfo->mark;
 	return XT_CONTINUE;
 }
 
 static unsigned int
-mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+mark_tg_v1(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
 	int mark = 0;
 
 	switch (markinfo->mode) {
@@ -62,11 +58,9 @@ mark_tg_v1(struct sk_buff *skb, const struct net_device *in,
 }
 
 static unsigned int
-mark_tg(struct sk_buff *skb, const struct net_device *in,
-        const struct net_device *out, unsigned int hooknum,
-        const struct xt_target *target, const void *targinfo)
+mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_mark_tginfo2 *info = targinfo;
+	const struct xt_mark_tginfo2 *info = par->targinfo;
 
 	skb->mark = (skb->mark & ~info->mask) ^ info->mark;
 	return XT_CONTINUE;
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 9b09552..3218ad6 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -21,11 +21,9 @@ MODULE_ALIAS("ipt_NFLOG");
 MODULE_ALIAS("ip6t_NFLOG");
 
 static unsigned int
-nflog_tg(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_nflog_info *info = targinfo;
+	const struct xt_nflog_info *info = par->targinfo;
 	struct nf_loginfo li;
 
 	li.type		     = NF_LOG_TYPE_ULOG;
@@ -33,8 +31,8 @@ nflog_tg(struct sk_buff *skb, const struct net_device *in,
 	li.u.ulog.group	     = info->group;
 	li.u.ulog.qthreshold = info->threshold;
 
-	nf_log_packet(target->family, hooknum, skb, in, out, &li,
-		      "%s", info->prefix);
+	nf_log_packet(par->target->family, par->hooknum, skb, par->in,
+	              par->out, &li, "%s", info->prefix);
 	return XT_CONTINUE;
 }
 
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index c03c2e8..2cc1fff 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -24,11 +24,9 @@ MODULE_ALIAS("ip6t_NFQUEUE");
 MODULE_ALIAS("arpt_NFQUEUE");
 
 static unsigned int
-nfqueue_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+nfqueue_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_NFQ_info *tinfo = targinfo;
+	const struct xt_NFQ_info *tinfo = par->targinfo;
 
 	return NF_QUEUE_NR(tinfo->queuenum);
 }
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index b9ee268..cc50295 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -13,9 +13,7 @@ MODULE_ALIAS("ipt_NOTRACK");
 MODULE_ALIAS("ip6t_NOTRACK");
 
 static unsigned int
-notrack_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+notrack_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	/* Previously seen (loopback)? Ignore. */
 	if (skb->nfct != NULL)
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index da7946e..92e3352 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -71,14 +71,9 @@ void xt_rateest_put(struct xt_rateest *est)
 EXPORT_SYMBOL_GPL(xt_rateest_put);
 
 static unsigned int
-xt_rateest_tg(struct sk_buff *skb,
-	      const struct net_device *in,
-	      const struct net_device *out,
-	      unsigned int hooknum,
-	      const struct xt_target *target,
-	      const void *targinfo)
+xt_rateest_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	const struct xt_rateest_target_info *info = targinfo;
+	const struct xt_rateest_target_info *info = par->targinfo;
 	struct gnet_stats_basic *stats = &info->est->bstats;
 
 	spin_lock_bh(&info->est->lock);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 2a2ab83..ad05214 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -29,12 +29,10 @@ MODULE_ALIAS("ip6t_SECMARK");
 static u8 mode;
 
 static unsigned int
-secmark_tg(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+secmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	u32 secmark = 0;
-	const struct xt_secmark_target_info *info = targinfo;
+	const struct xt_secmark_target_info *info = par->targinfo;
 
 	BUG_ON(info->mode != mode);
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index b868f99..e08762d 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -174,15 +174,13 @@ static u_int32_t tcpmss_reverse_mtu(const struct sk_buff *skb,
 }
 
 static unsigned int
-tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+tcpmss_tg4(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct iphdr *iph = ip_hdr(skb);
 	__be16 newlen;
 	int ret;
 
-	ret = tcpmss_mangle_packet(skb, targinfo,
+	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET),
 				   iph->ihl * 4,
 				   sizeof(*iph) + sizeof(struct tcphdr));
@@ -199,9 +197,7 @@ tcpmss_tg4(struct sk_buff *skb, const struct net_device *in,
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
 static unsigned int
-tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
-           const struct net_device *out, unsigned int hooknum,
-           const struct xt_target *target, const void *targinfo)
+tcpmss_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	u8 nexthdr;
@@ -212,7 +208,7 @@ tcpmss_tg6(struct sk_buff *skb, const struct net_device *in,
 	tcphoff = ipv6_skip_exthdr(skb, sizeof(*ipv6h), &nexthdr);
 	if (tcphoff < 0)
 		return NF_DROP;
-	ret = tcpmss_mangle_packet(skb, targinfo,
+	ret = tcpmss_mangle_packet(skb, par->targinfo,
 				   tcpmss_reverse_mtu(skb, PF_INET6),
 				   tcphoff,
 				   sizeof(*ipv6h) + sizeof(struct tcphdr));
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 2e0ae6c..9dd8c8e 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -75,19 +75,15 @@ tcpoptstrip_mangle_packet(struct sk_buff *skb,
 }
 
 static unsigned int
-tcpoptstrip_tg4(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknum,
-		const struct xt_target *target, const void *targinfo)
+tcpoptstrip_tg4(struct sk_buff *skb, const struct xt_target_param *par)
 {
-	return tcpoptstrip_mangle_packet(skb, targinfo, ip_hdrlen(skb),
+	return tcpoptstrip_mangle_packet(skb, par->targinfo, ip_hdrlen(skb),
 	       sizeof(struct iphdr) + sizeof(struct tcphdr));
 }
 
 #if defined(CONFIG_IP6_NF_MANGLE) || defined(CONFIG_IP6_NF_MANGLE_MODULE)
 static unsigned int
-tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
-		const struct net_device *out, unsigned int hooknum,
-		const struct xt_target *target, const void *targinfo)
+tcpoptstrip_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	struct ipv6hdr *ipv6h = ipv6_hdr(skb);
 	int tcphoff;
@@ -98,7 +94,7 @@ tcpoptstrip_tg6(struct sk_buff *skb, const struct net_device *in,
 	if (tcphoff < 0)
 		return NF_DROP;
 
-	return tcpoptstrip_mangle_packet(skb, targinfo, tcphoff,
+	return tcpoptstrip_mangle_packet(skb, par->targinfo, tcphoff,
 	       sizeof(*ipv6h) + sizeof(struct tcphdr));
 }
 #endif
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index 183f251..f08c49e 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -25,15 +25,10 @@
 #include <net/netfilter/nf_tproxy_core.h>
 
 static unsigned int
-tproxy_tg(struct sk_buff *skb,
-	  const struct net_device *in,
-	  const struct net_device *out,
-	  unsigned int hooknum,
-	  const struct xt_target *target,
-	  const void *targinfo)
+tproxy_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	const struct iphdr *iph = ip_hdr(skb);
-	const struct xt_tproxy_target_info *tgi = targinfo;
+	const struct xt_tproxy_target_info *tgi = par->targinfo;
 	struct udphdr _hdr, *hp;
 	struct sock *sk;
 
@@ -44,7 +39,7 @@ tproxy_tg(struct sk_buff *skb,
 	sk = nf_tproxy_get_sock_v4(dev_net(skb->dev), iph->protocol,
 				   iph->saddr, tgi->laddr ? tgi->laddr : iph->daddr,
 				   hp->source, tgi->lport ? tgi->lport : hp->dest,
-				   in, true);
+				   par->in, true);
 
 	/* NOTE: assign_sock consumes our sk reference */
 	if (sk && nf_tproxy_assign_sock(skb, sk)) {
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index da35f9f..fbb04b8 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -11,9 +11,7 @@ MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
 
 static unsigned int
-trace_tg(struct sk_buff *skb, const struct net_device *in,
-         const struct net_device *out, unsigned int hooknum,
-         const struct xt_target *target, const void *targinfo)
+trace_tg(struct sk_buff *skb, const struct xt_target_param *par)
 {
 	skb->nf_trace = 1;
 	return XT_CONTINUE;
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 79ea193..89791a5 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -188,6 +188,7 @@ static int tcf_ipt(struct sk_buff *skb, struct tc_action *a,
 {
 	int ret = 0, result = 0;
 	struct tcf_ipt *ipt = a->priv;
+	struct xt_target_param par;
 
 	if (skb_cloned(skb)) {
 		if (pskb_expand_head(skb, 0, 0, GFP_ATOMIC))
@@ -203,10 +204,13 @@ static int tcf_ipt(struct sk_buff *skb, struct tc_action *a,
 	/* yes, we have to worry about both in and out dev
 	 worry later - danger - this API seems to have changed
 	 from earlier kernels */
-	ret = ipt->tcfi_t->u.kernel.target->target(skb, skb->dev, NULL,
-						   ipt->tcfi_hook,
-						   ipt->tcfi_t->u.kernel.target,
-						   ipt->tcfi_t->data);
+	par.in       = skb->dev;
+	par.out      = NULL;
+	par.hooknum  = ipt->tcfi_hook;
+	par.target   = ipt->tcfi_t->u.kernel.target;
+	par.targinfo = ipt->tcfi_t->data;
+	ret = par.target->target(skb, &par);
+
 	switch (ret) {
 	case NF_ACCEPT:
 		result = TC_ACT_OK;
