From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 14/16] [NETFILTER]: Provide invoked family value to extensions
Date: Sat,  4 Oct 2008 15:41:28 -0400
Message-ID: <f357dd5d7e373d8135f5f5d46f83d2f9d1cc9bff.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34322 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbYJDTlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:36 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

By passing in the family through which extensions were invoked, a bit
of data space can be reclaimed. The "family" member will be added to
the parameter structures and the check functions be adjusted.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   12 ++++++++++--
 net/bridge/netfilter/ebtables.c    |   12 +++++++++---
 net/ipv4/netfilter/arp_tables.c    |    5 +++--
 net/ipv4/netfilter/ip_tables.c     |    8 ++++++--
 net/ipv6/netfilter/ip6_tables.c    |    8 ++++++--
 net/netfilter/x_tables.c           |   23 ++++++++++++-----------
 net/sched/act_ipt.c                |    4 ++--
 7 files changed, 48 insertions(+), 24 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b7d73b2..0251317 100644
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
@@ -391,9 +399,9 @@ extern void xt_unregister_match(struct xt_match *target);
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
index 2ba3e57..5e44f13 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -73,6 +73,7 @@ static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
 		.hooknum  = hooknr,
 		.target   = w->u.watcher,
 		.targinfo = w->data,
+		.family   = NFPROTO_BRIDGE,
 	};
 	par.target->target(skb, &par);
 	/* watchers don't give a verdict */
@@ -91,6 +92,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
 		.fragoff   = 0, /* Ethernet does not have such */
 		.thoff     = 0, /* not looking for L4 proto by default */
 		.hotdrop   = hotdrop,
+		.family    = NFPROTO_BRIDGE,
 	};
 	return m->u.match->match(skb, &par);
 }
@@ -218,6 +220,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 				.hooknum  = hook,
 				.target   = t->u.target,
 				.targinfo = t->data,
+				.family   = NFPROTO_BRIDGE,
 			};
 			verdict = t->u.target->target(skb, &par);
 		}
@@ -366,7 +369,8 @@ ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
 	par.match     = match;
 	par.matchinfo = m->data;
 	par.hook_mask = hookmask;
-	ret = xt_check_match(&par, NFPROTO_BRIDGE, m->match_size,
+	par.family    = NFPROTO_BRIDGE;
+	ret = xt_check_match(&par, m->match_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(match->me);
@@ -404,7 +408,8 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 	par.target    = watcher;
 	par.targinfo  = w->data;
 	par.hook_mask = hookmask;
-	ret = xt_check_target(&par, NFPROTO_BRIDGE, w->watcher_size,
+	par.family    = NFPROTO_BRIDGE;
+	ret = xt_check_target(&par, w->watcher_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
@@ -731,7 +736,8 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	par.target    = target;
 	par.targinfo  = t->data;
 	par.hook_mask = hookmask;
-	ret = xt_check_target(&par, NFPROTO_BRIDGE, t->target_size,
+	par.family    = NFPROTO_BRIDGE;
+	ret = xt_check_target(&par, t->target_size,
 	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0)
 		goto cleanup_watchers;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 6c293e8..8de3e7b 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -293,6 +293,7 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 					.hooknum  = hook,
 					.target   = t->u.kernel.target,
 					.targinfo = t->data,
+					.family   = NFPROTO_ARP,
 				};
 				verdict = par.target->target(skb, &par);
 
@@ -463,11 +464,11 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 		.target    = t->u.kernel.target,
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
+		.family    = NFPROTO_ARP,
 	};
 	int ret;
 
-	ret = xt_check_target(&par, NFPROTO_ARP,
-	      t->u.target_size - sizeof(*t), 0, false);
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0484df5..6769171 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -196,6 +196,7 @@ do_match(struct ipt_entry_match *m,
 		.fragoff   = offset,
 		.thoff     = ip_hdrlen(skb),
 		.hotdrop   = hotdrop,
+		.family    = NFPROTO_IPV4,
 	};
 
 	/* Stop iteration if it doesn't match */
@@ -424,6 +425,7 @@ ipt_do_table(struct sk_buff *skb,
 					.hooknum  = hook,
 					.target   = t->u.kernel.target,
 					.targinfo = t->data,
+					.family   = NFPROTO_IPV4,
 				};
 #ifdef CONFIG_NETFILTER_DEBUG
 				((struct ipt_entry *)table_base)->comefrom
@@ -627,10 +629,11 @@ check_match(struct ipt_entry_match *m, const char *name,
 		.match     = m->u.kernel.match,
 		.matchinfo = m->data,
 		.hook_mask = hookmask,
+		.family    = NFPROTO_IPV4,
 	};
 	int ret;
 
-	ret = xt_check_match(&par, NFPROTO_IPV4, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(&par, m->u.match_size - sizeof(*m),
 	      ip->proto, ip->invflags & IPT_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -679,10 +682,11 @@ static int check_target(struct ipt_entry *e, const char *name)
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
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index e727ac9..525e012 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -227,6 +227,7 @@ do_match(struct ip6t_entry_match *m,
 		.fragoff   = offset,
 		.thoff     = protoff,
 		.hotdrop   = hotdrop,
+		.family    = NFPROTO_IPV6,
 	};
 
 	/* Stop iteration if it doesn't match */
@@ -452,6 +453,7 @@ ip6t_do_table(struct sk_buff *skb,
 					.hooknum  = hook,
 					.target   = t->u.kernel.target,
 					.targinfo = t->data,
+					.family   = NFPROTO_IPV6,
 				};
 
 #ifdef CONFIG_NETFILTER_DEBUG
@@ -655,10 +657,11 @@ static int check_match(struct ip6t_entry_match *m, const char *name,
 		.match     = m->u.kernel.match,
 		.matchinfo = m->data,
 		.hook_mask = hookmask,
+		.family    = NFPROTO_IPV6,
 	};
 	int ret;
 
-	ret = xt_check_match(&par, NFPROTO_IPV6, m->u.match_size - sizeof(*m),
+	ret = xt_check_match(&par, m->u.match_size - sizeof(*m),
 			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
 	if (ret < 0) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -707,11 +710,12 @@ static int check_target(struct ip6t_entry *e, const char *name)
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
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 8a074a4..c3d1e5a 100644
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
 		printk("%s_tables: %s match: bad hook_mask %u/%u\n",
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
 		printk("%s_tables: %s target: bad hook_mask %u/%u\n",
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
-- 
1.6.0.1

