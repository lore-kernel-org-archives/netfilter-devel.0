From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 20/24] Change IPTABLES_VERSION to XTABLES_VERSION
Date: Tue, 4 Mar 2008 17:19:43 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803041718330.7660@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35282 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764064AbYCDQTq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:19:46 -0500
In-Reply-To: <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Has the aforementioned GNUmakefile.in and Makefile.am changes that 
should have been in p13 instead.

===
commit d369c0ffd0cf91b719188334f5c0ad31a94d81ad
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Mon Feb 18 12:20:21 2008 +0100

    Change IPTABLES_VERSION to XTABLES_VERSION
---
 configure.ac                    |    2 +-
 extensions/GNUmakefile.in       |    4 +++-
 extensions/libip6t_HL.c         |    4 ++--
 extensions/libip6t_LOG.c        |    4 ++--
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    4 ++--
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_eui64.c      |    4 ++--
 extensions/libip6t_frag.c       |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    4 ++--
 extensions/libip6t_icmp6.c      |    4 ++--
 extensions/libip6t_ipv6header.c |    4 ++--
 extensions/libip6t_mh.c         |    4 ++--
 extensions/libip6t_policy.c     |    4 ++--
 extensions/libip6t_rt.c         |    4 ++--
 extensions/libipt_CLUSTERIP.c   |    4 ++--
 extensions/libipt_DNAT.c        |    4 ++--
 extensions/libipt_ECN.c         |    4 ++--
 extensions/libipt_LOG.c         |    4 ++--
 extensions/libipt_MASQUERADE.c  |    4 ++--
 extensions/libipt_MIRROR.c      |    4 ++--
 extensions/libipt_NETMAP.c      |    4 ++--
 extensions/libipt_REDIRECT.c    |    4 ++--
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    4 ++--
 extensions/libipt_SNAT.c        |    4 ++--
 extensions/libipt_TTL.c         |    4 ++--
 extensions/libipt_ULOG.c        |    4 ++--
 extensions/libipt_addrtype.c    |    4 ++--
 extensions/libipt_ah.c          |    4 ++--
 extensions/libipt_ecn.c         |    4 ++--
 extensions/libipt_icmp.c        |    4 ++--
 extensions/libipt_policy.c      |    4 ++--
 extensions/libipt_realm.c       |    4 ++--
 extensions/libipt_ttl.c         |    4 ++--
 extensions/libipt_unclean.c     |    4 ++--
 extensions/libxt_CLASSIFY.c     |    4 ++--
 extensions/libxt_CONNMARK.c     |   10 +++++-----
 extensions/libxt_CONNSECMARK.c  |    6 +++---
 extensions/libxt_DSCP.c         |    4 ++--
 extensions/libxt_MARK.c         |   10 +++++-----
 extensions/libxt_NFLOG.c        |    6 +++---
 extensions/libxt_NFQUEUE.c      |    4 ++--
 extensions/libxt_NOTRACK.c      |    6 +++---
 extensions/libxt_RATEEST.c      |    4 ++--
 extensions/libxt_SECMARK.c      |    4 ++--
 extensions/libxt_TCPMSS.c       |    6 +++---
 extensions/libxt_TCPOPTSTRIP.c  |    4 ++--
 extensions/libxt_TOS.c          |    8 ++++----
 extensions/libxt_TRACE.c        |    4 ++--
 extensions/libxt_comment.c      |    4 ++--
 extensions/libxt_connbytes.c    |    6 +++---
 extensions/libxt_connlimit.c    |    6 +++---
 extensions/libxt_connmark.c     |    8 ++++----
 extensions/libxt_conntrack.c    |    6 +++---
 extensions/libxt_dccp.c         |    6 +++---
 extensions/libxt_dscp.c         |    6 +++---
 extensions/libxt_esp.c          |    6 +++---
 extensions/libxt_hashlimit.c    |   10 +++++-----
 extensions/libxt_helper.c       |    6 +++---
 extensions/libxt_iprange.c      |    6 +++---
 extensions/libxt_length.c       |    4 ++--
 extensions/libxt_limit.c        |    4 ++--
 extensions/libxt_mac.c          |    6 +++---
 extensions/libxt_mark.c         |    4 ++--
 extensions/libxt_multiport.c    |   12 ++++++------
 extensions/libxt_owner.c        |    8 ++++----
 extensions/libxt_physdev.c      |    6 +++---
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |    4 ++--
 extensions/libxt_recent.c       |    4 ++--
 extensions/libxt_sctp.c         |    6 +++---
 extensions/libxt_standard.c     |    4 ++--
 extensions/libxt_state.c        |    6 +++---
 extensions/libxt_statistic.c    |    4 ++--
 extensions/libxt_string.c       |    4 ++--
 extensions/libxt_tcp.c          |    6 +++---
 extensions/libxt_tcpmss.c       |    6 +++---
 extensions/libxt_time.c         |    4 ++--
 extensions/libxt_tos.c          |    6 +++---
 extensions/libxt_u32.c          |    4 ++--
 extensions/libxt_udp.c          |    6 +++---
 ip6tables-restore.c             |    4 ++--
 ip6tables-save.c                |    4 ++--
 ip6tables-standalone.c          |    2 +-
 iptables-restore.c              |    4 ++--
 iptables-save.c                 |    4 ++--
 iptables-standalone.c           |    2 +-
 iptables-xml.c                  |    4 ++--
 libipq/Makefile.am              |    2 +-
 libiptc/libiptc.c               |    3 ++-
 93 files changed, 218 insertions(+), 215 deletions(-)

diff --git a/configure.ac b/configure.ac
index 4025e0e..b4bd5c0 100644
--- a/configure.ac
+++ b/configure.ac
@@ -40,7 +40,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" == "yes"])
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
-	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
+	-Winline -pipe -DXTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DXTABLES_LIBDIR=\\\"\${xtlibdir}\\\"";
 kinclude_CFLAGS="";
 if [[ -n "$kbuilddir" ]]; then
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 1282a33..2f2c364 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -1,5 +1,7 @@
 # -*- Makefile -*-
 
+top_builddir := @top_builddir@
+builddir    := @builddir@
 top_srcdir  := @top_srcdir@
 srcdir      := @srcdir@
 ksourcedir  := @ksourcedir@
@@ -16,7 +18,7 @@ LDFLAGS        := @LDFLAGS@
 regular_CFLAGS := @regular_CFLAGS@
 kinclude_CFLAGS := @kinclude_CFLAGS@
 
-AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 3104285..f2b5861 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -23,7 +23,7 @@ static void HL_help(void)
 "  --hl-set value		Set HL to <value 0-255>\n"
 "  --hl-dec value		Decrement HL by <value 1-255>\n"
 "  --hl-inc value		Increment HL by <value 1-255>\n"
-, IPTABLES_VERSION);
+, XTABLES_VERSION);
 }
 
 static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -141,7 +141,7 @@ static const struct option HL_opts[] = {
 
 static struct ip6tables_target hl_target6 = {
 	.name 		= "HL",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_HL_info)),
 	.help		= HL_help,
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index e8de148..76a7e53 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -28,7 +28,7 @@ static void LOG_help(void)
 " --log-tcp-options		Log TCP options.\n\n"
 " --log-ip-options		Log IP options.\n\n"
 " --log-uid			Log UID owning the local socket.\n\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option LOG_opts[] = {
@@ -258,7 +258,7 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 
 static struct ip6tables_target log_target6 = {
     .name          = "LOG",
-    .version       = IPTABLES_VERSION,
+    .version       = XTABLES_VERSION,
     .size          = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
     .userspacesize = IP6T_ALIGN(sizeof(struct ip6t_log_info)),
     .help          = LOG_help,
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 9445534..067f2a5 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -140,7 +140,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 
 static struct ip6tables_target reject_target6 = {
 	.name = "REJECT",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size 		= IP6T_ALIGN(sizeof(struct ip6t_reject_info)),
 	.userspacesize 	= IP6T_ALIGN(sizeof(struct ip6t_reject_info)),
 	.help		= REJECT_help,
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index afebdb1..110b1fe 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -16,7 +16,7 @@ static void ah_help(void)
 " --ahspi [!] spi[:spi]         match spi (range)\n"
 " --ahlen [!] length            total length of this header\n"
 " --ahres                       check the reserved filed, too\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option ah_opts[] = {
@@ -195,7 +195,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match ah_match6 = {
 	.name          = "ah",
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_ah)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_ah)),
 	.help          = ah_help,
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 1333418..6cbf9cd 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -19,7 +19,7 @@ static void dst_help(void)
 "  --dst-len [!] length          total length of this header\n"
 "  --dst-opts TYPE[:LEN][,TYPE[:LEN]...]\n"
 "                                Options and its length (list, max: %d)\n",
-IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
+XTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
 static const struct option dst_opts[] = {
@@ -229,7 +229,7 @@ static void dst_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match dst_match6 = {
 	.name          = "dst",
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.help          = dst_help,
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index 7739e30..51bbaf8 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -18,7 +18,7 @@ static void eui64_help(void)
 "eui64 v%s options:\n"
 " This module hasn't got any option\n"
 " This module checks for EUI64 IPv6 addresses\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -31,7 +31,7 @@ static int eui64_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static struct ip6tables_match eui64_target6 = {
 	.name 		= "eui64",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(int)),
 	.userspacesize	= IP6T_ALIGN(sizeof(int)),
 	.help		= eui64_help,
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 834dd06..8ed20d9 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -19,7 +19,7 @@ static void frag_help(void)
 " --fragfirst                   matches on the first fragment\n"
 " [--fragmore|--fraglast]       there are more fragments or this\n"
 "                               is the last one\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option frag_opts[] = {
@@ -240,7 +240,7 @@ static void frag_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match frag_match6 = {
 	.name          = "frag",
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_frag)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_frag)),
 	.help          = frag_help,
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 7ca2b69..ac837ac 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -22,7 +22,7 @@ static void hbh_help(void)
 "  --hbh-len [!] length          total length of this header\n"
 "  --hbh-opts TYPE[:LEN][,TYPE[:LEN]...] \n"
 "                                Options and its length (list, max: %d)\n",
-IPTABLES_VERSION, IP6T_OPTS_OPTSNR);
+XTABLES_VERSION, IP6T_OPTS_OPTSNR);
 }
 
 static const struct option hbh_opts[] = {
@@ -216,7 +216,7 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match hbh_match6 = {
 	.name 		= "hbh",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_opts)),
 	.help		= hbh_help,
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index d2616b8..02c980d 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -22,7 +22,7 @@ static void hl_help(void)
 "  --hl-eq [!] value	Match hop limit value\n"
 "  --hl-lt value	Match HL < value\n"
 "  --hl-gt value	Match HL > value\n"
-, IPTABLES_VERSION);
+, XTABLES_VERSION);
 }
 
 static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -127,7 +127,7 @@ static const struct option hl_opts[] = {
 
 static struct ip6tables_match hl_match6 = {
 	.name          = "hl",
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
 	.userspacesize = IP6T_ALIGN(sizeof(struct ip6t_hl_info)),
 	.help          = hl_help,
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index d9bc785..3e8cc37 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -80,7 +80,7 @@ static void icmp6_help(void)
 "ICMPv6 v%s options:\n"
 " --icmpv6-type [!] typename	match icmpv6 type\n"
 "				(or numeric type or type/code)\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 	print_icmpv6types();
 }
 
@@ -253,7 +253,7 @@ static void icmp6_check(unsigned int flags)
 
 static struct ip6tables_match icmp6_match6 = {
 	.name 		= "icmp6",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_icmp)),
 	.help		= icmp6_help,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 05835ac..7ca50ad 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -144,7 +144,7 @@ static void ipv6header_help(void)
 "                                ipv6-frag,ah,esp,ipv6-nonxt,protocol\n"
 "                       numbers: 0,60,43,44,51,50,59\n"
 "--soft                    The header CONTAINS the specified extensions\n",
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option ipv6header_opts[] = {
@@ -288,7 +288,7 @@ static void ipv6header_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match ipv6header_match6 = {
 	.name		= "ipv6header",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.help		= ipv6header_help,
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index fd3f452..e91a5ad 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -63,7 +63,7 @@ static void mh_help(void)
 	printf(
 "MH v%s options:\n"
 " --mh-type [!] type[:type]	match mh type\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 	print_types_all();
 }
 
@@ -225,7 +225,7 @@ static const struct option mh_opts[] = {
 
 static struct ip6tables_match mh_match6 = {
 	.name		= "mh",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_mh)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_mh)),
 	.help		= mh_help,
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 4c2f405..6cf987d 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -38,7 +38,7 @@ static void policy_help(void)
 "[!] --tunnel-src addr/masklen	match tunnel source\n"
 "[!] --tunnel-dst addr/masklen	match tunnel destination\n"
 "  --next 			begin next element in policy\n",
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option policy_opts[] =
@@ -445,7 +445,7 @@ static void policy_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match policy_match6 = {
 	.name		= "policy",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_policy_info)),
 	.help		= policy_help,
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 33d282f..d33e76d 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -25,7 +25,7 @@ static void rt_help(void)
 " --rt-0-res                    check the reserved filed, too (type 0)\n"
 " --rt-0-addrs ADDR[,ADDR...]   Type=0 addresses (list, max: %d)\n"
 " --rt-0-not-strict             List of Type=0 addresses not a strict list\n",
-IPTABLES_VERSION, IP6T_RT_HOPS);
+XTABLES_VERSION, IP6T_RT_HOPS);
 }
 
 static const struct option rt_opts[] = {
@@ -331,7 +331,7 @@ static void rt_save(const void *ip, const struct xt_entry_match *match)
 
 static struct ip6tables_match rt_match6 = {
 	.name		= "rt",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IP6T_ALIGN(sizeof(struct ip6t_rt)),
 	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_rt)),
 	.help		= rt_help,
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 2314185..dca9a86 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -33,7 +33,7 @@ static void CLUSTERIP_help(void)
 "  --local-node <num>		 Set the local node number\n"
 "  --hash-init <num>		 Set init value of the Jenkins hash\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 #define	PARAM_NEW	0x0001
@@ -237,7 +237,7 @@ static void CLUSTERIP_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target clusterip_target = {
 	.name		= "CLUSTERIP",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_clusterip_tgt_info)),
 	.userspacesize	= offsetof(struct ipt_clusterip_tgt_info, config),
  	.help		= CLUSTERIP_help,
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index a0dbfc5..a98a875 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -28,7 +28,7 @@ static void DNAT_help(void)
 "				Address to map destination to.\n"
 "[--random]\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option DNAT_opts[] = {
@@ -245,7 +245,7 @@ static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target dnat_target = {
 	.name		= "DNAT",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= DNAT_help,
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 8335cca..b216307 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -22,7 +22,7 @@ static void ECN_help(void)
 	printf(
 "ECN target v%s options\n"
 "  --ecn-tcp-remove		Remove all ECN bits from TCP header\n",
-		IPTABLES_VERSION);
+		XTABLES_VERSION);
 }
 
 #if 0
@@ -155,7 +155,7 @@ static void ECN_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target ecn_target = {
 	.name		= "ECN",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ECN_info)),
 	.help		= ECN_help,
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 8287d95..d59d22b 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -28,7 +28,7 @@ static void LOG_help(void)
 " --log-tcp-options		Log TCP options.\n\n"
 " --log-ip-options		Log IP options.\n\n"
 " --log-uid			Log UID owning the local socket.\n\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option LOG_opts[] = {
@@ -260,7 +260,7 @@ static void LOG_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target log_target = {
     .name          = "LOG",
-    .version       = IPTABLES_VERSION,
+    .version       = XTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_log_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_log_info)),
     .help          = LOG_help,
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index c0c519d..671e278 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -19,7 +19,7 @@ static void MASQUERADE_help(void)
 "				Randomize source port.\n"
 "\n"
 ,
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option MASQUERADE_opts[] = {
@@ -153,7 +153,7 @@ MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target masquerade_target = {
 	.name		= "MASQUERADE",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= MASQUERADE_help,
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index 8506eff..cde04a4 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -12,7 +12,7 @@ static void MIRROR_help(void)
 {
 	printf(
 "MIRROR target v%s takes no options\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -25,7 +25,7 @@ static int MIRROR_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static struct iptables_target mirror_target = {
 	.name		= "MIRROR",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
  	.help		= MIRROR_help,
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 0043cca..9bf779d 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -24,7 +24,7 @@ static void NETMAP_help(void)
 	printf(MODULENAME" v%s options:\n"
 	       "  --%s address[/mask]\n"
 	       "				Network address to map to.\n\n",
-	       IPTABLES_VERSION, NETMAP_opts[0].name);
+	       XTABLES_VERSION, NETMAP_opts[0].name);
 }
 
 static u_int32_t
@@ -172,7 +172,7 @@ static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target netmap_target = {
 	.name		= MODULENAME,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= NETMAP_help,
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 0bcc9dd..116b577 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -18,7 +18,7 @@ static void REDIRECT_help(void)
 "REDIRECT v%s options:\n"
 " --to-ports <port>[-<port>]\n"
 "				Port (range) to map to.\n\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option REDIRECT_opts[] = {
@@ -159,7 +159,7 @@ static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target redirect_target = {
 	.name		= "REDIRECT",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= REDIRECT_help,
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index aa139fd..2824a1a 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -159,7 +159,7 @@ static void REJECT_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target reject_target = {
 	.name		= "REJECT",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_reject_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_reject_info)),
 	.help		= REJECT_help,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 9d58bf0..226cecf 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -25,7 +25,7 @@ static void SAME_help(void)
 " --random\n"
 "				Randomize source port\n"
 ,
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option SAME_opts[] = {
@@ -210,7 +210,7 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target same_target = {
 	.name		= "SAME",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_same_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_same_info)),
 	.help		= SAME_help,
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 9a553cd..ea998c2 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -28,7 +28,7 @@ static void SNAT_help(void)
 "				Address to map source to.\n"
 "[--random]\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option SNAT_opts[] = {
@@ -246,7 +246,7 @@ static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 
 static struct iptables_target snat_target = {
 	.name		= "SNAT",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ip_nat_multi_range)),
 	.help		= SNAT_help,
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index e19c3a0..34991cf 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -23,7 +23,7 @@ static void TTL_help(void)
 "  --ttl-set value		Set TTL to <value 0-255>\n"
 "  --ttl-dec value		Decrement TTL by <value 1-255>\n"
 "  --ttl-inc value		Increment TTL by <value 1-255>\n"
-, IPTABLES_VERSION);
+, XTABLES_VERSION);
 }
 
 static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -142,7 +142,7 @@ static const struct option TTL_opts[] = {
 static struct iptables_target ttl_target = {
 	.next		= NULL, 
 	.name		= "TTL",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_TTL_info)),
 	.help		= TTL_help,
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 10301f0..925d62b 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -41,7 +41,7 @@ static void ULOG_help(void)
 	       " --ulog-cprange size		Bytes of each packet to be passed\n"
 	       " --ulog-qthreshold		Threshold of in-kernel queue\n"
 	       " --ulog-prefix prefix		Prefix log messages with this prefix.\n\n",
-	       IPTABLES_VERSION);
+	       XTABLES_VERSION);
 }
 
 static const struct option ULOG_opts[] = {
@@ -188,7 +188,7 @@ static void ULOG_print(const void *ip, const struct xt_entry_target *target,
 
 static struct iptables_target ulog_target = {
 	.name		= "ULOG",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ulog_info)),
 	.help		= ULOG_help,
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 02752d3..388467f 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -44,7 +44,7 @@ static void addrtype_help(void)
 " [!] --dst-type type[,...]      Match destination address type\n"
 "\n"
 "Valid types:           \n"
-, IPTABLES_VERSION);
+, XTABLES_VERSION);
 	addrtype_help_types();
 }
 
@@ -185,7 +185,7 @@ static const struct option addrtype_opts[] = {
 
 static struct iptables_match addrtype_match = {
 	.name 		= "addrtype",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size 		= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_addrtype_info)),
 	.help 		= addrtype_help,
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 5d9ab6c..92e412f 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -15,7 +15,7 @@ static void ah_help(void)
 "AH v%s options:\n"
 " --ahspi [!] spi[:spi]\n"
 "				match spi (range)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option ah_opts[] = {
@@ -158,7 +158,7 @@ static void ah_save(const void *ip, const struct xt_entry_match *match)
 
 static struct iptables_match ah_match = {
 	.name 		= "ah",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ah)),
 	.userspacesize 	= IPT_ALIGN(sizeof(struct ipt_ah)),
 	.help 		= ah_help,
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 5c0428d..44a3c22 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -23,7 +23,7 @@ static void ecn_help(void)
 "[!] --ecn-tcp-cwr 		Match CWR bit of TCP header\n"
 "[!] --ecn-tcp-ece		Match ECE bit of TCP header\n"
 "[!] --ecn-ip-ect [0..3]	Match ECN codepoint in IPv4 header\n",
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option ecn_opts[] = {
@@ -146,7 +146,7 @@ static void ecn_save(const void *ip, const struct xt_entry_match *match)
 
 static struct iptables_match ecn_match = {
     .name          = "ecn",
-    .version       = IPTABLES_VERSION,
+    .version       = XTABLES_VERSION,
     .size          = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
     .userspacesize = IPT_ALIGN(sizeof(struct ipt_ecn_info)),
     .help          = ecn_help,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index df57a5e..69c0347 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -104,7 +104,7 @@ static void icmp_help(void)
 "ICMP v%s options:\n"
 " --icmp-type [!] typename	match icmp type\n"
 "				(or numeric type or type/code)\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 	print_icmptypes();
 }
 
@@ -276,7 +276,7 @@ static void icmp_save(const void *ip, const struct xt_entry_match *match)
 
 static struct iptables_match icmp_match = {
 	.name		= "icmp",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_icmp)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_icmp)),
 	.help		= icmp_help,
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index cdef750..e320017 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -37,7 +37,7 @@ static void policy_help(void)
 "[!] --tunnel-src addr/mask	match tunnel source\n"
 "[!] --tunnel-dst addr/mask	match tunnel destination\n"
 "  --next 			begin next element in policy\n",
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option policy_opts[] =
@@ -410,7 +410,7 @@ static void policy_save(const void *ip, const struct xt_entry_match *match)
 
 static struct iptables_match policy_match = {
 	.name		= "policy",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_policy_info)),
 	.help		= policy_help,
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 73444de..6795dd4 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -21,7 +21,7 @@ static void realm_help(void)
 "realm v%s options:\n"
 " --realm [!] value[/mask]\n"
 "				Match realm\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option realm_opts[] = {
@@ -245,7 +245,7 @@ static void realm_check(unsigned int flags)
 
 static struct iptables_match realm_match = {
 	.name		= "realm",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_realm_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_realm_info)),
 	.help		= realm_help,
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index d358dfc..feee70b 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -21,7 +21,7 @@ static void ttl_help(void)
 "  --ttl-eq value	Match time to live value\n"
 "  --ttl-lt value	Match TTL < value\n"
 "  --ttl-gt value	Match TTL > value\n"
-, IPTABLES_VERSION);
+, XTABLES_VERSION);
 }
 
 static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -150,7 +150,7 @@ static const struct option ttl_opts[] = {
 
 static struct iptables_match ttl_match = {
 	.name		= "ttl",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_ttl_info)),
 	.help		= ttl_help,
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 9956c1a..b15d62f 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -9,7 +9,7 @@ static void unclean_help(void)
 {
 	printf(
 "unclean v%s takes no options\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -22,7 +22,7 @@ static int unclean_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static struct iptables_match unclean_match = {
 	.name		= "unclean",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= IPT_ALIGN(0),
 	.userspacesize	= IPT_ALIGN(0),
 	.help		= unclean_help,
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 1bf9494..e8506fe 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -18,7 +18,7 @@ CLASSIFY_help(void)
 "CLASSIFY target v%s options:\n"
 "  --set-class [MAJOR:MINOR]    Set skb->priority value\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option CLASSIFY_opts[] = {
@@ -105,7 +105,7 @@ CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target classify_target = { 
 	.family		= AF_UNSPEC,
 	.name		= "CLASSIFY",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_classify_target_info)),
 	.help		= CLASSIFY_help,
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 73f8214..a064d72 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -42,7 +42,7 @@ static void CONNMARK_help(void)
 "  --save-mark [--mask mask]     Save the packet nfmark in the connection\n"
 "  --restore-mark [--mask mask]  Restore saved nfmark value\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option CONNMARK_opts[] = {
@@ -410,7 +410,7 @@ static struct xtables_target connmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNMARK",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
@@ -426,7 +426,7 @@ static struct xtables_target connmark_target6 = {
 	.family		= AF_INET6,
 	.name		= "CONNMARK",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_target_info)),
 	.help		= CONNMARK_help,
@@ -439,7 +439,7 @@ static struct xtables_target connmark_target6 = {
 };
 
 static struct xtables_target connmark_tg_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "CONNMARK",
 	.revision       = 1,
 	.family         = AF_INET,
@@ -455,7 +455,7 @@ static struct xtables_target connmark_tg_reg = {
 };
 
 static struct xtables_target connmark_tg6_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "CONNMARK",
 	.revision       = 1,
 	.family         = AF_INET6,
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 779594f..4d9a682 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -21,7 +21,7 @@ static void CONNSECMARK_help(void)
 "  --save                   Copy security mark from packet to conntrack\n"
 "  --restore                Copy security mark from connection to packet\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option CONNSECMARK_opts[] = {
@@ -111,7 +111,7 @@ CONNSECMARK_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target connsecmark_target = {
 	.family		= AF_INET,
 	.name		= "CONNSECMARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
@@ -126,7 +126,7 @@ static struct xtables_target connsecmark_target = {
 static struct xtables_target connsecmark_target6 = {
 	.family		= AF_INET6,
 	.name		= "CONNSECMARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connsecmark_target_info)),
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 3a99b33..7012647 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -135,7 +135,7 @@ static void DSCP_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target dscp_target = {
 	.family		= AF_INET,
 	.name		= "DSCP",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= DSCP_help,
@@ -149,7 +149,7 @@ static struct xtables_target dscp_target = {
 static struct xtables_target dscp_target6 = {
 	.family		= AF_INET6,
 	.name		= "DSCP",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_DSCP_info)),
 	.help		= DSCP_help,
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 4003d26..167db21 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -22,7 +22,7 @@ static void MARK_help(void)
 "  --and-mark value                   Binary AND the nfmark with value\n"
 "  --or-mark  value                   Binary OR  the nfmark with value\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option MARK_opts[] = {
@@ -287,7 +287,7 @@ static void mark_tg_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target mark_target_v0 = {
 	.family		= AF_INET,
 	.name		= "MARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
@@ -302,7 +302,7 @@ static struct xtables_target mark_target_v0 = {
 static struct xtables_target mark_target_v1 = {
 	.family		= AF_INET,
 	.name		= "MARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info_v1)),
@@ -317,7 +317,7 @@ static struct xtables_target mark_target_v1 = {
 static struct xtables_target mark_target6_v0 = {
 	.family		= AF_INET6,
 	.name		= "MARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_target_info)),
@@ -330,7 +330,7 @@ static struct xtables_target mark_target6_v0 = {
 };
 
 static struct xtables_target mark_tg_reg_v2 = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "MARK",
 	.revision      = 2,
 	.family        = AF_UNSPEC,
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 4b6c5a9..e343ee6 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -29,7 +29,7 @@ static void NFLOG_help(void)
 	       " --nflog-range NUM		Number of byte to copy\n"
 	       " --nflog-threshold NUM		Message threshold of in-kernel queue\n"
 	       " --nflog-prefix STRING		Prefix string for log messages\n\n",
-	       IPTABLES_VERSION);
+	       XTABLES_VERSION);
 }
 
 static void NFLOG_init(struct xt_entry_target *t)
@@ -142,7 +142,7 @@ static void NFLOG_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target nflog_target = {
 	.family		= AF_INET,
 	.name		= "NFLOG",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.help		= NFLOG_help,
@@ -156,7 +156,7 @@ static struct xtables_target nflog_target = {
 static struct xtables_target nflog_target6 = {
 	.family		= AF_INET6,
 	.name		= "NFLOG",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_nflog_info)),
 	.help		= NFLOG_help,
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 287c1c8..58fb881 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -83,7 +83,7 @@ static void NFQUEUE_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target nfqueue_target = {
 	.family		= AF_INET,
 	.name		= "NFQUEUE",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= NFQUEUE_help,
@@ -96,7 +96,7 @@ static struct xtables_target nfqueue_target = {
 static struct xtables_target nfqueue_target6 = {
 	.family		= AF_INET6,
 	.name		= "NFQUEUE",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_NFQ_info)),
 	.help		= NFQUEUE_help,
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index cb6bd1e..f613369 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -12,7 +12,7 @@ static void NOTRACK_help(void)
 {
 	printf(
 "NOTRACK target v%s takes no options\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -27,7 +27,7 @@ NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_target notrack_target = {
 	.family		= AF_INET,
 	.name		= "NOTRACK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= NOTRACK_help,
@@ -37,7 +37,7 @@ static struct xtables_target notrack_target = {
 static struct xtables_target notrack_target6 = {
 	.family		= AF_INET6,
 	.name		= "NOTRACK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= NOTRACK_help,
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 6918f76..cee9c82 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -23,7 +23,7 @@ RATEEST_help(void)
 "  --rateest-interval sec	Rate measurement interval in seconds\n"
 "  --rateest-ewmalog value	Rate measurement averaging time constant\n"
 "\n",
-	       IPTABLES_VERSION);
+	       XTABLES_VERSION);
 }
 
 enum RATEEST_options {
@@ -206,7 +206,7 @@ RATEEST_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target rateest_tg_reg = {
 	.family		= AF_UNSPEC,
 	.name		= "RATEEST",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.help		= RATEEST_help,
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index d143037..a71d028 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -20,7 +20,7 @@ static void SECMARK_help(void)
 "SECMARK target v%s options:\n"
 "  --selctx value                     Set the SELinux security context\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option SECMARK_opts[] = {
@@ -102,7 +102,7 @@ static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target secmark_target = {
 	.family		= AF_UNSPEC,
 	.name		= "SECMARK",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_target_info)),
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index f4a45c3..9b9602b 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -23,7 +23,7 @@ static void __TCPMSS_help(int hdrsize)
 "TCPMSS target v%s mutually-exclusive options:\n"
 "  --set-mss value               explicitly set MSS option to specified value\n"
 "  --clamp-mss-to-pmtu           automatically clamp MSS value to (path_MTU - %d)\n",
-IPTABLES_VERSION, hdrsize);
+XTABLES_VERSION, hdrsize);
 }
 
 static void TCPMSS_help(void)
@@ -126,7 +126,7 @@ static void TCPMSS_save(const void *ip, const struct xt_entry_target *target)
 static struct xtables_target tcpmss_target = {
 	.family		= AF_INET,
 	.name		= "TCPMSS",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= TCPMSS_help,
@@ -140,7 +140,7 @@ static struct xtables_target tcpmss_target = {
 static struct xtables_target tcpmss_target6 = {
 	.family		= AF_INET6,
 	.name		= "TCPMSS",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_info)),
 	.help		= TCPMSS_help6,
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 22e921a..0318421 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -176,7 +176,7 @@ tcpoptstrip_tg_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target tcpoptstrip_tg_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "TCPOPTSTRIP",
 	.family        = AF_INET,
 	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
@@ -191,7 +191,7 @@ static struct xtables_target tcpoptstrip_tg_reg = {
 };
 
 static struct xtables_target tcpoptstrip_tg6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "TCPOPTSTRIP",
 	.family        = AF_INET6,
 	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index dfc7af7..bf94916 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -59,7 +59,7 @@ static void tos_tg_help(void)
 "  --set-tos symbol        Set TOS field (IPv4 only) by symbol\n"
 "                          (this zeroes the 4-bit Precedence part!)\n"
 "                          Accepted symbolic names for value are:\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 
 	for (symbol = tos_symbol_names; symbol->name != NULL; ++symbol)
 		printf("                            (0x%02x) %2u %s\n",
@@ -205,7 +205,7 @@ static void tos_tg_save(const void *ip, const struct xt_entry_target *target)
 }
 
 static struct xtables_target tos_tg_reg_v0 = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "TOS",
 	.revision      = 0,
 	.family        = AF_INET,
@@ -220,7 +220,7 @@ static struct xtables_target tos_tg_reg_v0 = {
 };
 
 static struct xtables_target tos_tg_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "TOS",
 	.revision      = 1,
 	.family        = AF_INET,
@@ -235,7 +235,7 @@ static struct xtables_target tos_tg_reg = {
 };
 
 static struct xtables_target tos_tg6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "TOS",
 	.family        = AF_INET6,
 	.revision      = 1,
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 7241f2b..4b13ed4 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -12,7 +12,7 @@ static void TRACE_help(void)
 {
 	printf(
 "TRACE target v%s takes no options\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -26,7 +26,7 @@ static int TRACE_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_target trace_target = {
 	.family		= AF_UNSPEC,
 	.name		= "TRACE",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(0),
 	.userspacesize	= XT_ALIGN(0),
 	.help		= TRACE_help,
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 8ae77fc..b16c721 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -96,7 +96,7 @@ comment_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match comment_match = {
 	.family		= AF_INET,
 	.name		= "comment",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.help		= comment_help,
@@ -110,7 +110,7 @@ static struct xtables_match comment_match = {
 static struct xtables_match comment_match6 = {
 	.family		= AF_INET6,
 	.name		= "comment",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_comment_info)),
 	.help		= comment_help,
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 9fd5a47..f0e0152 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -16,7 +16,7 @@ static void connbytes_help(void)
 " [!] --connbytes from:[to]\n"
 "     --connbytes-dir [original, reply, both]\n"
 "     --connbytes-mode [packets, bytes, avgpkt]\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option connbytes_opts[] = {
@@ -188,7 +188,7 @@ static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match connbytes_match = {
 	.family		= AF_INET,
 	.name 		= "connbytes",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.help		= connbytes_help,
@@ -202,7 +202,7 @@ static struct xtables_match connbytes_match = {
 static struct xtables_match connbytes_match6 = {
 	.family		= AF_INET6,
 	.name 		= "connbytes",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connbytes_info)),
 	.help		= connbytes_help,
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index 2b4d3d5..19f46a7 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -15,7 +15,7 @@ static void connlimit_help(void)
 "[!] --connlimit-above n        match if the number of existing "
 "                               connections is (not) above n\n"
 "    --connlimit-mask n         group hosts using mask\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option connlimit_opts[] = {
@@ -181,7 +181,7 @@ static void connlimit_save6(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match connlimit_match = {
 	.name          = "connlimit",
 	.family        = AF_INET,
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
 	.userspacesize = offsetof(struct xt_connlimit_info, data),
 	.help          = connlimit_help,
@@ -196,7 +196,7 @@ static struct xtables_match connlimit_match = {
 static struct xtables_match connlimit_match6 = {
 	.name          = "connlimit",
 	.family        = AF_INET6,
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_connlimit_info)),
 	.userspacesize = offsetof(struct xt_connlimit_info, data),
 	.help          = connlimit_help,
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index dd43359..912f053 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -172,7 +172,7 @@ static struct xtables_match connmark_mt_reg_v0 = {
 	.family		= AF_INET,
 	.name		= "connmark",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.help		= connmark_mt_help,
@@ -187,7 +187,7 @@ static struct xtables_match connmark_mt6_reg_v0 = {
 	.family		= AF_INET6,
 	.name		= "connmark",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_connmark_info)),
 	.help		= connmark_mt_help,
@@ -199,7 +199,7 @@ static struct xtables_match connmark_mt6_reg_v0 = {
 };
 
 static struct xtables_match connmark_mt_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "connmark",
 	.revision       = 1,
 	.family         = AF_INET,
@@ -214,7 +214,7 @@ static struct xtables_match connmark_mt_reg = {
 };
 
 static struct xtables_match connmark_mt6_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "connmark",
 	.revision       = 1,
 	.family         = AF_INET6,
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index d5f1be7..fc2ba42 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -1017,7 +1017,7 @@ static void conntrack_mt6_save(const void *ip,
 }
 
 static struct xtables_match conntrack_match = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 0,
 	.family        = AF_INET,
@@ -1032,7 +1032,7 @@ static struct xtables_match conntrack_match = {
 };
 
 static struct xtables_match conntrack_mt_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
 	.family        = AF_INET,
@@ -1047,7 +1047,7 @@ static struct xtables_match conntrack_mt_reg = {
 };
 
 static struct xtables_match conntrack_mt6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "conntrack",
 	.revision      = 1,
 	.family        = AF_INET6,
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index d21de16..97daf4a 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -41,7 +41,7 @@ static void dccp_help(void)
 " --destination-port [!] port[:port]                     match destination port(s)\n"
 " --dport ...\n"
 ,
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option dccp_opts[] = {
@@ -342,7 +342,7 @@ static void dccp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match dccp_match = {
 	.name		= "dccp",
 	.family		= AF_INET,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.help		= dccp_help,
@@ -356,7 +356,7 @@ static struct xtables_match dccp_match = {
 static struct xtables_match dccp_match6 = {
 	.name		= "dccp",
 	.family		= AF_INET6,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.help		= dccp_help,
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 75941ab..97dafac 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -35,7 +35,7 @@ static void dscp_help(void)
 "				be any of the BE,EF, AFxx or CSx classes\n"
 "\n"
 "				These two options are mutually exclusive !\n"
-				, IPTABLES_VERSION
+				, XTABLES_VERSION
 );
 }
 
@@ -149,7 +149,7 @@ static void dscp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match dscp_match = {
 	.family		= AF_INET,
 	.name 		= "dscp",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.help		= dscp_help,
@@ -163,7 +163,7 @@ static struct xtables_match dscp_match = {
 static struct xtables_match dscp_match6 = {
 	.family		= AF_INET6,
 	.name 		= "dscp",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size 		= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dscp_info)),
 	.help		= dscp_help,
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index b20999d..45b2c8b 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -15,7 +15,7 @@ static void esp_help(void)
 "ESP v%s options:\n"
 " --espspi [!] spi[:spi]\n"
 "				match spi (range)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option esp_opts[] = {
@@ -156,7 +156,7 @@ static void esp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match esp_match = {
 	.family		= AF_INET,
 	.name 		= "esp",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
@@ -170,7 +170,7 @@ static struct xtables_match esp_match = {
 static struct xtables_match esp_match6 = {
 	.family		= AF_INET6,
 	.name 		= "esp",
-	.version 	= IPTABLES_VERSION,
+	.version 	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_esp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_esp)),
 	.help		= esp_help,
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index e430f93..3445c9d 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -42,7 +42,7 @@ static void hashlimit_help(void)
 "[--hashlimit-htable-max <num>]	number of hashtable entries\n"
 "[--hashlimit-htable-gcinterval]	interval between garbage collection runs\n"
 "[--hashlimit-htable-expire]	after which time are idle entries expired?\n"
-"\n", IPTABLES_VERSION, XT_HASHLIMIT_BURST);
+"\n", XTABLES_VERSION, XT_HASHLIMIT_BURST);
 }
 
 static void hashlimit_mt_help(void)
@@ -671,7 +671,7 @@ hashlimit_mt6_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match hashlimit_match = {
 	.family		= AF_INET,
 	.name		= "hashlimit",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
@@ -687,7 +687,7 @@ static struct xtables_match hashlimit_match = {
 static struct xtables_match hashlimit_match6 = {
 	.family		= AF_INET6,
 	.name		= "hashlimit",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 0,
 	.size		= XT_ALIGN(sizeof(struct xt_hashlimit_info)),
 	.userspacesize	= offsetof(struct xt_hashlimit_info, hinfo),
@@ -701,7 +701,7 @@ static struct xtables_match hashlimit_match6 = {
 };
 
 static struct xtables_match hashlimit_mt_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "hashlimit",
 	.revision       = 1,
 	.family         = AF_INET,
@@ -717,7 +717,7 @@ static struct xtables_match hashlimit_mt_reg = {
 };
 
 static struct xtables_match hashlimit_mt6_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "hashlimit",
 	.revision       = 1,
 	.family         = AF_INET6,
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 4ce1d4b..a028bbc 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -15,7 +15,7 @@ static void helper_help(void)
 "helper match v%s options:\n"
 "[!] --helper string        Match helper identified by string\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option helper_opts[] = {
@@ -79,7 +79,7 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match helper_match = {
 	.family		= AF_INET,
 	.name		= "helper",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
 	.help		= helper_help,
 	.parse		= helper_parse,
@@ -92,7 +92,7 @@ static struct xtables_match helper_match = {
 static struct xtables_match helper_match6 = {
 	.family		= AF_INET6,
 	.name		= "helper",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_helper_info)),
 	.help		= helper_help,
 	.parse		= helper_parse,
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 54d7d9c..f0c4f5b 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -339,7 +339,7 @@ static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match iprange_match = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "iprange",
 	.revision      = 0,
 	.family        = AF_INET,
@@ -354,7 +354,7 @@ static struct xtables_match iprange_match = {
 };
 
 static struct xtables_match iprange_mt_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "iprange",
 	.revision       = 1,
 	.family         = AF_INET,
@@ -369,7 +369,7 @@ static struct xtables_match iprange_mt_reg = {
 };
 
 static struct xtables_match iprange_mt6_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "iprange",
 	.revision       = 1,
 	.family         = AF_INET6,
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 136034c..ae64942 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -15,7 +15,7 @@ static void length_help(void)
 "length v%s options:\n"
 "[!] --length length[:length]    Match packet length against value or range\n"
 "                                of values (inclusive)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 
 }
   
@@ -127,7 +127,7 @@ static void length_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match length_match = {
 	.family		= AF_UNSPEC,
 	.name		= "length",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_length_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_length_info)),
 	.help		= length_help,
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index da64750..6898758 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -26,7 +26,7 @@ static void limit_help(void)
 "                                [Packets per second unless followed by \n"
 "                                /sec /minute /hour /day postfixes]\n"
 "--limit-burst number		number to match in a burst, default %u\n"
-"\n", IPTABLES_VERSION, XT_LIMIT_BURST);
+"\n", XTABLES_VERSION, XT_LIMIT_BURST);
 }
 
 static const struct option limit_opts[] = {
@@ -167,7 +167,7 @@ static void limit_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match limit_match = {
 	.family		= AF_UNSPEC,
 	.name		= "limit",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateinfo)),
 	.userspacesize	= offsetof(struct xt_rateinfo, prev),
 	.help		= limit_help,
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 112ac5b..9b76a9a 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -19,7 +19,7 @@ static void mac_help(void)
 "MAC v%s options:\n"
 " --mac-source [!] XX:XX:XX:XX:XX:XX\n"
 "				Match source MAC address\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option mac_opts[] = {
@@ -118,7 +118,7 @@ static void mac_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match mac_match = {
 	.family		= AF_INET,
  	.name		= "mac",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.help		= mac_help,
@@ -132,7 +132,7 @@ static struct xtables_match mac_match = {
 static struct xtables_match mac_match6 = {
 	.family		= AF_INET6,
  	.name		= "mac",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mac_info)),
 	.help		= mac_help,
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index e805a2b..be66169 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -152,7 +152,7 @@ static struct xtables_match mark_match = {
 	.family		= AF_UNSPEC,
 	.name		= "mark",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_mark_info)),
 	.help		= mark_mt_help,
@@ -164,7 +164,7 @@ static struct xtables_match mark_match = {
 };
 
 static struct xtables_match mark_mt_reg = {
-	.version        = IPTABLES_VERSION,
+	.version        = XTABLES_VERSION,
 	.name           = "mark",
 	.revision       = 1,
 	.family         = AF_UNSPEC,
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 7b96e6c..7d3c122 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -25,7 +25,7 @@ static void multiport_help(void)
 " --ports port[,port,port]\n"
 "				match both source and destination port(s)\n"
 " NOTE: this kernel does not support port ranges in multiport.\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static void multiport_help_v1(void)
@@ -40,7 +40,7 @@ static void multiport_help_v1(void)
 "				match destination port(s)\n"
 " --ports [!] port[,port:port,port]\n"
 "				match both source and destination port(s)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option multiport_opts[] = {
@@ -513,7 +513,7 @@ static struct xtables_match multiport_match = {
 	.family		= AF_INET,
 	.name		= "multiport",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
 	.help		= multiport_help,
@@ -528,7 +528,7 @@ static struct xtables_match multiport_match6 = {
 	.family		= AF_INET6,
 	.name		= "multiport",
 	.revision	= 0,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
 	.help		= multiport_help,
@@ -542,7 +542,7 @@ static struct xtables_match multiport_match6 = {
 static struct xtables_match multiport_match_v1 = {
 	.family		= AF_INET,
 	.name		= "multiport",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
@@ -557,7 +557,7 @@ static struct xtables_match multiport_match_v1 = {
 static struct xtables_match multiport_match6_v1 = {
 	.family		= AF_INET6,
 	.name		= "multiport",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.revision	= 1,
 	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 18f3d9a..221fdaf 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -532,7 +532,7 @@ static void owner_mt_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match owner_mt_reg_v0 = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 0,
 	.family        = AF_INET,
@@ -547,7 +547,7 @@ static struct xtables_match owner_mt_reg_v0 = {
 };
 
 static struct xtables_match owner_mt6_reg_v0 = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 0,
 	.family        = AF_INET6,
@@ -562,7 +562,7 @@ static struct xtables_match owner_mt6_reg_v0 = {
 };
 
 static struct xtables_match owner_mt_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 1,
 	.family        = AF_INET,
@@ -577,7 +577,7 @@ static struct xtables_match owner_mt_reg = {
 };
 
 static struct xtables_match owner_mt6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "owner",
 	.revision      = 1,
 	.family        = AF_INET6,
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 6b5fe20..ceb42a7 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -21,7 +21,7 @@ static void physdev_help(void)
 " [!] --physdev-is-in			arrived on a bridge device\n"
 " [!] --physdev-is-out			will leave on a bridge device\n"
 " [!] --physdev-is-bridged		it's a bridged packet\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option physdev_opts[] = {
@@ -165,7 +165,7 @@ static void physdev_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match physdev_match = {
 	.family		= AF_INET,
 	.name		= "physdev",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.help		= physdev_help,
@@ -179,7 +179,7 @@ static struct xtables_match physdev_match = {
 static struct xtables_match physdev_match6 = {
 	.family		= AF_INET6,
 	.name		= "physdev",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_physdev_info)),
 	.help		= physdev_help,
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index a5cf90a..ab41867 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -149,7 +149,7 @@ static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match pkttype_match = {
 	.family		= AF_UNSPEC,
 	.name		= "pkttype",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_pkttype_info)),
 	.help		= pkttype_help,
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index f73089d..1482dd9 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -80,7 +80,7 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 struct xtables_match quota_match = {
 	.family		= AF_UNSPEC,
 	.name		= "quota",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof (struct xt_quota_info)),
 	.userspacesize	= offsetof(struct xt_quota_info, quota),
 	.help		= quota_help,
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 69edaba..d959899 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -25,7 +25,7 @@ static void rateest_help(void)
 " [!] --rateest-gt		Match if rate is greater than given rate/estimator\n"
 " [!] --rateest-eq		Match if rate is equal to given rate/estimator\n"
 "\n",
-	       IPTABLES_VERSION);
+	       XTABLES_VERSION);
 }
 
 enum rateest_options {
@@ -429,7 +429,7 @@ rateest_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match rateest_mt_reg = {
 	.family		= AF_UNSPEC,
 	.name		= "rateest",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
 	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
 	.help		= rateest_help,
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 5b0112f..391a32f 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -211,7 +211,7 @@ static void recent_save(const void *ip, const struct xt_entry_match *match)
 /* Structure for iptables to use to communicate with module */
 static struct xtables_match recent_match = {
     .name          = "recent",
-    .version       = IPTABLES_VERSION,
+    .version       = XTABLES_VERSION,
     .family        = AF_INET,
     .size          = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
     .userspacesize = XT_ALIGN(sizeof(struct xt_recent_mtinfo)),
@@ -225,7 +225,7 @@ static struct xtables_match recent_match = {
 };
 
 static struct xtables_match recent_mt6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "recent",
 	.revision      = 0,
 	.family        = AF_INET6,
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index af6faba..4ab6aab 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -64,7 +64,7 @@ static void sctp_help(void)
 " --chunk-types [!] (all|any|none) (chunktype[:flags])+	match if all, any or none of\n"
 "						        chunktypes are present\n"
 "chunktypes - DATA INIT INIT_ACK SACK HEARTBEAT HEARTBEAT_ACK ABORT SHUTDOWN SHUTDOWN_ACK ERROR COOKIE_ECHO COOKIE_ACK ECN_ECNE ECN_CWR SHUTDOWN_COMPLETE ASCONF ASCONF_ACK ALL NONE\n",
-	IPTABLES_VERSION);
+	XTABLES_VERSION);
 }
 
 static const struct option sctp_opts[] = {
@@ -514,7 +514,7 @@ static void sctp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match sctp_match = {
 	.name		= "sctp",
 	.family		= AF_INET,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.help		= sctp_help,
@@ -528,7 +528,7 @@ static struct xtables_match sctp_match = {
 static struct xtables_match sctp_match6 = {
 	.name		= "sctp",
 	.family		= AF_INET6,
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_sctp_info)),
 	.help		= sctp_help,
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 68bf16d..b78fa25 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -12,7 +12,7 @@ static void standard_help(void)
 {
 	printf(
 "Standard v%s options:\n"
-"(If target is DROP, ACCEPT, RETURN or nothing)\n", IPTABLES_VERSION);
+"(If target is DROP, ACCEPT, RETURN or nothing)\n", XTABLES_VERSION);
 }
 
 /* Function which parses command options; returns true if it
@@ -26,7 +26,7 @@ static int standard_parse(int c, char **argv, int invert, unsigned int *flags,
 static struct xtables_target standard_target = {
 	.family		= AF_UNSPEC,
 	.name		= "standard",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(int)),
 	.userspacesize	= XT_ALIGN(sizeof(int)),
 	.help		= standard_help,
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index cbc8419..0640544 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -20,7 +20,7 @@ state_help(void)
 "state v%s options:\n"
 " [!] --state [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED][,...]\n"
 "				State(s) to match\n"
-"\n", IPTABLES_VERSION);
+"\n", XTABLES_VERSION);
 }
 
 static const struct option state_opts[] = {
@@ -145,7 +145,7 @@ static void state_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match state_match = { 
 	.family		= AF_INET,
 	.name		= "state",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
 	.help		= state_help,
@@ -159,7 +159,7 @@ static struct xtables_match state_match = {
 static struct xtables_match state_match6 = { 
 	.family		= AF_INET6,
 	.name		= "state",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_state_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_state_info)),
 	.help		= state_help,
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 67cf9e3..c2a921e 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -19,7 +19,7 @@ static void statistic_help(void)
 " --every n			 Match every nth packet\n"
 " --packet p			 Initial counter value (0 <= p <= n-1, default 0)\n"
 "\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option statistic_opts[] = {
@@ -166,7 +166,7 @@ static void statistic_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match statistic_match = {
 	.family		= AF_UNSPEC,
 	.name		= "statistic",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_statistic_info)),
 	.userspacesize	= offsetof(struct xt_statistic_info, u.nth.count),
 	.init		= statistic_mt_init,
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 182d474..1482614 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -40,7 +40,7 @@ static void string_help(void)
 "--algo	                      Algorithm\n"
 "--string [!] string          Match a string in a packet\n"
 "--hex-string [!] string      Match a hex string in a packet\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option string_opts[] = {
@@ -328,7 +328,7 @@ static void string_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match string_match = {
     .name		= "string",
     .family		= AF_UNSPEC,
-    .version		= IPTABLES_VERSION,
+    .version		= XTABLES_VERSION,
     .size		= XT_ALIGN(sizeof(struct xt_string_info)),
     .userspacesize	= offsetof(struct xt_string_info, config),
     .help		= string_help,
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 2026368..18b8eb9 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -23,7 +23,7 @@ static void tcp_help(void)
 " --dport ...\n"
 "				match destination port(s)\n"
 " --tcp-option [!] number       match if TCP option set\n\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option tcp_opts[] = {
@@ -386,7 +386,7 @@ static void tcp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match tcp_match = {
 	.family		= AF_INET,
 	.name		= "tcp",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
 	.help		= tcp_help,
@@ -400,7 +400,7 @@ static struct xtables_match tcp_match = {
 static struct xtables_match tcp_match6 = {
 	.family		= AF_INET6,
 	.name		= "tcp",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
 	.help		= tcp_help,
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 36d445c..d90dbbb 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -15,7 +15,7 @@ static void tcpmss_help(void)
 "tcpmss match v%s options:\n"
 "[!] --mss value[:value]	Match TCP MSS range.\n"
 "				(only valid for TCP SYN or SYN/ACK packets)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option tcpmss_opts[] = {
@@ -128,7 +128,7 @@ static void tcpmss_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match tcpmss_match = {
 	.family		= AF_INET,
 	.name		= "tcpmss",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.help		= tcpmss_help,
@@ -142,7 +142,7 @@ static struct xtables_match tcpmss_match = {
 static struct xtables_match tcpmss_match6 = {
 	.family		= AF_INET6,
 	.name		= "tcpmss",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpmss_match_info)),
 	.help		= tcpmss_help,
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 3a9ccd6..b682705 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -61,7 +61,7 @@ static void time_help(void)
 "                       (Possible days: Mon,Tue,Wed,Thu,Fri,Sat,Sun or 1 to 7\n"
 "                       Defaults to all weekdays.)\n"
 "  --localtz/--utc      Time is interpreted as UTC/local time\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static void time_init(struct xt_entry_match *m)
@@ -467,7 +467,7 @@ static void time_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match time_match = {
 	.name          = "time",
 	.family        = AF_UNSPEC,
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_time_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_time_info)),
 	.help          = time_help,
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index cd21560..f0d1635 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -138,7 +138,7 @@ static void tos_mt_save(const void *ip, const struct xt_entry_match *match)
 }
 
 static struct xtables_match tos_mt_reg_v0 = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "tos",
 	.family        = AF_INET,
 	.revision      = 0,
@@ -153,7 +153,7 @@ static struct xtables_match tos_mt_reg_v0 = {
 };
 
 static struct xtables_match tos_mt_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "tos",
 	.family        = AF_INET,
 	.revision      = 1,
@@ -168,7 +168,7 @@ static struct xtables_match tos_mt_reg = {
 };
 
 static struct xtables_match tos_mt6_reg = {
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.name          = "tos",
 	.family        = AF_INET6,
 	.revision      = 1,
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 2dff28f..c692e21 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -37,7 +37,7 @@ static void u32_help(void)
 		"\t\t""range := number | number \":\" number\n"
 		"\t\t""location := number | location operator number\n"
 		"\t\t""operator := \"&\" | \"<<\" | \">>\" | \"@\"\n",
-		IPTABLES_VERSION);
+		XTABLES_VERSION);
 	return;
 }
 
@@ -273,7 +273,7 @@ static void u32_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match u32_match = {
 	.name          = "u32",
 	.family        = AF_UNSPEC,
-	.version       = IPTABLES_VERSION,
+	.version       = XTABLES_VERSION,
 	.size          = XT_ALIGN(sizeof(struct xt_u32)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_u32)),
 	.help          = u32_help,
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 2ba781e..45af4ab 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -18,7 +18,7 @@ static void udp_help(void)
 " --destination-port [!] port[:port]\n"
 " --dport ...\n"
 "				match destination port(s)\n",
-IPTABLES_VERSION);
+XTABLES_VERSION);
 }
 
 static const struct option udp_opts[] = {
@@ -199,7 +199,7 @@ static void udp_save(const void *ip, const struct xt_entry_match *match)
 static struct xtables_match udp_match = {
 	.family		= AF_INET,
 	.name		= "udp",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
 	.help		= udp_help,
@@ -213,7 +213,7 @@ static struct xtables_match udp_match = {
 static struct xtables_match udp_match6 = {
 	.family		= AF_INET6,
 	.name		= "udp",
-	.version	= IPTABLES_VERSION,
+	.version	= XTABLES_VERSION,
 	.size		= XT_ALIGN(sizeof(struct xt_udp)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
 	.help		= udp_help,
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 2c3e95d..e28f649 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -128,7 +128,7 @@ int main(int argc, char *argv[])
 	int in_table = 0, testing = 0;
 
 	program_name = "ip6tables-restore";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 	line = 0;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
@@ -160,7 +160,7 @@ int main(int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage("ip6tables-restore",
-					    IPTABLES_VERSION);
+					    XTABLES_VERSION);
 				break;
 			case 'n':
 				noflush = 1;
diff --git a/ip6tables-save.c b/ip6tables-save.c
index e440887..3c72cfd 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -269,7 +269,7 @@ static int do_output(const char *tablename)
 		time_t now = time(NULL);
 
 		printf("# Generated by ip6tables-save v%s on %s",
-		       IPTABLES_VERSION, ctime(&now));
+		       XTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
 		/* Dump out chain names first,
@@ -330,7 +330,7 @@ int main(int argc, char *argv[])
 	int c;
 
 	program_name = "ip6tables-save";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
 	if (lib_dir == NULL) {
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index 1bb81bc..5bdcd4f 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -50,7 +50,7 @@ main(int argc, char *argv[])
 	ip6tc_handle_t handle = NULL;
 
 	program_name = "ip6tables";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
 	if (lib_dir == NULL) {
diff --git a/iptables-restore.c b/iptables-restore.c
index f556fa5..26f7e2f 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -129,7 +129,7 @@ main(int argc, char *argv[])
 	const char *tablename = 0;
 
 	program_name = "iptables-restore";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 	line = 0;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
@@ -161,7 +161,7 @@ main(int argc, char *argv[])
 				break;
 			case 'h':
 				print_usage("iptables-restore",
-					    IPTABLES_VERSION);
+					    XTABLES_VERSION);
 				break;
 			case 'n':
 				noflush = 1;
diff --git a/iptables-save.c b/iptables-save.c
index 1ce2090..4f31aee 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -292,7 +292,7 @@ static int do_output(const char *tablename)
 		time_t now = time(NULL);
 
 		printf("# Generated by iptables-save v%s on %s",
-		       IPTABLES_VERSION, ctime(&now));
+		       XTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
 		/* Dump out chain names first,
@@ -355,7 +355,7 @@ main(int argc, char *argv[])
 	int c;
 
 	program_name = "iptables-save";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
 	if (lib_dir == NULL) {
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 369adaf..55d9bbe 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -51,7 +51,7 @@ main(int argc, char *argv[])
 	iptc_handle_t handle = NULL;
 
 	program_name = "iptables";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 
 	lib_dir = getenv("XTABLES_LIBDIR");
 	if (lib_dir == NULL) {
diff --git a/iptables-xml.c b/iptables-xml.c
index d922efe..fea63ef 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -645,7 +645,7 @@ main(int argc, char *argv[])
 	FILE *in;
 
 	program_name = "iptables-xml";
-	program_version = IPTABLES_VERSION;
+	program_version = XTABLES_VERSION;
 	line = 0;
 
 	while ((c = getopt_long(argc, argv, "cvh", options, NULL)) != -1) {
@@ -658,7 +658,7 @@ main(int argc, char *argv[])
 			verbose = 1;
 			break;
 		case 'h':
-			print_usage("iptables-xml", IPTABLES_VERSION);
+			print_usage("iptables-xml", XTABLES_VERSION);
 			break;
 		}
 	}
diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index 942a874..d4245e7 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -1,6 +1,6 @@
 # -*- Makefile -*-
 
-AM_CFLAGS = ${regular_CFLAGS} -I${top_srcdir}/include
+AM_CFLAGS = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
 
 libipq_a_SOURCES = libipq.c
 lib_LIBRARIES    = libipq.a
diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index ca95748..b638dc9 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -26,6 +26,7 @@
  */
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <xtables.h>
 
 #include "linux_list.h"
 
@@ -1323,7 +1324,7 @@ TC_DUMP_ENTRIES(const TC_HANDLE_T handle)
 	CHECK(handle);
 
 	printf("libiptc v%s. %u bytes.\n",
-	       IPTABLES_VERSION, handle->entries->size);
+	       XTABLES_VERSION, handle->entries->size);
 	printf("Table `%s'\n", handle->info.name);
 	printf("Hooks: pre/in/fwd/out/post = %u/%u/%u/%u/%u\n",
 	       handle->info.hook_entry[HOOK_PRE_ROUTING],
