From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 3/6] [IPTABLES]: fix remaining warnings
Date: Tue, 29 Jan 2008 18:32:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291831400.14907@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801291828030.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46510 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbYA2Rc0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:32:26 -0500
In-Reply-To: <Pine.LNX.4.64.0801291828030.14907@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fix all remaining warnings (missing declarations, missing prototypes).

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 configure.ac                   |    5 -----
 extensions/GNUmakefile.in      |    2 ++
 extensions/libip6t_policy.c    |    5 -----
 extensions/libxt_CLASSIFY.c    |    1 +
 extensions/libxt_CONNMARK.c    |    1 +
 extensions/libxt_CONNSECMARK.c |    1 +
 extensions/libxt_DSCP.c        |    1 +
 extensions/libxt_MARK.c        |    1 +
 extensions/libxt_NFLOG.c       |    1 +
 extensions/libxt_NFQUEUE.c     |    1 +
 extensions/libxt_NOTRACK.c     |    1 +
 extensions/libxt_RATEEST.c     |    1 +
 extensions/libxt_SECMARK.c     |    1 +
 extensions/libxt_TCPMSS.c      |    1 +
 extensions/libxt_TCPOPTSTRIP.c |    1 +
 extensions/libxt_TOS.c         |    1 +
 extensions/libxt_TRACE.c       |    1 +
 extensions/libxt_comment.c     |    1 +
 extensions/libxt_connbytes.c   |    1 +
 extensions/libxt_connlimit.c   |    1 +
 extensions/libxt_connmark.c    |    1 +
 extensions/libxt_conntrack.c   |    1 +
 extensions/libxt_dccp.c        |    1 +
 extensions/libxt_dscp.c        |    1 +
 extensions/libxt_esp.c         |    4 ++--
 extensions/libxt_hashlimit.c   |    1 +
 extensions/libxt_helper.c      |    1 +
 extensions/libxt_iprange.c     |    1 +
 extensions/libxt_length.c      |    1 +
 extensions/libxt_limit.c       |    1 +
 extensions/libxt_mac.c         |    1 +
 extensions/libxt_mark.c        |    1 +
 extensions/libxt_multiport.c   |    4 ++--
 extensions/libxt_owner.c       |    1 +
 extensions/libxt_physdev.c     |    1 +
 extensions/libxt_pkttype.c     |    1 +
 extensions/libxt_quota.c       |    4 ++--
 extensions/libxt_rateest.c     |    1 +
 extensions/libxt_sctp.c        |    1 +
 extensions/libxt_standard.c    |    1 +
 extensions/libxt_state.c       |    1 +
 extensions/libxt_statistic.c   |    1 +
 extensions/libxt_string.c      |    1 +
 extensions/libxt_tcp.c         |    4 ++--
 extensions/libxt_tcpmss.c      |    1 +
 extensions/libxt_time.c        |    1 +
 extensions/libxt_tos.c         |    1 +
 extensions/libxt_u32.c         |    1 +
 extensions/libxt_udp.c         |    4 ++--
 include/iptables.h             |    2 --
 include/libiptc/libip6tc.h     |    2 ++
 include/libiptc/libiptc.h      |    2 ++
 include/xtables.h              |    3 +++
 ip6tables-multi.h              |    8 ++++++++
 ip6tables-restore.c            |    4 +++-
 ip6tables-save.c               |    1 +
 ip6tables-standalone.c         |    1 +
 ip6tables.c                    |    6 ++----
 iptables-multi.h               |    9 +++++++++
 iptables-restore.c             |    3 ++-
 iptables-save.c                |    1 +
 iptables-standalone.c          |    1 +
 iptables-xml.c                 |    1 +
 iptables.c                     |    4 +---
 libiptc/libiptc.c              |    9 ++++-----
 65 files changed, 94 insertions(+), 36 deletions(-)

Index: iptables/configure.ac
===================================================================
--- iptables.orig/configure.ac
+++ iptables/configure.ac
@@ -43,11 +43,6 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D
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
Index: iptables/extensions/GNUmakefile.in
===================================================================
--- iptables.orig/extensions/GNUmakefile.in
+++ iptables/extensions/GNUmakefile.in
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
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -126,11 +126,6 @@ mask_to_numeric(const struct in6_addr *a
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
Index: iptables/extensions/libxt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libxt_CLASSIFY.c
+++ iptables/extensions/libxt_CLASSIFY.c
@@ -130,6 +130,7 @@ static struct xtables_target classify_ta
 	.extra_opts	= CLASSIFY_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&classify_target);
Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c
+++ iptables/extensions/libxt_CONNMARK.c
@@ -470,6 +470,7 @@ static struct xtables_target connmark_tg
 	.extra_opts     = connmark_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&connmark_target);
Index: iptables/extensions/libxt_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNSECMARK.c
+++ iptables/extensions/libxt_CONNSECMARK.c
@@ -138,6 +138,7 @@ static struct xtables_target connsecmark
 	.extra_opts	= CONNSECMARK_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&connsecmark_target);
Index: iptables/extensions/libxt_DSCP.c
===================================================================
--- iptables.orig/extensions/libxt_DSCP.c
+++ iptables/extensions/libxt_DSCP.c
@@ -160,6 +160,7 @@ static struct xtables_target dscp_target
 	.extra_opts	= DSCP_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&dscp_target);
Index: iptables/extensions/libxt_MARK.c
===================================================================
--- iptables.orig/extensions/libxt_MARK.c
+++ iptables/extensions/libxt_MARK.c
@@ -359,6 +359,7 @@ static struct xtables_target mark_tg6_re
 	.extra_opts    = mark_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&mark_target_v0);
Index: iptables/extensions/libxt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libxt_NFLOG.c
+++ iptables/extensions/libxt_NFLOG.c
@@ -167,6 +167,7 @@ static struct xtables_target nflog_targe
 	.extra_opts	= NFLOG_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&nflog_target);
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -106,6 +106,7 @@ static struct xtables_target nfqueue_tar
 	.extra_opts	= NFQUEUE_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&nfqueue_target);
Index: iptables/extensions/libxt_NOTRACK.c
===================================================================
--- iptables.orig/extensions/libxt_NOTRACK.c
+++ iptables/extensions/libxt_NOTRACK.c
@@ -44,6 +44,7 @@ static struct xtables_target notrack_tar
 	.parse		= NOTRACK_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&notrack_target);
Index: iptables/extensions/libxt_RATEEST.c
===================================================================
--- iptables.orig/extensions/libxt_RATEEST.c
+++ iptables/extensions/libxt_RATEEST.c
@@ -233,6 +233,7 @@ static struct xtables_target rateest_tar
 	.extra_opts	= RATEEST_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&rateest_target4);
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -129,6 +129,7 @@ static struct xtables_target secmark_tar
 	.extra_opts	= SECMARK_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&secmark_target);
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -151,6 +151,7 @@ static struct xtables_target tcpmss_targ
 	.extra_opts	= TCPMSS_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tcpmss_target);
Index: iptables/extensions/libxt_TCPOPTSTRIP.c
===================================================================
--- iptables.orig/extensions/libxt_TCPOPTSTRIP.c
+++ iptables/extensions/libxt_TCPOPTSTRIP.c
@@ -205,6 +205,7 @@ static struct xtables_target tcpoptstrip
 	.extra_opts    = tcpoptstrip_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tcpoptstrip_tg_reg);
Index: iptables/extensions/libxt_TOS.c
===================================================================
--- iptables.orig/extensions/libxt_TOS.c
+++ iptables/extensions/libxt_TOS.c
@@ -249,6 +249,7 @@ static struct xtables_target tos_tg6_reg
 	.extra_opts    = tos_tg_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&tos_tg_reg_v0);
Index: iptables/extensions/libxt_TRACE.c
===================================================================
--- iptables.orig/extensions/libxt_TRACE.c
+++ iptables/extensions/libxt_TRACE.c
@@ -43,6 +43,7 @@ static struct xtables_target trace_targe
 	.parse		= TRACE_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&trace_target);
Index: iptables/extensions/libxt_comment.c
===================================================================
--- iptables.orig/extensions/libxt_comment.c
+++ iptables/extensions/libxt_comment.c
@@ -121,6 +121,7 @@ static struct xtables_match comment_matc
 	.extra_opts	= comment_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&comment_match);
Index: iptables/extensions/libxt_connbytes.c
===================================================================
--- iptables.orig/extensions/libxt_connbytes.c
+++ iptables/extensions/libxt_connbytes.c
@@ -213,6 +213,7 @@ static struct xtables_match connbytes_ma
 	.extra_opts	= connbytes_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connbytes_match);
Index: iptables/extensions/libxt_connlimit.c
===================================================================
--- iptables.orig/extensions/libxt_connlimit.c
+++ iptables/extensions/libxt_connlimit.c
@@ -208,6 +208,7 @@ static struct xtables_match connlimit_ma
 	.extra_opts    = connlimit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connlimit_match);
Index: iptables/extensions/libxt_connmark.c
===================================================================
--- iptables.orig/extensions/libxt_connmark.c
+++ iptables/extensions/libxt_connmark.c
@@ -228,6 +228,7 @@ static struct xtables_match connmark_mt6
 	.extra_opts     = connmark_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&connmark_mt_reg_v0);
Index: iptables/extensions/libxt_conntrack.c
===================================================================
--- iptables.orig/extensions/libxt_conntrack.c
+++ iptables/extensions/libxt_conntrack.c
@@ -1059,6 +1059,7 @@ static struct xtables_match conntrack_mt
 	.extra_opts    = conntrack_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&conntrack_match);
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -367,6 +367,7 @@ static struct xtables_match dccp_match6 
 	.extra_opts	= dccp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&dccp_match);
Index: iptables/extensions/libxt_dscp.c
===================================================================
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -174,6 +174,7 @@ static struct xtables_match dscp_match6 
 	.extra_opts	= dscp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&dscp_match);
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -181,8 +181,8 @@ static struct xtables_match esp_match6 =
 	.extra_opts	= esp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&esp_match);
 	xtables_register_match(&esp_match6);
Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -390,6 +390,7 @@ static struct xtables_match hashlimit_ma
 	.extra_opts	= hashlimit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&hashlimit_match);
Index: iptables/extensions/libxt_helper.c
===================================================================
--- iptables.orig/extensions/libxt_helper.c
+++ iptables/extensions/libxt_helper.c
@@ -102,6 +102,7 @@ static struct xtables_match helper_match
 	.extra_opts	= helper_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&helper_match);
Index: iptables/extensions/libxt_iprange.c
===================================================================
--- iptables.orig/extensions/libxt_iprange.c
+++ iptables/extensions/libxt_iprange.c
@@ -383,6 +383,7 @@ static struct xtables_match iprange_mt6_
 	.extra_opts     = iprange_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&iprange_match);
Index: iptables/extensions/libxt_length.c
===================================================================
--- iptables.orig/extensions/libxt_length.c
+++ iptables/extensions/libxt_length.c
@@ -152,6 +152,7 @@ static struct xtables_match length_match
 	.extra_opts	= length_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&length_match);
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -192,6 +192,7 @@ static struct xtables_match limit_match6
 	.extra_opts	= limit_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&limit_match);
Index: iptables/extensions/libxt_mac.c
===================================================================
--- iptables.orig/extensions/libxt_mac.c
+++ iptables/extensions/libxt_mac.c
@@ -143,6 +143,7 @@ static struct xtables_match mac_match6 =
 	.extra_opts	= mac_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&mac_match);
Index: iptables/extensions/libxt_mark.c
===================================================================
--- iptables.orig/extensions/libxt_mark.c
+++ iptables/extensions/libxt_mark.c
@@ -208,6 +208,7 @@ static struct xtables_match mark_mt6_reg
 	.extra_opts     = mark_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&mark_match);
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -569,8 +569,8 @@ static struct xtables_match multiport_ma
 	.extra_opts	= multiport_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&multiport_match);
 	xtables_register_match(&multiport_match6);
Index: iptables/extensions/libxt_owner.c
===================================================================
--- iptables.orig/extensions/libxt_owner.c
+++ iptables/extensions/libxt_owner.c
@@ -591,6 +591,7 @@ static struct xtables_match owner_mt6_re
 	.extra_opts    = owner_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&owner_mt_reg_v0);
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -190,6 +190,7 @@ static struct xtables_match physdev_matc
 	.extra_opts	= physdev_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&physdev_match);
Index: iptables/extensions/libxt_pkttype.c
===================================================================
--- iptables.orig/extensions/libxt_pkttype.c
+++ iptables/extensions/libxt_pkttype.c
@@ -174,6 +174,7 @@ static struct xtables_match pkttype_matc
 	.extra_opts	= pkttype_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&pkttype_match);
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
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
Index: iptables/extensions/libxt_rateest.c
===================================================================
--- iptables.orig/extensions/libxt_rateest.c
+++ iptables/extensions/libxt_rateest.c
@@ -454,6 +454,7 @@ static struct xtables_match rateest_matc
 	.extra_opts	= rateest_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&rateest_match4);
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -539,6 +539,7 @@ static struct xtables_match sctp_match6 
 	.extra_opts	= sctp_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&sctp_match);
Index: iptables/extensions/libxt_standard.c
===================================================================
--- iptables.orig/extensions/libxt_standard.c
+++ iptables/extensions/libxt_standard.c
@@ -43,6 +43,7 @@ static struct xtables_target standard_ta
 	.parse		= standard_parse,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_target(&standard_target);
Index: iptables/extensions/libxt_state.c
===================================================================
--- iptables.orig/extensions/libxt_state.c
+++ iptables/extensions/libxt_state.c
@@ -170,6 +170,7 @@ static struct xtables_match state_match6
 	.extra_opts	= state_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&state_match);
Index: iptables/extensions/libxt_statistic.c
===================================================================
--- iptables.orig/extensions/libxt_statistic.c
+++ iptables/extensions/libxt_statistic.c
@@ -193,6 +193,7 @@ static struct xtables_match statistic_ma
 	.extra_opts	= statistic_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&statistic_match);
Index: iptables/extensions/libxt_string.c
===================================================================
--- iptables.orig/extensions/libxt_string.c
+++ iptables/extensions/libxt_string.c
@@ -356,6 +356,7 @@ static struct xtables_match string_match
     .extra_opts		= string_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&string_match);
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -411,8 +411,8 @@ static struct xtables_match tcp_match6 =
 	.extra_opts	= tcp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&tcp_match);
 	xtables_register_match(&tcp_match6);
Index: iptables/extensions/libxt_tcpmss.c
===================================================================
--- iptables.orig/extensions/libxt_tcpmss.c
+++ iptables/extensions/libxt_tcpmss.c
@@ -153,6 +153,7 @@ static struct xtables_match tcpmss_match
 	.extra_opts	= tcpmss_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&tcpmss_match);
Index: iptables/extensions/libxt_time.c
===================================================================
--- iptables.orig/extensions/libxt_time.c
+++ iptables/extensions/libxt_time.c
@@ -492,6 +492,7 @@ static struct xtables_match time_match6 
 	.extra_opts    = time_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&time_match);
Index: iptables/extensions/libxt_tos.c
===================================================================
--- iptables.orig/extensions/libxt_tos.c
+++ iptables/extensions/libxt_tos.c
@@ -182,6 +182,7 @@ static struct xtables_match tos_mt6_reg 
 	.extra_opts    = tos_mt_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&tos_mt_reg_v0);
Index: iptables/extensions/libxt_u32.c
===================================================================
--- iptables.orig/extensions/libxt_u32.c
+++ iptables/extensions/libxt_u32.c
@@ -296,6 +296,7 @@ static struct xtables_match u32_match6 =
 	.extra_opts    = u32_opts,
 };
 
+void _init(void);
 void _init(void)
 {
 	xtables_register_match(&u32_match);
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -224,8 +224,8 @@ static struct xtables_match udp_match6 =
 	.extra_opts	= udp_opts,
 };
 
-void
-_init(void)
+void _init(void);
+void _init(void)
 {
 	xtables_register_match(&udp_match);
 	xtables_register_match(&udp_match6);
Index: iptables/include/iptables.h
===================================================================
--- iptables.orig/include/iptables.h
+++ iptables/include/iptables.h
@@ -24,8 +24,6 @@ extern int line;
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
-extern u_int16_t parse_protocol(const char *s);
-
 extern int do_command(int argc, char *argv[], char **table,
 		      iptc_handle_t *handle);
 extern int delete_chain(const ipt_chainlabel chain, int verbose,
Index: iptables/include/libiptc/libip6tc.h
===================================================================
--- iptables.orig/include/libiptc/libip6tc.h
+++ iptables/include/libiptc/libip6tc.h
@@ -152,4 +152,6 @@ const char *ip6tc_strerror(int err);
 /* Return prefix length, or -1 if not contiguous */
 int ipv6_prefix_length(const struct in6_addr *a);
 
+extern void dump_entries6(const ip6tc_handle_t);
+
 #endif /* _LIBIP6TC_H */
Index: iptables/include/libiptc/libiptc.h
===================================================================
--- iptables.orig/include/libiptc/libiptc.h
+++ iptables/include/libiptc/libiptc.h
@@ -159,6 +159,8 @@ int iptc_get_raw_socket(void);
 /* Translates errno numbers into more human-readable form than strerror. */
 const char *iptc_strerror(int err);
 
+extern void dump_entries(const iptc_handle_t);
+
 #ifdef __cplusplus
 }
 #endif
Index: iptables/include/xtables.h
===================================================================
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -267,4 +267,7 @@ extern void save_string(const char *valu
 #	define _init __attribute__((constructor)) _INIT
 #endif
 
+/* Present in both iptables.c and ip6tables.c */
+extern u_int16_t parse_protocol(const char *s);
+
 #endif /* _XTABLES_H */
Index: iptables/ip6tables-multi.h
===================================================================
--- /dev/null
+++ iptables/ip6tables-multi.h
@@ -0,0 +1,8 @@
+#ifndef _IP6TABLES_MULTI_H
+#define _IP6TABLES_MULTI_H 1
+
+extern int ip6tables_main(int, char **);
+extern int ip6tables_save_main(int, char **);
+extern int ip6tables_restore_main(int, char **);
+
+#endif /* _IP6TABLES_MULTI_H */
Index: iptables/ip6tables-restore.c
===================================================================
--- iptables.orig/ip6tables-restore.c
+++ iptables/ip6tables-restore.c
@@ -18,6 +18,7 @@
 #include "ip6tables.h"
 #include "xtables.h"
 #include "libiptc/libip6tc.h"
+#include "ip6tables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -55,7 +56,8 @@ static void print_usage(const char *name
 	exit(1);
 }
 
-ip6tc_handle_t create_handle(const char *tablename, const char* modprobe)
+static ip6tc_handle_t create_handle(const char *tablename,
+                                    const char *modprobe)
 {
 	ip6tc_handle_t handle;
 
Index: iptables/ip6tables-save.c
===================================================================
--- iptables.orig/ip6tables-save.c
+++ iptables/ip6tables-save.c
@@ -16,6 +16,7 @@
 #include <arpa/inet.h>
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
+#include "ip6tables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
Index: iptables/ip6tables-standalone.c
===================================================================
--- iptables.orig/ip6tables-standalone.c
+++ iptables/ip6tables-standalone.c
@@ -35,6 +35,7 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <ip6tables.h>
+#include "ip6tables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -41,6 +41,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include "ip6tables-multi.h"
 
 #ifndef TRUE
 #define TRUE 1
@@ -186,9 +187,6 @@ static int inverse_for_options[NUMBER_OF
 const char *program_version;
 const char *program_name;
 
-/* Extra debugging from libiptc */
-extern void dump_entries6(const ip6tc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1140,7 +1138,7 @@ generate_entry(const struct ip6t_entry *
 	return e;
 }
 
-void clear_rule_matches(struct ip6tables_rule_match **matches)
+static void clear_rule_matches(struct ip6tables_rule_match **matches)
 {
 	struct ip6tables_rule_match *matchp, *tmp;
 
Index: iptables/iptables-multi.h
===================================================================
--- /dev/null
+++ iptables/iptables-multi.h
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
Index: iptables/iptables-restore.c
===================================================================
--- iptables.orig/iptables-restore.c
+++ iptables/iptables-restore.c
@@ -15,6 +15,7 @@
 #include "iptables.h"
 #include "xtables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
@@ -54,7 +55,7 @@ static void print_usage(const char *name
 	exit(1);
 }
 
-iptc_handle_t create_handle(const char *tablename, const char* modprobe )
+static iptc_handle_t create_handle(const char *tablename, const char *modprobe)
 {
 	iptc_handle_t handle;
 
Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -15,6 +15,7 @@
 #include <netdb.h>
 #include "libiptc/libiptc.h"
 #include "iptables.h"
+#include "iptables-multi.h"
 
 #ifndef NO_SHARED_LIBS
 #include <dlfcn.h>
Index: iptables/iptables-standalone.c
===================================================================
--- iptables.orig/iptables-standalone.c
+++ iptables/iptables-standalone.c
@@ -36,6 +36,7 @@
 #include <errno.h>
 #include <string.h>
 #include <iptables.h>
+#include "iptables-multi.h"
 
 #ifdef IPTABLES_MULTI
 int
Index: iptables/iptables-xml.c
===================================================================
--- iptables.orig/iptables-xml.c
+++ iptables/iptables-xml.c
@@ -16,6 +16,7 @@
 #include <stdarg.h>
 #include "iptables.h"
 #include "libiptc/libiptc.h"
+#include "iptables-multi.h"
 
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -190,8 +190,6 @@ const char *program_name;
 
 int kernel_version;
 
-extern void dump_entries(const iptc_handle_t handle);
-
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -1143,7 +1141,7 @@ generate_entry(const struct ipt_entry *f
 	return e;
 }
 
-void clear_rule_matches(struct iptables_rule_match **matches)
+static void clear_rule_matches(struct iptables_rule_match **matches)
 {
 	struct iptables_rule_match *matchp, *tmp;
 
Index: iptables/libiptc/libiptc.c
===================================================================
--- iptables.orig/libiptc/libiptc.c
+++ iptables/libiptc/libiptc.c
@@ -1471,7 +1471,7 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, T
 }
 
 /* How many rules in this chain? */
-unsigned int
+static unsigned int
 TC_NUM_RULES(const char *chain, TC_HANDLE_T *handle)
 {
 	struct chain_head *c;
@@ -1487,9 +1487,8 @@ TC_NUM_RULES(const char *chain, TC_HANDL
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
@@ -1511,7 +1510,7 @@ const STRUCT_ENTRY *TC_GET_RULE(const ch
 }
 
 /* Returns a pointer to the target name of this position. */
-const char *standard_target_map(int verdict)
+static const char *standard_target_map(int verdict)
 {
 	switch (verdict) {
 		case RETURN:
