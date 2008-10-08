From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 76/79: xtables: provide invoked family value to extensions
Date: Wed,  8 Oct 2008 12:48:04 +0200 (MEST)
Message-ID: <20081008104804.10423.95527.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46079 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754862AbYJHKsF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:48:05 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 916a917dfec18535ff9e2afdafba82e6279eb4f4
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Oct 8 11:35:20 2008 +0200

    netfilter: xtables: provide invoked family value to extensions
    
    By passing in the family through which extensions were invoked, a bit
    of data space can be reclaimed. The "family" member will be added to
    the parameter structures and the check functions be adjusted.
    
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index e3b3b66..be41b60 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -183,6 +183,8 @@ struct xt_counters_info
  * @fragoff:	packet is a fragment, this is the data offset
  * @thoff:	position of transport header relative to skb->data
  * @hotdrop:	drop packet if we had inspection problems
+ * @family:	Actual NFPROTO_* through which the function is invoked
+ * 		(helpful when match->family == NFPROTO_UNSPEC)
  */
 struct xt_match_param {
 	const struct net_device *in, *out;
@@ -191,6 +193,7 @@ struct xt_match_param {
 	int fragoff;
 	unsigned int thoff;
 	bool *hotdrop;
+	u_int8_t family;
 };
 
 /**
@@ -210,12 +213,14 @@ struct xt_mtchk_param {
 	const struct xt_match *match;
 	void *matchinfo;
 	unsigned int hook_mask;
+	u_int8_t family;
 };
 
 /* Match destructor parameters */
 struct xt_mtdtor_param {
 	const struct xt_match *match;
 	void *matchinfo;
+	u_int8_t family;
 };
 
 /**
@@ -232,6 +237,7 @@ struct xt_target_param {
 	unsigned int hooknum;
 	const struct xt_target *target;
 	const void *targinfo;
+	u_int8_t family;
 };
 
 /**
@@ -249,12 +255,14 @@ struct xt_tgchk_param {
 	const struct xt_target *target;
 	void *targinfo;
 	unsigned int hook_mask;
+	u_int8_t family;
 };
 
 /* Target destructor parameters */
 struct xt_tgdtor_param {
 	const struct xt_target *target;
 	void *targinfo;
+	u_int8_t family;
 };
 
 struct xt_match
@@ -393,9 +401,9 @@ extern void xt_unregister_match(struct xt_match *target);
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
-extern int xt_check_match(struct xt_mtchk_param *, u_int8_t family,
+extern int xt_check_match(struct xt_mtchk_param *,
 			  unsigned int size, u_int8_t proto, bool inv_proto);
-extern int xt_check_target(struct xt_tgchk_param *, u_int8_t family,
+extern int xt_check_target(struct xt_tgchk_param *,
 			   unsigned int size, u_int8_t proto, bool inv_proto);
 
 extern struct xt_table *xt_register_table(struct net *net,
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 29d8061..5bb88eb 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -160,6 +160,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 	struct xt_match_param mtpar;
 	struct xt_target_param tgpar;
 
+	mtpar.family  = tgpar.family = NFPROTO_BRIDGE;
 	mtpar.in      = tgpar.in  = in;
 	mtpar.out     = tgpar.out = out;
 	mtpar.hotdrop = &hotdrop;
@@ -351,7 +352,7 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 
 	par->match     = match;
 	par->matchinfo = m->data;
-	ret = xt_check_match(par, NFPROTO_BRIDGE, m->match_size,
+	ret = xt_check_match(par, m->match_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(match->me);
@@ -386,7 +387,7 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 
 	par->target   = watcher;
 	par->targinfo = w->data;
-	ret = xt_check_target(par, NFPROTO_BRIDGE, w->watcher_size,
+	ret = xt_check_target(par, w->watcher_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
@@ -572,6 +573,7 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 
 	par.match     = m->u.match;
 	par.matchinfo = m->data;
+	par.family    = NFPROTO_BRIDGE;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 	module_put(par.match->me);
@@ -588,6 +590,7 @@ ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
 
 	par.target   = w->u.watcher;
 	par.targinfo = w->data;
+	par.family   = NFPROTO_BRIDGE;
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
@@ -611,6 +614,7 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 
 	par.target   = t->u.target;
 	par.targinfo = t->data;
+	par.family   = NFPROTO_BRIDGE;
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
@@ -673,6 +677,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	mtpar.table     = tgpar.table     = name;
 	mtpar.entryinfo = tgpar.entryinfo = e;
 	mtpar.hook_mask = tgpar.hook_mask = hookmask;
+	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
 	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
 	if (ret != 0)
 		goto cleanup_matches;
@@ -715,7 +720,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
-	ret = xt_check_target(&tgpar, NFPROTO_BRIDGE, t->target_size,
+	ret = xt_check_target(&tgpar, t->target_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(target->me);
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 3bab783..8d70d29 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -246,6 +246,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 	tgpar.in      = in;
 	tgpar.out     = out;
 	tgpar.hooknum = hook;
+	tgpar.family  = NFPROTO_ARP;
 
 	arp = arp_hdr(skb);
 	do {
@@ -465,10 +466,10 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
+		.family    = NFPROTO_ARP,
 	};
 
-	ret = xt_check_target(&par, NFPROTO_ARP,
-	      t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
@@ -566,6 +567,7 @@ static inline int cleanup_entry(struct arpt_entry *e, unsigned int *i)
 	t = arpt_get_target(e);
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
+	par.family   = NFPROTO_ARP;
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 50b9a6c..213fb27 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -348,6 +348,7 @@ ipt_do_table(struct sk_buff *skb,
 	mtpar.hotdrop = &hotdrop;
 	mtpar.in      = tgpar.in  = in;
 	mtpar.out     = tgpar.out = out;
+	mtpar.family  = tgpar.family = NFPROTO_IPV4;
 	tgpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
@@ -579,6 +580,7 @@ cleanup_match(struct ipt_entry_match *m, unsigned int *i)
 
 	par.match     = m->u.kernel.match;
 	par.matchinfo = m->data;
+	par.family    = NFPROTO_IPV4;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 	module_put(par.match->me);
@@ -616,7 +618,7 @@ check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
 
-	ret = xt_check_match(par, NFPROTO_IPV4, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
 	      ip->proto, ip->invflags & IPT_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -662,10 +664,11 @@ static int check_target(struct ipt_entry *e, const char *name)
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
+		.family    = NFPROTO_IPV4,
 	};
 	int ret;
 
-	ret = xt_check_target(&par, NFPROTO_IPV4, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
 	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -693,6 +696,7 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV4;
 	ret = IPT_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
 	if (ret != 0)
 		goto cleanup_matches;
@@ -780,6 +784,7 @@ cleanup_entry(struct ipt_entry *e, unsigned int *i)
 
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
+	par.family   = NFPROTO_IPV4;
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
@@ -1659,6 +1664,7 @@ compat_check_entry(struct ipt_entry *e, const char *name,
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV4;
 	ret = IPT_MATCH_ITERATE(e, check_match, &mtpar, &j);
 	if (ret)
 		goto cleanup_matches;
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d934a69..a33485d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -370,6 +370,7 @@ ip6t_do_table(struct sk_buff *skb,
 	mtpar.hotdrop = &hotdrop;
 	mtpar.in      = tgpar.in  = in;
 	mtpar.out     = tgpar.out = out;
+	mtpar.family  = tgpar.family = NFPROTO_IPV6;
 	tgpar.hooknum = hook;
 
 	read_lock_bh(&table->lock);
@@ -604,6 +605,7 @@ cleanup_match(struct ip6t_entry_match *m, unsigned int *i)
 
 	par.match     = m->u.kernel.match;
 	par.matchinfo = m->data;
+	par.family    = NFPROTO_IPV6;
 	if (par.match->destroy != NULL)
 		par.match->destroy(&par);
 	module_put(par.match->me);
@@ -640,7 +642,7 @@ static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
 
-	ret = xt_check_match(par, NFPROTO_IPV6, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
 			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -686,11 +688,12 @@ static int check_target(struct ip6t_entry *e, const char *name)
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
+		.family    = NFPROTO_IPV6,
 	};
 	int ret;
 
 	t = ip6t_get_target(e);
-	ret = xt_check_target(&par, NFPROTO_IPV6, t->u.target_size - sizeof(*t),
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
 	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -718,6 +721,7 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV6;
 	ret = IP6T_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
 	if (ret != 0)
 		goto cleanup_matches;
@@ -805,6 +809,7 @@ cleanup_entry(struct ip6t_entry *e, unsigned int *i)
 
 	par.target   = t->u.kernel.target;
 	par.targinfo = t->data;
+	par.family   = NFPROTO_IPV6;
 	if (par.target->destroy != NULL)
 		par.target->destroy(&par);
 	module_put(par.target->me);
@@ -1685,6 +1690,7 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name,
 	mtpar.table     = name;
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
+	mtpar.family    = NFPROTO_IPV6;
 	ret = IP6T_MATCH_ITERATE(e, check_match, &mtpar, &j);
 	if (ret)
 		goto cleanup_matches;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f29513c..89837a4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -321,7 +321,7 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-int xt_check_match(struct xt_mtchk_param *par, u_int8_t family,
+int xt_check_match(struct xt_mtchk_param *par,
 		   unsigned int size, u_int8_t proto, bool inv_proto)
 {
 	if (XT_ALIGN(par->match->matchsize) != size &&
@@ -331,26 +331,27 @@ int xt_check_match(struct xt_mtchk_param *par, u_int8_t family,
 		 * because it uses a dynamic-size data set.
 		 */
 		printk("%s_tables: %s match: invalid size %Zu != %u\n",
-		       xt_prefix[family], par->match->name,
+		       xt_prefix[par->family], par->match->name,
 		       XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
 	}
 	if (par->match->table != NULL &&
 	    strcmp(par->match->table, par->table) != 0) {
 		printk("%s_tables: %s match: only valid in %s table, not %s\n",
-		       xt_prefix[family], par->match->name,
+		       xt_prefix[par->family], par->match->name,
 		       par->match->table, par->table);
 		return -EINVAL;
 	}
 	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
 		printk("%s_tables: %s match: bad hook_mask %#x/%#x\n",
-		       xt_prefix[family], par->match->name,
+		       xt_prefix[par->family], par->match->name,
 		       par->hook_mask, par->match->hooks);
 		return -EINVAL;
 	}
 	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
 		printk("%s_tables: %s match: only valid for protocol %u\n",
-		       xt_prefix[family], par->match->name, par->match->proto);
+		       xt_prefix[par->family], par->match->name,
+		       par->match->proto);
 		return -EINVAL;
 	}
 	if (par->match->checkentry != NULL && !par->match->checkentry(par))
@@ -471,31 +472,31 @@ int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
-int xt_check_target(struct xt_tgchk_param *par, u_int8_t family,
+int xt_check_target(struct xt_tgchk_param *par,
 		    unsigned int size, u_int8_t proto, bool inv_proto)
 {
 	if (XT_ALIGN(par->target->targetsize) != size) {
 		printk("%s_tables: %s target: invalid size %Zu != %u\n",
-		       xt_prefix[family], par->target->name,
+		       xt_prefix[par->family], par->target->name,
 		       XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
 	}
 	if (par->target->table != NULL &&
 	    strcmp(par->target->table, par->table) != 0) {
 		printk("%s_tables: %s target: only valid in %s table, not %s\n",
-		       xt_prefix[family], par->target->name,
+		       xt_prefix[par->family], par->target->name,
 		       par->target->table, par->table);
 		return -EINVAL;
 	}
 	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
 		printk("%s_tables: %s target: bad hook_mask %#x/%#x\n",
-		       xt_prefix[family], par->target->name, par->hook_mask,
-		       par->target->hooks);
+		       xt_prefix[par->family], par->target->name,
+		       par->hook_mask, par->target->hooks);
 		return -EINVAL;
 	}
 	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
 		printk("%s_tables: %s target: only valid for protocol %u\n",
-		       xt_prefix[family], par->target->name,
+		       xt_prefix[par->family], par->target->name,
 		       par->target->proto);
 		return -EINVAL;
 	}
diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index b951d42..0453d79 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -55,9 +55,9 @@ static int ipt_init_target(struct ipt_entry_target *t, char *table, unsigned int
 	par.target    = target;
 	par.targinfo  = t->data;
 	par.hook_mask = hook;
+	par.family    = NFPROTO_IPV4;
 
-	ret = xt_check_target(&par, NFPROTO_IPV4,
-	      t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		module_put(t->u.kernel.target->me);
 		return ret;
