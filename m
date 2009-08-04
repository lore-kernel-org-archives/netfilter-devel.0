From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 072/103] netfilter: xtables2: xt2<->xt1 translation - compat GET_ENTRIES/SET_REPLACE support
Date: Tue,  4 Aug 2009 09:25:56 +0200
Message-ID: <1249370787-17583-73-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56951 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601AbZHDH1v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:27:51 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit wires up the compat path to the translator. The
translator currently deals with the base entry, e.g. ip6t_entry.
compat<->normal translation of matchinfo data of arbitrary extensions
is done in an upcoming commit.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv6/ip6_tables.h |   12 +++++++++
 net/ipv6/netfilter/ip6_tables.c           |   38 +++++++++++++++++++---------
 net/netfilter/xt1_translat.c              |    3 +-
 3 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/include/linux/netfilter_ipv6/ip6_tables.h b/include/linux/netfilter_ipv6/ip6_tables.h
index 421c2d5..bad5135 100644
--- a/include/linux/netfilter_ipv6/ip6_tables.h
+++ b/include/linux/netfilter_ipv6/ip6_tables.h
@@ -346,6 +346,18 @@ struct compat_ip6t_entry
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
index 464930a..b7901e3 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -68,6 +68,7 @@ do {								\
 #endif
 
 #define xtsub_entry           ip6t_entry
+#define xtsub_entry_nocompat  ip6t_entry
 #define xtsub_replace         ip6t_replace
 #define xtsub_error_target    ip6t_error_target
 #define XTSUB_NFPROTO         NFPROTO_IPV6
@@ -77,6 +78,16 @@ do {								\
 
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
 
 /*
    We keep a set of rules for each CPU, so we can avoid write-locking
@@ -1444,18 +1455,6 @@ do_add_counters(struct net *net, const void __user *user, unsigned int len,
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
@@ -1859,6 +1858,10 @@ compat_do_replace(struct net *net, void __user *user, unsigned int len)
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
+	if (xt2_table_lookup(net, tmp.name, NFPROTO_IPV6,
+	    XT2_NO_RCULOCK) != NULL)
+		return ip6t2_compat_do_replace(net, user, len);
+
 	/* overflow check */
 	if (tmp.size >= INT_MAX / num_possible_cpus())
 		return -ENOMEM;
@@ -1973,6 +1976,7 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 {
 	int ret;
 	struct compat_ip6t_get_entries get;
+	struct xt2_table *xt2_table;
 	struct xt_table *t;
 
 	if (*len < sizeof(get)) {
@@ -1989,6 +1993,16 @@ compat_get_entries(struct net *net, struct compat_ip6t_get_entries __user *uptr,
 		return -EINVAL;
 	}
 
+	xt2_table = xt2_table_lookup(net, get.name, NFPROTO_IPV6,
+	            XT2_TAKE_RCULOCK);
+	if (xt2_table != NULL) {
+		ret = ip6t2_compat_table_to_xt1(uptr->entrytable, get.size,
+		      xt2_table, &ip6t_compat_xlat_info);
+		rcu_read_unlock();
+		return ret;
+	}
+	rcu_read_unlock();
+
 	xt_compat_lock(AF_INET6);
 	t = xt_find_table_lock(net, AF_INET6, get.name);
 	if (t && !IS_ERR(t)) {
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index a975a41..7719d8b 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -588,7 +588,8 @@ XTSUB2(do_replace)(struct net *net, const void __user *user, unsigned int len)
 	vfree(blob);
 	if (ret < 0)
 		goto out;
-	ret = xts_table_replace(repl.counters, repl.num_counters, net, table);
+	ret = xts_table_replace((void __user *)(unsigned long)repl.counters,
+	      repl.num_counters, net, table);
 	if (ret < 0)
 		goto out;
 	return 0;
-- 
1.6.3.3

