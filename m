From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 12/16] [NETFILTER]: Move extension arguments into compound structure (5/6)
Date: Sat,  4 Oct 2008 15:41:26 -0400
Message-ID: <9b35ed4e9912843d8cf9a68fadebdb2581784b86.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34320 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753374AbYJDTlg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 15:41:36 -0400
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
In-Reply-To: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
References: <67e1140a1db2e8aa9a4b6c80289039487c5445cb.1223149287.git.jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch does this for target extensions' checkentry functions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h        |   29 ++++++++++++++++++--------
 include/linux/netfilter_bridge/ebtables.h |    4 +-
 net/bridge/netfilter/ebt_arpreply.c       |   12 ++++------
 net/bridge/netfilter/ebt_dnat.c           |   15 ++++++-------
 net/bridge/netfilter/ebt_log.c            |    7 +----
 net/bridge/netfilter/ebt_mark.c           |    7 +----
 net/bridge/netfilter/ebt_nflog.c          |    7 +----
 net/bridge/netfilter/ebt_redirect.c       |   13 +++++------
 net/bridge/netfilter/ebt_snat.c           |   11 +++------
 net/bridge/netfilter/ebt_ulog.c           |    7 +----
 net/bridge/netfilter/ebtables.c           |   22 ++++++++++++++-----
 net/ipv4/netfilter/arp_tables.c           |   18 +++++++++-------
 net/ipv4/netfilter/arpt_mangle.c          |    6 +---
 net/ipv4/netfilter/ip_tables.c            |   17 +++++++++------
 net/ipv4/netfilter/ipt_CLUSTERIP.c        |   13 ++++-------
 net/ipv4/netfilter/ipt_ECN.c              |    9 ++-----
 net/ipv4/netfilter/ipt_LOG.c              |    7 +----
 net/ipv4/netfilter/ipt_MASQUERADE.c       |    7 +----
 net/ipv4/netfilter/ipt_NETMAP.c           |    7 +----
 net/ipv4/netfilter/ipt_REDIRECT.c         |    7 +----
 net/ipv4/netfilter/ipt_REJECT.c           |    9 ++-----
 net/ipv4/netfilter/ipt_TTL.c              |    7 +----
 net/ipv4/netfilter/ipt_ULOG.c             |    7 +----
 net/ipv4/netfilter/nf_nat_rule.c          |   16 +++----------
 net/ipv6/netfilter/ip6_tables.c           |   16 +++++++++-----
 net/ipv6/netfilter/ip6t_HL.c              |    7 +----
 net/ipv6/netfilter/ip6t_LOG.c             |    7 +----
 net/ipv6/netfilter/ip6t_REJECT.c          |    9 ++-----
 net/netfilter/x_tables.c                  |   32 ++++++++++++++--------------
 net/netfilter/xt_CONNMARK.c               |   24 ++++++++-------------
 net/netfilter/xt_CONNSECMARK.c            |   16 ++++++--------
 net/netfilter/xt_DSCP.c                   |   19 ++++++----------
 net/netfilter/xt_MARK.c                   |   14 +++---------
 net/netfilter/xt_NFLOG.c                  |    7 +----
 net/netfilter/xt_RATEEST.c                |    9 +------
 net/netfilter/xt_SECMARK.c                |   12 ++++------
 net/netfilter/xt_TCPMSS.c                 |   22 +++++++------------
 net/sched/act_ipt.c                       |   10 +++++++-
 38 files changed, 202 insertions(+), 266 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 81f7fb6..0dbc673 100644
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
@@ -289,11 +306,7 @@ struct xt_target
            hook_mask is a bitmask of hooks from which it can be
            called. */
 	/* Should return true or false. */
-	bool (*checkentry)(const char *tablename,
-			   const void *entry,
-			   const struct xt_target *target,
-			   void *targinfo,
-			   unsigned int hook_mask);
+	bool (*checkentry)(struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_target *target, void *targinfo);
@@ -374,10 +387,8 @@ extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
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
index 1aaef8f..9afac0c 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -57,13 +57,10 @@ ebt_arpreply_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_arpreply_tg_check(const char *tablename, const void *entry,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_arpreply_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_arpreply_info *info = data;
-	const struct ebt_entry *e = entry;
+	const struct ebt_arpreply_info *info = par->targinfo;
+	const struct ebt_entry *e = par->entryinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
@@ -71,7 +68,8 @@ ebt_arpreply_tg_check(const char *tablename, const void *entry,
 	    e->invflags & EBT_IPROTO)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
+	if (strcmp(par->table, "nat") ||
+	    par->hook_mask & ~(1 << NF_BR_PRE_ROUTING))
 		return false;
 	return true;
 }
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 3f01fc8..0569fea 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -26,19 +26,18 @@ ebt_dnat_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_dnat_tg_check(const char *tablename, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_dnat_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") ||
-	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
-	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+	if ((strcmp(par->table, "nat") != 0 ||
+	    (par->hook_mask & ~((1 << NF_BR_PRE_ROUTING) |
+	    (1 << NF_BR_LOCAL_OUT)))) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index a2c7fb2..f7543b7 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -24,12 +24,9 @@
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static bool
-ebt_log_tg_check(const char *table, const void *entry,
-		 const struct xt_target *target, void *data,
-		 unsigned int hook_mask)
+static bool ebt_log_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_log_info *info = data;
+	struct ebt_log_info *info = par->targinfo;
 
 	if (info->bitmask & ~EBT_LOG_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index a2a5cb2..f8796a0 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -36,12 +36,9 @@ ebt_mark_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_mark_tg_check(const char *table, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_mark_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_mark_t_info *info = data;
+	const struct ebt_mark_t_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 16b60bc..53a700f 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -35,12 +35,9 @@ ebt_nflog_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_nflog_tg_check(const char *table, const void *e,
-		   const struct xt_target *target, void *data,
-		   unsigned int hookmask)
+static bool ebt_nflog_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_nflog_info *info = data;
+	struct ebt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~EBT_NFLOG_MASK)
 		return false;
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index f51c502..83d43df 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -32,18 +32,17 @@ ebt_redirect_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return info->target;
 }
 
-static bool
-ebt_redirect_tg_check(const char *tablename, const void *e,
-		      const struct xt_target *target, void *data,
-		      unsigned int hookmask)
+static bool ebt_redirect_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_redirect_info *info = data;
+	const struct ebt_redirect_info *info = par->targinfo;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if ( (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING)) &&
-	     (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
+	if ((strcmp(par->table, "nat") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_PRE_ROUTING)) &&
+	    (strcmp(par->table, "broute") != 0 ||
+	    par->hook_mask & ~(1 << NF_BR_BROUTING)))
 		return false;
 	if (INVALID_TARGET)
 		return false;
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 7ff404a..53b9763 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -42,21 +42,18 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static bool
-ebt_snat_tg_check(const char *tablename, const void *e,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_snat_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ebt_nat_info *info = data;
+	const struct ebt_nat_info *info = par->targinfo;
 	int tmp;
 
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return false;
 	CLEAR_BASE_CHAIN_BIT;
-	if (strcmp(tablename, "nat"))
+	if (strcmp(par->table, "nat") != 0)
 		return false;
-	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
+	if (par->hook_mask & ~(1 << NF_BR_POST_ROUTING))
 		return false;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index bff5149..759b20f 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -254,12 +254,9 @@ ebt_ulog_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return EBT_CONTINUE;
 }
 
-static bool
-ebt_ulog_tg_check(const char *table, const void *entry,
-		  const struct xt_target *target, void *data,
-		  unsigned int hookmask)
+static bool ebt_ulog_tg_check(struct xt_tgchk_param *par)
 {
-	struct ebt_ulog_info *uloginfo = data;
+	struct ebt_ulog_info *uloginfo = par->targinfo;
 
 	if (uloginfo->nlgroup > 31)
 		return false;
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index f125b08..a784431 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -381,6 +381,7 @@ static inline int
 ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
 {
+	struct xt_tgchk_param par;
 	struct xt_target *watcher;
 	size_t left = ((char *)e + e->target_offset) - (char *)w;
 	int ret;
@@ -398,9 +399,13 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
 		return -ENOENT;
 	w->u.watcher = watcher;
 
-	ret = xt_check_target(watcher, NFPROTO_BRIDGE, w->watcher_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
-	      e, w->data);
+	par.table     = name;
+	par.entryinfo = e;
+	par.target    = watcher;
+	par.targinfo  = w->data;
+	par.hook_mask = hookmask;
+	ret = xt_check_target(&par, NFPROTO_BRIDGE, w->watcher_size,
+	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0) {
 		module_put(watcher->me);
 		return ret;
@@ -628,6 +633,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
    const char *name, unsigned int *cnt,
    struct ebt_cl_stack *cl_s, unsigned int udc_cnt)
 {
+	struct xt_tgchk_param par;
 	struct ebt_entry_target *t;
 	struct xt_target *target;
 	unsigned int i, j, hook = 0, hookmask = 0;
@@ -713,9 +719,13 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		goto cleanup_watchers;
 	}
 
-	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
-	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO,
-	      e, t->data);
+	par.table     = name;
+	par.entryinfo = e;
+	par.target    = target;
+	par.targinfo  = t->data;
+	par.hook_mask = hookmask;
+	ret = xt_check_target(&par, NFPROTO_BRIDGE, t->target_size,
+	      e->ethproto, e->invflags & EBT_IPROTO);
 	if (ret < 0)
 		goto cleanup_watchers;
 
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index c641509..917498f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -456,16 +456,18 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 
 static inline int check_target(struct arpt_entry *e, const char *name)
 {
-	struct arpt_entry_target *t;
-	struct xt_target *target;
+	struct arpt_entry_target *t = arpt_get_target(e);
+	struct xt_tgchk_param par = {
+		.table     = name,
+		.entryinfo = e,
+		.target    = t->u.kernel.target,
+		.targinfo  = t->data,
+		.hook_mask = e->comefrom,
+	};
 	int ret;
 
-	t = arpt_get_target(e);
-	target = t->u.kernel.target;
-
-	ret = xt_check_target(target, NFPROTO_ARP,
-			      t->u.target_size - sizeof(*t),
-			      name, e->comefrom, 0, 0, e, t->data);
+	ret = xt_check_target(&par, NFPROTO_ARP,
+	      t->u.target_size - sizeof(*t), 0, false);
 	if (ret < 0) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
diff --git a/net/ipv4/netfilter/arpt_mangle.c b/net/ipv4/netfilter/arpt_mangle.c
index 447a15e..1f52f8a 100644
--- a/net/ipv4/netfilter/arpt_mangle.c
+++ b/net/ipv4/netfilter/arpt_mangle.c
@@ -54,11 +54,9 @@ target(struct sk_buff *skb, struct xt_target_param *par)
 	return mangle->target;
 }
 
-static bool
-checkentry(const char *tablename, const void *e, const struct xt_target *target,
-	   void *targinfo, unsigned int hook_mask)
+static bool checkentry(struct xt_tgchk_param *par)
 {
-	const struct arpt_mangle *mangle = targinfo;
+	const struct arpt_mangle *mangle = par->targinfo;
 
 	if (mangle->flags & ~ARPT_MANGLE_MASK ||
 	    !(mangle->flags & ARPT_MANGLE_MASK))
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 0e6dce6..0775857 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -672,15 +672,18 @@ err:
 
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
index 1fa36e7..be81a50 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -347,13 +347,10 @@ clusterip_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-clusterip_tg_check(const char *tablename, const void *e_void,
-                   const struct xt_target *target, void *targinfo,
-                   unsigned int hook_mask)
+static bool clusterip_tg_check(struct xt_tgchk_param *par)
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
index 75a6ab9..923a55e 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -92,13 +92,10 @@ static unsigned int ecn_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-ecn_tg_check(const char *tablename, const void *e_void,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ecn_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_ECN_info *einfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_ECN_info *einfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (einfo->operation & IPT_ECN_OP_MASK) {
 		printk(KERN_WARNING "ECN: unsupported ECN operation %x\n",
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index a8fd1ad..9ac759f 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -439,12 +439,9 @@ static unsigned int log_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-log_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool log_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_log_info *loginfo = targinfo;
+	const struct ipt_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index dce1096..bfbfed1 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -31,12 +31,9 @@ MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 static DEFINE_RWLOCK(masq_lock);
 
 /* FIXME: Multiple targets. --RR */
-static bool
-masquerade_tg_check(const char *tablename, const void *e,
-                    const struct xt_target *target, void *targinfo,
-                    unsigned int hook_mask)
+static bool masquerade_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("masquerade_check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 4f61193..09dee68 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -22,12 +22,9 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
-static bool
-netmap_tg_check(const char *tablename, const void *e,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool netmap_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (!(mr->range[0].flags & IP_NAT_RANGE_MAP_IPS)) {
 		pr_debug("NETMAP:check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 670da15..0b9cb99 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -26,12 +26,9 @@ MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
-static bool
-redirect_tg_check(const char *tablename, const void *e,
-                  const struct xt_target *target, void *targinfo,
-                  unsigned int hook_mask)
+static bool redirect_tg_check(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	if (mr->range[0].flags & IP_NAT_RANGE_MAP_IPS) {
 		pr_debug("redirect_check: bad MAP_IPS.\n");
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index adb88b2..a77442a 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -174,13 +174,10 @@ static unsigned int reject_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool
-reject_tg_check(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool reject_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_reject_info *rejinfo = targinfo;
-	const struct ipt_entry *e = e_void;
+	const struct ipt_reject_info *rejinfo = par->targinfo;
+	const struct ipt_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IPT_ICMP_ECHOREPLY) {
 		printk("ipt_REJECT: ECHOREPLY no longer supported.\n");
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index 7bbc4c7..35585ea 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -58,12 +58,9 @@ static unsigned int ttl_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-ttl_tg_check(const char *tablename, const void *e,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool ttl_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_TTL_info *info = targinfo;
+	const struct ipt_TTL_info *info = par->targinfo;
 
 	if (info->mode > IPT_TTL_MAXMODE) {
 		printk(KERN_WARNING "ipt_TTL: invalid or unknown Mode %u\n",
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 49dcf6a..5e49612 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -312,12 +312,9 @@ static void ipt_logfn(u_int8_t pf,
 	ipt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static bool
-ulog_tg_check(const char *tablename, const void *e,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hookmask)
+static bool ulog_tg_check(struct xt_tgchk_param *par)
 {
-	const struct ipt_ulog_info *loginfo = targinfo;
+	const struct ipt_ulog_info *loginfo = par->targinfo;
 
 	if (loginfo->prefix[sizeof(loginfo->prefix) - 1] != '\0') {
 		pr_debug("ipt_ULOG: prefix term %i\n",
diff --git a/net/ipv4/netfilter/nf_nat_rule.c b/net/ipv4/netfilter/nf_nat_rule.c
index 608319c..a21c86c 100644
--- a/net/ipv4/netfilter/nf_nat_rule.c
+++ b/net/ipv4/netfilter/nf_nat_rule.c
@@ -129,13 +129,9 @@ ipt_dnat_target(struct sk_buff *skb, struct xt_target_param *par)
 	return nf_nat_setup_info(ct, &mr->range[0], IP_NAT_MANIP_DST);
 }
 
-static bool ipt_snat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_snat_checkentry(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
@@ -145,13 +141,9 @@ static bool ipt_snat_checkentry(const char *tablename,
 	return true;
 }
 
-static bool ipt_dnat_checkentry(const char *tablename,
-				const void *entry,
-				const struct xt_target *target,
-				void *targinfo,
-				unsigned int hook_mask)
+static bool ipt_dnat_checkentry(struct xt_tgchk_param *par)
 {
-	const struct nf_nat_multi_range_compat *mr = targinfo;
+	const struct nf_nat_multi_range_compat *mr = par->targinfo;
 
 	/* Must be a valid range */
 	if (mr->rangesize != 1) {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 557ef7c..bc8cd8f 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -700,15 +700,19 @@ err:
 
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
index e164d26..f4da8a1 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -53,12 +53,9 @@ static unsigned int hl_tg6(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-hl_tg6_check(const char *tablename, const void *entry,
-             const struct xt_target *target, void *targinfo,
-             unsigned int hook_mask)
+static bool hl_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_HL_info *info = targinfo;
+	const struct ip6t_HL_info *info = par->targinfo;
 
 	if (info->mode > IP6T_HL_MAXMODE) {
 		printk(KERN_WARNING "ip6t_HL: invalid or unknown Mode %u\n",
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 7f5c1ef..b2bfe6a 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -452,12 +452,9 @@ static unsigned int log_tg6(struct sk_buff *skb, struct xt_target_param *par)
 }
 
 
-static bool
-log_tg6_check(const char *tablename, const void *entry,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool log_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_log_info *loginfo = targinfo;
+	const struct ip6t_log_info *loginfo = par->targinfo;
 
 	if (loginfo->level >= 8) {
 		pr_debug("LOG: level %u >= 8\n", loginfo->level);
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index 4beb303..522de8d 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -213,13 +213,10 @@ reject_tg6(struct sk_buff *skb, struct xt_target_param *par)
 	return NF_DROP;
 }
 
-static bool
-reject_tg6_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool reject_tg6_check(struct xt_tgchk_param *par)
 {
-	const struct ip6t_reject_info *rejinfo = targinfo;
-	const struct ip6t_entry *e = entry;
+	const struct ip6t_reject_info *rejinfo = par->targinfo;
+	const struct ip6t_entry *e = par->entryinfo;
 
 	if (rejinfo->with == IP6T_ICMP6_ECHOREPLY) {
 		printk("ip6t_REJECT: ECHOREPLY is not supported.\n");
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 6a372ee..8a074a4 100644
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
 		printk("%s_tables: %s target: bad hook_mask %u/%u\n",
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
index 0e9ef0a..bf84f6c 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -112,18 +112,15 @@ connmark_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-connmark_tg_check_v0(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connmark_tg_check_v0(struct xt_tgchk_param *par)
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
+static bool connmark_tg_check(struct xt_tgchk_param *par)
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
index 4473370..3506f37 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -85,16 +85,14 @@ connsecmark_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-connsecmark_tg_check(const char *tablename, const void *entry,
-                     const struct xt_target *target, void *targinfo,
-                     unsigned int hook_mask)
+static bool connsecmark_tg_check(struct xt_tgchk_param *par)
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
index 6ee1039..cf67598 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -59,15 +59,12 @@ static unsigned int dscp_tg6(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-dscp_tg_check(const char *tablename, const void *e_void,
-              const struct xt_target *target, void *targinfo,
-              unsigned int hook_mask)
+static bool dscp_tg_check(struct xt_tgchk_param *par)
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
@@ -92,12 +89,10 @@ static unsigned int tos_tg_v0(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-tos_tg_check_v0(const char *tablename, const void *e_void,
-                const struct xt_target *target, void *targinfo,
-                unsigned int hook_mask)
+static bool tos_tg_check_v0(struct xt_tgchk_param *par)
 {
-	const u_int8_t tos = ((struct ipt_tos_target_info *)targinfo)->tos;
+	const struct ipt_tos_target_info *info = par->targinfo;
+	const uint8_t tos = info->tos;
 
 	if (tos != IPTOS_LOWDELAY && tos != IPTOS_THROUGHPUT &&
 	    tos != IPTOS_RELIABILITY && tos != IPTOS_MINCOST &&
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index ce896ec..3af5b86 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -65,12 +65,9 @@ static unsigned int mark_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-mark_tg_check_v0(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v0(struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info *markinfo = targinfo;
+	const struct xt_mark_target_info *markinfo = par->targinfo;
 
 	if (markinfo->mark > 0xffffffff) {
 		printk(KERN_WARNING "MARK: Only supports 32bit wide mark\n");
@@ -79,12 +76,9 @@ mark_tg_check_v0(const char *tablename, const void *entry,
 	return true;
 }
 
-static bool
-mark_tg_check_v1(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool mark_tg_check_v1(struct xt_tgchk_param *par)
 {
-	const struct xt_mark_target_info_v1 *markinfo = targinfo;
+	const struct xt_mark_target_info_v1 *markinfo = par->targinfo;
 
 	if (markinfo->mode != XT_MARK_SET
 	    && markinfo->mode != XT_MARK_AND
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index d959e55..39e696c 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -35,12 +35,9 @@ static unsigned int nflog_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-nflog_tg_check(const char *tablename, const void *entry,
-               const struct xt_target *target, void *targetinfo,
-               unsigned int hookmask)
+static bool nflog_tg_check(struct xt_tgchk_param *par)
 {
-	const struct xt_nflog_info *info = targetinfo;
+	const struct xt_nflog_info *info = par->targinfo;
 
 	if (info->flags & ~XT_NFLOG_MASK)
 		return false;
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index fdedf9c..4465609 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -84,14 +84,9 @@ xt_rateest_tg(struct sk_buff *skb, struct xt_target_param *par)
 	return XT_CONTINUE;
 }
 
-static bool
-xt_rateest_tg_checkentry(const char *tablename,
-			 const void *entry,
-			 const struct xt_target *target,
-			 void *targinfo,
-			 unsigned int hook_mask)
+static bool xt_rateest_tg_checkentry(struct xt_tgchk_param *par)
 {
-	struct xt_rateest_target_info *info = targinfo;
+	struct xt_rateest_target_info *info = par->targinfo;
 	struct xt_rateest *est;
 	struct {
 		struct nlattr		opt;
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index a8fd56d..b8b6818 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -80,16 +80,14 @@ static bool checkentry_selinux(struct xt_secmark_target_info *info)
 	return true;
 }
 
-static bool
-secmark_tg_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool secmark_tg_check(struct xt_tgchk_param *par)
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
index ad13013..4a1e717 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -237,16 +237,13 @@ static inline bool find_syn_match(const struct xt_entry_match *m)
 	return false;
 }
 
-static bool
-tcpmss_tg4_check(const char *tablename, const void *entry,
-                 const struct xt_target *target, void *targinfo,
-                 unsigned int hook_mask)
+static bool tcpmss_tg4_check(struct xt_tgchk_param *par)
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
+static bool tcpmss_tg6_check(struct xt_tgchk_param *par)
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
-- 
1.6.0.1

