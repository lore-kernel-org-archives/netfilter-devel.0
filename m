From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 096/103] netfilter: arptables: include xt1_perproto in arp_tables
Date: Tue,  4 Aug 2009 09:26:20 +0200
Message-ID: <1249370787-17583-97-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56962 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621AbZHDH2Q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:28:16 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_arp/arp_tables.h |   15 ++++++++++++
 net/ipv4/netfilter/Kconfig               |    1 +
 net/ipv4/netfilter/arp_tables.c          |   35 +++++++++++++++++++----------
 net/netfilter/xt1_translat.c             |   23 ++++++++++++++++++-
 4 files changed, 60 insertions(+), 14 deletions(-)

diff --git a/include/linux/netfilter_arp/arp_tables.h b/include/linux/netfilter_arp/arp_tables.h
index 16313df..8140700 100644
--- a/include/linux/netfilter_arp/arp_tables.h
+++ b/include/linux/netfilter_arp/arp_tables.h
@@ -276,6 +276,9 @@ extern unsigned int arpt_do_table(struct sk_buff *skb,
 				  const struct net_device *out,
 				  struct xt_table *table);
 
+extern struct xt2_table *arpt2_register_table(struct net *,
+	const struct xt_table *, const struct arpt_replace *);
+
 #define ARPT_ALIGN(s) XT_ALIGN(s)
 
 #ifdef CONFIG_COMPAT
@@ -291,6 +294,18 @@ struct compat_arpt_entry
 	unsigned char elems[0];
 };
 
+struct compat_arpt_replace {
+	char				name[ARPT_TABLE_MAXNAMELEN];
+	u32				valid_hooks;
+	u32				num_entries;
+	u32				size;
+	u32				hook_entry[NF_ARP_NUMHOOKS];
+	u32				underflow[NF_ARP_NUMHOOKS];
+	u32				num_counters;
+	compat_uptr_t			counters;
+	struct compat_arpt_entry	entries[0];
+};
+
 static inline struct arpt_entry_target *
 compat_arpt_get_target(struct compat_arpt_entry *e)
 {
diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
index b960bbd..2019153 100644
--- a/net/ipv4/netfilter/Kconfig
+++ b/net/ipv4/netfilter/Kconfig
@@ -361,6 +361,7 @@ endif # IP_NF_IPTABLES
 config IP_NF_ARPTABLES
 	tristate "ARP tables support"
 	select NETFILTER_XTABLES
+	select NETFILTER_XT1_SUPPORT
 	depends on NETFILTER_ADVANCED
 	help
 	  arptables is a general, extensible packet identification framework.
diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index e3911a0..850b248 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -58,6 +58,29 @@ do {								\
 #define ARP_NF_ASSERT(x)
 #endif
 
+#define xtsub_entry           arpt_entry
+#define xtsub_entry_nocompat  arpt_entry
+#define xtsub_replace         arpt_replace
+#define xtsub_error_target    arpt_error_target
+#define XTSUB_NFPROTO         NFPROTO_ARP
+#define XTSUB_NFPROTO_ARP     1
+#define XTSUB(x)              arpt_ ## x
+#define XTSUB2(x)             arpt2_ ## x
+
+#include "../../netfilter/xt1_translat.c"
+#include "../../netfilter/xt1_postshared.c"
+#undef XTSUB2
+#undef xtsub_entry
+#undef xtsub_replace
+
+#ifdef CONFIG_COMPAT
+#define XTSUB_DO_COMPAT
+#define xtsub_entry           compat_arpt_entry
+#define xtsub_replace         compat_arpt_replace
+#define XTSUB2(x)             arpt2_compat_ ## x
+#include "../../netfilter/xt1_translat.c"
+#endif
+
 static inline int arp_devaddr_compare(const struct arpt_devaddr_info *ap,
 				      const char *hdr_addr, int len)
 {
@@ -1515,18 +1538,6 @@ out_unlock:
 	goto out;
 }
 
-struct compat_arpt_replace {
-	char				name[ARPT_TABLE_MAXNAMELEN];
-	u32				valid_hooks;
-	u32				num_entries;
-	u32				size;
-	u32				hook_entry[NF_ARP_NUMHOOKS];
-	u32				underflow[NF_ARP_NUMHOOKS];
-	u32				num_counters;
-	compat_uptr_t			counters;
-	struct compat_arpt_entry	entries[0];
-};
-
 static int compat_do_replace(struct net *net, void __user *user,
 			     unsigned int len)
 {
diff --git a/net/netfilter/xt1_translat.c b/net/netfilter/xt1_translat.c
index d45e674..20a4217 100644
--- a/net/netfilter/xt1_translat.c
+++ b/net/netfilter/xt1_translat.c
@@ -12,9 +12,11 @@
 #include <linux/slab.h>
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_quota.h>
+#include <linux/netfilter_arp/arp_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
-#if !defined(XTSUB_NFPROTO_IPV4) && !defined(XTSUB_NFPROTO_IPV6)
+#if !defined(XTSUB_NFPROTO_IPV4) && !defined(XTSUB_NFPROTO_IPV6) && \
+    !defined(XTSUB_NFPROTO_ARP)
 #	error Need to define XTSUB_NFPROTO_xxx.
 #endif
 #ifdef XTSUB_DO_COMPAT
@@ -43,6 +45,13 @@ static inline bool XTSUB2(unconditional)(const struct xtsub_entry *e)
 {
 	return memcmp(&e->ipv6, &xtsub_uncond, sizeof(xtsub_uncond)) == 0;
 }
+#elif defined(XTSUB_NFPROTO_ARP)
+static const struct arpt_arp xtsub_uncond;
+
+static inline bool XTSUB2(unconditional)(const struct xtsub_entry *e)
+{
+	return memcmp(&e->arp, &xtsub_uncond, sizeof(xtsub_uncond)) == 0;
+}
 #endif
 
 static inline struct xt_entry_target *
@@ -170,6 +179,8 @@ XTSUB2(target_to_xt2)(struct xt2_rule *rule, const struct xtsub_entry *entry,
 		/* debug: (we already checked loopfreeness before) */
 		if (ntarget->r_goto == rule->chain)
 			return -ELOOP;
+#elif defined(XTSUB_NFPROTO_ARP)
+	/* arptables does not support goto */
 #endif
 	} else {
 		ntarget->ext     = XT2_ACTION_JUMP;
@@ -214,6 +225,9 @@ XTSUB2(rule_to_xt2)(struct xt2_chain *chain, const struct xtsub_entry *entry,
 		rule->flags |= XT2_INV_L4PROTO;
 	ret = xt2_rule_add_match(rule, "ipv6", 0, &entry->ipv6,
 	      sizeof(entry->ipv6), false);
+#elif defined(XTSUB_NFPROTO_ARP)
+	ret = xt2_rule_add_match(rule, "arp", 0, &entry->arp,
+	      sizeof(entry->arp), false);
 #endif
 	if (ret < 0)
 		goto out;
@@ -490,13 +504,18 @@ XTSUB2(rule_to_xt1)(void __user **user_ptr, int *len, unsigned int *z,
 	if (strcmp(ematch->ext->name, "ipv4") != 0)
 		return -EIO;
 	memcpy(&entry.ip, ematch->data, sizeof(entry.ip));
+	entry.nfcache = 0;
 #elif defined(XTSUB_NFPROTO_IPV6)
 	if (strcmp(ematch->ext->name, "ipv6") != 0)
 		return -EIO;
 	memcpy(&entry.ipv6, ematch->data, sizeof(entry.ipv6));
+	entry.nfcache = 0;
+#elif defined(XTSUB_NFPROTO_ARP)
+	if (strcmp(ematch->ext->name, "arp") != 0)
+		return -EIO;
+	memcpy(&entry.arp, ematch->data, sizeof(entry.arp));
 #endif
 	entry.comefrom = rule->chain->comefrom;
-	entry.nfcache  = 0;
 	xts_rule_get_quota(quota_ematch, &entry.counters.bcnt,
 		&entry.counters.pcnt);
 
-- 
1.6.3.3

