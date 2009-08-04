From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 064/103] netfilter: xtables2: xt2->xt1 translation - GET_INFO support
Date: Tue,  4 Aug 2009 09:25:48 +0200
Message-ID: <1249370787-17583-65-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56947 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932572AbZHDH1m (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:42 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Part 1 of the backwards translation. Calculates size and
hook_entry/underflow points.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |   28 ++++++++
 net/ipv6/netfilter/ip6_tables.c    |   41 +++++++++++-
 net/netfilter/xt1_support.c        |  123 ++++++++++++++++++++++++++++++++++++
 3 files changed, 190 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index cf8e65e..0c9d64f 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -414,6 +414,26 @@ struct xt_table_info
 	void *entries[1];
 };
 
+/**
+ * xt1 size definitions
+ *
+ * @marker_size:	size of a user-chain and end-of-ruleset marker
+ * @entry_hdr_size:	size of struct ip6t_entry
+ * @pmatch_size:	size of struct ip6t_ip6
+ * @first_match:	required name of the first match
+ * @ematch_size:	size of the ematch header
+ * @etarget_size:	size of the etarget header
+ * @standard_tgsize:	size of the complete standard target, includes
+ * 			etarget_size and alignment padding
+ */
+struct xt1_xlat_info {
+	unsigned int marker_size;
+	unsigned int entry_hdr_size, pmatch_size;
+	unsigned int ematch_size, etarget_size;
+	unsigned int standard_tgsize;
+	const char *first_match;
+};
+
 /*
  * The use of low negative numbers means we can use IS_ERR()
  * (See xt2_special_target below.)
@@ -693,6 +713,9 @@ extern void *xt_repldata_create(const struct xt_table *);
 
 extern struct xt2_chain *xts_lookup_chain(const struct xt2_table *,
 	unsigned int);
+extern unsigned int xts_blob_prep_table(const struct xt2_table *,
+	const struct xt1_xlat_info *, unsigned int *, unsigned int *,
+	unsigned int *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
@@ -715,6 +738,11 @@ extern unsigned int xt2_do_table(struct sk_buff *, unsigned int,
 	const struct net_device *, const struct net_device *,
 	const struct xt2_table *);
 
+static inline bool xt2_builtin_chain(const struct xt2_chain *c)
+{
+	return *c->name == '\0';
+}
+
 static inline bool xt2_special_target(const struct xt_target *t)
 {
 	return IS_ERR(t);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index edb00ad..8dc507d 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1164,10 +1164,36 @@ static int compat_table_info(const struct xt_table_info *info,
 }
 #endif
 
+static const struct xt1_xlat_info ip6t_xlat_info = {
+	.marker_size     = sizeof(struct ip6t_error_target),
+	.entry_hdr_size  = sizeof(struct ip6t_entry),
+	.pmatch_size     = sizeof(struct ip6t_ip6),
+	.first_match     = "ipv6",
+	.ematch_size     = sizeof(struct xt_entry_match),
+	.etarget_size    = sizeof(struct xt_entry_target),
+	.standard_tgsize = XT_ALIGN(sizeof(struct xt_entry_target) +
+	                   sizeof(int)),
+};
+
+static int ip6t2_get_info(void __user *uptr, int len,
+                          const struct xt2_table *table)
+{
+	struct ip6t_getinfo info = {
+		.valid_hooks = table->valid_hooks,
+	};
+
+	strncpy(info.name, table->name,
+	        min(sizeof(info.name), sizeof(table->name)));
+	info.size = xts_blob_prep_table(table, &ip6t_xlat_info,
+	            info.hook_entry, info.underflow, &info.num_entries);
+	return (copy_to_user(uptr, &info, sizeof(info)) != 0) ? -EFAULT : 0;
+}
+
 static int get_info(struct net *net, void __user *user,
                     const int *len, int compat)
 {
 	char name[IP6T_TABLE_MAXNAMELEN];
+	struct xt2_table *xt2_table;
 	struct xt_table *t;
 	int ret;
 
@@ -1181,12 +1207,23 @@ static int get_info(struct net *net, void __user *user,
 		return -EFAULT;
 
 	name[IP6T_TABLE_MAXNAMELEN-1] = '\0';
+	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
+				    "ip6table_%s", name);
+	xt2_table = xt2_table_lookup(net, name, NFPROTO_IPV6,
+	            XT2_TAKE_RCULOCK);
+	if (xt2_table != NULL) {
+		ret = ip6t2_get_info(user, *len, xt2_table);
+		rcu_read_unlock();
+		if (t != NULL)
+			module_put(t->me);
+		return ret;
+	}
+	rcu_read_unlock();
+
 #ifdef CONFIG_COMPAT
 	if (compat)
 		xt_compat_lock(AF_INET6);
 #endif
-	t = try_then_request_module(xt_find_table_lock(net, AF_INET6, name),
-				    "ip6table_%s", name);
 	if (t && !IS_ERR(t)) {
 		struct ip6t_getinfo info;
 		const struct xt_table_info *private = t->private;
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index d15bfb7..5900880 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -7,7 +7,9 @@
  *	the Free Software Foundation, either version 2 of the License, or
  *	(at your option) any later version.
  */
+#include <linux/list.h>
 #include <linux/module.h>
+#include <linux/rcupdate.h>
 #include <linux/netfilter/x_tables.h>
 
 /**
@@ -34,4 +36,125 @@ xts_lookup_chain(const struct xt2_table *table, unsigned int needle)
 }
 EXPORT_SYMBOL_GPL(xts_lookup_chain);
 
+/**
+ * get pointer to quota ematches
+ *
+ * Also used for the xt2->xt1 converter. Generalized matches run until the two
+ * last quota matches.
+ */
+static const struct xt2_entry_match *
+xts_rule_quota_ptr(const struct xt2_rule *rule)
+{
+	const struct xt2_entry_match *ematch;
+
+	/* Need at least two ematches */
+	if (list_empty(&rule->match_list) ||
+	    rule->match_list.next->next == &rule->match_list)
+		return NULL;
+
+	/* Now need exactly two trailing quota matches */
+	ematch = list_entry(rule->match_list.prev, typeof(*ematch), anchor);
+	if (strcmp(ematch->ext->name, "quota") != 0 &&
+	    ematch->ext->revision != 3)
+		return NULL;
+	ematch = list_entry(ematch->anchor.prev, typeof(*ematch), anchor);
+	if (strcmp(ematch->ext->name, "quota") != 0 &&
+	    ematch->ext->revision != 3)
+		return NULL;
+	return ematch;
+}
+
+static int
+xts_blob_prep_rule(const struct xt2_rule *rule, const struct xt1_xlat_info *io,
+                   unsigned int *underflow, unsigned int z)
+{
+	const struct xt2_table *table = rule->chain->table;
+	const struct xt2_entry_match *ematch, *quota_stop;
+	const struct xt2_entry_target *etarget;
+	unsigned int h;
+
+	/* Quota check implies ematch list empty check. */
+	quota_stop = xts_rule_quota_ptr(rule);
+	if (quota_stop == NULL)
+		return -EIO;
+
+	/* Must have exactly one target */
+	if (list_empty(&rule->target_list) ||
+	    rule->target_list.next->next != &rule->target_list)
+		return -EIO;
+
+	ematch = list_first_entry(&rule->match_list,
+	         typeof(*ematch), anchor);
+	if (strcmp(ematch->ext->name, io->first_match) != 0)
+		return -EIO;
+
+	/* Do underflow assign first before @z is increased. */
+	for (h = 0; h < ARRAY_SIZE(table->underflow); ++h)
+		if (rule == table->underflow[h])
+			underflow[h] = z;
+
+	/* Subtracting, because it will already be added in the loop. */
+	z += io->entry_hdr_size - io->ematch_size - io->pmatch_size;
+
+	list_for_each_entry(ematch, &rule->match_list, anchor) {
+		if (ematch == quota_stop)
+			/* quotas included in entry_hdr */
+			break;
+		z += io->ematch_size + ematch->dsize;
+	}
+
+	etarget = list_first_entry(&rule->target_list,
+	          typeof(*etarget), anchor);
+	z += xt2_special_target(etarget->ext) ? io->standard_tgsize :
+	     io->etarget_size + XT_ALIGN(etarget->ext->targetsize);
+	return z;
+}
+
+/**
+ * - calculate details for GETINFO ioctl from xt2 table
+ * @table:	the xt2 table
+ * @io:		info block on blob's field sizes
+ *
+ * Calculate the details for a GETINFO ioctl from the supplied xt2 table.
+ * Returns -1 if the table cannot be converted to an xt1 blob without
+ * loss of information.
+ */
+unsigned int
+xts_blob_prep_table(const struct xt2_table *table,
+                    const struct xt1_xlat_info *io,
+                    unsigned int *hook_entry, unsigned int *underflow,
+                    unsigned int *entries_ptr)
+{
+	const struct xt2_chain *chain;
+	const struct xt2_rule *rule;
+	unsigned int hook, entries = 0;
+	int z = 0;
+
+	rcu_read_lock();
+	list_for_each_entry(chain, &table->chain_list, anchor) {
+		for (hook = 0; hook < ARRAY_SIZE(table->entrypoint); ++hook)
+			if (table->entrypoint[hook] == chain)
+				hook_entry[hook] = z;
+
+		if (!xt2_builtin_chain(chain)) {
+			z += io->entry_hdr_size + io->marker_size;
+			++entries;
+		}
+
+		list_for_each_entry(rule, &chain->rule_list, anchor) {
+			++entries;
+			z = xts_blob_prep_rule(rule, io, underflow, z);
+			if (z < 0)
+				return z;
+		}
+	}
+	rcu_read_unlock();
+
+	/* Table terminator */
+	z += io->entry_hdr_size + io->marker_size;
+	*entries_ptr = ++entries;
+	return z;
+}
+EXPORT_SYMBOL_GPL(xts_blob_prep_table);
+
 MODULE_LICENSE("GPL");
-- 
1.6.3.3

