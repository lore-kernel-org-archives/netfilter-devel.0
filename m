From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/23] netfilter: move Ebtables to use Xtables
Date: Mon,  6 Oct 2008 08:15:04 -0400
Message-ID: <0a71cdb22ae4ae9ad9c49cab82cc41ccdd5653a1.1223294924.git.jengelh@medozas.de>
References: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57085 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbYJFMPa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:15:30 -0400
In-Reply-To: <1223295326-10890-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter_bridge/ebtables.h |    6 +-
 net/bridge/netfilter/Kconfig              |    1 +
 net/bridge/netfilter/ebt_802_3.c          |    8 +-
 net/bridge/netfilter/ebt_among.c          |   14 +-
 net/bridge/netfilter/ebt_arp.c            |    8 +-
 net/bridge/netfilter/ebt_arpreply.c       |    8 +-
 net/bridge/netfilter/ebt_dnat.c           |    8 +-
 net/bridge/netfilter/ebt_ip.c             |    8 +-
 net/bridge/netfilter/ebt_ip6.c            |    9 +-
 net/bridge/netfilter/ebt_limit.c          |    8 +-
 net/bridge/netfilter/ebt_log.c            |    9 +-
 net/bridge/netfilter/ebt_mark.c           |    8 +-
 net/bridge/netfilter/ebt_mark_m.c         |    8 +-
 net/bridge/netfilter/ebt_nflog.c          |   16 ++--
 net/bridge/netfilter/ebt_pkttype.c        |    8 +-
 net/bridge/netfilter/ebt_redirect.c       |    8 +-
 net/bridge/netfilter/ebt_snat.c           |    8 +-
 net/bridge/netfilter/ebt_stp.c            |    8 +-
 net/bridge/netfilter/ebt_ulog.c           |   10 +-
 net/bridge/netfilter/ebt_vlan.c           |    8 +-
 net/bridge/netfilter/ebtables.c           |  173 +++++++++++------------------
 net/netfilter/x_tables.c                  |    9 +-
 22 files changed, 158 insertions(+), 193 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebtables.h b/include/linux/netfilter_bridge/ebtables.h
index f20a57d..d3f9243 100644
--- a/include/linux/netfilter_bridge/ebtables.h
+++ b/include/linux/netfilter_bridge/ebtables.h
@@ -124,7 +124,7 @@ struct ebt_entry_match
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_match *match;
+		struct xt_match *match;
 	} u;
 	/* size of data */
 	unsigned int match_size;
@@ -135,7 +135,7 @@ struct ebt_entry_watcher
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_watcher *watcher;
+		struct xt_target *watcher;
 	} u;
 	/* size of data */
 	unsigned int watcher_size;
@@ -146,7 +146,7 @@ struct ebt_entry_target
 {
 	union {
 		char name[EBT_FUNCTION_MAXNAMELEN];
-		struct ebt_target *target;
+		struct xt_target *target;
 	} u;
 	/* size of data */
 	unsigned int target_size;
diff --git a/net/bridge/netfilter/Kconfig b/net/bridge/netfilter/Kconfig
index 9094797..e7c197f 100644
--- a/net/bridge/netfilter/Kconfig
+++ b/net/bridge/netfilter/Kconfig
@@ -7,6 +7,7 @@ menu "Bridge: Netfilter Configuration"
 
 config BRIDGE_NF_EBTABLES
 	tristate "Ethernet Bridge tables (ebtables) support"
+	select NETFILTER_XTABLES
 	help
 	  ebtables is a general, extensible frame/packet identification
 	  framework. Say 'Y' or 'M' here if you want to do Ethernet
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 6f1a69c..6fc2a59 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -51,8 +51,8 @@ ebt_802_3_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_802_3 __read_mostly = {
-	.name		= EBT_802_3_MATCH,
+static struct xt_match ebt_802_3_mt_reg __read_mostly = {
+	.name		= "802_3",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_802_3_mt,
@@ -63,12 +63,12 @@ static struct ebt_match filter_802_3 __read_mostly = {
 
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
index 84a306f..084559e 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -7,12 +7,12 @@
  *  August, 2003
  *
  */
-
-#include <linux/netfilter_bridge/ebtables.h>
-#include <linux/netfilter_bridge/ebt_among.h>
 #include <linux/ip.h>
 #include <linux/if_arp.h>
 #include <linux/module.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
+#include <linux/netfilter_bridge/ebt_among.h>
 
 static bool ebt_mac_wormhash_contains(const struct ebt_mac_wormhash *wh,
 				      const char *mac, __be32 ip)
@@ -211,8 +211,8 @@ ebt_among_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_among __read_mostly = {
-	.name		= EBT_AMONG_MATCH,
+static struct xt_match ebt_among_mt_reg __read_mostly = {
+	.name		= "among",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_among_mt,
@@ -223,12 +223,12 @@ static struct ebt_match filter_among __read_mostly = {
 
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
index 6e7cd2f..a073dff 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -119,8 +119,8 @@ ebt_arp_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_arp __read_mostly = {
-	.name		= EBT_ARP_MATCH,
+static struct xt_match ebt_arp_mt_reg __read_mostly = {
+	.name		= "arp",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_arp_mt,
@@ -131,12 +131,12 @@ static struct ebt_match filter_arp __read_mostly = {
 
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
index 6f2f658..8071b64 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -78,8 +78,8 @@ ebt_arpreply_tg_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct ebt_target reply_target __read_mostly = {
-	.name		= EBT_ARPREPLY_TARGET,
+static struct xt_target ebt_arpreply_tg_reg __read_mostly = {
+	.name		= "arpreply",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_arpreply_tg,
@@ -90,12 +90,12 @@ static struct ebt_target reply_target __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index b7cc013..d2211c4 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -47,8 +47,8 @@ ebt_dnat_tg_check(const char *tablename, const void *entry,
 	return true;
 }
 
-static struct ebt_target dnat __read_mostly = {
-	.name		= EBT_DNAT_TARGET,
+static struct xt_target ebt_dnat_tg_reg __read_mostly = {
+	.name		= "dnat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_dnat_tg,
@@ -59,12 +59,12 @@ static struct ebt_target dnat __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index e7f3b17..b42c7ce 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -109,8 +109,8 @@ ebt_ip_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_ip __read_mostly = {
-	.name		= EBT_IP_MATCH,
+static struct xt_match ebt_ip_mt_reg __read_mostly = {
+	.name		= "ip",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_ip_mt,
@@ -121,12 +121,12 @@ static struct ebt_match filter_ip __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_ip6.c b/net/bridge/netfilter/ebt_ip6.c
index 807685d..317e624 100644
--- a/net/bridge/netfilter/ebt_ip6.c
+++ b/net/bridge/netfilter/ebt_ip6.c
@@ -121,9 +121,8 @@ ebt_ip6_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_ip6 =
-{
-	.name		= EBT_IP6_MATCH,
+static struct xt_match ebt_ip6_mt_reg __read_mostly = {
+	.name		= "ip6",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_ip6_mt,
@@ -134,12 +133,12 @@ static struct ebt_match filter_ip6 =
 
 static int __init ebt_ip6_init(void)
 {
-	return ebt_register_match(&filter_ip6);
+	return xt_register_match(&ebt_ip6_mt_reg);
 }
 
 static void __exit ebt_ip6_fini(void)
 {
-	ebt_unregister_match(&filter_ip6);
+	xt_unregister_match(&ebt_ip6_mt_reg);
 }
 
 module_init(ebt_ip6_init);
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index d337273..43d9a50 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -89,8 +89,8 @@ ebt_limit_mt_check(const char *table, const void *e,
 	return true;
 }
 
-static struct ebt_match ebt_limit_reg __read_mostly = {
-	.name		= EBT_LIMIT_MATCH,
+static struct xt_match ebt_limit_mt_reg __read_mostly = {
+	.name		= "limit",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_limit_mt,
@@ -101,12 +101,12 @@ static struct ebt_match ebt_limit_reg __read_mostly = {
 
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
index 424dfdf..b40f9ed 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -215,9 +215,8 @@ ebt_log_tg(struct sk_buff *skb, const struct net_device *in,
 	return EBT_CONTINUE;
 }
 
-static struct ebt_watcher log =
-{
-	.name		= EBT_LOG_WATCHER,
+static struct xt_target ebt_log_tg_reg __read_mostly = {
+	.name		= "log",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_log_tg,
@@ -236,7 +235,7 @@ static int __init ebt_log_init(void)
 {
 	int ret;
 
-	ret = ebt_register_watcher(&log);
+	ret = xt_register_target(&ebt_log_tg_reg);
 	if (ret < 0)
 		return ret;
 	nf_log_register(NFPROTO_BRIDGE, &ebt_log_logger);
@@ -246,7 +245,7 @@ static int __init ebt_log_init(void)
 static void __exit ebt_log_fini(void)
 {
 	nf_log_unregister(&ebt_log_logger);
-	ebt_unregister_watcher(&log);
+	xt_unregister_target(&ebt_log_tg_reg);
 }
 
 module_init(ebt_log_init);
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 92c6727..dff19fc 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -59,8 +59,8 @@ ebt_mark_tg_check(const char *table, const void *e,
 	return true;
 }
 
-static struct ebt_target mark_target __read_mostly = {
-	.name		= EBT_MARK_TARGET,
+static struct xt_target ebt_mark_tg_reg __read_mostly = {
+	.name		= "mark",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_mark_tg,
@@ -71,12 +71,12 @@ static struct ebt_target mark_target __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index db64a0d..aa6781c 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -40,8 +40,8 @@ ebt_mark_mt_check(const char *table, const void *e,
 	return true;
 }
 
-static struct ebt_match filter_mark __read_mostly = {
-	.name		= EBT_MARK_MATCH,
+static struct xt_match ebt_mark_mt_reg __read_mostly = {
+	.name		= "mark_m",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_mark_mt,
@@ -52,12 +52,12 @@ static struct ebt_match filter_mark __read_mostly = {
 
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
index b415f88..917ac36 100644
--- a/net/bridge/netfilter/ebt_nflog.c
+++ b/net/bridge/netfilter/ebt_nflog.c
@@ -49,24 +49,24 @@ ebt_nflog_tg_check(const char *table, const void *e,
 	return true;
 }
 
-static struct ebt_watcher nflog __read_mostly = {
-	.name = EBT_NFLOG_WATCHER,
-	.revision = 0,
-	.family = NFPROTO_BRIDGE,
-	.target = ebt_nflog_tg,
+static struct xt_target ebt_nflog_tg_reg __read_mostly = {
+	.name       = "nflog",
+	.revision   = 0,
+	.family     = NFPROTO_BRIDGE,
+	.target     = ebt_nflog_tg,
 	.checkentry = ebt_nflog_tg_check,
 	.targetsize = XT_ALIGN(sizeof(struct ebt_nflog_info)),
-	.me = THIS_MODULE,
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
index 0639345..1c04ce5 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -36,8 +36,8 @@ ebt_pkttype_mt_check(const char *table, const void *e,
 	return true;
 }
 
-static struct ebt_match filter_pkttype __read_mostly = {
-	.name		= EBT_PKTTYPE_MATCH,
+static struct xt_match ebt_pkttype_mt_reg __read_mostly = {
+	.name		= "pkttype",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_pkttype_mt,
@@ -48,12 +48,12 @@ static struct ebt_match filter_pkttype __read_mostly = {
 
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
index e9540cf..1b7684f 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -52,8 +52,8 @@ ebt_redirect_tg_check(const char *tablename, const void *e,
 	return true;
 }
 
-static struct ebt_target redirect_target __read_mostly = {
-	.name		= EBT_REDIRECT_TARGET,
+static struct xt_target ebt_redirect_tg_reg __read_mostly = {
+	.name		= "redirect",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_redirect_tg,
@@ -64,12 +64,12 @@ static struct ebt_target redirect_target __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 363d005..c90217a 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -69,8 +69,8 @@ ebt_snat_tg_check(const char *tablename, const void *e,
 	return true;
 }
 
-static struct ebt_target snat __read_mostly = {
-	.name		= EBT_SNAT_TARGET,
+static struct xt_target ebt_snat_tg_reg __read_mostly = {
+	.name		= "snat",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_snat_tg,
@@ -81,12 +81,12 @@ static struct ebt_target snat __read_mostly = {
 
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
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 7576d1d..28bb48b 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -176,8 +176,8 @@ ebt_stp_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_stp __read_mostly = {
-	.name		= EBT_STP_MATCH,
+static struct xt_match ebt_stp_mt_reg __read_mostly = {
+	.name		= "stp",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_stp_mt,
@@ -188,12 +188,12 @@ static struct ebt_match filter_stp __read_mostly = {
 
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
index 77ff9c4..25ca646 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -275,8 +275,8 @@ ebt_ulog_tg_check(const char *table, const void *entry,
 	return 0;
 }
 
-static struct ebt_watcher ulog __read_mostly = {
-	.name		= EBT_ULOG_WATCHER,
+static struct xt_target ebt_ulog_tg_reg __read_mostly = {
+	.name		= "ulog",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.target		= ebt_ulog_tg,
@@ -286,7 +286,7 @@ static struct ebt_watcher ulog __read_mostly = {
 };
 
 static const struct nf_logger ebt_ulog_logger = {
-	.name		= EBT_ULOG_WATCHER,
+	.name		= "ulog",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
 };
@@ -315,7 +315,7 @@ static int __init ebt_ulog_init(void)
 		printk(KERN_WARNING KBUILD_MODNAME ": out of memory trying to "
 		       "call netlink_kernel_create\n");
 		ret = false;
-	} else if (ebt_register_watcher(&ulog) != 0) {
+	} else if (xt_register_target(&ebt_ulog_tg_reg) != 0) {
 		netlink_kernel_release(ebtulognl);
 	}
 
@@ -331,7 +331,7 @@ static void __exit ebt_ulog_fini(void)
 	int i;
 
 	nf_log_unregister(&ebt_ulog_logger);
-	ebt_unregister_watcher(&ulog);
+	xt_unregister_target(&ebt_ulog_tg_reg);
 	for (i = 0; i < EBT_ULOG_MAXNLGROUPS; i++) {
 		ub = &ulog_buffers[i];
 		if (timer_pending(&ub->timer))
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 3af688b..5addef6 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -162,8 +162,8 @@ ebt_vlan_mt_check(const char *table, const void *entry,
 	return true;
 }
 
-static struct ebt_match filter_vlan __read_mostly = {
-	.name		= EBT_VLAN_MATCH,
+static struct xt_match ebt_vlan_mt_reg __read_mostly = {
+	.name		= "vlan",
 	.revision	= 0,
 	.family		= NFPROTO_BRIDGE,
 	.match		= ebt_vlan_mt,
@@ -177,12 +177,12 @@ static int __init ebt_vlan_init(void)
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
index 942739d..d12ad58 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -60,17 +60,18 @@ static LIST_HEAD(ebt_targets);
 static LIST_HEAD(ebt_matches);
 static LIST_HEAD(ebt_watchers);
 
-static struct ebt_target ebt_standard_target = {
+static struct xt_target ebt_standard_target = {
 	.name       = "standard",
 	.revision   = 0,
 	.family     = NFPROTO_BRIDGE,
+	.targetsize = sizeof(int),
 };
 
 static inline int ebt_do_watcher (struct ebt_entry_watcher *w,
    struct sk_buff *skb, unsigned int hooknr, const struct net_device *in,
    const struct net_device *out)
 {
-	w->u.watcher->target(skb, in, out, hooknr, NULL, w->data);
+	w->u.watcher->target(skb, in, out, hooknr, w->u.watcher, w->data);
 	/* watchers don't give a verdict */
 	return 0;
 }
@@ -79,7 +80,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
    const struct sk_buff *skb, const struct net_device *in,
    const struct net_device *out)
 {
-	return m->u.match->match(skb, in, out, NULL, m->data, 0, 0, NULL);
+	return m->u.match->match(skb, in, out, m->u.match, m->data, 0, 0, NULL);
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)
@@ -194,7 +195,7 @@ unsigned int ebt_do_table (unsigned int hook, struct sk_buff *skb,
 			verdict = ((struct ebt_standard_target *)t)->verdict;
 		else
 			verdict = t->u.target->target(skb, in, out, hook,
-				  NULL, t->data);
+				  t->u.target, t->data);
 		if (verdict == EBT_ACCEPT) {
 			read_unlock_bh(&table->lock);
 			return NF_ACCEPT;
@@ -336,104 +337,73 @@ static inline int
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
-	}
-	mutex_unlock(&ebt_mutex);
-	if (match->family != NFPROTO_BRIDGE) {
-		printk(KERN_WARNING "ebtables: %s match: not for ebtables?\n",
-		       match->name);
-		goto out;
-	}
-	if (match->revision != 0) {
-		printk(KERN_WARNING "ebtables: %s match: ebtables is not "
-		       "supporting revisions at this time\n",
-		       match->name);
-		goto out;
-	}
-	if (XT_ALIGN(match->matchsize) != m->match_size &&
-	    match->matchsize != -1) {
-		/*
-		 * ebt_among is exempt from centralized matchsize checking
-		 * because it uses a dynamic-size data set.
-		 */
-		printk(KERN_WARNING "ebtables: %s match: "
-		       "invalid size %Zu != %u\n",
-		       match->name, XT_ALIGN(match->matchsize), m->match_size);
-		goto out;
-	}
-	if (match->checkentry &&
+	m->u.match = match;
+
+	ret = xt_check_match(match, NFPROTO_BRIDGE, m->match_size,
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	if (ret < 0) {
+		module_put(match->me);
+		return ret;
+	} else if (match->checkentry != NULL &&
 	    !match->checkentry(name, e, NULL, m->data, hookmask)) {
+		module_put(match->me);
 		BUGPRINT("match->check failed\n");
-		goto out;
+		return -EINVAL;
 	}
+
 	(*cnt)++;
 	return 0;
- out:
-	module_put(match->me);
-	return -EINVAL;
 }
 
 static inline int
 ebt_check_watcher(struct ebt_entry_watcher *w, struct ebt_entry *e,
    const char *name, unsigned int hookmask, unsigned int *cnt)
 {
-	struct ebt_watcher *watcher;
+	struct xt_target *watcher;
 	size_t left = ((char *)e + e->target_offset) - (char *)w;
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
+	watcher = try_then_request_module(
+		  xt_find_target(NFPROTO_BRIDGE, w->u.name, 0),
+		  "ebt_%s", w->u.name);
+	if (IS_ERR(watcher))
+		return PTR_ERR(watcher);
+	if (watcher == NULL)
 		return -ENOENT;
-	}
-	mutex_unlock(&ebt_mutex);
-	if (watcher->family != NFPROTO_BRIDGE) {
-		printk(KERN_WARNING "ebtables: %s watcher: not for ebtables?\n",
-		       watcher->name);
-		goto out;
-	}
-	if (watcher->revision != 0) {
-		printk(KERN_WARNING "ebtables: %s watcher: ebtables is not "
-		       "supporting revisions at this time\n",
-		       watcher->name);
-		goto out;
-	}
-	if (XT_ALIGN(watcher->targetsize) != w->watcher_size) {
-		printk(KERN_WARNING "ebtables: %s watcher: "
-		       "invalid size %Zu != %u\n",
-		       watcher->name, XT_ALIGN(watcher->targetsize),
-		       w->watcher_size);
-		goto out;
-	}
-	if (watcher->checkentry &&
+	w->u.watcher = watcher;
+
+	ret = xt_check_target(watcher, NFPROTO_BRIDGE, w->watcher_size,
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	if (ret < 0) {
+		module_put(watcher->me);
+		return ret;
+	} else if (watcher->checkentry != NULL &&
 	    !watcher->checkentry(name, e, NULL, w->data, hookmask)) {
+		module_put(watcher->me);
 		BUGPRINT("watcher->check failed\n");
-		goto out;
+		return -EINVAL;
 	}
+
 	(*cnt)++;
 	return 0;
- out:
-	module_put(watcher->me);
-	return -EINVAL;
 }
 
 static int ebt_verify_pointers(struct ebt_replace *repl,
@@ -607,7 +577,7 @@ ebt_cleanup_match(struct ebt_entry_match *m, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (m->u.match->destroy)
-		m->u.match->destroy(NULL, m->data);
+		m->u.match->destroy(m->u.match, m->data);
 	module_put(m->u.match->me);
 
 	return 0;
@@ -619,7 +589,7 @@ ebt_cleanup_watcher(struct ebt_entry_watcher *w, unsigned int *i)
 	if (i && (*i)-- == 0)
 		return 1;
 	if (w->u.watcher->destroy)
-		w->u.watcher->destroy(NULL, w->data);
+		w->u.watcher->destroy(w->u.watcher, w->data);
 	module_put(w->u.watcher->me);
 
 	return 0;
@@ -639,7 +609,7 @@ ebt_cleanup_entry(struct ebt_entry *e, unsigned int *cnt)
 	EBT_MATCH_ITERATE(e, ebt_cleanup_match, NULL);
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	if (t->u.target->destroy)
-		t->u.target->destroy(NULL, t->data);
+		t->u.target->destroy(t->u.target, t->data);
 	module_put(t->u.target->me);
 
 	return 0;
@@ -651,7 +621,7 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
    struct ebt_cl_stack *cl_s, unsigned int udc_cnt)
 {
 	struct ebt_entry_target *t;
-	struct ebt_target *target;
+	struct xt_target *target;
 	unsigned int i, j, hook = 0, hookmask = 0;
 	size_t gap;
 	int ret;
@@ -704,27 +674,15 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		goto cleanup_watchers;
 	t = (struct ebt_entry_target *)(((char *)e) + e->target_offset);
 	gap = e->next_offset - e->target_offset;
-	target = find_target_lock(t->u.name, &ret, &ebt_mutex);
-	if (!target)
-		goto cleanup_watchers;
-	if (!try_module_get(target->me)) {
-		mutex_unlock(&ebt_mutex);
-		ret = -ENOENT;
-		goto cleanup_watchers;
-	}
-	mutex_unlock(&ebt_mutex);
 
-	if (target->family != NFPROTO_BRIDGE) {
-		printk(KERN_WARNING "ebtables: %s target: not for ebtables?\n",
-		       target->name);
-		ret = -EINVAL;
+	target = try_then_request_module(
+		 xt_find_target(NFPROTO_BRIDGE, t->u.name, 0),
+		 "ebt_%s", t->u.name);
+	if (IS_ERR(target)) {
+		ret = PTR_ERR(target);
 		goto cleanup_watchers;
-	}
-	if (target->revision != 0) {
-		printk(KERN_WARNING "ebtables: %s target: ebtables is not "
-		       "supporting revisions at this time\n",
-		       target->name);
-		ret = -EINVAL;
+	} else if (target == NULL) {
+		ret = -ENOENT;
 		goto cleanup_watchers;
 	}
 
@@ -745,13 +703,12 @@ ebt_check_entry(struct ebt_entry *e, struct ebt_table_info *newinfo,
 		module_put(t->u.target->me);
 		ret = -EFAULT;
 		goto cleanup_watchers;
-	} else if (XT_ALIGN(target->targetsize) != t->target_size) {
-		printk(KERN_WARNING "ebtables: %s target: "
-		       "invalid size %Zu != %u\n",
-		       target->name, XT_ALIGN(target->targetsize),
-		       t->target_size);
-		module_put(t->u.target->me);
-		ret = -EINVAL;
+	}
+
+	ret = xt_check_target(target, NFPROTO_BRIDGE, t->target_size,
+	      name, hookmask, e->ethproto, e->invflags & EBT_IPROTO);
+	if (ret < 0) {
+		module_put(target->me);
 		goto cleanup_watchers;
 	} else if (t->u.target->checkentry &&
 	    !t->u.target->checkentry(name, e, NULL, t->data, hookmask)) {
@@ -1589,11 +1546,14 @@ static int __init ebtables_init(void)
 {
 	int ret;
 
-	mutex_lock(&ebt_mutex);
-	list_add(&ebt_standard_target.list, &ebt_targets);
-	mutex_unlock(&ebt_mutex);
-	if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
+	ret = xt_register_target(&ebt_standard_target);
+	if (ret < 0)
 		return ret;
+	ret = nf_register_sockopt(&ebt_sockopts);
+	if (ret < 0) {
+		xt_unregister_target(&ebt_standard_target);
+		return ret;
+	}
 
 	printk(KERN_INFO "Ebtables v2.0 registered\n");
 	return 0;
@@ -1602,6 +1562,7 @@ static int __init ebtables_init(void)
 static void __exit ebtables_fini(void)
 {
 	nf_unregister_sockopt(&ebt_sockopts);
+	xt_unregister_target(&ebt_standard_target);
 	printk(KERN_INFO "Ebtables v2.0 unregistered\n");
 }
 
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index aece6c2..0e23f42 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -30,7 +30,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("[ip,ip6,arp]_tables backend module");
+MODULE_DESCRIPTION("{ip,ip6,arp,eb}_tables backend module");
 
 #define SMP_ALIGN(x) (((x) + SMP_CACHE_BYTES-1) & ~(SMP_CACHE_BYTES-1))
 
@@ -325,7 +325,12 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 		   unsigned int size, const char *table, unsigned int hook_mask,
 		   unsigned short proto, int inv_proto)
 {
-	if (XT_ALIGN(match->matchsize) != size) {
+	if (XT_ALIGN(match->matchsize) != size &&
+	    match->matchsize != -1) {
+		/*
+		 * ebt_among is exempt from centralized matchsize checking
+		 * because it uses a dynamic-size data set.
+		 */
 		printk("%s_tables: %s match: invalid size %Zu != %u\n",
 		       xt_prefix[family], match->name,
 		       XT_ALIGN(match->matchsize), size);
-- 
1.6.0.1

