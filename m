From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 16/38]: Update modules' descriptions
Date: Tue, 15 Jan 2008 07:19:33 +0100 (MET)
Message-ID: <20080115061928.3184.47341.sendpatchset@localhost.localdomain>
References: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62202 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332AbYAOGTf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2008 01:19:35 -0500
In-Reply-To: <20080115061907.3184.39432.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: Update modules' descriptions

Updates the MODULE_DESCRIPTION() tags for all Netfilter modules,
actually describing what the module does and not just
"netfilter XYZ target".

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 1834195893f1df31c850cf93281e4a88e2cfad9b
tree 4ee31ded35ae277bef8a3c123a54f58e34b383f8
parent 9793ea135e7d8ad359f3fd35b94fe89faa0e88a3
author Jan Engelhardt <jengelh@computergmbh.de> Mon, 14 Jan 2008 06:51:40 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 15 Jan 2008 06:53:20 +0100

 net/ipv4/netfilter/ipt_CLUSTERIP.c   |    2 +-
 net/ipv4/netfilter/ipt_ECN.c         |    2 +-
 net/ipv4/netfilter/ipt_LOG.c         |    2 +-
 net/ipv4/netfilter/ipt_MASQUERADE.c  |    2 +-
 net/ipv4/netfilter/ipt_NETMAP.c      |    2 +-
 net/ipv4/netfilter/ipt_REDIRECT.c    |    2 +-
 net/ipv4/netfilter/ipt_REJECT.c      |    2 +-
 net/ipv4/netfilter/ipt_TTL.c         |    2 +-
 net/ipv4/netfilter/ipt_ULOG.c        |    2 +-
 net/ipv4/netfilter/ipt_addrtype.c    |    2 +-
 net/ipv4/netfilter/ipt_ah.c          |    2 +-
 net/ipv4/netfilter/ipt_ecn.c         |    2 +-
 net/ipv4/netfilter/ipt_iprange.c     |    2 +-
 net/ipv4/netfilter/ipt_recent.c      |    2 +-
 net/ipv4/netfilter/ipt_ttl.c         |    2 +-
 net/ipv6/netfilter/ip6t_HL.c         |    2 +-
 net/ipv6/netfilter/ip6t_LOG.c        |    2 +-
 net/ipv6/netfilter/ip6t_REJECT.c     |    2 +-
 net/ipv6/netfilter/ip6t_ah.c         |    2 +-
 net/ipv6/netfilter/ip6t_eui64.c      |    2 +-
 net/ipv6/netfilter/ip6t_frag.c       |    2 +-
 net/ipv6/netfilter/ip6t_hbh.c        |    2 +-
 net/ipv6/netfilter/ip6t_hl.c         |    2 +-
 net/ipv6/netfilter/ip6t_ipv6header.c |    2 +-
 net/ipv6/netfilter/ip6t_mh.c         |    2 +-
 net/ipv6/netfilter/ip6t_rt.c         |    2 +-
 net/netfilter/xt_CLASSIFY.c          |    2 +-
 net/netfilter/xt_CONNMARK.c          |    2 +-
 net/netfilter/xt_CONNSECMARK.c       |    2 +-
 net/netfilter/xt_DSCP.c              |    2 +-
 net/netfilter/xt_MARK.c              |    2 +-
 net/netfilter/xt_NFLOG.c             |    2 +-
 net/netfilter/xt_NFQUEUE.c           |    2 +-
 net/netfilter/xt_NOTRACK.c           |    1 +
 net/netfilter/xt_RATEEST.c           |    2 +-
 net/netfilter/xt_SECMARK.c           |    2 +-
 net/netfilter/xt_TCPMSS.c            |    2 +-
 net/netfilter/xt_TCPOPTSTRIP.c       |    2 +-
 net/netfilter/xt_TRACE.c             |    1 +
 net/netfilter/xt_comment.c           |    2 +-
 net/netfilter/xt_connbytes.c         |    2 +-
 net/netfilter/xt_connlimit.c         |    2 +-
 net/netfilter/xt_connmark.c          |    2 +-
 net/netfilter/xt_conntrack.c         |    2 +-
 net/netfilter/xt_dccp.c              |    2 +-
 net/netfilter/xt_dscp.c              |    2 +-
 net/netfilter/xt_esp.c               |    2 +-
 net/netfilter/xt_hashlimit.c         |    2 +-
 net/netfilter/xt_helper.c            |    2 +-
 net/netfilter/xt_length.c            |    2 +-
 net/netfilter/xt_limit.c             |    2 +-
 net/netfilter/xt_mac.c               |    2 +-
 net/netfilter/xt_mark.c              |    2 +-
 net/netfilter/xt_multiport.c         |    2 +-
 net/netfilter/xt_owner.c             |    2 +-
 net/netfilter/xt_physdev.c           |    2 +-
 net/netfilter/xt_pkttype.c           |    2 +-
 net/netfilter/xt_policy.c            |    2 +-
 net/netfilter/xt_quota.c             |    1 +
 net/netfilter/xt_realm.c             |    2 +-
 net/netfilter/xt_sctp.c              |    2 +-
 net/netfilter/xt_statistic.c         |    2 +-
 net/netfilter/xt_string.c            |    2 +-
 net/netfilter/xt_tcpmss.c            |    2 +-
 net/netfilter/xt_tcpudp.c            |    2 +-
 net/netfilter/xt_time.c              |    2 +-
 net/netfilter/xt_u32.c               |    2 +-
 67 files changed, 67 insertions(+), 64 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index df39ca0..1b31f7d 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -32,7 +32,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables target for CLUSTERIP");
+MODULE_DESCRIPTION("Xtables: CLUSTERIP target");
 
 struct clusterip_config {
 	struct list_head list;			/* list of all configs */
diff --git a/net/ipv4/netfilter/ipt_ECN.c b/net/ipv4/netfilter/ipt_ECN.c
index ab41764..21395bc 100644
--- a/net/ipv4/netfilter/ipt_ECN.c
+++ b/net/ipv4/netfilter/ipt_ECN.c
@@ -21,7 +21,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables ECN modification module");
+MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag modification");
 
 /* set ECT codepoint from IP header.
  * 	return false if there was an error. */
diff --git a/net/ipv4/netfilter/ipt_LOG.c b/net/ipv4/netfilter/ipt_LOG.c
index 5acdddf..b38d785 100644
--- a/net/ipv4/netfilter/ipt_LOG.c
+++ b/net/ipv4/netfilter/ipt_LOG.c
@@ -26,7 +26,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables syslog logging module");
+MODULE_DESCRIPTION("Xtables: IPv4 packet logging to syslog");
 
 /* Use lock to serialize, so printks don't overlap */
 static DEFINE_SPINLOCK(log_lock);
diff --git a/net/ipv4/netfilter/ipt_MASQUERADE.c b/net/ipv4/netfilter/ipt_MASQUERADE.c
index 1cbff7b..d80fee8 100644
--- a/net/ipv4/netfilter/ipt_MASQUERADE.c
+++ b/net/ipv4/netfilter/ipt_MASQUERADE.c
@@ -25,7 +25,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables MASQUERADE target module");
+MODULE_DESCRIPTION("Xtables: automatic-address SNAT");
 
 /* Lock protects masq region inside conntrack */
 static DEFINE_RWLOCK(masq_lock);
diff --git a/net/ipv4/netfilter/ipt_NETMAP.c b/net/ipv4/netfilter/ipt_NETMAP.c
index 5b71ef4..6739abf 100644
--- a/net/ipv4/netfilter/ipt_NETMAP.c
+++ b/net/ipv4/netfilter/ipt_NETMAP.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Svenning Soerensen <svenning@post5.tele.dk>");
-MODULE_DESCRIPTION("iptables 1:1 NAT mapping of IP networks target");
+MODULE_DESCRIPTION("Xtables: 1:1 NAT mapping of IPv4 subnets");
 
 static bool
 netmap_tg_check(const char *tablename, const void *e,
diff --git a/net/ipv4/netfilter/ipt_REDIRECT.c b/net/ipv4/netfilter/ipt_REDIRECT.c
index 3d9ec5c..5c62924 100644
--- a/net/ipv4/netfilter/ipt_REDIRECT.c
+++ b/net/ipv4/netfilter/ipt_REDIRECT.c
@@ -23,7 +23,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables REDIRECT target module");
+MODULE_DESCRIPTION("Xtables: Connection redirection to localhost");
 
 /* FIXME: Take multiple ranges --RR */
 static bool
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index a299ceb..e3c2ecc 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -29,7 +29,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables REJECT target module");
+MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv4");
 
 /* Send RST reply */
 static void send_reset(struct sk_buff *oldskb, int hook)
diff --git a/net/ipv4/netfilter/ipt_TTL.c b/net/ipv4/netfilter/ipt_TTL.c
index fa13cf6..30eed65 100644
--- a/net/ipv4/netfilter/ipt_TTL.c
+++ b/net/ipv4/netfilter/ipt_TTL.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter_ipv4/ipt_TTL.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("IP tables TTL modification module");
+MODULE_DESCRIPTION("Xtables: IPv4 TTL field modification target");
 MODULE_LICENSE("GPL");
 
 static unsigned int
diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 1d8e146..fa24efa 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -50,7 +50,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@gnumonks.org>");
-MODULE_DESCRIPTION("iptables userspace logging module");
+MODULE_DESCRIPTION("Xtables: packet logging to netlink using ULOG");
 MODULE_ALIAS_NET_PF_PROTO(PF_NETLINK, NETLINK_NFLOG);
 
 #define ULOG_NL_EVENT		111		/* Harald's favorite number */
diff --git a/net/ipv4/netfilter/ipt_addrtype.c b/net/ipv4/netfilter/ipt_addrtype.c
index 8763902..49587a4 100644
--- a/net/ipv4/netfilter/ipt_addrtype.c
+++ b/net/ipv4/netfilter/ipt_addrtype.c
@@ -21,7 +21,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("iptables addrtype match");
+MODULE_DESCRIPTION("Xtables: address type match for IPv4");
 
 static inline bool match_type(const struct net_device *dev, __be32 addr,
 			      u_int16_t mask)
diff --git a/net/ipv4/netfilter/ipt_ah.c b/net/ipv4/netfilter/ipt_ah.c
index 2b2fb26..e977989 100644
--- a/net/ipv4/netfilter/ipt_ah.c
+++ b/net/ipv4/netfilter/ipt_ah.c
@@ -16,7 +16,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
-MODULE_DESCRIPTION("iptables AH SPI match module");
+MODULE_DESCRIPTION("Xtables: IPv4 IPsec-AH SPI match");
 
 #ifdef DEBUG_CONNTRACK
 #define duprintf(format, args...) printk(format , ## args)
diff --git a/net/ipv4/netfilter/ipt_ecn.c b/net/ipv4/netfilter/ipt_ecn.c
index ea13784..749de82 100644
--- a/net/ipv4/netfilter/ipt_ecn.c
+++ b/net/ipv4/netfilter/ipt_ecn.c
@@ -19,7 +19,7 @@
 #include <linux/netfilter_ipv4/ipt_ecn.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables ECN matching module");
+MODULE_DESCRIPTION("Xtables: Explicit Congestion Notification (ECN) flag match for IPv4");
 MODULE_LICENSE("GPL");
 
 static inline bool match_ip(const struct sk_buff *skb,
diff --git a/net/ipv4/netfilter/ipt_iprange.c b/net/ipv4/netfilter/ipt_iprange.c
index 82208ed..9a2aba8 100644
--- a/net/ipv4/netfilter/ipt_iprange.c
+++ b/net/ipv4/netfilter/ipt_iprange.c
@@ -15,7 +15,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>");
-MODULE_DESCRIPTION("iptables arbitrary IP range match module");
+MODULE_DESCRIPTION("Xtables: arbitrary IPv4 range matching");
 
 static bool
 iprange_mt(const struct sk_buff *skb, const struct net_device *in,
diff --git a/net/ipv4/netfilter/ipt_recent.c b/net/ipv4/netfilter/ipt_recent.c
index 4f3700d..e3154a9 100644
--- a/net/ipv4/netfilter/ipt_recent.c
+++ b/net/ipv4/netfilter/ipt_recent.c
@@ -30,7 +30,7 @@
 #include <linux/netfilter_ipv4/ipt_recent.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("IP tables recently seen matching module");
+MODULE_DESCRIPTION("Xtables: \"recently-seen\" host matching for IPv4");
 MODULE_LICENSE("GPL");
 
 static unsigned int ip_list_tot = 100;
diff --git a/net/ipv4/netfilter/ipt_ttl.c b/net/ipv4/netfilter/ipt_ttl.c
index b18d391..e0b8cae 100644
--- a/net/ipv4/netfilter/ipt_ttl.c
+++ b/net/ipv4/netfilter/ipt_ttl.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("IP tables TTL matching module");
+MODULE_DESCRIPTION("Xtables: IPv4 TTL field match");
 MODULE_LICENSE("GPL");
 
 static bool
diff --git a/net/ipv6/netfilter/ip6t_HL.c b/net/ipv6/netfilter/ip6t_HL.c
index cefb425..d5f8fd5 100644
--- a/net/ipv6/netfilter/ip6t_HL.c
+++ b/net/ipv6/netfilter/ip6t_HL.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter_ipv6/ip6t_HL.h>
 
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("IP6 tables Hop Limit modification module");
+MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field modification target");
 MODULE_LICENSE("GPL");
 
 static unsigned int
diff --git a/net/ipv6/netfilter/ip6t_LOG.c b/net/ipv6/netfilter/ip6t_LOG.c
index 474c2b1..86a6138 100644
--- a/net/ipv6/netfilter/ip6t_LOG.c
+++ b/net/ipv6/netfilter/ip6t_LOG.c
@@ -26,7 +26,7 @@
 #include <net/netfilter/nf_log.h>
 
 MODULE_AUTHOR("Jan Rekorajski <baggins@pld.org.pl>");
-MODULE_DESCRIPTION("IP6 tables LOG target module");
+MODULE_DESCRIPTION("Xtables: IPv6 packet logging to syslog");
 MODULE_LICENSE("GPL");
 
 struct in_device;
diff --git a/net/ipv6/netfilter/ip6t_REJECT.c b/net/ipv6/netfilter/ip6t_REJECT.c
index a951c2c..b23baa6 100644
--- a/net/ipv6/netfilter/ip6t_REJECT.c
+++ b/net/ipv6/netfilter/ip6t_REJECT.c
@@ -31,7 +31,7 @@
 #include <linux/netfilter_ipv6/ip6t_REJECT.h>
 
 MODULE_AUTHOR("Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>");
-MODULE_DESCRIPTION("IP6 tables REJECT target module");
+MODULE_DESCRIPTION("Xtables: packet \"rejection\" target for IPv6");
 MODULE_LICENSE("GPL");
 
 /* Send RST reply */
diff --git a/net/ipv6/netfilter/ip6t_ah.c b/net/ipv6/netfilter/ip6t_ah.c
index f5d08a8..429629f 100644
--- a/net/ipv6/netfilter/ip6t_ah.c
+++ b/net/ipv6/netfilter/ip6t_ah.c
@@ -20,7 +20,7 @@
 #include <linux/netfilter_ipv6/ip6t_ah.h>
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 AH match");
+MODULE_DESCRIPTION("Xtables: IPv6 IPsec-AH match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 /* Returns 1 if the spi is matched by the range, 0 otherwise */
diff --git a/net/ipv6/netfilter/ip6t_eui64.c b/net/ipv6/netfilter/ip6t_eui64.c
index dd9e67d..8f331f1 100644
--- a/net/ipv6/netfilter/ip6t_eui64.c
+++ b/net/ipv6/netfilter/ip6t_eui64.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
-MODULE_DESCRIPTION("IPv6 EUI64 address checking match");
+MODULE_DESCRIPTION("Xtables: IPv6 EUI64 address match");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
diff --git a/net/ipv6/netfilter/ip6t_frag.c b/net/ipv6/netfilter/ip6t_frag.c
index ae8c714..e2bbc63 100644
--- a/net/ipv6/netfilter/ip6t_frag.c
+++ b/net/ipv6/netfilter/ip6t_frag.c
@@ -19,7 +19,7 @@
 #include <linux/netfilter_ipv6/ip6t_frag.h>
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 FRAG match");
+MODULE_DESCRIPTION("Xtables: IPv6 fragment match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
diff --git a/net/ipv6/netfilter/ip6t_hbh.c b/net/ipv6/netfilter/ip6t_hbh.c
index b76e27d..62e39ac 100644
--- a/net/ipv6/netfilter/ip6t_hbh.c
+++ b/net/ipv6/netfilter/ip6t_hbh.c
@@ -21,7 +21,7 @@
 #include <linux/netfilter_ipv6/ip6t_opts.h>
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 opts match");
+MODULE_DESCRIPTION("Xtables: IPv6 Hop-By-Hop and Destination Header match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 MODULE_ALIAS("ip6t_dst");
 
diff --git a/net/ipv6/netfilter/ip6t_hl.c b/net/ipv6/netfilter/ip6t_hl.c
index 8f2d7d0..3456716 100644
--- a/net/ipv6/netfilter/ip6t_hl.c
+++ b/net/ipv6/netfilter/ip6t_hl.c
@@ -16,7 +16,7 @@
 #include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Maciej Soltysiak <solt@dns.toxicfilms.tv>");
-MODULE_DESCRIPTION("IP tables Hop Limit matching module");
+MODULE_DESCRIPTION("Xtables: IPv6 Hop Limit field match");
 MODULE_LICENSE("GPL");
 
 static bool
diff --git a/net/ipv6/netfilter/ip6t_ipv6header.c b/net/ipv6/netfilter/ip6t_ipv6header.c
index ae497e7..3a94017 100644
--- a/net/ipv6/netfilter/ip6t_ipv6header.c
+++ b/net/ipv6/netfilter/ip6t_ipv6header.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter_ipv6/ip6t_ipv6header.h>
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 headers match");
+MODULE_DESCRIPTION("Xtables: IPv6 header types match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 static bool
diff --git a/net/ipv6/netfilter/ip6t_mh.c b/net/ipv6/netfilter/ip6t_mh.c
index 618e6b9..e06678d 100644
--- a/net/ipv6/netfilter/ip6t_mh.c
+++ b/net/ipv6/netfilter/ip6t_mh.c
@@ -21,7 +21,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv6/ip6t_mh.h>
 
-MODULE_DESCRIPTION("ip6t_tables match for MH");
+MODULE_DESCRIPTION("Xtables: IPv6 Mobility Header match");
 MODULE_LICENSE("GPL");
 
 #ifdef DEBUG_IP_FIREWALL_USER
diff --git a/net/ipv6/netfilter/ip6t_rt.c b/net/ipv6/netfilter/ip6t_rt.c
index 038cea6..12a9efe 100644
--- a/net/ipv6/netfilter/ip6t_rt.c
+++ b/net/ipv6/netfilter/ip6t_rt.c
@@ -21,7 +21,7 @@
 #include <linux/netfilter_ipv6/ip6t_rt.h>
 
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("IPv6 RT match");
+MODULE_DESCRIPTION("Xtables: IPv6 Routing Header match");
 MODULE_AUTHOR("Andras Kis-Szabo <kisza@sch.bme.hu>");
 
 /* Returns 1 if the id is matched by the range, 0 otherwise */
diff --git a/net/netfilter/xt_CLASSIFY.c b/net/netfilter/xt_CLASSIFY.c
index 8e83dd4..77a52bf 100644
--- a/net/netfilter/xt_CLASSIFY.c
+++ b/net/netfilter/xt_CLASSIFY.c
@@ -22,7 +22,7 @@
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("iptables qdisc classification target module");
+MODULE_DESCRIPTION("Xtables: Qdisc classification");
 MODULE_ALIAS("ipt_CLASSIFY");
 MODULE_ALIAS("ip6t_CLASSIFY");
 
diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
index b9bd772..5fecfb4 100644
--- a/net/netfilter/xt_CONNMARK.c
+++ b/net/netfilter/xt_CONNMARK.c
@@ -26,7 +26,7 @@
 #include <net/checksum.h>
 
 MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("IP tables CONNMARK matching module");
+MODULE_DESCRIPTION("Xtables: connection mark modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_CONNMARK");
 MODULE_ALIAS("ip6t_CONNMARK");
diff --git a/net/netfilter/xt_CONNSECMARK.c b/net/netfilter/xt_CONNSECMARK.c
index 024106b..1faa913 100644
--- a/net/netfilter/xt_CONNSECMARK.c
+++ b/net/netfilter/xt_CONNSECMARK.c
@@ -26,7 +26,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@redhat.com>");
-MODULE_DESCRIPTION("ip[6]tables CONNSECMARK module");
+MODULE_DESCRIPTION("Xtables: target for copying between connection and security mark");
 MODULE_ALIAS("ipt_CONNSECMARK");
 MODULE_ALIAS("ip6t_CONNSECMARK");
 
diff --git a/net/netfilter/xt_DSCP.c b/net/netfilter/xt_DSCP.c
index 3d216d6..97efd74 100644
--- a/net/netfilter/xt_DSCP.c
+++ b/net/netfilter/xt_DSCP.c
@@ -21,7 +21,7 @@
 #include <linux/netfilter_ipv4/ipt_TOS.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("x_tables DSCP modification module");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field modification");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_DSCP");
 MODULE_ALIAS("ip6t_DSCP");
diff --git a/net/netfilter/xt_MARK.c b/net/netfilter/xt_MARK.c
index 1c3fb75..f9ce20b 100644
--- a/net/netfilter/xt_MARK.c
+++ b/net/netfilter/xt_MARK.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("ip[6]tables MARK modification module");
+MODULE_DESCRIPTION("Xtables: packet mark modification");
 MODULE_ALIAS("ipt_MARK");
 MODULE_ALIAS("ip6t_MARK");
 
diff --git a/net/netfilter/xt_NFLOG.c b/net/netfilter/xt_NFLOG.c
index 866facf..19ae8ef 100644
--- a/net/netfilter/xt_NFLOG.c
+++ b/net/netfilter/xt_NFLOG.c
@@ -15,7 +15,7 @@
 #include <net/netfilter/nf_log.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("x_tables NFLOG target");
+MODULE_DESCRIPTION("Xtables: packet logging to netlink using NFLOG");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NFLOG");
 MODULE_ALIAS("ip6t_NFLOG");
diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index 16b57c2..beb24d1 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter/xt_NFQUEUE.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("[ip,ip6,arp]_tables NFQUEUE target");
+MODULE_DESCRIPTION("Xtables: packet forwarding to netlink");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NFQUEUE");
 MODULE_ALIAS("ip6t_NFQUEUE");
diff --git a/net/netfilter/xt_NOTRACK.c b/net/netfilter/xt_NOTRACK.c
index 95712e4..6c9de61 100644
--- a/net/netfilter/xt_NOTRACK.c
+++ b/net/netfilter/xt_NOTRACK.c
@@ -7,6 +7,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <net/netfilter/nf_conntrack.h>
 
+MODULE_DESCRIPTION("Xtables: Disabling connection tracking for packets");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_NOTRACK");
 MODULE_ALIAS("ip6t_NOTRACK");
diff --git a/net/netfilter/xt_RATEEST.c b/net/netfilter/xt_RATEEST.c
index c008883..c5ba525 100644
--- a/net/netfilter/xt_RATEEST.c
+++ b/net/netfilter/xt_RATEEST.c
@@ -197,7 +197,7 @@ static void __exit xt_rateest_tg_fini(void)
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("xtables rate estimator");
+MODULE_DESCRIPTION("Xtables: packet rate estimator");
 MODULE_ALIAS("ipt_RATEEST");
 MODULE_ALIAS("ip6t_RATEEST");
 module_init(xt_rateest_tg_init);
diff --git a/net/netfilter/xt_SECMARK.c b/net/netfilter/xt_SECMARK.c
index 7d5439c..b11b3ec 100644
--- a/net/netfilter/xt_SECMARK.c
+++ b/net/netfilter/xt_SECMARK.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("James Morris <jmorris@redhat.com>");
-MODULE_DESCRIPTION("ip[6]tables SECMARK modification module");
+MODULE_DESCRIPTION("Xtables: packet security mark modification");
 MODULE_ALIAS("ipt_SECMARK");
 MODULE_ALIAS("ip6t_SECMARK");
 
diff --git a/net/netfilter/xt_TCPMSS.c b/net/netfilter/xt_TCPMSS.c
index a1bc77f..60e3767 100644
--- a/net/netfilter/xt_TCPMSS.c
+++ b/net/netfilter/xt_TCPMSS.c
@@ -24,7 +24,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("x_tables TCP MSS modification module");
+MODULE_DESCRIPTION("Xtables: TCP Maximum Segment Size (MSS) adjustment");
 MODULE_ALIAS("ipt_TCPMSS");
 MODULE_ALIAS("ip6t_TCPMSS");
 
diff --git a/net/netfilter/xt_TCPOPTSTRIP.c b/net/netfilter/xt_TCPOPTSTRIP.c
index 43d6ac2..3b2aa56 100644
--- a/net/netfilter/xt_TCPOPTSTRIP.c
+++ b/net/netfilter/xt_TCPOPTSTRIP.c
@@ -141,7 +141,7 @@ static void __exit tcpoptstrip_tg_exit(void)
 module_init(tcpoptstrip_tg_init);
 module_exit(tcpoptstrip_tg_exit);
 MODULE_AUTHOR("Sven Schnelle <svens@bitebene.org>, Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("netfilter \"TCPOPTSTRIP\" target module");
+MODULE_DESCRIPTION("Xtables: TCP option stripping");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TCPOPTSTRIP");
 MODULE_ALIAS("ip6t_TCPOPTSTRIP");
diff --git a/net/netfilter/xt_TRACE.c b/net/netfilter/xt_TRACE.c
index 219b9d2..30dab79 100644
--- a/net/netfilter/xt_TRACE.c
+++ b/net/netfilter/xt_TRACE.c
@@ -5,6 +5,7 @@
 
 #include <linux/netfilter/x_tables.h>
 
+MODULE_DESCRIPTION("Xtables: packet flow tracing");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_TRACE");
 MODULE_ALIAS("ip6t_TRACE");
diff --git a/net/netfilter/xt_comment.c b/net/netfilter/xt_comment.c
index 4539d43..89f4736 100644
--- a/net/netfilter/xt_comment.c
+++ b/net/netfilter/xt_comment.c
@@ -10,7 +10,7 @@
 #include <linux/netfilter/xt_comment.h>
 
 MODULE_AUTHOR("Brad Fisher <brad@info-link.net>");
-MODULE_DESCRIPTION("iptables comment match module");
+MODULE_DESCRIPTION("Xtables: No-op match which can be tagged with a comment");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_comment");
 MODULE_ALIAS("ip6t_comment");
diff --git a/net/netfilter/xt_connbytes.c b/net/netfilter/xt_connbytes.c
index 7d4940a..b15e7e2 100644
--- a/net/netfilter/xt_connbytes.c
+++ b/net/netfilter/xt_connbytes.c
@@ -12,7 +12,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables match for matching number of pkts/bytes per connection");
+MODULE_DESCRIPTION("Xtables: Number of packets/bytes per connection matching");
 MODULE_ALIAS("ipt_connbytes");
 MODULE_ALIAS("ip6t_connbytes");
 
diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index 6a9e2a3..e00ecd9 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -309,7 +309,7 @@ static void __exit connlimit_mt_exit(void)
 module_init(connlimit_mt_init);
 module_exit(connlimit_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("netfilter xt_connlimit match module");
+MODULE_DESCRIPTION("Xtables: Number of connections matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connlimit");
 MODULE_ALIAS("ip6t_connlimit");
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 55c6235..aaa1b96 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -28,7 +28,7 @@
 #include <linux/netfilter/xt_connmark.h>
 
 MODULE_AUTHOR("Henrik Nordstrom <hno@marasystems.com>");
-MODULE_DESCRIPTION("IP tables connmark match module");
+MODULE_DESCRIPTION("Xtables: connection mark match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_connmark");
 MODULE_ALIAS("ip6t_connmark");
diff --git a/net/netfilter/xt_conntrack.c b/net/netfilter/xt_conntrack.c
index dc9e737..e92190e 100644
--- a/net/netfilter/xt_conntrack.c
+++ b/net/netfilter/xt_conntrack.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("iptables connection tracking match module");
+MODULE_DESCRIPTION("Xtables: connection tracking state match");
 MODULE_ALIAS("ipt_conntrack");
 MODULE_ALIAS("ip6t_conntrack");
 
diff --git a/net/netfilter/xt_dccp.c b/net/netfilter/xt_dccp.c
index ab2f7e9..667f45e 100644
--- a/net/netfilter/xt_dccp.c
+++ b/net/netfilter/xt_dccp.c
@@ -22,7 +22,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("Match for DCCP protocol packets");
+MODULE_DESCRIPTION("Xtables: DCCP protocol packet match");
 MODULE_ALIAS("ipt_dccp");
 MODULE_ALIAS("ip6t_dccp");
 
diff --git a/net/netfilter/xt_dscp.c b/net/netfilter/xt_dscp.c
index 834e437..26f4aab 100644
--- a/net/netfilter/xt_dscp.c
+++ b/net/netfilter/xt_dscp.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter_ipv4/ipt_tos.h>
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("x_tables DSCP/tos matching module");
+MODULE_DESCRIPTION("Xtables: DSCP/TOS field match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_dscp");
 MODULE_ALIAS("ip6t_dscp");
diff --git a/net/netfilter/xt_esp.c b/net/netfilter/xt_esp.c
index d7c90ac..71c7c37 100644
--- a/net/netfilter/xt_esp.c
+++ b/net/netfilter/xt_esp.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Yon Uriarte <yon@astaro.de>");
-MODULE_DESCRIPTION("x_tables ESP SPI match module");
+MODULE_DESCRIPTION("Xtables: IPsec-ESP packet match");
 MODULE_ALIAS("ipt_esp");
 MODULE_ALIAS("ip6t_esp");
 
diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index c35d220..d479ca9 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -35,7 +35,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
-MODULE_DESCRIPTION("iptables match for limiting per hash-bucket");
+MODULE_DESCRIPTION("Xtables: per hash-bucket rate-limit match");
 MODULE_ALIAS("ipt_hashlimit");
 MODULE_ALIAS("ip6t_hashlimit");
 
diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
index 5d063e5..dada290 100644
--- a/net/netfilter/xt_helper.c
+++ b/net/netfilter/xt_helper.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Josefsson <gandalf@netfilter.org>");
-MODULE_DESCRIPTION("iptables helper match module");
+MODULE_DESCRIPTION("Xtables: Related connection matching");
 MODULE_ALIAS("ipt_helper");
 MODULE_ALIAS("ip6t_helper");
 
diff --git a/net/netfilter/xt_length.c b/net/netfilter/xt_length.c
index ea54578..b8640f9 100644
--- a/net/netfilter/xt_length.c
+++ b/net/netfilter/xt_length.c
@@ -15,7 +15,7 @@
 #include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("James Morris <jmorris@intercode.com.au>");
-MODULE_DESCRIPTION("IP tables packet length matching module");
+MODULE_DESCRIPTION("Xtables: Packet length (Layer3,4,5) match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_length");
 MODULE_ALIAS("ip6t_length");
diff --git a/net/netfilter/xt_limit.c b/net/netfilter/xt_limit.c
index 2ef0dbf..aad9ab8 100644
--- a/net/netfilter/xt_limit.c
+++ b/net/netfilter/xt_limit.c
@@ -16,7 +16,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Herve Eychenne <rv@wallfire.org>");
-MODULE_DESCRIPTION("iptables rate limit match");
+MODULE_DESCRIPTION("Xtables: rate-limit match");
 MODULE_ALIAS("ipt_limit");
 MODULE_ALIAS("ip6t_limit");
 
diff --git a/net/netfilter/xt_mac.c b/net/netfilter/xt_mac.c
index 7d89863..b3e96a0 100644
--- a/net/netfilter/xt_mac.c
+++ b/net/netfilter/xt_mac.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("iptables mac matching module");
+MODULE_DESCRIPTION("Xtables: MAC address match");
 MODULE_ALIAS("ipt_mac");
 MODULE_ALIAS("ip6t_mac");
 
diff --git a/net/netfilter/xt_mark.c b/net/netfilter/xt_mark.c
index 5cc8cc5..9f78f61 100644
--- a/net/netfilter/xt_mark.c
+++ b/net/netfilter/xt_mark.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("iptables mark matching module");
+MODULE_DESCRIPTION("Xtables: packet mark match");
 MODULE_ALIAS("ipt_mark");
 MODULE_ALIAS("ip6t_mark");
 
diff --git a/net/netfilter/xt_multiport.c b/net/netfilter/xt_multiport.c
index d03cc37..31daa81 100644
--- a/net/netfilter/xt_multiport.c
+++ b/net/netfilter/xt_multiport.c
@@ -22,7 +22,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Netfilter Core Team <coreteam@netfilter.org>");
-MODULE_DESCRIPTION("x_tables multiple port match module");
+MODULE_DESCRIPTION("Xtables: multiple port matching for TCP, UDP, UDP-Lite, SCTP and DCCP");
 MODULE_ALIAS("ipt_multiport");
 MODULE_ALIAS("ip6t_multiport");
 
diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
index 4222fa2..d382f9c 100644
--- a/net/netfilter/xt_owner.c
+++ b/net/netfilter/xt_owner.c
@@ -205,7 +205,7 @@ static void __exit owner_mt_exit(void)
 module_init(owner_mt_init);
 module_exit(owner_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("netfilter \"owner\" match module");
+MODULE_DESCRIPTION("Xtables: socket owner matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_owner");
 MODULE_ALIAS("ip6t_owner");
diff --git a/net/netfilter/xt_physdev.c b/net/netfilter/xt_physdev.c
index 678b683..4ec1094 100644
--- a/net/netfilter/xt_physdev.c
+++ b/net/netfilter/xt_physdev.c
@@ -16,7 +16,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Bart De Schuymer <bdschuym@pandora.be>");
-MODULE_DESCRIPTION("iptables bridge physical device match module");
+MODULE_DESCRIPTION("Xtables: Bridge physical device match");
 MODULE_ALIAS("ipt_physdev");
 MODULE_ALIAS("ip6t_physdev");
 
diff --git a/net/netfilter/xt_pkttype.c b/net/netfilter/xt_pkttype.c
index cbcb8ea..7936f7e 100644
--- a/net/netfilter/xt_pkttype.c
+++ b/net/netfilter/xt_pkttype.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Michal Ludvig <michal@logix.cz>");
-MODULE_DESCRIPTION("IP tables match to match on linklayer packet type");
+MODULE_DESCRIPTION("Xtables: link layer packet type match");
 MODULE_ALIAS("ipt_pkttype");
 MODULE_ALIAS("ip6t_pkttype");
 
diff --git a/net/netfilter/xt_policy.c b/net/netfilter/xt_policy.c
index 47c2e43..9e918ad 100644
--- a/net/netfilter/xt_policy.c
+++ b/net/netfilter/xt_policy.c
@@ -18,7 +18,7 @@
 #include <linux/netfilter/x_tables.h>
 
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("Xtables IPsec policy matching module");
+MODULE_DESCRIPTION("Xtables: IPsec policy match");
 MODULE_LICENSE("GPL");
 
 static inline bool
diff --git a/net/netfilter/xt_quota.c b/net/netfilter/xt_quota.c
index 887874b..3b021d0 100644
--- a/net/netfilter/xt_quota.c
+++ b/net/netfilter/xt_quota.c
@@ -11,6 +11,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Sam Johnston <samj@samj.net>");
+MODULE_DESCRIPTION("Xtables: countdown quota match");
 MODULE_ALIAS("ipt_quota");
 MODULE_ALIAS("ip6t_quota");
 
diff --git a/net/netfilter/xt_realm.c b/net/netfilter/xt_realm.c
index 63289b4..7df1627 100644
--- a/net/netfilter/xt_realm.c
+++ b/net/netfilter/xt_realm.c
@@ -18,7 +18,7 @@
 
 MODULE_AUTHOR("Sampsa Ranta <sampsa@netsonic.fi>");
 MODULE_LICENSE("GPL");
-MODULE_DESCRIPTION("X_tables realm match");
+MODULE_DESCRIPTION("Xtables: Routing realm match");
 MODULE_ALIAS("ipt_realm");
 
 static bool
diff --git a/net/netfilter/xt_sctp.c b/net/netfilter/xt_sctp.c
index 1c8a4ee..b718ec6 100644
--- a/net/netfilter/xt_sctp.c
+++ b/net/netfilter/xt_sctp.c
@@ -11,7 +11,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Kiran Kumar Immidi");
-MODULE_DESCRIPTION("Match for SCTP protocol packets");
+MODULE_DESCRIPTION("Xtables: SCTP protocol packet match");
 MODULE_ALIAS("ipt_sctp");
 MODULE_ALIAS("ip6t_sctp");
 
diff --git a/net/netfilter/xt_statistic.c b/net/netfilter/xt_statistic.c
index fb16648..4313308 100644
--- a/net/netfilter/xt_statistic.c
+++ b/net/netfilter/xt_statistic.c
@@ -18,7 +18,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Patrick McHardy <kaber@trash.net>");
-MODULE_DESCRIPTION("xtables statistical match module");
+MODULE_DESCRIPTION("Xtables: statistics-based matching (\"Nth\", random)");
 MODULE_ALIAS("ipt_statistic");
 MODULE_ALIAS("ip6t_statistic");
 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index aff7a11..72f694d 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -16,7 +16,7 @@
 #include <linux/textsearch.h>
 
 MODULE_AUTHOR("Pablo Neira Ayuso <pablo@eurodev.net>");
-MODULE_DESCRIPTION("IP tables string match module");
+MODULE_DESCRIPTION("Xtables: string-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_string");
 MODULE_ALIAS("ip6t_string");
diff --git a/net/netfilter/xt_tcpmss.c b/net/netfilter/xt_tcpmss.c
index 2a3e4c3..d7a5b27 100644
--- a/net/netfilter/xt_tcpmss.c
+++ b/net/netfilter/xt_tcpmss.c
@@ -20,7 +20,7 @@
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Marc Boucher <marc@mbsi.ca>");
-MODULE_DESCRIPTION("iptables TCP MSS match module");
+MODULE_DESCRIPTION("Xtables: TCP MSS match");
 MODULE_ALIAS("ipt_tcpmss");
 MODULE_ALIAS("ip6t_tcpmss");
 
diff --git a/net/netfilter/xt_tcpudp.c b/net/netfilter/xt_tcpudp.c
index 6be5f2d..4fa3b66 100644
--- a/net/netfilter/xt_tcpudp.c
+++ b/net/netfilter/xt_tcpudp.c
@@ -10,7 +10,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 
-MODULE_DESCRIPTION("x_tables match for TCP and UDP(-Lite), supports IPv4 and IPv6");
+MODULE_DESCRIPTION("Xtables: TCP, UDP and UDP-Lite match");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("xt_tcp");
 MODULE_ALIAS("xt_udp");
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 96da93c..e9a8794 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -264,7 +264,7 @@ static void __exit time_mt_exit(void)
 module_init(time_mt_init);
 module_exit(time_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("netfilter time match");
+MODULE_DESCRIPTION("Xtables: time-based matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_time");
 MODULE_ALIAS("ip6t_time");
diff --git a/net/netfilter/xt_u32.c b/net/netfilter/xt_u32.c
index 3d8f5b3..9b8ed39 100644
--- a/net/netfilter/xt_u32.c
+++ b/net/netfilter/xt_u32.c
@@ -130,7 +130,7 @@ static void __exit u32_mt_exit(void)
 module_init(u32_mt_init);
 module_exit(u32_mt_exit);
 MODULE_AUTHOR("Jan Engelhardt <jengelh@computergmbh.de>");
-MODULE_DESCRIPTION("netfilter u32 match module");
+MODULE_DESCRIPTION("Xtables: arbitrary byte matching");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("ipt_u32");
 MODULE_ALIAS("ip6t_u32");
