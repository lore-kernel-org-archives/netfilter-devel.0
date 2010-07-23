From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] all: consistent syntax use in struct option
Date: Fri, 23 Jul 2010 21:36:22 +0200
Message-ID: <1279913784-12272-5-git-send-email-jengelh@medozas.de>
References: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56107 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755105Ab0GWTgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jul 2010 15:36:35 -0400
In-Reply-To: <1279913784-12272-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Try to inhibit copypasting old stuff.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c         |    9 +++++----
 extensions/libip6t_LOG.c        |   17 +++++++++--------
 extensions/libip6t_REJECT.c     |    5 +++--
 extensions/libip6t_ah.c         |    9 +++++----
 extensions/libip6t_dst.c        |    9 +++++----
 extensions/libip6t_frag.c       |   15 ++++++++-------
 extensions/libip6t_hbh.c        |    8 ++++----
 extensions/libip6t_hl.c         |   12 ++++++------
 extensions/libip6t_icmp6.c      |    5 +++--
 extensions/libip6t_ipv6header.c |    7 ++++---
 extensions/libip6t_mh.c         |    5 +++--
 extensions/libip6t_rt.c         |   15 ++++++++-------
 extensions/libipt_CLUSTERIP.c   |   15 ++++++++-------
 extensions/libipt_DNAT.c        |    9 +++++----
 extensions/libipt_ECN.c         |   11 ++++++-----
 extensions/libipt_LOG.c         |   17 +++++++++--------
 extensions/libipt_MASQUERADE.c  |    7 ++++---
 extensions/libipt_NETMAP.c      |    6 +++---
 extensions/libipt_REDIRECT.c    |    7 ++++---
 extensions/libipt_REJECT.c      |    5 +++--
 extensions/libipt_SAME.c        |    9 +++++----
 extensions/libipt_SNAT.c        |    9 +++++----
 extensions/libipt_TTL.c         |    9 +++++----
 extensions/libipt_ULOG.c        |   11 ++++++-----
 extensions/libipt_addrtype.c    |   24 ++++++++++++------------
 extensions/libipt_ah.c          |    5 +++--
 extensions/libipt_ecn.c         |    9 +++++----
 extensions/libipt_icmp.c        |    5 +++--
 extensions/libipt_realm.c       |    5 +++--
 extensions/libipt_ttl.c         |   12 ++++++------
 extensions/libxt_CHECKSUM.c     |    5 +++--
 extensions/libxt_CLASSIFY.c     |    5 +++--
 extensions/libxt_CONNMARK.c     |   13 +++++++------
 extensions/libxt_CONNSECMARK.c  |    7 ++++---
 extensions/libxt_CT.c           |   13 +++++++------
 extensions/libxt_DSCP.c         |    7 ++++---
 extensions/libxt_IDLETIMER.c    |    8 ++++----
 extensions/libxt_LED.c          |    4 ++--
 extensions/libxt_MARK.c         |   10 +++++-----
 extensions/libxt_NFLOG.c        |   11 ++++++-----
 extensions/libxt_NFQUEUE.c      |    7 ++++---
 extensions/libxt_RATEEST.c      |    9 +++++----
 extensions/libxt_SECMARK.c      |    5 +++--
 extensions/libxt_SET.c          |    7 ++++---
 extensions/libxt_TCPMSS.c       |    7 ++++---
 extensions/libxt_TCPOPTSTRIP.c  |    4 ++--
 extensions/libxt_TOS.c          |    5 +++--
 extensions/libxt_TPROXY.c       |    8 ++++----
 extensions/libxt_cluster.c      |   11 ++++++-----
 extensions/libxt_comment.c      |    5 +++--
 extensions/libxt_connbytes.c    |    9 +++++----
 extensions/libxt_connlimit.c    |    7 ++++---
 extensions/libxt_connmark.c     |    3 ++-
 extensions/libxt_conntrack.c    |    2 +-
 extensions/libxt_cpu.c          |    5 +++--
 extensions/libxt_dccp.c         |   15 ++++++++-------
 extensions/libxt_dscp.c         |    7 ++++---
 extensions/libxt_esp.c          |    5 +++--
 extensions/libxt_hashlimit.c    |   20 ++++++++++----------
 extensions/libxt_helper.c       |    5 +++--
 extensions/libxt_iprange.c      |    3 ++-
 extensions/libxt_ipvs.c         |    3 ++-
 extensions/libxt_length.c       |    5 +++--
 extensions/libxt_limit.c        |    8 ++++----
 extensions/libxt_mac.c          |    5 +++--
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |   13 +++++++------
 extensions/libxt_osf.c          |   10 +++++-----
 extensions/libxt_owner.c        |    6 +++---
 extensions/libxt_physdev.c      |   13 +++++++------
 extensions/libxt_pkttype.c      |    5 +++--
 extensions/libxt_policy.c       |   21 ++++++++++++---------
 extensions/libxt_quota.c        |    5 +++--
 extensions/libxt_rateest.c      |   31 ++++++++++++++++---------------
 extensions/libxt_recent.c       |   23 ++++++++++++-----------
 extensions/libxt_sctp.c         |   13 +++++++------
 extensions/libxt_set.c          |    7 ++++---
 extensions/libxt_state.c        |    5 +++--
 extensions/libxt_statistic.c    |   11 ++++++-----
 extensions/libxt_string.c       |   15 ++++++++-------
 extensions/libxt_tcp.c          |   17 +++++++++--------
 extensions/libxt_tcpmss.c       |    5 +++--
 extensions/libxt_time.c         |   18 +++++++++---------
 extensions/libxt_tos.c          |    2 +-
 extensions/libxt_u32.c          |    5 +++--
 extensions/libxt_udp.c          |   11 ++++++-----
 extensions/tos_values.c         |    2 +-
 include/xtables.h.in            |    2 ++
 88 files changed, 429 insertions(+), 357 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index bff0611..eeab0c9 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -6,6 +6,7 @@
  */
=20
 #include <getopt.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -131,10 +132,10 @@ static void HL_print(const void *ip, const struct=
 xt_entry_target *target,
 }
=20
 static const struct option HL_opts[] =3D {
-	{ "hl-set", 1, NULL, '1' },
-	{ "hl-dec", 1, NULL, '2' },
-	{ "hl-inc", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "hl-set", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "hl-dec", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "hl-inc", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_target hl_tg6_reg =3D {
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index ff9edc6..727ce6a 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add LOG support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -30,14 +31,14 @@ static void LOG_help(void)
 }
=20
 static const struct option LOG_opts[] =3D {
-	{ .name =3D "log-level",        .has_arg =3D 1, .val =3D '!' },
-	{ .name =3D "log-prefix",       .has_arg =3D 1, .val =3D '#' },
-	{ .name =3D "log-tcp-sequence", .has_arg =3D 0, .val =3D '1' },
-	{ .name =3D "log-tcp-options",  .has_arg =3D 0, .val =3D '2' },
-	{ .name =3D "log-ip-options",   .has_arg =3D 0, .val =3D '3' },
-	{ .name =3D "log-uid",          .has_arg =3D 0, .val =3D '4' },
-	{ .name =3D "log-macdecode",    .has_arg =3D 0, .val =3D '5' },
-	{ .name =3D NULL }
+	{.name =3D "log-level",        .has_arg =3D true,  .val =3D '!'},
+	{.name =3D "log-prefix",       .has_arg =3D true,  .val =3D '#'},
+	{.name =3D "log-tcp-sequence", .has_arg =3D false, .val =3D '1'},
+	{.name =3D "log-tcp-options",  .has_arg =3D false, .val =3D '2'},
+	{.name =3D "log-ip-options",   .has_arg =3D false, .val =3D '3'},
+	{.name =3D "log-uid",          .has_arg =3D false, .val =3D '4'},
+	{.name =3D "log-macdecode",    .has_arg =3D false, .val =3D '5'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void LOG_init(struct xt_entry_target *t)
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index b8195d7..94d2694 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -5,6 +5,7 @@
  * ported to IPv6 by Harald Welte <laforge@gnumonks.org>
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -61,8 +62,8 @@ static void REJECT_help(void)
 }
=20
 static const struct option REJECT_opts[] =3D {
-	{ "reject-with", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "reject-with", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void REJECT_init(struct xt_entry_target *t)
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 285704c..41c5385 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add AH support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -18,10 +19,10 @@ static void ah_help(void)
 }
=20
 static const struct option ah_opts[] =3D {
-	{ .name =3D "ahspi", .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "ahlen", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "ahres", .has_arg =3D 0, .val =3D '3' },
-	{ .name =3D NULL }
+	{.name =3D "ahspi", .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "ahlen", .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "ahres", .has_arg =3D false, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 72df6ad..9e4875e 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Dst header support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -22,10 +23,10 @@ IP6T_OPTS_OPTSNR);
 }
=20
 static const struct option dst_opts[] =3D {
-	{ .name =3D "dst-len",        .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "dst-opts",       .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "dst-not-strict", .has_arg =3D 1, .val =3D '3' },
-	{ .name =3D NULL }
+	{.name =3D "dst-len",        .has_arg =3D true, .val =3D '1'},
+	{.name =3D "dst-opts",       .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dst-not-strict", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 5a280cc..dd23cda 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Fragmentation header supp=
ort. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -21,13 +22,13 @@ static void frag_help(void)
 }
=20
 static const struct option frag_opts[] =3D {
-	{ .name =3D "fragid",    .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "fraglen",   .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "fragres",   .has_arg =3D 0, .val =3D '3' },
-	{ .name =3D "fragfirst", .has_arg =3D 0, .val =3D '4' },
-	{ .name =3D "fragmore",  .has_arg =3D 0, .val =3D '5' },
-	{ .name =3D "fraglast",  .has_arg =3D 0, .val =3D '6' },
-	{ .name =3D NULL }
+	{.name =3D "fragid",    .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "fraglen",   .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "fragres",   .has_arg =3D false, .val =3D '3'},
+	{.name =3D "fragfirst", .has_arg =3D false, .val =3D '4'},
+	{.name =3D "fragmore",  .has_arg =3D false, .val =3D '5'},
+	{.name =3D "fraglast",  .has_arg =3D false, .val =3D '6'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 520ec9e..cddd615 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -25,10 +25,10 @@ IP6T_OPTS_OPTSNR);
 }
=20
 static const struct option hbh_opts[] =3D {
-	{ "hbh-len", 1, NULL, '1' },
-	{ "hbh-opts", 1, NULL, '2' },
-	{ "hbh-not-strict", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "hbh-len",        .has_arg =3D true, .val =3D '1'},
+	{.name =3D "hbh-opts",       .has_arg =3D true, .val =3D '2'},
+	{.name =3D "hbh-not-strict", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 09589b1..6e58250 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -5,7 +5,7 @@
  * This program is released under the terms of GNU GPL
  * Cleanups by Stephane Ouellette <ouellettes@videotron.ca>
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -116,11 +116,11 @@ static void hl_save(const void *ip, const struct =
xt_entry_match *match)
 }
=20
 static const struct option hl_opts[] =3D {
-	{ .name =3D "hl",    .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "hl-eq", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "hl-lt", .has_arg =3D 1, .val =3D '3' },
-	{ .name =3D "hl-gt", .has_arg =3D 1, .val =3D '4' },
-	{ .name =3D NULL }
+	{.name =3D "hl",    .has_arg =3D true, .val =3D '2'},
+	{.name =3D "hl-eq", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "hl-lt", .has_arg =3D true, .val =3D '3'},
+	{.name =3D "hl-gt", .has_arg =3D true, .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_match hl_mt6_reg =3D {
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index fb321b3..b8a6ec9 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add ICMP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -84,8 +85,8 @@ static void icmp6_help(void)
 }
=20
 static const struct option icmp6_opts[] =3D {
-	{ "icmpv6-type", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "icmpv6-type", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6h=
eader.c
index af1f5ef..d6ce248 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -6,6 +6,7 @@ on whether they contain certain headers */
=20
 #include <getopt.h>
 #include <xtables.h>
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -140,9 +141,9 @@ static void ipv6header_help(void)
 }
=20
 static const struct option ipv6header_opts[] =3D {
-	{ "header", 1, NULL, '1' },
-	{ "soft", 0, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "header", .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "soft",   .has_arg =3D false, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void ipv6header_init(struct xt_entry_match *m)
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 95cd65d..54dd8c6 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -11,6 +11,7 @@
  *
  * Based on libip6t_{icmpv6,udp}.c
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -216,8 +217,8 @@ static void mh_save(const void *ip, const struct xt=
_entry_match *match)
 }
=20
 static const struct option mh_opts[] =3D {
-	{ "mh-type", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "mh-type", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_match mh_mt6_reg =3D {
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index a04023d..f1a50eb 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to ip6tables to add Routing header support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -28,13 +29,13 @@ IP6T_RT_HOPS);
 }
=20
 static const struct option rt_opts[] =3D {
-	{ "rt-type", 1, NULL, '1' },
-	{ "rt-segsleft", 1, NULL, '2' },
-	{ "rt-len", 1, NULL, '3' },
-	{ "rt-0-res", 0, NULL, '4' },
-	{ "rt-0-addrs", 1, NULL, '5' },
-	{ "rt-0-not-strict", 0, NULL, '6' },
-	{ .name =3D NULL }
+	{.name =3D "rt-type",         .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "rt-segsleft",     .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "rt-len",          .has_arg =3D true,  .val =3D '3'},
+	{.name =3D "rt-0-res",        .has_arg =3D false, .val =3D '4'},
+	{.name =3D "rt-0-addrs",      .has_arg =3D true,  .val =3D '5'},
+	{.name =3D "rt-0-not-strict", .has_arg =3D false, .val =3D '6'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERI=
P.c
index 279aacf..492eefc 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -3,6 +3,7 @@
  *
  * Development of this code was funded by SuSE AG, http://www.suse.com=
/
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -41,13 +42,13 @@ static void CLUSTERIP_help(void)
 #define PARAM_HASHINIT	0x0020
=20
 static const struct option CLUSTERIP_opts[] =3D {
-	{ "new", 0, NULL, '1' },
-	{ "hashmode", 1, NULL, '2' },
-	{ "clustermac", 1, NULL, '3' },
-	{ "total-nodes", 1, NULL, '4' },
-	{ "local-node", 1, NULL, '5' },
-	{ "hash-init", 1, NULL, '6' },
-	{ .name =3D NULL }
+	{.name =3D "new",         .has_arg =3D false, .val =3D '1'},
+	{.name =3D "hashmode",    .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "clustermac",  .has_arg =3D true,  .val =3D '3'},
+	{.name =3D "total-nodes", .has_arg =3D true,  .val =3D '4'},
+	{.name =3D "local-node",  .has_arg =3D true,  .val =3D '5'},
+	{.name =3D "hash-init",   .has_arg =3D true,  .val =3D '6'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 57c5888..7afe241 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add destination-NAT support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -31,10 +32,10 @@ static void DNAT_help(void)
 }
=20
 static const struct option DNAT_opts[] =3D {
-	{ "to-destination", 1, NULL, '1' },
-	{ "random", 0, NULL, '2' },
-	{ "persistent", 0, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "to-destination", .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "random",         .has_arg =3D false, .val =3D '2'},
+	{.name =3D "persistent",     .has_arg =3D false, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct ipt_natinfo *
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index bf1f8a5..75ea011 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -8,6 +8,7 @@
  *
  * $Id$
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -32,11 +33,11 @@ static void ECN_help(void)
=20
=20
 static const struct option ECN_opts[] =3D {
-	{ "ecn-tcp-remove", 0, NULL, 'F' },
-	{ "ecn-tcp-cwr", 1, NULL, 'G' },
-	{ "ecn-tcp-ece", 1, NULL, 'H' },
-	{ "ecn-ip-ect", 1, NULL, '9' },
-	{ .name =3D NULL }
+	{.name =3D "ecn-tcp-remove", .has_arg =3D false, .val =3D 'F'},
+	{.name =3D "ecn-tcp-cwr",    .has_arg =3D true,  .val =3D 'G'},
+	{.name =3D "ecn-tcp-ece",    .has_arg =3D true,  .val =3D 'H'},
+	{.name =3D "ecn-ip-ect",     .has_arg =3D true,  .val =3D '9'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int ECN_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 73c8f32..0c41271 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add LOG support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -30,14 +31,14 @@ static void LOG_help(void)
 }
=20
 static const struct option LOG_opts[] =3D {
-	{ .name =3D "log-level",        .has_arg =3D 1, .val =3D '!' },
-	{ .name =3D "log-prefix",       .has_arg =3D 1, .val =3D '#' },
-	{ .name =3D "log-tcp-sequence", .has_arg =3D 0, .val =3D '1' },
-	{ .name =3D "log-tcp-options",  .has_arg =3D 0, .val =3D '2' },
-	{ .name =3D "log-ip-options",   .has_arg =3D 0, .val =3D '3' },
-	{ .name =3D "log-uid",          .has_arg =3D 0, .val =3D '4' },
-	{ .name =3D "log-macdecode",    .has_arg =3D 0, .val =3D '5' },
-	{ .name =3D NULL }
+	{.name =3D "log-level",        .has_arg =3D true,  .val =3D '!'},
+	{.name =3D "log-prefix",       .has_arg =3D true,  .val =3D '#'},
+	{.name =3D "log-tcp-sequence", .has_arg =3D false, .val =3D '1'},
+	{.name =3D "log-tcp-options",  .has_arg =3D false, .val =3D '2'},
+	{.name =3D "log-ip-options",   .has_arg =3D false, .val =3D '3'},
+	{.name =3D "log-uid",          .has_arg =3D false, .val =3D '4'},
+	{.name =3D "log-macdecode",    .has_arg =3D false, .val =3D '5'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void LOG_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUER=
ADE.c
index 3386ff3..b6bbd60 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add masquerade support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -20,9 +21,9 @@ static void MASQUERADE_help(void)
 }
=20
 static const struct option MASQUERADE_opts[] =3D {
-	{ "to-ports", 1, NULL, '1' },
-	{ "random", 0, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "to-ports", .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "random",   .has_arg =3D false, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void MASQUERADE_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index b05022b..09262ba 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -1,7 +1,7 @@
 /* Shared library add-on to iptables to add static NAT support.
    Author: Svenning Soerensen <svenning@post5.tele.dk>
 */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -13,8 +13,8 @@
 #define MODULENAME "NETMAP"
=20
 static const struct option NETMAP_opts[] =3D {
-	{ "to", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "to", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void NETMAP_help(void)
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.=
c
index 324d0eb..940603a 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add redirect support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -22,9 +23,9 @@ static void REDIRECT_help(void)
 }
=20
 static const struct option REDIRECT_opts[] =3D {
-	{ "to-ports", 1, NULL, '1' },
-	{ "random", 0, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "to-ports", .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "random",   .has_arg =3D false, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void REDIRECT_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index 85d9e53..8c08dd0 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -2,6 +2,7 @@
  *
  * (C) 2000 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -76,8 +77,8 @@ static void REJECT_help(void)
 }
=20
 static const struct option REJECT_opts[] =3D {
-	{ "reject-with", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "reject-with", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void REJECT_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index ed02ef9..5fb1b5b 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add simple non load-balancing =
SNAT support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -25,10 +26,10 @@ static void SAME_help(void)
 }
=20
 static const struct option SAME_opts[] =3D {
-	{ "to", 1, NULL, '1' },
-	{ "nodst", 0, NULL, '2'},
-	{ "random", 0, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "to",     .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "nodst",  .has_arg =3D false, .val =3D '2'},
+	{.name =3D "random", .has_arg =3D false, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void SAME_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index f7c93d8..1075c79 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add source-NAT support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -31,10 +32,10 @@ static void SNAT_help(void)
 }
=20
 static const struct option SNAT_opts[] =3D {
-	{ "to-source", 1, NULL, '1' },
-	{ "random", 0, NULL, '2' },
-	{ "persistent", 0, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "to-source",  .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "random",     .has_arg =3D false, .val =3D '2'},
+	{.name =3D "persistent", .has_arg =3D false, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct ipt_natinfo *
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 4db9bbe..2e0c233 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -5,6 +5,7 @@
  *
  * This program is distributed under the terms of GNU GPL
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -131,10 +132,10 @@ static void TTL_print(const void *ip, const struc=
t xt_entry_target *target,
 }
=20
 static const struct option TTL_opts[] =3D {
-	{ "ttl-set", 1, NULL, '1' },
-	{ "ttl-dec", 1, NULL, '2' },
-	{ "ttl-inc", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "ttl-set", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "ttl-dec", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "ttl-inc", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_target ttl_tg_reg =3D {
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 4d009b7..46928c3 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -9,6 +9,7 @@
  *=20
  * libipt_ULOG.c,v 1.7 2001/01/30 11:55:02 laforge Exp
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -42,11 +43,11 @@ static void ULOG_help(void)
 }
=20
 static const struct option ULOG_opts[] =3D {
-	{"ulog-nlgroup", 1, NULL, '!'},
-	{"ulog-prefix", 1, NULL, '#'},
-	{"ulog-cprange", 1, NULL, 'A'},
-	{"ulog-qthreshold", 1, NULL, 'B'},
-	{ .name =3D NULL }
+	{.name =3D "ulog-nlgroup",    .has_arg =3D true, .val =3D '!'},
+	{.name =3D "ulog-prefix",     .has_arg =3D true, .val =3D '#'},
+	{.name =3D "ulog-cprange",    .has_arg =3D true, .val =3D 'A'},
+	{.name =3D "ulog-qthreshold", .has_arg =3D true, .val =3D 'B'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void ULOG_init(struct xt_entry_target *t)
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.=
c
index ad63dcf..9391b4e 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -1,7 +1,7 @@
 /* Shared library add-on to iptables to add addrtype matching support=20
  *=20
  * This program is released under the terms of GNU GPL */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -304,23 +304,23 @@ static void addrtype_save_v1(const void *ip, cons=
t struct xt_entry_match *match)
 }
=20
 static const struct option addrtype_opts[] =3D {
-	{ "src-type", 1, NULL, '1' },
-	{ "dst-type", 1, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "src-type", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "dst-type", .has_arg =3D true, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option addrtype_opts_v0[] =3D {
-	{ "src-type", 1, NULL, '1' },
-	{ "dst-type", 1, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "src-type", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "dst-type", .has_arg =3D true, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option addrtype_opts_v1[] =3D {
-	{ "src-type", 1, NULL, '1' },
-	{ "dst-type", 1, NULL, '2' },
-	{ "limit-iface-in", 0, NULL, '3' },
-	{ "limit-iface-out", 0, NULL, '4' },
-	{ .name =3D NULL }
+	{.name =3D "src-type",        .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "dst-type",        .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "limit-iface-in",  .has_arg =3D false, .val =3D '3'},
+	{.name =3D "limit-iface-out", .has_arg =3D false, .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_match addrtype_mt_reg[] =3D {
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 170cd8b..58ed6d1 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add AH support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -17,8 +18,8 @@ static void ah_help(void)
 }
=20
 static const struct option ah_opts[] =3D {
-	{ "ahspi", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "ahspi", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index ec3ff2d..3f1fc3b 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -7,6 +7,7 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -25,10 +26,10 @@ static void ecn_help(void)
 }
=20
 static const struct option ecn_opts[] =3D {
-	{ .name =3D "ecn-tcp-cwr", .has_arg =3D 0, .val =3D 'F' },
-	{ .name =3D "ecn-tcp-ece", .has_arg =3D 0, .val =3D 'G' },
-	{ .name =3D "ecn-ip-ect",  .has_arg =3D 1, .val =3D 'H' },
-	{ .name =3D NULL }
+	{.name =3D "ecn-tcp-cwr", .has_arg =3D false, .val =3D 'F'},
+	{.name =3D "ecn-tcp-ece", .has_arg =3D false, .val =3D 'G'},
+	{.name =3D "ecn-ip-ect",  .has_arg =3D true,  .val =3D 'H'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int ecn_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 37b2fdc..28985b9 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add ICMP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -108,8 +109,8 @@ static void icmp_help(void)
 }
=20
 static const struct option icmp_opts[] =3D {
-	{ "icmp-type", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "icmp-type", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void=20
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index cd4b324..1d48546 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add realm matching support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -23,8 +24,8 @@ static void realm_help(void)
 }
=20
 static const struct option realm_opts[] =3D {
-	{ "realm", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "realm", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 struct realmname {=20
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index e2fbcd5..34d0f23 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -4,7 +4,7 @@
  * $Id$
  *
  * This program is released under the terms of GNU GPL */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -139,11 +139,11 @@ static void ttl_save(const void *ip, const struct=
 xt_entry_match *match)
 }
=20
 static const struct option ttl_opts[] =3D {
-	{ "ttl", 1, NULL, '2' },
-	{ "ttl-eq", 1, NULL, '2'},
-	{ "ttl-lt", 1, NULL, '3'},
-	{ "ttl-gt", 1, NULL, '4'},
-	{ .name =3D NULL }
+	{.name =3D "ttl",    .has_arg =3D true, .val =3D '2'},
+	{.name =3D "ttl-eq", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "ttl-lt", .has_arg =3D true, .val =3D '3'},
+	{.name =3D "ttl-gt", .has_arg =3D true, .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xtables_match ttl_mt_reg =3D {
diff --git a/extensions/libxt_CHECKSUM.c b/extensions/libxt_CHECKSUM.c
index 9a24443..101a54c 100644
--- a/extensions/libxt_CHECKSUM.c
+++ b/extensions/libxt_CHECKSUM.c
@@ -8,6 +8,7 @@
  *
  * libxt_CHECKSUM.c borrowed some bits from libipt_ECN.c
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -24,8 +25,8 @@ static void CHECKSUM_help(void)
 }
=20
 static const struct option CHECKSUM_opts[] =3D {
-	{ "checksum-fill", 0, NULL, 'F' },
-	{ .name =3D NULL }
+	{.name =3D "checksum-fill", .has_arg =3D false, .val =3D 'F'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int CHECKSUM_parse(int c, char **argv, int invert, unsigned int=
 *flags,
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 82b8f4e..ab5127c 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add CLASSIFY target support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -19,8 +20,8 @@ CLASSIFY_help(void)
 }
=20
 static const struct option CLASSIFY_opts[] =3D {
-	{ "set-class", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "set-class", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 6aba5f3..6772877 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -19,6 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -49,11 +50,11 @@ static void CONNMARK_help(void)
 }
=20
 static const struct option CONNMARK_opts[] =3D {
-	{ "set-mark", 1, NULL, '1' },
-	{ "save-mark", 0, NULL, '2' },
-	{ "restore-mark", 0, NULL, '3' },
-	{ "mask", 1, NULL, '4' },
-	{ .name =3D NULL }
+	{.name =3D "set-mark",     .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "save-mark",    .has_arg =3D false, .val =3D '2'},
+	{.name =3D "restore-mark", .has_arg =3D false, .val =3D '3'},
+	{.name =3D "mask",         .has_arg =3D true,  .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option connmark_tg_opts[] =3D {
@@ -67,7 +68,7 @@ static const struct option connmark_tg_opts[] =3D {
 	{.name =3D "ctmask",        .has_arg =3D true,  .val =3D 'c'},
 	{.name =3D "nfmask",        .has_arg =3D true,  .val =3D 'n'},
 	{.name =3D "mask",          .has_arg =3D true,  .val =3D 'm'},
-	{.name =3D NULL},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void connmark_tg_help(void)
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECM=
ARK.c
index d95339f..8df2363 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -23,9 +24,9 @@ static void CONNSECMARK_help(void)
 }
=20
 static const struct option CONNSECMARK_opts[] =3D {
-	{ "save", 0, NULL, '1' },
-	{ "restore", 0, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "save",    .has_arg =3D false, .val =3D '1'},
+	{.name =3D "restore", .has_arg =3D false, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_CT.c b/extensions/libxt_CT.c
index 6be6ea0..8952b75 100644
--- a/extensions/libxt_CT.c
+++ b/extensions/libxt_CT.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -28,12 +29,12 @@ enum ct_options {
 };
=20
 static const struct option ct_opts[] =3D {
-	{ "notrack",	0, NULL, CT_OPT_NOTRACK },
-	{ "helper",	1, NULL, CT_OPT_HELPER },
-	{ "ctevents",	1, NULL, CT_OPT_CTEVENTS },
-	{ "expevents",	1, NULL, CT_OPT_EXPEVENTS },
-	{ "zone",	1, NULL, CT_OPT_ZONE },
-	{ .name	=3D NULL },
+	{.name =3D "notrack",	.has_arg =3D false, .val =3D CT_OPT_NOTRACK},
+	{.name =3D "helper",	.has_arg =3D true,  .val =3D CT_OPT_HELPER},
+	{.name =3D "ctevents",	.has_arg =3D true,  .val =3D CT_OPT_CTEVENTS},
+	{.name =3D "expevents",	.has_arg =3D true,  .val =3D CT_OPT_EXPEVENTS=
},
+	{.name =3D "zone",	.has_arg =3D true,  .val =3D CT_OPT_ZONE},
+	XT_GETOPT_TABLEEND,
 };
=20
 struct event_tbl {
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 82ac10c..9a69824 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -9,6 +9,7 @@
  *
  * --set-class added by Iain Barnes
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -38,9 +39,9 @@ static void DSCP_help(void)
 }
=20
 static const struct option DSCP_opts[] =3D {
-	{ "set-dscp", 1, NULL, 'F' },
-	{ "set-dscp-class", 1, NULL, 'G' },
-	{ .name =3D NULL }
+	{.name =3D "set-dscp",       .has_arg =3D true, .val =3D 'F'},
+	{.name =3D "set-dscp-class", .has_arg =3D true, .val =3D 'G'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_IDLETIMER.c b/extensions/libxt_IDLETIMER.=
c
index c931d0e..12573a4 100644
--- a/extensions/libxt_IDLETIMER.c
+++ b/extensions/libxt_IDLETIMER.c
@@ -20,7 +20,7 @@
  * 02110-1301 USA
  *
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -36,9 +36,9 @@ enum {
 };
=20
 static const struct option idletimer_tg_opts[] =3D {
-	{ .name =3D "timeout", .has_arg =3D true, .flag =3D 0, .val =3D 't' }=
,
-	{ .name =3D "label",   .has_arg =3D true, .flag =3D 0, .val =3D 'l' }=
,
-	{ .name =3D NULL }
+	{.name =3D "timeout", .has_arg =3D true, .val =3D 't'},
+	{.name =3D "label",   .has_arg =3D true, .val =3D 'l'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void idletimer_tg_help(void)
diff --git a/extensions/libxt_LED.c b/extensions/libxt_LED.c
index af0e091..ca1b6ed 100644
--- a/extensions/libxt_LED.c
+++ b/extensions/libxt_LED.c
@@ -9,7 +9,7 @@
  * published by the Free Software Foundation.
  *
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -24,7 +24,7 @@ static const struct option LED_opts[] =3D {
 	{.name =3D "led-trigger-id",   .has_arg =3D true,  .val =3D 'i'},
 	{.name =3D "led-delay",        .has_arg =3D true,  .val =3D 'd'},
 	{.name =3D "led-always-blink", .has_arg =3D false, .val =3D 'a'},
-	{.name =3D NULL},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void LED_help(void)
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index dbfc7c0..39996d0 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -40,10 +40,10 @@ static void MARK_help(void)
 }
=20
 static const struct option MARK_opts[] =3D {
-	{ "set-mark", 1, NULL, '1' },
-	{ "and-mark", 1, NULL, '2' },
-	{ "or-mark", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "set-mark", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "and-mark", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "or-mark",  .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option mark_tg_opts[] =3D {
@@ -52,7 +52,7 @@ static const struct option mark_tg_opts[] =3D {
 	{.name =3D "and-mark",  .has_arg =3D true, .val =3D '&'},
 	{.name =3D "or-mark",   .has_arg =3D true, .val =3D '|'},
 	{.name =3D "xor-mark",  .has_arg =3D true, .val =3D '^'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void mark_tg_help(void)
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index e2185d5..2cf279a 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -15,11 +16,11 @@ enum {
 };
=20
 static const struct option NFLOG_opts[] =3D {
-	{ "nflog-group",     1, NULL, NFLOG_GROUP },
-	{ "nflog-prefix",    1, NULL, NFLOG_PREFIX },
-	{ "nflog-range",     1, NULL, NFLOG_RANGE },
-	{ "nflog-threshold", 1, NULL, NFLOG_THRESHOLD },
-	{ .name =3D NULL }
+	{.name =3D "nflog-group",     .has_arg =3D true, .val =3D NFLOG_GROUP=
},
+	{.name =3D "nflog-prefix",    .has_arg =3D true, .val =3D NFLOG_PREFI=
X},
+	{.name =3D "nflog-range",     .has_arg =3D true, .val =3D NFLOG_RANGE=
},
+	{.name =3D "nflog-threshold", .has_arg =3D true, .val =3D NFLOG_THRES=
HOLD},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void NFLOG_help(void)
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 2d9d98a..e412153 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -5,6 +5,7 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -31,9 +32,9 @@ static void NFQUEUE_help_v1(void)
 }
=20
 static const struct option NFQUEUE_opts[] =3D {
-	{ "queue-num", 1, NULL, 'F' },
-	{ "queue-balance", 1, NULL, 'B' },
-	{ .name =3D NULL }
+	{.name =3D "queue-num",     .has_arg =3D true, .val =3D 'F'},
+	{.name =3D "queue-balance", .has_arg =3D true, .val =3D 'B'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void exit_badqueue(const char *s)
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index 4b7831f..d89f818 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -31,10 +32,10 @@ enum RATEEST_options {
 };
=20
 static const struct option RATEEST_opts[] =3D {
-	{ "rateest-name",	1, NULL, RATEEST_OPT_NAME },
-	{ "rateest-interval",	1, NULL, RATEEST_OPT_INTERVAL },
-	{ "rateest-ewmalog",	1, NULL, RATEEST_OPT_EWMALOG },
-	{ .name =3D NULL },
+	{.name =3D "rateest-name",     .has_arg =3D true, .val =3D RATEEST_OP=
T_NAME},
+	{.name =3D "rateest-interval", .has_arg =3D true, .val =3D RATEEST_OP=
T_INTERVAL},
+	{.name =3D "rateest-ewmalog",  .has_arg =3D true, .val =3D RATEEST_OP=
T_EWMALOG},
+	XT_GETOPT_TABLEEND,
 };
=20
 /* Copied from iproute */
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 2152b6f..9e231ee 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -5,6 +5,7 @@
  *
  * Copyright (C) 2006 Red Hat, Inc., James Morris <jmorris@redhat.com>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -22,8 +23,8 @@ static void SECMARK_help(void)
 }
=20
 static const struct option SECMARK_opts[] =3D {
-	{ "selctx", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "selctx", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int SECMARK_parse(int c, char **argv, int invert, unsigned int =
*flags,
diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index f6386a9..c05811e 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -9,6 +9,7 @@
  */
=20
 /* Shared library add-on to iptables to add IP set mangling target. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -32,9 +33,9 @@ set_target_help(void)
 }
=20
 static const struct option set_target_opts[] =3D {
-	{ .name =3D "add-set", .has_arg =3D true, .val =3D '1'},
-	{ .name =3D "del-set", .has_arg =3D true, .val =3D '2'},
-	{ .name =3D NULL }
+	{.name =3D "add-set", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "del-set", .has_arg =3D true, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index ac9e2d0..b24789a 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -2,6 +2,7 @@
  *
  * Copyright (c) 2000 Marc Boucher
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -36,9 +37,9 @@ static void TCPMSS_help6(void)
 }
=20
 static const struct option TCPMSS_opts[] =3D {
-	{ "set-mss", 1, NULL, '1' },
-	{ "clamp-mss-to-pmtu", 0, NULL, '2' },
-	{ .name =3D NULL }
+	{.name =3D "set-mss",           .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "clamp-mss-to-pmtu", .has_arg =3D false, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int=
 *flags,
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTST=
RIP.c
index a063d0d..66ab46d 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -28,7 +28,7 @@ struct tcp_optionmap {
=20
 static const struct option tcpoptstrip_tg_opts[] =3D {
 	{.name =3D "strip-options", .has_arg =3D true, .val =3D 's'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct tcp_optionmap tcp_optionmap[] =3D {
@@ -38,7 +38,7 @@ static const struct tcp_optionmap tcp_optionmap[] =3D=
 {
 	{"sack",           "Selective ACK",        TCPOPT_SACK},
 	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
 	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void tcpoptstrip_tg_help(void)
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index dc60cc0..9575c05 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -5,6 +5,7 @@
  * Contact: Jan Engelhardt <jengelh@computergmbh.de>
  */
 #include <getopt.h>
+#include <stdbool.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
@@ -24,7 +25,7 @@ enum {
=20
 static const struct option tos_tg_opts_v0[] =3D {
 	{.name =3D "set-tos", .has_arg =3D true, .val =3D '=3D'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option tos_tg_opts[] =3D {
@@ -32,7 +33,7 @@ static const struct option tos_tg_opts[] =3D {
 	{.name =3D "and-tos", .has_arg =3D true, .val =3D '&'},
 	{.name =3D "or-tos",  .has_arg =3D true, .val =3D '|'},
 	{.name =3D "xor-tos", .has_arg =3D true, .val =3D '^'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void tos_tg_help_v0(void)
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d410c52..cd0b50a 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -15,10 +15,10 @@
 #include <linux/netfilter/xt_TPROXY.h>
=20
 static const struct option tproxy_tg_opts[] =3D {
-	{ .name =3D "on-port", .has_arg =3D 1, .val =3D '1'},
-	{ .name =3D "on-ip", .has_arg =3D 1, .val =3D '2'},
-	{ .name =3D "tproxy-mark", .has_arg =3D 1, .val =3D '3'},
-	{NULL},
+	{.name =3D "on-port",     .has_arg =3D true, .val =3D '1'},
+	{.name =3D "on-ip",       .has_arg =3D true, .val =3D '2'},
+	{.name =3D "tproxy-mark", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 enum {
diff --git a/extensions/libxt_cluster.c b/extensions/libxt_cluster.c
index ea5d9fb..1591045 100644
--- a/extensions/libxt_cluster.c
+++ b/extensions/libxt_cluster.c
@@ -5,6 +5,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -38,11 +39,11 @@ enum {
 };
=20
 static const struct option cluster_opts[] =3D {
-	{ "cluster-total-nodes", 	1, NULL, CLUSTER_OPT_TOTAL_NODES },
-	{ "cluster-local-node", 	1, NULL, CLUSTER_OPT_LOCAL_NODE },
-	{ "cluster-local-nodemask",	1, NULL, CLUSTER_OPT_NODE_MASK },
-	{ "cluster-hash-seed",		1, NULL, CLUSTER_OPT_HASH_SEED },
-	{ .name =3D NULL }
+	{.name =3D "cluster-total-nodes",    .has_arg =3D true, .val =3D CLUS=
TER_OPT_TOTAL_NODES},
+	{.name =3D "cluster-local-node",     .has_arg =3D true, .val =3D CLUS=
TER_OPT_LOCAL_NODE},
+	{.name =3D "cluster-local-nodemask", .has_arg =3D true, .val =3D CLUS=
TER_OPT_NODE_MASK},
+	{.name =3D "cluster-hash-seed",      .has_arg =3D true, .val =3D CLUS=
TER_OPT_HASH_SEED},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int=20
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 0068a6e..a9325a5 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -6,6 +6,7 @@
  *     2004-05-12: Brad Fisher <brad@info-link.net>
  *         Port to patch-o-matic-ng
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -22,8 +23,8 @@ static void comment_help(void)
 }
=20
 static const struct option comment_opts[] =3D {
-	{ "comment", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "comment", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.=
c
index 5ebdd34..2e20862 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add byte tracking support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -18,10 +19,10 @@ static void connbytes_help(void)
 }
=20
 static const struct option connbytes_opts[] =3D {
-	{ "connbytes", 1, NULL, '1' },
-	{ "connbytes-dir", 1, NULL, '2' },
-	{ "connbytes-mode", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "connbytes",      .has_arg =3D true, .val =3D '1'},
+	{.name =3D "connbytes-dir",  .has_arg =3D true, .val =3D '2'},
+	{.name =3D "connbytes-mode", .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.=
c
index a215915..b01d301 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add connection limit support. =
*/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -18,9 +19,9 @@ static void connlimit_help(void)
 }
=20
 static const struct option connlimit_opts[] =3D {
-	{"connlimit-above", 1, NULL, 'A'},
-	{"connlimit-mask",  1, NULL, 'M'},
-	{ .name =3D NULL }
+	{.name =3D "connlimit-above", .has_arg =3D true, .val =3D 'A'},
+	{.name =3D "connlimit-mask",  .has_arg =3D true, .val =3D 'M'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void connlimit_init(struct xt_entry_match *match)
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 38aa563..6bb2689 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -19,6 +19,7 @@
  * along with this program; if not, write to the Free Software
  * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-130=
7  USA
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -46,7 +47,7 @@ static void connmark_mt_help(void)
=20
 static const struct option connmark_mt_opts[] =3D {
 	{.name =3D "mark", .has_arg =3D true, .val =3D '1'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.=
c
index 5557d3e..6c4a9cd 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -88,7 +88,7 @@ static const struct option conntrack_mt_opts_v0[] =3D=
 {
 	{.name =3D "ctrepldst", .has_arg =3D true, .val =3D '6'},
 	{.name =3D "ctstatus",  .has_arg =3D true, .val =3D '7'},
 	{.name =3D "ctexpire",  .has_arg =3D true, .val =3D '8'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option conntrack_mt_opts[] =3D {
diff --git a/extensions/libxt_cpu.c b/extensions/libxt_cpu.c
index 66b9d83..ee02996 100644
--- a/extensions/libxt_cpu.c
+++ b/extensions/libxt_cpu.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add CPU match support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -15,8 +16,8 @@ static void cpu_help(void)
 }
=20
 static const struct option cpu_opts[] =3D {
-	{ "cpu", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "cpu", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 8d0b13a..104f46f 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -5,6 +5,7 @@
  * This program is distributed under the terms of GNU GPL v2, 1991
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -43,13 +44,13 @@ static void dccp_help(void)
 }
=20
 static const struct option dccp_opts[] =3D {
-	{ .name =3D "source-port", .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "sport", .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "destination-port", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "dport", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "dccp-types", .has_arg =3D 1, .val =3D '3' },
-	{ .name =3D "dccp-option", .has_arg =3D 1, .val =3D '4' },
-	{ .name =3D NULL }
+	{.name =3D "source-port",      .has_arg =3D true, .val =3D '1'},
+	{.name =3D "sport",            .has_arg =3D true, .val =3D '1'},
+	{.name =3D "destination-port", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dport",            .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dccp-types",       .has_arg =3D true, .val =3D '3'},
+	{.name =3D "dccp-option",      .has_arg =3D true, .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 1569f7d..4f81f2f 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -12,6 +12,7 @@
  * http://www.iana.org/assignments/dscp-registry
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -38,9 +39,9 @@ static void dscp_help(void)
 }
=20
 static const struct option dscp_opts[] =3D {
-	{ "dscp", 1, NULL, 'F' },
-	{ "dscp-class", 1, NULL, 'G' },
-	{ .name =3D NULL }
+	{.name =3D "dscp",       .has_arg =3D true, .val =3D 'F'},
+	{.name =3D "dscp-class", .has_arg =3D true, .val =3D 'G'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 18218f4..070a6a4 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add ESP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -19,8 +20,8 @@ static void esp_help(void)
 }
=20
 static const struct option esp_opts[] =3D {
-	{ "espspi", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "espspi", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int32_t
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index 7442dfc..fbf19d2 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -67,15 +67,15 @@ static void hashlimit_mt_help(void)
 }
=20
 static const struct option hashlimit_opts[] =3D {
-	{ "hashlimit", 1, NULL, '%' },
-	{ "hashlimit-burst", 1, NULL, '$' },
-	{ "hashlimit-htable-size", 1, NULL, '&' },
-	{ "hashlimit-htable-max", 1, NULL, '*' },
-	{ "hashlimit-htable-gcinterval", 1, NULL, '(' },
-	{ "hashlimit-htable-expire", 1, NULL, ')' },
-	{ "hashlimit-mode", 1, NULL, '_' },
-	{ "hashlimit-name", 1, NULL, '"' },
-	{ .name =3D NULL }
+	{.name =3D "hashlimit",                   .has_arg =3D true, .val =3D=
 '%'},
+	{.name =3D "hashlimit-burst",             .has_arg =3D true, .val =3D=
 '$'},
+	{.name =3D "hashlimit-htable-size",       .has_arg =3D true, .val =3D=
 '&'},
+	{.name =3D "hashlimit-htable-max",        .has_arg =3D true, .val =3D=
 '*'},
+	{.name =3D "hashlimit-htable-gcinterval", .has_arg =3D true, .val =3D=
 '('},
+	{.name =3D "hashlimit-htable-expire",     .has_arg =3D true, .val =3D=
 ')'},
+	{.name =3D "hashlimit-mode",              .has_arg =3D true, .val =3D=
 '_'},
+	{.name =3D "hashlimit-name",              .has_arg =3D true, .val =3D=
 '"'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option hashlimit_mt_opts[] =3D {
@@ -91,7 +91,7 @@ static const struct option hashlimit_mt_opts[] =3D {
 	{.name =3D "hashlimit-htable-expire",     .has_arg =3D true, .val =3D=
 ')'},
 	{.name =3D "hashlimit-mode",              .has_arg =3D true, .val =3D=
 '_'},
 	{.name =3D "hashlimit-name",              .has_arg =3D true, .val =3D=
 '"'},
-	{},
+	XT_GETOPT_TABLEEND,
 };
=20
 static
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 35b5f15..e9551bc 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add related packet matching su=
pport. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -16,8 +17,8 @@ static void helper_help(void)
 }
=20
 static const struct option helper_opts[] =3D {
-	{ "helper", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "helper", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 55a2f84..6b511b5 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add IP range matching support.=
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -39,7 +40,7 @@ static void iprange_mt_help(void)
 static const struct option iprange_mt_opts[] =3D {
 	{.name =3D "src-range", .has_arg =3D true, .val =3D '1'},
 	{.name =3D "dst-range", .has_arg =3D true, .val =3D '2'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index 6843551..493d975 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -11,6 +11,7 @@
 #include <errno.h>
 #include <getopt.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -26,7 +27,7 @@ static const struct option ipvs_mt_opts[] =3D {
 	{ .name =3D "vdir",     .has_arg =3D true,  .val =3D '4' },
 	{ .name =3D "vmethod",  .has_arg =3D true,  .val =3D '5' },
 	{ .name =3D "vportctl", .has_arg =3D true,  .val =3D '6' },
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void ipvs_mt_help(void)
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 96e8b6c..aeba52f 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add packet length matching sup=
port. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -17,8 +18,8 @@ static void length_help(void)
 }
  =20
 static const struct option length_opts[] =3D {
-	{ "length", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "length", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int16_t
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index c836303..3f94e21 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -3,7 +3,7 @@
  * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
  * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -29,9 +29,9 @@ XT_LIMIT_BURST);
 }
=20
 static const struct option limit_opts[] =3D {
-	{ "limit", 1, NULL, '%' },
-	{ "limit-burst", 1, NULL, '$' },
-	{ .name =3D NULL }
+	{.name =3D "limit",       .has_arg =3D true, .val =3D '%'},
+	{.name =3D "limit-burst", .has_arg =3D true, .val =3D '$'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index 00996a0..eb07467 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add MAC address support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -21,8 +22,8 @@ static void mac_help(void)
 }
=20
 static const struct option mac_opts[] =3D {
-	{ "mac-source", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "mac-source", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 8013c9a..a2bc4f8 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -27,7 +27,7 @@ static void mark_mt_help(void)
=20
 static const struct option mark_mt_opts[] =3D {
 	{.name =3D "mark", .has_arg =3D true, .val =3D '1'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static int mark_mt_parse(int c, char **argv, int invert, unsigned int =
*flags,
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.=
c
index e8a0dab..5b823b6 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add multiple TCP port support.=
 */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -44,12 +45,12 @@ static void multiport_help_v1(void)
 }
=20
 static const struct option multiport_opts[] =3D {
-	{ "source-ports", 1, NULL, '1' },
-	{ "sports", 1, NULL, '1' }, /* synonym */
-	{ "destination-ports", 1, NULL, '2' },
-	{ "dports", 1, NULL, '2' }, /* synonym */
-	{ "ports", 1, NULL, '3' },
-	{ .name =3D NULL }
+	{.name =3D "source-ports",      .has_arg =3D true, .val =3D '1'},
+	{.name =3D "sports",            .has_arg =3D true, .val =3D '1'}, /* =
synonym */
+	{.name =3D "destination-ports", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dports",            .has_arg =3D true, .val =3D '2'}, /* =
synonym */
+	{.name =3D "ports",             .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static char *
diff --git a/extensions/libxt_osf.c b/extensions/libxt_osf.c
index 07b86e4..66c23b4 100644
--- a/extensions/libxt_osf.c
+++ b/extensions/libxt_osf.c
@@ -20,7 +20,7 @@
 /*
  * xtables interface for OS fingerprint matching module.
  */
-
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -54,10 +54,10 @@ static void osf_help(void)
=20
=20
 static const struct option osf_opts[] =3D {
-	{ .name =3D "genre",	.has_arg =3D true, .val =3D '1' },
-	{ .name =3D "ttl",	.has_arg =3D true, .val =3D '2' },
-	{ .name =3D "log",	.has_arg =3D true, .val =3D '3' },
-	{ .name =3D NULL }
+	{.name =3D "genre", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "ttl",   .has_arg =3D true, .val =3D '2'},
+	{.name =3D "log",   .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
=20
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index b595d97..4015f13 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -113,7 +113,7 @@ static const struct option owner_mt_opts_v0[] =3D {
 #ifdef IPT_OWNER_COMM
 	{.name =3D "cmd-owner", .has_arg =3D true, .val =3D 'c'},
 #endif
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option owner_mt6_opts_v0[] =3D {
@@ -121,14 +121,14 @@ static const struct option owner_mt6_opts_v0[] =3D=
 {
 	{.name =3D "gid-owner", .has_arg =3D true, .val =3D 'g'},
 	{.name =3D "pid-owner", .has_arg =3D true, .val =3D 'p'},
 	{.name =3D "sid-owner", .has_arg =3D true, .val =3D 's'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static const struct option owner_mt_opts[] =3D {
 	{.name =3D "uid-owner",     .has_arg =3D true,  .val =3D 'u'},
 	{.name =3D "gid-owner",     .has_arg =3D true,  .val =3D 'g'},
 	{.name =3D "socket-exists", .has_arg =3D false, .val =3D 'k'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 5382ab6..d92df9e 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add bridge port matching suppo=
rt. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -24,12 +25,12 @@ static void physdev_help(void)
 }
=20
 static const struct option physdev_opts[] =3D {
-	{ "physdev-in", 1, NULL, '1' },
-	{ "physdev-out", 1, NULL, '2' },
-	{ "physdev-is-in", 0, NULL, '3' },
-	{ "physdev-is-out", 0, NULL, '4' },
-	{ "physdev-is-bridged", 0, NULL, '5' },
-	{ .name =3D NULL }
+	{.name =3D "physdev-in",         .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "physdev-out",        .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "physdev-is-in",      .has_arg =3D false, .val =3D '3'},
+	{.name =3D "physdev-is-out",     .has_arg =3D false, .val =3D '4'},
+	{.name =3D "physdev-is-bridged", .has_arg =3D false, .val =3D '5'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index cd83e73..d402591 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -4,6 +4,7 @@
  *
  * Michal Ludvig <michal@logix.cz>
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -61,8 +62,8 @@ static void pkttype_help(void)
 }
=20
 static const struct option pkttype_opts[] =3D {
-	{"pkt-type", 1, NULL, '1'},
-	{ .name =3D NULL }
+	{.name =3D "pkt-type", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void parse_pkttype(const char *pkttype, struct xt_pkttype_info =
*info)
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index a87ddd8..3ddb3ec 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add policy support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -42,53 +43,55 @@ static const struct option policy_opts[] =3D
 {
 	{
 		.name		=3D "dir",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '1',
 	},
 	{
 		.name		=3D "pol",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '2',
 	},
 	{
 		.name		=3D "strict",
+		.has_arg	=3D false,
 		.val		=3D '3'
 	},
 	{
 		.name		=3D "reqid",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '4',
 	},
 	{
 		.name		=3D "spi",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '5'
 	},
 	{
 		.name		=3D "tunnel-src",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '6'
 	},
 	{
 		.name		=3D "tunnel-dst",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '7'
 	},
 	{
 		.name		=3D "proto",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '8'
 	},
 	{
 		.name		=3D "mode",
-		.has_arg	=3D 1,
+		.has_arg	=3D true,
 		.val		=3D '9'
 	},
 	{
 		.name		=3D "next",
+		.has_arg	=3D false,
 		.val		=3D 'a'
 	},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static int parse_direction(char *s)
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index ac7c686..b6bab93 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -3,6 +3,7 @@
  *
  * Sam Johnston <samj@samj.net>
  */
+#include <stdbool.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -12,8 +13,8 @@
 #include <linux/netfilter/xt_quota.h>
=20
 static const struct option quota_opts[] =3D {
-	{"quota", 1, NULL, '1'},
-	{ .name =3D NULL }
+	{.name =3D "quota", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void quota_help(void)
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index ad0884e..6aefb5c 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -40,20 +41,20 @@ enum rateest_options {
 };
=20
 static const struct option rateest_opts[] =3D {
-	{ "rateest1",		1, NULL, OPT_RATEEST1 },
-	{ "rateest",		1, NULL, OPT_RATEEST1 }, /* alias for absolute mode */
-	{ "rateest2",		1, NULL, OPT_RATEEST2 },
-	{ "rateest-bps1",	0, NULL, OPT_RATEEST_BPS1 },
-	{ "rateest-pps1",	0, NULL, OPT_RATEEST_PPS1 },
-	{ "rateest-bps2",	0, NULL, OPT_RATEEST_BPS2 },
-	{ "rateest-pps2",	0, NULL, OPT_RATEEST_PPS2 },
-	{ "rateest-bps",	0, NULL, OPT_RATEEST_BPS2 }, /* alias for absolute m=
ode */
-	{ "rateest-pps",	0, NULL, OPT_RATEEST_PPS2 }, /* alias for absolute m=
ode */
-	{ "rateest-delta",	0, NULL, OPT_RATEEST_DELTA },
-	{ "rateest-lt",		0, NULL, OPT_RATEEST_LT },
-	{ "rateest-gt",		0, NULL, OPT_RATEEST_GT },
-	{ "rateest-eq",		0, NULL, OPT_RATEEST_EQ },
-	{ .name =3D NULL }
+	{.name =3D "rateest1",      .has_arg =3D true,  .val =3D OPT_RATEEST1=
},
+	{.name =3D "rateest",       .has_arg =3D true,  .val =3D OPT_RATEEST1=
}, /* alias for absolute mode */
+	{.name =3D "rateest2",      .has_arg =3D true,  .val =3D OPT_RATEEST2=
},
+	{.name =3D "rateest-bps1",  .has_arg =3D false, .val =3D OPT_RATEEST_=
BPS1},
+	{.name =3D "rateest-pps1",  .has_arg =3D false, .val =3D OPT_RATEEST_=
PPS1},
+	{.name =3D "rateest-bps2",  .has_arg =3D false, .val =3D OPT_RATEEST_=
BPS2},
+	{.name =3D "rateest-pps2",  .has_arg =3D false, .val =3D OPT_RATEEST_=
PPS2},
+	{.name =3D "rateest-bps",   .has_arg =3D false, .val =3D OPT_RATEEST_=
BPS2}, /* alias for absolute mode */
+	{.name =3D "rateest-pps",   .has_arg =3D false, .val =3D OPT_RATEEST_=
PPS2}, /* alias for absolute mode */
+	{.name =3D "rateest-delta", .has_arg =3D false, .val =3D OPT_RATEEST_=
DELTA},
+	{.name =3D "rateest-lt",    .has_arg =3D false, .val =3D OPT_RATEEST_=
LT},
+	{.name =3D "rateest-gt",    .has_arg =3D false, .val =3D OPT_RATEEST_=
GT},
+	{.name =3D "rateest-eq",    .has_arg =3D false, .val =3D OPT_RATEEST_=
EQ},
+	XT_GETOPT_TABLEEND,
 };
=20
 /* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.h=
tml */
@@ -79,7 +80,7 @@ static const struct rate_suffix {
 	{ "GBps",	8000000000. },
 	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
 	{ "TBps",	8000000000000. },
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index ecc17ad..41faeb6 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add recent matching support. *=
/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -9,17 +10,17 @@
 #include <linux/netfilter/xt_recent.h>
=20
 static const struct option recent_opts[] =3D {
-	{ .name =3D "set",      .has_arg =3D 0, .val =3D 201 },
-	{ .name =3D "rcheck",   .has_arg =3D 0, .val =3D 202 },
-	{ .name =3D "update",   .has_arg =3D 0, .val =3D 203 },
-	{ .name =3D "seconds",  .has_arg =3D 1, .val =3D 204 },
-	{ .name =3D "hitcount", .has_arg =3D 1, .val =3D 205 },
-	{ .name =3D "remove",   .has_arg =3D 0, .val =3D 206 },
-	{ .name =3D "rttl",     .has_arg =3D 0, .val =3D 207 },
-	{ .name =3D "name",     .has_arg =3D 1, .val =3D 208 },
-	{ .name =3D "rsource",  .has_arg =3D 0, .val =3D 209 },
-	{ .name =3D "rdest",    .has_arg =3D 0, .val =3D 210 },
-	{ .name =3D NULL }
+	{.name =3D "set",      .has_arg =3D false, .val =3D 201},
+	{.name =3D "rcheck",   .has_arg =3D false, .val =3D 202},
+	{.name =3D "update",   .has_arg =3D false, .val =3D 203},
+	{.name =3D "seconds",  .has_arg =3D true,  .val =3D 204},
+	{.name =3D "hitcount", .has_arg =3D true,  .val =3D 205},
+	{.name =3D "remove",   .has_arg =3D false, .val =3D 206},
+	{.name =3D "rttl",     .has_arg =3D false, .val =3D 207},
+	{.name =3D "name",     .has_arg =3D true,  .val =3D 208},
+	{.name =3D "rsource",  .has_arg =3D false, .val =3D 209},
+	{.name =3D "rdest",    .has_arg =3D false, .val =3D 210},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void recent_help(void)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index d321fb8..80406f7 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -7,6 +7,7 @@
  * libipt_ecn.c borrowed heavily from libipt_dscp.c
  *
  */
+#include <stdbool.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -55,12 +56,12 @@ static void sctp_help(void)
 }
=20
 static const struct option sctp_opts[] =3D {
-	{ .name =3D "source-port", .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "sport", .has_arg =3D 1, .val =3D '1' },
-	{ .name =3D "destination-port", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "dport", .has_arg =3D 1, .val =3D '2' },
-	{ .name =3D "chunk-types", .has_arg =3D 1, .val =3D '3' },
-	{ .name =3D NULL }
+	{.name =3D "source-port",      .has_arg =3D true, .val =3D '1'},
+	{.name =3D "sport",            .has_arg =3D true, .val =3D '1'},
+	{.name =3D "destination-port", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dport",            .has_arg =3D true, .val =3D '2'},
+	{.name =3D "chunk-types",      .has_arg =3D true, .val =3D '3'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index 75fa3c2..594e2d4 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -9,6 +9,7 @@
  */
=20
 /* Shared library add-on to iptables to add IP set matching. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -32,9 +33,9 @@ set_help(void)
 }
=20
 static const struct option set_opts[] =3D {
-	{ .name =3D "match-set", .has_arg =3D true, .val =3D '1'},
-	{ .name =3D "set",       .has_arg =3D true, .val =3D '2'},
-	{ .name =3D NULL }
+	{.name =3D "match-set", .has_arg =3D true, .val =3D '1'},
+	{.name =3D "set",       .has_arg =3D true, .val =3D '2'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index d8159e5..4064333 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add state tracking support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -22,8 +23,8 @@ state_help(void)
 }
=20
 static const struct option state_opts[] =3D {
-	{ "state", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "state", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static int
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.=
c
index 913aa2c..94f2913 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -1,3 +1,4 @@
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -21,11 +22,11 @@ static void statistic_help(void)
 }
=20
 static const struct option statistic_opts[] =3D {
-	{ "mode", 1, NULL, '1' },
-	{ "probability", 1, NULL, '2' },
-	{ "every", 1, NULL, '3' },
-	{ "packet", 1, NULL, '4' },
-	{ .name =3D NULL }
+	{.name =3D "mode",        .has_arg =3D true, .val =3D '1'},
+	{.name =3D "probability", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "every",       .has_arg =3D true, .val =3D '3'},
+	{.name =3D "packet",      .has_arg =3D true, .val =3D '4'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static struct xt_statistic_info *global_info;
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index df6302e..a6c5881 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -21,6 +21,7 @@
  *             ipt_string_info.
  */
 #define _GNU_SOURCE 1
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -44,13 +45,13 @@ static void string_help(void)
 }
=20
 static const struct option string_opts[] =3D {
-	{ "from", 1, NULL, '1' },
-	{ "to", 1, NULL, '2' },
-	{ "algo", 1, NULL, '3' },
-	{ "string", 1, NULL, '4' },
-	{ "hex-string", 1, NULL, '5' },
-	{ "icase", 0, NULL, '6' },
-	{ .name =3D NULL }
+	{.name =3D "from",       .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "to",         .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "algo",       .has_arg =3D true,  .val =3D '3'},
+	{.name =3D "string",     .has_arg =3D true,  .val =3D '4'},
+	{.name =3D "hex-string", .has_arg =3D true,  .val =3D '5'},
+	{.name =3D "icase",      .has_arg =3D false, .val =3D '6'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void string_init(struct xt_entry_match *m)
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 75551d7..26e533c 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add TCP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -26,14 +27,14 @@ static void tcp_help(void)
 }
=20
 static const struct option tcp_opts[] =3D {
-	{ "source-port", 1, NULL, '1' },
-	{ "sport", 1, NULL, '1' }, /* synonym */
-	{ "destination-port", 1, NULL, '2' },
-	{ "dport", 1, NULL, '2' }, /* synonym */
-	{ "syn", 0, NULL, '3' },
-	{ "tcp-flags", 1, NULL, '4' },
-	{ "tcp-option", 1, NULL, '5' },
-	{ .name =3D NULL }
+	{.name =3D "source-port",      .has_arg =3D true,  .val =3D '1'},
+	{.name =3D "sport",            .has_arg =3D true,  .val =3D '1'}, /* =
synonym */
+	{.name =3D "destination-port", .has_arg =3D true,  .val =3D '2'},
+	{.name =3D "dport",            .has_arg =3D true,  .val =3D '2'}, /* =
synonym */
+	{.name =3D "syn",              .has_arg =3D false, .val =3D '3'},
+	{.name =3D "tcp-flags",        .has_arg =3D true,  .val =3D '4'},
+	{.name =3D "tcp-option",       .has_arg =3D true,  .val =3D '5'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index b54a890..110c60d 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add tcp MSS matching support. =
*/
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -17,8 +18,8 @@ static void tcpmss_help(void)
 }
=20
 static const struct option tcpmss_opts[] =3D {
-	{ "mss", 1, NULL, '1' },
-	{ .name =3D NULL }
+	{.name =3D "mss", .has_arg =3D true, .val =3D '1'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static u_int16_t
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 098fc9c..9f12266 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -38,15 +38,15 @@ static const char *const week_days[] =3D {
 };
=20
 static const struct option time_opts[] =3D {
-	{"datestart", true,  NULL, 'D'},
-	{"datestop",  true,  NULL, 'E'},
-	{"timestart", true,  NULL, 'X'},
-	{"timestop",  true,  NULL, 'Y'},
-	{"weekdays",  true,  NULL, 'w'},
-	{"monthdays", true,  NULL, 'm'},
-	{"localtz",   false, NULL, 'l'},
-	{"utc",       false, NULL, 'u'},
-	{ .name =3D NULL }
+	{.name =3D "datestart", .has_arg =3D true,  .val =3D 'D'},
+	{.name =3D "datestop",  .has_arg =3D true,  .val =3D 'E'},
+	{.name =3D "timestart", .has_arg =3D true,  .val =3D 'X'},
+	{.name =3D "timestop",  .has_arg =3D true,  .val =3D 'Y'},
+	{.name =3D "weekdays",  .has_arg =3D true,  .val =3D 'w'},
+	{.name =3D "monthdays", .has_arg =3D true,  .val =3D 'm'},
+	{.name =3D "localtz",   .has_arg =3D false, .val =3D 'l'},
+	{.name =3D "utc",       .has_arg =3D false, .val =3D 'u'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void time_help(void)
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index 6b8cd89..f78594a 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -26,7 +26,7 @@ enum {
=20
 static const struct option tos_mt_opts[] =3D {
 	{.name =3D "tos", .has_arg =3D true, .val =3D 't'},
-	{ .name =3D NULL }
+	XT_GETOPT_TABLEEND,
 };
=20
 static void tos_mt_help(void)
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 9a61c8a..67e6068 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -15,6 +15,7 @@
 #include <errno.h>
 #include <getopt.h>
 #include <netdb.h>
+#include <stdbool.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
@@ -23,8 +24,8 @@
 #include <linux/netfilter/xt_u32.h>
=20
 static const struct option u32_opts[] =3D {
-	{"u32", 1, NULL, 'u'},
-	{ .name =3D NULL }
+	{.name =3D "u32", .has_arg =3D true, .val =3D 'u'},
+	XT_GETOPT_TABLEEND,
 };
=20
 static void u32_help(void)
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 135e7af..3006c04 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -1,4 +1,5 @@
 /* Shared library add-on to iptables to add UDP support. */
+#include <stdbool.h>
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -21,11 +22,11 @@ static void udp_help(void)
 }
=20
 static const struct option udp_opts[] =3D {
-	{ "source-port", 1, NULL, '1' },
-	{ "sport", 1, NULL, '1' }, /* synonym */
-	{ "destination-port", 1, NULL, '2' },
-	{ "dport", 1, NULL, '2' }, /* synonym */
-	{ .name =3D NULL }
+	{.name =3D "source-port",      .has_arg =3D true, .val =3D '1'},
+	{.name =3D "sport",            .has_arg =3D true, .val =3D '1'}, /* s=
ynonym */
+	{.name =3D "destination-port", .has_arg =3D true, .val =3D '2'},
+	{.name =3D "dport",            .has_arg =3D true, .val =3D '2'}, /* s=
ynonym */
+	XT_GETOPT_TABLEEND,
 };
=20
 static void
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index e8f1563..10add19 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -20,7 +20,7 @@ static const struct tos_symbol_info {
 	{IPTOS_RELIABILITY, "Maximize-Reliability"},
 	{IPTOS_MINCOST,     "Minimize-Cost"},
 	{IPTOS_NORMALSVC,   "Normal-Service"},
-	{ .name =3D NULL }
+	{},
 };
=20
 /*
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 2d7df32..9e47c2d 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -199,6 +199,8 @@ struct xtables_globals
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) =
__attribute__((noreturn, format(printf,2,3)));
 };
=20
+#define XT_GETOPT_TABLEEND {NULL}
+
 #ifdef __cplusplus
 extern "C" {
 #endif
--=20
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
