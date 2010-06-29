From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 25/56] netfilter: xtables2: xt2<->xt1 translation - compat GET_ENTRIES/SET_REPLACE support
Date: Tue, 29 Jun 2010 10:43:05 +0200
Message-ID: <1277801017-30600-26-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44281 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab0F2IoH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:07 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit wires up the compat path to the translator. The
translator currently deals with the base entry, e.g. ip6t_entry.
compat<->normal translation of matchinfo data of arbitrary extensions
is done in an upcoming commit.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv6/ip6_tables.h |   12 +++++++++
 net/ipv6/netfilter/ip6_tables.c           |   39 ++++++++++++++++++++---------
 net/netfilter/xt1_translat.c              |    3 +-
 3 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index d1d5d3a..b86e18c 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -335,6 +335,18 @@ struct compat_ip6t_entry {
 	unsigned char elems[0];
 };
 
+struct compat_ip6t_replace {
+	char			name[IP6T_TABLE_MAXNAMELEN];
+	u32			valid_hooks;
+	u32			num_entries;
+	u32			size;
+	u32			hook_entry[NF_INET_NUMHOOKS];
+	u32			underflow[NF_INET_NUMHOOKS];
+	u32			num_counters;
+	compat_uptr_t		counters;	/* struct ip6t_counters * */
+	struct compat_ip6t_entry entries[0];
+};
+
 static inline struct ip6t_entry_target *
 compat_ip6t_get_target(struct compat_ip6t_entry *e)
 {
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 1aff1b0..5522533 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -64,6 +64,7 @@ MODULE_DESCRIPTION("IPv6 packet filter");
 #endif
 
 #define xtsub_entry           ip6t_entry
+#define xtsub_entry_nocompat  ip6t_entry
 #define xtsub_replace         ip6t_replace
 #define xtsub_error_target    ip6t_error_target
 #define XTSUB_NFPROTO         NFPROTO_IPV6
@@ -73,6 +74,16 @@ MODULE_DESCRIPTION("IPv6 packet filter");
 
 #include "../../netfilter/xt1_translat.c"
 #include "../../netfilter/xt1_postshared.c"
+#undef XTSUB2
+#undef xtsub_entry
+#undef xtsub_replace
+
+#ifdef CONFIG_COMPAT
+#define xtsub_entry           compat_ip6t_entry
+#define xtsub_replace         compat_ip6t_replace
+#define XTSUB2(x)             ip6t2_compat_ ## x
+#include "../../netfilter/xt1_translat.c"
+#endif
 
 void *ip6t_alloc_initial_table(const struct xt_table *info)
 {
@@ -1468,18 +1479,6 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
 }
 
 #ifdef CONFIG_COMPAT
-struct compat_ip6t_replace {
-	char			name[IP6T_TABLE_MAXNAMELEN];
-	u32			valid_hooks;
-	u32			num_entries;
-	u32			size;
-	u32			hook_entry[NF_INET_NUMHOOKS];
-	u32			underflow[NF_INET_NUMHOOKS];
-	u32			num_counters;
-	compat_uptr_t		counters;	/* struct ip6t_counters * */
-	struct compat_ip6t_entry entries[0];
-};
-
 static int
 compat_copy_entry_to_user(struct ip6t_entry *e, void __user **dstptr,
 			  unsigned int *size, struct xt_counters *counters,
@@ -1889,6 +1888,10 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
+	if (xt2_table_lookup(net, tmp.name, NFPROTO_IPV6,
+			     XT2_STD_RCULOCK) != NULL)
+		return ip6t2_compat_do_replace(net, user, len);
+
 	/* overflow check */
 	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
@@ -2003,6 +2006,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 {
 	int ret;
 	struct compat_ip6t_get_entries get;
+	struct xt2_table *xt2_table;
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
@@ -2019,6 +2023,17 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
+	xt2_table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
+				     XT2_KEEP_RCULOCK);
+	if (xt2_table != NULL) {
+		ret = ip6t2_compat_table_to_xt1(uptr->entrytable, get.size,
+						xt2_table,
+						&ip6t_compat_xlat_info);
+		rcu_read_unlock();
+		return ret;
+	}
+	rcu_read_unlock();
+
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index fe6e4be..bd8fc2d 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -587,7 +587,8 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 	vfree(blob);
 	if (ret < 0)
 		goto out;
-	ret = xts_table_replace(repl.counters, repl.num_counters, net, table);
+	ret = xts_table_replace((void __user *)(unsigned long)repl.counters,
+				repl.num_counters, net, table);
 	if (ret < 0)
 		goto out;
 	return 0;
-- 
1.7.1

