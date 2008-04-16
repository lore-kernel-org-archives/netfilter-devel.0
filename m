From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 10/13] [NETFILTER]: Make Ebtables use Xtables infrastructure
Date: Wed, 16 Apr 2008 17:31:02 +0200
Message-ID: <f15cce7b97746d6cb9e7dbd288b5be62cd0bf773.1208359825.git.jengelh@computergmbh.de>
References: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38091 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761410AbYDPPbK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 11:31:10 -0400
In-Reply-To: <1208359865-3022-1-git-send-email-jengelh@computergmbh.de>
In-Reply-To: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
References: <540dfb29c6c573830cbde9bf579ddef33657ed20.1208359825.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 include/linux/netfilter_bridge/ebtables.h |   15 +-
 net/bridge/netfilter/Kconfig              |    6 +
 net/bridge/netfilter/ebt_802_3.c          |   41 ++--
 net/bridge/netfilter/ebt_among.c          |   53 +++--
 net/bridge/netfilter/ebt_arp.c            |   45 ++--
 net/bridge/netfilter/ebt_arpreply.c       |   49 +++--
 net/bridge/netfilter/ebt_dnat.c           |   47 ++--
 net/bridge/netfilter/ebt_ip.c             |   56 +++--
 net/bridge/netfilter/ebt_limit.c          |   44 ++--
 net/bridge/netfilter/ebt_log.c            |   52 +++--
 net/bridge/netfilter/ebt_mark.c           |   46 ++--
 net/bridge/netfilter/ebt_mark_m.c         |   45 ++--
 net/bridge/netfilter/ebt_nflog.c          |   46 ++--
 net/bridge/netfilter/ebt_pkttype.c        |   44 ++--
 net/bridge/netfilter/ebt_redirect.c       |   47 ++--
 net/bridge/netfilter/ebt_snat.c           |   55 +++--
 net/bridge/netfilter/ebt_stp.c            |   46 ++--
 net/bridge/netfilter/ebt_ulog.c           |   51 +++--
 net/bridge/netfilter/ebt_vlan.c           |   59 +++---
 net/bridge/netfilter/ebtables.c           |  265 ++++++++-------------
 net/netfilter/x_tables.c                  |    5 +-
 21 files changed, 571 insertions(+), 546 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index 892f5b7..28e7f4a 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -117,11 +117,14 @@ struct ebt_entries {
 #define EBT_INV_MASK (EBT_IPROTO | EBT_IIN | EBT_IOUT | EBT_ILOGICALIN \
    | EBT_ILOGICALOUT | EBT_ISOURCE | EBT_IDEST)
 
+struct xt_match;
+struct xt_target;
+
 struct ebt_entry_match
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_match *match;
+		struct xt_match *match;
 	} u;
 	/* size of data */
 	unsigned int match_size;
@@ -132,7 +135,7 @@ struct ebt_entry_watcher
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_watcher *watcher;
+		struct xt_target *watcher;
 	} u;
 	/* size of data */
 	unsigned int watcher_size;
@@ -143,7 +146,7 @@ struct ebt_entry_target
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_target *target;
+		struct xt_target *target;
 	} u;
 	/* size of data */
 	unsigned int target_size;
@@ -288,12 +291,6 @@ struct ebt_table
 		     ~(__alignof__(struct ebt_replace)-1))
 extern int ebt_register_table(struct ebt_table *table);
 extern void ebt_unregister_table(struct ebt_table *table);
-extern int ebt_register_match(struct ebt_match *match);
-extern void ebt_unregister_match(struct ebt_match *match);
-extern int ebt_register_watcher(struct ebt_watcher *watcher);
-extern void ebt_unregister_watcher(struct ebt_watcher *watcher);
-extern int ebt_register_target(struct ebt_target *target);
-extern void ebt_unregister_target(struct ebt_target *target);
 extern unsigned int ebt_do_table(unsigned int hook, struct sk_buff *skb,
    const struct net_device *in, const struct net_device *out,
    struct ebt_table *table);
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 7beeefa..4a04467 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -7,6 +7,7 @@ menu "Bridge: Netfilter Configuration"
 
 config BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
+	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
 	  framework. Say 'Y' or 'M' here if you want to do Ethernet
@@ -44,6 +45,9 @@ config BRIDGE_EBT_T_NAT
 	  See the man page for ebtables(8).
 
 	  To compile it as a module, choose M here.  If unsure, say N.
+
+if NETFILTER_XTABLES
+
 #
 # matches
 #
@@ -226,4 +230,6 @@ config BRIDGE_EBT_NFLOG
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
+endif # NETFILTER_XTABLES
+
 endmenu
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 9853402..41163b0 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -7,13 +7,16 @@
  * May 2003
  *
  */
-
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_802_3.h>
-#include <linux/module.h>
 
-static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_802_3_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_802_3_info *info = data;
 	const struct ebt_802_3_hdr *hdr = ebt_802_3_hdr(skb);
@@ -36,35 +39,37 @@ static int ebt_filter_802_3(const struct sk_buff *skb, const struct net_device *
 	return EBT_MATCH;
 }
 
-static struct ebt_match filter_802_3;
-static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_802_3_mt_check(const char *table, const void *entry,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	const struct ebt_802_3_info *info = data;
 
-	if (datalen < sizeof(struct ebt_802_3_info))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_802_3_MASK || info->invflags & ~EBT_802_3_MASK)
-		return -EINVAL;
+		return false;
 
-	return 0;
+	return true;
 }
 
-static struct ebt_match filter_802_3 __read_mostly = {
-	.name		= EBT_802_3_MATCH,
-	.match		= ebt_filter_802_3,
-	.check		= ebt_802_3_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_802_3_mt_reg __read_mostly = {
+	.name       = "802_3",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_802_3_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_802_3_info)),
+	.checkentry = ebt_802_3_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_802_3_init(void)
 {
-	return ebt_register_match(&filter_802_3);
+	return xt_register_match(&ebt_802_3_mt_reg);
 }
 
 static void __exit ebt_802_3_fini(void)
 {
-	ebt_unregister_match(&filter_802_3);
+	xt_unregister_match(&ebt_802_3_mt_reg);
 }
 
 module_init(ebt_802_3_init);
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 70b6dca..ebf905b 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -7,12 +7,13 @@
  *  August, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_among.h>
-#include <linux/ip.h>
 #include <linux/if_arp.h>
+#include <linux/ip.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_among.h>
 
 static int ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 				     const char *mac, __be32 ip)
@@ -131,10 +132,10 @@ static int get_ip_src(const struct sk_buff *skb, __be32 *addr)
 	return 0;
 }
 
-static int ebt_filter_among(const struct sk_buff *skb,
-			    const struct net_device *in,
-			    const struct net_device *out, const void *data,
-			    unsigned int datalen)
+static bool
+ebt_among_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_among_info *info = data;
 	const char *dmac, *smac;
@@ -177,9 +178,10 @@ static int ebt_filter_among(const struct sk_buff *skb,
 	return EBT_MATCH;
 }
 
-static int ebt_among_check(const char *tablename, unsigned int hookmask,
-			   const struct ebt_entry *e, void *data,
-			   unsigned int datalen)
+static bool
+ebt_among_mt_check(const char *table, const void *entry,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	const struct ebt_among_info *info = data;
 	int expected_length = sizeof(struct ebt_among_info);
@@ -191,42 +193,45 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 	expected_length += ebt_mac_wormhash_size(wh_dst);
 	expected_length += ebt_mac_wormhash_size(wh_src);
 
-	if (datalen != EBT_ALIGN(expected_length)) {
+	if (match->matchsize != EBT_ALIGN(expected_length)) {
 		printk(KERN_WARNING
 		       "ebtables: among: wrong size: %d "
 		       "against expected %d, rounded to %Zd\n",
-		       datalen, expected_length,
+		       match->matchsize, expected_length,
 		       EBT_ALIGN(expected_length));
-		return -EINVAL;
+		return false;
 	}
 	if (wh_dst && (err = ebt_mac_wormhash_check_integrity(wh_dst))) {
 		printk(KERN_WARNING
 		       "ebtables: among: dst integrity fail: %x\n", -err);
-		return -EINVAL;
+		return false;
 	}
 	if (wh_src && (err = ebt_mac_wormhash_check_integrity(wh_src))) {
 		printk(KERN_WARNING
 		       "ebtables: among: src integrity fail: %x\n", -err);
-		return -EINVAL;
+		return false;
 	}
-	return 0;
+	return true;
 }
 
-static struct ebt_match filter_among __read_mostly = {
-	.name		= EBT_AMONG_MATCH,
-	.match		= ebt_filter_among,
-	.check		= ebt_among_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_among_mt_reg __read_mostly = {
+	.name       = "among",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_among_mt,
+	.matchsize  = -1,
+	.checkentry = ebt_among_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_among_init(void)
 {
-	return ebt_register_match(&filter_among);
+	return xt_register_match(&ebt_among_mt_reg);
 }
 
 static void __exit ebt_among_fini(void)
 {
-	ebt_unregister_match(&filter_among);
+	xt_unregister_match(&ebt_among_mt_reg);
 }
 
 module_init(ebt_among_init);
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 7c535be..10302bc 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -8,15 +8,18 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_arp.h>
 #include <linux/if_arp.h>
 #include <linux/if_ether.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_arp.h>
 
-static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_arp_mt(const struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, const struct xt_match *match,
+	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_arp_info *info = data;
 	const struct arphdr *ah;
@@ -100,37 +103,41 @@ static int ebt_filter_arp(const struct sk_buff *skb, const struct net_device *in
 	return EBT_MATCH;
 }
 
-static int ebt_arp_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_arp_mt_check(const char *table, const void *entry,
+		 const struct xt_match *match, void *data,
+		 unsigned int hook_mask)
 {
 	const struct ebt_arp_info *info = data;
+	const struct ebt_entry *e = entry;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_arp_info)))
-		return -EINVAL;
 	if ((e->ethproto != htons(ETH_P_ARP) &&
 	   e->ethproto != htons(ETH_P_RARP)) ||
 	   e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & ~EBT_ARP_MASK || info->invflags & ~EBT_ARP_MASK)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_match filter_arp __read_mostly = {
-	.name		= EBT_ARP_MATCH,
-	.match		= ebt_filter_arp,
-	.check		= ebt_arp_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_arp_mt_reg __read_mostly = {
+	.name       = "arp",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_arp_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_arp_info)),
+	.checkentry = ebt_arp_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_arp_init(void)
 {
-	return ebt_register_match(&filter_arp);
+	return xt_register_match(&ebt_arp_mt_reg);
 }
 
 static void __exit ebt_arp_fini(void)
 {
-	ebt_unregister_match(&filter_arp);
+	xt_unregister_match(&ebt_arp_mt_reg);
 }
 
 module_init(ebt_arp_init);
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 0c42795..896ec15 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -8,16 +8,18 @@
  *  August, 2003
  *
  */
-
+#include <linux/if_arp.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_arpreply.h>
-#include <linux/if_arp.h>
 #include <net/arp.h>
-#include <linux/module.h>
 
-static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_arpreply_tg(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hoonum,
+		const struct xt_target *target, const void *data)
 {
 	struct ebt_arpreply_info *info = (void *)data;
 	const __be32 *siptr, *diptr;
@@ -58,42 +60,47 @@ static int ebt_target_reply(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_arpreply_tg_check(const char *tablename, const void *entry,
+		      const struct xt_target *target, void *data,
+		      unsigned int hookmask)
 {
 	const struct ebt_arpreply_info *info = data;
+	const struct ebt_entry *e = entry;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_arpreply_info)))
-		return -EINVAL;
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	if (e->ethproto != htons(ETH_P_ARP) ||
 	    e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING))
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_target reply_target __read_mostly = {
-	.name		= EBT_ARPREPLY_TARGET,
-	.target		= ebt_target_reply,
-	.check		= ebt_target_reply_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
+	.name       = "ARPREPLY",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_arpreply_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_arpreply_info)),
+	.checkentry = ebt_arpreply_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_arpreply_init(void)
 {
-	return ebt_register_target(&reply_target);
+	return xt_register_target(&ebt_arpreply_tg_reg);
 }
 
 static void __exit ebt_arpreply_fini(void)
 {
-	ebt_unregister_target(&reply_target);
+	xt_unregister_target(&ebt_arpreply_tg_reg);
 }
 
 module_init(ebt_arpreply_init);
 module_exit(ebt_arpreply_fini);
 MODULE_DESCRIPTION("Ebtables: ARP reply target");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_ARPREPLY");
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index ca64c1c..866dee6 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -7,16 +7,17 @@
  *  June, 2002
  *
  */
-
-#include <linux/netfilter.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
-#include <linux/module.h>
 #include <net/sock.h>
 
-static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_dnat_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hooknum,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_nat_info *info = data;
 
@@ -27,43 +28,47 @@ static int ebt_target_dnat(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_dnat_tg_check(const char *tablename, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_nat_info *info = data;
 
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if ( (strcmp(tablename, "nat") ||
 	   (hookmask & ~((1 << NF_BR_PRE_ROUTING) | (1 << NF_BR_LOCAL_OUT)))) &&
 	   (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
-		return -EINVAL;
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
-		return -EINVAL;
+		return false;
 	if (INVALID_TARGET)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_target dnat __read_mostly = {
-	.name		= EBT_DNAT_TARGET,
-	.target		= ebt_target_dnat,
-	.check		= ebt_target_dnat_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_dnat_tg_reg __read_mostly = {
+	.name       = "DNAT",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_dnat_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_nat_info)),
+	.checkentry = ebt_dnat_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_dnat_init(void)
 {
-	return ebt_register_target(&dnat);
+	return xt_register_target(&ebt_dnat_tg_reg);
 }
 
 static void __exit ebt_dnat_fini(void)
 {
-	ebt_unregister_target(&dnat);
+	xt_unregister_target(&ebt_dnat_tg_reg);
 }
 
 module_init(ebt_dnat_init);
 module_exit(ebt_dnat_fini);
 MODULE_DESCRIPTION("Ebtables: Destination MAC address translation");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_DNAT");
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 65caa00..5b70dbb 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -11,22 +11,24 @@
  *    Innominate Security Technologies AG <mhopf@innominate.com>
  *    September, 2002
  */
-
+#include <linux/in.h>
+#include <linux/ip.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ip.h>
-#include <linux/ip.h>
 #include <net/ip.h>
-#include <linux/in.h>
-#include <linux/module.h>
 
 struct tcpudphdr {
 	__be16 src;
 	__be16 dst;
 };
 
-static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, const void *data,
-   unsigned int datalen)
+static bool
+ebt_ip_mt(const struct sk_buff *skb, const struct net_device *in,
+	  const struct net_device *out, const struct xt_match *match,
+	  const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_ip_info *info = data;
 	const struct iphdr *ih;
@@ -78,50 +80,54 @@ static int ebt_filter_ip(const struct sk_buff *skb, const struct net_device *in,
 	return EBT_MATCH;
 }
 
-static int ebt_ip_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_ip_mt_check(const char *table, const void *entry,
+		const struct xt_match *match, void *data,
+		unsigned int hook_mask)
 {
 	const struct ebt_ip_info *info = data;
+	const struct ebt_entry *e = entry;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ip_info)))
-		return -EINVAL;
 	if (e->ethproto != htons(ETH_P_IP) ||
 	   e->invflags & EBT_IPROTO)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & ~EBT_IP_MASK || info->invflags & ~EBT_IP_MASK)
-		return -EINVAL;
+		return false;
 	if (info->bitmask & (EBT_IP_DPORT | EBT_IP_SPORT)) {
 		if (info->invflags & EBT_IP_PROTO)
-			return -EINVAL;
+			return false;
 		if (info->protocol != IPPROTO_TCP &&
 		    info->protocol != IPPROTO_UDP &&
 		    info->protocol != IPPROTO_UDPLITE &&
 		    info->protocol != IPPROTO_SCTP &&
 		    info->protocol != IPPROTO_DCCP)
-			 return -EINVAL;
+			 return false;
 	}
 	if (info->bitmask & EBT_IP_DPORT && info->dport[0] > info->dport[1])
-		return -EINVAL;
+		return false;
 	if (info->bitmask & EBT_IP_SPORT && info->sport[0] > info->sport[1])
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_match filter_ip __read_mostly = {
-	.name		= EBT_IP_MATCH,
-	.match		= ebt_filter_ip,
-	.check		= ebt_ip_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_ip_mt_reg __read_mostly = {
+	.name       = "ip",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_ip_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_ip_info)),
+	.checkentry = ebt_ip_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_ip_init(void)
 {
-	return ebt_register_match(&filter_ip);
+	return xt_register_match(&ebt_ip_mt_reg);
 }
 
 static void __exit ebt_ip_fini(void)
 {
-	ebt_unregister_match(&filter_ip);
+	xt_unregister_match(&ebt_ip_mt_reg);
 }
 
 module_init(ebt_ip_init);
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index 8cbdc01..16c8699 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -10,13 +10,12 @@
  *  September, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_limit.h>
 #include <linux/module.h>
-
 #include <linux/netdevice.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_limit.h>
 
 static DEFINE_SPINLOCK(limit_lock);
 
@@ -31,9 +30,10 @@ static DEFINE_SPINLOCK(limit_lock);
 
 #define CREDITS_PER_JIFFY POW2_BELOW32(MAX_CPJ)
 
-static int ebt_limit_match(const struct sk_buff *skb,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static bool
+ebt_limit_mt(const struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, const struct xt_match *match,
+	     const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	struct ebt_limit_info *info = (struct ebt_limit_info *)data;
 	unsigned long now = jiffies;
@@ -66,20 +66,19 @@ user2credits(u_int32_t user)
 	return (user * HZ * CREDITS_PER_JIFFY) / EBT_LIMIT_SCALE;
 }
 
-static int ebt_limit_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_limit_mt_check(const char *table, const void *entry,
+		   const struct xt_match *match, void *data,
+		   unsigned int hook_mask)
 {
 	struct ebt_limit_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_limit_info)))
-		return -EINVAL;
-
 	/* Check for overflow. */
 	if (info->burst == 0 ||
 	    user2credits(info->avg * info->burst) < user2credits(info->avg)) {
 		printk("Overflow in ebt_limit, try lower: %u/%u\n",
 			info->avg, info->burst);
-		return -EINVAL;
+		return false;
 	}
 
 	/* User avg in seconds * EBT_LIMIT_SCALE: convert to jiffies * 128. */
@@ -87,24 +86,27 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 	info->credit = user2credits(info->avg * info->burst);
 	info->credit_cap = user2credits(info->avg * info->burst);
 	info->cost = user2credits(info->avg);
-	return 0;
+	return true;
 }
 
-static struct ebt_match ebt_limit_reg __read_mostly = {
-	.name		= EBT_LIMIT_MATCH,
-	.match		= ebt_limit_match,
-	.check		= ebt_limit_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_limit_mt_reg __read_mostly = {
+	.name       = "limit",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_limit_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_limit_info)),
+	.checkentry = ebt_limit_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_limit_init(void)
 {
-	return ebt_register_match(&ebt_limit_reg);
+	return xt_register_match(&ebt_limit_mt_reg);
 }
 
 static void __exit ebt_limit_fini(void)
 {
-	ebt_unregister_match(&ebt_limit_reg);
+	xt_unregister_match(&ebt_limit_mt_reg);
 }
 
 module_init(ebt_limit_init);
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index bc19d65..74df258 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -8,32 +8,32 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_log.h>
-#include <linux/netfilter.h>
 #include <linux/module.h>
-#include <linux/ip.h>
 #include <linux/in.h>
+#include <linux/ip.h>
 #include <linux/if_arp.h>
+#include <linux/skbuff.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_log.h>
 #include <net/netfilter/nf_log.h>
 
 static DEFINE_SPINLOCK(ebt_log_lock);
 
-static int ebt_log_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_log_tg_check(const char *table, const void *entry,
+		 const struct xt_target *target, void *data,
+		 unsigned int hook_mask)
 {
 	struct ebt_log_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_log_info)))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_LOG_MASK)
-		return -EINVAL;
+		return false;
 	if (info->loglevel >= 8)
-		return -EINVAL;
+		return false;
 	info->prefix[EBT_LOG_PREFIX_SIZE - 1] = '\0';
-	return 0;
+	return true;
 }
 
 struct tcpudphdr
@@ -160,9 +160,10 @@ out:
 
 }
 
-static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, unsigned int hooknr,
+	   const struct xt_target *target, const void *data)
 {
 	const struct ebt_log_info *info = data;
 	struct nf_loginfo li;
@@ -177,14 +178,18 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 	else
 		ebt_log_packet(NFPROTO_BRIDGE, hooknr, skb, in, out, &li,
 			       info->prefix);
+
+	return EBT_CONTINUE;
 }
 
-static struct ebt_watcher log =
-{
-	.name		= EBT_LOG_WATCHER,
-	.watcher	= ebt_log,
-	.check		= ebt_log_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_log_tg_reg __read_mostly = {
+	.name       = "LOG",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_log_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_log_info)),
+	.checkentry = ebt_log_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static const struct nf_logger ebt_log_logger = {
@@ -197,7 +202,7 @@ static int __init ebt_log_init(void)
 {
 	int ret;
 
-	ret = ebt_register_watcher(&log);
+	ret = xt_register_target(&ebt_log_tg_reg);
 	if (ret < 0)
 		return ret;
 	nf_log_register(NFPROTO_BRIDGE, &ebt_log_logger);
@@ -207,10 +212,11 @@ static int __init ebt_log_init(void)
 static void __exit ebt_log_fini(void)
 {
 	nf_log_unregister(&ebt_log_logger);
-	ebt_unregister_watcher(&log);
+	xt_unregister_target(&ebt_log_tg_reg);
 }
 
 module_init(ebt_log_init);
 module_exit(ebt_log_fini);
 MODULE_DESCRIPTION("Ebtables: Packet logging to syslog");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_LOG");
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 36723f4..619a01c 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -12,14 +12,16 @@
  * I believe adding a mangle table just for marking is total overkill.
  * Marking a frame doesn't really change anything in the frame anyway.
  */
-
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_t.h>
-#include <linux/module.h>
 
-static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_mark_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hooknum,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_mark_t_info *info = data;
 	int action = info->target & -16;
@@ -36,45 +38,49 @@ static int ebt_target_mark(struct sk_buff *skb, unsigned int hooknr,
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_mark_tg_check(const char *table, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_mark_t_info *info = data;
 	int tmp;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_t_info)))
-		return -EINVAL;
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return -EINVAL;
+		return false;
 	tmp = info->target & ~EBT_VERDICT_BITS;
 	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
 	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_target mark_target __read_mostly = {
-	.name		= EBT_MARK_TARGET,
-	.target		= ebt_target_mark,
-	.check		= ebt_target_mark_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_mark_tg_reg __read_mostly = {
+	.name       = "MARK",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_mark_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_mark_t_info)),
+	.checkentry = ebt_mark_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_mark_init(void)
 {
-	return ebt_register_target(&mark_target);
+	return xt_register_target(&ebt_mark_tg_reg);
 }
 
 static void __exit ebt_mark_fini(void)
 {
-	ebt_unregister_target(&mark_target);
+	xt_unregister_target(&ebt_mark_tg_reg);
 }
 
 module_init(ebt_mark_init);
 module_exit(ebt_mark_fini);
 MODULE_DESCRIPTION("Ebtables: Packet mark modification");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_MARK");
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 9b0a454..d923c07 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -7,14 +7,16 @@
  *  July, 2002
  *
  */
-
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_mark_m.h>
-#include <linux/module.h>
 
-static int ebt_filter_mark(const struct sk_buff *skb,
-   const struct net_device *in, const struct net_device *out, const void *data,
-   unsigned int datalen)
+static bool
+ebt_mark_mt(const struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, const struct xt_match *match,
+	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_mark_m_info *info = data;
 
@@ -23,37 +25,40 @@ static int ebt_filter_mark(const struct sk_buff *skb,
 	return !(((skb->mark & info->mask) == info->mark) ^ info->invert);
 }
 
-static int ebt_mark_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_mark_mt_check(const char *table, const void *entry,
+		  const struct xt_match *match, void *data,
+		  unsigned int hook_mask)
 {
 	const struct ebt_mark_m_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_m_info)))
-		return -EINVAL;
 	if (info->bitmask & ~EBT_MARK_MASK)
-		return -EINVAL;
+		return false;
 	if ((info->bitmask & EBT_MARK_OR) && (info->bitmask & EBT_MARK_AND))
-		return -EINVAL;
+		return false;
 	if (!info->bitmask)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_match filter_mark __read_mostly = {
-	.name		= EBT_MARK_MATCH,
-	.match		= ebt_filter_mark,
-	.check		= ebt_mark_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_mark_mt_reg __read_mostly = {
+	.name       = "mark",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_mark_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_mark_m_info)),
+	.checkentry = ebt_mark_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_mark_m_init(void)
 {
-	return ebt_register_match(&filter_mark);
+	return xt_register_match(&ebt_mark_mt_reg);
 }
 
 static void __exit ebt_mark_m_fini(void)
 {
-	ebt_unregister_match(&filter_mark);
+	xt_unregister_match(&ebt_mark_mt_reg);
 }
 
 module_init(ebt_mark_m_init);
diff --git a/net/bridge/netfilter/ebt_nflog.c b/net/bridge/netfilter/ebt_nflog.c
index 8e799aa..eaa4cdb 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -14,17 +14,17 @@
 
 #include <linux/module.h>
 #include <linux/spinlock.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nflog.h>
 #include <net/netfilter/nf_log.h>
 
-static void ebt_nflog(const struct sk_buff *skb,
-		      unsigned int hooknr,
-		      const struct net_device *in,
-		      const struct net_device *out,
-		      const void *data, unsigned int datalen)
+static unsigned int
+ebt_nflog_tg(struct sk_buff *skb, const struct net_device *in,
+	     const struct net_device *out, unsigned int hooknr,
+	     const struct xt_target *target, const void *targinfo)
 {
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	const struct ebt_nflog_info *info = targinfo;
 	struct nf_loginfo li;
 
 	li.type = NF_LOG_TYPE_ULOG;
@@ -33,38 +33,40 @@ static void ebt_nflog(const struct sk_buff *skb,
 	li.u.ulog.qthreshold = info->threshold;
 
 	nf_log_packet(PF_BRIDGE, hooknr, skb, in, out, &li, "%s", info->prefix);
+	return XT_CONTINUE;
 }
 
-static int ebt_nflog_check(const char *tablename,
-			   unsigned int hookmask,
-			   const struct ebt_entry *e,
-			   void *data, unsigned int datalen)
+static bool
+ebt_nflog_tg_check(const char *tablename, const void *entry,
+		   const struct xt_target *target, void *targinfo,
+		   unsigned int hook_mask)
 {
-	struct ebt_nflog_info *info = (struct ebt_nflog_info *)data;
+	struct ebt_nflog_info *info = targinfo;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nflog_info)))
-		return -EINVAL;
 	if (info->flags & ~EBT_NFLOG_MASK)
-		return -EINVAL;
+		return false;
 	info->prefix[EBT_NFLOG_PREFIX_SIZE - 1] = '\0';
-	return 0;
+	return true;
 }
 
-static struct ebt_watcher nflog __read_mostly = {
-	.name = EBT_NFLOG_WATCHER,
-	.watcher = ebt_nflog,
-	.check = ebt_nflog_check,
-	.me = THIS_MODULE,
+static struct xt_target ebt_nflog_tg_reg __read_mostly = {
+	.name       = "NFLOG",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_nflog_tg,
+	.checkentry = ebt_nflog_tg_check,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_nflog_info)),
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_nflog_init(void)
 {
-	return ebt_register_watcher(&nflog);
+	return xt_register_target(&ebt_nflog_tg_reg);
 }
 
 static void __exit ebt_nflog_fini(void)
 {
-	ebt_unregister_watcher(&nflog);
+	xt_unregister_target(&ebt_nflog_tg_reg);
 }
 
 module_init(ebt_nflog_init);
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 676db32..2ad2972 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -7,50 +7,54 @@
  *  April, 2003
  *
  */
-
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_pkttype.h>
-#include <linux/module.h>
 
-static int ebt_filter_pkttype(const struct sk_buff *skb,
-   const struct net_device *in,
-   const struct net_device *out,
-   const void *data,
-   unsigned int datalen)
+static bool
+ebt_pkttype_mt(const struct sk_buff *skb, const struct net_device *in,
+	       const struct net_device *out, const struct xt_match *match,
+	       const void *data, int offset, unsigned int protoff,
+	       bool *hotdrop)
 {
 	const struct ebt_pkttype_info *info = data;
 
 	return (skb->pkt_type != info->pkt_type) ^ info->invert;
 }
 
-static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_pkttype_mt_check(const char *table, const void *entry,
+		     const struct xt_match *match, void *data,
+		     unsigned int hook_mask)
 {
 	const struct ebt_pkttype_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_pkttype_info)))
-		return -EINVAL;
 	if (info->invert != 0 && info->invert != 1)
-		return -EINVAL;
+		return false;
 	/* Allow any pkt_type value */
-	return 0;
+	return true;
 }
 
-static struct ebt_match filter_pkttype __read_mostly = {
-	.name		= EBT_PKTTYPE_MATCH,
-	.match		= ebt_filter_pkttype,
-	.check		= ebt_pkttype_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_pkttype_mt_reg __read_mostly = {
+	.name       = "pkttype",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_pkttype_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_pkttype_info)),
+	.checkentry = ebt_pkttype_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_pkttype_init(void)
 {
-	return ebt_register_match(&filter_pkttype);
+	return xt_register_match(&ebt_pkttype_mt_reg);
 }
 
 static void __exit ebt_pkttype_fini(void)
 {
-	ebt_unregister_match(&filter_pkttype);
+	xt_unregister_match(&ebt_pkttype_mt_reg);
 }
 
 module_init(ebt_pkttype_init);
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index b8afe85..13ac73d 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -7,17 +7,18 @@
  *  April, 2002
  *
  */
-
-#include <linux/netfilter.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_redirect.h>
-#include <linux/module.h>
 #include <net/sock.h>
 #include "../br_private.h"
 
-static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_redirect_tg(struct sk_buff *skb, const struct net_device *in,
+		const struct net_device *out, unsigned int hooknr,
+		const struct xt_target *target, const void *data)
 {
 	const struct ebt_redirect_info *info = data;
 
@@ -33,42 +34,46 @@ static int ebt_target_redirect(struct sk_buff *skb, unsigned int hooknr,
 	return info->target;
 }
 
-static int ebt_target_redirect_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_redirect_tg_check(const char *tablename, const void *entry,
+		      const struct xt_target *target, void *data,
+		      unsigned int hookmask)
 {
 	const struct ebt_redirect_info *info = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_redirect_info)))
-		return -EINVAL;
 	if (BASE_CHAIN && info->target == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if ( (strcmp(tablename, "nat") || hookmask & ~(1 << NF_BR_PRE_ROUTING)) &&
 	     (strcmp(tablename, "broute") || hookmask & ~(1 << NF_BR_BROUTING)) )
-		return -EINVAL;
+		return false;
 	if (INVALID_TARGET)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_target redirect_target __read_mostly = {
-	.name		= EBT_REDIRECT_TARGET,
-	.target		= ebt_target_redirect,
-	.check		= ebt_target_redirect_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_redirect_tg_reg __read_mostly = {
+	.name       = "REDIRECT",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_redirect_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_redirect_info)),
+	.checkentry = ebt_redirect_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_redirect_init(void)
 {
-	return ebt_register_target(&redirect_target);
+	return xt_register_target(&ebt_redirect_tg_reg);
 }
 
 static void __exit ebt_redirect_fini(void)
 {
-	ebt_unregister_target(&redirect_target);
+	xt_unregister_target(&ebt_redirect_tg_reg);
 }
 
 module_init(ebt_redirect_init);
 module_exit(ebt_redirect_fini);
 MODULE_DESCRIPTION("Ebtables: Packet redirection to localhost");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_REDIRECT");
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 5425333..275559e 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -7,18 +7,19 @@
  *  June, 2002
  *
  */
-
-#include <linux/netfilter.h>
+#include <linux/if_arp.h>
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_nat.h>
-#include <linux/module.h>
-#include <net/sock.h>
-#include <linux/if_arp.h>
 #include <net/arp.h>
+#include <net/sock.h>
 
-static int ebt_target_snat(struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_snat_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hooknum,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_nat_info *info = data;
 
@@ -43,49 +44,53 @@ out:
 	return info->target | ~EBT_VERDICT_BITS;
 }
 
-static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_snat_tg_check(const char *tablename, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hookmask)
 {
 	const struct ebt_nat_info *info = data;
 	int tmp;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_nat_info)))
-		return -EINVAL;
 	tmp = info->target | ~EBT_VERDICT_BITS;
 	if (BASE_CHAIN && tmp == EBT_RETURN)
-		return -EINVAL;
+		return false;
 	CLEAR_BASE_CHAIN_BIT;
 	if (strcmp(tablename, "nat"))
-		return -EINVAL;
+		return false;
 	if (hookmask & ~(1 << NF_BR_POST_ROUTING))
-		return -EINVAL;
+		return false;
 
 	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
-		return -EINVAL;
+		return false;
 	tmp = info->target | EBT_VERDICT_BITS;
 	if ((tmp & ~NAT_ARP_BIT) != ~NAT_ARP_BIT)
-		return -EINVAL;
-	return 0;
+		return false;
+	return true;
 }
 
-static struct ebt_target snat __read_mostly = {
-	.name		= EBT_SNAT_TARGET,
-	.target		= ebt_target_snat,
-	.check		= ebt_target_snat_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_snat_tg_reg __read_mostly = {
+	.name       = "SNAT",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_snat_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_nat_info)),
+	.checkentry = ebt_snat_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_snat_init(void)
 {
-	return ebt_register_target(&snat);
+	return xt_register_target(&ebt_snat_tg_reg);
 }
 
 static void __exit ebt_snat_fini(void)
 {
-	ebt_unregister_target(&snat);
+	xt_unregister_target(&ebt_snat_tg_reg);
 }
 
 module_init(ebt_snat_init);
 module_exit(ebt_snat_fini);
 MODULE_DESCRIPTION("Ebtables: Source MAC address translation");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ebt_SNAT");
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 40f36d3..e4b76ba 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -7,11 +7,12 @@
  *
  *  July, 2003
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_stp.h>
 #include <linux/etherdevice.h>
 #include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_stp.h>
 
 #define BPDU_TYPE_CONFIG 0
 #define BPDU_TYPE_TCN 0x80
@@ -119,8 +120,10 @@ static int ebt_filter_config(const struct ebt_stp_info *info,
 	return EBT_MATCH;
 }
 
-static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in,
-   const struct net_device *out, const void *data, unsigned int datalen)
+static bool
+ebt_stp_mt(const struct sk_buff *skb, const struct net_device *in,
+	   const struct net_device *out, const struct xt_match *match,
+	   const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_stp_info *info = data;
 	const struct stp_header *sp;
@@ -153,42 +156,45 @@ static int ebt_filter_stp(const struct sk_buff *skb, const struct net_device *in
 	return EBT_MATCH;
 }
 
-static int ebt_stp_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_stp_mt_check(const char *table, const void *entry,
+		 const struct xt_match *match, void *data,
+		 unsigned int hook_mask)
 {
 	const struct ebt_stp_info *info = data;
-	const unsigned int len = EBT_ALIGN(sizeof(struct ebt_stp_info));
 	const uint8_t bridge_ula[6] = {0x01, 0x80, 0xc2, 0x00, 0x00, 0x00};
 	const uint8_t msk[6] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	const struct ebt_entry *e = entry;
 
 	if (info->bitmask & ~EBT_STP_MASK || info->invflags & ~EBT_STP_MASK ||
 	    !(info->bitmask & EBT_STP_MASK))
-		return -EINVAL;
-	if (datalen != len)
-		return -EINVAL;
+		return false;
 	/* Make sure the match only receives stp frames */
 	if (compare_ether_addr(e->destmac, bridge_ula) ||
 	    compare_ether_addr(e->destmsk, msk) || !(e->bitmask & EBT_DESTMAC))
-		return -EINVAL;
+		return false;
 
-	return 0;
+	return true;
 }
 
-static struct ebt_match filter_stp __read_mostly = {
-	.name		= EBT_STP_MATCH,
-	.match		= ebt_filter_stp,
-	.check		= ebt_stp_check,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_stp_mt_reg __read_mostly = {
+	.name       = "stp",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_stp_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_stp_info)),
+	.checkentry = ebt_stp_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_stp_init(void)
 {
-	return ebt_register_match(&filter_stp);
+	return xt_register_match(&ebt_stp_mt_reg);
 }
 
 static void __exit ebt_stp_fini(void)
 {
-	ebt_unregister_match(&filter_stp);
+	xt_unregister_match(&ebt_stp_mt_reg);
 }
 
 module_init(ebt_stp_init);
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index 3b1678c..af1a24d 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -28,14 +28,15 @@
  *
  */
 
+#include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/socket.h>
+#include <linux/netdevice.h>
+#include <linux/netlink.h>
 #include <linux/skbuff.h>
-#include <linux/kernel.h>
+#include <linux/socket.h>
+#include <linux/spinlock.h>
 #include <linux/timer.h>
-#include <linux/netlink.h>
-#include <linux/netdevice.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_ulog.h>
 #include <net/netfilter/nf_log.h>
@@ -245,38 +246,43 @@ static void ebt_log_packet(u_int8_t pf, unsigned int hooknum,
 	ebt_ulog_packet(hooknum, skb, in, out, &loginfo, prefix);
 }
 
-static void ebt_ulog(const struct sk_buff *skb, unsigned int hooknr,
-   const struct net_device *in, const struct net_device *out,
-   const void *data, unsigned int datalen)
+static unsigned int
+ebt_ulog_tg(struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, unsigned int hooknr,
+	    const struct xt_target *target, const void *data)
 {
 	const struct ebt_ulog_info *uloginfo = data;
 
 	ebt_ulog_packet(hooknr, skb, in, out, uloginfo, NULL);
+	return EBT_CONTINUE;
 }
 
-
-static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
-   const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_ulog_tg_check(const char *table, const void *entry,
+		  const struct xt_target *target, void *data,
+		  unsigned int hook_mask)
 {
 	struct ebt_ulog_info *uloginfo = data;
 
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_ulog_info)) ||
-	    uloginfo->nlgroup > 31)
-		return -EINVAL;
+	if (uloginfo->nlgroup > 31)
+		return false;
 
 	uloginfo->prefix[EBT_ULOG_PREFIX_LEN - 1] = '\0';
 
 	if (uloginfo->qthreshold > EBT_ULOG_MAX_QLEN)
 		uloginfo->qthreshold = EBT_ULOG_MAX_QLEN;
 
-	return 0;
+	return true;
 }
 
-static struct ebt_watcher ulog __read_mostly = {
-	.name		= EBT_ULOG_WATCHER,
-	.watcher	= ebt_ulog,
-	.check		= ebt_ulog_check,
-	.me		= THIS_MODULE,
+static struct xt_target ebt_ulog_tg_reg __read_mostly = {
+	.name       = "ULOG",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_ulog_tg,
+	.targetsize = EBT_ALIGN(sizeof(struct ebt_ulog_info)),
+	.checkentry = ebt_ulog_tg_check,
+	.me         = THIS_MODULE,
 };
 
 static const struct nf_logger ebt_ulog_logger = {
@@ -306,7 +312,7 @@ static int __init ebt_ulog_init(void)
 					  THIS_MODULE);
 	if (!ebtulognl)
 		ret = -ENOMEM;
-	else if ((ret = ebt_register_watcher(&ulog)))
+	else if ((ret = xt_register_target(&ebt_ulog_tg_reg)))
 		netlink_kernel_release(ebtulognl);
 
 	if (ret == 0)
@@ -321,7 +327,7 @@ static void __exit ebt_ulog_fini(void)
 	int i;
 
 	nf_log_unregister(&ebt_ulog_logger);
-	ebt_unregister_watcher(&ulog);
+	xt_unregister_target(&ebt_ulog_tg_reg);
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
 		if (timer_pending(&ub->timer))
@@ -341,3 +347,4 @@ module_exit(ebt_ulog_fini);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
 MODULE_DESCRIPTION("Ebtables: Packet logging to netlink using ULOG");
+MODULE_ALIAS("ebt_ULOG");
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index ab60b0d..90ff4da 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -22,6 +22,8 @@
 #include <linux/if_vlan.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
+#include <linux/skbuff.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/netfilter_bridge/ebt_vlan.h>
 
@@ -39,11 +41,10 @@ MODULE_LICENSE("GPL");
 #define GET_BITMASK(_BIT_MASK_) info->bitmask & _BIT_MASK_
 #define EXIT_ON_MISMATCH(_MATCH_,_MASK_) {if (!((info->_MATCH_ == _MATCH_)^!!(info->invflags & _MASK_))) return EBT_NOMATCH;}
 
-static int
-ebt_filter_vlan(const struct sk_buff *skb,
-		const struct net_device *in,
-		const struct net_device *out,
-		const void *data, unsigned int datalen)
+static bool
+ebt_vlan_mt(const struct sk_buff *skb, const struct net_device *in,
+	    const struct net_device *out, const struct xt_match *match,
+	    const void *data, int offset, unsigned int protoff, bool *hotdrop)
 {
 	const struct ebt_vlan_info *info = data;
 	const struct vlan_hdr *fp;
@@ -86,27 +87,20 @@ ebt_filter_vlan(const struct sk_buff *skb,
 	return EBT_MATCH;
 }
 
-static int
-ebt_check_vlan(const char *tablename,
-	       unsigned int hooknr,
-	       const struct ebt_entry *e, void *data, unsigned int datalen)
+static bool
+ebt_vlan_mt_check(const char *table, const void *entry,
+		  const struct xt_match *match, void *data,
+		  unsigned int hook_mask)
 {
 	struct ebt_vlan_info *info = data;
-
-	/* Parameters buffer overflow check */
-	if (datalen != EBT_ALIGN(sizeof(struct ebt_vlan_info))) {
-		DEBUG_MSG
-		    ("passed size %d is not eq to ebt_vlan_info (%Zd)\n",
-		     datalen, sizeof(struct ebt_vlan_info));
-		return -EINVAL;
-	}
+	const struct ebt_entry *e = entry;
 
 	/* Is it 802.1Q frame checked? */
 	if (e->ethproto != htons(ETH_P_8021Q)) {
 		DEBUG_MSG
 		    ("passed entry proto %2.4X is not 802.1Q (8100)\n",
 		     (unsigned short) ntohs(e->ethproto));
-		return -EINVAL;
+		return false;
 	}
 
 	/* Check for bitmask range
@@ -114,14 +108,14 @@ ebt_check_vlan(const char *tablename,
 	if (info->bitmask & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("bitmask %2X is out of mask (%2X)\n",
 			  info->bitmask, EBT_VLAN_MASK);
-		return -EINVAL;
+		return false;
 	}
 
 	/* Check for inversion flags range */
 	if (info->invflags & ~EBT_VLAN_MASK) {
 		DEBUG_MSG("inversion flags %2X is out of mask (%2X)\n",
 			  info->invflags, EBT_VLAN_MASK);
-		return -EINVAL;
+		return false;
 	}
 
 	/* Reserved VLAN ID (VID) values
@@ -136,7 +130,7 @@ ebt_check_vlan(const char *tablename,
 				DEBUG_MSG
 				    ("id %d is out of range (1-4096)\n",
 				     info->id);
-				return -EINVAL;
+				return false;
 			}
 			/* Note: This is valid VLAN-tagged frame point.
 			 * Any value of user_priority are acceptable,
@@ -151,7 +145,7 @@ ebt_check_vlan(const char *tablename,
 		if ((unsigned char) info->prio > 7) {
 			DEBUG_MSG("prio %d is out of range (0-7)\n",
 			     info->prio);
-			return -EINVAL;
+			return false;
 		}
 	}
 	/* Check for encapsulated proto range - it is possible to be
@@ -162,18 +156,21 @@ ebt_check_vlan(const char *tablename,
 			DEBUG_MSG
 			    ("encap frame length %d is less than minimal\n",
 			     ntohs(info->encap));
-			return -EINVAL;
+			return false;
 		}
 	}
 
-	return 0;
+	return true;
 }
 
-static struct ebt_match filter_vlan __read_mostly = {
-	.name		= EBT_VLAN_MATCH,
-	.match		= ebt_filter_vlan,
-	.check		= ebt_check_vlan,
-	.me		= THIS_MODULE,
+static struct xt_match ebt_vlan_mt_reg __read_mostly = {
+	.name       = "vlan",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.match      = ebt_vlan_mt,
+	.matchsize  = EBT_ALIGN(sizeof(struct ebt_vlan_info)),
+	.checkentry = ebt_vlan_mt_check,
+	.me         = THIS_MODULE,
 };
 
 static int __init ebt_vlan_init(void)
@@ -181,12 +178,12 @@ static int __init ebt_vlan_init(void)
 	DEBUG_MSG("ebtables 802.1Q extension module v"
 		  MODULE_VERS "\n");
 	DEBUG_MSG("module debug=%d\n", !!debug);
-	return ebt_register_match(&filter_vlan);
+	return xt_register_match(&ebt_vlan_mt_reg);
 }
 
 static void __exit ebt_vlan_fini(void)
 {
-	ebt_unregister_match(&filter_vlan);
+	xt_unregister_match(&ebt_vlan_mt_reg);
 }
 
 module_init(ebt_vlan_init);
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 32afff8..347f6df 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1,4 +1,4 @@
-/*
+/*e
  *  ebtables
  *
  *  Author:
@@ -14,11 +14,11 @@
  *  as published by the Free Software Foundation; either version
  *  2 of the License, or (at your option) any later version.
  */
-
-
+#include <linux/ctype.h>
 #include <linux/kmod.h>
 #include <linux/module.h>
 #include <linux/vmalloc.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_bridge/ebtables.h>
 #include <linux/spinlock.h>
 #include <linux/mutex.h>
@@ -55,20 +55,19 @@
 
 static DEFINE_MUTEX(ebt_mutex);
 static LIST_HEAD(ebt_tables);
-static LIST_HEAD(ebt_targets);
-static LIST_HEAD(ebt_matches);
-static LIST_HEAD(ebt_watchers);
 
-static struct ebt_target ebt_standard_target =
-{ {NULL, NULL}, EBT_STANDARD_TARGET, NULL, NULL, NULL, NULL};
+static struct xt_target ebt_standard_target = {
+	.name       = EBT_STANDARD_TARGET,
+	.family     = NFPROTO_BRIDGE,
+	.targetsize = sizeof(int),
+};
 
 static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
    const struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
    const struct net_device *out)
 {
-	w->u.watcher->watcher(skb, hooknr, in, out, w->data,
-	   w->watcher_size);
-	/* watchers don't give a verdict */
+	w->u.watcher->target((struct sk_buff *)skb, in, out, hooknr,
+			     w->u.watcher, w->data);
 	return 0;
 }
 
@@ -76,8 +75,9 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out)
 {
-	return m->u.match->match(skb, in, out, m->data,
-	   m->match_size);
+	bool ignored;
+	return m->u.match->match(skb, in, out, m->u.match,
+				 m->data, 0, 0, &ignored);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
@@ -191,8 +191,8 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 		if (!t->u.target->target)
 			verdict = ((struct ebt_standard_target *)t)->verdict;
 		else
-			verdict = t->u.target->target(skb, hook,
-			   in, out, t->data, t->target_size);
+			verdict = t->u.target->target(skb, in, out, hook,
+				  t->u.target, t->data);
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
@@ -312,46 +312,35 @@ find_table_lock(const char *name, int *error, struct mutex *mutex)
 	return find_inlist_lock(&ebt_tables, name, "ebtable_", error, mutex);
 }
 
-static inline struct ebt_match *
-find_match_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_matches, name, "ebt_", error, mutex);
-}
-
-static inline struct ebt_watcher *
-find_watcher_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_watchers, name, "ebt_", error, mutex);
-}
-
-static inline struct ebt_target *
-find_target_lock(const char *name, int *error, struct mutex *mutex)
-{
-	return find_inlist_lock(&ebt_targets, name, "ebt_", error, mutex);
-}
-
 static inline int
 ebt_check_match(struct ebt_entry_match *m, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
 {
-	struct ebt_match *match;
+	struct xt_match *match;
 	size_t left = ((char *)e + e->watchers_offset) - (char *)m;
 	int ret;
 
 	if (left < sizeof(struct ebt_entry_match) ||
 	    left - sizeof(struct ebt_entry_match) < m->match_size)
 		return -EINVAL;
-	match = find_match_lock(m->u.name, &ret, &ebt_mutex);
-	if (!match)
-		return ret;
-	m->u.match = match;
-	if (!try_module_get(match->me)) {
-		mutex_unlock(&ebt_mutex);
+
+	match = try_then_request_module(xt_find_match(NFPROTO_BRIDGE,
+		m->u.name, 0), "ebt_%s", m->u.name);
+	if (IS_ERR(match))
+		return PTR_ERR(match);
+	if (match == NULL)
 		return -ENOENT;
+	m->u.match = match;
+
+	ret = xt_check_match(match, NFPROTO_BRIDGE, m->match_size,
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	if (ret < 0) {
+		module_put(match->me);
+		return ret;
 	}
-	mutex_unlock(&ebt_mutex);
-	if (match->check &&
-	   match->check(name, hookmask, e, m->data, m->match_size) != 0) {
+
+	if (match->checkentry != NULL &&
+	    !match->checkentry(name, e, match, m->data, hookmask)) {
 		BUGPRINT("match->check failed\n");
 		module_put(match->me);
 		return -EINVAL;
@@ -364,24 +353,37 @@ static inline int
 ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
 {
-	struct ebt_watcher *watcher;
+	struct xt_target *watcher;
 	size_t left = ((char *)e + e->target_offset) - (char *)w;
+	char *p;
 	int ret;
 
 	if (left < sizeof(struct ebt_entry_watcher) ||
 	   left - sizeof(struct ebt_entry_watcher) < w->watcher_size)
 		return -EINVAL;
-	watcher = find_watcher_lock(w->u.name, &ret, &ebt_mutex);
-	if (!watcher)
-		return ret;
-	w->u.watcher = watcher;
-	if (!try_module_get(watcher->me)) {
-		mutex_unlock(&ebt_mutex);
+
+	/* Transitional compat handling */
+	for (p = w->u.name; p < w->u.name + sizeof(w->u.name); ++p)
+		*p = toupper(*p);
+
+	watcher = try_then_request_module(
+		  xt_find_target(NFPROTO_BRIDGE, w->u.name, 0),
+		  "ebt_%s", w->u.name);
+	if (IS_ERR(watcher))
+		return PTR_ERR(watcher);
+	if (watcher == NULL)
 		return -ENOENT;
+	w->u.watcher = watcher;
+
+	ret = xt_check_target(watcher, NFPROTO_BRIDGE, w->watcher_size,
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	if (ret < 0) {
+		module_put(watcher->me);
+		return ret;
 	}
-	mutex_unlock(&ebt_mutex);
-	if (watcher->check &&
-	   watcher->check(name, hookmask, e, w->data, w->watcher_size) != 0) {
+
+	if (watcher->checkentry != NULL &&
+	    !watcher->checkentry(name, e, watcher, w->data, hookmask)) {
 		BUGPRINT("watcher->check failed\n");
 		module_put(watcher->me);
 		return -EINVAL;
@@ -561,7 +563,7 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (m->u.match->destroy)
-		m->u.match->destroy(m->data, m->match_size);
+		m->u.match->destroy(m->u.match, m->data);
 	module_put(m->u.match->me);
 
 	return 0;
@@ -573,7 +575,7 @@ ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (w->u.watcher->destroy)
-		w->u.watcher->destroy(w->data, w->watcher_size);
+		w->u.watcher->destroy(w->u.watcher, w->data);
 	module_put(w->u.watcher->me);
 
 	return 0;
@@ -593,7 +595,7 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	if (t->u.target->destroy)
-		t->u.target->destroy(t->data, t->target_size);
+		t->u.target->destroy(t->u.target, t->data);
 	module_put(t->u.target->me);
 
 	return 0;
@@ -605,9 +607,10 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
    struct ebt_cl_stack *cl_s, unsigned int udc_cnt)
 {
 	struct ebt_entry_target *t;
-	struct ebt_target *target;
+	struct xt_target *target;
 	unsigned int i, j, hook = 0, hookmask = 0;
 	size_t gap;
+	char *p;
 	int ret;
 
 	/* don't mess with the struct ebt_entries */
@@ -658,38 +661,50 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	gap = e->next_offset - e->target_offset;
-	target = find_target_lock(t->u.name, &ret, &ebt_mutex);
-	if (!target)
+
+	/* Transitional compat handling */
+	if (strcmp(t->u.name, "standard") != 0)
+		for (p = t->u.name; p < t->u.name + sizeof(t->u.name); ++p)
+			*p = toupper(*p);
+
+	target = try_then_request_module(
+		 xt_find_target(NFPROTO_BRIDGE, t->u.name, 0),
+		 "ebt_%s", t->u.name);
+	if (IS_ERR(target)) {
+		ret = PTR_ERR(target);
 		goto cleanup_watchers;
-	if (!try_module_get(target->me)) {
-		mutex_unlock(&ebt_mutex);
+	}
+	if (target == NULL) {
 		ret = -ENOENT;
 		goto cleanup_watchers;
 	}
-	mutex_unlock(&ebt_mutex);
 
 	t->u.target = target;
 	if (t->u.target == &ebt_standard_target) {
 		if (gap < sizeof(struct ebt_standard_target)) {
 			BUGPRINT("Standard target size too big\n");
 			ret = -EFAULT;
-			goto cleanup_watchers;
+			goto put;
 		}
 		if (((struct ebt_standard_target *)t)->verdict <
 		   -NUM_STANDARD_TARGETS) {
 			BUGPRINT("Invalid standard target\n");
 			ret = -EFAULT;
-			goto cleanup_watchers;
+			goto put;
 		}
-	} else if (t->target_size > gap - sizeof(struct ebt_entry_target) ||
-	   (t->u.target->check &&
-	   t->u.target->check(name, hookmask, e, t->data, t->target_size) != 0)){
-		module_put(t->u.target->me);
+	} else if (t->target_size > gap - sizeof(struct ebt_entry_target)) {
 		ret = -EFAULT;
-		goto cleanup_watchers;
+		goto put;
+	} else {
+		ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
+		      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+		if (ret < 0)
+			goto put;
 	}
 	(*cnt)++;
 	return 0;
+ put:
+	module_put(target->me);
 cleanup_watchers:
 	EBT_WATCHER_ITERATE(e, ebt_cleanup_watcher, &j);
 cleanup_matches:
@@ -1068,87 +1083,6 @@ free_newinfo:
 	return ret;
 }
 
-int ebt_register_target(struct ebt_target *target)
-{
-	struct ebt_target *t;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(t, &ebt_targets, list) {
-		if (strcmp(t->name, target->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&target->list, &ebt_targets);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_target(struct ebt_target *target)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&target->list);
-	mutex_unlock(&ebt_mutex);
-}
-
-int ebt_register_match(struct ebt_match *match)
-{
-	struct ebt_match *m;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(m, &ebt_matches, list) {
-		if (strcmp(m->name, match->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&match->list, &ebt_matches);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_match(struct ebt_match *match)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&match->list);
-	mutex_unlock(&ebt_mutex);
-}
-
-int ebt_register_watcher(struct ebt_watcher *watcher)
-{
-	struct ebt_watcher *w;
-	int ret;
-
-	ret = mutex_lock_interruptible(&ebt_mutex);
-	if (ret != 0)
-		return ret;
-	list_for_each_entry(w, &ebt_watchers, list) {
-		if (strcmp(w->name, watcher->name) == 0) {
-			mutex_unlock(&ebt_mutex);
-			return -EEXIST;
-		}
-	}
-	list_add(&watcher->list, &ebt_watchers);
-	mutex_unlock(&ebt_mutex);
-
-	return 0;
-}
-
-void ebt_unregister_watcher(struct ebt_watcher *watcher)
-{
-	mutex_lock(&ebt_mutex);
-	list_del(&watcher->list);
-	mutex_unlock(&ebt_mutex);
-}
-
 int ebt_register_table(struct ebt_table *table)
 {
 	struct ebt_table_info *newinfo;
@@ -1327,8 +1261,13 @@ static inline int ebt_make_matchname(struct ebt_entry_match *m,
 static inline int ebt_make_watchername(struct ebt_entry_watcher *w,
    char *base, char __user *ubase)
 {
+	char tmp[sizeof(w->u.watcher->name)];
 	char __user *hlp = ubase + ((char *)w - base);
-	if (copy_to_user(hlp , w->u.watcher->name, EBT_FUNCTION_MAXNAMELEN))
+	unsigned int i;
+
+	for (i = 0; i < sizeof(tmp); ++i)
+		tmp[i] = tolower(w->u.watcher->name[i]);
+	if (copy_to_user(hlp, tmp, EBT_FUNCTION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1338,6 +1277,8 @@ static inline int ebt_make_names(struct ebt_entry *e, char *base, char __user *u
 	int ret;
 	char __user *hlp;
 	struct ebt_entry_target *t;
+	char tmp[sizeof(t->u.target->name)];
+	unsigned int i;
 
 	if (e->bitmask == 0)
 		return 0;
@@ -1351,7 +1292,9 @@ static inline int ebt_make_names(struct ebt_entry *e, char *base, char __user *u
 	ret = EBT_WATCHER_ITERATE(e, ebt_make_watchername, base, ubase);
 	if (ret != 0)
 		return ret;
-	if (copy_to_user(hlp, t->u.target->name, EBT_FUNCTION_MAXNAMELEN))
+	for (i = 0; i < sizeof(tmp); ++i)
+		tmp[i] = tolower(t->u.target->name[i]);
+	if (copy_to_user(hlp, tmp, EBT_FUNCTION_MAXNAMELEN))
 		return -EFAULT;
 	return 0;
 }
@@ -1518,11 +1461,14 @@ static int __init ebtables_init(void)
 {
 	int ret;
 
-	mutex_lock(&ebt_mutex);
-	list_add(&ebt_standard_target.list, &ebt_targets);
-	mutex_unlock(&ebt_mutex);
-	if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
+	ret = xt_register_target(&ebt_standard_target);
+	if (ret < 0)
+		return ret;
+	ret = nf_register_sockopt(&ebt_sockopts);
+	if (ret < 0) {
+		xt_unregister_target(&ebt_standard_target);
 		return ret;
+	}
 
 	printk(KERN_INFO "Ebtables v2.0 registered\n");
 	return 0;
@@ -1531,17 +1477,12 @@ static int __init ebtables_init(void)
 static void __exit ebtables_fini(void)
 {
 	nf_unregister_sockopt(&ebt_sockopts);
+	xt_unregister_target(&ebt_standard_target);
 	printk(KERN_INFO "Ebtables v2.0 unregistered\n");
 }
 
 EXPORT_SYMBOL(ebt_register_table);
 EXPORT_SYMBOL(ebt_unregister_table);
-EXPORT_SYMBOL(ebt_register_match);
-EXPORT_SYMBOL(ebt_unregister_match);
-EXPORT_SYMBOL(ebt_register_watcher);
-EXPORT_SYMBOL(ebt_unregister_watcher);
-EXPORT_SYMBOL(ebt_register_target);
-EXPORT_SYMBOL(ebt_unregister_target);
 EXPORT_SYMBOL(ebt_do_table);
 module_init(ebtables_init);
 module_exit(ebtables_fini);
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 5053e19..0173fb4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -30,7 +30,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("[ip,ip6,arp]_tables backend module");
+MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
@@ -326,7 +326,8 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 		   unsigned int size, const char *table, unsigned int hook_mask,
 		   unsigned short proto, int inv_proto)
 {
-	if (XT_ALIGN(match->matchsize) != size) {
+	/* testing for -1 is temporary until ebtables is fixed up */
+	if (match->matchsize != -1 && XT_ALIGN(match->matchsize) != size) {
 		printk("%s_tables: %s match: invalid size %Zu != %u\n",
 		       xt_prefix[family], match->name,
 		       XT_ALIGN(match->matchsize), size);
-- 
1.5.5

