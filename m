From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 049/103] netfilter: xtables: convert basic nfproto match functions into xt matches
Date: Tue,  4 Aug 2009 09:25:33 +0200
Message-ID: <1249370787-17583-50-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50631 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbZHDH10 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:26 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
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
 net/bridge/netfilter/ebtables.c    |   93 ++++++++++++++++++++---------
 net/ipv4/netfilter/arp_tables.c    |  114 +++++++++++++++++++++++-------------
 net/ipv4/netfilter/ip_tables.c     |   72 ++++++++++++++---------
 net/ipv6/netfilter/ip6_tables.c    |   78 ++++++++++++++-----------
 5 files changed, 227 insertions(+), 134 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 4b7927a..62cce82 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -201,14 +201,14 @@ struct xt_counters_info
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
  */
 struct xt_action_param {
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 9f871e4..8b8cf09 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -101,10 +101,11 @@ ebt_dev_check(const char *entry, const struct net_device *device)
 
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
@@ -114,15 +115,17 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
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
+	if ((par->in == NULL || par->in->br_port == NULL) ? 0 :
+	    FWINV2(ebt_dev_check(e->logical_in, par->in->br_port->br->dev),
+	    EBT_ILOGICALIN))
 		return false;
-	if ((!out || !out->br_port) ? 0 : FWINV2(ebt_dev_check(
-	   e->logical_out, out->br_port->br->dev), EBT_ILOGICALOUT))
+	if ((par->out == NULL || par->out->br_port == NULL) ? 0 :
+	    FWINV2(ebt_dev_check(e->logical_out, par->out->br_port->br->dev),
+	    EBT_ILOGICALOUT))
 		return false;
 
 	if (e->bitmask & EBT_SOURCEMAC) {
@@ -144,6 +147,35 @@ ebt_basic_match(const struct ebt_entry *e, const struct ethhdr *h,
 	return true;
 }
 
+static bool ebt_basic_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ebt_entry *e = par->matchinfo;
+
+	if (e->bitmask & ~EBT_F_MASK) {
+		BUGPRINT("Unknown flag for bitmask\n");
+		return false;
+	}
+	if (e->invflags & ~EBT_INV_MASK) {
+		BUGPRINT("Unknown flag for inv bitmask\n");
+		return false;
+	}
+	if ((e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3)) {
+		BUGPRINT("NOPROTO & 802_3 not allowed\n");
+		return false;
+	}
+
+	return true;
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
@@ -188,7 +220,9 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	base = private->entries;
 	i = 0;
 	while (i < nentries) {
-		if (!ebt_basic_match(point, eth_hdr(skb), in, out))
+		acpar.match     = &ebt_builtin_mt;
+		acpar.matchinfo = point;
+		if (!ebt_basic_match(skb, &acpar))
 			goto letscontinue;
 
 		if (EBT_MATCH_ITERATE(point, ebt_do_match, skb, &acpar) != 0)
@@ -628,18 +662,16 @@ ebt_check_entry(struct ebt_entry *e, const struct ebt_table_info *newinfo,
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
+	mtpar.table     = tgpar.table     = name;
+	mtpar.entryinfo = tgpar.entryinfo = e;
+	mtpar.hook_mask = tgpar.hook_mask = hookmask;
+	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
+
+	mtpar.match     = &ebt_builtin_mt;
+	mtpar.matchinfo = e;
+	if (!ebt_basic_checkentry(&mtpar))
 		return -EINVAL;
-	}
+
 	/* what hook do we belong to? */
 	for (i = 0; i < NF_BR_NUMHOOKS; i++) {
 		if (!newinfo->hook_entry[i])
@@ -664,10 +696,6 @@ ebt_check_entry(struct ebt_entry *e, const struct ebt_table_info *newinfo,
 	}
 	i = 0;
 
-	mtpar.table     = tgpar.table     = name;
-	mtpar.entryinfo = tgpar.entryinfo = e;
-	mtpar.hook_mask = tgpar.hook_mask = hookmask;
-	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
 	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
 	if (ret != 0)
 		goto cleanup_matches;
@@ -1483,19 +1511,26 @@ static int __init ebtables_init(void)
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
index 33fb603..f38444c 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -96,12 +96,12 @@ static unsigned long ifname_compare(const char *_a, const char *_b, const char *
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
@@ -114,7 +114,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP operation field mismatch.\n");
 		dprintf("ar_op: %04x info->arpop: %04x info->arpop_mask: %04x\n",
 			arphdr->ar_op, arpinfo->arpop, arpinfo->arpop_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_hrd & arpinfo->arhrd_mask) != arpinfo->arhrd,
@@ -122,7 +122,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP hardware address format mismatch.\n");
 		dprintf("ar_hrd: %04x info->arhrd: %04x info->arhrd_mask: %04x\n",
 			arphdr->ar_hrd, arpinfo->arhrd, arpinfo->arhrd_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_pro & arpinfo->arpro_mask) != arpinfo->arpro,
@@ -130,7 +130,7 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
 		dprintf("ARP protocol address format mismatch.\n");
 		dprintf("ar_pro: %04x info->arpro: %04x info->arpro_mask: %04x\n",
 			arphdr->ar_pro, arpinfo->arpro, arpinfo->arpro_mask);
-		return 0;
+		return false;
 	}
 
 	if (FWINV((arphdr->ar_hln & arpinfo->arhln_mask) != arpinfo->arhln,
@@ -138,24 +138,24 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
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
@@ -174,46 +174,48 @@ static inline int arp_packet_match(const struct arphdr *arphdr,
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
+static bool arp_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct arpt_arp *arp = par->matchinfo;
+
 	if (arp->flags & ~ARPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 arp->flags & ~ARPT_F_MASK);
-		return 0;
+		return false;
 	}
 	if (arp->invflags & ~ARPT_INV_MASK) {
 		duprintf("Unknown invflag bits set: %08X\n",
 			 arp->invflags & ~ARPT_INV_MASK);
-		return 0;
+		return false;
 	}
 
-	return 1;
+	return true;
 }
 
 #ifdef CONFIG_COMPAT
@@ -265,6 +267,15 @@ static struct xt_target arpt_builtin_tg[] __read_mostly = {
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
@@ -289,11 +300,9 @@ unsigned int arpt_do_table(struct sk_buff *skb,
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
@@ -301,9 +310,6 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	if (!pskb_may_pull(skb, arp_hdr_len(skb->dev)))
 		return NF_DROP;
 
-	indev = in ? in->name : nulldevname;
-	outdev = out ? out->name : nulldevname;
-
 	xt_info_rdlock_bh();
 	private = table->private;
 	table_base = private->entries[smp_processor_id()];
@@ -317,12 +323,19 @@ unsigned int arpt_do_table(struct sk_buff *skb,
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
@@ -502,11 +515,14 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 	return 1;
 }
 
-static inline int check_entry(const struct arpt_entry *e, const char *name)
+static inline int
+check_entry(struct arpt_entry *e, struct xt_mtchk_param *par)
 {
 	const struct arpt_entry_target *t;
 
-	if (!arp_checkentry(&e->arp)) {
+	par->match     = &arpt_builtin_mt;
+	par->matchinfo = &e->arp;
+	if (!arp_checkentry(par)) {
 		duprintf("arp_tables: arp check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
@@ -548,9 +564,14 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size)
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
 
@@ -1242,6 +1263,7 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
 	struct xt_target *target;
 	unsigned int entry_offset;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_arpt_entry) != 0
@@ -1258,7 +1280,13 @@ check_compat_entry_size_and_hooks(struct compat_arpt_entry *e,
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
 
@@ -1881,6 +1909,9 @@ static int __init arp_tables_init(void)
 	ret = xt_register_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	if (ret < 0)
 		goto err2;
+	ret = xt_register_match(&arpt_builtin_mt);
+	if (ret < 0)
+		goto err3;
 
 	/* Register setsockopt */
 	ret = nf_register_sockopt(&arpt_sockopts);
@@ -1891,6 +1922,8 @@ static int __init arp_tables_init(void)
 	return 0;
 
 err4:
+	xt_unregister_match(&arpt_builtin_mt);
+err3:
 	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 err2:
 	unregister_pernet_subsys(&arp_tables_net_ops);
@@ -1901,6 +1934,7 @@ err1:
 static void __exit arp_tables_fini(void)
 {
 	nf_unregister_sockopt(&arpt_sockopts);
+	xt_unregister_match(&arpt_builtin_mt);
 	xt_unregister_targets(arpt_builtin_tg, ARRAY_SIZE(arpt_builtin_tg));
 	unregister_pernet_subsys(&arp_tables_net_ops);
 }
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4a8d6ab..7761470 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -77,13 +77,12 @@ do {								\
 
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
@@ -103,20 +102,20 @@ ip_packet_match(const struct iphdr *ip,
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
@@ -132,7 +131,8 @@ ip_packet_match(const struct iphdr *ip,
 
 	/* If we have a fragment rule but the packet is not a fragment
 	 * then we return zero */
-	if (FWINV((ipinfo->flags&IPT_F_FRAG) && !isfrag, IPT_INV_FRAG)) {
+	if (FWINV((ipinfo->flags&IPT_F_FRAG) &&
+	    par->fragoff == 0, IPT_INV_FRAG)) {
 		dprintf("Fragment rule but not fragment.%s\n",
 			ipinfo->invflags & IPT_INV_FRAG ? " (INV)" : "");
 		return false;
@@ -141,9 +141,10 @@ ip_packet_match(const struct iphdr *ip,
 	return true;
 }
 
-static bool
-ip_checkentry(const struct ipt_ip *ip)
+static bool ip_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct ipt_ip *ip = par->matchinfo;
+
 	if (ip->flags & ~IPT_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ip->flags & ~IPT_F_MASK);
@@ -255,6 +256,14 @@ static struct xt_target ipt_builtin_tg[] __read_mostly = {
 
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
@@ -397,11 +406,9 @@ ipt_do_table(struct sk_buff *skb,
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
@@ -410,8 +417,6 @@ ipt_do_table(struct sk_buff *skb,
 
 	/* Initialization */
 	ip = ip_hdr(skb);
-	indev = in ? in->name : nulldevname;
-	outdev = out ? out->name : nulldevname;
 	/* We handle fragments by dealing with the first fragment as
 	 * if it was a normal packet.  All other fragments are treated
 	 * normally, except that they will NEVER match rules that ask
@@ -446,8 +451,9 @@ ipt_do_table(struct sk_buff *skb,
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
@@ -663,11 +669,13 @@ static void cleanup_match(struct ipt_entry_match *m)
 }
 
 static int
-check_entry(const struct ipt_entry *e, const char *name)
+check_entry(struct ipt_entry *e, struct xt_mtchk_param *par)
 {
 	const struct ipt_entry_target *t;
 
-	if (!ip_checkentry(&e->ip)) {
+	par->match     = &ipt_builtin_mt[0]; /* ipv4 */
+	par->matchinfo = &e->ip;
+	if (!ip_checkentry(par)) {
 		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
@@ -759,15 +767,14 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size)
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
 
-	ret = check_entry(e, name);
-	if (ret)
-		return ret;
-
-	j = 0;
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
@@ -1570,6 +1577,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	unsigned int entry_offset;
 	unsigned int j;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ipt_entry) != 0
@@ -1586,7 +1594,13 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
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
index 0911681..f00ecc0 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -78,16 +78,13 @@ do {								\
 
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
 
@@ -106,20 +103,20 @@ ip6_packet_match(const struct sk_buff *skb,
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
@@ -131,13 +128,13 @@ ip6_packet_match(const struct sk_buff *skb,
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
@@ -160,9 +157,10 @@ ip6_packet_match(const struct sk_buff *skb,
 }
 
 /* should be ip6 safe */
-static bool
-ip6_checkentry(const struct ip6t_ip6 *ipv6)
+static bool ip6_checkentry(const struct xt_mtchk_param *par)
 {
+	const struct ip6t_ip6 *ipv6 = par->matchinfo;
+
 	if (ipv6->flags & ~IP6T_F_MASK) {
 		duprintf("Unknown flag bits set: %08X\n",
 			 ipv6->flags & ~IP6T_F_MASK);
@@ -274,6 +272,14 @@ static struct xt_target ip6t_builtin_tg[] __read_mostly = {
 
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
@@ -414,19 +420,14 @@ ip6t_do_table(struct sk_buff *skb,
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
@@ -456,8 +457,9 @@ ip6t_do_table(struct sk_buff *skb,
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
@@ -665,12 +667,14 @@ static void cleanup_match(struct ip6t_entry_match *m)
 }
 
 static int
-check_entry(const struct ip6t_entry *e, const char *name)
+check_entry(struct ip6t_entry *e, struct xt_mtchk_param *par)
 {
 	const struct ip6t_entry_target *t;
 
-	if (!ip6_checkentry(&e->ipv6)) {
-		duprintf("ip_tables: ip check failed %p %s.\n", e, name);
+	par->match     = &ip6t_builtin_mt[0];
+	par->matchinfo = &e->ipv6;
+	if (!ip6_checkentry(par)) {
+		duprintf("ip6_tables: ip check failed %p %s.\n", e, name);
 		return -EINVAL;
 	}
 
@@ -761,15 +765,14 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size)
 	struct xt_mtchk_param mtpar;
 	struct xt_entry_match *ematch;
 
-	ret = check_entry(e, name);
-	if (ret)
-		return ret;
-
-	j = 0;
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
@@ -1574,6 +1577,7 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	unsigned int entry_offset;
 	unsigned int j;
 	int ret, off, h;
+	struct xt_mtchk_param mtpar;
 
 	duprintf("check_compat_entry_size_and_hooks %p\n", e);
 	if ((unsigned long)e % __alignof__(struct compat_ip6t_entry) != 0
@@ -1590,7 +1594,13 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
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
1.6.3.3

