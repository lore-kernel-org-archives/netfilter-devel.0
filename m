From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 066/103] netfilter: xtables2: xt1->xt2 translation - SET_REPLACE support
Date: Tue,  4 Aug 2009 09:25:50 +0200
Message-ID: <1249370787-17583-67-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56946 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932576AbZHDH1o (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:44 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support table replacement from userspace. Currently without
returning counters.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h |    3 ++
 net/ipv6/netfilter/ip6_tables.c    |    9 ++++++
 net/netfilter/x_tables.c           |    3 +-
 net/netfilter/xt1_support.c        |   28 +++++++++++++++++++
 net/netfilter/xt1_translat.c       |   52 ++++++++++++++++++++++++++++++++++++
 5 files changed, 94 insertions(+), 1 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index 589e0dc..9514002 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -571,6 +571,8 @@ struct xt2_table_link {
 	struct xt2_table *table;
 };
 
+extern const char *const xt_prefix[NFPROTO_NUMPROTO];
+
 #define XT_TABLE_INFO_SZ (offsetof(struct xt_table_info, entries) \
 			  + nr_cpu_ids * sizeof(char *))
 extern int xt_register_target(struct xt_target *target);
@@ -727,6 +729,7 @@ extern int xts_starget_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_target *, const struct xt1_xlat_info *);
 extern int xts_target_to_xt1(void __user **, int *, unsigned int *,
 	const struct xt2_entry_target *);
+extern int xts_table_replace(struct net *, struct xt2_table *);
 
 extern struct xt2_rule *xt2_rule_new(struct xt2_chain *);
 extern int xt2_rule_add_match(struct xt2_rule *, const char *, uint8_t,
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 7f722a8..f6d4030 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -73,6 +73,7 @@ static int mark_source_chains(const struct xt_table_info *,
 #define xtsub_entry           ip6t_entry
 #define xtsub_replace         ip6t_replace
 #define xtsub_error_target    ip6t_error_target
+#define XTSUB_NFPROTO         NFPROTO_IPV6
 #define XTSUB_NFPROTO_IPV6    1
 #define XTSUB(x)              ip6t_ ## x
 #define XTSUB2(x)             ip6t2_ ## x
@@ -1398,6 +1399,14 @@ do_replace(struct net *net, const void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
+	/*
+	 * If the table goes away just moments later, no problem.
+	 * Just dispatching here.
+	 */
+	if (xt2_table_lookup(net, tmp.name,
+	    NFPROTO_IPV6, XT2_NO_RCULOCK) != NULL)
+		return ip6t2_do_replace(net, user, len);
+
 	/* overflow check */
 	if (tmp.num_counters >= INT_MAX / sizeof(struct xt_counters))
 		return -ENOMEM;
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d19eb56..0895016 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -72,13 +72,14 @@ enum {
 	/* XT_CONTINUE = 0xFFFFFFFF, */ /* reminder (x_tables.h) */
 };
 
-static const char *const xt_prefix[NFPROTO_NUMPROTO] = {
+const char *const xt_prefix[NFPROTO_NUMPROTO] = {
 	[NFPROTO_UNSPEC] = "x",
 	[NFPROTO_IPV4]   = "ip",
 	[NFPROTO_ARP]    = "arp",
 	[NFPROTO_BRIDGE] = "eb",
 	[NFPROTO_IPV6]   = "ip6",
 };
+EXPORT_SYMBOL_GPL(xt_prefix);
 
 /* Allow this many total entries. */
 static unsigned int xt_jumpstack_multiplier = 2;
diff --git a/net/netfilter/xt1_support.c b/net/netfilter/xt1_support.c
index d2124a3..d7270dc 100644
--- a/net/netfilter/xt1_support.c
+++ b/net/netfilter/xt1_support.c
@@ -239,4 +239,32 @@ int xts_target_to_xt1(void __user **user_ptr, int *len, unsigned int *z,
 }
 EXPORT_SYMBOL_GPL(xts_target_to_xt1);
 
+/**
+ * Load table module, check hook masks, replace table.
+ */
+int xts_table_replace(struct net *net, struct xt2_table *table)
+{
+	struct xt2_table *old_table;
+
+	old_table = try_then_request_module(xt2_table_lookup(net,
+	            table->name, table->nfproto, XT2_TAKE_RCULOCK),
+	            "%stable_%s", xt_prefix[table->nfproto], table->name);
+	if (old_table == NULL)
+		return -ENOENT;
+	if (table->valid_hooks != old_table->valid_hooks) {
+		pr_err("Invalid hook mix: 0x%x (old) vs 0x%x (new)\n",
+		       old_table->valid_hooks, table->valid_hooks);
+		rcu_read_unlock();
+		return -EINVAL;
+	}
+	rcu_read_unlock();
+
+	old_table = xt2_table_replace(net, table);
+	if (IS_ERR(old_table))
+		return PTR_ERR(old_table);
+	xt2_table_destroy(NULL, old_table);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(xts_table_replace);
+
 MODULE_LICENSE("GPL");
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index f0a9c4d..af413f5 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -436,3 +436,55 @@ XTSUB2(table_to_xt1)(void __user *user_ptr, int len, struct xt2_table *table,
 	mutex_unlock(&table->xt1_lock);
 	return ret;
 }
+
+static int
+XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
+{
+	struct xtsub_replace repl;
+	struct xt2_table *table;
+	void *blob;
+	int ret;
+
+	if (copy_from_user(&repl, user, sizeof(repl)) != 0)
+		return -EFAULT;
+
+	/* overflow check */
+	if (repl.num_counters >= INT_MAX / sizeof(struct xt_counters))
+		return -ENOMEM;
+
+#define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
+	/* Pedantry: prevent them from hitting BUG() in vmalloc.c --RR */
+	if ((SMP_ALIGN(repl.size) >> PAGE_SHIFT) + 2 > num_physpages)
+		return -ENOMEM;
+#undef SMP_ALIGN
+
+	table = xt2_table_new();
+	if (table == NULL)
+		return -ENOMEM;
+	/* Need a writable copy for check_entry_and_size_hooks. */
+	ret  = -ENOMEM;
+	blob = vmalloc(repl.size);
+	if (blob == NULL)
+		goto out;
+	if (copy_from_user(blob, user + sizeof(repl), repl.size) != 0) {
+		ret = -EFAULT;
+		goto out;
+	}
+	strncpy(table->name, repl.name, sizeof(table->name));
+	table->name[sizeof(table->name)-1] = '\0';
+	table->valid_hooks = repl.valid_hooks;
+	table->nfproto     = XTSUB_NFPROTO;
+
+	ret = XTSUB2(table_to_xt2)(table, blob, &repl);
+	vfree(blob);
+	if (ret < 0)
+		goto out;
+	ret = xts_table_replace(net, table);
+	if (ret < 0)
+		goto out;
+	return 0;
+
+ out:
+	xt2_table_destroy(NULL, table);
+	return ret;
+}
-- 
1.6.3.3

