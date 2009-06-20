From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 1/6] Core changes for better error reporting to userspace.
Date: Sat, 20 Jun 2009 23:56:11 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906202348470.11764@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:51733 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086AbZFTV4L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Jun 2009 17:56:11 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 0151F1F4294
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:56:12 +0200 (CEST)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WLVIOSKbKIcP for <netfilter-devel@vger.kernel.org>;
	Sat, 20 Jun 2009 23:56:11 +0200 (CEST)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id CC29D1F4292
	for <netfilter-devel@vger.kernel.org>; Sat, 20 Jun 2009 23:56:11 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

For better error reporting to userspace, a new getsockopt operation, 
*GET_REPLACE is introduced. The new operation makes us possible to push 
back fine grained error reporting from the extensions to userspace. If 
there was an extension error, the new 'xt_error_entry' structure and 
following that the *entry_match or *entry_target structures are sent back 
to the userspace. The 'xt_error_entry' structure carries the 
extension-specific error code and a flag to signal the type of the next 
data block (match, target [or watcher with ebtables]). For the sake of the 
complete error reporting, the table, hook and protocol checkings are moved 
from the xt_check_match|target functions to the checkentry functions.

A sample error reporting with the patched kernel and iptables:

root@teg~# iptables -A FORWARD -j TCPMSS --clamp-mss-to-pmtu
iptables v1.4.3.2: Error in target extension `TCPMSS':
Target is only valid for protocol TCP.
Try `iptables -h' or 'iptables --help' for more information.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---

 include/linux/netfilter/x_tables.h        |   47 +++--
 include/linux/netfilter_arp/arp_tables.h  |    3 
 include/linux/netfilter_bridge/ebtables.h |    3 
 include/linux/netfilter_ipv4/ip_tables.h  |   10 +
 include/linux/netfilter_ipv6/ip6_tables.h |   10 +
 net/bridge/netfilter/ebtables.c           |  299 +++++++++++++++++++++++++++--
 net/ipv4/netfilter/arp_tables.c           |  161 ++++++++++++++--
 net/ipv4/netfilter/ip_tables.c            |  204 +++++++++++++++++---
 net/ipv6/netfilter/ip6_tables.c           |  196 ++++++++++++++++---
 net/netfilter/x_tables.c                  |   86 +-------
 10 files changed, 825 insertions(+), 194 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 1030b75..8583eab 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -2,6 +2,7 @@
 #define _X_TABLES_H
 
 #include <linux/types.h>
+#include <linux/err.h>
 
 #define XT_FUNCTION_MAXNAMELEN 30
 #define XT_TABLE_MAXNAMELEN 32
@@ -70,6 +71,14 @@ struct xt_standard_target
 	int verdict;
 };
 
+struct xt_error_entry {
+	__u8 errcode;
+	__u8 match;
+	unsigned char data[0];
+};
+
+#define XT_PTR_ERR	(MAX_ERRNO+1)
+
 /* The argument to IPT_SO_GET_REVISION_*.  Returns highest revision
  * kernel supports, if >= revision. */
 struct xt_get_revision
@@ -210,6 +219,9 @@ struct xt_match_param {
  * @match:	struct xt_match through which this function was invoked
  * @matchinfo:	per-match data
  * @hook_mask:	via which hooks the new rule is reachable
+ * @family:	protocol family
+ * @proto:	transport protocol
+ * @inverted:	transport protocol check is inverted
  */
 struct xt_mtchk_param {
 	const char *table;
@@ -217,7 +229,10 @@ struct xt_mtchk_param {
 	const struct xt_match *match;
 	void *matchinfo;
 	unsigned int hook_mask;
+	u_int16_t proto;
 	u_int8_t family;
+	bool inverted;
+	bool compat_log;
 };
 
 /* Match destructor parameters */
@@ -259,7 +274,10 @@ struct xt_tgchk_param {
 	const struct xt_target *target;
 	void *targinfo;
 	unsigned int hook_mask;
+	u_int16_t proto;
 	u_int8_t family;
+	bool inverted;
+	bool compat_log;
 };
 
 /* Target destructor parameters */
@@ -284,8 +302,9 @@ struct xt_match
 	bool (*match)(const struct sk_buff *skb,
 		      const struct xt_match_param *);
 
-	/* Called when user tries to insert an entry of this type. */
-	bool (*checkentry)(const struct xt_mtchk_param *);
+	/* Called when user tries to insert an entry of this type.
+	 * Returns zero or a positive errno. */
+	unsigned int (*checkentry)(const struct xt_mtchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_mtdtor_param *);
@@ -300,11 +319,8 @@ struct xt_match
 	/* Free to use by each match */
 	unsigned long data;
 
-	const char *table;
 	unsigned int matchsize;
 	unsigned int compatsize;
-	unsigned int hooks;
-	unsigned short proto;
 
 	unsigned short family;
 };
@@ -322,11 +338,9 @@ struct xt_target
 	unsigned int (*target)(struct sk_buff *skb,
 			       const struct xt_target_param *);
 
-	/* Called when user tries to insert an entry of this type:
-           hook_mask is a bitmask of hooks from which it can be
-           called. */
-	/* Should return true or false. */
-	bool (*checkentry)(const struct xt_tgchk_param *);
+	/* Called when user tries to insert an entry of this type.
+	 * Returns 0 or a positive errno */
+	unsigned int (*checkentry)(const struct xt_tgchk_param *);
 
 	/* Called when entry of this type deleted. */
 	void (*destroy)(const struct xt_tgdtor_param *);
@@ -338,11 +352,8 @@ struct xt_target
 	/* Set this to THIS_MODULE if you are a module, otherwise NULL */
 	struct module *me;
 
-	const char *table;
 	unsigned int targetsize;
 	unsigned int compatsize;
-	unsigned int hooks;
-	unsigned short proto;
 
 	unsigned short family;
 	u_int8_t revision;
@@ -401,10 +412,8 @@ extern void xt_unregister_match(struct xt_match *target);
 extern int xt_register_matches(struct xt_match *match, unsigned int n);
 extern void xt_unregister_matches(struct xt_match *match, unsigned int n);
 
-extern int xt_check_match(struct xt_mtchk_param *,
-			  unsigned int size, u_int8_t proto, bool inv_proto);
-extern int xt_check_target(struct xt_tgchk_param *,
-			   unsigned int size, u_int8_t proto, bool inv_proto);
+extern int xt_check_match(struct xt_mtchk_param *, unsigned int size);
+extern int xt_check_target(struct xt_tgchk_param *, unsigned int size);
 
 extern struct xt_table *xt_register_table(struct net *net,
 					  struct xt_table *table,
@@ -525,6 +534,10 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 	return ret;
 }
 
+#define xt_compat_log(par, fmt, args...) \
+	if ((par)->compat_log)		 \
+		printk(KERN_ERR fmt "\n", ## args)
+
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
 
diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 590ac3d..913b65a 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -123,7 +123,8 @@ struct arpt_entry
 #define ARPT_SO_GET_ENTRIES		(ARPT_BASE_CTL + 1)
 /* #define ARPT_SO_GET_REVISION_MATCH	(APRT_BASE_CTL + 2) */
 #define ARPT_SO_GET_REVISION_TARGET	(ARPT_BASE_CTL + 3)
-#define ARPT_SO_GET_MAX			(ARPT_SO_GET_REVISION_TARGET)
+#define ARPT_SO_GET_REPLACE		(ARPT_BASE_CTL + 4)
+#define ARPT_SO_GET_MAX			(ARPT_SO_GET_REPLACE)
 
 /* CONTINUE verdict for targets */
 #define ARPT_CONTINUE XT_CONTINUE
diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index e40ddb9..b5b04fc 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -198,7 +198,8 @@ struct ebt_entry {
 #define EBT_SO_GET_ENTRIES      (EBT_SO_GET_INFO+1)
 #define EBT_SO_GET_INIT_INFO    (EBT_SO_GET_ENTRIES+1)
 #define EBT_SO_GET_INIT_ENTRIES (EBT_SO_GET_INIT_INFO+1)
-#define EBT_SO_GET_MAX          (EBT_SO_GET_INIT_ENTRIES+1)
+#define EBT_SO_GET_REPLACE	(EBT_SO_GET_INIT_ENTRIES+1)
+#define EBT_SO_GET_MAX          (EBT_SO_GET_REPLACE+1)
 
 #ifdef __KERNEL__
 
diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index 092bd50..37b6805 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -115,7 +115,8 @@ struct ipt_entry
 #define IPT_SO_GET_ENTRIES		(IPT_BASE_CTL + 1)
 #define IPT_SO_GET_REVISION_MATCH	(IPT_BASE_CTL + 2)
 #define IPT_SO_GET_REVISION_TARGET	(IPT_BASE_CTL + 3)
-#define IPT_SO_GET_MAX			IPT_SO_GET_REVISION_TARGET
+#define IPT_SO_GET_REPLACE		(IPT_BASE_CTL + 4)
+#define IPT_SO_GET_MAX			IPT_SO_GET_REPLACE
 
 #define IPT_CONTINUE XT_CONTINUE
 #define IPT_RETURN XT_RETURN
@@ -134,6 +135,13 @@ struct ipt_entry
 #define IPT_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
 #define IPT_UDP_INV_MASK	XT_UDP_INV_MASK
 
+enum {
+	IPT_ICMP_ERR_NONE,
+	IPT_ICMP_ERR_PROTO,
+	IPT_ICMP_ERR_FLAGS,
+	IPT_ICMP_ERR_MAX,
+};
+
 /* ICMP matching stuff */
 struct ipt_icmp
 {
diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 1089e33..140d48c 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -168,7 +168,8 @@ struct ip6t_error
 #define IP6T_SO_GET_ENTRIES		(IP6T_BASE_CTL + 1)
 #define IP6T_SO_GET_REVISION_MATCH	(IP6T_BASE_CTL + 4)
 #define IP6T_SO_GET_REVISION_TARGET	(IP6T_BASE_CTL + 5)
-#define IP6T_SO_GET_MAX			IP6T_SO_GET_REVISION_TARGET
+#define IP6T_SO_GET_REPLACE		(IP6T_BASE_CTL + 6)
+#define IP6T_SO_GET_MAX			IP6T_SO_GET_REPLACE
 
 /* CONTINUE verdict for targets */
 #define IP6T_CONTINUE XT_CONTINUE
@@ -194,6 +195,13 @@ struct ip6t_error
 #define IP6T_UDP_INV_DSTPT	XT_UDP_INV_DSTPT
 #define IP6T_UDP_INV_MASK	XT_UDP_INV_MASK
 
+enum {
+	IP6T_ICMPV6_ERR_NONE,
+	IP6T_ICMPV6_ERR_PROTO,
+	IP6T_ICMPV6_ERR_FLAGS,
+	IP6T_ICMPV6_ERR_MAX,
+};
+
 /* ICMP matching stuff */
 struct ip6t_icmp
 {
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 37928d5..668bee8 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -328,7 +328,7 @@ find_table_lock(struct net *net, const char *name, int *error,
 
 static inline int
 ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
-		unsigned int *cnt)
+		unsigned int *cnt, unsigned int *error_offset)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct xt_match *match;
@@ -342,27 +342,28 @@ ebt_check_match(struct ebt_entry_match *m, struct xt_mtchk_param *par,
 	match = try_then_request_module(xt_find_match(NFPROTO_BRIDGE,
 		m->u.name, 0), "ebt_%s", m->u.name);
 	if (IS_ERR(match))
-		return PTR_ERR(match);
+		return -XT_PTR_ERR;
 	if (match == NULL)
 		return -ENOENT;
 	m->u.match = match;
 
 	par->match     = match;
 	par->matchinfo = m->data;
-	ret = xt_check_match(par, m->match_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
-	if (ret < 0) {
+	par->proto     = e->ethproto;
+	par->inverted  = e->invflags & EBT_IPROTO;
+	ret = xt_check_match(par, m->match_size);
+	if (ret) {
 		module_put(match->me);
 		return ret;
 	}
-
+	*error_offset += m->match_size;
 	(*cnt)++;
 	return 0;
 }
 
 static inline int
 ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
-		  unsigned int *cnt)
+		  unsigned int *cnt, unsigned int *error_offset)
 {
 	const struct ebt_entry *e = par->entryinfo;
 	struct xt_target *watcher;
@@ -377,20 +378,21 @@ ebt_check_watcher(struct ebt_entry_watcher *w, struct xt_tgchk_param *par,
 		  xt_find_target(NFPROTO_BRIDGE, w->u.name, 0),
 		  "ebt_%s", w->u.name);
 	if (IS_ERR(watcher))
-		return PTR_ERR(watcher);
+		return -XT_PTR_ERR;
 	if (watcher == NULL)
 		return -ENOENT;
 	w->u.watcher = watcher;
 
 	par->target   = watcher;
 	par->targinfo = w->data;
-	ret = xt_check_target(par, w->watcher_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
-	if (ret < 0) {
+	par->proto    = e->ethproto;
+	par->inverted = e->invflags & EBT_IPROTO;
+	ret = xt_check_target(par, w->watcher_size);
+	if (ret) {
 		module_put(watcher->me);
 		return ret;
 	}
-
+	*error_offset += w->watcher_size;
 	(*cnt)++;
 	return 0;
 }
@@ -621,7 +623,8 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 static inline int
 ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
    const char *name, unsigned int *cnt,
-   struct ebt_cl_stack *cl_s, unsigned int udc_cnt)
+   struct ebt_cl_stack *cl_s, unsigned int udc_cnt,
+   unsigned int *error_offset, bool compat_log)
 {
 	struct ebt_entry_target *t;
 	struct xt_target *target;
@@ -675,11 +678,14 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 	mtpar.entryinfo = tgpar.entryinfo = e;
 	mtpar.hook_mask = tgpar.hook_mask = hookmask;
 	mtpar.family    = tgpar.family    = NFPROTO_BRIDGE;
-	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i);
+	mtpar.compat_log = tgpar.compat_log = compat_log;
+	ret = EBT_MATCH_ITERATE(e, ebt_check_match, &mtpar, &i,
+				error_offset);
 	if (ret != 0)
 		goto cleanup_matches;
 	j = 0;
-	ret = EBT_WATCHER_ITERATE(e, ebt_check_watcher, &tgpar, &j);
+	ret = EBT_WATCHER_ITERATE(e, ebt_check_watcher, &tgpar, &j,
+				  error_offset);
 	if (ret != 0)
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
@@ -689,7 +695,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		 xt_find_target(NFPROTO_BRIDGE, t->u.name, 0),
 		 "ebt_%s", t->u.name);
 	if (IS_ERR(target)) {
-		ret = PTR_ERR(target);
+		ret = -XT_PTR_ERR;
 		goto cleanup_watchers;
 	} else if (target == NULL) {
 		ret = -ENOENT;
@@ -717,9 +723,12 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 
 	tgpar.target   = target;
 	tgpar.targinfo = t->data;
-	ret = xt_check_target(&tgpar, t->target_size,
-	      e->ethproto, e->invflags & EBT_IPROTO);
-	if (ret < 0) {
+	tgpar.proto    = e->ethproto;
+	tgpar.inverted = e->invflags & EBT_IPROTO;
+	tgpar.compat_log = compat_log;
+	ret = xt_check_target(&tgpar, t->target_size);
+	if (ret) {
+		*error_offset = e->target_offset;
 		module_put(target->me);
 		goto cleanup_watchers;
 	}
@@ -808,7 +817,9 @@ letscontinue:
 }
 
 /* do the parsing of the table/chains/entries/matches/watchers/targets, heh */
-static int translate_table(char *name, struct ebt_table_info *newinfo)
+static int translate_table(char *name, struct ebt_table_info *newinfo,
+			   unsigned int *rulenum, unsigned int *error_offset,
+			   bool compat_log)
 {
 	unsigned int i, j, k, udc_cnt;
 	int ret;
@@ -916,9 +927,12 @@ static int translate_table(char *name, struct ebt_table_info *newinfo)
 
 	/* used to know what we need to clean up if something goes wrong */
 	i = 0;
+	*error_offset = sizeof(struct ebt_entry);
 	ret = EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
-	   ebt_check_entry, newinfo, name, &i, cl_s, udc_cnt);
+	   ebt_check_entry, newinfo, name, &i, cl_s, udc_cnt,
+	   error_offset, compat_log);
 	if (ret != 0) {
+		*rulenum = i;
 		EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
 		   ebt_cleanup_entry, &i);
 	}
@@ -953,6 +967,7 @@ static void get_counters(struct ebt_counter *oldcounters,
 static int do_replace(struct net *net, void __user *user, unsigned int len)
 {
 	int ret, i, countersize;
+	unsigned int rulenum, error_offset;
 	struct ebt_table_info *newinfo;
 	struct ebt_replace tmp;
 	struct ebt_table *t;
@@ -1017,7 +1032,7 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 	if (ret != 0)
 		goto free_counterstmp;
 
-	ret = translate_table(tmp.name, newinfo);
+	ret = translate_table(tmp.name, newinfo, &rulenum, &error_offset, true);
 
 	if (ret != 0)
 		goto free_counterstmp;
@@ -1103,12 +1118,246 @@ free_newinfo:
 	return ret;
 }
 
+static int
+find_failed(struct ebt_entry *e, struct ebt_entry **failed,
+	    unsigned int *which)
+{
+	if (which && (*which)-- == 0) {
+		*failed = e;
+		return 1;
+	}
+	return 0;
+}
+
+/* replace the table */
+static int get_replace(struct net *net, void __user *user, int *len)
+{
+	int ret, i, countersize;
+	unsigned int rulenum, error_offset;
+	struct ebt_table_info *newinfo;
+	struct ebt_replace tmp;
+	struct ebt_table *t;
+	struct ebt_counter *counterstmp = NULL;
+	/* used to be able to unlock earlier */
+	struct ebt_table_info *table;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	if (*len != sizeof(tmp) + tmp.entries_size) {
+		BUGPRINT("Wrong len argument\n");
+		return -EINVAL;
+	}
+
+	if (tmp.entries_size == 0) {
+		BUGPRINT("Entries_size never zero\n");
+		return -EINVAL;
+	}
+	/* overflow check */
+	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) / NR_CPUS -
+			SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
+		return -ENOMEM;
+	if (tmp.num_counters >= INT_MAX / sizeof(struct ebt_counter))
+		return -ENOMEM;
+
+	countersize = COUNTER_OFFSET(tmp.nentries) * nr_cpu_ids;
+	newinfo = vmalloc(sizeof(*newinfo) + countersize);
+	if (!newinfo)
+		return -ENOMEM;
+
+	if (countersize)
+		memset(newinfo->counters, 0, countersize);
+
+	newinfo->entries = vmalloc(tmp.entries_size);
+	if (!newinfo->entries) {
+		ret = -ENOMEM;
+		goto free_newinfo;
+	}
+	if (copy_from_user(
+	   newinfo->entries, tmp.entries, tmp.entries_size) != 0) {
+		BUGPRINT("Couldn't copy entries from userspace\n");
+		ret = -EFAULT;
+		goto free_entries;
+	}
+
+	/* the user wants counters back
+	   the check on the size is done later, when we have the lock */
+	if (tmp.num_counters) {
+		counterstmp = vmalloc(tmp.num_counters * sizeof(*counterstmp));
+		if (!counterstmp) {
+			ret = -ENOMEM;
+			goto free_entries;
+		}
+	}
+	else
+		counterstmp = NULL;
+
+	/* this can get initialized by translate_table() */
+	newinfo->chainstack = NULL;
+	ret = ebt_verify_pointers(&tmp, newinfo);
+	if (ret != 0)
+		goto free_counterstmp;
+
+	*len = 0;
+	ret = translate_table(tmp.name, newinfo, &rulenum, &error_offset, false);
+
+	if (ret < 0) {
+		/* Core failure */
+		goto free_counterstmp;
+	} else if (ret > 0) {
+		/* Extension checkentry failure
+		 * newinfo->nentries: rule num
+		 * newinfo->entries_size: offset to match/target
+		 */
+		struct ebt_entry *e = NULL;
+		struct xt_error_entry *x;
+
+		EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
+				  find_failed, &e, &rulenum);
+
+		if (!e) {
+			ret = -EFAULT;
+			goto free_counterstmp;
+		}
+		x = (void *) e + error_offset - sizeof(*x);
+		x->errcode = ret;
+		x->match = error_offset < e->watchers_offset ? 1 :
+			   error_offset < e->target_offset ? 2 : 0;
+		ret = 0;
+		if (x->match == 1) {
+			const struct ebt_entry_match *m = 
+			 	(void *) e + error_offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + m->match_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ebt_entry_match,
+					 	    u.name),
+					m->u.match->name,
+					strlen(m->u.match->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + m->match_size;
+		} else if (x->match == 2) {
+			const struct ebt_entry_watcher *w = 
+			 	(void *) e + error_offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + w->watcher_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ebt_entry_watcher,
+					 	    u.name),
+					w->u.watcher->name,
+					strlen(w->u.watcher->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + w->watcher_size;
+		} else {
+			const struct ebt_entry_target *t = 
+			 	(void *) e + error_offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + t->target_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ebt_entry_target,
+					 	    u.name),
+					t->u.target->name,
+					strlen(t->u.target->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + t->target_size;
+		}
+		goto free_counterstmp;
+	}
+
+	t = find_table_lock(net, tmp.name, &ret, &ebt_mutex);
+	if (!t) {
+		ret = -ENOENT;
+		goto free_iterate;
+	}
+
+	/* the table doesn't like it */
+	if (t->check && (ret = t->check(newinfo, tmp.valid_hooks)))
+		goto free_unlock;
+
+	if (tmp.num_counters && tmp.num_counters != t->private->nentries) {
+		BUGPRINT("Wrong nr. of counters requested\n");
+		ret = -EINVAL;
+		goto free_unlock;
+	}
+
+	/* we have the mutex lock, so no danger in reading this pointer */
+	table = t->private;
+	/* make sure the table can only be rmmod'ed if it contains no rules */
+	if (!table->nentries && newinfo->nentries && !try_module_get(t->me)) {
+		ret = -ENOENT;
+		goto free_unlock;
+	} else if (table->nentries && !newinfo->nentries)
+		module_put(t->me);
+	/* we need an atomic snapshot of the counters */
+	write_lock_bh(&t->lock);
+	if (tmp.num_counters)
+		get_counters(t->private->counters, counterstmp,
+		   t->private->nentries);
+
+	t->private = newinfo;
+	write_unlock_bh(&t->lock);
+	mutex_unlock(&ebt_mutex);
+	/* so, a user can change the chains while having messed up her counter
+	   allocation. Only reason why this is done is because this way the lock
+	   is held only once, while this doesn't bring the kernel into a
+	   dangerous state. */
+	if (tmp.num_counters &&
+	   copy_to_user(tmp.counters, counterstmp,
+	   tmp.num_counters * sizeof(struct ebt_counter))) {
+		BUGPRINT("Couldn't copy counters to userspace\n");
+		ret = -EFAULT;
+	}
+	else
+		ret = 0;
+
+	/* decrease module count and free resources */
+	EBT_ENTRY_ITERATE(table->entries, table->entries_size,
+	   ebt_cleanup_entry, NULL);
+
+	vfree(table->entries);
+	if (table->chainstack) {
+		for_each_possible_cpu(i)
+			vfree(table->chainstack[i]);
+		vfree(table->chainstack);
+	}
+	vfree(table);
+
+	vfree(counterstmp);
+	return ret;
+
+free_unlock:
+	mutex_unlock(&ebt_mutex);
+free_iterate:
+	EBT_ENTRY_ITERATE(newinfo->entries, newinfo->entries_size,
+	   ebt_cleanup_entry, NULL);
+free_counterstmp:
+	vfree(counterstmp);
+	/* can be initialized in translate_table() */
+	if (newinfo->chainstack) {
+		for_each_possible_cpu(i)
+			vfree(newinfo->chainstack[i]);
+		vfree(newinfo->chainstack);
+	}
+free_entries:
+	vfree(newinfo->entries);
+free_newinfo:
+	vfree(newinfo);
+	return ret;
+}
+
 struct ebt_table *ebt_register_table(struct net *net, struct ebt_table *table)
 {
 	struct ebt_table_info *newinfo;
 	struct ebt_table *t;
 	struct ebt_replace_kernel *repl;
 	int ret, i, countersize;
+	unsigned int rulenum, error_offset;
 	void *p;
 
 	if (!table || !(repl = table->table) || !repl->entries ||
@@ -1153,7 +1402,7 @@ struct ebt_table *ebt_register_table(struct net *net, struct ebt_table *table)
 			newinfo->hook_entry[i] = p +
 				((char *)repl->hook_entry[i] - repl->entries);
 	}
-	ret = translate_table(repl->name, newinfo);
+	ret = translate_table(repl->name, newinfo, &rulenum, &error_offset, true);
 	if (ret != 0) {
 		BUGPRINT("Translate_table failed\n");
 		goto free_chainstack;
@@ -1463,6 +1712,10 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		mutex_unlock(&ebt_mutex);
 		break;
 
+	case EBT_SO_GET_REPLACE:
+		ret = get_replace(sock_net(sk), user, len);
+		break;
+
 	default:
 		mutex_unlock(&ebt_mutex);
 		ret = -EINVAL;
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 7505dff..a677016 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -479,7 +479,8 @@ static inline int check_entry(struct arpt_entry *e, const char *name)
 	return 0;
 }
 
-static inline int check_target(struct arpt_entry *e, const char *name)
+static inline int check_target(struct arpt_entry *e, const char *name,
+			       bool compat_log)
 {
 	struct arpt_entry_target *t = arpt_get_target(e);
 	int ret;
@@ -490,10 +491,13 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
 		.family    = NFPROTO_ARP,
+		.proto	   = 0,
+		.inverted  = false,
+		.compat_log = compat_log,
 	};
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t), 0, false);
-	if (ret < 0) {
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t));
+	if (ret) {
 		duprintf("arp_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		return ret;
@@ -503,7 +507,8 @@ static inline int check_target(struct arpt_entry *e, const char *name)
 
 static inline int
 find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+		 unsigned int *i, unsigned int *error_offset,
+		 bool compat_log)
 {
 	struct arpt_entry_target *t;
 	struct xt_target *target;
@@ -520,14 +525,16 @@ find_check_entry(struct arpt_entry *e, const char *name, unsigned int size,
 					 "arpt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = target ? -XT_PTR_ERR : -ENOENT;
 		goto out;
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
-	if (ret)
+	ret = check_target(e, name, compat_log);
+	if (ret) {
+		*error_offset = e->target_offset;
 		goto err;
+	}
 
 	(*i)++;
 	return 0;
@@ -607,9 +614,10 @@ static int translate_table(const char *name,
 			   unsigned int size,
 			   unsigned int number,
 			   const unsigned int *hook_entries,
-			   const unsigned int *underflows)
+			   const unsigned int *underflows,
+			   bool compat_log)
 {
-	unsigned int i;
+	unsigned int i, error_offset;
 	int ret;
 
 	newinfo->size = size;
@@ -665,10 +673,16 @@ static int translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
+	error_offset = sizeof(struct arpt_entry);
 	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
-				 find_check_entry, name, size, &i);
+				 find_check_entry, name, size, &i,
+				 &error_offset, compat_log);
 
 	if (ret != 0) {
+		/* Reuse members */
+		newinfo->hook_entry[0] = i;
+		newinfo->underflow[0] = error_offset;
+		
 		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
 				cleanup_entry, &i);
 		return ret;
@@ -1083,7 +1097,7 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 
 	ret = translate_table(tmp.name, tmp.valid_hooks,
 			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+			      tmp.hook_entry, tmp.underflow, true);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1102,6 +1116,122 @@ static int do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+static int
+find_failed(struct arpt_entry *e, struct arpt_entry **failed,
+	    unsigned int *which)
+{
+	if (which && (*which)-- == 0) {
+		*failed = e;
+		return 1;
+	}
+	return 0;
+}
+
+static int get_replace(struct net *net, void __user *user, int *len)
+{
+	int ret;
+	struct arpt_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	*len = 0;
+	ret = translate_table(tmp.name, tmp.valid_hooks,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
+			      tmp.hook_entry, tmp.underflow, false);
+	if (ret < 0) {
+		/* Core failure */
+		goto free_newinfo;
+	} else if (ret > 0) {
+		/* Extension checkentry failure
+		 * newinfo->hook_entry[0]: rule num
+		 * newinfo->underflow[0]: offset to match/target
+		 */
+		struct arpt_entry *e = NULL;
+		struct xt_error_entry *x;
+		unsigned int offset = newinfo->underflow[0];
+		unsigned int rulenum = newinfo->hook_entry[0];
+
+		ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size,
+				   find_failed, &e, &rulenum);
+
+		if (!e) {
+			ret = -EFAULT;
+			goto free_newinfo;
+		}
+		x = (void *) e + offset - sizeof(*x);
+		x->errcode = ret;
+		x->match = !!(offset < e->target_offset);
+		ret = 0;
+		if (x->match) {
+#ifndef ARPT_ENTRY_MATCH_INTRODUCED
+			ret = -EFAULT;
+#else
+			const struct arpt_entry_match *m = 
+			 	(void *) e + offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + m->u.match_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct arpt_entry_match,
+					 	    u.user.name),
+					m->u.kernel.match->name,
+					strlen(m->u.kernel.match->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + m->u.match_size;
+#endif
+		} else {
+			const struct arpt_entry_target *t = 
+			 	(void *) e + offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + t->u.target_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct arpt_entry_target,
+					 	    u.user.name),
+					t->u.kernel.target->name,
+					strlen(t->u.kernel.target->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + t->u.target_size;
+		}
+		goto free_newinfo;
+	}
+
+	duprintf("arp_tables: Translated table\n");
+
+	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	ARPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
 /* We're lazy, and add to the first CPU; overflow works its fey magic
  * and everything is OK. */
 static int
@@ -1334,7 +1464,7 @@ static inline int compat_check_entry(struct arpt_entry *e, const char *name,
 {
 	int ret;
 
-	ret = check_target(e, name);
+	ret = check_target(e, name, true);
 	if (ret)
 		return ret;
 
@@ -1751,6 +1881,10 @@ static int do_arpt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len
 					"arpt_%s", rev.name);
 		break;
 	}
+	
+	case ARPT_SO_GET_REPLACE:
+		ret = get_replace(sock_net(sk), user, len);
+		break;
 
 	default:
 		duprintf("do_arpt_get_ctl: unknown request %i\n", cmd);
@@ -1784,7 +1918,8 @@ struct xt_table *arpt_register_table(struct net *net, struct xt_table *table,
 			      newinfo, loc_cpu_entry, repl->size,
 			      repl->num_entries,
 			      repl->hook_entry,
-			      repl->underflow);
+			      repl->underflow,
+			      true);
 
 	duprintf("arpt_register_table: translate table gives %d\n", ret);
 	if (ret != 0)
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index fdefae6..954e90e 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -600,28 +600,30 @@ check_entry(struct ipt_entry *e, const char *name)
 
 static int
 check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
-	    unsigned int *i)
+	    unsigned int *i, unsigned int *error_offset)
 {
 	const struct ipt_ip *ip = par->entryinfo;
 	int ret;
 
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
+	par->proto     = ip->proto;
+	par->inverted  = ip->invflags & IPT_INV_PROTO;
 
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-	      ip->proto, ip->invflags & IPT_INV_PROTO);
-	if (ret < 0) {
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m));
+	if (ret) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 par.match->name);
 		return ret;
 	}
+	*error_offset += m->u.match_size;
 	++*i;
 	return 0;
 }
 
 static int
 find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
-		 unsigned int *i)
+		 unsigned int *i, unsigned int *error_offset)
 {
 	struct xt_match *match;
 	int ret;
@@ -631,11 +633,11 @@ find_check_match(struct ipt_entry_match *m, struct xt_mtchk_param *par,
 					"ipt_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return match ? -XT_PTR_ERR : -ENOENT;
 	}
 	m->u.kernel.match = match;
 
-	ret = check_match(m, par, i);
+	ret = check_match(m, par, i, error_offset);
 	if (ret)
 		goto err;
 
@@ -645,7 +647,8 @@ err:
 	return ret;
 }
 
-static int check_target(struct ipt_entry *e, const char *name)
+static int check_target(struct ipt_entry *e, const char *name,
+			bool compat_log)
 {
 	struct ipt_entry_target *t = ipt_get_target(e);
 	struct xt_tgchk_param par = {
@@ -655,12 +658,14 @@ static int check_target(struct ipt_entry *e, const char *name)
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
 		.family    = NFPROTO_IPV4,
+		.proto     = e->ip.proto,
+		.inverted  = e->ip.invflags & IPT_INV_PROTO,
+		.compat_log = compat_log,
 	};
 	int ret;
 
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
-	if (ret < 0) {
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t));
+	if (ret) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		return ret;
@@ -670,7 +675,8 @@ static int check_target(struct ipt_entry *e, const char *name)
 
 static int
 find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+		 unsigned int *i, unsigned int *error_offset,
+		 bool compat_log)
 {
 	struct ipt_entry_target *t;
 	struct xt_target *target;
@@ -687,10 +693,11 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
-	ret = IPT_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
-	if (ret != 0)
+	mtpar.compat_log = compat_log;
+	ret = IPT_MATCH_ITERATE(e, find_check_match, &mtpar, &j, error_offset);
+	if (ret != 0) {
 		goto cleanup_matches;
-
+	}
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
 							t->u.user.name,
@@ -698,14 +705,16 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 					 "ipt_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = target ? -XT_PTR_ERR : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
-	if (ret)
+	ret = check_target(e, name, compat_log);
+	if (ret) {
+		*error_offset = e->target_offset;
 		goto err;
+	}
 
 	(*i)++;
 	return 0;
@@ -791,9 +800,10 @@ translate_table(const char *name,
 		unsigned int size,
 		unsigned int number,
 		const unsigned int *hook_entries,
-		const unsigned int *underflows)
+		const unsigned int *underflows,
+		bool compat_log)
 {
-	unsigned int i;
+	unsigned int i, error_offset;
 	int ret;
 
 	newinfo->size = size;
@@ -845,12 +855,19 @@ translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
+	error_offset = sizeof(struct ipt_entry);
 	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
-				find_check_entry, name, size, &i);
+				find_check_entry, name, size,
+				&i, &error_offset, compat_log);
 
 	if (ret != 0) {
+		/* Reuse members */
+		newinfo->hook_entry[0] = i;
+		newinfo->underflow[0] = error_offset;
+
 		IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				cleanup_entry, &i);
+
 		return ret;
 	}
 
@@ -1291,7 +1308,7 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 
 	ret = translate_table(tmp.name, tmp.valid_hooks,
 			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+			      tmp.hook_entry, tmp.underflow, true);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1310,6 +1327,120 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+static int
+find_failed(struct ipt_entry *e, struct ipt_entry **failed,
+	    unsigned int *which)
+{
+	if (which && (*which)-- == 0) {
+		*failed = e;
+		return 1;
+	}
+	return 0;
+}
+
+static int
+get_replace(struct net *net, void __user *user, int *len)
+{
+	int ret;
+	struct ipt_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	*len = 0;
+	ret = translate_table(tmp.name, tmp.valid_hooks,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
+			      tmp.hook_entry, tmp.underflow, false);
+	if (ret < 0) {
+		/* Core failure */
+		goto free_newinfo;
+	} else if (ret > 0) {
+		/* Extension checkentry failure
+		 * newinfo->hook_entry[0]: rule num
+		 * newinfo->underflow[0]: offset to match/target
+		 */
+		struct ipt_entry *e = NULL;
+		struct xt_error_entry *x;
+		unsigned int offset = newinfo->underflow[0];
+		unsigned int rulenum = newinfo->hook_entry[0];
+
+		IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size,
+				  find_failed, &e, &rulenum);
+
+		if (!e) {
+			ret = -EFAULT;
+			goto free_newinfo;
+		}
+		x = (void *) e + offset - sizeof(*x);
+		x->errcode = ret;
+		x->match = !!(offset < e->target_offset);
+		ret = 0;
+		if (x->match) {
+			const struct ipt_entry_match *m = 
+			 	(void *) e + offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + m->u.match_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ipt_entry_match,
+					 	    u.user.name),
+					m->u.kernel.match->name,
+					strlen(m->u.kernel.match->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + m->u.match_size;
+		} else {
+			const struct ipt_entry_target *t = 
+			 	(void *) e + offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + t->u.target_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ipt_entry_target,
+					 	    u.user.name),
+					t->u.kernel.target->name,
+					strlen(t->u.kernel.target->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + t->u.target_size;
+		}
+		goto free_newinfo;
+	}
+
+	duprintf("ip_tables: Translated table\n");
+
+	*len = 0;
+	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	IPT_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
 /* We're lazy, and add to the first CPU; overflow works its fey magic
  * and everything is OK. */
 static int
@@ -1645,7 +1776,7 @@ compat_check_entry(struct ipt_entry *e, const char *name,
 				     unsigned int *i)
 {
 	struct xt_mtchk_param mtpar;
-	unsigned int j;
+	unsigned int j, error_offset;
 	int ret;
 
 	j = 0;
@@ -1653,11 +1784,12 @@ compat_check_entry(struct ipt_entry *e, const char *name,
 	mtpar.entryinfo = &e->ip;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV4;
-	ret = IPT_MATCH_ITERATE(e, check_match, &mtpar, &j);
+	mtpar.compat_log = true;
+	ret = IPT_MATCH_ITERATE(e, check_match, &mtpar, &j, &error_offset);
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, name, true);
 	if (ret)
 		goto cleanup_matches;
 
@@ -2043,6 +2175,10 @@ do_ipt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		break;
 	}
 
+	case IPT_SO_GET_REPLACE:
+		ret = get_replace(sock_net(sk), user, len);
+		break;
+
 	default:
 		duprintf("do_ipt_get_ctl: unknown request %i\n", cmd);
 		ret = -EINVAL;
@@ -2075,7 +2211,8 @@ struct xt_table *ipt_register_table(struct net *net, struct xt_table *table,
 			      newinfo, loc_cpu_entry, repl->size,
 			      repl->num_entries,
 			      repl->hook_entry,
-			      repl->underflow);
+			      repl->underflow,
+			      true);
 	if (ret != 0)
 		goto out_free;
 
@@ -2148,12 +2285,20 @@ icmp_match(const struct sk_buff *skb, const struct xt_match_param *par)
 				    !!(icmpinfo->invflags&IPT_ICMP_INV));
 }
 
-static bool icmp_checkentry(const struct xt_mtchk_param *par)
+static unsigned int icmp_checkentry(const struct xt_mtchk_param *par)
 {
-	const struct ipt_icmp *icmpinfo = par->matchinfo;
+	struct ipt_icmp *icmpinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_ICMP || par->inverted) {
+		xt_compat_log(par, "icmp match: only valid for protocol ICMP");
+		return IPT_ICMP_ERR_PROTO;
+	}
 	/* Must specify no unknown invflags */
-	return !(icmpinfo->invflags & ~IPT_ICMP_INV);
+	if (icmpinfo->invflags & ~IPT_ICMP_INV) {
+		icmpinfo->invflags &= ~IPT_ICMP_INV;
+		return IPT_ICMP_ERR_FLAGS;
+	}
+	return IPT_ICMP_ERR_NONE;
 }
 
 /* The built-in targets: standard (NULL) and error. */
@@ -2197,7 +2342,6 @@ static struct xt_match icmp_matchstruct __read_mostly = {
 	.match		= icmp_match,
 	.matchsize	= sizeof(struct ipt_icmp),
 	.checkentry	= icmp_checkentry,
-	.proto		= IPPROTO_ICMP,
 	.family		= NFPROTO_IPV4,
 };
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index ced1f2c..907235b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -628,28 +628,30 @@ check_entry(struct ip6t_entry *e, const char *name)
 }
 
 static int check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
-		       unsigned int *i)
+		       unsigned int *i, unsigned int *error_offset)
 {
 	const struct ip6t_ip6 *ipv6 = par->entryinfo;
 	int ret;
 
 	par->match     = m->u.kernel.match;
 	par->matchinfo = m->data;
+	par->proto     = ipv6->proto;
+	par->inverted  = ipv6->invflags & IP6T_INV_PROTO;
 
-	ret = xt_check_match(par, m->u.match_size - sizeof(*m),
-			     ipv6->proto, ipv6->invflags & IP6T_INV_PROTO);
-	if (ret < 0) {
+	ret = xt_check_match(par, m->u.match_size - sizeof(*m));
+	if (ret) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 par.match->name);
 		return ret;
 	}
+	*error_offset += m->u.match_size;
 	++*i;
 	return 0;
 }
 
 static int
 find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
-		 unsigned int *i)
+		 unsigned int *i, unsigned int *error_offset)
 {
 	struct xt_match *match;
 	int ret;
@@ -659,11 +661,11 @@ find_check_match(struct ip6t_entry_match *m, struct xt_mtchk_param *par,
 					"ip6t_%s", m->u.user.name);
 	if (IS_ERR(match) || !match) {
 		duprintf("find_check_match: `%s' not found\n", m->u.user.name);
-		return match ? PTR_ERR(match) : -ENOENT;
+		return match ? -XT_PTR_ERR : -ENOENT;
 	}
 	m->u.kernel.match = match;
 
-	ret = check_match(m, par, i);
+	ret = check_match(m, par, i, error_offset);
 	if (ret)
 		goto err;
 
@@ -673,7 +675,8 @@ err:
 	return ret;
 }
 
-static int check_target(struct ip6t_entry *e, const char *name)
+static int check_target(struct ip6t_entry *e, const char *name,
+			bool compat_log)
 {
 	struct ip6t_entry_target *t = ip6t_get_target(e);
 	struct xt_tgchk_param par = {
@@ -683,13 +686,15 @@ static int check_target(struct ip6t_entry *e, const char *name)
 		.targinfo  = t->data,
 		.hook_mask = e->comefrom,
 		.family    = NFPROTO_IPV6,
+		.proto     = e->ipv6.proto,
+		.inverted  = e->ipv6.invflags & IP6T_INV_PROTO,
+		.compat_log = compat_log,
 	};
 	int ret;
 
 	t = ip6t_get_target(e);
-	ret = xt_check_target(&par, t->u.target_size - sizeof(*t),
-	      e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
-	if (ret < 0) {
+	ret = xt_check_target(&par, t->u.target_size - sizeof(*t));
+	if (ret) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		return ret;
@@ -699,7 +704,8 @@ static int check_target(struct ip6t_entry *e, const char *name)
 
 static int
 find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
-		 unsigned int *i)
+		 unsigned int *i, unsigned int *error_offset,
+		 bool compat_log)
 {
 	struct ip6t_entry_target *t;
 	struct xt_target *target;
@@ -716,7 +722,8 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
-	ret = IP6T_MATCH_ITERATE(e, find_check_match, &mtpar, &j);
+	mtpar.compat_log = compat_log;
+	ret = IP6T_MATCH_ITERATE(e, find_check_match, &mtpar, &j, error_offset);
 	if (ret != 0)
 		goto cleanup_matches;
 
@@ -727,14 +734,16 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 					 "ip6t_%s", t->u.user.name);
 	if (IS_ERR(target) || !target) {
 		duprintf("find_check_entry: `%s' not found\n", t->u.user.name);
-		ret = target ? PTR_ERR(target) : -ENOENT;
+		ret = target ? -XT_PTR_ERR : -ENOENT;
 		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
 
-	ret = check_target(e, name);
-	if (ret)
+	ret = check_target(e, name, compat_log);
+	if (ret) {
+		*error_offset = e->target_offset;
 		goto err;
+	}
 
 	(*i)++;
 	return 0;
@@ -820,9 +829,10 @@ translate_table(const char *name,
 		unsigned int size,
 		unsigned int number,
 		const unsigned int *hook_entries,
-		const unsigned int *underflows)
+		const unsigned int *underflows,
+		bool compat_log)
 {
-	unsigned int i;
+	unsigned int i, error_offset;
 	int ret;
 
 	newinfo->size = size;
@@ -874,12 +884,19 @@ translate_table(const char *name,
 
 	/* Finally, each sanity check must pass */
 	i = 0;
+	error_offset = sizeof(struct ip6t_entry);
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
-				find_check_entry, name, size, &i);
+				find_check_entry, name, size,
+				&i, &error_offset, compat_log);
 
 	if (ret != 0) {
+		/* Reuse members */
+		newinfo->hook_entry[0] = i;
+		newinfo->underflow[0] = error_offset;
+
 		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
 				   cleanup_entry, &i);
+				   
 		return ret;
 	}
 
@@ -1321,7 +1338,7 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 
 	ret = translate_table(tmp.name, tmp.valid_hooks,
 			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
-			      tmp.hook_entry, tmp.underflow);
+			      tmp.hook_entry, tmp.underflow, true);
 	if (ret != 0)
 		goto free_newinfo;
 
@@ -1340,6 +1357,120 @@ do_replace(struct net *net, void __user *user, unsigned int len)
 	return ret;
 }
 
+static int
+find_failed(struct ip6t_entry *e, struct ip6t_entry **failed,
+	    unsigned int *which)
+{
+	if (which && (*which)-- == 0) {
+		*failed = e;
+		return 1;
+	}
+	return 0;
+}
+
+static int
+get_replace(struct net *net, void __user *user, int *len)
+{
+	int ret;
+	struct ip6t_replace tmp;
+	struct xt_table_info *newinfo;
+	void *loc_cpu_entry;
+
+	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+	newinfo = xt_alloc_table_info(tmp.size);
+	if (!newinfo)
+		return -ENOMEM;
+
+	/* choose the copy that is on our node/cpu */
+	loc_cpu_entry = newinfo->entries[raw_smp_processor_id()];
+	if (copy_from_user(loc_cpu_entry, user + sizeof(tmp),
+			   tmp.size) != 0) {
+		ret = -EFAULT;
+		goto free_newinfo;
+	}
+
+	*len = 0;
+	ret = translate_table(tmp.name, tmp.valid_hooks,
+			      newinfo, loc_cpu_entry, tmp.size, tmp.num_entries,
+			      tmp.hook_entry, tmp.underflow, false);
+	if (ret < 0) {
+		/* Core failure */
+		goto free_newinfo;
+ 	} else if (ret > 0) {
+ 		/* Extension checkentry failure:
+ 		 * newinfo->hook_entry[0]: rule num
+ 		 * newinfo->underflow[0]: offset to match/target
+ 		 */
+ 		struct ip6t_entry *e = NULL;
+ 		struct xt_error_entry *x;
+ 		unsigned int offset = newinfo->underflow[0];
+ 		unsigned int rulenum = newinfo->hook_entry[0];
+ 		
+ 		IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size,
+ 				   find_failed, &e, &rulenum);
+
+		if (!e) {
+			ret = -EFAULT;
+			goto free_newinfo;
+		}
+		x = (void *) e + offset - sizeof(*x);
+		x->errcode = ret;
+		x->match = !!(offset < e->target_offset);
+		ret = 0;
+		if (x->match) {
+			const struct ip6t_entry_match *m = 
+			 	(void *) e + offset;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + m->u.match_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ip6t_entry_match,
+					 	    u.user.name),
+					m->u.kernel.match->name,
+					strlen(m->u.kernel.match->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + m->u.match_size;
+		} else {
+			const struct ip6t_entry_target *t = 
+			 	(void *) e + offset;
+			*len = sizeof(*x) + t->u.target_size;
+			if (copy_to_user(user, x,
+					 sizeof(*x) + t->u.target_size) != 0
+			    || copy_to_user(user + sizeof(*x)
+					 + offsetof(struct ip6t_entry_target,
+					 	    u.user.name),
+					t->u.kernel.target->name,
+					strlen(t->u.kernel.target->name)+1)
+			    != 0)
+			    	ret = -EFAULT;
+			else
+				*len = sizeof(*x) + t->u.target_size;
+		}
+		goto free_newinfo;
+	}
+
+	duprintf("ip_tables: Translated table\n");
+
+	ret = __do_replace(net, tmp.name, tmp.valid_hooks, newinfo,
+			   tmp.num_counters, tmp.counters);
+	if (ret)
+		goto free_newinfo_untrans;
+	return 0;
+
+ free_newinfo_untrans:
+	IP6T_ENTRY_ITERATE(loc_cpu_entry, newinfo->size, cleanup_entry, NULL);
+ free_newinfo:
+	xt_free_table_info(newinfo);
+	return ret;
+}
+
 /* We're lazy, and add to the first CPU; overflow works its fey magic
  * and everything is OK. */
 static int
@@ -1676,7 +1807,7 @@ compat_copy_entry_from_user(struct compat_ip6t_entry *e, void **dstptr,
 static int compat_check_entry(struct ip6t_entry *e, const char *name,
 				     unsigned int *i)
 {
-	unsigned int j;
+	unsigned int j, error_offset;
 	int ret;
 	struct xt_mtchk_param mtpar;
 
@@ -1685,11 +1816,12 @@ static int compat_check_entry(struct ip6t_entry *e, const char *name,
 	mtpar.entryinfo = &e->ipv6;
 	mtpar.hook_mask = e->comefrom;
 	mtpar.family    = NFPROTO_IPV6;
-	ret = IP6T_MATCH_ITERATE(e, check_match, &mtpar, &j);
+	mtpar.compat_log = true;
+	ret = IP6T_MATCH_ITERATE(e, check_match, &mtpar, &j, &error_offset);
 	if (ret)
 		goto cleanup_matches;
 
-	ret = check_target(e, name);
+	ret = check_target(e, name, true);
 	if (ret)
 		goto cleanup_matches;
 
@@ -2075,6 +2207,10 @@ do_ip6t_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		break;
 	}
 
+	case IP6T_SO_GET_REPLACE:
+		ret = get_replace(sock_net(sk), user, len);
+		break;
+
 	default:
 		duprintf("do_ip6t_get_ctl: unknown request %i\n", cmd);
 		ret = -EINVAL;
@@ -2107,7 +2243,8 @@ struct xt_table *ip6t_register_table(struct net *net, struct xt_table *table,
 			      newinfo, loc_cpu_entry, repl->size,
 			      repl->num_entries,
 			      repl->hook_entry,
-			      repl->underflow);
+			      repl->underflow,
+			      true);
 	if (ret != 0)
 		goto out_free;
 
@@ -2179,12 +2316,18 @@ icmp6_match(const struct sk_buff *skb, const struct xt_match_param *par)
 }
 
 /* Called when user tries to insert an entry of this type. */
-static bool icmp6_checkentry(const struct xt_mtchk_param *par)
+static unsigned int icmp6_checkentry(const struct xt_mtchk_param *par)
 {
 	const struct ip6t_icmp *icmpinfo = par->matchinfo;
 
+	if (par->proto != IPPROTO_ICMPV6 || par->inverted) {
+		xt_compat_log(par, "icmpv6 match: only valid for protocol ICMPV6");
+		return IP6T_ICMPV6_ERR_PROTO;
+	}
 	/* Must specify no unknown invflags */
-	return !(icmpinfo->invflags & ~IP6T_ICMP_INV);
+	if (icmpinfo->invflags & ~IP6T_ICMP_INV)
+		return IP6T_ICMPV6_ERR_FLAGS;
+	return IP6T_ICMPV6_ERR_NONE;
 }
 
 /* The built-in targets: standard (NULL) and error. */
@@ -2228,7 +2371,6 @@ static struct xt_match icmp6_matchstruct __read_mostly = {
 	.match		= icmp6_match,
 	.matchsize	= sizeof(struct ip6t_icmp),
 	.checkentry	= icmp6_checkentry,
-	.proto		= IPPROTO_ICMPV6,
 	.family		= NFPROTO_IPV6,
 };
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 025d1a0..59465ca 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -329,34 +329,7 @@ int xt_find_revision(u8 af, const char *name, u8 revision, int target,
 }
 EXPORT_SYMBOL_GPL(xt_find_revision);
 
-static char *textify_hooks(char *buf, size_t size, unsigned int mask)
-{
-	static const char *const names[] = {
-		"PREROUTING", "INPUT", "FORWARD",
-		"OUTPUT", "POSTROUTING", "BROUTING",
-	};
-	unsigned int i;
-	char *p = buf;
-	bool np = false;
-	int res;
-
-	*p = '\0';
-	for (i = 0; i < ARRAY_SIZE(names); ++i) {
-		if (!(mask & (1 << i)))
-			continue;
-		res = snprintf(p, size, "%s%s", np ? "/" : "", names[i]);
-		if (res > 0) {
-			size -= res;
-			p += res;
-		}
-		np = true;
-	}
-
-	return buf;
-}
-
-int xt_check_match(struct xt_mtchk_param *par,
-		   unsigned int size, u_int8_t proto, bool inv_proto)
+int xt_check_match(struct xt_mtchk_param *par, unsigned int size)
 {
 	if (XT_ALIGN(par->match->matchsize) != size &&
 	    par->match->matchsize != -1) {
@@ -369,31 +342,8 @@ int xt_check_match(struct xt_mtchk_param *par,
 		       XT_ALIGN(par->match->matchsize), size);
 		return -EINVAL;
 	}
-	if (par->match->table != NULL &&
-	    strcmp(par->match->table, par->table) != 0) {
-		pr_err("%s_tables: %s match: only valid in %s table, not %s\n",
-		       xt_prefix[par->family], par->match->name,
-		       par->match->table, par->table);
-		return -EINVAL;
-	}
-	if (par->match->hooks && (par->hook_mask & ~par->match->hooks) != 0) {
-		char used[64], allow[64];
-
-		pr_err("%s_tables: %s match: used from hooks %s, but only "
-		       "valid from %s\n",
-		       xt_prefix[par->family], par->match->name,
-		       textify_hooks(used, sizeof(used), par->hook_mask),
-		       textify_hooks(allow, sizeof(allow), par->match->hooks));
-		return -EINVAL;
-	}
-	if (par->match->proto && (par->match->proto != proto || inv_proto)) {
-		pr_err("%s_tables: %s match: only valid for protocol %u\n",
-		       xt_prefix[par->family], par->match->name,
-		       par->match->proto);
-		return -EINVAL;
-	}
-	if (par->match->checkentry != NULL && !par->match->checkentry(par))
-		return -EINVAL;
+	if (par->match->checkentry != NULL)
+		return par->match->checkentry(par);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_match);
@@ -510,8 +460,7 @@ int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 EXPORT_SYMBOL_GPL(xt_compat_match_to_user);
 #endif /* CONFIG_COMPAT */
 
-int xt_check_target(struct xt_tgchk_param *par,
-		    unsigned int size, u_int8_t proto, bool inv_proto)
+int xt_check_target(struct xt_tgchk_param *par, unsigned int size)
 {
 	if (XT_ALIGN(par->target->targetsize) != size) {
 		pr_err("%s_tables: %s target: invalid size %Zu != %u\n",
@@ -519,31 +468,8 @@ int xt_check_target(struct xt_tgchk_param *par,
 		       XT_ALIGN(par->target->targetsize), size);
 		return -EINVAL;
 	}
-	if (par->target->table != NULL &&
-	    strcmp(par->target->table, par->table) != 0) {
-		pr_err("%s_tables: %s target: only valid in %s table, not %s\n",
-		       xt_prefix[par->family], par->target->name,
-		       par->target->table, par->table);
-		return -EINVAL;
-	}
-	if (par->target->hooks && (par->hook_mask & ~par->target->hooks) != 0) {
-		char used[64], allow[64];
-
-		pr_err("%s_tables: %s target: used from hooks %s, but only "
-		       "usable from %s\n",
-		       xt_prefix[par->family], par->target->name,
-		       textify_hooks(used, sizeof(used), par->hook_mask),
-		       textify_hooks(allow, sizeof(allow), par->target->hooks));
-		return -EINVAL;
-	}
-	if (par->target->proto && (par->target->proto != proto || inv_proto)) {
-		pr_err("%s_tables: %s target: only valid for protocol %u\n",
-		       xt_prefix[par->family], par->target->name,
-		       par->target->proto);
-		return -EINVAL;
-	}
-	if (par->target->checkentry != NULL && !par->target->checkentry(par))
-		return -EINVAL;
+	if (par->target->checkentry != NULL)
+		return par->target->checkentry(par);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(xt_check_target);


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
