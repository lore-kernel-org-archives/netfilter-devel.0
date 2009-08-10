From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/6] netfilter: xtables: use xt_table for hook instantiation
Date: Mon, 10 Aug 2009 21:19:51 +0200
Message-ID: <1249931992-18761-6-git-send-email-jengelh@medozas.de>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33988 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634AbZHJTUE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2009 15:20:04 -0400
In-Reply-To: <1249931992-18761-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The respective xt_table structures already have most of the metadata
needed for hook setup. Add a 'priority' field to struct xt_table so
that xt_hook_link() can be called with a reduced number of arguments.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/x_tables.h     |    6 +++---
 net/ipv4/netfilter/arptable_filter.c   |    6 +++---
 net/ipv4/netfilter/iptable_filter.c    |    6 +++---
 net/ipv4/netfilter/iptable_mangle.c    |    6 +++---
 net/ipv4/netfilter/iptable_raw.c       |    6 +++---
 net/ipv4/netfilter/iptable_security.c  |    6 +++---
 net/ipv6/netfilter/ip6table_filter.c   |    6 +++---
 net/ipv6/netfilter/ip6table_mangle.c   |    6 +++---
 net/ipv6/netfilter/ip6table_raw.c      |    6 +++---
 net/ipv6/netfilter/ip6table_security.c |    6 +++---
 net/netfilter/x_tables.c               |   18 ++++++++----------
 11 files changed, 38 insertions(+), 40 deletions(-)

diff --git a/include/linux/netfilter/x_tables.h b/include/linux/netfilter/x_tables.h
index b71d9fa..2a47a01 100644
--- a/include/linux/netfilter/x_tables.h
+++ b/include/linux/netfilter/x_tables.h
@@ -363,6 +363,7 @@ struct xt_table
 	struct module *me;
 
 	u_int8_t af;		/* address/protocol family */
+	int priority;		/* hook order */
 
 	/* A unique name... */
 	const char name[XT_TABLE_MAXNAMELEN];
@@ -525,9 +526,8 @@ static inline unsigned long ifname_compare_aligned(const char *_a,
 	return ret;
 }
 
-extern struct nf_hook_ops *xt_hook_link(nf_hookfn *, uint8_t, int,
-	unsigned int, struct module *);
-extern void xt_hook_unlink(struct nf_hook_ops *, unsigned int);
+extern struct nf_hook_ops *xt_hook_link(const struct xt_table *, nf_hookfn *);
+extern void xt_hook_unlink(const struct xt_table *, struct nf_hook_ops *);
 
 #ifdef CONFIG_COMPAT
 #include <net/compat.h>
diff --git a/net/ipv4/netfilter/arptable_filter.c b/net/ipv4/netfilter/arptable_filter.c
index 1828a77..d5e822a 100644
--- a/net/ipv4/netfilter/arptable_filter.c
+++ b/net/ipv4/netfilter/arptable_filter.c
@@ -50,6 +50,7 @@ static const struct xt_table packet_filter = {
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_ARP,
+	.priority	= NF_IP_PRI_FILTER,
 };
 
 /* The work comes in here from netfilter.c */
@@ -94,8 +95,7 @@ static int __init arptable_filter_init(void)
 	if (ret < 0)
 		return ret;
 
-	arpfilter_ops = xt_hook_link(arptable_filter_hook, NFPROTO_ARP,
-	                NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	arpfilter_ops = xt_hook_link(&packet_filter, arptable_filter_hook);
 	if (IS_ERR(arpfilter_ops)) {
 		ret = PTR_ERR(arpfilter_ops);
 		goto cleanup_table;
@@ -109,7 +109,7 @@ cleanup_table:
 
 static void __exit arptable_filter_fini(void)
 {
-	xt_hook_unlink(arpfilter_ops, FILTER_VALID_HOOKS);
+	xt_hook_unlink(&packet_filter, arpfilter_ops);
 	unregister_pernet_subsys(&arptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_filter.c b/net/ipv4/netfilter/iptable_filter.c
index 18bd254..7f631a3 100644
--- a/net/ipv4/netfilter/iptable_filter.c
+++ b/net/ipv4/netfilter/iptable_filter.c
@@ -58,6 +58,7 @@ static const struct xt_table packet_filter = {
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
+	.priority	= NF_IP_PRI_FILTER,
 };
 
 static unsigned int
@@ -121,8 +122,7 @@ static int __init iptable_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	filter_ops = xt_hook_link(iptable_filter_hook, NFPROTO_IPV4,
-	             NF_IP_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	filter_ops = xt_hook_link(&packet_filter, iptable_filter_hook);
 	if (IS_ERR(filter_ops)) {
 		ret = PTR_ERR(filter_ops);
 		goto cleanup_table;
@@ -137,7 +137,7 @@ static int __init iptable_filter_init(void)
 
 static void __exit iptable_filter_fini(void)
 {
-	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
+	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&iptable_filter_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_mangle.c b/net/ipv4/netfilter/iptable_mangle.c
index a217de4..02be0d9 100644
--- a/net/ipv4/netfilter/iptable_mangle.c
+++ b/net/ipv4/netfilter/iptable_mangle.c
@@ -69,6 +69,7 @@ static const struct xt_table packet_mangler = {
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
+	.priority	= NF_IP_PRI_MANGLE,
 };
 
 static unsigned int
@@ -160,8 +161,7 @@ static int __init iptable_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	mangle_ops = xt_hook_link(iptable_mangle_hook, NFPROTO_IPV4,
-	             NF_IP_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	mangle_ops = xt_hook_link(&packet_mangler, iptable_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
 		ret = PTR_ERR(mangle_ops);
 		goto cleanup_table;
@@ -176,7 +176,7 @@ static int __init iptable_mangle_init(void)
 
 static void __exit iptable_mangle_fini(void)
 {
-	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
+	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&iptable_mangle_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
index 7767253..8828ba5 100644
--- a/net/ipv4/netfilter/iptable_raw.c
+++ b/net/ipv4/netfilter/iptable_raw.c
@@ -41,6 +41,7 @@ static const struct xt_table packet_raw = {
 	.valid_hooks =  RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV4,
+	.priority = NF_IP_PRI_FIRST,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -93,8 +94,7 @@ static int __init iptable_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_link(iptable_raw_hook, NFPROTO_IPV4,
-	               NF_IP_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	rawtable_ops = xt_hook_link(&packet_raw, iptable_raw_hook);
 	if (IS_ERR(rawtable_ops)) {
 		ret = PTR_ERR(rawtable_ops);
 		goto cleanup_table;
@@ -109,7 +109,7 @@ static int __init iptable_raw_init(void)
 
 static void __exit iptable_raw_fini(void)
 {
-	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
+	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&iptable_raw_net_ops);
 }
 
diff --git a/net/ipv4/netfilter/iptable_security.c b/net/ipv4/netfilter/iptable_security.c
index 118e514..175cf0f 100644
--- a/net/ipv4/netfilter/iptable_security.c
+++ b/net/ipv4/netfilter/iptable_security.c
@@ -62,6 +62,7 @@ static const struct xt_table security_table = {
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV4,
+	.priority	= NF_IP_PRI_SECURITY,
 };
 
 static unsigned int
@@ -113,8 +114,7 @@ static int __init iptable_security_init(void)
         if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_link(iptable_security_hook, NFPROTO_IPV4,
-	             NF_IP_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	sectbl_ops = xt_hook_link(&security_table, iptable_security_hook);
 	if (IS_ERR(sectbl_ops)) {
 		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
@@ -129,7 +129,7 @@ cleanup_table:
 
 static void __exit iptable_security_fini(void)
 {
-	xt_hook_unlink(sectbl_ops, SECURITY_VALID_HOOKS);
+	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&iptable_security_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_filter.c b/net/ipv6/netfilter/ip6table_filter.c
index c01d7c2..90cf866 100644
--- a/net/ipv6/netfilter/ip6table_filter.c
+++ b/net/ipv6/netfilter/ip6table_filter.c
@@ -56,6 +56,7 @@ static const struct xt_table packet_filter = {
 	.valid_hooks	= FILTER_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
+	.priority	= NF_IP6_PRI_FILTER,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -114,8 +115,7 @@ static int __init ip6table_filter_init(void)
 		return ret;
 
 	/* Register hooks */
-	filter_ops = xt_hook_link(ip6table_filter_hook, NFPROTO_IPV6,
-	             NF_IP6_PRI_FILTER, FILTER_VALID_HOOKS, THIS_MODULE);
+	filter_ops = xt_hook_link(&packet_filter, ip6table_filter_hook);
 	if (IS_ERR(filter_ops)) {
 		ret = PTR_ERR(filter_ops);
 		goto cleanup_table;
@@ -130,7 +130,7 @@ static int __init ip6table_filter_init(void)
 
 static void __exit ip6table_filter_fini(void)
 {
-	xt_hook_unlink(filter_ops, FILTER_VALID_HOOKS);
+	xt_hook_unlink(&packet_filter, filter_ops);
 	unregister_pernet_subsys(&ip6table_filter_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_mangle.c b/net/ipv6/netfilter/ip6table_mangle.c
index 8765824..f6ca1b7 100644
--- a/net/ipv6/netfilter/ip6table_mangle.c
+++ b/net/ipv6/netfilter/ip6table_mangle.c
@@ -62,6 +62,7 @@ static const struct xt_table packet_mangler = {
 	.valid_hooks	= MANGLE_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
+	.priority	= NF_IP6_PRI_MANGLE,
 };
 
 static unsigned int
@@ -156,8 +157,7 @@ static int __init ip6table_mangle_init(void)
 		return ret;
 
 	/* Register hooks */
-	mangle_ops = xt_hook_link(ip6table_mangle_hook, NFPROTO_IPV6,
-	             NF_IP6_PRI_MANGLE, MANGLE_VALID_HOOKS, THIS_MODULE);
+	mangle_ops = xt_hook_link(&packet_mangler, ip6table_mangle_hook);
 	if (IS_ERR(mangle_ops)) {
 		ret = PTR_ERR(mangle_ops);
 		goto cleanup_table;
@@ -172,7 +172,7 @@ static int __init ip6table_mangle_init(void)
 
 static void __exit ip6table_mangle_fini(void)
 {
-	xt_hook_unlink(mangle_ops, MANGLE_VALID_HOOKS);
+	xt_hook_unlink(&packet_mangler, mangle_ops);
 	unregister_pernet_subsys(&ip6table_mangle_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_raw.c b/net/ipv6/netfilter/ip6table_raw.c
index 228a665..4ddc1ff 100644
--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -40,6 +40,7 @@ static const struct xt_table packet_raw = {
 	.valid_hooks = RAW_VALID_HOOKS,
 	.me = THIS_MODULE,
 	.af = NFPROTO_IPV6,
+	.priority = NF_IP6_PRI_FIRST,
 };
 
 /* The work comes in here from netfilter.c. */
@@ -86,8 +87,7 @@ static int __init ip6table_raw_init(void)
 		return ret;
 
 	/* Register hooks */
-	rawtable_ops = xt_hook_link(ip6table_raw_hook, NFPROTO_IPV6,
-	               NF_IP6_PRI_FIRST, RAW_VALID_HOOKS, THIS_MODULE);
+	rawtable_ops = xt_hook_link(&packet_raw, ip6table_raw_hook);
 	if (IS_ERR(rawtable_ops)) {
 		ret = PTR_ERR(rawtable_ops);
 		goto cleanup_table;
@@ -102,7 +102,7 @@ static int __init ip6table_raw_init(void)
 
 static void __exit ip6table_raw_fini(void)
 {
-	xt_hook_unlink(rawtable_ops, RAW_VALID_HOOKS);
+	xt_hook_unlink(&packet_raw, rawtable_ops);
 	unregister_pernet_subsys(&ip6table_raw_net_ops);
 }
 
diff --git a/net/ipv6/netfilter/ip6table_security.c b/net/ipv6/netfilter/ip6table_security.c
index 7928087..82f56a0 100644
--- a/net/ipv6/netfilter/ip6table_security.c
+++ b/net/ipv6/netfilter/ip6table_security.c
@@ -61,6 +61,7 @@ static const struct xt_table security_table = {
 	.valid_hooks	= SECURITY_VALID_HOOKS,
 	.me		= THIS_MODULE,
 	.af		= NFPROTO_IPV6,
+	.priority	= NF_IP6_PRI_SECURITY,
 };
 
 static unsigned int
@@ -106,8 +107,7 @@ static int __init ip6table_security_init(void)
 	if (ret < 0)
 		return ret;
 
-	sectbl_ops = xt_hook_link(ip6table_security_hook, NFPROTO_IPV6,
-	             NF_IP6_PRI_SECURITY, SECURITY_VALID_HOOKS, THIS_MODULE);
+	sectbl_ops = xt_hook_link(&security_table, ip6table_security_hook);
 	if (IS_ERR(sectbl_ops)) {
 		ret = PTR_ERR(sectbl_ops);
 		goto cleanup_table;
@@ -122,7 +122,7 @@ cleanup_table:
 
 static void __exit ip6table_security_fini(void)
 {
-	xt_hook_unlink(sectbl_ops, SECURITY_VALID_HOOKS);
+	xt_hook_unlink(&security_table, sectbl_ops);
 	unregister_pernet_subsys(&ip6table_security_net_ops);
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f7c4c39..46e0120 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1103,17 +1103,15 @@ static unsigned int xt_hookmask_bitcount(unsigned int mask)
 
 /**
  * xt_hook_link - set up hooks for a new table
+ * @table:	table with metadata needed to set up hooks
  * @fn:		Hook function
- * @nfproto:	%NFPROTO_*
- * @prio:	n'th place within @nfproto's hook list (%NF_IP_PRI_*, etc.)
- * @hook_mask:	Requested hooks
  *
  * This function will take care of creating and registering the necessary
  * Netfilter hooks for XT tables.
  */
-struct nf_hook_ops *xt_hook_link(nf_hookfn *fn, uint8_t nfproto, int prio,
-    unsigned int hook_mask, struct module *owner)
+struct nf_hook_ops *xt_hook_link(const struct xt_table *table, nf_hookfn *fn)
 {
+	unsigned int hook_mask = table->valid_hooks;
 	uint8_t i, num_hooks = xt_hookmask_bitcount(hook_mask);
 	uint8_t hooknum;
 	struct nf_hook_ops *ops;
@@ -1128,10 +1126,10 @@ struct nf_hook_ops *xt_hook_link(nf_hookfn *fn, uint8_t nfproto, int prio,
 		if (!(hook_mask & 1))
 			continue;
 		ops[i].hook     = fn;
-		ops[i].owner    = owner;
-		ops[i].pf       = nfproto;
+		ops[i].owner    = table->me;
+		ops[i].pf       = table->af;
 		ops[i].hooknum  = hooknum;
-		ops[i].priority = prio;
+		ops[i].priority = table->priority;
 		++i;
 	}
 
@@ -1150,9 +1148,9 @@ EXPORT_SYMBOL_GPL(xt_hook_link);
  * @ops:	nf_hook_ops array as returned by nf_hook_link
  * @hook_mask:	the very same mask that was passed to nf_hook_link
  */
-void xt_hook_unlink(struct nf_hook_ops *ops, unsigned int hook_mask)
+void xt_hook_unlink(const struct xt_table *table, struct nf_hook_ops *ops)
 {
-	nf_unregister_hooks(ops, xt_hookmask_bitcount(hook_mask));
+	nf_unregister_hooks(ops, xt_hookmask_bitcount(table->valid_hooks));
 	kfree(ops);
 }
 EXPORT_SYMBOL_GPL(xt_hook_unlink);
-- 
1.6.4

