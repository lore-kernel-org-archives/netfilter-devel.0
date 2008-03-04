From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 07/24] Fix all remaining warnings (missing declarations,
 missing prototypes)
Date: Tue, 4 Mar 2008 16:55:39 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041655240.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53747 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYCDPzl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:55:41 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit aa67ae160fbfa3787d6a26763d5417f92f1c9b2f
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 11 00:54:00 2008 +0100

    Fix all remaining warnings (missing declarations, missing prototypes)
---
 configure.ac                    |    5 -----
 extensions/GNUmakefile.in       |    2 ++
 extensions/libip6t_HL.c         |    1 +
 extensions/libip6t_LOG.c        |    1 +
 extensions/libip6t_REJECT.c     |    1 +
 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_condition.c  |    5 ++---
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_eui64.c      |    1 +
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    1 +
 extensions/libip6t_ipv6header.c |    1 +
 extensions/libip6t_mh.c         |    1 +
 extensions/libip6t_policy.c     |    6 +-----
 extensions/libip6t_rt.c         |    4 ++--
 extensions/libipt_CLUSTERIP.c   |    1 +
 extensions/libipt_DNAT.c        |    1 +
 extensions/libipt_ECN.c         |    1 +
 extensions/libipt_LOG.c         |    1 +
 extensions/libipt_MASQUERADE.c  |    1 +
 extensions/libipt_MIRROR.c      |    1 +
 extensions/libipt_NETMAP.c      |    1 +
 extensions/libipt_REDIRECT.c    |    1 +
 extensions/libipt_REJECT.c      |    1 +
 extensions/libipt_SAME.c        |    1 +
 extensions/libipt_SET.c         |    1 +
 extensions/libipt_SNAT.c        |    1 +
 extensions/libipt_TTL.c         |    1 +
 extensions/libipt_ULOG.c        |    3 ++-
 extensions/libipt_addrtype.c    |    2 +-
 extensions/libipt_ah.c          |    4 ++--
 extensions/libipt_condition.c   |    5 ++---
 extensions/libipt_ecn.c         |    1 +
 extensions/libipt_icmp.c        |    1 +
 extensions/libipt_policy.c      |    1 +
 extensions/libipt_realm.c       |    1 +
 extensions/libipt_recent.c      |    1 +
 extensions/libipt_set.c         |    1 +
 extensions/libipt_ttl.c         |    2 +-
 extensions/libipt_unclean.c     |    1 +
 extensions/libxt_CLASSIFY.c     |    1 +
 extensions/libxt_CONNMARK.c     |    1 +
 extensions/libxt_CONNSECMARK.c  |    1 +
 extensions/libxt_DSCP.c         |    1 +
 extensions/libxt_MARK.c         |    1 +
 extensions/libxt_NFLOG.c        |    1 +
 extensions/libxt_NFQUEUE.c      |    1 +
 extensions/libxt_NOTRACK.c      |    1 +
 extensions/libxt_RATEEST.c      |    1 +
 extensions/libxt_SECMARK.c      |    1 +
 extensions/libxt_TCPMSS.c       |    1 +
 extensions/libxt_TCPOPTSTRIP.c  |    1 +
 extensions/libxt_TOS.c          |    1 +
 extensions/libxt_TRACE.c        |    1 +
 extensions/libxt_comment.c      |    1 +
 extensions/libxt_connbytes.c    |    1 +
 extensions/libxt_connlimit.c    |    1 +
 extensions/libxt_connmark.c     |    1 +
 extensions/libxt_conntrack.c    |    1 +
 extensions/libxt_dccp.c         |    1 +
 extensions/libxt_dscp.c         |    1 +
 extensions/libxt_esp.c          |    4 ++--
 extensions/libxt_hashlimit.c    |    1 +
 extensions/libxt_helper.c       |    1 +
 extensions/libxt_iprange.c      |    1 +
 extensions/libxt_length.c       |    1 +
 extensions/libxt_limit.c        |    1 +
 extensions/libxt_mac.c          |    1 +
 extensions/libxt_mark.c         |    1 +
 extensions/libxt_multiport.c    |    4 ++--
 extensions/libxt_owner.c        |    1 +
 extensions/libxt_physdev.c      |    1 +
 extensions/libxt_pkttype.c      |    1 +
 extensions/libxt_quota.c        |    4 ++--
 extensions/libxt_rateest.c      |    1 +
 extensions/libxt_sctp.c         |    1 +
 extensions/libxt_standard.c     |    1 +
 extensions/libxt_state.c        |    1 +
 extensions/libxt_statistic.c    |    1 +
 extensions/libxt_string.c       |    1 +
 extensions/libxt_tcp.c          |    4 ++--
 extensions/libxt_tcpmss.c       |    1 +
 extensions/libxt_time.c         |    1 +
 extensions/libxt_tos.c          |    1 +
 extensions/libxt_u32.c          |    1 +
 extensions/libxt_udp.c          |    4 ++--
 include/iptables.h              |    2 --
 include/libiptc/libip6tc.h      |    2 ++
 include/libiptc/libiptc.h       |    2 ++
 include/xtables.h               |    3 +++
 ip6tables-multi.h               |    8 ++++++++
 ip6tables-restore.c             |    4 +++-
 ip6tables-save.c                |    1 +
 ip6tables-standalone.c          |    1 +
 ip6tables.c                     |    6 ++----
 iptables-multi.h                |    9 +++++++++
 iptables-restore.c              |    3 ++-
 iptables-save.c                 |    1 +
 iptables-standalone.c           |    1 +
 iptables-xml.c                  |    1 +
 iptables.c                      |    4 +---
 libiptc/libiptc.c               |    9 ++++-----
 104 files changed, 143 insertions(+), 58 deletions(-)
 create mode 100644 ip6tables-multi.h
 create mode 100644 iptables-multi.h

diff --git a/configure.ac b/configure.ac
index 87fca6c..29f54dc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -43,11 +43,6 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
 kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
-# Remove workarounds soon
-regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
-	-Wno-missing-declarations -Wno-missing-prototypes \
-        -Wno-unused-parameter"
-
 AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 3d9eb24..c6c181a 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -143,6 +143,7 @@ initext4.c: .initext4.dd
 	for i in ${initext_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
+	echo -en "void init_extensions(void);\n" >>$@; \
 	echo -en "void init_extensions(void)\n""{\n" >>$@; \
 	for i in ${initext_func}; do \
 		echo -e "\t""lib$${i}_init();" >>$@; \
@@ -157,6 +158,7 @@ initext6.c: .initext6.dd
 	for i in ${initext6_func}; do \
 		echo "extern void lib$${i}_init(void);" >>$@; \
 	done; \
+	echo -en "void init_extensions(void);\n" >>$@; \
 	echo -en "void init_extensions(void)\n""{\n" >>$@; \
 	for i in ${initext6_func}; do \
 		echo -e "\t""lib$${i}_init();" >>$@; \
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index c20147b..3104285 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -152,6 +152,7 @@ static struct ip6tables_target hl_target6 = {
 	.extra_opts	= HL_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target6(&hl_target6);
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 6fd4c0b..e8de148 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -269,6 +269,7 @@ static struct ip6tables_target log_target6 = {
     .extra_opts    = LOG_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target6(&log_target6);
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 000096e..9445534 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -151,6 +151,7 @@ static struct ip6tables_target reject_target6 = {
 	.extra_opts	= REJECT_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target6(&reject_target6);
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 46469ea..afebdb1 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -206,8 +206,8 @@ static struct ip6tables_match ah_match6 = {
 	.extra_opts    = ah_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&ah_match6);
 }
diff --git a/extensions/libip6t_condition.c b/extensions/libip6t_condition.c
index 03e2722..56793b2 100644
--- a/extensions/libip6t_condition.c
+++ b/extensions/libip6t_condition.c
@@ -87,9 +87,8 @@ static struct ip6tables_match condition_match6 = {
 	.extra_opts = condition_opts,
 };
 
-
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&condition_match6);
 }
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 5b06033..1333418 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -240,8 +240,8 @@ static struct ip6tables_match dst_match6 = {
 	.extra_opts    = dst_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&dst_match6);
 }
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 45988c4..7739e30 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -38,6 +38,7 @@ static struct ip6tables_match eui64_target6 = {
 	.parse		= eui64_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match6(&eui64_target6);
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 86f40f4..834dd06 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -251,8 +251,8 @@ static struct ip6tables_match frag_match6 = {
 	.extra_opts    = frag_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&frag_match6);
 }
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index ad12547..7ca2b69 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -227,8 +227,8 @@ static struct ip6tables_match hbh_match6 = {
 	.extra_opts	= hbh_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&hbh_match6);
 }
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 7f99598..d2616b8 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -138,7 +138,7 @@ static struct ip6tables_match hl_match6 = {
 	.extra_opts    = hl_opts,
 };
 
-
+void _init(void);
 void _init(void) 
 {
 	register_match6(&hl_match6);
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 8c9653f..d9bc785 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -265,6 +265,7 @@ static struct ip6tables_match icmp6_match6 = {
 	.extra_opts	= icmp6_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match6(&icmp6_match6);
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index c20fb94..05835ac 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -300,6 +300,7 @@ static struct ip6tables_match ipv6header_match6 = {
 	.extra_opts	= ipv6header_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match6(&ipv6header_match6);
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index dd0da2b..fd3f452 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -236,6 +236,7 @@ static struct ip6tables_match mh_match6 = {
 	.extra_opts	= mh_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match6(&mh_match6);
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index f706f98..4c2f405 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -126,11 +126,6 @@ mask_to_numeric(const struct in6_addr *addrp)
 	return buf;
 }
 
-/* These should be in include/ip6tables.h... */
-extern u_int16_t parse_protocol(const char *s);
-
-/* End duplicated code from ip6tables.c */
-
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
@@ -461,6 +456,7 @@ static struct ip6tables_match policy_match6 = {
 	.extra_opts	= policy_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match6(&policy_match6);
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index e2ae09f..33d282f 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -342,8 +342,8 @@ static struct ip6tables_match rt_match6 = {
 	.extra_opts	= rt_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match6(&rt_match6);
 }
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index fdeae86..2314185 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -248,6 +248,7 @@ static struct iptables_target clusterip_target = {
 	.extra_opts	= CLUSTERIP_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&clusterip_target);
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 3ad412b..a0dbfc5 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -256,6 +256,7 @@ static struct iptables_target dnat_target = {
 	.extra_opts	= DNAT_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&dnat_target);
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 1523b2d..8335cca 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -166,6 +166,7 @@ static struct iptables_target ecn_target = {
 	.extra_opts	= ECN_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&ecn_target);
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 6b08f58..8287d95 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -271,6 +271,7 @@ static struct iptables_target log_target = {
     .extra_opts    = LOG_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&log_target);
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index fc914c5..c0c519d 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -164,6 +164,7 @@ static struct iptables_target masquerade_target = {
 	.extra_opts	= MASQUERADE_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&masquerade_target);
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 83397fe..8506eff 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -34,6 +34,7 @@ static struct iptables_target mirror_target = {
 	.save		= NULL,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&mirror_target);
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index da0e5f4..0043cca 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -184,6 +184,7 @@ static struct iptables_target netmap_target = {
 	.extra_opts	= NETMAP_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&netmap_target);
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 1918df8..0bcc9dd 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -170,6 +170,7 @@ static struct iptables_target redirect_target = {
 	.extra_opts	= REDIRECT_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&redirect_target);
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 5901a5e..aa139fd 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -170,6 +170,7 @@ static struct iptables_target reject_target = {
 	.extra_opts	= REJECT_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&reject_target);
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index f7c737c..9d58bf0 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -222,6 +222,7 @@ static struct iptables_target same_target = {
 	.extra_opts	= SAME_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&same_target);
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index dd42867..91ab488 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -168,6 +168,7 @@ static struct iptables_target set_target = {
 	.extra_opts	= SET_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&set_target);
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 7b9e176..9a553cd 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -257,6 +257,7 @@ static struct iptables_target snat_target = {
 	.extra_opts	= SNAT_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&snat_target);
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index b5a32c4..e19c3a0 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -153,6 +153,7 @@ static struct iptables_target ttl_target = {
 	.extra_opts	= TTL_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&ttl_target);
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 6fb2c66..10301f0 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -21,7 +21,7 @@
 #include "../include/linux/netfilter_ipv4/ipt_ULOG.h"
 
 
-void print_groups(unsigned int gmask)
+static void print_groups(unsigned int gmask)
 {
 	int b;
 	unsigned int test;
@@ -199,6 +199,7 @@ static struct iptables_target ulog_target = {
 	.extra_opts	= ULOG_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_target(&ulog_target);
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 7db9dce..02752d3 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -196,7 +196,7 @@ static struct iptables_match addrtype_match = {
 	.extra_opts 	= addrtype_opts,
 };
 
-
+void _init(void);
 void _init(void) 
 {
 	register_match(&addrtype_match);
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 2555b5d..5d9ab6c 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -169,8 +169,8 @@ static struct iptables_match ah_match = {
 	.extra_opts 	= ah_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match(&ah_match);
 }
diff --git a/extensions/libipt_condition.c b/extensions/libipt_condition.c
index 4a98dd8..5bd1c44 100644
--- a/extensions/libipt_condition.c
+++ b/extensions/libipt_condition.c
@@ -86,9 +86,8 @@ static struct iptables_match condition_match = {
 	.extra_opts 	= condition_opts,
 };
 
-
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	register_match(&condition_match);
 }
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 9c07eab..5c0428d 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -157,6 +157,7 @@ static struct iptables_match ecn_match = {
     .extra_opts    = ecn_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&ecn_match);
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index b1fccbf..df57a5e 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -287,6 +287,7 @@ static struct iptables_match icmp_match = {
 	.extra_opts	= icmp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&icmp_match);
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 48b96be..cdef750 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -421,6 +421,7 @@ static struct iptables_match policy_match = {
 	.extra_opts	= policy_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&policy_match);
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 7026fc2..73444de 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -256,6 +256,7 @@ static struct iptables_match realm_match = {
 	.extra_opts	= realm_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&realm_match);
diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index ace778e..d82b026 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -224,6 +224,7 @@ static struct iptables_match recent_match = {
     .extra_opts    = recent_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&recent_match);
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 932008b..78a02b5 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -155,6 +155,7 @@ static struct iptables_match set_match = {
 	.extra_opts	= set_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&set_match);
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index d7820f1..d358dfc 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -161,7 +161,7 @@ static struct iptables_match ttl_match = {
 	.extra_opts	= ttl_opts,
 };
 
-
+void _init(void);
 void _init(void) 
 {
 	register_match(&ttl_match);
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 648d098..9956c1a 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -29,6 +29,7 @@ static struct iptables_match unclean_match = {
 	.parse		= unclean_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	register_match(&unclean_match);
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index e39367a..ea6cdbe 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -130,6 +130,7 @@ static struct xtables_target classify_target6 = {
 	.extra_opts	= CLASSIFY_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&classify_target);
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 9e8013a..73f8214 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -470,6 +470,7 @@ static struct xtables_target connmark_tg6_reg = {
 	.extra_opts     = connmark_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&connmark_target);
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index e8d0a5e..779594f 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -138,6 +138,7 @@ static struct xtables_target connsecmark_target6 = {
 	.extra_opts	= CONNSECMARK_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&connsecmark_target);
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index c15f0e1..3a99b33 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -160,6 +160,7 @@ static struct xtables_target dscp_target6 = {
 	.extra_opts	= DSCP_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&dscp_target);
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 569d2e8..2994e75 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -359,6 +359,7 @@ static struct xtables_target mark_tg6_reg_v2 = {
 	.extra_opts    = mark_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&mark_target_v0);
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index d4dc971..4b6c5a9 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -167,6 +167,7 @@ static struct xtables_target nflog_target6 = {
 	.extra_opts	= NFLOG_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&nflog_target);
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index b1c5ef3..287c1c8 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -106,6 +106,7 @@ static struct xtables_target nfqueue_target6 = {
 	.extra_opts	= NFQUEUE_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&nfqueue_target);
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index 18ad5e1..cb6bd1e 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -44,6 +44,7 @@ static struct xtables_target notrack_target6 = {
 	.parse		= NOTRACK_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&notrack_target);
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 4f52c2e..df16581 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -233,6 +233,7 @@ static struct xtables_target rateest_target6 = {
 	.extra_opts	= RATEEST_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&rateest_target4);
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index b794e7d..5dfd21e 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -129,6 +129,7 @@ static struct xtables_target secmark_target6 = {
 	.extra_opts	= SECMARK_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&secmark_target);
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 9ab69bf..f4a45c3 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -151,6 +151,7 @@ static struct xtables_target tcpmss_target6 = {
 	.extra_opts	= TCPMSS_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tcpmss_target);
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index bd66435..22e921a 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -205,6 +205,7 @@ static struct xtables_target tcpoptstrip_tg6_reg = {
 	.extra_opts    = tcpoptstrip_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tcpoptstrip_tg_reg);
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 777d7cf..dfc7af7 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -249,6 +249,7 @@ static struct xtables_target tos_tg6_reg = {
 	.extra_opts    = tos_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tos_tg_reg_v0);
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index c70df6a..f1d2d94 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -43,6 +43,7 @@ static struct xtables_target trace_target6 = {
 	.parse		= TRACE_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&trace_target);
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 20277d4..8ae77fc 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -121,6 +121,7 @@ static struct xtables_match comment_match6 = {
 	.extra_opts	= comment_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&comment_match);
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index e6cb1f4..9fd5a47 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -213,6 +213,7 @@ static struct xtables_match connbytes_match6 = {
 	.extra_opts	= connbytes_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connbytes_match);
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 9e2137a..2b4d3d5 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -208,6 +208,7 @@ static struct xtables_match connlimit_match6 = {
 	.extra_opts    = connlimit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connlimit_match);
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 1e38f7c..dd43359 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -228,6 +228,7 @@ static struct xtables_match connmark_mt6_reg = {
 	.extra_opts     = connmark_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connmark_mt_reg_v0);
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index e3e29f0..d5f1be7 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1061,6 +1061,7 @@ static struct xtables_match conntrack_mt6_reg = {
 	.extra_opts    = conntrack_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&conntrack_match);
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 467a695..d21de16 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -367,6 +367,7 @@ static struct xtables_match dccp_match6 = {
 	.extra_opts	= dccp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&dccp_match);
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index a28af09..75941ab 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -174,6 +174,7 @@ static struct xtables_match dscp_match6 = {
 	.extra_opts	= dscp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&dscp_match);
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index f37c088..b20999d 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -181,8 +181,8 @@ static struct xtables_match esp_match6 = {
 	.extra_opts	= esp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&esp_match);
 	xtables_register_match(&esp_match6);
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 00b0304..a19ab8f 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -390,6 +390,7 @@ static struct xtables_match hashlimit_match6 = {
 	.extra_opts	= hashlimit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&hashlimit_match);
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 31ae4fc..4ce1d4b 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -102,6 +102,7 @@ static struct xtables_match helper_match6 = {
 	.extra_opts	= helper_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&helper_match);
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 51b35f8..54d7d9c 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -383,6 +383,7 @@ static struct xtables_match iprange_mt6_reg = {
 	.extra_opts     = iprange_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&iprange_match);
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index b812b67..8fb2150 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -152,6 +152,7 @@ static struct xtables_match length_match6 = {
 	.extra_opts	= length_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&length_match);
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 65a8df3..e93388b 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -192,6 +192,7 @@ static struct xtables_match limit_match6 = {
 	.extra_opts	= limit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&limit_match);
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 2284d2a..112ac5b 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -143,6 +143,7 @@ static struct xtables_match mac_match6 = {
 	.extra_opts	= mac_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&mac_match);
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index af7f844..1e07736 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -208,6 +208,7 @@ static struct xtables_match mark_mt6_reg = {
 	.extra_opts     = mark_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&mark_match);
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 6de7bc1..7b96e6c 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -569,8 +569,8 @@ static struct xtables_match multiport_match6_v1 = {
 	.extra_opts	= multiport_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&multiport_match);
 	xtables_register_match(&multiport_match6);
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index ea86f99..18f3d9a 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -591,6 +591,7 @@ static struct xtables_match owner_mt6_reg = {
 	.extra_opts    = owner_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&owner_mt_reg_v0);
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index e971d1e..6b5fe20 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -190,6 +190,7 @@ static struct xtables_match physdev_match6 = {
 	.extra_opts	= physdev_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&physdev_match);
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 75194fc..893fe43 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -174,6 +174,7 @@ static struct xtables_match pkttype_match6 = {
 	.extra_opts	= pkttype_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&pkttype_match);
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index b4fb78b..9ce350d 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -103,8 +103,8 @@ struct xtables_match quota_match6 = {
 	.extra_opts	= quota_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&quota_match);
 	xtables_register_match(&quota_match6);
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 5f13340..0771fcd 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -454,6 +454,7 @@ static struct xtables_match rateest_match6 = {
 	.extra_opts	= rateest_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&rateest_match4);
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 2ca1572..af6faba 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -539,6 +539,7 @@ static struct xtables_match sctp_match6 = {
 	.extra_opts	= sctp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&sctp_match);
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index eef9369..2417f09 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -43,6 +43,7 @@ static struct xtables_target standard_target6 = {
 	.parse		= standard_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&standard_target);
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 5b8beea..cbc8419 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -170,6 +170,7 @@ static struct xtables_match state_match6 = {
 	.extra_opts	= state_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&state_match);
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index ebb4e91..5ac77b6 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -193,6 +193,7 @@ static struct xtables_match statistic_match6 = {
 	.extra_opts	= statistic_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&statistic_match);
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index f1030bb..5be14ef 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -356,6 +356,7 @@ static struct xtables_match string_match6 = {
     .extra_opts		= string_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&string_match);
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 3274f08..2026368 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -411,8 +411,8 @@ static struct xtables_match tcp_match6 = {
 	.extra_opts	= tcp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&tcp_match);
 	xtables_register_match(&tcp_match6);
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 7a026bf..36d445c 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -153,6 +153,7 @@ static struct xtables_match tcpmss_match6 = {
 	.extra_opts	= tcpmss_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&tcpmss_match);
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index c39ab1a..3efc727 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -492,6 +492,7 @@ static struct xtables_match time_match6 = {
 	.extra_opts    = time_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&time_match);
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 16a90ef..cd21560 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -182,6 +182,7 @@ static struct xtables_match tos_mt6_reg = {
 	.extra_opts    = tos_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&tos_mt_reg_v0);
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 251b2d4..1e79c57 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -296,6 +296,7 @@ static struct xtables_match u32_match6 = {
 	.extra_opts    = u32_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&u32_match);
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 4e83ae8..2ba781e 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -224,8 +224,8 @@ static struct xtables_match udp_match6 = {
 	.extra_opts	= udp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&udp_match);
 	xtables_register_match(&udp_match6);
diff --git a/include/iptables.h b/include/iptables.h
index f39410c..7ce9080 100644
--- a/include/iptables.h
+++ b/include/iptables.h
@@ -24,8 +24,6 @@ extern int line;
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
-extern u_int16_t parse_protocol(const char *s);
-
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
index 5069689..6e8a565 100644
--- a/include/libiptc/libip6tc.h
+++ b/include/libiptc/libip6tc.h
@@ -152,4 +152,6 @@ const char *ip6tc_strerror(int err);
 /* Return prefix length, or -1 if not contiguous */
 int ipv6_prefix_length(const struct in6_addr *a);
 
+extern void dump_entries6(const ip6tc_handle_t);
+
 #endif /* _LIBIP6TC_H */
diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
index 30f5b7d..1f6f95d 100644
--- a/include/libiptc/libiptc.h
+++ b/include/libiptc/libiptc.h
@@ -159,6 +159,8 @@ int iptc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
 
+extern void dump_entries(const iptc_handle_t);
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/include/xtables.h b/include/xtables.h
index 4b75e2c..f2bcb44 100644
--- a/include/xtables.h
+++ b/include/xtables.h
@@ -267,4 +267,7 @@ extern void save_string(const char *value);
 #	define _init __attribute__((constructor)) _INIT
 #endif
 
+/* Present in both iptables.c and ip6tables.c */
+extern u_int16_t parse_protocol(const char *s);
+
 #endif /* _XTABLES_H */
diff --git a/ip6tables-multi.h b/ip6tables-multi.h
new file mode 100644
index 0000000..551029a
--- /dev/null
+++ b/ip6tables-multi.h
@@ -0,0 +1,8 @@
+#ifndef _IP6TABLES_MULTI_H
+#define _IP6TABLES_MULTI_H 1
+
+extern int ip6tables_main(int, char **);
+extern int ip6tables_save_main(int, char **);
+extern int ip6tables_restore_main(int, char **);
+
+#endif /* _IP6TABLES_MULTI_H */
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 570bd51..e9cc0ff 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -18,6 +18,7 @@
 #include "ip6tables.h"
 #include "xtables.h"
 #include "libiptc/libip6tc.h"
+#include "ip6tables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -55,7 +56,8 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-ip6tc_handle_t create_handle(const char *tablename, const char* modprobe)
+static ip6tc_handle_t create_handle(const char *tablename,
+                                    const char *modprobe)
 {
 	ip6tc_handle_t handle;
 
diff --git a/ip6tables-save.c b/ip6tables-save.c
index c73d354..e7eade1 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
+#include "ip6tables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index b7dfd17..4029c1f 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -35,6 +35,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <ip6tables.h>
+#include "ip6tables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
diff --git a/ip6tables.c b/ip6tables.c
index 4b517e5..e5602f7 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -41,6 +41,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include "ip6tables-multi.h"
 
 #ifndef TRUE
 #define TRUE 1
@@ -186,9 +187,6 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 const char *program_version;
 const char *program_name;
 
-/* Extra debugging from libiptc */
-extern void dump_entries6(const ip6tc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1140,7 +1138,7 @@ generate_entry(const struct ip6t_entry *fw,
 	return e;
 }
 
-void clear_rule_matches(struct ip6tables_rule_match **matches)
+static void clear_rule_matches(struct ip6tables_rule_match **matches)
 {
 	struct ip6tables_rule_match *matchp, *tmp;
 
diff --git a/iptables-multi.h b/iptables-multi.h
new file mode 100644
index 0000000..a9912b0
--- /dev/null
+++ b/iptables-multi.h
@@ -0,0 +1,9 @@
+#ifndef _IPTABLES_MULTI_H
+#define _IPTABLES_MULTI_H 1
+
+extern int iptables_main(int, char **);
+extern int iptables_save_main(int, char **);
+extern int iptables_restore_main(int, char **);
+extern int iptables_xml_main(int, char **);
+
+#endif /* _IPTABLES_MULTI_H */
diff --git a/iptables-restore.c b/iptables-restore.c
index 44263ce..b751d2c 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -15,6 +15,7 @@
 #include "iptables.h"
 #include "xtables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -54,7 +55,7 @@ static void print_usage(const char *name, const char *version)
 	exit(1);
 }
 
-iptc_handle_t create_handle(const char *tablename, const char* modprobe )
+static iptc_handle_t create_handle(const char *tablename, const char *modprobe)
 {
 	iptc_handle_t handle;
 
diff --git a/iptables-save.c b/iptables-save.c
index f82c8a7..c0c37ed 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -15,6 +15,7 @@
 #include <netdb.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
+#include "iptables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
diff --git a/iptables-standalone.c b/iptables-standalone.c
index e5c7841..55c7ce9 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -36,6 +36,7 @@
 #include <errno.h>
 #include <string.h>
 #include <iptables.h>
+#include "iptables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
diff --git a/iptables-xml.c b/iptables-xml.c
index 94f2e39..d922efe 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -16,6 +16,7 @@
 #include <stdarg.h>
 #include "iptables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
diff --git a/iptables.c b/iptables.c
index 0363aba..b2a4b53 100644
--- a/iptables.c
+++ b/iptables.c
@@ -190,8 +190,6 @@ const char *program_name;
 
 int kernel_version;
 
-extern void dump_entries(const iptc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1143,7 +1141,7 @@ generate_entry(const struct ipt_entry *fw,
 	return e;
 }
 
-void clear_rule_matches(struct iptables_rule_match **matches)
+static void clear_rule_matches(struct iptables_rule_match **matches)
 {
 	struct iptables_rule_match *matchp, *tmp;
 
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 113c250..e8f14fc 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -1471,7 +1471,7 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, TC_HANDLE_T *handle)
 }
 
 /* How many rules in this chain? */
-unsigned int
+static unsigned int
 TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 {
 	struct chain_head *c;
@@ -1487,9 +1487,8 @@ TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 	return c->num_rules;
 }
 
-const STRUCT_ENTRY *TC_GET_RULE(const char *chain,
-				unsigned int n,
-				TC_HANDLE_T *handle)
+static const STRUCT_ENTRY *
+TC_GET_RULE(const char *chain, unsigned int n, TC_HANDLE_T *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
@@ -1511,7 +1510,7 @@ const STRUCT_ENTRY *TC_GET_RULE(const char *chain,
 }
 
 /* Returns a pointer to the target name of this position. */
-const char *standard_target_map(int verdict)
+static const char *standard_target_map(int verdict)
 {
 	switch (verdict) {
 		case RETURN:
