From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 74/79: xtables: move extension arguments into compound structure (5/6)
Date: Wed,  8 Oct 2008 12:48:01 +0200 (MEST)
Message-ID: <20081008104801.10423.30033.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46091 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbYJHKsD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:03 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit af5d6dc200eb0fcc6fbd3df1ab4d8969004cb37f
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:19 2008 +0200

    netfilter: xtables: move extension arguments into compound structure (5/6)
    
    This patch does this for target extensions' checkentry functions.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 46d0cb1..8daeb49 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -234,6 +234,23 @@ struct xt_target_param {
 	const void *targinfo;
 };
 
+/**
+ * struct xt_tgchk_param - parameters for target extensions'
+ * checkentry functions
+ *
+ * @entryinfo:	the family-specific rule data
+ * 		(struct ipt_entry, ip6t_entry, arpt_entry, ebt_entry)
+ *
+ * Other fields see above.
+ */
+struct xt_tgchk_param {
+	const char *table;
+	void *entryinfo;
+	const struct xt_target *target;
+	void *targinfo;
+	unsigned int hook_mask;
+};
+
 struct xt_match
 {
 	struct list_head list;
@@ -291,11 +308,7 @@ struct xt_target
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	bool (*checkentry)(const char *tablename,
-			   const void *entry,
-			   const struct xt_target *target,
-			   void *targinfo,
-			   unsigned int hook_mask);
+	bool (*checkentry)(const struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_target *target, void *targinfo);
@@ -376,10 +389,8 @@ extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
 extern int xt_check_match(struct xt_mtchk_param *, u_int8_t family,
 			  unsigned int size, u_int8_t proto, bool inv_proto);
-extern int xt_check_target(const struct xt_target *target, unsigned short family,
-			   unsigned int size, const char *table, unsigned int hook,
-			   unsigned short proto, int inv_proto,
-			   const void *entry, void *targinfo);
+extern int xt_check_target(struct xt_tgchk_param *, u_int8_t family,
+			   unsigned int size, u_int8_t proto, bool inv_proto);
 
 extern struct xt_table *xt_register_table(struct net *net,
 					  struct xt_table *table,
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 568a690..d45e29c 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -310,9 +310,9 @@ extern unsigned int ebt_do_table(unsigned int hook, struct sk_buff *skb,
 #define FWINV(bool,invflg) ((bool) ^ !!(info->invflags & invflg))
 /* True if the hook mask denotes that the rule is in a base chain,
  * used in the check() functions */
-#define BASE_CHAIN (hookmask & (1 << NF_BR_NUMHOOKS))
+#define BASE_CHAIN (par->hook_mask & (1 << NF_BR_NUMHOOKS))
 /* Clear the bit in the hook mask that tells if the rule is on a base chain */
-#define CLEAR_BASE_CHAIN_BIT (hookmask &= ~(1 << NF_BR_NUMHOOKS))
+#define CLEAR_BASE_CHAIN_BIT (par->hook_mask &= ~(1 << NF_BR_NUMHOOKS))
 /* True if the target is not a standard target */
 #define INVALID_TARGET (info->target < -NUM_STANDARD_TARGETS || info->target >= 0)
 
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index fc94699..76584cd 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -57,20 +57,16 @@ ebt_arpreply_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_arpreply_tg_check(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_arpreply_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ebt_arpreply_info *info = data;
-	const struct ebt_entry *e = entry;
+	const struct ebt_arpreply_info *info = par->targinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
 		return false;
-	CLEAR_BASE_CHAIN_BIT;
 	return true;
 }
 
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index bb5d79e..6b49ea9 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -26,19 +26,20 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_dnat_tg_check(const char *tablename, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_dnat_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
+	unsigned int hook_mask;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
-	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") ||
-	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
-	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+
+	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
+	if ((strcmp(par->table, "nat") != 0 ||
+	    (hook_mask & ~((1 << NF_BR_PRE_ROUTING) |
+	    (1 << NF_BR_LOCAL_OUT)))) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 87de5fc..3d33c60 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,12 +24,9 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool
-ebt_log_tg_check(const char *table, const void *entry,
-		 const struct xt_target *target, void *data,
-		 unsigned int hook_mask)
+static bool ebt_log_tg_check(const struct xt_tgchk_param *par)
 {
-	struct ebt_log_info *info = data;
+	struct ebt_log_info *info = par->targinfo;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index aafc456..2fee7e8 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -36,18 +36,14 @@ ebt_mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_mark_tg_check(const char *table, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_mark_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ebt_mark_t_info *info = data;
+	const struct ebt_mark_t_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return false;
-	CLEAR_BASE_CHAIN_BIT;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
 		return false;
 	tmp = info->target & ~EBT_VERDICT_BITS;
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 6a28d99..2a63d99 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -35,12 +35,9 @@ ebt_nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_nflog_tg_check(const char *table, const void *e,
-		   const struct xt_target *target, void *data,
-		   unsigned int hookmask)
+static bool ebt_nflog_tg_check(const struct xt_tgchk_param *par)
 {
-	struct ebt_nflog_info *info = data;
+	struct ebt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 0cfe2fa..c8a49f7 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -32,18 +32,19 @@ ebt_redirect_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_redirect_tg_check(const char *tablename, const void *e,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_redirect_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ebt_redirect_info *info = data;
+	const struct ebt_redirect_info *info = par->targinfo;
+	unsigned int hook_mask;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
-	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING)) &&
-	     (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+
+	hook_mask = par->hook_mask & ~(1 << NF_BR_NUMHOOKS);
+	if ((strcmp(par->table, "nat") != 0 ||
+	    hook_mask & ~(1 << NF_BR_PRE_ROUTING)) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index f55960e..8d04d4c 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -42,18 +42,14 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_snat_tg_check(const char *tablename, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_snat_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return false;
-	CLEAR_BASE_CHAIN_BIT;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
 		return false;
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index bfedf12..2c6d682 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -254,12 +254,9 @@ ebt_ulog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_ulog_tg_check(const char *table, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_ulog_tg_check(const struct xt_tgchk_param *par)
 {
-	struct ebt_ulog_info *uloginfo = data;
+	struct ebt_ulog_info *uloginfo = par->targinfo;
 
 	if (uloginfo->nlgroup > 31)
 		return false;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index a1156ba..cf823c2 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -363,9 +363,10 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 }
 
 static inline int
-ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
-   const char *name, unsigned int hookmask, unsigned int *cnt)
+ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
+		  unsigned int *cnt)
 {
+	const struct ebt_entry *e = par->entryinfo;
 	struct xt_target *watcher;
 	size_t left = ((char *)e + e->target_offset) - (char *)w;
 	int ret;
@@ -383,9 +384,10 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		return -ENOENT;
 	w->u.watcher = watcher;
 
-	ret = xt_check_target(watcher, NFPROTO_BRIDGE, w->watcher_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
-	      e, w->data);
+	par->target   = watcher;
+	par->targinfo = w->data;
+	ret = xt_check_target(par, NFPROTO_BRIDGE, w->watcher_size,
+	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -619,6 +621,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	size_t gap;
 	int ret;
 	struct xt_mtchk_param mtpar;
+	struct xt_tgchk_param tgpar;
 
 	/* don't mess with the struct ebt_entries */
 	if (e->bitmask == 0)
@@ -660,14 +663,14 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	}
 	i = 0;
 
-	mtpar.table     = name;
-	mtpar.entryinfo = e;
-	mtpar.hook_mask = hookmask;
+	mtpar.table     = tgpar.table     = name;
+	mtpar.entryinfo = tgpar.entryinfo = e;
+	mtpar.hook_mask = tgpar.hook_mask = hookmask;
 	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
 	if (ret != 0)
 		goto cleanup_matches;
 	j = 0;
-	ret = EBT_WATCHER_ITERATE(e, ebt_check_watcher, e, name, hookmask, &j);
+	ret = EBT_WATCHER_ITERATE(e, ebt_check_watcher, &tgpar, &j);
 	if (ret != 0)
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
@@ -703,9 +706,10 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		goto cleanup_watchers;
 	}
 
-	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
-	      e, t->data);
+	tgpar.target   = target;
+	tgpar.targinfo = t->data;
+	ret = xt_check_target(&tgpar, NFPROTO_BRIDGE, t->target_size,
+	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(target->me);
 		goto cleanup_watchers;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 5b631ad..b3238d0 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -457,16 +457,18 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
-	struct arpt_entry_target *t;
-	struct xt_target *target;
+	struct arpt_entry_target *t = arpt_get_target(e);
 	int ret;
-
-	t = arpt_get_target(e);
-	target = t->u.kernel.target;
-
-	ret = xt_check_target(target, NFPROTO_ARP,
-			      t->u.target_size - sizeof(*t),
-			      name, e->comefrom, 0, 0, e, t->data);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
+
+	ret = xt_check_target(&par, NFPROTO_ARP,
+	      t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 0bf81b3..b0d5b1d 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -54,11 +54,9 @@ target(struct sk_buff *skb, const struct xt_target_param *par)
 	return mangle->target;
 }
 
-static bool
-checkentry(const char *tablename, const void *e, const struct xt_target *target,
-	   void *targinfo, unsigned int hook_mask)
+static bool checkentry(const struct xt_tgchk_param *par)
 {
-	const struct arpt_mangle *mangle = targinfo;
+	const struct arpt_mangle *mangle = par->targinfo;
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0f8ecf3..e592c54 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -655,15 +655,18 @@ err:
 
 static int check_target(struct ipt_entry *e, const char *name)
 {
-	struct ipt_entry_target *t;
-	struct xt_target *target;
+	struct ipt_entry_target *t = ipt_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
-	t = ipt_get_target(e);
-	target = t->u.kernel.target;
-	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ip.proto,
-			      e->ip.invflags & IPT_INV_PROTO, e, t->data);
+	ret = xt_check_target(&par, NFPROTO_IPV4, t->u.target_size - sizeof(*t),
+	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index 67e8aa8..6c7254e 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -347,13 +347,10 @@ clusterip_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-clusterip_tg_check(const char *tablename, const void *e_void,
-                   const struct xt_target *target, void *targinfo,
-                   unsigned int hook_mask)
+static bool clusterip_tg_check(const struct xt_tgchk_param *par)
 {
-	struct ipt_clusterip_tgt_info *cipinfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	struct ipt_clusterip_tgt_info *cipinfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	struct clusterip_config *config;
 
@@ -404,9 +401,9 @@ clusterip_tg_check(const char *tablename, const void *e_void,
 	}
 	cipinfo->config = config;
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index e37f181..f7e2fa0 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -93,13 +93,10 @@ ecn_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-ecn_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ecn_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_ECN_info *einfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index e9942ae..fc6ce04 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -440,12 +440,9 @@ log_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-log_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool log_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index e0d9d49..f389f60 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -31,12 +31,9 @@ MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
-static bool
-masquerade_tg_check(const char *tablename, const void *e,
-                    const struct xt_target *target, void *targinfo,
-                    unsigned int hook_mask)
+static bool masquerade_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("masquerade_check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index cf18f23..7c29582 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -22,12 +22,9 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
-static bool
-netmap_tg_check(const char *tablename, const void *e,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool netmap_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		pr_debug("NETMAP:check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 23adb09..698e5e7 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -26,12 +26,9 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
-static bool
-redirect_tg_check(const char *tablename, const void *e,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+static bool redirect_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("redirect_check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index b36071b..0b4b6e0 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -175,13 +175,10 @@ reject_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool
-reject_tg_check(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool reject_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_reject_info *rejinfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_reject_info *rejinfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		printk("ipt_REJECT: ECHOREPLY no longer supported.\n");
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 05cbfd2..6d76aae 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -59,12 +59,9 @@ ttl_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-ttl_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ttl_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = par->targinfo;
 
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 46c0df0..18a2826 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -313,12 +313,9 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool
-ulog_tg_check(const char *tablename, const void *e,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hookmask)
+static bool ulog_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ulog_info *loginfo = targinfo;
+	const struct ipt_ulog_info *loginfo = par->targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		pr_debug("ipt_ULOG: prefix term %i\n",
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 83170ff..bea54a6 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -128,13 +128,9 @@ ipt_dnat_target(struct sk_buff *skb, const struct xt_target_param *par)
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
-static bool ipt_snat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_snat_checkentry(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
@@ -144,13 +140,9 @@ static bool ipt_snat_checkentry(const char *tablename,
 	return true;
 }
 
-static bool ipt_dnat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_dnat_checkentry(const struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ee0986c..ca14fb8 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -679,15 +679,19 @@ err:
 
 static int check_target(struct ip6t_entry *e, const char *name)
 {
-	struct ip6t_entry_target *t;
-	struct xt_target *target;
+	struct ip6t_entry_target *t = ip6t_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
 	t = ip6t_get_target(e);
-	target = t->u.kernel.target;
-	ret = xt_check_target(target, AF_INET6, t->u.target_size - sizeof(*t),
-			      name, e->comefrom, e->ipv6.proto,
-			      e->ipv6.invflags & IP6T_INV_PROTO, e, t->data);
+	ret = xt_check_target(&par, NFPROTO_IPV6, t->u.target_size - sizeof(*t),
+	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index ac759a5..27b5adf 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -54,12 +54,9 @@ hl_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-hl_tg6_check(const char *tablename, const void *entry,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool hl_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = par->targinfo;
 
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index a31d3ec..caa441d 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -453,12 +453,9 @@ log_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 }
 
 
-static bool
-log_tg6_check(const char *tablename, const void *entry,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool log_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct ip6t_log_info *loginfo = targinfo;
+	const struct ip6t_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 1d5f3a7..0981b4c 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -213,13 +213,10 @@ reject_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool
-reject_tg6_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool reject_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct ip6t_reject_info *rejinfo = targinfo;
-	const struct ip6t_entry *e = entry;
+	const struct ip6t_reject_info *rejinfo = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 817ab14..f29513c 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -471,35 +471,35 @@ int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
-int xt_check_target(const struct xt_target *target, unsigned short family,
-		    unsigned int size, const char *table, unsigned int hook_mask,
-		    unsigned short proto, int inv_proto, const void *entry,
-		    void *targinfo)
+int xt_check_target(struct xt_tgchk_param *par, u_int8_t family,
+		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
-	if (XT_ALIGN(target->targetsize) != size) {
+	if (XT_ALIGN(par->target->targetsize) != size) {
 		printk("%s_tables: %s target: invalid size %Zu != %u\n",
-		       xt_prefix[family], target->name,
-		       XT_ALIGN(target->targetsize), size);
+		       xt_prefix[family], par->target->name,
+		       XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
 	}
-	if (target->table && strcmp(target->table, table)) {
+	if (par->target->table != NULL &&
+	    strcmp(par->target->table, par->table) != 0) {
 		printk("%s_tables: %s target: only valid in %s table, not %s\n",
-		       xt_prefix[family], target->name, target->table, table);
+		       xt_prefix[family], par->target->name,
+		       par->target->table, par->table);
 		return -EINVAL;
 	}
-	if (target->hooks && (hook_mask & ~target->hooks) != 0) {
+	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		printk("%s_tables: %s target: bad hook_mask %#x/%#x\n",
-		       xt_prefix[family], target->name, hook_mask,
-		       target->hooks);
+		       xt_prefix[family], par->target->name, par->hook_mask,
+		       par->target->hooks);
 		return -EINVAL;
 	}
-	if (target->proto && (target->proto != proto || inv_proto)) {
+	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
 		printk("%s_tables: %s target: only valid for protocol %u\n",
-		       xt_prefix[family], target->name, target->proto);
+		       xt_prefix[family], par->target->name,
+		       par->target->proto);
 		return -EINVAL;
 	}
-	if (target->checkentry != NULL &&
-	    !target->checkentry(table, entry, target, targinfo, hook_mask))
+	if (par->target->checkentry != NULL && !par->target->checkentry(par))
 		return -EINVAL;
 	return 0;
 }
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index 95ed267..8fc9f35 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -112,18 +112,15 @@ connmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-connmark_tg_check_v0(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connmark_tg_check_v0(const struct xt_tgchk_param *par)
 {
-	const struct xt_connmark_target_info *matchinfo = targinfo;
+	const struct xt_connmark_target_info *matchinfo = par->targinfo;
 
 	if (matchinfo->mode == XT_CONNMARK_RESTORE) {
-		if (strcmp(tablename, "mangle") != 0) {
+		if (strcmp(par->table, "mangle") != 0) {
 			printk(KERN_WARNING "CONNMARK: restore can only be "
 			       "called from \"mangle\" table, not \"%s\"\n",
-			       tablename);
+			       par->table);
 			return false;
 		}
 	}
@@ -131,22 +128,19 @@ connmark_tg_check_v0(const char *tablename, const void *entry,
 		printk(KERN_WARNING "CONNMARK: Only supports 32bit mark\n");
 		return false;
 	}
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
 }
 
-static bool
-connmark_tg_check(const char *tablename, const void *entry,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+static bool connmark_tg_check(const struct xt_tgchk_param *par)
 {
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "cannot load conntrack support for "
-		       "proto=%u\n", target->family);
+		       "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 2211a2c..2041a3d 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -85,16 +85,14 @@ connsecmark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-connsecmark_tg_check(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connsecmark_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_connsecmark_target_info *info = targinfo;
+	const struct xt_connsecmark_target_info *info = par->targinfo;
 
-	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+	if (strcmp(par->table, "mangle") != 0 &&
+	    strcmp(par->table, "security") != 0) {
 		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		       "or \'security\' tables, not \'%s\'.\n", par->table);
 		return false;
 	}
 
@@ -108,9 +106,9 @@ connsecmark_tg_check(const char *tablename, const void *entry,
 		return false;
 	}
 
-	if (nf_ct_l3proto_try_module_get(target->family) < 0) {
+	if (nf_ct_l3proto_try_module_get(par->target->family) < 0) {
 		printk(KERN_WARNING "can't load conntrack support for "
-				    "proto=%u\n", target->family);
+				    "proto=%u\n", par->target->family);
 		return false;
 	}
 	return true;
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index c78e80a..6a347e7 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -61,15 +61,12 @@ dscp_tg6(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-dscp_tg_check(const char *tablename, const void *e_void,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool dscp_tg_check(const struct xt_tgchk_param *par)
 {
-	const u_int8_t dscp = ((struct xt_DSCP_info *)targinfo)->dscp;
+	const struct xt_DSCP_info *info = par->targinfo;
 
-	if (dscp > XT_DSCP_MAX) {
-		printk(KERN_WARNING "DSCP: dscp %x out of range\n", dscp);
+	if (info->dscp > XT_DSCP_MAX) {
+		printk(KERN_WARNING "DSCP: dscp %x out of range\n", info->dscp);
 		return false;
 	}
 	return true;
@@ -95,12 +92,10 @@ tos_tg_v0(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-tos_tg_check_v0(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool tos_tg_check_v0(const struct xt_tgchk_param *par)
 {
-	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+	const struct ipt_tos_target_info *info = par->targinfo;
+	const uint8_t tos = info->tos;
 
 	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
 	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 27d03f3..123ee0b 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -66,12 +66,9 @@ mark_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-mark_tg_check_v0(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v0(const struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = par->targinfo;
 
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
@@ -80,12 +77,9 @@ mark_tg_check_v0(const char *tablename, const void *entry,
 	return true;
 }
 
-static bool
-mark_tg_check_v1(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v1(const struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
 
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 3218ad6..56ee4f1 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -36,12 +36,9 @@ nflog_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-nflog_tg_check(const char *tablename, const void *entry,
-               const struct xt_target *target, void *targetinfo,
-               unsigned int hookmask)
+static bool nflog_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_nflog_info *info = targetinfo;
+	const struct xt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return false;
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index 92e3352..edf4ab1 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -84,14 +84,9 @@ xt_rateest_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-xt_rateest_tg_checkentry(const char *tablename,
-			 const void *entry,
-			 const struct xt_target *target,
-			 void *targinfo,
-			 unsigned int hook_mask)
+static bool xt_rateest_tg_checkentry(const struct xt_tgchk_param *par)
 {
-	struct xt_rateest_target_info *info = targinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
 	struct {
 		struct nlattr		opt;
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index ad05214..e577722 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -80,16 +80,14 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	return true;
 }
 
-static bool
-secmark_tg_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool secmark_tg_check(const struct xt_tgchk_param *par)
 {
-	struct xt_secmark_target_info *info = targinfo;
+	struct xt_secmark_target_info *info = par->targinfo;
 
-	if (strcmp(tablename, "mangle") && strcmp(tablename, "security")) {
+	if (strcmp(par->table, "mangle") != 0 &&
+	    strcmp(par->table, "security") != 0) {
 		printk(KERN_INFO PFX "target only valid in the \'mangle\' "
-		       "or \'security\' tables, not \'%s\'.\n", tablename);
+		       "or \'security\' tables, not \'%s\'.\n", par->table);
 		return false;
 	}
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index e08762d..4f3b1f8 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -237,16 +237,13 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool
-tcpmss_tg4_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool tcpmss_tg4_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = targinfo;
-	const struct ipt_entry *e = entry;
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (hook_mask & ~((1 << NF_INET_FORWARD) |
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
@@ -260,16 +257,13 @@ tcpmss_tg4_check(const char *tablename, const void *entry,
 }
 
 #if defined(CONFIG_IP6_NF_IPTABLES) || defined(CONFIG_IP6_NF_IPTABLES_MODULE)
-static bool
-tcpmss_tg6_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool tcpmss_tg6_check(const struct xt_tgchk_param *par)
 {
-	const struct xt_tcpmss_info *info = targinfo;
-	const struct ip6t_entry *e = entry;
+	const struct xt_tcpmss_info *info = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
 
 	if (info->mss == XT_TCPMSS_CLAMP_PMTU &&
-	    (hook_mask & ~((1 << NF_INET_FORWARD) |
+	    (par->hook_mask & ~((1 << NF_INET_FORWARD) |
 			   (1 << NF_INET_LOCAL_OUT) |
 			   (1 << NF_INET_POST_ROUTING))) != 0) {
 		printk("xt_TCPMSS: path-MTU clamping only supported in "
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_TPROXY.c
index f08c49e..1340c2f 100644
--- a/net/netfilter/xt_TPROXY.c
+++ b/net/netfilter/xt_TPROXY.c
@@ -59,14 +59,9 @@ tproxy_tg(struct sk_buff *skb, const struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool
-tproxy_tg_check(const char *tablename,
-		const void *entry,
-		const struct xt_target *target,
-		void *targetinfo,
-		unsigned int hook_mask)
+static bool tproxy_tg_check(const struct xt_tgchk_param *par)
 {
-	const struct ipt_ip *i = entry;
+	const struct ipt_ip *i = par->entryinfo;
 
 	if ((i->proto == IPPROTO_TCP || i->proto == IPPROTO_UDP)
 	    && !(i->invflags & IPT_INV_PROTO))
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 89791a5..a54dc3f 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -40,6 +40,7 @@ static struct tcf_hashinfo ipt_hash_info = {
 
 static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int hook)
 {
+	struct xt_tgchk_param par;
 	struct xt_target *target;
 	int ret = 0;
 
@@ -49,9 +50,14 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 		return -ENOENT;
 
 	t->u.kernel.target = target;
-
-	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
-			      table, hook, 0, 0, NULL, t->data);
+	par.table     = table;
+	par.entryinfo = NULL;
+	par.target    = target;
+	par.targinfo  = t->data;
+	par.hook_mask = hook;
+
+	ret = xt_check_target(&par, NFPROTO_IPV4,
+	      t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		module_put(t->u.kernel.target->me);
 		return ret;
