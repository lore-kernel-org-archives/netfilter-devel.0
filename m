From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 11/11] netfilter: xtables: convert basic nfproto match functions into xt matches
Date: Mon,  3 May 2010 11:51:36 +0200
Message-ID: <1272880297-11198-12-git-send-email-jengelh@medozas.de>
References: <1272880297-11198-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:59494 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab0ECJwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 May 2010 05:52:03 -0400
In-Reply-To: <1272880297-11198-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Each table implementation has a private built-in hardwired match
function for its corresponding nfproto data (e.g. ip_tables: struct
ipt6_ip6 processed by ip6_packet_match to match against the IPv6
header, etc.)

Rewrite the functions so that they are independent xt_matches and can
be used from an nfproto-independent table.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    4 +-
 net/bridge/netfilter/ebtables.c    |   98 ++++++++++++++++++++---------
 net/ipv4/netfilter/arp_tables.c    |  118 +++++++++++++++++++++++------------
 net/ipv4/netfilter/ip_tables.c     |   82 +++++++++++++++----------
 net/ipv6/netfilter/ip6_tables.c    |   88 +++++++++++++++------------
 5 files changed, 245 insertions(+), 145 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index c2ee5d8..ac0b15c 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -191,14 +191,14 @@ struct xt_counters_info {
  * @targetinfo:	per-target data
  * @in:		input netdevice
  * @out:	output netdevice
- * @fragoff:	packet is a fragment, this is the data offset
- * @thoff:	position of transport header relative to skb->data
  * @hook:	hook number given packet came from
  * @family:	Actual NFPROTO_* through which the function is invoked
  * 		(helpful when match->family == NFPROTO_UNSPEC)
  *
  * Fields written to by extensions:
  *
+ * @fragoff:	packet is a fragment, this is the data offset
+ * @thoff:	position of transport header relative to skb->data
  * @hotdrop:	drop packet if we had inspection problems
  * Network namespace obtainable using dev_net(in/out)
  */
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 7f3ba94..1c62562 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -122,10 +122,11 @@ ebt_dev_check(const char *entry, const struct net_device *device)
 
 #define FWINV2(bool,invflg) ((bool) ^ !!(e->invflags & invflg))
 /* process standard matches */
-static inline bool
-ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
-                const struct net_device *in, const struct net_device *out)
+static bool
+ebt_basic_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	const struct ethhdr *h = eth_hdr(skb);
+	const struct ebt_entry *e = par->matchinfo;
 	int verdict, i;
 
 	if (e->bitmask & EBT_802_3) {
@@ -135,15 +136,17 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 	   FWINV2(e->ethproto != h->h_proto, EBT_IPROTO))
 		return false;
 
-	if (FWINV2(ebt_dev_check(e->in, in), EBT_IIN))
+	if (FWINV2(ebt_dev_check(e->in, par->in), EBT_IIN))
 		return false;
-	if (FWINV2(ebt_dev_check(e->out, out), EBT_IOUT))
+	if (FWINV2(ebt_dev_check(e->out, par->out), EBT_IOUT))
 		return false;
-	if ((!in || !in->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_in, in->br_port->br->dev), EBT_ILOGICALIN))
+	if ((par->in == NULL || par->in->br_port == NULL) ? false :
+	    FWINV2(ebt_dev_check(e->logical_in, par->in->br_port->br->dev),
+	    EBT_ILOGICALIN))
 		return false;
-	if ((!out || !out->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_out, out->br_port->br->dev), EBT_ILOGICALOUT))
+	if ((par->out == NULL || par->out->br_port == NULL) ? false :
+	    FWINV2(ebt_dev_check(e->logical_out, par->out->br_port->br->dev),
+	    EBT_ILOGICALOUT))
 		return false;
 
 	if (e->bitmask & EBT_SOURCEMAC) {
@@ -165,6 +168,35 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 	return true;
 }
 
+static int ebt_basic_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ebt_entry *e = par->matchinfo;
+
+	if (e->bitmask & ~EBT_F_MASK) {
+		BUGPRINT("Unknown flag for bitmask\n");
+		return -EINVAL;
+	}
+	if (e->invflags & ~EBT_INV_MASK) {
+		BUGPRINT("Unknown flag for inv bitmask\n");
+		return -EINVAL;
+	}
+	if ((e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3)) {
+		BUGPRINT("NOPROTO & 802_3 not allowed\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static struct xt_match ebt_builtin_mt __read_mostly = {
+	.name       = "eth",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.matchsize  = sizeof(struct ebt_entry),
+	.match      = ebt_basic_match,
+	.checkentry = ebt_basic_checkentry,
+};
+
 static inline __pure
 struct ebt_entry *ebt_next_entry(const struct ebt_entry *entry)
 {
@@ -209,7 +241,9 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	base = private->entries;
 	i = 0;
 	while (i < nentries) {
-		if (!ebt_basic_match(point, eth_hdr(skb), in, out))
+		acpar.match     = &ebt_builtin_mt;
+		acpar.matchinfo = point;
+		if (!ebt_basic_match(skb, &acpar))
 			goto letscontinue;
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
@@ -655,18 +689,18 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	if (e->bitmask == 0)
 		return 0;
 
-	if (e->bitmask & ~EBT_F_MASK) {
-		BUGPRINT("Unknown flag for bitmask\n");
-		return -EINVAL;
-	}
-	if (e->invflags & ~EBT_INV_MASK) {
-		BUGPRINT("Unknown flag for inv bitmask\n");
-		return -EINVAL;
-	}
-	if ( (e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3) ) {
-		BUGPRINT("NOPROTO & 802_3 not allowed\n");
-		return -EINVAL;
-	}
+	mtpar.net	= tgpar.net       = net;
+	mtpar.table     = tgpar.table     = name;
+	mtpar.entryinfo = tgpar.entryinfo = e;
+	mtpar.hook_mask = tgpar.hook_mask = hookmask;
+	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
+
+	mtpar.match     = &ebt_builtin_mt;
+	mtpar.matchinfo = e;
+	ret = ebt_basic_checkentry(&mtpar);
+	if (ret < 0)
+		return ret;
+
 	/* what hook do we belong to? */
 	for (i = 0; i < NF_BR_NUMHOOKS; i++) {
 		if (!newinfo->hook_entry[i])
@@ -691,11 +725,6 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	}
 	i = 0;
 
-	mtpar.net	= tgpar.net       = net;
-	mtpar.table     = tgpar.table     = name;
-	mtpar.entryinfo = tgpar.entryinfo = e;
-	mtpar.hook_mask = tgpar.hook_mask = hookmask;
-	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
 	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
 	if (ret != 0)
 		goto cleanup_matches;
@@ -2418,19 +2447,26 @@ static int __init ebtables_init(void)
 	ret = xt_register_target(&ebt_standard_target);
 	if (ret < 0)
 		return ret;
+	ret = xt_register_match(&ebt_builtin_mt);
+	if (ret < 0)
+		goto out;
 	ret = nf_register_sockopt(&ebt_sockopts);
-	if (ret < 0) {
-		xt_unregister_target(&ebt_standard_target);
-		return ret;
-	}
+	if (ret < 0)
+		goto out2;
 
 	printk(KERN_INFO "Ebtables v2.0 registered\n");
 	return 0;
+ out2:
+	xt_unregister_match(&ebt_builtin_mt);
+ out:
+	xt_unregister_target(&ebt_standard_target);
+	return ret;
 }
 
 static void __exit ebtables_fini(void)
 {
 	nf_unregister_sockopt(&ebt_sockopts);
+	xt_unregister_match(&ebt_builtin_mt);
 	xt_unregister_target(&ebt_standard_target);
 	printk(KERN_INFO "Ebtables v2.0 unregistered\n");
 }
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7d6852e..d5147a9 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -103,12 +103,12 @@ static unsigned long ifname_compare(const char *_a, const char *_b, const char *
 }
 
 /* Returns whether packet matches rule or not. */
-static inline int arp_packet_match(const struct arphdr *arphdr,
-				   struct net_device *dev,
-				   const char *indev,
-				   const char *outdev,
-				   const struct arpt_arp *arpinfo)
+static bool
+arp_packet_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
+	const struct arphdr *arphdr = arp_hdr(skb);
+	const struct arpt_arp *arpinfo = par->matchinfo;
 	const char *arpptr = (char *)(arphdr + 1);
 	const char *src_devaddr, *tgt_devaddr;
 	__be32 src_ipaddr, tgt_ipaddr;
@@ -121,7 +121,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP operation field mismatch.\n");
 		dprintf("ar_op: %04x info->arpop: %04x info->arpop_mask: %04x\n",
 			arphdr->ar_op, arpinfo->arpop, arpinfo->arpop_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_hrd & arpinfo->arhrd_mask) != arpinfo->arhrd,
@@ -129,7 +129,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP hardware address format mismatch.\n");
 		dprintf("ar_hrd: %04x info->arhrd: %04x info->arhrd_mask: %04x\n",
 			arphdr->ar_hrd, arpinfo->arhrd, arpinfo->arhrd_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_pro & arpinfo->arpro_mask) != arpinfo->arpro,
@@ -137,7 +137,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP protocol address format mismatch.\n");
 		dprintf("ar_pro: %04x info->arpro: %04x info->arpro_mask: %04x\n",
 			arphdr->ar_pro, arpinfo->arpro, arpinfo->arpro_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_hln & arpinfo->arhln_mask) != arpinfo->arhln,
@@ -145,24 +145,24 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP hardware address length mismatch.\n");
 		dprintf("ar_hln: %02x info->arhln: %02x info->arhln_mask: %02x\n",
 			arphdr->ar_hln, arpinfo->arhln, arpinfo->arhln_mask);
-		return 0;
+		return false;
 	}
 
 	src_devaddr = arpptr;
-	arpptr += dev->addr_len;
+	arpptr += skb->dev->addr_len;
 	memcpy(&src_ipaddr, arpptr, sizeof(u32));
 	arpptr += sizeof(u32);
 	tgt_devaddr = arpptr;
-	arpptr += dev->addr_len;
+	arpptr += skb->dev->addr_len;
 	memcpy(&tgt_ipaddr, arpptr, sizeof(u32));
 
-	if (FWINV(arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr, dev->addr_len),
-		  ARPT_INV_SRCDEVADDR) ||
-	    FWINV(arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr, dev->addr_len),
-		  ARPT_INV_TGTDEVADDR)) {
+	if (FWINV(arp_devaddr_compare(&arpinfo->src_devaddr, src_devaddr,
+	    skb->dev->addr_len), ARPT_INV_SRCDEVADDR) ||
+	    FWINV(arp_devaddr_compare(&arpinfo->tgt_devaddr, tgt_devaddr,
+	    skb->dev->addr_len), ARPT_INV_TGTDEVADDR)) {
 		dprintf("Source or target device address mismatch.\n");
 
-		return 0;
+		return false;
 	}
 
 	if (FWINV((src_ipaddr & arpinfo->smsk.s_addr) != arpinfo->src.s_addr,
@@ -181,46 +181,48 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 			&arpinfo->tmsk.s_addr,
 			&arpinfo->tgt.s_addr,
 			arpinfo->invflags & ARPT_INV_TGTIP ? " (INV)" : "");
-		return 0;
+		return false;
 	}
 
 	/* Look for ifname matches.  */
-	ret = ifname_compare(indev, arpinfo->iniface, arpinfo->iniface_mask);
-
+	ret = ifname_compare((par->in == NULL) ? nulldevname : par->in->name,
+	      arpinfo->iniface, arpinfo->iniface_mask);
 	if (FWINV(ret != 0, ARPT_INV_VIA_IN)) {
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, arpinfo->iniface,
+			par->in->name, arpinfo->iniface,
 			arpinfo->invflags&ARPT_INV_VIA_IN ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
-	ret = ifname_compare(outdev, arpinfo->outiface, arpinfo->outiface_mask);
-
+	ret = ifname_compare((par->out == NULL) ? nulldevname : par->out->name,
+	      arpinfo->outiface, arpinfo->outiface_mask);
 	if (FWINV(ret != 0, ARPT_INV_VIA_OUT)) {
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, arpinfo->outiface,
+			par->out->name, arpinfo->outiface,
 			arpinfo->invflags&ARPT_INV_VIA_OUT ?" (INV)":"");
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 #undef FWINV
 }
 
-static inline int arp_checkentry(const struct arpt_arp *arp)
+static int arp_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct arpt_arp *arp = par->matchinfo;
+
 	if (arp->flags & ~ARPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 arp->flags & ~ARPT_F_MASK);
-		return 0;
+		return -EINVAL;
 	}
 	if (arp->invflags & ~ARPT_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 arp->invflags & ~ARPT_INV_MASK);
-		return 0;
+		return -EINVAL;
 	}
 
-	return 1;
+	return 0;
 }
 
 #ifdef CONFIG_COMPAT
@@ -272,6 +274,15 @@ static struct xt_target arpt_builtin_tg[] __read_mostly = {
 	},
 };
 
+static struct xt_match arpt_builtin_mt __read_mostly = {
+	.name       = "arp",
+	.revision   = 0,
+	.family     = NFPROTO_ARP,
+	.matchsize  = sizeof(struct arpt_arp),
+	.match      = arp_packet_match,
+	.checkentry = arp_checkentry,
+};
+
 static inline const struct arpt_entry_target *
 arpt_get_target_c(const struct arpt_entry *e)
 {
@@ -296,11 +307,9 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 			   const struct net_device *out,
 			   struct xt_table *table)
 {
-	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned int verdict = NF_DROP;
 	const struct arphdr *arp;
 	struct arpt_entry *e, *back;
-	const char *indev, *outdev;
 	void *table_base;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
@@ -308,9 +317,6 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
 
-	indev = in ? in->name : nulldevname;
-	outdev = out ? out->name : nulldevname;
-
 	xt_info_rdlock_bh();
 	private = table->private;
 	table_base = private->entries[smp_processor_id()];
@@ -324,12 +330,19 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	acpar.family  = NFPROTO_ARP;
 	acpar.hotdrop = false;
 
+	/*
+	 * For arptables, do these two outside the loop because arp_tables
+	 * does not support other matches anyway.
+	 */
+	acpar.match     = &arpt_builtin_mt;
+	acpar.matchinfo = &e->arp;
+
 	arp = arp_hdr(skb);
 	do {
 		const struct arpt_entry_target *t;
 		int hdr_len;
 
-		if (!arp_packet_match(arp, skb->dev, indev, outdev, &e->arp)) {
+		if (!arp_packet_match(skb, &acpar)) {
 			e = arpt_next_entry(e);
 			continue;
 		}
@@ -509,13 +522,18 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int check_entry(const struct arpt_entry *e, const char *name)
+static inline int
+check_entry(struct arpt_entry *e, struct xt_mtchk_param *par)
 {
 	const struct arpt_entry_target *t;
+	int ret;
 
-	if (!arp_checkentry(&e->arp)) {
+	par->match     = &arpt_builtin_mt;
+	par->matchinfo = &e->arp;
+	ret = arp_checkentry(par);
+	if (ret < 0) {
 		duprintf("arp_tables: arp check failed %p %s.\n", e, name);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (e->target_offset + sizeof(struct arpt_entry_target) > e->next_offset)
@@ -555,9 +573,14 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
 {
 	struct arpt_entry_target *t;
 	struct xt_target *target;
+	struct xt_mtchk_param mtpar;
 	int ret;
 
-	ret = check_entry(e, name);
+	mtpar.table     = name;
+	mtpar.entryinfo = &e->arp;
+	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_ARP;
+	ret = check_entry(e, &mtpar);
 	if (ret)
 		return ret;
 
@@ -1250,6 +1273,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	struct xt_target *target;
 	unsigned int entry_offset;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_arpt_entry) != 0 ||
@@ -1266,7 +1290,13 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	}
 
 	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct arpt_entry *)e, name);
+	mtpar.table     = name;
+	mtpar.entryinfo = &e->arp;
+	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_ARP;
+	mtpar.match     = &arpt_builtin_mt;
+	mtpar.matchinfo = &e->arp;
+	ret = check_entry((struct arpt_entry *)e, &mtpar);
 	if (ret)
 		return ret;
 
@@ -1892,6 +1922,9 @@ static int __init arp_tables_init(void)
 	ret = xt_register_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	if (ret < 0)
 		goto err2;
+	ret = xt_register_match(&arpt_builtin_mt);
+	if (ret < 0)
+		goto err3;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&arpt_sockopts);
@@ -1902,6 +1935,8 @@ static int __init arp_tables_init(void)
 	return 0;
 
 err4:
+	xt_unregister_match(&arpt_builtin_mt);
+err3:
 	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 err2:
 	unregister_pernet_subsys(&arp_tables_net_ops);
@@ -1912,6 +1947,7 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
+	xt_unregister_match(&arpt_builtin_mt);
 	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	unregister_pernet_subsys(&arp_tables_net_ops);
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8de563c..3ba491b 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -84,13 +84,12 @@ EXPORT_SYMBOL_GPL(ipt_alloc_initial_table);
 
 /* Returns whether matches rule or not. */
 /* Performance critical - called for every packet */
-static inline bool
-ip_packet_match(const struct iphdr *ip,
-		const char *indev,
-		const char *outdev,
-		const struct ipt_ip *ipinfo,
-		int isfrag)
+static bool
+ip_packet_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
+	const struct iphdr *ip = ip_hdr(skb);
+	const struct ipt_ip *ipinfo = par->matchinfo;
 	unsigned long ret;
 
 #define FWINV(bool, invflg) ((bool) ^ !!(ipinfo->invflags & (invflg)))
@@ -110,20 +109,20 @@ ip_packet_match(const struct iphdr *ip,
 		return false;
 	}
 
-	ret = ifname_compare_aligned(indev, ipinfo->iniface, ipinfo->iniface_mask);
-
+	ret = ifname_compare_aligned((par->in == NULL) ? nulldevname :
+	      par->in->name, ipinfo->iniface, ipinfo->iniface_mask);
 	if (FWINV(ret != 0, IPT_INV_VIA_IN)) {
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, ipinfo->iniface,
+			par->in->name, ipinfo->iniface,
 			ipinfo->invflags&IPT_INV_VIA_IN ?" (INV)":"");
 		return false;
 	}
 
-	ret = ifname_compare_aligned(outdev, ipinfo->outiface, ipinfo->outiface_mask);
-
+	ret = ifname_compare_aligned((par->out == NULL) ? nulldevname :
+	      par->out->name, ipinfo->outiface, ipinfo->outiface_mask);
 	if (FWINV(ret != 0, IPT_INV_VIA_OUT)) {
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, ipinfo->outiface,
+			par->out->name, ipinfo->outiface,
 			ipinfo->invflags&IPT_INV_VIA_OUT ?" (INV)":"");
 		return false;
 	}
@@ -139,7 +138,8 @@ ip_packet_match(const struct iphdr *ip,
 
 	/* If we have a fragment rule but the packet is not a fragment
 	 * then we return zero */
-	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG)) {
+	if (FWINV((ipinfo->flags&IPT_F_FRAG) &&
+	    par->fragoff == 0, IPT_INV_FRAG)) {
 		dprintf("Fragment rule but not fragment.%s\n",
 			ipinfo->invflags & IPT_INV_FRAG ? " (INV)" : "");
 		return false;
@@ -148,20 +148,21 @@ ip_packet_match(const struct iphdr *ip,
 	return true;
 }
 
-static bool
-ip_checkentry(const struct ipt_ip *ip)
+static int ip_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct ipt_ip *ip = par->matchinfo;
+
 	if (ip->flags & ~IPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ip->flags & ~IPT_F_MASK);
-		return false;
+		return -EINVAL;
 	}
 	if (ip->invflags & ~IPT_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 ip->invflags & ~IPT_INV_MASK);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
@@ -261,6 +262,14 @@ static struct xt_target ipt_builtin_tg[] __read_mostly = {
 
 static struct xt_match ipt_builtin_mt[] __read_mostly = {
 	{
+		.name       = "ipv4",
+		.revision   = 0,
+		.family     = NFPROTO_IPV4,
+		.matchsize  = sizeof(struct ipt_ip),
+		.match      = ip_packet_match,
+		.checkentry = ip_checkentry,
+	},
+	{
 		.name       = "icmp",
 		.match      = icmp_match,
 		.matchsize  = sizeof(struct ipt_icmp),
@@ -403,11 +412,9 @@ ipt_do_table(struct sk_buff *skb,
 	     const struct net_device *out,
 	     struct xt_table *table)
 {
-	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	const struct iphdr *ip;
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
-	const char *indev, *outdev;
 	const void *table_base;
 	struct ipt_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
@@ -416,8 +423,6 @@ ipt_do_table(struct sk_buff *skb,
 
 	/* Initialization */
 	ip = ip_hdr(skb);
-	indev = in ? in->name : nulldevname;
-	outdev = out ? out->name : nulldevname;
 	/* We handle fragments by dealing with the first fragment as
 	 * if it was a normal packet.  All other fragments are treated
 	 * normally, except that they will NEVER match rules that ask
@@ -452,8 +457,9 @@ ipt_do_table(struct sk_buff *skb,
 		const struct xt_entry_match *ematch;
 
 		IP_NF_ASSERT(e);
-		if (!ip_packet_match(ip, indev, outdev,
-		    &e->ip, acpar.fragoff)) {
+		acpar.match     = &ipt_builtin_mt[0]; /* "ipv4" itself */
+		acpar.matchinfo = &e->ip;
+		if (!ip_packet_match(skb, &acpar)) {
  no_match:
 			e = ipt_next_entry(e);
 			continue;
@@ -668,13 +674,17 @@ static void cleanup_match(struct ipt_entry_match *m, struct net *net)
 }
 
 static int
-check_entry(const struct ipt_entry *e, const char *name)
+check_entry(struct ipt_entry *e, struct xt_mtchk_param *par)
 {
 	const struct ipt_entry_target *t;
+	int ret;
 
-	if (!ip_checkentry(&e->ip)) {
+	par->match     = &ipt_builtin_mt[0]; /* ipv4 */
+	par->matchinfo = &e->ip;
+	ret = ip_checkentry(par);
+	if (ret < 0) {
 		duprintf("ip check failed %p %s.\n", e, par->match->name);
-		return -EINVAL;
+		return ret;
 	}
 
 	if (e->target_offset + sizeof(struct ipt_entry_target) >
@@ -765,16 +775,15 @@ find_check_entry(struct ipt_entry *e, struct net *net, const char *name,
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
 
-	ret = check_entry(e, name);
-	if (ret)
-		return ret;
-
-	j = 0;
 	mtpar.net	= net;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
+	ret = check_entry(e, &mtpar);
+	if (ret)
+		return ret;
+	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = find_check_match(ematch, &mtpar);
 		if (ret != 0)
@@ -1579,6 +1588,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	unsigned int entry_offset;
 	unsigned int j;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ipt_entry) != 0 ||
@@ -1595,7 +1605,13 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	}
 
 	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct ipt_entry *)e, name);
+	mtpar.table     = name;
+	mtpar.entryinfo = &e->ip;
+	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV4;
+	mtpar.match     = &ipt_builtin_mt[0]; /* ipv4 */
+	mtpar.matchinfo = &e->ip;
+	ret = check_entry((struct ipt_entry *)e, &mtpar);
 	if (ret)
 		return ret;
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 574557f..8867597 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -98,16 +98,13 @@ ip6t_ext_hdr(u8 nexthdr)
 
 /* Returns whether matches rule or not. */
 /* Performance critical - called for every packet */
-static inline bool
-ip6_packet_match(const struct sk_buff *skb,
-		 const char *indev,
-		 const char *outdev,
-		 const struct ip6t_ip6 *ip6info,
-		 unsigned int *protoff,
-		 int *fragoff, bool *hotdrop)
+static bool
+ip6_packet_match(const struct sk_buff *skb, struct xt_action_param *par)
 {
+	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	unsigned long ret;
 	const struct ipv6hdr *ipv6 = ipv6_hdr(skb);
+	const struct ip6t_ip6 *ip6info = par->matchinfo;
 
 #define FWINV(bool, invflg) ((bool) ^ !!(ip6info->invflags & (invflg)))
 
@@ -126,20 +123,20 @@ ip6_packet_match(const struct sk_buff *skb,
 		return false;
 	}
 
-	ret = ifname_compare_aligned(indev, ip6info->iniface, ip6info->iniface_mask);
-
+	ret = ifname_compare_aligned((par->in == NULL) ? nulldevname :
+	      par->in->name, ip6info->iniface, ip6info->iniface_mask);
 	if (FWINV(ret != 0, IP6T_INV_VIA_IN)) {
 		dprintf("VIA in mismatch (%s vs %s).%s\n",
-			indev, ip6info->iniface,
+			par->in->name, ip6info->iniface,
 			ip6info->invflags&IP6T_INV_VIA_IN ?" (INV)":"");
 		return false;
 	}
 
-	ret = ifname_compare_aligned(outdev, ip6info->outiface, ip6info->outiface_mask);
-
+	ret = ifname_compare_aligned((par->out == NULL) ? nulldevname :
+	      par->out->name, ip6info->outiface, ip6info->outiface_mask);
 	if (FWINV(ret != 0, IP6T_INV_VIA_OUT)) {
 		dprintf("VIA out mismatch (%s vs %s).%s\n",
-			outdev, ip6info->outiface,
+			par->out->name, ip6info->outiface,
 			ip6info->invflags&IP6T_INV_VIA_OUT ?" (INV)":"");
 		return false;
 	}
@@ -151,13 +148,13 @@ ip6_packet_match(const struct sk_buff *skb,
 		int protohdr;
 		unsigned short _frag_off;
 
-		protohdr = ipv6_find_hdr(skb, protoff, -1, &_frag_off);
+		protohdr = ipv6_find_hdr(skb, &par->thoff, -1, &_frag_off);
 		if (protohdr < 0) {
 			if (_frag_off == 0)
-				*hotdrop = true;
+				par->hotdrop = true;
 			return false;
 		}
-		*fragoff = _frag_off;
+		par->fragoff = _frag_off;
 
 		dprintf("Packet protocol %hi ?= %s%hi.\n",
 				protohdr,
@@ -180,20 +177,21 @@ ip6_packet_match(const struct sk_buff *skb,
 }
 
 /* should be ip6 safe */
-static bool
-ip6_checkentry(const struct ip6t_ip6 *ipv6)
+static int ip6_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct ip6t_ip6 *ipv6 = par->matchinfo;
+
 	if (ipv6->flags & ~IP6T_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ipv6->flags & ~IP6T_F_MASK);
-		return false;
+		return -EINVAL;
 	}
 	if (ipv6->invflags & ~IP6T_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 ipv6->invflags & ~IP6T_INV_MASK);
-		return false;
+		return -EINVAL;
 	}
-	return true;
+	return 0;
 }
 
 /* Returns 1 if the type and code is matched by the range, 0 otherwise */
@@ -294,6 +292,14 @@ static struct xt_target ip6t_builtin_tg[] __read_mostly = {
 
 static struct xt_match ip6t_builtin_mt[] __read_mostly = {
 	{
+		.name       = "ipv6",
+		.revision   = 0,
+		.family     = NFPROTO_IPV6,
+		.matchsize  = sizeof(struct ip6t_ip6),
+		.match      = ip6_packet_match,
+		.checkentry = ip6_checkentry,
+	},
+	{
 		.name       = "icmp6",
 		.match      = icmp6_match,
 		.matchsize  = sizeof(struct ip6t_icmp),
@@ -434,19 +440,14 @@ ip6t_do_table(struct sk_buff *skb,
 	      const struct net_device *out,
 	      struct xt_table *table)
 {
-	static const char nulldevname[IFNAMSIZ] __attribute__((aligned(sizeof(long))));
 	/* Initializing verdict to NF_DROP keeps gcc happy. */
 	unsigned int verdict = NF_DROP;
-	const char *indev, *outdev;
 	const void *table_base;
 	struct ip6t_entry *e, **jumpstack;
 	unsigned int *stackptr, origptr, cpu;
 	const struct xt_table_info *private;
 	struct xt_action_param acpar;
 
-	/* Initialization */
-	indev = in ? in->name : nulldevname;
-	outdev = out ? out->name : nulldevname;
 	/* We handle fragments by dealing with the first fragment as
 	 * if it was a normal packet.  All other fragments are treated
 	 * normally, except that they will NEVER match rules that ask
@@ -476,8 +477,9 @@ ip6t_do_table(struct sk_buff *skb,
 		const struct xt_entry_match *ematch;
 
 		IP_NF_ASSERT(e);
-		if (!ip6_packet_match(skb, indev, outdev, &e->ipv6,
-		    &acpar.thoff, &acpar.fragoff, &acpar.hotdrop)) {
+		acpar.match     = &ip6t_builtin_mt[0];
+		acpar.matchinfo = &e->ipv6;
+		if (!ip6_packet_match(skb, &acpar)) {
  no_match:
 			e = ip6t_next_entry(e);
 			continue;
@@ -684,13 +686,17 @@ static void cleanup_match(struct ip6t_entry_match *m, struct net *net)
 }
 
 static int
-check_entry(const struct ip6t_entry *e, const char *name)
+check_entry(struct ip6t_entry *e, struct xt_mtchk_param *par)
 {
 	const struct ip6t_entry_target *t;
+	int ret;
 
-	if (!ip6_checkentry(&e->ipv6)) {
-		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
-		return -EINVAL;
+	par->match     = &ip6t_builtin_mt[0];
+	par->matchinfo = &e->ipv6;
+	ret = ip6_checkentry(par);
+	if (ret < 0) {
+		duprintf("ip6_tables: ip check failed %p %s.\n", e, name);
+		return ret;
 	}
 
 	if (e->target_offset + sizeof(struct ip6t_entry_target) >
@@ -782,16 +788,15 @@ find_check_entry(struct ip6t_entry *e, struct net *net, const char *name,
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
 
-	ret = check_entry(e, name);
-	if (ret)
-		return ret;
-
-	j = 0;
 	mtpar.net	= net;
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
+	ret = check_entry(e, &mtpar);
+	if (ret)
+		return ret;
+	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = find_check_match(ematch, &mtpar);
 		if (ret != 0)
@@ -1598,6 +1603,7 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	unsigned int entry_offset;
 	unsigned int j;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0 ||
@@ -1614,7 +1620,13 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	}
 
 	/* For purposes of check_entry casting the compat entry is fine */
-	ret = check_entry((struct ip6t_entry *)e, name);
+	mtpar.table     = name;
+	mtpar.entryinfo = &e->ipv6;
+	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV6;
+	mtpar.match     = &ip6t_builtin_mt[0]; /* ipv6 */
+	mtpar.matchinfo = &e->ipv6;
+	ret = check_entry((struct ip6t_entry *)e, &mtpar);
 	if (ret)
 		return ret;
 
-- 
1.7.0.5

