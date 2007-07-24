From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 06/**] Make option structures const
Date: Tue, 24 Jul 2007 12:25:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707241224510.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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



Make the option structures const.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libip6t_CONNMARK.c    |    2 +-
 extensions/libip6t_CONNSECMARK.c |    2 +-
 extensions/libip6t_HL.c          |    2 +-
 extensions/libip6t_LOG.c         |    2 +-
 extensions/libip6t_MARK.c        |    2 +-
 extensions/libip6t_NFLOG.c       |    2 +-
 extensions/libip6t_REJECT.c      |    2 +-
 extensions/libip6t_ah.c          |    2 +-
 extensions/libip6t_condition.c   |    2 +-
 extensions/libip6t_connmark.c    |    2 +-
 extensions/libip6t_dst.c         |    2 +-
 extensions/libip6t_frag.c        |    2 +-
 extensions/libip6t_hashlimit.c   |    2 +-
 extensions/libip6t_hbh.c         |    4 ++--
 extensions/libip6t_hl.c          |    2 +-
 extensions/libip6t_icmp6.c       |    2 +-
 extensions/libip6t_ipv6header.c  |    2 +-
 extensions/libip6t_mh.c          |    2 +-
 extensions/libip6t_owner.c       |    2 +-
 extensions/libip6t_policy.c      |    2 +-
 extensions/libip6t_rt.c          |    2 +-
 extensions/libip6t_state.c       |    2 +-
 extensions/libipt_CLASSIFY.c     |    2 +-
 extensions/libipt_CLUSTERIP.c    |    2 +-
 extensions/libipt_CONNMARK.c     |    2 +-
 extensions/libipt_CONNSECMARK.c  |    2 +-
 extensions/libipt_DNAT.c         |    2 +-
 extensions/libipt_DSCP.c         |    2 +-
 extensions/libipt_ECN.c          |    2 +-
 extensions/libipt_LOG.c          |    2 +-
 extensions/libipt_MARK.c         |    2 +-
 extensions/libipt_MASQUERADE.c   |    2 +-
 extensions/libipt_NETMAP.c       |    2 +-
 extensions/libipt_NFLOG.c        |    2 +-
 extensions/libipt_REDIRECT.c     |    2 +-
 extensions/libipt_REJECT.c       |    2 +-
 extensions/libipt_SAME.c         |    2 +-
 extensions/libipt_SET.c          |    2 +-
 extensions/libipt_SNAT.c         |    2 +-
 extensions/libipt_TOS.c          |    4 ++--
 extensions/libipt_TTL.c          |    2 +-
 extensions/libipt_ULOG.c         |    2 +-
 extensions/libipt_addrtype.c     |    4 ++--
 extensions/libipt_ah.c           |    2 +-
 extensions/libipt_condition.c    |    2 +-
 extensions/libipt_connbytes.c    |    2 +-
 extensions/libipt_connmark.c     |    2 +-
 extensions/libipt_connrate.c     |    2 +-
 extensions/libipt_conntrack.c    |    2 +-
 extensions/libipt_dscp_helper.c  |    2 +-
 extensions/libipt_ecn.c          |    2 +-
 extensions/libipt_hashlimit.c    |    2 +-
 extensions/libipt_helper.c       |    2 +-
 extensions/libipt_icmp.c         |    2 +-
 extensions/libipt_iprange.c      |    2 +-
 extensions/libipt_owner.c        |    2 +-
 extensions/libipt_policy.c       |    2 +-
 extensions/libipt_realm.c        |    2 +-
 extensions/libipt_recent.c       |    2 +-
 extensions/libipt_set.c          |    2 +-
 extensions/libipt_state.c        |    2 +-
 extensions/libipt_statistic.c    |    2 +-
 extensions/libipt_tos.c          |    4 ++--
 extensions/libipt_ttl.c          |    2 +-
 extensions/libxt_NFQUEUE.c       |    2 +-
 extensions/libxt_SECMARK.c       |    2 +-
 extensions/libxt_TCPMSS.c        |    2 +-
 extensions/libxt_comment.c       |    2 +-
 extensions/libxt_dccp.c          |    2 +-
 extensions/libxt_dscp.c          |    2 +-
 extensions/libxt_esp.c           |    2 +-
 extensions/libxt_length.c        |    2 +-
 extensions/libxt_limit.c         |    2 +-
 extensions/libxt_mac.c           |    2 +-
 extensions/libxt_mark.c          |    2 +-
 extensions/libxt_multiport.c     |    2 +-
 extensions/libxt_physdev.c       |    2 +-
 extensions/libxt_pkttype.c       |    2 +-
 extensions/libxt_quota.c         |    2 +-
 extensions/libxt_sctp.c          |    2 +-
 extensions/libxt_string.c        |    2 +-
 extensions/libxt_tcp.c           |    2 +-
 extensions/libxt_tcpmss.c        |    2 +-
 extensions/libxt_udp.c           |    2 +-
 84 files changed, 88 insertions(+), 88 deletions(-)

Index: iptables/extensions/libip6t_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libip6t_CONNMARK.c
+++ iptables/extensions/libip6t_CONNMARK.c
@@ -48,7 +48,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
 	{ "save-mark", 0, 0, '2' },
 	{ "restore-mark", 0, 0, '3' },
Index: iptables/extensions/libip6t_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libip6t_CONNSECMARK.c
+++ iptables/extensions/libip6t_CONNSECMARK.c
@@ -24,7 +24,7 @@ static void help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "save", 0, 0, '1' },
 	{ "restore", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables.orig/extensions/libip6t_HL.c
+++ iptables/extensions/libip6t_HL.c
@@ -138,7 +138,7 @@ static void print(const void *ip,
 	printf("%u ", info->hop_limit);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "hl-set", 1, 0, '1' },
 	{ "hl-dec", 1, 0, '2' },
 	{ "hl-inc", 1, 0, '3' },
Index: iptables/extensions/libip6t_LOG.c
===================================================================
--- iptables.orig/extensions/libip6t_LOG.c
+++ iptables/extensions/libip6t_LOG.c
@@ -32,7 +32,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
 	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
 	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
Index: iptables/extensions/libip6t_MARK.c
===================================================================
--- iptables.orig/extensions/libip6t_MARK.c
+++ iptables/extensions/libip6t_MARK.c
@@ -20,7 +20,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "set-mark", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = 0 }
 };
Index: iptables/extensions/libip6t_NFLOG.c
===================================================================
--- iptables.orig/extensions/libip6t_NFLOG.c
+++ iptables/extensions/libip6t_NFLOG.c
@@ -14,7 +14,7 @@ enum {
 	NFLOG_THRESHOLD	= 0x8,
 };
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "nflog-group",     1, 0, NFLOG_GROUP },
 	{ "nflog-prefix",    1, 0, NFLOG_PREFIX },
 	{ "nflog-range",     1, 0, NFLOG_RANGE },
Index: iptables/extensions/libip6t_REJECT.c
===================================================================
--- iptables.orig/extensions/libip6t_REJECT.c
+++ iptables/extensions/libip6t_REJECT.c
@@ -65,7 +65,7 @@ help(void)
 	print_reject_types();
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "reject-with", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libip6t_ah.c
===================================================================
--- iptables.orig/extensions/libip6t_ah.c
+++ iptables/extensions/libip6t_ah.c
@@ -20,7 +20,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "ahspi", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "ahlen", .has_arg = 1, .flag = 0, .val = '2' },
 	{ .name = "ahres", .has_arg = 0, .flag = 0, .val = '3' },
Index: iptables/extensions/libip6t_condition.c
===================================================================
--- iptables.orig/extensions/libip6t_condition.c
+++ iptables/extensions/libip6t_condition.c
@@ -19,7 +19,7 @@ help(void)
 }
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
 	{ .name = 0 }
 };
Index: iptables/extensions/libip6t_connmark.c
===================================================================
--- iptables.orig/extensions/libip6t_connmark.c
+++ iptables/extensions/libip6t_connmark.c
@@ -39,7 +39,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mark", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libip6t_dst.c
===================================================================
--- iptables.orig/extensions/libip6t_dst.c
+++ iptables/extensions/libip6t_dst.c
@@ -31,7 +31,7 @@ UNAME " v%s options:\n"
 IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = LNAME "-len",        .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = LNAME "-opts",       .has_arg = 1, .flag = 0, .val = '2' },
 	{ .name = LNAME "-not-strict", .has_arg = 1, .flag = 0, .val = '3' },
Index: iptables/extensions/libip6t_frag.c
===================================================================
--- iptables.orig/extensions/libip6t_frag.c
+++ iptables/extensions/libip6t_frag.c
@@ -23,7 +23,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "fragid",    .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "fraglen",   .has_arg = 1, .flag = 0, .val = '2' },
 	{ .name = "fragres",   .has_arg = 0, .flag = 0, .val = '3' },
Index: iptables/extensions/libip6t_hashlimit.c
===================================================================
--- iptables.orig/extensions/libip6t_hashlimit.c
+++ iptables/extensions/libip6t_hashlimit.c
@@ -46,7 +46,7 @@ help(void)
 "\n", IPTABLES_VERSION, XT_HASHLIMIT_BURST);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "hashlimit", 1, 0, '%' },
 	{ "hashlimit-burst", 1, 0, '$' },
 	{ "hashlimit-htable-size", 1, 0, '&' },
Index: iptables/extensions/libip6t_hbh.c
===================================================================
--- iptables.orig/extensions/libip6t_hbh.c
+++ iptables/extensions/libip6t_hbh.c
@@ -30,14 +30,14 @@ UNAME , IPTABLES_VERSION, LNAME, LNAME, 
 }
 
 #if HOPBYHOP
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "hbh-len", 1, 0, '1' },
 	{ "hbh-opts", 1, 0, '2' },
 	{ "hbh-not-strict", 1, 0, '3' },
 	{0}
 };
 #else
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "dst-len", 1, 0, '1' },
 	{ "dst-opts", 1, 0, '2' },
 	{ "dst-not-strict", 1, 0, '3' },
Index: iptables/extensions/libip6t_hl.c
===================================================================
--- iptables.orig/extensions/libip6t_hl.c
+++ iptables/extensions/libip6t_hl.c
@@ -120,7 +120,7 @@ static void save(const void *ip,
 	printf("--hl-%s %u ", op[info->mode], info->hop_limit);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "hl",    .has_arg = 1, .flag = 0, .val = '2' },
 	{ .name = "hl-eq", .has_arg = 1, .flag = 0, .val = '2' },
 	{ .name = "hl-lt", .has_arg = 1, .flag = 0, .val = '3' },
Index: iptables/extensions/libip6t_icmp6.c
===================================================================
--- iptables.orig/extensions/libip6t_icmp6.c
+++ iptables/extensions/libip6t_icmp6.c
@@ -85,7 +85,7 @@ help(void)
 	print_icmpv6types();
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "icmpv6-type", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libip6t_ipv6header.c
===================================================================
--- iptables.orig/extensions/libip6t_ipv6header.c
+++ iptables/extensions/libip6t_ipv6header.c
@@ -148,7 +148,7 @@ help(void)
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "header", 1, 0, '1' },
 	{ "soft", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libip6t_mh.c
===================================================================
--- iptables.orig/extensions/libip6t_mh.c
+++ iptables/extensions/libip6t_mh.c
@@ -226,7 +226,7 @@ static void save(const void *ip, const s
 		printf("--mh-type %u ", mhinfo->types[0]);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mh-type", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libip6t_owner.c
===================================================================
--- iptables.orig/extensions/libip6t_owner.c
+++ iptables/extensions/libip6t_owner.c
@@ -36,7 +36,7 @@ IPTABLES_VERSION);
 #endif /* IP6T_OWNER_COMM */
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "uid-owner", 1, 0, '1' },
 	{ "gid-owner", 1, 0, '2' },
 	{ "pid-owner", 1, 0, '3' },
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -41,7 +41,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{
 		.name		= "dir",
Index: iptables/extensions/libip6t_rt.c
===================================================================
--- iptables.orig/extensions/libip6t_rt.c
+++ iptables/extensions/libip6t_rt.c
@@ -29,7 +29,7 @@ help(void)
 IPTABLES_VERSION, IP6T_RT_HOPS);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "rt-type", 1, 0, '1' },
 	{ "rt-segsleft", 1, 0, '2' },
 	{ "rt-len", 1, 0, '3' },
Index: iptables/extensions/libip6t_state.c
===================================================================
--- iptables.orig/extensions/libip6t_state.c
+++ iptables/extensions/libip6t_state.c
@@ -23,7 +23,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "state", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libipt_CLASSIFY.c
+++ iptables/extensions/libipt_CLASSIFY.c
@@ -21,7 +21,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-class", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libipt_CLUSTERIP.c
===================================================================
--- iptables.orig/extensions/libipt_CLUSTERIP.c
+++ iptables/extensions/libipt_CLUSTERIP.c
@@ -44,7 +44,7 @@ IPTABLES_VERSION);
 #define PARAM_LOCALNODE	0x0010
 #define PARAM_HASHINIT	0x0020
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "new", 0, 0, '1' },
 	{ "hashmode", 1, 0, '2' },
 	{ "clustermac", 1, 0, '3' },
Index: iptables/extensions/libipt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libipt_CONNMARK.c
+++ iptables/extensions/libipt_CONNMARK.c
@@ -48,7 +48,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
 	{ "save-mark", 0, 0, '2' },
 	{ "restore-mark", 0, 0, '3' },
Index: iptables/extensions/libipt_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libipt_CONNSECMARK.c
+++ iptables/extensions/libipt_CONNSECMARK.c
@@ -24,7 +24,7 @@ static void help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "save", 0, 0, '1' },
 	{ "restore", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_DNAT.c
===================================================================
--- iptables.orig/extensions/libipt_DNAT.c
+++ iptables/extensions/libipt_DNAT.c
@@ -32,7 +32,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to-destination", 1, 0, '1' },
 	{ "random", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_DSCP.c
===================================================================
--- iptables.orig/extensions/libipt_DSCP.c
+++ iptables/extensions/libipt_DSCP.c
@@ -42,7 +42,7 @@ static void help(void) 
 );
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-dscp", 1, 0, 'F' },
 	{ "set-dscp-class", 1, 0, 'G' },
 	{ 0 }
Index: iptables/extensions/libipt_ECN.c
===================================================================
--- iptables.orig/extensions/libipt_ECN.c
+++ iptables/extensions/libipt_ECN.c
@@ -37,7 +37,7 @@ static void help(void) 
 #endif
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "ecn-tcp-remove", 0, 0, 'F' },
 	{ "ecn-tcp-cwr", 1, 0, 'G' },
 	{ "ecn-tcp-ece", 1, 0, 'H' },
Index: iptables/extensions/libipt_LOG.c
===================================================================
--- iptables.orig/extensions/libipt_LOG.c
+++ iptables/extensions/libipt_LOG.c
@@ -32,7 +32,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "log-level",        .has_arg = 1, .flag = 0, .val = '!' },
 	{ .name = "log-prefix",       .has_arg = 1, .flag = 0, .val = '#' },
 	{ .name = "log-tcp-sequence", .has_arg = 0, .flag = 0, .val = '1' },
Index: iptables/extensions/libipt_MARK.c
===================================================================
--- iptables.orig/extensions/libipt_MARK.c
+++ iptables/extensions/libipt_MARK.c
@@ -22,7 +22,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-mark", 1, 0, '1' },
 	{ "and-mark", 1, 0, '2' },
 	{ "or-mark", 1, 0, '3' },
Index: iptables/extensions/libipt_MASQUERADE.c
===================================================================
--- iptables.orig/extensions/libipt_MASQUERADE.c
+++ iptables/extensions/libipt_MASQUERADE.c
@@ -23,7 +23,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to-ports", 1, 0, '1' },
 	{ "random", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_NETMAP.c
===================================================================
--- iptables.orig/extensions/libipt_NETMAP.c
+++ iptables/extensions/libipt_NETMAP.c
@@ -13,7 +13,7 @@
 
 #define MODULENAME "NETMAP"
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libipt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libipt_NFLOG.c
+++ iptables/extensions/libipt_NFLOG.c
@@ -14,7 +14,7 @@ enum {
 	NFLOG_THRESHOLD	= 0x8,
 };
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "nflog-group",     1, 0, NFLOG_GROUP },
 	{ "nflog-prefix",    1, 0, NFLOG_PREFIX },
 	{ "nflog-range",     1, 0, NFLOG_RANGE },
Index: iptables/extensions/libipt_REDIRECT.c
===================================================================
--- iptables.orig/extensions/libipt_REDIRECT.c
+++ iptables/extensions/libipt_REDIRECT.c
@@ -22,7 +22,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to-ports", 1, 0, '1' },
 	{ "random", 1, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_REJECT.c
===================================================================
--- iptables.orig/extensions/libipt_REJECT.c
+++ iptables/extensions/libipt_REJECT.c
@@ -80,7 +80,7 @@ help(void)
 	printf("(*) See man page or read the INCOMPATIBILITES file for compatibility issues.\n");
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "reject-with", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libipt_SAME.c
===================================================================
--- iptables.orig/extensions/libipt_SAME.c
+++ iptables/extensions/libipt_SAME.c
@@ -29,7 +29,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to", 1, 0, '1' },
 	{ "nodst", 0, 0, '2'},
 	{ "random", 0, 0, '3' },
Index: iptables/extensions/libipt_SET.c
===================================================================
--- iptables.orig/extensions/libipt_SET.c
+++ iptables/extensions/libipt_SET.c
@@ -34,7 +34,7 @@ static void help(void)
 	       "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"add-set",   1, 0, '1'},
 	{"del-set",   1, 0, '2'},
 	{0}
Index: iptables/extensions/libipt_SNAT.c
===================================================================
--- iptables.orig/extensions/libipt_SNAT.c
+++ iptables/extensions/libipt_SNAT.c
@@ -32,7 +32,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "to-source", 1, 0, '1' },
 	{ "random", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_TOS.c
===================================================================
--- iptables.orig/extensions/libipt_TOS.c
+++ iptables/extensions/libipt_TOS.c
@@ -14,7 +14,7 @@ struct tosinfo {
 };
 
 /* TOS names and values. */
-static
+static const
 struct TOS_value
 {
 	unsigned char TOS;
@@ -47,7 +47,7 @@ IPTABLES_VERSION);
 	fputc('\n', stdout);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-tos", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libipt_TTL.c
===================================================================
--- iptables.orig/extensions/libipt_TTL.c
+++ iptables/extensions/libipt_TTL.c
@@ -138,7 +138,7 @@ static void print(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "ttl-set", 1, 0, '1' },
 	{ "ttl-dec", 1, 0, '2' },
 	{ "ttl-inc", 1, 0, '3' },
Index: iptables/extensions/libipt_ULOG.c
===================================================================
--- iptables.orig/extensions/libipt_ULOG.c
+++ iptables/extensions/libipt_ULOG.c
@@ -44,7 +44,7 @@ static void help(void)
 	       IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"ulog-nlgroup", 1, 0, '!'},
 	{"ulog-prefix", 1, 0, '#'},
 	{"ulog-cprange", 1, 0, 'A'},
Index: iptables/extensions/libipt_addrtype.c
===================================================================
--- iptables.orig/extensions/libipt_addrtype.c
+++ iptables/extensions/libipt_addrtype.c
@@ -12,7 +12,7 @@
 #include <linux/netfilter_ipv4/ipt_addrtype.h>
 
 /* from linux/rtnetlink.h, must match order of enumeration */
-static char *rtn_names[] = {
+static const char *const rtn_names[] = {
 	"UNSPEC",
 	"UNICAST",
 	"LOCAL",
@@ -179,7 +179,7 @@ static void save(const void *ip,
 	}
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "src-type", 1, 0, '1' },
 	{ "dst-type", 1, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libipt_ah.c
===================================================================
--- iptables.orig/extensions/libipt_ah.c
+++ iptables/extensions/libipt_ah.c
@@ -19,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "ahspi", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_condition.c
===================================================================
--- iptables.orig/extensions/libipt_condition.c
+++ iptables/extensions/libipt_condition.c
@@ -19,7 +19,7 @@ help(void)
 }
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "condition", .has_arg = 1, .flag = 0, .val = 'X' },
 	{ .name = 0 }
 };
Index: iptables/extensions/libipt_connbytes.c
===================================================================
--- iptables.orig/extensions/libipt_connbytes.c
+++ iptables/extensions/libipt_connbytes.c
@@ -20,7 +20,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "connbytes", 1, 0, '1' },
 	{ "connbytes-dir", 1, 0, '2' },
 	{ "connbytes-mode", 1, 0, '3' },
Index: iptables/extensions/libipt_connmark.c
===================================================================
--- iptables.orig/extensions/libipt_connmark.c
+++ iptables/extensions/libipt_connmark.c
@@ -39,7 +39,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mark", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_connrate.c
===================================================================
--- iptables.orig/extensions/libipt_connrate.c
+++ iptables/extensions/libipt_connrate.c
@@ -29,7 +29,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "connrate", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_conntrack.c
===================================================================
--- iptables.orig/extensions/libipt_conntrack.c
+++ iptables/extensions/libipt_conntrack.c
@@ -43,7 +43,7 @@ help(void)
 
 
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "ctstate", 1, 0, '1' },
 	{ "ctproto", 1, 0, '2' },
 	{ "ctorigsrc", 1, 0, '3' },
Index: iptables/extensions/libipt_dscp_helper.c
===================================================================
--- iptables.orig/extensions/libipt_dscp_helper.c
+++ iptables/extensions/libipt_dscp_helper.c
@@ -14,7 +14,7 @@
 #include <xtables.h>
 
 
-static struct ds_class
+static const struct ds_class
 {
 	const char *name;
 	unsigned int dscp;
Index: iptables/extensions/libipt_ecn.c
===================================================================
--- iptables.orig/extensions/libipt_ecn.c
+++ iptables/extensions/libipt_ecn.c
@@ -26,7 +26,7 @@ static void help(void) 
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "ecn-tcp-cwr", .has_arg = 0, .flag = 0, .val = 'F' },
 	{ .name = "ecn-tcp-ece", .has_arg = 0, .flag = 0, .val = 'G' },
 	{ .name = "ecn-ip-ect",  .has_arg = 1, .flag = 0, .val = 'H' },
Index: iptables/extensions/libipt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libipt_hashlimit.c
+++ iptables/extensions/libipt_hashlimit.c
@@ -46,7 +46,7 @@ help(void)
 "\n", IPTABLES_VERSION, IPT_HASHLIMIT_BURST);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "hashlimit", 1, 0, '%' },
 	{ "hashlimit-burst", 1, 0, '$' },
 	{ "hashlimit-htable-size", 1, 0, '&' },
Index: iptables/extensions/libipt_helper.c
===================================================================
--- iptables.orig/extensions/libipt_helper.c
+++ iptables/extensions/libipt_helper.c
@@ -19,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "helper", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_icmp.c
===================================================================
--- iptables.orig/extensions/libipt_icmp.c
+++ iptables/extensions/libipt_icmp.c
@@ -109,7 +109,7 @@ help(void)
 	print_icmptypes();
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "icmp-type", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_iprange.c
===================================================================
--- iptables.orig/extensions/libipt_iprange.c
+++ iptables/extensions/libipt_iprange.c
@@ -20,7 +20,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "src-range", 1, 0, '1' },
 	{ "dst-range", 1, 0, '2' },
 	{0}
Index: iptables/extensions/libipt_owner.c
===================================================================
--- iptables.orig/extensions/libipt_owner.c
+++ iptables/extensions/libipt_owner.c
@@ -38,7 +38,7 @@ IPTABLES_VERSION);
 #endif /* IPT_OWNER_COMM */
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "uid-owner", 1, 0, '1' },
 	{ "gid-owner", 1, 0, '2' },
 	{ "pid-owner", 1, 0, '3' },
Index: iptables/extensions/libipt_policy.c
===================================================================
--- iptables.orig/extensions/libipt_policy.c
+++ iptables/extensions/libipt_policy.c
@@ -40,7 +40,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] =
+static const struct option opts[] =
 {
 	{
 		.name		= "dir",
Index: iptables/extensions/libipt_realm.c
===================================================================
--- iptables.orig/extensions/libipt_realm.c
+++ iptables/extensions/libipt_realm.c
@@ -25,7 +25,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "realm", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_recent.c
===================================================================
--- iptables.orig/extensions/libipt_recent.c
+++ iptables/extensions/libipt_recent.c
@@ -22,7 +22,7 @@
 #endif /* IPT_RECENT_NAME_LEN */
 
 /* Options for this module */
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "set",      .has_arg = 0, .flag = 0, .val = 201 }, 
 	{ .name = "rcheck",   .has_arg = 0, .flag = 0, .val = 202 }, 
 	{ .name = "update",   .has_arg = 0, .flag = 0, .val = 203 },
Index: iptables/extensions/libipt_set.c
===================================================================
--- iptables.orig/extensions/libipt_set.c
+++ iptables/extensions/libipt_set.c
@@ -32,7 +32,7 @@ static void help(void)
 	       "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"set", 1, 0, '1'},
 	{0}
 };
Index: iptables/extensions/libipt_state.c
===================================================================
--- iptables.orig/extensions/libipt_state.c
+++ iptables/extensions/libipt_state.c
@@ -23,7 +23,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "state", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_statistic.c
===================================================================
--- iptables.orig/extensions/libipt_statistic.c
+++ iptables/extensions/libipt_statistic.c
@@ -23,7 +23,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mode", 1, 0, '1' },
 	{ "probability", 1, 0, '2' },
 	{ "every", 1, 0, '3' },
Index: iptables/extensions/libipt_tos.c
===================================================================
--- iptables.orig/extensions/libipt_tos.c
+++ iptables/extensions/libipt_tos.c
@@ -9,7 +9,7 @@
 #include <linux/netfilter_ipv4/ipt_tos.h>
 
 /* TOS names and values. */
-static
+static const
 struct TOS_value
 {
 	unsigned char TOS;
@@ -42,7 +42,7 @@ IPTABLES_VERSION);
 	fputc('\n', stdout);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "tos", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libipt_ttl.c
===================================================================
--- iptables.orig/extensions/libipt_ttl.c
+++ iptables/extensions/libipt_ttl.c
@@ -143,7 +143,7 @@ static void save(const void *ip,
 	printf("%u ", info->ttl);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "ttl", 1, 0, '2' },
 	{ "ttl-eq", 1, 0, '2'},
 	{ "ttl-lt", 1, 0, '3'},
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -27,7 +27,7 @@ static void help(void) 
 );
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "queue-num", 1, 0, 'F' },
 	{ 0 }
 };
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -23,7 +23,7 @@ static void help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "selctx", 1, 0, '1' },
 	{ 0 }
 };
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -36,7 +36,7 @@ static void help6(void)
 	__help(60);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "set-mss", 1, 0, '1' },
 	{ "clamp-mss-to-pmtu", 0, 0, '2' },
 	{ 0 }
Index: iptables/extensions/libxt_comment.c
===================================================================
--- iptables.orig/extensions/libxt_comment.c
+++ iptables/extensions/libxt_comment.c
@@ -24,7 +24,7 @@ help(void)
 		);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "comment", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -46,7 +46,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "source-port", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "sport", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "destination-port", .has_arg = 1, .flag = 0, .val = '2' },
Index: iptables/extensions/libxt_dscp.c
===================================================================
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -39,7 +39,7 @@ static void help(void) 
 );
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "dscp", 1, 0, 'F' },
 	{ "dscp-class", 1, 0, 'G' },
 	{ 0 }
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -19,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "espspi", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_length.c
===================================================================
--- iptables.orig/extensions/libxt_length.c
+++ iptables/extensions/libxt_length.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 }
   
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "length", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -30,7 +30,7 @@ help(void)
 "\n", IPTABLES_VERSION, XT_LIMIT_BURST);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "limit", 1, 0, '%' },
 	{ "limit-burst", 1, 0, '$' },
 	{ 0 }
Index: iptables/extensions/libxt_mac.c
===================================================================
--- iptables.orig/extensions/libxt_mac.c
+++ iptables/extensions/libxt_mac.c
@@ -23,7 +23,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mac-source", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_mark.c
===================================================================
--- iptables.orig/extensions/libxt_mark.c
+++ iptables/extensions/libxt_mark.c
@@ -20,7 +20,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mark", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -45,7 +45,7 @@ help_v1(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "source-ports", 1, 0, '1' },
 	{ "sports", 1, 0, '1' }, /* synonym */
 	{ "destination-ports", 1, 0, '2' },
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -25,7 +25,7 @@ help(void)
 "\n", IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "physdev-in", 1, 0, '1' },
 	{ "physdev-out", 1, 0, '2' },
 	{ "physdev-is-in", 0, 0, '3' },
Index: iptables/extensions/libxt_pkttype.c
===================================================================
--- iptables.orig/extensions/libxt_pkttype.c
+++ iptables/extensions/libxt_pkttype.c
@@ -64,7 +64,7 @@ static void help(void)
 	print_types();
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{"pkt-type", 1, 0, '1'},
 	{0}
 };
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
@@ -11,7 +11,7 @@
 
 #include <linux/netfilter/xt_quota.h>
 
-static struct option opts[] = {
+static const struct option opts[] = {
         {"quota", 1, 0, '1'},
         {0}
 };
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -69,7 +69,7 @@ static void help(void)
 	IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ .name = "source-port", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "sport", .has_arg = 1, .flag = 0, .val = '1' },
 	{ .name = "destination-port", .has_arg = 1, .flag = 0, .val = '2' },
Index: iptables/extensions/libxt_string.c
===================================================================
--- iptables.orig/extensions/libxt_string.c
+++ iptables/extensions/libxt_string.c
@@ -44,7 +44,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "from", 1, 0, '1' },
 	{ "to", 1, 0, '2' },
 	{ "algo", 1, 0, '3' },
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -27,7 +27,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "source-port", 1, 0, '1' },
 	{ "sport", 1, 0, '1' }, /* synonym */
 	{ "destination-port", 1, 0, '2' },
Index: iptables/extensions/libxt_tcpmss.c
===================================================================
--- iptables.orig/extensions/libxt_tcpmss.c
+++ iptables/extensions/libxt_tcpmss.c
@@ -19,7 +19,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "mss", 1, 0, '1' },
 	{0}
 };
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -22,7 +22,7 @@ help(void)
 IPTABLES_VERSION);
 }
 
-static struct option opts[] = {
+static const struct option opts[] = {
 	{ "source-port", 1, 0, '1' },
 	{ "sport", 1, 0, '1' }, /* synonym */
 	{ "destination-port", 1, 0, '2' },
