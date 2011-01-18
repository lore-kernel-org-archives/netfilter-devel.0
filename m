From: Jan Engelhardt <jengelh@medozas.de>
Subject: [5/5] netfilter: xtables: case-sensitivity avoidance (5/5)
Date: Tue, 18 Jan 2011 16:40:22 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101181640120.15657@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38352 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753Ab1ARPkX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 10:40:23 -0500
In-Reply-To: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent 94b1a89f0d094d5467a7437af9d86b303943eb8c (v2.6.37-3812-g94b1a89)
commit dc5ef7eb160f0cf8361683a520f53d692abbc527
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Jan 18 06:35:56 2011 +0100

netfilter: xtables: case-sensitivity avoidance (5/5)

Renames the .c source files.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/Makefile                        |   16 +++---
 .../netfilter/{ipt_CLUSTERIP.c => xt_clusterip.c}  |    1 +
 net/ipv4/netfilter/{ipt_ECN.c => xt_ecn_tg.c}      |    1 +
 net/ipv4/netfilter/{ipt_LOG.c => xt_log_ipv4.c}    |    1 +
 .../{ipt_MASQUERADE.c => xt_masquerade.c}          |    1 +
 net/ipv4/netfilter/{ipt_NETMAP.c => xt_netmap.c}   |    1 +
 .../netfilter/{ipt_REDIRECT.c => xt_redirect.c}    |    0
 .../netfilter/{ipt_REJECT.c => xt_reject_ipv4.c}   |    1 +
 net/ipv4/netfilter/{ipt_ULOG.c => xt_ulog.c}       |    1 +
 net/ipv6/netfilter/Makefile                        |    4 +-
 net/ipv6/netfilter/{ip6t_LOG.c => xt_log_ipv6.c}   |    1 +
 .../netfilter/{ip6t_REJECT.c => xt_reject_ipv6.c}  |    1 +
 net/netfilter/Makefile                             |   38 ++++++------
 net/netfilter/{xt_AUDIT.c => xt_audit.c}           |    0
 net/netfilter/{xt_CHECKSUM.c => xt_checksum.c}     |    0
 net/netfilter/{xt_CLASSIFY.c => xt_classify.c}     |    0
 .../{xt_CONNSECMARK.c => xt_connsecmark.c}         |    0
 net/netfilter/{xt_CT.c => xt_ct.c}                 |    0
 net/netfilter/{xt_DSCP.c => xt_dscp_tg.c}          |    0
 net/netfilter/{xt_HL.c => xt_hl_tg.c}              |    0
 net/netfilter/{xt_IDLETIMER.c => xt_idletimer.c}   |    0
 net/netfilter/{xt_LED.c => xt_led.c}               |    0
 net/netfilter/{xt_NFLOG.c => xt_nflog.c}           |    0
 net/netfilter/{xt_NFQUEUE.c => xt_nfqueue.c}       |    0
 net/netfilter/{xt_NOTRACK.c => xt_notrack.c}       |    0
 net/netfilter/{xt_RATEEST.c => xt_rateest_tg.c}    |    0
 net/netfilter/{xt_SECMARK.c => xt_secmark.c}       |    0
 net/netfilter/{xt_TCPMSS.c => xt_tcpmss_tg.c}      |    0
 .../{xt_TCPOPTSTRIP.c => xt_tcpoptstrip.c}         |    0
 net/netfilter/{xt_TEE.c => xt_tee.c}               |    0
 net/netfilter/{xt_TPROXY.c => xt_tproxy.c}         |    0
 net/netfilter/{xt_TRACE.c => xt_trace.c}           |    0
 32 files changed, 38 insertions(+), 29 deletions(-)
 rename net/ipv4/netfilter/{ipt_CLUSTERIP.c => xt_clusterip.c} (99%)
 rename net/ipv4/netfilter/{ipt_ECN.c => xt_ecn_tg.c} (99%)
 rename net/ipv4/netfilter/{ipt_LOG.c => xt_log_ipv4.c} (99%)
 rename net/ipv4/netfilter/{ipt_MASQUERADE.c => xt_masquerade.c} (99%)
 rename net/ipv4/netfilter/{ipt_NETMAP.c => xt_netmap.c} (99%)
 rename net/ipv4/netfilter/{ipt_REDIRECT.c => xt_redirect.c} (100%)
 rename net/ipv4/netfilter/{ipt_REJECT.c => xt_reject_ipv4.c} (99%)
 rename net/ipv4/netfilter/{ipt_ULOG.c => xt_ulog.c} (99%)
 rename net/ipv6/netfilter/{ip6t_LOG.c => xt_log_ipv6.c} (99%)
 rename net/ipv6/netfilter/{ip6t_REJECT.c => xt_reject_ipv6.c} (99%)
 rename net/netfilter/{xt_AUDIT.c => xt_audit.c} (100%)
 rename net/netfilter/{xt_CHECKSUM.c => xt_checksum.c} (100%)
 rename net/netfilter/{xt_CLASSIFY.c => xt_classify.c} (100%)
 rename net/netfilter/{xt_CONNSECMARK.c => xt_connsecmark.c} (100%)
 rename net/netfilter/{xt_CT.c => xt_ct.c} (100%)
 rename net/netfilter/{xt_DSCP.c => xt_dscp_tg.c} (100%)
 rename net/netfilter/{xt_HL.c => xt_hl_tg.c} (100%)
 rename net/netfilter/{xt_IDLETIMER.c => xt_idletimer.c} (100%)
 rename net/netfilter/{xt_LED.c => xt_led.c} (100%)
 rename net/netfilter/{xt_NFLOG.c => xt_nflog.c} (100%)
 rename net/netfilter/{xt_NFQUEUE.c => xt_nfqueue.c} (100%)
 rename net/netfilter/{xt_NOTRACK.c => xt_notrack.c} (100%)
 rename net/netfilter/{xt_RATEEST.c => xt_rateest_tg.c} (100%)
 rename net/netfilter/{xt_SECMARK.c => xt_secmark.c} (100%)
 rename net/netfilter/{xt_TCPMSS.c => xt_tcpmss_tg.c} (100%)
 rename net/netfilter/{xt_TCPOPTSTRIP.c => xt_tcpoptstrip.c} (100%)
 rename net/netfilter/{xt_TEE.c => xt_tee.c} (100%)
 rename net/netfilter/{xt_TPROXY.c => xt_tproxy.c} (100%)
 rename net/netfilter/{xt_TRACE.c => xt_trace.c} (100%)

diff --git a/net/ipv4/netfilter/Makefile b/net/ipv4/netfilter/Makefile
index 19eb59d..9896238 100644
--- a/net/ipv4/netfilter/Makefile
+++ b/net/ipv4/netfilter/Makefile
@@ -53,14 +53,14 @@ obj-$(CONFIG_IP_NF_MATCH_AH) += ipt_ah.o
 obj-$(CONFIG_IP_NF_MATCH_ECN) += ipt_ecn.o
 
 # targets
-obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += ipt_CLUSTERIP.o
-obj-$(CONFIG_IP_NF_TARGET_ECN) += ipt_ECN.o
-obj-$(CONFIG_IP_NF_TARGET_LOG) += ipt_LOG.o
-obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += ipt_MASQUERADE.o
-obj-$(CONFIG_IP_NF_TARGET_NETMAP) += ipt_NETMAP.o
-obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += ipt_REDIRECT.o
-obj-$(CONFIG_IP_NF_TARGET_REJECT) += ipt_REJECT.o
-obj-$(CONFIG_IP_NF_TARGET_ULOG) += ipt_ULOG.o
+obj-$(CONFIG_IP_NF_TARGET_CLUSTERIP) += xt_clusterip.o
+obj-$(CONFIG_IP_NF_TARGET_ECN) += xt_ecn_tg.o
+obj-$(CONFIG_IP_NF_TARGET_LOG) += xt_log_ipv4.o
+obj-$(CONFIG_IP_NF_TARGET_MASQUERADE) += xt_masquerade.o
+obj-$(CONFIG_IP_NF_TARGET_NETMAP) += xt_netmap.o
+obj-$(CONFIG_IP_NF_TARGET_REDIRECT) += xt_redirect.o
+obj-$(CONFIG_IP_NF_TARGET_REJECT) += xt_reject_ipv4.o
+obj-$(CONFIG_IP_NF_TARGET_ULOG) += xt_ulog.o
 
 # generic ARP tables
 obj-$(CONFIG_IP_NF_ARPTABLES) += arp_tables.o
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/xt_clusterip.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_CLUSTERIP.c
rename to net/ipv4/netfilter/xt_clusterip.c
index ed812b1..696f13c 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/xt_clusterip.c
@@ -36,6 +36,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: CLUSTERIP target");
+MODULE_ALIAS("ipt_CLUSTERIP");
 
 struct clusterip_config {
 	struct list_head list;			/* list of all configs */
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/xt_ecn_tg.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_ECN.c
rename to net/ipv4/netfilter/xt_ecn_tg.c
index a8ee93e..a7c0f62 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/xt_ecn_tg.c
@@ -22,6 +22,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag modification");
+MODULE_ALIAS("ipt_ECN");
 
 /* set ECT codepoint from IP header.
  * 	return false if there was an error. */
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/xt_log_ipv4.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_LOG.c
rename to net/ipv4/netfilter/xt_log_ipv4.c
index 710a08f..a3f337c 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/xt_log_ipv4.c
@@ -29,6 +29,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: IPv4 packet logging to syslog");
+MODULE_ALIAS("ipt_LOG");
 
 /* One level of recursion won't kill us */
 static void dump_packet(struct sbuff *m,
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/xt_masquerade.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_MASQUERADE.c
rename to net/ipv4/netfilter/xt_masquerade.c
index d2ed9dc..274e8f5 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/xt_masquerade.c
@@ -26,6 +26,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
+MODULE_ALIAS("ipt_MASQUERADE");
 
 /* FIXME: Multiple targets. --RR */
 static int masquerade_tg_check(const struct xt_tgchk_param *par)
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/xt_netmap.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_NETMAP.c
rename to net/ipv4/netfilter/xt_netmap.c
index 6cdb298..39f46a3 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/xt_netmap.c
@@ -21,6 +21,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
 MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
+MODULE_ALIAS("ipt_NETMAP");
 
 static int netmap_tg_check(const struct xt_tgchk_param *par)
 {
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/xt_redirect.c
similarity index 100%
rename from net/ipv4/netfilter/ipt_REDIRECT.c
rename to net/ipv4/netfilter/xt_redirect.c
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/xt_reject_ipv4.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_REJECT.c
rename to net/ipv4/netfilter/xt_reject_ipv4.c
index c7e4854..07951d0 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/xt_reject_ipv4.c
@@ -31,6 +31,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
 MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
+MODULE_ALIAS("ipt_REJECT");
 
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int hook)
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/xt_ulog.c
similarity index 99%
rename from net/ipv4/netfilter/ipt_ULOG.c
rename to net/ipv4/netfilter/xt_ulog.c
index 293dbe3..ae0f58d 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/xt_ulog.c
@@ -52,6 +52,7 @@
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
 MODULE_DESCRIPTION("Xtables: packet logging to netlink using ULOG");
+MODULE_ALIAS("ipt_ULOG");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NFLOG);
 
 #define ULOG_NL_EVENT		111		/* Harald's favorite number */
diff --git a/net/ipv6/netfilter/Makefile b/net/ipv6/netfilter/Makefile
index abfee91..4ac424b 100644
--- a/net/ipv6/netfilter/Makefile
+++ b/net/ipv6/netfilter/Makefile
@@ -30,5 +30,5 @@ obj-$(CONFIG_IP6_NF_MATCH_OPTS) += ip6t_hbh.o
 obj-$(CONFIG_IP6_NF_MATCH_RT) += ip6t_rt.o
 
 # targets
-obj-$(CONFIG_IP6_NF_TARGET_LOG) += ip6t_LOG.o
-obj-$(CONFIG_IP6_NF_TARGET_REJECT) += ip6t_REJECT.o
+obj-$(CONFIG_IP6_NF_TARGET_LOG) += xt_log_ipv6.o
+obj-$(CONFIG_IP6_NF_TARGET_REJECT) += xt_reject_ipv6.o
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/xt_log_ipv6.c
similarity index 99%
rename from net/ipv6/netfilter/ip6t_LOG.c
rename to net/ipv6/netfilter/xt_log_ipv6.c
index a48698e..baf1cb0 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/xt_log_ipv6.c
@@ -29,6 +29,7 @@
 MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
 MODULE_DESCRIPTION("Xtables: IPv6 packet logging to syslog");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip6t_LOG");
 
 struct in_device;
 #include <net/route.h>
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/xt_reject_ipv6.c
similarity index 99%
rename from net/ipv6/netfilter/ip6t_REJECT.c
rename to net/ipv6/netfilter/xt_reject_ipv6.c
index 19b2052..55d5a4d 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/xt_reject_ipv6.c
@@ -35,6 +35,7 @@
 MODULE_AUTHOR("Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
 MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
 MODULE_LICENSE("GPL");
+MODULE_ALIAS("ip6t_REJECT");
 
 /* Send RST reply */
 static void send_reset(struct net *net, struct sk_buff *oldskb)
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 401d574..f3a2fb6 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -45,25 +45,25 @@ obj-$(CONFIG_NETFILTER_XT_MARK) += xt_mark.o
 obj-$(CONFIG_NETFILTER_XT_CONNMARK) += xt_connmark.o
 
 # targets
-obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_AUDIT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_CHECKSUM.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_CLASSIFY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_CONNSECMARK.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_CT.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_DSCP.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_HL.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_LED.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_NFLOG.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_NFQUEUE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_NOTRACK.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_RATEEST.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_SECMARK.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_TPROXY.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_TCPMSS.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_TCPOPTSTRIP.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_TEE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_TRACE.o
-obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_IDLETIMER.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_AUDIT) += xt_audit.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CHECKSUM) += xt_checksum.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CLASSIFY) += xt_classify.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CONNSECMARK) += xt_connsecmark.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_CT) += xt_ct.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_DSCP) += xt_dscp_tg.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_HL) += xt_hl_tg.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_LED) += xt_led.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFLOG) += xt_nflog.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NFQUEUE) += xt_nfqueue.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_NOTRACK) += xt_notrack.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_RATEEST) += xt_rateest_tg.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_SECMARK) += xt_secmark.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TPROXY) += xt_tproxy.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPMSS) += xt_tcpmss_tg.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TCPOPTSTRIP) += xt_tcpoptstrip.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TEE) += xt_tee.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_TRACE) += xt_trace.o
+obj-$(CONFIG_NETFILTER_XT_TARGET_IDLETIMER) += xt_idletimer.o
 
 # matches
 obj-$(CONFIG_NETFILTER_XT_MATCH_CLUSTER) += xt_cluster.o
diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_audit.c
similarity index 100%
rename from net/netfilter/xt_AUDIT.c
rename to net/netfilter/xt_audit.c
diff --git a/net/netfilter/xt_CHECKSUM.c b/net/netfilter/xt_checksum.c
similarity index 100%
rename from net/netfilter/xt_CHECKSUM.c
rename to net/netfilter/xt_checksum.c
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_classify.c
similarity index 100%
rename from net/netfilter/xt_CLASSIFY.c
rename to net/netfilter/xt_classify.c
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_connsecmark.c
similarity index 100%
rename from net/netfilter/xt_CONNSECMARK.c
rename to net/netfilter/xt_connsecmark.c
diff --git a/net/netfilter/xt_CT.c b/net/netfilter/xt_ct.c
similarity index 100%
rename from net/netfilter/xt_CT.c
rename to net/netfilter/xt_ct.c
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_dscp_tg.c
similarity index 100%
rename from net/netfilter/xt_DSCP.c
rename to net/netfilter/xt_dscp_tg.c
diff --git a/net/netfilter/xt_HL.c b/net/netfilter/xt_hl_tg.c
similarity index 100%
rename from net/netfilter/xt_HL.c
rename to net/netfilter/xt_hl_tg.c
diff --git a/net/netfilter/xt_IDLETIMER.c b/net/netfilter/xt_idletimer.c
similarity index 100%
rename from net/netfilter/xt_IDLETIMER.c
rename to net/netfilter/xt_idletimer.c
diff --git a/net/netfilter/xt_LED.c b/net/netfilter/xt_led.c
similarity index 100%
rename from net/netfilter/xt_LED.c
rename to net/netfilter/xt_led.c
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_nflog.c
similarity index 100%
rename from net/netfilter/xt_NFLOG.c
rename to net/netfilter/xt_nflog.c
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_nfqueue.c
similarity index 100%
rename from net/netfilter/xt_NFQUEUE.c
rename to net/netfilter/xt_nfqueue.c
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_notrack.c
similarity index 100%
rename from net/netfilter/xt_NOTRACK.c
rename to net/netfilter/xt_notrack.c
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_rateest_tg.c
similarity index 100%
rename from net/netfilter/xt_RATEEST.c
rename to net/netfilter/xt_rateest_tg.c
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_secmark.c
similarity index 100%
rename from net/netfilter/xt_SECMARK.c
rename to net/netfilter/xt_secmark.c
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_tcpmss_tg.c
similarity index 100%
rename from net/netfilter/xt_TCPMSS.c
rename to net/netfilter/xt_tcpmss_tg.c
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_tcpoptstrip.c
similarity index 100%
rename from net/netfilter/xt_TCPOPTSTRIP.c
rename to net/netfilter/xt_tcpoptstrip.c
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_tee.c
similarity index 100%
rename from net/netfilter/xt_TEE.c
rename to net/netfilter/xt_tee.c
diff --git a/net/netfilter/xt_TPROXY.c b/net/netfilter/xt_tproxy.c
similarity index 100%
rename from net/netfilter/xt_TPROXY.c
rename to net/netfilter/xt_tproxy.c
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_trace.c
similarity index 100%
rename from net/netfilter/xt_TRACE.c
rename to net/netfilter/xt_trace.c
-- 
# Created with git-export-patch
