From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 03/**] Remove unneeded NULL fields
Date: Tue, 24 Jul 2007 12:18:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241217160.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org




Remove the .next=NULL field. This is automatically initialized to zero.
I've kept .print=NULL and .save=NULL so it stands out
(since iptables will do the print/save then).

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_TRACE.c      |    2 +-
 extensions/libip6t_state.c      |    1 -
 extensions/libipt_CLASSIFY.c    |    1 -
 extensions/libipt_CLUSTERIP.c   |    1 -
 extensions/libipt_CONNSECMARK.c |    1 -
 extensions/libipt_DNAT.c        |    1 -
 extensions/libipt_DSCP.c        |    1 -
 extensions/libipt_ECN.c         |    1 -
 extensions/libipt_MARK.c        |    2 --
 extensions/libipt_MIRROR.c      |    1 -
 extensions/libipt_NETMAP.c      |    1 -
 extensions/libipt_REDIRECT.c    |    1 -
 extensions/libipt_REJECT.c      |    1 -
 extensions/libipt_SAME.c        |    1 -
 extensions/libipt_SNAT.c        |    1 -
 extensions/libipt_TOS.c         |    1 -
 extensions/libipt_TRACE.c       |    2 +-
 extensions/libipt_ULOG.c        |    1 -
 extensions/libipt_addrtype.c    |    1 -
 extensions/libipt_ah.c          |    1 -
 extensions/libipt_connbytes.c   |    1 -
 extensions/libipt_connrate.c    |    1 -
 extensions/libipt_conntrack.c   |    1 -
 extensions/libipt_helper.c      |    1 -
 extensions/libipt_icmp.c        |    1 -
 extensions/libipt_iprange.c     |    1 -
 extensions/libipt_owner.c       |    1 -
 extensions/libipt_recent.c      |    1 -
 extensions/libipt_state.c       |    1 -
 extensions/libipt_tos.c         |    1 -
 extensions/libipt_ttl.c         |    1 -
 extensions/libipt_unclean.c     |    1 -
 extensions/libxt_NFQUEUE.c      |    2 --
 extensions/libxt_SECMARK.c      |    2 --
 extensions/libxt_TCPMSS.c       |    2 --
 extensions/libxt_comment.c      |    2 --
 extensions/libxt_dscp.c         |    2 --
 extensions/libxt_esp.c          |    2 --
 extensions/libxt_length.c       |    2 --
 extensions/libxt_limit.c        |    2 --
 extensions/libxt_mac.c          |    2 --
 extensions/libxt_mark.c         |    2 --
 extensions/libxt_multiport.c    |    4 ----
 extensions/libxt_physdev.c      |    2 --
 extensions/libxt_pkttype.c      |    2 --
 extensions/libxt_quota.c        |    2 --
 extensions/libxt_standard.c     |    2 --
 extensions/libxt_tcp.c          |    2 --
 extensions/libxt_tcpmss.c       |    2 --
 extensions/libxt_udp.c          |    2 --
 50 files changed, 2 insertions(+), 71 deletions(-)

Index: iptables/extensions/libip6t_TRACE.c
===================================================================
--- iptables.orig/extensions/libip6t_TRACE.c
+++ iptables/extensions/libip6t_TRACE.c
@@ -43,7 +43,7 @@ final_check(unsigned int flags)
 
 static
 struct ip6tables_target trace 
-= {	.next = NULL,
+= {
 	.name = "TRACE",
 	.version = IPTABLES_VERSION,
 	.size = IP6T_ALIGN(0),
Index: iptables/extensions/libip6t_state.c
===================================================================
--- iptables.orig/extensions/libip6t_state.c
+++ iptables/extensions/libip6t_state.c
@@ -144,7 +144,6 @@ static void save(const void *ip, const s
 }
 
 static struct ip6tables_match state = { 
-	.next		= NULL,
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ipt_state_info)),
Index: iptables/extensions/libipt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libipt_CLASSIFY.c
+++ iptables/extensions/libipt_CLASSIFY.c
@@ -109,7 +109,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target classify = { 
-	.next		= NULL,
 	.name		= "CLASSIFY",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_classify_target_info)),
Index: iptables/extensions/libipt_CLUSTERIP.c
===================================================================
--- iptables.orig/extensions/libipt_CLUSTERIP.c
+++ iptables/extensions/libipt_CLUSTERIP.c
@@ -248,7 +248,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target clusterip = { 
-	.next		= NULL,
 	.name		= "CLUSTERIP",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
Index: iptables/extensions/libipt_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libipt_CONNSECMARK.c
+++ iptables/extensions/libipt_CONNSECMARK.c
@@ -106,7 +106,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_target connsecmark = {
-	.next		= NULL,
 	.name		= "CONNSECMARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
Index: iptables/extensions/libipt_DNAT.c
===================================================================
--- iptables.orig/extensions/libipt_DNAT.c
+++ iptables/extensions/libipt_DNAT.c
@@ -249,7 +249,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target dnat = { 
-	.next		= NULL,
 	.name		= "DNAT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
Index: iptables/extensions/libipt_DSCP.c
===================================================================
--- iptables.orig/extensions/libipt_DSCP.c
+++ iptables/extensions/libipt_DSCP.c
@@ -144,7 +144,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target dscp = { 
-	.next		= NULL,
 	.name		= "DSCP",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_DSCP_info)),
Index: iptables/extensions/libipt_ECN.c
===================================================================
--- iptables.orig/extensions/libipt_ECN.c
+++ iptables/extensions/libipt_ECN.c
@@ -165,7 +165,6 @@ save(const void *ip, const struct xt_ent
 
 static
 struct iptables_target ecn = { 
-	.next		= NULL,
 	.name		= "ECN",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
Index: iptables/extensions/libipt_MARK.c
===================================================================
--- iptables.orig/extensions/libipt_MARK.c
+++ iptables/extensions/libipt_MARK.c
@@ -187,7 +187,6 @@ save_v1(const void *ip, const struct xt_
 
 static
 struct iptables_target mark_v0 = {
-	.next		= NULL,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 0,
@@ -204,7 +203,6 @@ struct iptables_target mark_v0 = {
 
 static
 struct iptables_target mark_v1 = {
-	.next		= NULL,
 	.name		= "MARK",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
Index: iptables/extensions/libipt_MIRROR.c
===================================================================
--- iptables.orig/extensions/libipt_MIRROR.c
+++ iptables/extensions/libipt_MIRROR.c
@@ -42,7 +42,6 @@ final_check(unsigned int flags)
 }
 
 static struct iptables_target mirror = {
-	.next		= NULL,
 	.name		= "MIRROR",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
Index: iptables/extensions/libipt_NETMAP.c
===================================================================
--- iptables.orig/extensions/libipt_NETMAP.c
+++ iptables/extensions/libipt_NETMAP.c
@@ -178,7 +178,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target target_module = {
-	.next		= NULL,
 	.name		= MODULENAME,
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
Index: iptables/extensions/libipt_REDIRECT.c
===================================================================
--- iptables.orig/extensions/libipt_REDIRECT.c
+++ iptables/extensions/libipt_REDIRECT.c
@@ -170,7 +170,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target redir = { 
-	.next		= NULL,
 	.name		= "REDIRECT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
Index: iptables/extensions/libipt_REJECT.c
===================================================================
--- iptables.orig/extensions/libipt_REJECT.c
+++ iptables/extensions/libipt_REJECT.c
@@ -169,7 +169,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_target reject = { 
-	.next		= NULL,
 	.name		= "REJECT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_reject_info)),
Index: iptables/extensions/libipt_SAME.c
===================================================================
--- iptables.orig/extensions/libipt_SAME.c
+++ iptables/extensions/libipt_SAME.c
@@ -216,7 +216,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target same = {
-	.next		= NULL,
 	.name		= "SAME",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_same_info)),
Index: iptables/extensions/libipt_SNAT.c
===================================================================
--- iptables.orig/extensions/libipt_SNAT.c
+++ iptables/extensions/libipt_SNAT.c
@@ -251,7 +251,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target snat = {
-	.next		= NULL,
 	.name		= "SNAT",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
Index: iptables/extensions/libipt_TOS.c
===================================================================
--- iptables.orig/extensions/libipt_TOS.c
+++ iptables/extensions/libipt_TOS.c
@@ -154,7 +154,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_target tos = {
-	.next		= NULL,
 	.name		= "TOS",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_target_info)),
Index: iptables/extensions/libipt_TRACE.c
===================================================================
--- iptables.orig/extensions/libipt_TRACE.c
+++ iptables/extensions/libipt_TRACE.c
@@ -43,7 +43,7 @@ final_check(unsigned int flags)
 
 static
 struct iptables_target trace 
-= {	.next = NULL,
+= {
 	.name = "TRACE",
 	.version = IPTABLES_VERSION,
 	.size = IPT_ALIGN(0),
Index: iptables/extensions/libipt_ULOG.c
===================================================================
--- iptables.orig/extensions/libipt_ULOG.c
+++ iptables/extensions/libipt_ULOG.c
@@ -193,7 +193,6 @@ print(const void *ip,
 }
 
 static struct iptables_target ulog = {
-	.next		= NULL,
 	.name		= "ULOG",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ulog_info)),
Index: iptables/extensions/libipt_addrtype.c
===================================================================
--- iptables.orig/extensions/libipt_addrtype.c
+++ iptables/extensions/libipt_addrtype.c
@@ -187,7 +187,6 @@ static struct option opts[] = {
 
 static
 struct iptables_match addrtype = {
-	.next 		= NULL,
 	.name 		= "addrtype",
 	.version 	= IPTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
Index: iptables/extensions/libipt_ah.c
===================================================================
--- iptables.orig/extensions/libipt_ah.c
+++ iptables/extensions/libipt_ah.c
@@ -169,7 +169,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_match ah = { 
-	.next 		= NULL,
 	.name 		= "ah",
 	.version 	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ah)),
Index: iptables/extensions/libipt_connbytes.c
===================================================================
--- iptables.orig/extensions/libipt_connbytes.c
+++ iptables/extensions/libipt_connbytes.c
@@ -186,7 +186,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_match state = {
-	.next 		= NULL,
 	.name 		= "connbytes",
 	.version 	= IPTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_connbytes_info)),
Index: iptables/extensions/libipt_connrate.c
===================================================================
--- iptables.orig/extensions/libipt_connrate.c
+++ iptables/extensions/libipt_connrate.c
@@ -160,7 +160,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_match state = { 
-	.next 		= NULL,
 	.name		= "connrate",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_connrate_info)),
Index: iptables/extensions/libipt_conntrack.c
===================================================================
--- iptables.orig/extensions/libipt_conntrack.c
+++ iptables/extensions/libipt_conntrack.c
@@ -505,7 +505,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_match conntrack = { 
-	.next 		= NULL,
 	.name		= "conntrack",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
Index: iptables/extensions/libipt_helper.c
===================================================================
--- iptables.orig/extensions/libipt_helper.c
+++ iptables/extensions/libipt_helper.c
@@ -83,7 +83,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_match helper = { 
-	.next		= NULL,
 	.name		= "helper",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_helper_info)),
Index: iptables/extensions/libipt_icmp.c
===================================================================
--- iptables.orig/extensions/libipt_icmp.c
+++ iptables/extensions/libipt_icmp.c
@@ -287,7 +287,6 @@ static void final_check(unsigned int fla
 }
 
 static struct iptables_match icmp = { 
-	.next		= NULL,
 	.name		= "icmp",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_icmp)),
Index: iptables/extensions/libipt_iprange.c
===================================================================
--- iptables.orig/extensions/libipt_iprange.c
+++ iptables/extensions/libipt_iprange.c
@@ -165,7 +165,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_match iprange = { 
-	.next		= NULL,
 	.name		= "iprange",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_iprange_info)),
Index: iptables/extensions/libipt_owner.c
===================================================================
--- iptables.orig/extensions/libipt_owner.c
+++ iptables/extensions/libipt_owner.c
@@ -231,7 +231,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_match owner = { 
-	.next		= NULL,
 	.name		= "owner",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_owner_info)),
Index: iptables/extensions/libipt_recent.c
===================================================================
--- iptables.orig/extensions/libipt_recent.c
+++ iptables/extensions/libipt_recent.c
@@ -220,7 +220,6 @@ save(const void *ip, const struct xt_ent
 
 /* Structure for iptables to use to communicate with module */
 static struct iptables_match recent = { 
-    .next          = NULL,
     .name          = "recent",
     .version       = IPTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_recent_info)),
Index: iptables/extensions/libipt_state.c
===================================================================
--- iptables.orig/extensions/libipt_state.c
+++ iptables/extensions/libipt_state.c
@@ -144,7 +144,6 @@ static void save(const void *ip, const s
 }
 
 static struct iptables_match state = { 
-	.next		= NULL,
 	.name		= "state",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_state_info)),
Index: iptables/extensions/libipt_tos.c
===================================================================
--- iptables.orig/extensions/libipt_tos.c
+++ iptables/extensions/libipt_tos.c
@@ -153,7 +153,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct iptables_match tos = { 
-	.next		= NULL,
 	.name		= "tos",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_tos_info)),
Index: iptables/extensions/libipt_ttl.c
===================================================================
--- iptables.orig/extensions/libipt_ttl.c
+++ iptables/extensions/libipt_ttl.c
@@ -152,7 +152,6 @@ static struct option opts[] = {
 };
 
 static struct iptables_match ttl = {
-	.next		= NULL,
 	.name		= "ttl",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
Index: iptables/extensions/libipt_unclean.c
===================================================================
--- iptables.orig/extensions/libipt_unclean.c
+++ iptables/extensions/libipt_unclean.c
@@ -35,7 +35,6 @@ static void final_check(unsigned int fla
 
 static
 struct iptables_match unclean = { 
-	.next		= NULL,
 	.name		= "unclean",
 	.version	= IPTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -94,7 +94,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_target nfqueue = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "NFQUEUE",
 	.version	= IPTABLES_VERSION,
@@ -110,7 +109,6 @@ static struct xtables_target nfqueue = {
 };
 
 static struct xtables_target nfqueue6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "NFQUEUE",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -104,7 +104,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_target secmark = {
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "SECMARK",
 	.version	= IPTABLES_VERSION,
@@ -121,7 +120,6 @@ static struct xtables_target secmark = {
 };
 
 static struct xtables_target secmark6 = {
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "SECMARK",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -140,7 +140,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_target mss = {
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "TCPMSS",
 	.version	= IPTABLES_VERSION,
@@ -156,7 +155,6 @@ static struct xtables_target mss = {
 };
 
 static struct xtables_target mss6 = {
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "TCPMSS",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_comment.c
===================================================================
--- iptables.orig/extensions/libxt_comment.c
+++ iptables/extensions/libxt_comment.c
@@ -100,7 +100,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_match comment = {
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "comment",
 	.version	= IPTABLES_VERSION,
@@ -115,7 +114,6 @@ static struct xtables_match comment = {
 };
 
 static struct xtables_match comment6 = {
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "comment",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_dscp.c
===================================================================
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -153,7 +153,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_match dscp = { 
-	.next 		= NULL,
 	.family		= AF_INET,
 	.name 		= "dscp",
 	.version 	= IPTABLES_VERSION,
@@ -168,7 +167,6 @@ static struct xtables_match dscp = { 
 };
 
 static struct xtables_match dscp6 = { 
-	.next 		= NULL,
 	.family		= AF_INET6,
 	.name 		= "dscp",
 	.version 	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -165,7 +165,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match esp = { 
-	.next 		= NULL,
 	.family		= AF_INET,
 	.name 		= "esp",
 	.version 	= IPTABLES_VERSION,
@@ -181,7 +180,6 @@ static struct xtables_match esp = { 
 };
 
 static struct xtables_match esp6 = { 
-	.next 		= NULL,
 	.family		= AF_INET6,
 	.name 		= "esp",
 	.version 	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_length.c
===================================================================
--- iptables.orig/extensions/libxt_length.c
+++ iptables/extensions/libxt_length.c
@@ -132,7 +132,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_match length = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
@@ -147,7 +146,6 @@ static struct xtables_match length = { 
 };
 
 static struct xtables_match length6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "length",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -176,7 +176,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match limit = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
@@ -192,7 +191,6 @@ static struct xtables_match limit = { 
 };
 
 static struct xtables_match limit6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "limit",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_mac.c
===================================================================
--- iptables.orig/extensions/libxt_mac.c
+++ iptables/extensions/libxt_mac.c
@@ -121,7 +121,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match mac = { 
-	.next		= NULL,
 	.family		= AF_INET,
  	.name		= "mac",
 	.version	= IPTABLES_VERSION,
@@ -136,7 +135,6 @@ static struct xtables_match mac = { 
 };
 
 static struct xtables_match mac6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
  	.name		= "mac",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_mark.c
===================================================================
--- iptables.orig/extensions/libxt_mark.c
+++ iptables/extensions/libxt_mark.c
@@ -105,7 +105,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_match mark = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "mark",
 	.version	= IPTABLES_VERSION,
@@ -120,7 +119,6 @@ static struct xtables_match mark = { 
 };
 
 static struct xtables_match mark6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "mark",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -520,7 +520,6 @@ static void save6_v1(const void *ip_void
 }
 
 static struct xtables_match multiport = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "multiport",
 	.revision	= 0,
@@ -537,7 +536,6 @@ static struct xtables_match multiport = 
 };
 
 static struct xtables_match multiport6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "multiport",
 	.revision	= 0,
@@ -554,7 +552,6 @@ static struct xtables_match multiport6 =
 };
 
 static struct xtables_match multiport_v1 = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
@@ -571,7 +568,6 @@ static struct xtables_match multiport_v1
 };
 
 static struct xtables_match multiport6_v1 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -173,7 +173,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match physdev = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "physdev",
 	.version	= IPTABLES_VERSION,
@@ -189,7 +188,6 @@ static struct xtables_match physdev = { 
 };
 
 static struct xtables_match physdev6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "physdev",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_pkttype.c
===================================================================
--- iptables.orig/extensions/libxt_pkttype.c
+++ iptables/extensions/libxt_pkttype.c
@@ -148,7 +148,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match pkttype = {
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "pkttype",
 	.version	= IPTABLES_VERSION,
@@ -163,7 +162,6 @@ static struct xtables_match pkttype = {
 };
 
 static struct xtables_match pkttype6 = {
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "pkttype",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
@@ -86,7 +86,6 @@ final_check(unsigned int flags)
 }
 
 struct xtables_match quota = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
@@ -101,7 +100,6 @@ struct xtables_match quota = { 
 };
 
 struct xtables_match quota6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "quota",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -49,7 +49,6 @@ save(const void *ip, const struct xt_ent
 
 static
 struct xtables_target standard = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "standard",
 	.version	= IPTABLES_VERSION,
@@ -66,7 +65,6 @@ struct xtables_target standard = { 
 
 static
 struct xtables_target standard6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "standard",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -395,7 +395,6 @@ static void save(const void *ip, const s
 }
 
 static struct xtables_match tcp = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "tcp",
 	.version	= IPTABLES_VERSION,
@@ -411,7 +410,6 @@ static struct xtables_match tcp = { 
 };
 
 static struct xtables_match tcp6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "tcp",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_tcpmss.c
===================================================================
--- iptables.orig/extensions/libxt_tcpmss.c
+++ iptables/extensions/libxt_tcpmss.c
@@ -133,7 +133,6 @@ save(const void *ip, const struct xt_ent
 }
 
 static struct xtables_match tcpmss = {
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "tcpmss",
 	.version	= IPTABLES_VERSION,
@@ -148,7 +147,6 @@ static struct xtables_match tcpmss = {
 };
 
 static struct xtables_match tcpmss6 = {
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "tcpmss",
 	.version	= IPTABLES_VERSION,
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -209,7 +209,6 @@ static void save(const void *ip, const s
 
 static
 struct xtables_match udp = { 
-	.next		= NULL,
 	.family		= AF_INET,
 	.name		= "udp",
 	.version	= IPTABLES_VERSION,
@@ -226,7 +225,6 @@ struct xtables_match udp = { 
 
 static
 struct xtables_match udp6 = { 
-	.next		= NULL,
 	.family		= AF_INET6,
 	.name		= "udp",
 	.version	= IPTABLES_VERSION,
