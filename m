From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 090/103] netfilter: iptables: include xt1_perproto code in ip_tables
Date: Tue,  4 Aug 2009 09:26:14 +0200
Message-ID: <1249370787-17583-91-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56961 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619AbZHDH2K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:10 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_ipv4/ip_tables.h |   15 ++++++++++++
 net/ipv4/netfilter/Kconfig               |    1 +
 net/ipv4/netfilter/ip_tables.c           |   35 +++++++++++++++++++----------
 net/netfilter/xt1_translat.c             |   35 +++++++++++++++++++++++++----
 4 files changed, 69 insertions(+), 17 deletions(-)

diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux/netfilter_ipv4/ip_tables.h
index f50c06f..ab81dbe 100644
--- a/include/linux/netfilter_ipv4/ip_tables.h
+++ b/include/linux/netfilter_ipv4/ip_tables.h
@@ -251,6 +251,9 @@ extern struct xt_table *ipt_register_table(struct net *net,
 					   const struct ipt_replace *repl);
 extern void ipt_unregister_table(struct xt_table *table);
 
+extern struct xt2_table *ipt2_register_table(struct net *,
+	const struct xt_table *, const struct ipt_replace *);
+
 /* Standard entry. */
 struct ipt_standard
 {
@@ -314,6 +317,18 @@ struct compat_ipt_entry
 	unsigned char elems[0];
 };
 
+struct compat_ipt_replace {
+	char			name[IPT_TABLE_MAXNAMELEN];
+	u32			valid_hooks;
+	u32			num_entries;
+	u32			size;
+	u32			hook_entry[NF_INET_NUMHOOKS];
+	u32			underflow[NF_INET_NUMHOOKS];
+	u32			num_counters;
+	compat_uptr_t		counters;	/* struct ipt_counters * */
+	struct compat_ipt_entry	entries[0];
+};
+
 /* Helper functions */
 static inline struct ipt_entry_target *
 compat_ipt_get_target(struct compat_ipt_entry *e)
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index 1833bdb..b960bbd 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -53,6 +53,7 @@ config IP_NF_IPTABLES
 	tristate "IP tables support (required for filtering/masq/NAT)"
 	default m if NETFILTER_ADVANCED=n
 	select NETFILTER_XTABLES
+	select NETFILTER_XT1_SUPPORT
 	help
 	  iptables is a general, extensible packet identification framework.
 	  The packet filtering and full NAT (masquerading, port forwarding,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f409fcd..7b7f1c3 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -66,6 +66,29 @@ do {								\
 #define inline
 #endif
 
+#define xtsub_entry           ipt_entry
+#define xtsub_entry_nocompat  ipt_entry
+#define xtsub_replace         ipt_replace
+#define xtsub_error_target    ipt_error_target
+#define XTSUB_NFPROTO         NFPROTO_IPV4
+#define XTSUB_NFPROTO_IPV4    1
+#define XTSUB(x)              ipt_ ## x
+#define XTSUB2(x)             ipt2_ ## x
+
+#include "../../netfilter/xt1_translat.c"
+#include "../../netfilter/xt1_postshared.c"
+#undef XTSUB2
+#undef xtsub_entry
+#undef xtsub_replace
+
+#ifdef CONFIG_COMPAT
+#define XTSUB_DO_COMPAT
+#define xtsub_entry           compat_ipt_entry
+#define xtsub_replace         compat_ipt_replace
+#define XTSUB2(x)             ipt2_compat_ ## x
+#include "../../netfilter/xt1_translat.c"
+#endif
+
 /*
    We keep a set of rules for each CPU, so we can avoid write-locking
    them in the softirq when updating the counters and therefore
@@ -1478,18 +1501,6 @@ do_add_counters(struct net *net, const void __user *user,
 }
 
 #ifdef CONFIG_COMPAT
-struct compat_ipt_replace {
-	char			name[IPT_TABLE_MAXNAMELEN];
-	u32			valid_hooks;
-	u32			num_entries;
-	u32			size;
-	u32			hook_entry[NF_INET_NUMHOOKS];
-	u32			underflow[NF_INET_NUMHOOKS];
-	u32			num_counters;
-	compat_uptr_t		counters;	/* struct ipt_counters * */
-	struct compat_ipt_entry	entries[0];
-};
-
 static int
 compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
 			  unsigned int *size, struct xt_counters *counters,
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index 994fcc5..d45e674 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -12,8 +12,9 @@
 #include <linux/slab.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_quota.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#if !defined(XTSUB_NFPROTO_IPV6)
+#if !defined(XTSUB_NFPROTO_IPV4) && !defined(XTSUB_NFPROTO_IPV6)
 #	error Need to define XTSUB_NFPROTO_xxx.
 #endif
 #ifdef XTSUB_DO_COMPAT
@@ -28,7 +29,14 @@
 #	define xtsub_target_to_xt1   xts_target_to_xt1
 #endif
 
-#ifdef XTSUB_NFPROTO_IPV6
+#ifdef XTSUB_NFPROTO_IPV4
+static const struct ipt_ip xtsub_uncond;
+
+static inline bool XTSUB2(unconditional)(const struct xtsub_entry *e)
+{
+	return memcmp(&e->ip, &xtsub_uncond, sizeof(xtsub_uncond)) == 0;
+}
+#elif defined(XTSUB_NFPROTO_IPV6)
 static const struct ip6t_ip6 xtsub_uncond;
 
 static inline bool XTSUB2(unconditional)(const struct xtsub_entry *e)
@@ -147,7 +155,14 @@ XTSUB2(target_to_xt2)(struct xt2_rule *rule, const struct xtsub_entry *entry,
 	} else if (st->verdict == entry_offset + entry->next_offset) {
 		ntarget->ext     = XT2_FINAL_VERDICT;
 		ntarget->verdict = XT_CONTINUE;
-#ifdef XTSUB_NFPROTO_IPV6
+#if defined(XTSUB_NFPROTO_IPV4)
+	} else if (entry->ip.flags & IPT_F_GOTO) {
+		ntarget->ext     = XT2_ACTION_GOTO;
+		ntarget->r_goto  = xts_lookup_chain(rule->chain->table,
+		                   st->verdict);
+		if (ntarget->r_goto == rule->chain)
+			return -ELOOP;
+#elif defined(XTSUB_NFPROTO_IPV6)
 	} else if (entry->ipv6.flags & IP6T_F_GOTO) {
 		ntarget->ext     = XT2_ACTION_GOTO;
 		ntarget->r_goto  = xts_lookup_chain(rule->chain->table,
@@ -187,7 +202,13 @@ XTSUB2(rule_to_xt2)(struct xt2_chain *chain, const struct xtsub_entry *entry,
 		return ERR_PTR(-ENOMEM);
 
 	rule->chain->comefrom = entry->comefrom;
-#ifdef XTSUB_NFPROTO_IPV6
+#if defined(XTSUB_NFPROTO_IPV4)
+	rule->l4proto = entry->ip.proto;
+	if (entry->ip.flags & IPT_INV_PROTO)
+		rule->flags |= XT2_INV_L4PROTO;
+	ret = xt2_rule_add_match(rule, "ipv4", 0, &entry->ip,
+	      sizeof(entry->ip), false);
+#elif defined(XTSUB_NFPROTO_IPV6)
 	rule->l4proto = entry->ipv6.proto;
 	if (entry->ipv6.flags & IP6T_INV_PROTO)
 		rule->flags |= XT2_INV_L4PROTO;
@@ -465,7 +486,11 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 	z_start = *z;
 	ematch = list_first_entry(&rule->match_list,
 	         typeof(*ematch), anchor);
-#ifdef XTSUB_NFPROTO_IPV6
+#if defined(XTSUB_NFPROTO_IPV4)
+	if (strcmp(ematch->ext->name, "ipv4") != 0)
+		return -EIO;
+	memcpy(&entry.ip, ematch->data, sizeof(entry.ip));
+#elif defined(XTSUB_NFPROTO_IPV6)
 	if (strcmp(ematch->ext->name, "ipv6") != 0)
 		return -EIO;
 	memcpy(&entry.ipv6, ematch->data, sizeof(entry.ipv6));
-- 
1.6.3.3

