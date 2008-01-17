From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded macros
Date: Thu, 17 Jan 2008 21:10:37 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37787 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYAQUKi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2008 15:10:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit a6c73fee39cedc87ef2562f84d5b1f68a315a79b
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Jan 17 18:58:05 2008 +0100

    [NETFILTER]: ebtables: expand/remove unneeded macros
    
    The EBT_*_{MATCH,TARGET,WATCHER} macros are only used within the
    accompanying .c source file, so they can be moved to it. And since
    they are only used once, we can just as well expand them.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/include/linux/netfilter_bridge/ebt_802_3.h b/include/linux/netfilter_bridge/ebt_802_3.h
index a11b0c2..11421ca 100644
--- a/include/linux/netfilter_bridge/ebt_802_3.h
+++ b/include/linux/netfilter_bridge/ebt_802_3.h
@@ -4,8 +4,6 @@
 #define EBT_802_3_SAP 0x01
 #define EBT_802_3_TYPE 0x02
 
-#define EBT_802_3_MATCH "802_3"
-
 /*
  * If frame has DSAP/SSAP value 0xaa you must check the SNAP type
  * to discover what kind of packet we're carrying. 
diff --git a/include/linux/netfilter_bridge/ebt_among.h b/include/linux/netfilter_bridge/ebt_among.h
index 7654069..d120451 100644
--- a/include/linux/netfilter_bridge/ebt_among.h
+++ b/include/linux/netfilter_bridge/ebt_among.h
@@ -60,6 +60,4 @@ struct ebt_among_info
 #define ebt_among_wh_src(x) ((x)->wh_src_ofs ? \
 	(struct ebt_mac_wormhash*)((char*)(x) + (x)->wh_src_ofs) : NULL)
 
-#define EBT_AMONG_MATCH "among"
-
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_arp.h b/include/linux/netfilter_bridge/ebt_arp.h
index cbf4843..e5c9fbf 100644
--- a/include/linux/netfilter_bridge/ebt_arp.h
+++ b/include/linux/netfilter_bridge/ebt_arp.h
@@ -12,7 +12,6 @@
 #define EBT_ARP_MASK (EBT_ARP_OPCODE | EBT_ARP_HTYPE | EBT_ARP_PTYPE | \
    EBT_ARP_SRC_IP | EBT_ARP_DST_IP | EBT_ARP_SRC_MAC | EBT_ARP_DST_MAC | \
    EBT_ARP_GRAT)
-#define EBT_ARP_MATCH "arp"
 
 struct ebt_arp_info
 {
diff --git a/include/linux/netfilter_bridge/ebt_arpreply.h b/include/linux/netfilter_bridge/ebt_arpreply.h
index 96a8339..1f333a3 100644
--- a/include/linux/netfilter_bridge/ebt_arpreply.h
+++ b/include/linux/netfilter_bridge/ebt_arpreply.h
@@ -6,6 +6,5 @@ struct ebt_arpreply_info
 	unsigned char mac[ETH_ALEN];
 	int target;
 };
-#define EBT_ARPREPLY_TARGET "arpreply"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_ip.h b/include/linux/netfilter_bridge/ebt_ip.h
index d684747..7cca9d0 100644
--- a/include/linux/netfilter_bridge/ebt_ip.h
+++ b/include/linux/netfilter_bridge/ebt_ip.h
@@ -23,7 +23,6 @@
 #define EBT_IP_DPORT 0x20
 #define EBT_IP_MASK (EBT_IP_SOURCE | EBT_IP_DEST | EBT_IP_TOS | EBT_IP_PROTO |\
  EBT_IP_SPORT | EBT_IP_DPORT )
-#define EBT_IP_MATCH "ip"
 
 /* the same values are used for the invflags */
 struct ebt_ip_info
diff --git a/include/linux/netfilter_bridge/ebt_limit.h b/include/linux/netfilter_bridge/ebt_limit.h
index d8b6500..be43d36 100644
--- a/include/linux/netfilter_bridge/ebt_limit.h
+++ b/include/linux/netfilter_bridge/ebt_limit.h
@@ -1,8 +1,6 @@
 #ifndef __LINUX_BRIDGE_EBT_LIMIT_H
 #define __LINUX_BRIDGE_EBT_LIMIT_H
 
-#define EBT_LIMIT_MATCH "limit"
-
 /* timings are in milliseconds. */
 #define EBT_LIMIT_SCALE 10000
 
diff --git a/include/linux/netfilter_bridge/ebt_log.h b/include/linux/netfilter_bridge/ebt_log.h
index 96e231a..fb25ebe 100644
--- a/include/linux/netfilter_bridge/ebt_log.h
+++ b/include/linux/netfilter_bridge/ebt_log.h
@@ -6,7 +6,6 @@
 #define EBT_LOG_NFLOG 0x04
 #define EBT_LOG_MASK (EBT_LOG_IP | EBT_LOG_ARP)
 #define EBT_LOG_PREFIX_SIZE 30
-#define EBT_LOG_WATCHER "log"
 
 struct ebt_log_info
 {
diff --git a/include/linux/netfilter_bridge/ebt_mark_m.h b/include/linux/netfilter_bridge/ebt_mark_m.h
index 301524f..bcfc2f0 100644
--- a/include/linux/netfilter_bridge/ebt_mark_m.h
+++ b/include/linux/netfilter_bridge/ebt_mark_m.h
@@ -10,6 +10,5 @@ struct ebt_mark_m_info
 	uint8_t invert;
 	uint8_t bitmask;
 };
-#define EBT_MARK_MATCH "mark_m"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_mark_t.h b/include/linux/netfilter_bridge/ebt_mark_t.h
index 6270f6f..159f073 100644
--- a/include/linux/netfilter_bridge/ebt_mark_t.h
+++ b/include/linux/netfilter_bridge/ebt_mark_t.h
@@ -19,6 +19,5 @@ struct ebt_mark_t_info
 	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
 	int target;
 };
-#define EBT_MARK_TARGET "mark"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_nat.h b/include/linux/netfilter_bridge/ebt_nat.h
index 435b886..e1b62b4 100644
--- a/include/linux/netfilter_bridge/ebt_nat.h
+++ b/include/linux/netfilter_bridge/ebt_nat.h
@@ -8,7 +8,5 @@ struct ebt_nat_info
 	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
 	int target;
 };
-#define EBT_SNAT_TARGET "snat"
-#define EBT_DNAT_TARGET "dnat"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_pkttype.h b/include/linux/netfilter_bridge/ebt_pkttype.h
index 0d64bbb..de6848a 100644
--- a/include/linux/netfilter_bridge/ebt_pkttype.h
+++ b/include/linux/netfilter_bridge/ebt_pkttype.h
@@ -6,6 +6,5 @@ struct ebt_pkttype_info
 	uint8_t pkt_type;
 	uint8_t invert;
 };
-#define EBT_PKTTYPE_MATCH "pkttype"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_redirect.h b/include/linux/netfilter_bridge/ebt_redirect.h
index 5c67990..e9dbda7 100644
--- a/include/linux/netfilter_bridge/ebt_redirect.h
+++ b/include/linux/netfilter_bridge/ebt_redirect.h
@@ -6,6 +6,5 @@ struct ebt_redirect_info
 	/* EBT_ACCEPT, EBT_DROP, EBT_CONTINUE or EBT_RETURN */
 	int target;
 };
-#define EBT_REDIRECT_TARGET "redirect"
 
 #endif
diff --git a/include/linux/netfilter_bridge/ebt_stp.h b/include/linux/netfilter_bridge/ebt_stp.h
index e5fd678..83a6da3 100644
--- a/include/linux/netfilter_bridge/ebt_stp.h
+++ b/include/linux/netfilter_bridge/ebt_stp.h
@@ -18,8 +18,6 @@
 #define EBT_STP_MASK		0x0fff
 #define EBT_STP_CONFIG_MASK	0x0ffe
 
-#define EBT_STP_MATCH "stp"
-
 struct ebt_stp_config_info
 {
 	uint8_t flags;
diff --git a/include/linux/netfilter_bridge/ebt_ulog.h b/include/linux/netfilter_bridge/ebt_ulog.h
index b677e26..4dafcc0 100644
--- a/include/linux/netfilter_bridge/ebt_ulog.h
+++ b/include/linux/netfilter_bridge/ebt_ulog.h
@@ -6,7 +6,6 @@
 #define EBT_ULOG_MAXNLGROUPS 32 /* hardcoded netlink max */
 #define EBT_ULOG_PREFIX_LEN 32
 #define EBT_ULOG_MAX_QLEN 50
-#define EBT_ULOG_WATCHER "ulog"
 #define EBT_ULOG_VERSION 1
 
 struct ebt_ulog_info {
diff --git a/include/linux/netfilter_bridge/ebt_vlan.h b/include/linux/netfilter_bridge/ebt_vlan.h
index 1d98be4..4715d7b 100644
--- a/include/linux/netfilter_bridge/ebt_vlan.h
+++ b/include/linux/netfilter_bridge/ebt_vlan.h
@@ -5,7 +5,6 @@
 #define EBT_VLAN_PRIO	0x02
 #define EBT_VLAN_ENCAP	0x04
 #define EBT_VLAN_MASK (EBT_VLAN_ID | EBT_VLAN_PRIO | EBT_VLAN_ENCAP)
-#define EBT_VLAN_MATCH "vlan"
 
 struct ebt_vlan_info {
 	uint16_t id;		/* VLAN ID {1-4095} */
diff --git a/net/bridge/netfilter/ebt_802_3.c b/net/bridge/netfilter/ebt_802_3.c
index 41a7807..2e8d994 100644
--- a/net/bridge/netfilter/ebt_802_3.c
+++ b/net/bridge/netfilter/ebt_802_3.c
@@ -52,7 +52,7 @@ static int ebt_802_3_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_802_3 =
 {
-	.name		= EBT_802_3_MATCH,
+	.name		= "802_3",
 	.match		= ebt_filter_802_3,
 	.check		= ebt_802_3_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_among.c b/net/bridge/netfilter/ebt_among.c
index 6436d30..3fb9ed4 100644
--- a/net/bridge/netfilter/ebt_among.c
+++ b/net/bridge/netfilter/ebt_among.c
@@ -207,7 +207,7 @@ static int ebt_among_check(const char *tablename, unsigned int hookmask,
 }
 
 static struct ebt_match filter_among = {
-	.name		= EBT_AMONG_MATCH,
+	.name		= "among",
 	.match		= ebt_filter_among,
 	.check		= ebt_among_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_arp.c b/net/bridge/netfilter/ebt_arp.c
index 1814139..039faf4 100644
--- a/net/bridge/netfilter/ebt_arp.c
+++ b/net/bridge/netfilter/ebt_arp.c
@@ -115,7 +115,7 @@ static int ebt_arp_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_arp =
 {
-	.name		= EBT_ARP_MATCH,
+	.name		= "arp",
 	.match		= ebt_filter_arp,
 	.check		= ebt_arp_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_arpreply.c b/net/bridge/netfilter/ebt_arpreply.c
index 48a80e4..90dfa68 100644
--- a/net/bridge/netfilter/ebt_arpreply.c
+++ b/net/bridge/netfilter/ebt_arpreply.c
@@ -75,7 +75,7 @@ static int ebt_target_reply_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target reply_target =
 {
-	.name		= EBT_ARPREPLY_TARGET,
+	.name		= "arpreply",
 	.target		= ebt_target_reply,
 	.check		= ebt_target_reply_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 74262e9..7ebbaaf 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -48,7 +48,7 @@ static int ebt_target_dnat_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target dnat =
 {
-	.name		= EBT_DNAT_TARGET,
+	.name		= "dnat",
 	.target		= ebt_target_dnat,
 	.check		= ebt_target_dnat_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_ip.c b/net/bridge/netfilter/ebt_ip.c
index 69f7f0a..272e9ff 100644
--- a/net/bridge/netfilter/ebt_ip.c
+++ b/net/bridge/netfilter/ebt_ip.c
@@ -107,7 +107,7 @@ static int ebt_ip_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_ip =
 {
-	.name		= EBT_IP_MATCH,
+	.name		= "ip",
 	.match		= ebt_filter_ip,
 	.check		= ebt_ip_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_limit.c b/net/bridge/netfilter/ebt_limit.c
index d48fa5c..fcf3151 100644
--- a/net/bridge/netfilter/ebt_limit.c
+++ b/net/bridge/netfilter/ebt_limit.c
@@ -92,7 +92,7 @@ static int ebt_limit_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match ebt_limit_reg =
 {
-	.name		= EBT_LIMIT_MATCH,
+	.name		= "limit",
 	.match		= ebt_limit_match,
 	.check		= ebt_limit_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_log.c b/net/bridge/netfilter/ebt_log.c
index 3be9e98..97db468 100644
--- a/net/bridge/netfilter/ebt_log.c
+++ b/net/bridge/netfilter/ebt_log.c
@@ -177,7 +177,7 @@ static void ebt_log(const struct sk_buff *skb, unsigned int hooknr,
 
 static struct ebt_watcher log =
 {
-	.name		= EBT_LOG_WATCHER,
+	.name		= "log",
 	.watcher	= ebt_log,
 	.check		= ebt_log_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 6cba543..0b44fec 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -59,7 +59,7 @@ static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target mark_target =
 {
-	.name		= EBT_MARK_TARGET,
+	.name		= "mark",
 	.target		= ebt_target_mark,
 	.check		= ebt_target_mark_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_mark_m.c b/net/bridge/netfilter/ebt_mark_m.c
index 6b0d216..cf81aa3 100644
--- a/net/bridge/netfilter/ebt_mark_m.c
+++ b/net/bridge/netfilter/ebt_mark_m.c
@@ -41,7 +41,7 @@ static int ebt_mark_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_mark =
 {
-	.name		= EBT_MARK_MATCH,
+	.name		= "mark_m",
 	.match		= ebt_filter_mark,
 	.check		= ebt_mark_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_pkttype.c b/net/bridge/netfilter/ebt_pkttype.c
index 4fffd70..07a3d1d 100644
--- a/net/bridge/netfilter/ebt_pkttype.c
+++ b/net/bridge/netfilter/ebt_pkttype.c
@@ -38,7 +38,7 @@ static int ebt_pkttype_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_pkttype =
 {
-	.name		= EBT_PKTTYPE_MATCH,
+	.name		= "pkttype",
 	.match		= ebt_filter_pkttype,
 	.check		= ebt_pkttype_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_redirect.c b/net/bridge/netfilter/ebt_redirect.c
index 422cb83..ce561c6 100644
--- a/net/bridge/netfilter/ebt_redirect.c
+++ b/net/bridge/netfilter/ebt_redirect.c
@@ -53,7 +53,7 @@ static int ebt_target_redirect_check(const char *tablename, unsigned int hookmas
 
 static struct ebt_target redirect_target =
 {
-	.name		= EBT_REDIRECT_TARGET,
+	.name		= "redirect",
 	.target		= ebt_target_redirect,
 	.check		= ebt_target_redirect_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 425ac92..5980a4c 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -69,7 +69,7 @@ static int ebt_target_snat_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_target snat =
 {
-	.name		= EBT_SNAT_TARGET,
+	.name		= "snat",
 	.target		= ebt_target_snat,
 	.check		= ebt_target_snat_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_stp.c b/net/bridge/netfilter/ebt_stp.c
index 31b7736..8655c84 100644
--- a/net/bridge/netfilter/ebt_stp.c
+++ b/net/bridge/netfilter/ebt_stp.c
@@ -174,7 +174,7 @@ static int ebt_stp_check(const char *tablename, unsigned int hookmask,
 
 static struct ebt_match filter_stp =
 {
-	.name		= EBT_STP_MATCH,
+	.name		= "stp",
 	.match		= ebt_filter_stp,
 	.check		= ebt_stp_check,
 	.me		= THIS_MODULE,
diff --git a/net/bridge/netfilter/ebt_ulog.c b/net/bridge/netfilter/ebt_ulog.c
index b73ba28..ce92b2c 100644
--- a/net/bridge/netfilter/ebt_ulog.c
+++ b/net/bridge/netfilter/ebt_ulog.c
@@ -273,14 +273,14 @@ static int ebt_ulog_check(const char *tablename, unsigned int hookmask,
 }
 
 static struct ebt_watcher ulog = {
-	.name		= EBT_ULOG_WATCHER,
+	.name		= "ulog",
 	.watcher	= ebt_ulog,
 	.check		= ebt_ulog_check,
 	.me		= THIS_MODULE,
 };
 
 static const struct nf_logger ebt_ulog_logger = {
-	.name		= EBT_ULOG_WATCHER,
+	.name		= "ulog",
 	.logfn		= &ebt_log_packet,
 	.me		= THIS_MODULE,
 };
diff --git a/net/bridge/netfilter/ebt_vlan.c b/net/bridge/netfilter/ebt_vlan.c
index 0ddf749..488cc94 100644
--- a/net/bridge/netfilter/ebt_vlan.c
+++ b/net/bridge/netfilter/ebt_vlan.c
@@ -170,7 +170,7 @@ ebt_check_vlan(const char *tablename,
 }
 
 static struct ebt_match filter_vlan = {
-	.name		= EBT_VLAN_MATCH,
+	.name		= "vlan",
 	.match		= ebt_filter_vlan,
 	.check		= ebt_check_vlan,
 	.me		= THIS_MODULE,

