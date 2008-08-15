From: Jan Engelhardt <jengelh@medozas.de>
Subject: Update comments
Date: Fri, 15 Aug 2008 18:57:31 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808151857110.26696@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53622 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbYHOW5d (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 18:57:33 -0400
In-Reply-To: <alpine.LNX.1.10.0808151856510.26696@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit 6ca22c9d159540a558acb21bf80fe4960b656b59
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Aug 15 18:41:08 2008 -0400

Update comments

A number of comments are redundant, some outdated and others outright
wrong in their own way. Remove and fixup.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c        |    8 +-------
 extensions/libip6t_REJECT.c     |   10 +---------
 extensions/libip6t_ah.c         |    8 +-------
 extensions/libip6t_dst.c        |    8 +-------
 extensions/libip6t_eui64.c      |    3 ---
 extensions/libip6t_frag.c       |    8 +-------
 extensions/libip6t_hbh.c        |   10 ++--------
 extensions/libip6t_icmp6.c      |    8 +-------
 extensions/libip6t_ipv6header.c |    4 ----
 extensions/libip6t_policy.c     |    3 +--
 extensions/libip6t_rt.c         |    8 +-------
 extensions/libipt_CLUSTERIP.c   |    3 ---
 extensions/libipt_DNAT.c        |    6 ------
 extensions/libipt_ECN.c         |    2 --
 extensions/libipt_LOG.c         |    6 ------
 extensions/libipt_MASQUERADE.c  |    6 ------
 extensions/libipt_MIRROR.c      |    3 ---
 extensions/libipt_NETMAP.c      |    8 --------
 extensions/libipt_REDIRECT.c    |    6 ------
 extensions/libipt_REJECT.c      |    8 --------
 extensions/libipt_SAME.c        |    7 -------
 extensions/libipt_SET.c         |    7 -------
 extensions/libipt_SNAT.c        |    6 ------
 extensions/libipt_ULOG.c        |    6 ------
 extensions/libipt_ah.c          |    8 +-------
 extensions/libipt_ecn.c         |    2 --
 extensions/libipt_icmp.c        |    6 ------
 extensions/libipt_realm.c       |   10 ----------
 extensions/libipt_recent.c      |   11 +----------
 extensions/libipt_set.c         |    5 -----
 extensions/libipt_unclean.c     |    3 ---
 extensions/libxt_CLASSIFY.c     |    5 -----
 extensions/libxt_CONNMARK.c     |    6 ------
 extensions/libxt_DSCP.c         |    2 --
 extensions/libxt_MARK.c         |    7 -------
 extensions/libxt_NFQUEUE.c      |    2 --
 extensions/libxt_NOTRACK.c      |    3 ---
 extensions/libxt_SECMARK.c      |    5 -----
 extensions/libxt_TCPMSS.c       |    5 -----
 extensions/libxt_TRACE.c        |    3 ---
 extensions/libxt_comment.c      |    5 -----
 extensions/libxt_connbytes.c    |    5 -----
 extensions/libxt_connmark.c     |    4 ----
 extensions/libxt_conntrack.c    |    6 ------
 extensions/libxt_dccp.c         |    4 ----
 extensions/libxt_dscp.c         |    2 --
 extensions/libxt_esp.c          |    6 ------
 extensions/libxt_hashlimit.c    |   11 ++---------
 extensions/libxt_helper.c       |    6 ------
 extensions/libxt_length.c       |    7 -------
 extensions/libxt_limit.c        |   10 ++--------
 extensions/libxt_mac.c          |    6 ------
 extensions/libxt_mark.c         |    4 ----
 extensions/libxt_pkttype.c      |    1 -
 extensions/libxt_quota.c        |    4 ----
 extensions/libxt_sctp.c         |    6 +-----
 extensions/libxt_standard.c     |    3 ---
 extensions/libxt_state.c        |    6 ------
 extensions/libxt_statistic.c    |    3 ---
 extensions/libxt_string.c       |    8 --------
 extensions/libxt_tcp.c          |    6 ------
 extensions/libxt_tcpmss.c       |    6 ------
 extensions/libxt_u32.c          |    1 -
 extensions/libxt_udp.c          |    6 ------
 64 files changed, 17 insertions(+), 344 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 53efae3..07e741c 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -1,4 +1,4 @@
-/* Shared library add-on to iptables to add LOG support. */
+/* Shared library add-on to ip6tables to add LOG support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -17,7 +17,6 @@
=20
 #define LOG_DEFAULT_LEVEL LOG_WARNING
=20
-/* Function which prints out usage message. */
 static void LOG_help(void)
 {
 	printf(
@@ -40,7 +39,6 @@ static const struct option LOG_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void LOG_init(struct xt_entry_target *t)
 {
 	struct ip6t_log_info *loginfo =3D (struct ip6t_log_info *)t->data;
@@ -103,8 +101,6 @@ parse_level(const char *level)
 #define IP6T_LOG_OPT_IPOPT 0x10
 #define IP6T_LOG_OPT_UID 0x20
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int LOG_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_target **targe=
t)
 {
@@ -194,7 +190,6 @@ static int LOG_parse(int c, char **argv, int invert=
, unsigned int *flags,
 	return 1;
 }
=20
-/* Prints out the targinfo. */
 static void LOG_print(const void *ip, const struct xt_entry_target *ta=
rget,
                       int numeric)
 {
@@ -233,7 +228,6 @@ static void LOG_print(const void *ip, const struct =
xt_entry_target *target,
 		printf("prefix `%s' ", loginfo->prefix);
 }
=20
-/* Saves the union ip6t_targinfo in parsable form to stdout. */
 static void LOG_save(const void *ip, const struct xt_entry_target *tar=
get)
 {
 	const struct ip6t_log_info *loginfo
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index d4245e5..9144809 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -1,4 +1,4 @@
-/* Shared library add-on to iptables to add customized REJECT support.
+/* Shared library add-on to ip6tables to add customized REJECT support=
=2E
  *
  * (C) 2000 Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
  *=20
@@ -51,9 +51,6 @@ print_reject_types(void)
 	printf("\n");
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-
-/* Function which prints out usage message. */
 static void REJECT_help(void)
 {
 	printf(
@@ -69,7 +66,6 @@ static const struct option REJECT_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Allocate and initialize the target. */
 static void REJECT_init(struct xt_entry_target *t)
 {
 	struct ip6t_reject_info *reject =3D (struct ip6t_reject_info *)t->dat=
a;
@@ -79,8 +75,6 @@ static void REJECT_init(struct xt_entry_target *t)
=20
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int REJECT_parse(int c, char **argv, int invert, unsigned int *=
flags,
                         const void *entry, struct xt_entry_target **ta=
rget)
 {
@@ -109,7 +103,6 @@ static int REJECT_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 	return 0;
 }
=20
-/* Prints out ipt_reject_info. */
 static void REJECT_print(const void *ip, const struct xt_entry_target =
*target,
                          int numeric)
 {
@@ -124,7 +117,6 @@ static void REJECT_print(const void *ip, const stru=
ct xt_entry_target *target,
 	printf("reject-with %s ", reject_table[i].name);
 }
=20
-/* Saves ipt_reject in parsable form to stdout. */
 static void REJECT_save(const void *ip, const struct xt_entry_target *=
target)
 {
 	const struct ip6t_reject_info *reject
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 5483e30..96b07ef 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -7,8 +7,7 @@
 #include <errno.h>
 #include <ip6tables.h>
 #include <linux/netfilter_ipv6/ip6t_ah.h>
-                                       =20
-/* Function which prints out usage message. */
+
 static void ah_help(void)
 {
 	printf(
@@ -68,7 +67,6 @@ parse_ah_spis(const char *spistring, u_int32_t *spis)
 	free(buffer);
 }
=20
-/* Initialize the match. */
 static void ah_init(struct xt_entry_match *m)
 {
 	struct ip6t_ah *ahinfo =3D (struct ip6t_ah *)m->data;
@@ -78,8 +76,6 @@ static void ah_init(struct xt_entry_match *m)
 	ahinfo->hdrres =3D 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int ah_parse(int c, char **argv, int invert, unsigned int *flag=
s,
                     const void *entry, struct xt_entry_match **match)
 {
@@ -143,7 +139,6 @@ print_len(const char *name, u_int32_t len, int inve=
rt)
 		printf("%s:%s%u ", name, inv, len);
 }
=20
-/* Prints out the union ip6t_matchinfo. */
 static void ah_print(const void *ip, const struct xt_entry_match *matc=
h,
                      int numeric)
 {
@@ -163,7 +158,6 @@ static void ah_print(const void *ip, const struct x=
t_entry_match *match,
 		       ah->invflags & ~IP6T_AH_INV_MASK);
 }
=20
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void ah_save(const void *ip, const struct xt_entry_match *match=
)
 {
 	const struct ip6t_ah *ahinfo =3D (struct ip6t_ah *)match->data;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 8882b11..aff20b7 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -1,4 +1,4 @@
-/* Shared library add-on to ip6tables to add Hop-by-Hop and Dst header=
s support. */
+/* Shared library add-on to ip6tables to add Dst header support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -11,7 +11,6 @@
 #include <sys/socket.h>
 #include <arpa/inet.h>
=20
-/* Function which prints out usage message. */
 static void dst_help(void)
 {
 	printf(
@@ -107,7 +106,6 @@ parse_options(const char *optsstr, u_int16_t *opts)
 	return i;
 }
=20
-/* Initialize the match. */
 static void dst_init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo =3D (struct ip6t_opts *)m->data;
@@ -118,8 +116,6 @@ static void dst_init(struct xt_entry_match *m)
 	optinfo->optsnr =3D 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int dst_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_match **match)
 {
@@ -182,7 +178,6 @@ print_options(unsigned int optsnr, u_int16_t *optsp=
)
 	}
 }
=20
-/* Prints out the union ip6t_matchinfo. */
 static void dst_print(const void *ip, const struct xt_entry_match *mat=
ch,
                       int numeric)
 {
@@ -207,7 +202,6 @@ static void dst_print(const void *ip, const struct =
xt_entry_match *match,
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
 }
=20
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void dst_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct ip6t_opts *optinfo =3D (struct ip6t_opts *)match->data;
diff --git a/extensions/libip6t_eui64.c b/extensions/libip6t_eui64.c
index b93d121..8754b93 100644
--- a/extensions/libip6t_eui64.c
+++ b/extensions/libip6t_eui64.c
@@ -11,7 +11,6 @@
 #endif
 #include <ip6tables.h>
=20
-/* Function which prints out usage message. */
 static void eui64_help(void)
 {
 	printf(
@@ -20,8 +19,6 @@ static void eui64_help(void)
 " This module checks for EUI64 IPv6 addresses\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int eui64_parse(int c, char **argv, int invert, unsigned int *f=
lags,
                        const void *entry, struct xt_entry_match **matc=
h)
 {
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index 1dd48ba..b651a95 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -7,8 +7,7 @@
 #include <errno.h>
 #include <ip6tables.h>
 #include <linux/netfilter_ipv6/ip6t_frag.h>
-                                       =20
-/* Function which prints out usage message. */
+
 static void frag_help(void)
 {
 	printf(
@@ -74,7 +73,6 @@ parse_frag_ids(const char *idstring, u_int32_t *ids)
 	free(buffer);
 }
=20
-/* Initialize the match. */
 static void frag_init(struct xt_entry_match *m)
 {
 	struct ip6t_frag *fraginfo =3D (struct ip6t_frag *)m->data;
@@ -86,8 +84,6 @@ static void frag_init(struct xt_entry_match *m)
 	fraginfo->invflags =3D 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int frag_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *entry, struct xt_entry_match **match=
)
 {
@@ -166,7 +162,6 @@ print_ids(const char *name, u_int32_t min, u_int32_=
t max,
 	}
 }
=20
-/* Prints out the union ip6t_matchinfo. */
 static void frag_print(const void *ip, const struct xt_entry_match *ma=
tch,
                        int numeric)
 {
@@ -199,7 +194,6 @@ static void frag_print(const void *ip, const struct=
 xt_entry_match *match,
 		       frag->invflags & ~IP6T_FRAG_INV_MASK);
 }
=20
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void frag_save(const void *ip, const struct xt_entry_match *mat=
ch)
 {
 	const struct ip6t_frag *fraginfo =3D (struct ip6t_frag *)match->data;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 6492f9f..d981f66 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -1,4 +1,4 @@
-/* Shared library add-on to ip6tables to add Hop-by-Hop and Dst header=
s support. */
+/* Shared library add-on to ip6tables to add Hop-by-Hop header support=
=2E */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -11,10 +11,9 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
-                                       =20
+
 #define DEBUG		0
=20
-/* Function which prints out usage message. */
 static void hbh_help(void)
 {
 	printf(
@@ -102,7 +101,6 @@ parse_options(const char *optsstr, u_int16_t *opts)
 	return i;
 }
=20
-/* Initialize the match. */
 static void hbh_init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo =3D (struct ip6t_opts *)m->data;
@@ -113,8 +111,6 @@ static void hbh_init(struct xt_entry_match *m)
 	optinfo->optsnr =3D 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int hbh_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_match **match)
 {
@@ -175,7 +171,6 @@ print_options(unsigned int optsnr, u_int16_t *optsp=
)
 	}
 }
=20
-/* Prints out the union ip6t_matchinfo. */
 static void hbh_print(const void *ip, const struct xt_entry_match *mat=
ch,
                       int numeric)
 {
@@ -196,7 +191,6 @@ static void hbh_print(const void *ip, const struct =
xt_entry_match *match,
 		       optinfo->invflags & ~IP6T_OPTS_INV_MASK);
 }
=20
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void hbh_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct ip6t_opts *optinfo =3D (struct ip6t_opts *)match->data;
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index c29fe61..e60c5bd 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -1,4 +1,4 @@
-/* Shared library add-on to iptables to add ICMP support. */
+/* Shared library add-on to ip6tables to add ICMP support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
@@ -73,7 +73,6 @@ print_icmpv6types(void)
 	printf("\n");
 }
=20
-/* Function which prints out usage message. */
 static void icmp6_help(void)
 {
 	printf(
@@ -141,7 +140,6 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type=
, u_int8_t code[])
 	}
 }
=20
-/* Initialize the match. */
 static void icmp6_init(struct xt_entry_match *m)
 {
 	struct ip6t_icmp *icmpv6info =3D (struct ip6t_icmp *)m->data;
@@ -149,8 +147,6 @@ static void icmp6_init(struct xt_entry_match *m)
 	icmpv6info->code[1] =3D 0xFF;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int icmp6_parse(int c, char **argv, int invert, unsigned int *f=
lags,
                        const void *entry, struct xt_entry_match **matc=
h)
 {
@@ -213,7 +209,6 @@ static void print_icmpv6type(u_int8_t type,
 		printf(" codes %u-%u ", code_min, code_max);
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void icmp6_print(const void *ip, const struct xt_entry_match *m=
atch,
                         int numeric)
 {
@@ -229,7 +224,6 @@ static void icmp6_print(const void *ip, const struc=
t xt_entry_match *match,
 		       icmpv6->invflags & ~IP6T_ICMP_INV);
 }
=20
-/* Saves the match in parsable form to stdout. */
 static void icmp6_save(const void *ip, const struct xt_entry_match *ma=
tch)
 {
 	const struct ip6t_icmp *icmpv6 =3D (struct ip6t_icmp *)match->data;
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6h=
eader.c
index 547f966..a3cfc62 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -179,7 +179,6 @@ parse_header(const char *flags) {
 #define IPV6_HDR_HEADER	0x01
 #define IPV6_HDR_SOFT	0x02
=20
-/* Parses command options; returns 0 if it ate an option */
 static int
 ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
                  const void *entry, struct xt_entry_match **match)
@@ -218,7 +217,6 @@ ipv6header_parse(int c, char **argv, int invert, un=
signed int *flags,
 	return 1;
 }
=20
-/* Checks the flags variable */
 static void ipv6header_check(unsigned int flags)
 {
 	if (!flags) exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no option=
s specified");
@@ -246,7 +244,6 @@ print_header(u_int8_t flags){
                 printf("NONE");
 }
=20
-/* Prints out the match */
 static void ipv6header_print(const void *ip,
                              const struct xt_entry_match *match, int n=
umeric)
 {
@@ -269,7 +266,6 @@ static void ipv6header_print(const void *ip,
 	return;
 }
=20
-/* Saves the match */
 static void ipv6header_save(const void *ip, const struct xt_entry_matc=
h *match)
 {
=20
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 09dc5cc..2a64caa 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -1,5 +1,4 @@
-/* Shared library add-on to iptables to add policy support. */
-
+/* Shared library add-on to ip6tables to add policy support. */
 #include <stdio.h>
 #include <netdb.h>
 #include <string.h>
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 50c9444..207f515 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -11,10 +11,9 @@
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <arpa/inet.h>
-                                       =20
+
 /*#define DEBUG	1*/
=20
-/* Function which prints out usage message. */
 static void rt_help(void)
 {
 	printf(
@@ -136,7 +135,6 @@ parse_addresses(const char *addrstr, struct in6_add=
r *addrp)
 	return i;
 }
=20
-/* Initialize the match. */
 static void rt_init(struct xt_entry_match *m)
 {
 	struct ip6t_rt *rtinfo =3D (struct ip6t_rt *)m->data;
@@ -150,8 +148,6 @@ static void rt_init(struct xt_entry_match *m)
 	rtinfo->addrnr =3D 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int rt_parse(int c, char **argv, int invert, unsigned int *flag=
s,
                     const void *entry, struct xt_entry_match **match)
 {
@@ -264,7 +260,6 @@ print_addresses(unsigned int addrnr, struct in6_add=
r *addrp)
 	}
 }
=20
-/* Prints out the union ip6t_matchinfo. */
 static void rt_print(const void *ip, const struct xt_entry_match *matc=
h,
                      int numeric)
 {
@@ -291,7 +286,6 @@ static void rt_print(const void *ip, const struct x=
t_entry_match *match,
 		       rtinfo->invflags & ~IP6T_RT_INV_MASK);
 }
=20
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
 static void rt_save(const void *ip, const struct xt_entry_match *match=
)
 {
 	const struct ip6t_rt *rtinfo =3D (struct ip6t_rt *)match->data;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERI=
P.c
index 6a2c8da..e9789e9 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -192,9 +192,7 @@ static char *mac2str(const u_int8_t mac[ETH_ALEN])
 		mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
 	return buf;
 }
-		=09
=20
-/* Prints out the targinfo. */
 static void CLUSTERIP_print(const void *ip,
                             const struct xt_entry_target *target, int =
numeric)
 {
@@ -214,7 +212,6 @@ static void CLUSTERIP_print(const void *ip,
 		cipinfo->hash_initval);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void CLUSTERIP_save(const void *ip, const struct xt_entry_targe=
t *target)
 {
 	const struct ipt_clusterip_tgt_info *cipinfo =3D
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index fed7611..b5c6ff5 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -19,7 +19,6 @@ struct ipt_natinfo
 	struct ip_nat_multi_range mr;
 };
=20
-/* Function which prints out usage message. */
 static void DNAT_help(void)
 {
 	printf(
@@ -134,8 +133,6 @@ parse_to(char *arg, int portok, struct ipt_natinfo =
*info)
 	return &(append_range(info, &range)->t);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int DNAT_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *e, struct xt_entry_target **target)
 {
@@ -182,7 +179,6 @@ static int DNAT_parse(int c, char **argv, int inver=
t, unsigned int *flags,
 	}
 }
=20
-/* Final check; must have specfied --to-source. */
 static void DNAT_check(unsigned int flags)
 {
 	if (!flags)
@@ -210,7 +206,6 @@ static void print_range(const struct ip_nat_range *=
r)
 	}
 }
=20
-/* Prints out the targinfo. */
 static void DNAT_print(const void *ip, const struct xt_entry_target *t=
arget,
                        int numeric)
 {
@@ -226,7 +221,6 @@ static void DNAT_print(const void *ip, const struct=
 xt_entry_target *target,
 	}
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void DNAT_save(const void *ip, const struct xt_entry_target *ta=
rget)
 {
 	struct ipt_natinfo *info =3D (void *)target;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index 9526c37..0ef480b 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -104,7 +104,6 @@ static void ECN_check(unsigned int flags)
 		           "ECN target: Parameter --ecn-tcp-remove is required");
 }
=20
-/* Prints out the targinfo. */
 static void ECN_print(const void *ip, const struct xt_entry_target *ta=
rget,
                       int numeric)
 {
@@ -129,7 +128,6 @@ static void ECN_print(const void *ip, const struct =
xt_entry_target *target,
 	}
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void ECN_save(const void *ip, const struct xt_entry_target *tar=
get)
 {
 	const struct ipt_ECN_info *einfo =3D
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 50b1130..57c35b0 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -17,7 +17,6 @@
 #define IPT_LOG_MASK	0x0f
 #endif
=20
-/* Function which prints out usage message. */
 static void LOG_help(void)
 {
 	printf(
@@ -40,7 +39,6 @@ static const struct option LOG_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void LOG_init(struct xt_entry_target *t)
 {
 	struct ipt_log_info *loginfo =3D (struct ipt_log_info *)t->data;
@@ -103,8 +101,6 @@ parse_level(const char *level)
 #define IPT_LOG_OPT_IPOPT 0x10
 #define IPT_LOG_OPT_UID 0x20
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int LOG_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_target **targe=
t)
 {
@@ -194,7 +190,6 @@ static int LOG_parse(int c, char **argv, int invert=
, unsigned int *flags,
 	return 1;
 }
=20
-/* Prints out the targinfo. */
 static void LOG_print(const void *ip, const struct xt_entry_target *ta=
rget,
                       int numeric)
 {
@@ -233,7 +228,6 @@ static void LOG_print(const void *ip, const struct =
xt_entry_target *target,
 		printf("prefix `%s' ", loginfo->prefix);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void LOG_save(const void *ip, const struct xt_entry_target *tar=
get)
 {
 	const struct ipt_log_info *loginfo
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUER=
ADE.c
index ea4f5cd..7670765 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -8,7 +8,6 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter/nf_nat.h>
=20
-/* Function which prints out usage message. */
 static void MASQUERADE_help(void)
 {
 	printf(
@@ -25,7 +24,6 @@ static const struct option MASQUERADE_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void MASQUERADE_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr =3D (struct ip_nat_multi_range *)t->dat=
a;
@@ -69,8 +67,6 @@ parse_ports(const char *arg, struct ip_nat_multi_rang=
e *mr)
 	}
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int MASQUERADE_parse(int c, char **argv, int invert, unsigned i=
nt *flags,
                             const void *e, struct xt_entry_target **ta=
rget)
 {
@@ -108,7 +104,6 @@ static int MASQUERADE_parse(int c, char **argv, int=
 invert, unsigned int *flags,
 	}
 }
=20
-/* Prints out the targinfo. */
 static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
                  int numeric)
@@ -129,7 +124,6 @@ MASQUERADE_print(const void *ip, const struct xt_en=
try_target *target,
 		printf("random ");
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
 MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 {
diff --git a/extensions/libipt_MIRROR.c b/extensions/libipt_MIRROR.c
index cc1c7a4..0365f47 100644
--- a/extensions/libipt_MIRROR.c
+++ b/extensions/libipt_MIRROR.c
@@ -7,14 +7,11 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
=20
-/* Function which prints out usage message. */
 static void MIRROR_help(void)
 {
 	printf("MIRROR target takes no options\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int MIRROR_parse(int c, char **argv, int invert, unsigned int *=
flags,
                         const void *entry, struct xt_entry_target **ta=
rget)
 {
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 2a78696..3a5c613 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -18,7 +18,6 @@ static const struct option NETMAP_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Function which prints out usage message. */
 static void NETMAP_help(void)
 {
 	printf(MODULENAME" target options:\n"
@@ -53,7 +52,6 @@ netmask2bits(u_int32_t netmask)
 	return bits;
 }
=20
-/* Initialize the target. */
 static void NETMAP_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr =3D (struct ip_nat_multi_range *)t->dat=
a;
@@ -112,8 +110,6 @@ parse_to(char *arg, struct ip_nat_range *range)
 	range->max_ip =3D range->min_ip | ~netmask;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int NETMAP_parse(int c, char **argv, int invert, unsigned int *=
flags,
                         const void *entry, struct xt_entry_target **ta=
rget)
 {
@@ -135,7 +131,6 @@ static int NETMAP_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 	}
 }
=20
-/* Final check; need --to */
 static void NETMAP_check(unsigned int flags)
 {
 	if (!flags)
@@ -143,7 +138,6 @@ static void NETMAP_check(unsigned int flags)
 			   MODULENAME" needs --%s", NETMAP_opts[0].name);
 }
=20
-/* Prints out the targinfo. */
 static void NETMAP_print(const void *ip, const struct xt_entry_target =
*target,
                          int numeric)
 {
@@ -163,7 +157,6 @@ static void NETMAP_print(const void *ip, const stru=
ct xt_entry_target *target,
 		printf("/%d", bits);
 }
=20
-/* Saves the targinfo in parsable form to stdout. */
 static void NETMAP_save(const void *ip, const struct xt_entry_target *=
target)
 {
 	printf("--%s ", NETMAP_opts[0].name);
@@ -189,4 +182,3 @@ void _init(void)
 {
 	xtables_register_target(&netmap_tg_reg);
 }
-
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.=
c
index c03562b..ffef3bf 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -11,7 +11,6 @@
 #define IPT_REDIRECT_OPT_DEST	0x01
 #define IPT_REDIRECT_OPT_RANDOM	0x02
=20
-/* Function which prints out usage message. */
 static void REDIRECT_help(void)
 {
 	printf(
@@ -26,7 +25,6 @@ static const struct option REDIRECT_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void REDIRECT_init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr =3D (struct ip_nat_multi_range *)t->dat=
a;
@@ -76,8 +74,6 @@ parse_ports(const char *arg, struct ip_nat_multi_rang=
e *mr)
 	}
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int REDIRECT_parse(int c, char **argv, int invert, unsigned int=
 *flags,
                           const void *e, struct xt_entry_target **targ=
et)
 {
@@ -122,7 +118,6 @@ static int REDIRECT_parse(int c, char **argv, int i=
nvert, unsigned int *flags,
 	}
 }
=20
-/* Prints out the targinfo. */
 static void REDIRECT_print(const void *ip, const struct xt_entry_targe=
t *target,
                            int numeric)
 {
@@ -141,7 +136,6 @@ static void REDIRECT_print(const void *ip, const st=
ruct xt_entry_target *target,
 	}
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void REDIRECT_save(const void *ip, const struct xt_entry_target=
 *target)
 {
 	struct ip_nat_multi_range *mr
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index fd272c4..5f9407c 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -64,9 +64,6 @@ print_reject_types(void)
 	printf("\n");
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
-
-/* Function which prints out usage message. */
 static void REJECT_help(void)
 {
 	printf(
@@ -84,7 +81,6 @@ static const struct option REJECT_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Allocate and initialize the target. */
 static void REJECT_init(struct xt_entry_target *t)
 {
 	struct ipt_reject_info *reject =3D (struct ipt_reject_info *)t->data;
@@ -94,8 +90,6 @@ static void REJECT_init(struct xt_entry_target *t)
=20
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int REJECT_parse(int c, char **argv, int invert, unsigned int *=
flags,
                         const void *entry, struct xt_entry_target **ta=
rget)
 {
@@ -128,7 +122,6 @@ static int REJECT_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 	return 0;
 }
=20
-/* Prints out ipt_reject_info. */
 static void REJECT_print(const void *ip, const struct xt_entry_target =
*target,
                          int numeric)
 {
@@ -143,7 +136,6 @@ static void REJECT_print(const void *ip, const stru=
ct xt_entry_target *target,
 	printf("reject-with %s ", reject_table[i].name);
 }
=20
-/* Saves ipt_reject in parsable form to stdout. */
 static void REJECT_save(const void *ip, const struct xt_entry_target *=
target)
 {
 	const struct ipt_reject_info *reject
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index c0aef9f..baf5fee 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -10,7 +10,6 @@
 /* For 64bit kernel / 32bit userspace */
 #include <linux/netfilter_ipv4/ipt_SAME.h>
=20
-/* Function which prints out usage message. */
 static void SAME_help(void)
 {
 	printf(
@@ -33,7 +32,6 @@ static const struct option SAME_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void SAME_init(struct xt_entry_target *t)
 {
 	struct ipt_same_info *mr =3D (struct ipt_same_info *)t->data;
@@ -81,8 +79,6 @@ parse_to(char *arg, struct ip_nat_range *range)
 #define IPT_SAME_OPT_NODST		0x02
 #define IPT_SAME_OPT_RANDOM		0x04
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int SAME_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *entry, struct xt_entry_target **targ=
et)
 {
@@ -132,7 +128,6 @@ static int SAME_parse(int c, char **argv, int inver=
t, unsigned int *flags,
 	return 1;
 }
=20
-/* Final check; need --to. */
 static void SAME_check(unsigned int flags)
 {
 	if (!(flags & IPT_SAME_OPT_TO))
@@ -140,7 +135,6 @@ static void SAME_check(unsigned int flags)
 			   "SAME needs --to");
 }
=20
-/* Prints out the targinfo. */
 static void SAME_print(const void *ip, const struct xt_entry_target *t=
arget,
                        int numeric)
 {
@@ -175,7 +169,6 @@ static void SAME_print(const void *ip, const struct=
 xt_entry_target *target,
 		printf("random ");
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SAME_save(const void *ip, const struct xt_entry_target *ta=
rget)
 {
 	unsigned int count;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 62d959f..fa81571 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -22,7 +22,6 @@
 #include <linux/netfilter_ipv4/ipt_set.h>
 #include "libipt_set.h"
=20
-/* Function which prints out usage message. */
 static void SET_help(void)
 {
 	printf("SET target options:\n"
@@ -39,7 +38,6 @@ static const struct option SET_opts[] =3D {
 	{ }
 };
=20
-/* Initialize the target. */
 static void SET_init(struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =3D
@@ -80,8 +78,6 @@ parse_target(char **argv, int invert, unsigned int *f=
lags,
 	*flags =3D 1;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int SET_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_target **targe=
t)
 {
@@ -104,7 +100,6 @@ static int SET_parse(int c, char **argv, int invert=
, unsigned int *flags,
 	return 1;
 }
=20
-/* Final check; must specify at least one. */
 static void SET_check(unsigned int flags)
 {
 	if (!flags)
@@ -132,7 +127,6 @@ print_target(const char *prefix, const struct ipt_s=
et_info *info)
 	printf(" ");
 }
=20
-/* Prints out the targinfo. */
 static void SET_print(const void *ip, const struct xt_entry_target *ta=
rget,
                       int numeric)
 {
@@ -143,7 +137,6 @@ static void SET_print(const void *ip, const struct =
xt_entry_target *target,
 	print_target("del-set", &info->del_set);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SET_save(const void *ip, const struct xt_entry_target *tar=
get)
 {
 	struct ipt_set_info_target *info =3D
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 11536c6..b2a4925 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -19,7 +19,6 @@ struct ipt_natinfo
 	struct ip_nat_multi_range mr;
 };
=20
-/* Function which prints out usage message. */
 static void SNAT_help(void)
 {
 	printf(
@@ -134,8 +133,6 @@ parse_to(char *arg, int portok, struct ipt_natinfo =
*info)
 	return &(append_range(info, &range)->t);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int SNAT_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *e, struct xt_entry_target **target)
 {
@@ -183,7 +180,6 @@ static int SNAT_parse(int c, char **argv, int inver=
t, unsigned int *flags,
 	}
 }
=20
-/* Final check; must have specfied --to-source. */
 static void SNAT_check(unsigned int flags)
 {
 	if (!(flags & IPT_SNAT_OPT_SOURCE))
@@ -211,7 +207,6 @@ static void print_range(const struct ip_nat_range *=
r)
 	}
 }
=20
-/* Prints out the targinfo. */
 static void SNAT_print(const void *ip, const struct xt_entry_target *t=
arget,
                        int numeric)
 {
@@ -227,7 +222,6 @@ static void SNAT_print(const void *ip, const struct=
 xt_entry_target *target,
 	}
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SNAT_save(const void *ip, const struct xt_entry_target *ta=
rget)
 {
 	struct ipt_natinfo *info =3D (void *)target;
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 33c26ec..bec693d 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -33,7 +33,6 @@ static void print_groups(unsigned int gmask)
 	}
 }
=20
-/* Function which prints out usage message. */
 static void ULOG_help(void)
 {
 	printf("ULOG target options:\n"
@@ -51,7 +50,6 @@ static const struct option ULOG_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Initialize the target. */
 static void ULOG_init(struct xt_entry_target *t)
 {
 	struct ipt_ulog_info *loginfo =3D (struct ipt_ulog_info *) t->data;
@@ -66,8 +64,6 @@ static void ULOG_init(struct xt_entry_target *t)
 #define IPT_LOG_OPT_CPRANGE 0x04
 #define IPT_LOG_OPT_QTHRESHOLD 0x08
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int ULOG_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *entry, struct xt_entry_target **targ=
et)
 {
@@ -148,7 +144,6 @@ static int ULOG_parse(int c, char **argv, int inver=
t, unsigned int *flags,
 	return 1;
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void ULOG_save(const void *ip, const struct xt_entry_target *ta=
rget)
 {
 	const struct ipt_ulog_info *loginfo
@@ -170,7 +165,6 @@ static void ULOG_save(const void *ip, const struct =
xt_entry_target *target)
 		printf("--ulog-qthreshold %u ", (unsigned int)loginfo->qthreshold);
 }
=20
-/* Prints out the targinfo. */
 static void ULOG_print(const void *ip, const struct xt_entry_target *t=
arget,
                        int numeric)
 {
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 386c43f..1f4f397 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -7,8 +7,7 @@
 #include <errno.h>
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_ah.h>
-                                       =20
-/* Function which prints out usage message. */
+
 static void ah_help(void)
 {
 	printf(
@@ -64,7 +63,6 @@ parse_ah_spis(const char *spistring, u_int32_t *spis)
 	free(buffer);
 }
=20
-/* Initialize the match. */
 static void ah_init(struct xt_entry_match *m)
 {
 	struct ipt_ah *ahinfo =3D (struct ipt_ah *)m->data;
@@ -74,8 +72,6 @@ static void ah_init(struct xt_entry_match *m)
=20
 #define AH_SPI 0x01
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int ah_parse(int c, char **argv, int invert, unsigned int *flag=
s,
                     const void *entry, struct xt_entry_match **match)
 {
@@ -120,7 +116,6 @@ print_spis(const char *name, u_int32_t min, u_int32=
_t max,
 	}
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void ah_print(const void *ip, const struct xt_entry_match *matc=
h,
                      int numeric)
 {
@@ -134,7 +129,6 @@ static void ah_print(const void *ip, const struct x=
t_entry_match *match,
 		       ah->invflags & ~IPT_AH_INV_MASK);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void ah_save(const void *ip, const struct xt_entry_match *match=
)
 {
 	const struct ipt_ah *ahinfo =3D (struct ipt_ah *)match->data;
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 0621453..4dfaac9 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -90,7 +90,6 @@ static void ecn_check(unsigned int flags)
 		           "ECN match: some option required");
 }
=20
-/* Prints out the matchinfo. */
 static void ecn_print(const void *ip, const struct xt_entry_match *mat=
ch,
                       int numeric)
 {
@@ -118,7 +117,6 @@ static void ecn_print(const void *ip, const struct =
xt_entry_match *match,
 	}
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void ecn_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct ipt_ecn_info *einfo =3D
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index f57503a..8faf66f 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -97,7 +97,6 @@ print_icmptypes(void)
 	printf("\n");
 }
=20
-/* Function which prints out usage message. */
 static void icmp_help(void)
 {
 	printf(
@@ -165,7 +164,6 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_=
int8_t code[])
 	}
 }
=20
-/* Initialize the match. */
 static void icmp_init(struct xt_entry_match *m)
 {
 	struct ipt_icmp *icmpinfo =3D (struct ipt_icmp *)m->data;
@@ -174,8 +172,6 @@ static void icmp_init(struct xt_entry_match *m)
 	icmpinfo->code[1] =3D 0xFF;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int icmp_parse(int c, char **argv, int invert, unsigned int *fl=
ags,
                       const void *entry, struct xt_entry_match **match=
)
 {
@@ -238,7 +234,6 @@ static void print_icmptype(u_int8_t type,
 		printf(" codes %u-%u ", code_min, code_max);
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void icmp_print(const void *ip, const struct xt_entry_match *ma=
tch,
                        int numeric)
 {
@@ -254,7 +249,6 @@ static void icmp_print(const void *ip, const struct=
 xt_entry_match *match,
 		       icmp->invflags & ~IPT_ICMP_INV);
 }
=20
-/* Saves the match in parsable form to stdout. */
 static void icmp_save(const void *ip, const struct xt_entry_match *mat=
ch)
 {
 	const struct ipt_icmp *icmp =3D (struct ipt_icmp *)match->data;
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 1e7f690..ba89abf 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -14,7 +14,6 @@
 #include <iptables.h>
 #include <linux/netfilter_ipv4/ipt_realm.h>
=20
-/* Function which prints out usage message. */
 static void realm_help(void)
 {
 	printf(
@@ -149,9 +148,6 @@ static const char *realm_id2name(int id)
 	return NULL;
 }
=20
-
-/* Function which parses command options; returns true if it
-   ate an option */
 static int realm_parse(int c, char **argv, int invert, unsigned int *f=
lags,
                        const void *entry, struct xt_entry_match **matc=
h)
 {
@@ -208,7 +204,6 @@ print_realm(unsigned long id, unsigned long mask, i=
nt numeric)
 	}
 }
=20
-/* Prints out the matchinfo. */
 static void realm_print(const void *ip, const struct xt_entry_match *m=
atch,
                         int numeric)
 {
@@ -221,8 +216,6 @@ static void realm_print(const void *ip, const struc=
t xt_entry_match *match,
 	print_realm(ri->id, ri->mask, numeric);
 }
=20
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void realm_save(const void *ip, const struct xt_entry_match *ma=
tch)
 {
 	struct ipt_realm_info *ri =3D (struct ipt_realm_info *) match->data;
@@ -234,7 +227,6 @@ static void realm_save(const void *ip, const struct=
 xt_entry_match *match)
 	print_realm(ri->id, ri->mask, 0);
 }
=20
-/* Final check; must have specified --mark. */
 static void realm_check(unsigned int flags)
 {
 	if (!flags)
@@ -260,5 +252,3 @@ void _init(void)
 {
 	xtables_register_match(&realm_mt_reg);
 }
-
-
diff --git a/extensions/libipt_recent.c b/extensions/libipt_recent.c
index 108de2f..94f246a 100644
--- a/extensions/libipt_recent.c
+++ b/extensions/libipt_recent.c
@@ -21,7 +21,6 @@
 #define IPT_RECENT_NAME_LEN	200
 #endif /* IPT_RECENT_NAME_LEN */
=20
-/* Options for this module */
 static const struct option recent_opts[] =3D {
 	{ .name =3D "set",      .has_arg =3D 0, .val =3D 201 },=20
 	{ .name =3D "rcheck",   .has_arg =3D 0, .val =3D 202 },=20
@@ -36,7 +35,6 @@ static const struct option recent_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Function which prints out usage message. */
 static void recent_help(void)
 {
 	printf(
@@ -61,8 +59,7 @@ static void recent_help(void)
 "    --rdest                     Match/Save the destination address of=
 each packet in the recent list table.\n"
 RECENT_NAME " " RECENT_VER ": Stephen Frost <sfrost@snowman.net>.  htt=
p://snowman.net/projects/ipt_recent/\n");
 }
- =20
-/* Initialize the match. */
+
 static void recent_init(struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info =3D (struct ipt_recent_info *)(match)->d=
ata;
@@ -79,8 +76,6 @@ static void recent_init(struct xt_entry_match *match)
 	(IPT_RECENT_SET | IPT_RECENT_CHECK | \
 	IPT_RECENT_UPDATE | IPT_RECENT_REMOVE)
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int recent_parse(int c, char **argv, int invert, unsigned int *=
flags,
                         const void *entry, struct xt_entry_match **mat=
ch)
 {
@@ -163,7 +158,6 @@ static int recent_parse(int c, char **argv, int inv=
ert, unsigned int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified a specific option. */
 static void recent_check(unsigned int flags)
 {
 	if (!(flags & RECENT_CMDS))
@@ -177,7 +171,6 @@ static void recent_check(unsigned int flags)
 		           "--update");
 }
=20
-/* Prints out the matchinfo. */
 static void recent_print(const void *ip, const struct xt_entry_match *=
match,
                          int numeric)
 {
@@ -199,7 +192,6 @@ static void recent_print(const void *ip, const stru=
ct xt_entry_match *match,
 	if(info->side =3D=3D IPT_RECENT_DEST) printf("side: dest");
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void recent_save(const void *ip, const struct xt_entry_match *m=
atch)
 {
 	struct ipt_recent_info *info =3D (struct ipt_recent_info *)match->dat=
a;
@@ -219,7 +211,6 @@ static void recent_save(const void *ip, const struc=
t xt_entry_match *match)
 	if(info->side =3D=3D IPT_RECENT_DEST) printf("--rdest ");
 }
=20
-/* Structure for iptables to use to communicate with module */
 static struct xtables_match recent_mt_reg =3D {
     .name          =3D "recent",
     .version       =3D XTABLES_VERSION,
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 759bca3..1bacdda 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -21,7 +21,6 @@
 #include <linux/netfilter_ipv4/ipt_set.h>
 #include "libipt_set.h"
=20
-/* Function which prints out usage message. */
 static void set_help(void)
 {
 	printf("set match options:\n"
@@ -36,7 +35,6 @@ static const struct option set_opts[] =3D {
 	{ }
 };
=20
-/* Initialize the match. */
 static void set_init(struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info =3D=20
@@ -47,7 +45,6 @@ static void set_init(struct xt_entry_match *match)
=20
 }
=20
-/* Function which parses command options; returns true if it ate an op=
tion */
 static int set_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
                      const void *entry, struct xt_entry_match **match)
 {
@@ -91,7 +88,6 @@ static int set_parse(int c, char **argv, int invert, =
unsigned int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --set. */
 static void set_check(unsigned int flags)
 {
 	if (!flags)
@@ -131,7 +127,6 @@ static void set_print(const void *ip, const struct =
xt_entry_match *match,
 	print_match("set", &info->match_set);
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void set_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	struct ipt_set_info_match *info =3D=20
diff --git a/extensions/libipt_unclean.c b/extensions/libipt_unclean.c
index 4bdbd1b..968e034 100644
--- a/extensions/libipt_unclean.c
+++ b/extensions/libipt_unclean.c
@@ -4,14 +4,11 @@
 #include <getopt.h>
 #include <iptables.h>
=20
-/* Function which prints out usage message. */
 static void unclean_help(void)
 {
 	printf("unclean match takes no options\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int unclean_parse(int c, char **argv, int invert, unsigned int =
*flags,
                          const void *entry, struct xt_entry_match **ma=
tch)
 {
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 79dd16c..113f680 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -10,7 +10,6 @@
 #include <linux/types.h>
 #include <linux/pkt_sched.h>
=20
-/* Function which prints out usage message. */
 static void
 CLASSIFY_help(void)
 {
@@ -35,8 +34,6 @@ static int CLASSIFY_string_to_priority(const char *s,=
 unsigned int *p)
 	return 0;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
@@ -77,7 +74,6 @@ CLASSIFY_print_class(unsigned int priority, int numer=
ic)
 	printf("%x:%x ", TC_H_MAJ(priority)>>16, TC_H_MIN(priority));
 }
=20
-/* Prints out the targinfo. */
 static void
 CLASSIFY_print(const void *ip,
       const struct xt_entry_target *target,
@@ -89,7 +85,6 @@ CLASSIFY_print(const void *ip,
 	CLASSIFY_print_class(clinfo->priority, numeric);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void
 CLASSIFY_save(const void *ip, const struct xt_entry_target *target)
 {
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 27640f5..9f83111 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -33,7 +33,6 @@ enum {
 	F_SR_MARK =3D 1 << 1,
 };
=20
-/* Function which prints out usage message. */
 static void CONNMARK_help(void)
 {
 	printf(
@@ -95,8 +94,6 @@ static void connmark_tg_init(struct xt_entry_target *=
target)
 	info->nfmask =3D ~0U;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
                const void *entry, struct xt_entry_target **target)
@@ -273,8 +270,6 @@ print_mask(const char *text, unsigned long mask)
 		printf("%s0x%lx", text, mask);
 }
=20
-
-/* Prints out the target info. */
 static void CONNMARK_print(const void *ip,
                            const struct xt_entry_target *target, int n=
umeric)
 {
@@ -346,7 +341,6 @@ connmark_tg_print(const void *ip, const struct xt_e=
ntry_target *target,
 	}
 }
=20
-/* Saves the target into in parsable form to stdout. */
 static void CONNMARK_save(const void *ip, const struct xt_entry_target=
 *target)
 {
 	const struct xt_connmark_target_info *markinfo =3D
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index e9369ab..17bad16 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -113,7 +113,6 @@ print_dscp(u_int8_t dscp, int numeric)
  	printf("0x%02x ", dscp);
 }
=20
-/* Prints out the targinfo. */
 static void DSCP_print(const void *ip, const struct xt_entry_target *t=
arget,
                        int numeric)
 {
@@ -123,7 +122,6 @@ static void DSCP_print(const void *ip, const struct=
 xt_entry_target *target,
 	print_dscp(dinfo->dscp, numeric);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void DSCP_save(const void *ip, const struct xt_entry_target *ta=
rget)
 {
 	const struct xt_DSCP_info *dinfo =3D
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 5b880ce..8184976 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -13,7 +13,6 @@ enum {
 	F_MARK =3D 1 << 0,
 };
=20
-/* Function which prints out usage message. */
 static void MARK_help(void)
 {
 	printf(
@@ -91,8 +90,6 @@ static void MARK_check(unsigned int flags)
 			   " is required");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
@@ -199,7 +196,6 @@ print_mark(unsigned long mark)
 	printf("0x%lx ", mark);
 }
=20
-/* Prints out the targinfo. */
 static void MARK_print_v0(const void *ip,
                           const struct xt_entry_target *target, int nu=
meric)
 {
@@ -209,7 +205,6 @@ static void MARK_print_v0(const void *ip,
 	print_mark(markinfo->mark);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void MARK_save_v0(const void *ip, const struct xt_entry_target =
*target)
 {
 	const struct xt_mark_target_info *markinfo =3D
@@ -219,7 +214,6 @@ static void MARK_save_v0(const void *ip, const stru=
ct xt_entry_target *target)
 	print_mark(markinfo->mark);
 }
=20
-/* Prints out the targinfo. */
 static void MARK_print_v1(const void *ip, const struct xt_entry_target=
 *target,
                           int numeric)
 {
@@ -255,7 +249,6 @@ static void mark_tg_print(const void *ip, const str=
uct xt_entry_target *target,
 		printf("MARK xset 0x%x/0x%x ", info->mark, info->mask);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void MARK_save_v1(const void *ip, const struct xt_entry_target =
*target)
 {
 	const struct xt_mark_target_info_v1 *markinfo =3D
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 49d0ebc..d0b171a 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -62,7 +62,6 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigne=
d int *flags,
 	return 1;
 }
=20
-/* Prints out the targinfo. */
 static void NFQUEUE_print(const void *ip,
                           const struct xt_entry_target *target, int nu=
meric)
 {
@@ -71,7 +70,6 @@ static void NFQUEUE_print(const void *ip,
 	printf("NFQUEUE num %u", tinfo->queuenum);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void NFQUEUE_save(const void *ip, const struct xt_entry_target =
*target)
 {
 	const struct xt_NFQ_info *tinfo =3D
diff --git a/extensions/libxt_NOTRACK.c b/extensions/libxt_NOTRACK.c
index 83ad817..ab54b47 100644
--- a/extensions/libxt_NOTRACK.c
+++ b/extensions/libxt_NOTRACK.c
@@ -7,14 +7,11 @@
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
=20
-/* Function which prints out usage message. */
 static void NOTRACK_help(void)
 {
 	printf("NOTRACK target takes no options\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 NOTRACK_parse(int c, char **argv, int invert, unsigned int *flags,
               const void *entry, struct xt_entry_target **target)
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 7d3dbfa..c62fb44 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -26,10 +26,6 @@ static const struct option SECMARK_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/*
- * Function which parses command options; returns true if it
- * ate an option.
- */
 static int SECMARK_parse(int c, char **argv, int invert, unsigned int =
*flags,
                          const void *entry, struct xt_entry_target **t=
arget)
 {
@@ -87,7 +83,6 @@ static void SECMARK_print(const void *ip, const struc=
t xt_entry_target *target,
 	print_secmark(info);
 }
=20
-/* Saves the target info in parsable form to stdout. */
 static void SECMARK_save(const void *ip, const struct xt_entry_target =
*target)
 {
 	struct xt_secmark_target_info *info =3D
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index fbf73c9..bffd260 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -16,7 +16,6 @@ struct mssinfo {
 	struct xt_tcpmss_info mss;
 };
=20
-/* Function which prints out usage message. */
 static void __TCPMSS_help(int hdrsize)
 {
 	printf(
@@ -42,8 +41,6 @@ static const struct option TCPMSS_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int=
 *flags,
                           const void *entry, struct xt_entry_target **=
target,
                           int hdrsize)
@@ -99,7 +96,6 @@ static void TCPMSS_check(unsigned int flags)
 		           "TCPMSS target: At least one parameter is required");
 }
=20
-/* Prints out the targinfo. */
 static void TCPMSS_print(const void *ip, const struct xt_entry_target =
*target,
                          int numeric)
 {
@@ -111,7 +107,6 @@ static void TCPMSS_print(const void *ip, const stru=
ct xt_entry_target *target,
 		printf("TCPMSS set %u ", mssinfo->mss);
 }
=20
-/* Saves the union ipt_targinfo in parsable form to stdout. */
 static void TCPMSS_save(const void *ip, const struct xt_entry_target *=
target)
 {
 	const struct xt_tcpmss_info *mssinfo =3D
diff --git a/extensions/libxt_TRACE.c b/extensions/libxt_TRACE.c
index 4b0bac8..b8eb969 100644
--- a/extensions/libxt_TRACE.c
+++ b/extensions/libxt_TRACE.c
@@ -7,14 +7,11 @@
 #include <xtables.h>
 #include <linux/netfilter/x_tables.h>
=20
-/* Function which prints out usage message. */
 static void TRACE_help(void)
 {
 	printf("TRACE target takes no options\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int TRACE_parse(int c, char **argv, int invert, unsigned int *f=
lags,
                        const void *entry, struct xt_entry_target **tar=
get)
 {
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index abbb6cb..b02f09b 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -14,7 +14,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_comment.h>
=20
-/* Function which prints out usage message. */
 static void comment_help(void)
 {
 	printf(
@@ -39,8 +38,6 @@ parse_comment(const char *s, struct xt_comment_info *=
info)
 	strcpy((char *)info->comment, s);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 comment_parse(int c, char **argv, int invert, unsigned int *flags,
               const void *entry, struct xt_entry_match **match)
@@ -64,7 +61,6 @@ comment_parse(int c, char **argv, int invert, unsigne=
d int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --comment. */
 static void comment_check(unsigned int flags)
 {
 	if (!flags)
@@ -72,7 +68,6 @@ static void comment_check(unsigned int flags)
 			   "COMMENT match: You must specify `--comment'");
 }
=20
-/* Prints out the matchinfo. */
 static void
 comment_print(const void *ip, const struct xt_entry_match *match, int =
numeric)
 {
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.=
c
index 64faa8f..0867091 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -8,7 +8,6 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <linux/netfilter/xt_connbytes.h>
=20
-/* Function which prints out usage message. */
 static void connbytes_help(void)
 {
 	printf(
@@ -44,8 +43,6 @@ parse_range(const char *arg, struct xt_connbytes_info=
 *si)
 			   (unsigned long long)si->count.to);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
@@ -141,7 +138,6 @@ static void print_direction(struct xt_connbytes_inf=
o *sinfo)
 	}
 }
=20
-/* Prints out the matchinfo. */
 static void
 connbytes_print(const void *ip, const struct xt_entry_match *match, in=
t numeric)
 {
@@ -163,7 +159,6 @@ connbytes_print(const void *ip, const struct xt_ent=
ry_match *match, int numeric)
 	print_direction(sinfo);
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void connbytes_save(const void *ip, const struct xt_entry_match=
 *match)
 {
 	struct xt_connbytes_info *sinfo =3D (struct xt_connbytes_info *)match=
->data;
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index eb4060e..2358f68 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -73,8 +73,6 @@ connmark_mt_parse(int c, char **argv, int invert, uns=
igned int *flags,
 	return false;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 connmark_parse(int c, char **argv, int invert, unsigned int *flags,
                const void *entry, struct xt_entry_match **match)
@@ -120,7 +118,6 @@ static void connmark_mt_check(unsigned int flags)
 		           "connmark: The --mark option is required");
 }
=20
-/* Prints out the matchinfo. */
 static void
 connmark_print(const void *ip, const struct xt_entry_match *match, int=
 numeric)
 {
@@ -143,7 +140,6 @@ connmark_mt_print(const void *ip, const struct xt_e=
ntry_match *match, int numeri
 	print_mark(info->mark, info->mask);
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void connmark_save(const void *ip, const struct xt_entry_match =
*match)
 {
 	struct xt_connmark_info *info =3D (struct xt_connmark_info *)match->d=
ata;
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.=
c
index 1d339a0..79ed3b8 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -22,7 +22,6 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <arpa/inet.h>
=20
-/* Function which prints out usage message. */
 static void conntrack_mt_help(void)
 {
 	printf(
@@ -285,8 +284,6 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *i=
nfo, const char *s)
 	info->expires_max =3D max;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int conntrack_parse(int c, char **argv, int invert, unsigned in=
t *flags,
                            const void *entry, struct xt_entry_match **=
match)
 {
@@ -792,7 +789,6 @@ print_addr(struct in_addr *addr, struct in_addr *ma=
sk, int inv, int numeric)
 	}
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void
 matchinfo_print(const void *ip, const struct xt_entry_match *match, in=
t numeric, const char *optpfx)
 {
@@ -976,7 +972,6 @@ conntrack_dump(const struct xt_conntrack_mtinfo1 *i=
nfo, const char *prefix,
 	}
 }
=20
-/* Prints out the matchinfo. */
 static void conntrack_print(const void *ip, const struct xt_entry_matc=
h *match,
                             int numeric)
 {
@@ -997,7 +992,6 @@ conntrack_mt6_print(const void *ip, const struct xt=
_entry_match *match,
 	conntrack_dump((const void *)match->data, "", AF_INET6, numeric);
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void conntrack_save(const void *ip, const struct xt_entry_match=
 *match)
 {
 	matchinfo_print(ip, match, 1, "--");
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 8aa3d06..e1d6457 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -24,7 +24,6 @@
 #define DEBUGP(format, fist...)=20
 #endif
=20
-/* Initialize the match. */
 static void dccp_init(struct xt_entry_match *m)
 {
 	struct xt_dccp_info *einfo =3D (struct xt_dccp_info *)m->data;
@@ -266,7 +265,6 @@ print_option(u_int8_t option, int invert, int numer=
ic)
 		printf("option=3D%s%u ", invert ? "!" : "", option);
 }
=20
-/* Prints out the matchinfo. */
 static void
 dccp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
 {
@@ -299,7 +297,6 @@ dccp_print(const void *ip, const struct xt_entry_ma=
tch *match, int numeric)
 	}
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void dccp_save(const void *ip, const struct xt_entry_match *mat=
ch)
 {
 	const struct xt_dccp_info *einfo =3D
@@ -370,4 +367,3 @@ void _init(void)
 	xtables_register_match(&dccp_match);
 	xtables_register_match(&dccp_match6);
 }
-
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 3551978..42ca71d 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -124,7 +124,6 @@ print_dscp(u_int8_t dscp, int invert, int numeric)
  	printf("0x%02x ", dscp);
 }
=20
-/* Prints out the matchinfo. */
 static void
 dscp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
 {
@@ -134,7 +133,6 @@ dscp_print(const void *ip, const struct xt_entry_ma=
tch *match, int numeric)
 	print_dscp(dinfo->dscp, dinfo->invert, numeric);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void dscp_save(const void *ip, const struct xt_entry_match *mat=
ch)
 {
 	const struct xt_dscp_info *dinfo =3D
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 1da8245..544d7b3 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -8,7 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_esp.h>
=20
-/* Function which prints out usage message. */
 static void esp_help(void)
 {
 	printf(
@@ -67,7 +66,6 @@ parse_esp_spis(const char *spistring, u_int32_t *spis=
)
 	free(buffer);
 }
=20
-/* Initialize the match. */
 static void esp_init(struct xt_entry_match *m)
 {
 	struct xt_esp *espinfo =3D (struct xt_esp *)m->data;
@@ -77,8 +75,6 @@ static void esp_init(struct xt_entry_match *m)
=20
 #define ESP_SPI 0x01
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 esp_parse(int c, char **argv, int invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
@@ -117,7 +113,6 @@ print_spis(const char *name, u_int32_t min, u_int32=
_t max,
 	}
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void
 esp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
 {
@@ -131,7 +126,6 @@ esp_print(const void *ip, const struct xt_entry_mat=
ch *match, int numeric)
 		       esp->invflags & ~XT_ESP_INV_MASK);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void esp_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct xt_esp *espinfo =3D (struct xt_esp *)match->data;
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.=
c
index da9b05f..3960417 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -5,8 +5,8 @@
  * Development of this code was funded by Astaro AG, http://www.astaro=
=2Ecom/
  *
  * Based on ipt_limit.c by
- * J??e de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv?Eychenne    <rv@wallfire.org>
+ * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
+ * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  *=20
  * Error corections by nmalykh@bilim.com (22.01.2005)
  */
@@ -27,7 +27,6 @@
 #define XT_HASHLIMIT_GCINTERVAL	1000
 #define XT_HASHLIMIT_EXPIRE	10000
=20
-/* Function which prints out usage message. */
 static void hashlimit_help(void)
 {
 	printf(
@@ -131,7 +130,6 @@ int parse_rate(const char *rate, u_int32_t *val)
 	return 1;
 }
=20
-/* Initialize the match. */
 static void hashlimit_init(struct xt_entry_match *m)
 {
 	struct xt_hashlimit_info *r =3D (struct xt_hashlimit_info *)m->data;
@@ -209,8 +207,6 @@ enum {
 	PARAM_DSTMASK    =3D 1 << 9,
 };
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
@@ -453,7 +449,6 @@ hashlimit_mt6_parse(int c, char **argv, int invert,=
 unsigned int *flags,
 	       flags, c, invert, 128);
 }
=20
-/* Final check; nothing. */
 static void hashlimit_check(unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
@@ -527,7 +522,6 @@ static void print_mode(unsigned int mode, char sepa=
rator)
 	putchar(' ');
 }
=20
-/* Prints out the matchinfo. */
 static void hashlimit_print(const void *ip,
                             const struct xt_entry_match *match, int nu=
meric)
 {
@@ -594,7 +588,6 @@ hashlimit_mt6_print(const void *ip, const struct xt=
_entry_match *match,
 	hashlimit_mt_print(info, 128);
 }
=20
-/* FIXME: Make minimalist: only print rate if not default --RR */
 static void hashlimit_save(const void *ip, const struct xt_entry_match=
 *match)
 {
 	struct xt_hashlimit_info *r =3D=20
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index ba0b996..e8f1635 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -8,7 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_helper.h>
=20
-/* Function which prints out usage message. */
 static void helper_help(void)
 {
 	printf(
@@ -21,8 +20,6 @@ static const struct option helper_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 helper_parse(int c, char **argv, int invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
@@ -48,7 +45,6 @@ helper_parse(int c, char **argv, int invert, unsigned=
 int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --helper. */
 static void helper_check(unsigned int flags)
 {
 	if (!flags)
@@ -56,7 +52,6 @@ static void helper_check(unsigned int flags)
 			   "helper match: You must specify `--helper'");
 }
=20
-/* Prints out the info. */
 static void
 helper_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
 {
@@ -65,7 +60,6 @@ helper_print(const void *ip, const struct xt_entry_ma=
tch *match, int numeric)
 	printf("helper match %s\"%s\" ", info->invert ? "! " : "", info->name=
);
 }
=20
-/* Saves the union ipt_info in parsable form to stdout. */
 static void helper_save(const void *ip, const struct xt_entry_match *m=
atch)
 {
 	struct xt_helper_info *info =3D (struct xt_helper_info *)match->data;
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index ec305ae..c5c411e 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -8,7 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_length.h>
=20
-/* Function which prints out usage message. */
 static void length_help(void)
 {
 	printf(
@@ -59,8 +58,6 @@ parse_lengths(const char *s, struct xt_length_info *i=
nfo)
 =09
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 length_parse(int c, char **argv, int invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
@@ -86,7 +83,6 @@ length_parse(int c, char **argv, int invert, unsigned=
 int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --length. */
 static void length_check(unsigned int flags)
 {
 	if (!flags)
@@ -94,7 +90,6 @@ static void length_check(unsigned int flags)
 			   "length: You must specify `--length'");
 }
=20
-/* Common match printing code. */
 static void
 print_length(struct xt_length_info *info)
 {
@@ -107,7 +102,6 @@ print_length(struct xt_length_info *info)
 		printf("%u:%u ", info->min, info->max);
 }
=20
-/* Prints out the matchinfo. */
 static void
 length_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
 {
@@ -115,7 +109,6 @@ length_print(const void *ip, const struct xt_entry_=
match *match, int numeric)
 	print_length((struct xt_length_info *)match->data);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void length_save(const void *ip, const struct xt_entry_match *m=
atch)
 {
 	printf("--length ");
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index a519a1a..3ed7b96 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -1,7 +1,7 @@
 /* Shared library add-on to iptables to add limit support.
  *
- * J??e de Vivie   <devivie@info.enserb.u-bordeaux.fr>
- * Herv?Eychenne    <rv@wallfire.org>
+ * J=C3=A9r=C3=B4me de Vivie   <devivie@info.enserb.u-bordeaux.fr>
+ * Herv=C3=A9 Eychenne    <rv@wallfire.org>
  */
=20
 #include <stdio.h>
@@ -17,7 +17,6 @@
 #define XT_LIMIT_AVG	"3/hour"
 #define XT_LIMIT_BURST	5
=20
-/* Function which prints out usage message. */
 static void limit_help(void)
 {
 	printf(
@@ -71,7 +70,6 @@ int parse_rate(const char *rate, u_int32_t *val)
 	return 1;
 }
=20
-/* Initialize the match. */
 static void limit_init(struct xt_entry_match *m)
 {
 	struct xt_rateinfo *r =3D (struct xt_rateinfo *)m->data;
@@ -87,8 +85,6 @@ static void limit_init(struct xt_entry_match *m)
 			   "Sorry: burst too large for that avg rate.\n");
 */
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 limit_parse(int c, char **argv, int invert, unsigned int *flags,
             const void *entry, struct xt_entry_match **match)
@@ -145,7 +141,6 @@ static void print_rate(u_int32_t period)
 	printf("%u/%s ", rates[i-1].mult / period, rates[i-1].name);
 }
=20
-/* Prints out the matchinfo. */
 static void
 limit_print(const void *ip, const struct xt_entry_match *match, int nu=
meric)
 {
@@ -154,7 +149,6 @@ limit_print(const void *ip, const struct xt_entry_m=
atch *match, int numeric)
 	printf("burst %u ", r->burst);
 }
=20
-/* FIXME: Make minimalist: only print rate if not default --RR */
 static void limit_save(const void *ip, const struct xt_entry_match *ma=
tch)
 {
 	struct xt_rateinfo *r =3D (struct xt_rateinfo *)match->data;
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index bc91f0f..2fe5e7b 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -12,7 +12,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_mac.h>
=20
-/* Function which prints out usage message. */
 static void mac_help(void)
 {
 	printf(
@@ -50,8 +49,6 @@ parse_mac(const char *mac, struct xt_mac_info *info)
 	}
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 mac_parse(int c, char **argv, int invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
@@ -84,7 +81,6 @@ static void print_mac(const unsigned char macaddress[=
ETH_ALEN])
 	printf(" ");
 }
=20
-/* Final check; must have specified --mac. */
 static void mac_check(unsigned int flags)
 {
 	if (!flags)
@@ -92,7 +88,6 @@ static void mac_check(unsigned int flags)
 			   "You must specify `--mac-source'");
 }
=20
-/* Prints out the matchinfo. */
 static void
 mac_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
 {
@@ -105,7 +100,6 @@ mac_print(const void *ip, const struct xt_entry_mat=
ch *match, int numeric)
 	print_mac(info->srcaddr);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void mac_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct xt_mac_info *info =3D (void *)match->data;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 1e07676..4ee29e7 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -53,8 +53,6 @@ static int mark_mt_parse(int c, char **argv, int inve=
rt, unsigned int *flags,
 	return false;
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 mark_parse(int c, char **argv, int invert, unsigned int *flags,
            const void *entry, struct xt_entry_match **match)
@@ -109,7 +107,6 @@ mark_mt_print(const void *ip, const struct xt_entry=
_match *match, int numeric)
 	print_mark(info->mark, info->mask);
 }
=20
-/* Prints out the matchinfo. */
 static void
 mark_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
 {
@@ -134,7 +131,6 @@ static void mark_mt_save(const void *ip, const stru=
ct xt_entry_match *match)
 	print_mark(info->mark, info->mask);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void
 mark_save(const void *ip, const struct xt_entry_match *match)
 {
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 2554101..5e5e7ca 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -54,7 +54,6 @@ static void print_types(void)
 	printf("\n");
 }
=20
-/* Function which prints out usage message. */
 static void pkttype_help(void)
 {
 	printf(
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 8e178fe..5007f7c 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -16,14 +16,12 @@ static const struct option quota_opts[] =3D {
 	{ .name =3D NULL }
 };
=20
-/* print usage */
 static void quota_help(void)
 {
 	printf("quota match options:\n"
 	       " --quota quota			quota (bytes)\n");
 }
=20
-/* print matchinfo */
 static void
 quota_print(const void *ip, const struct xt_entry_match *match, int nu=
meric)
 {
@@ -31,7 +29,6 @@ quota_print(const void *ip, const struct xt_entry_mat=
ch *match, int numeric)
 	printf("quota: %llu bytes", (unsigned long long) q->quota);
 }
=20
-/* save matchinfo */
 static void
 quota_save(const void *ip, const struct xt_entry_match *match)
 {
@@ -55,7 +52,6 @@ parse_quota(const char *s, u_int64_t * quota)
 		return 1;
 }
=20
-/* parse all options, returning true if we found any for us */
 static int
 quota_parse(int c, char **argv, int invert, unsigned int *flags,
 	    const void *entry, struct xt_entry_match **match)
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 8f363ff..4f1d13f 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -23,7 +23,7 @@
 #include <linux/netfilter/xt_sctp.h>
=20
 /* Some ZS!#@:$%*#$! has replaced the ELEMCOUNT macro in ipt_sctp.h wi=
th
- * ARRAY_SIZE without noticing that this file is used from userserspac=
e,
+ * ARRAY_SIZE without noticing that this file is used from userspace,
  * and userspace doesn't have ARRAY_SIZE */
=20
 #ifndef ELEMCOUNT
@@ -40,7 +40,6 @@
 static void
 print_chunk(u_int32_t chunknum, int numeric);
=20
-/* Initialize the match. */
 static void sctp_init(struct xt_entry_match *m)
 {
 	int i;
@@ -444,7 +443,6 @@ out:
 	return;
 }
=20
-/* Prints out the matchinfo. */
 static void
 sctp_print(const void *ip, const struct xt_entry_match *match, int num=
eric)
 {
@@ -475,7 +473,6 @@ sctp_print(const void *ip, const struct xt_entry_ma=
tch *match, int numeric)
 	}
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void sctp_save(const void *ip, const struct xt_entry_match *mat=
ch)
 {
 	const struct xt_sctp_info *einfo =3D
@@ -543,4 +540,3 @@ void _init(void)
 	xtables_register_match(&sctp_match);
 	xtables_register_match(&sctp_match6);
 }
-
diff --git a/extensions/libxt_standard.c b/extensions/libxt_standard.c
index 505f87d..54e1348 100644
--- a/extensions/libxt_standard.c
+++ b/extensions/libxt_standard.c
@@ -7,7 +7,6 @@
 #include <getopt.h>
 #include <xtables.h>
=20
-/* Function which prints out usage message. */
 static void standard_help(void)
 {
 	printf(
@@ -15,8 +14,6 @@ static void standard_help(void)
 "(If target is DROP, ACCEPT, RETURN or nothing)\n");
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int standard_parse(int c, char **argv, int invert, unsigned int=
 *flags,
                           const void *entry, struct xt_entry_target **=
target)
 {
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index c37fd70..3af2e48 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -12,7 +12,6 @@
 #define XT_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 1))
 #endif
=20
-/* Function which prints out usage message. */
 static void
 state_help(void)
 {
@@ -60,8 +59,6 @@ state_parse_states(const char *arg, struct xt_state_i=
nfo *sinfo)
 		exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 state_parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
@@ -86,7 +83,6 @@ state_parse(int c, char **argv, int invert, unsigned =
int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --state. */
 static void state_final_check(unsigned int flags)
 {
 	if (!flags)
@@ -120,7 +116,6 @@ static void state_print_state(unsigned int statemas=
k)
 	printf(" ");
 }
=20
-/* Prints out the matchinfo. */
 static void
 state_print(const void *ip,
       const struct xt_entry_match *match,
@@ -132,7 +127,6 @@ state_print(const void *ip,
 	state_print_state(sinfo->statemask);
 }
=20
-/* Saves the matchinfo in parsable form to stdout. */
 static void state_save(const void *ip, const struct xt_entry_match *ma=
tch)
 {
 	struct xt_state_info *sinfo =3D (struct xt_state_info *)match->data;
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.=
c
index 114b419..d85aacb 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -94,7 +94,6 @@ statistic_parse(int c, char **argv, int invert, unsig=
ned int *flags,
 	return 1;
 }
=20
-/* Final check; must have specified --mark. */
 static void statistic_check(unsigned int flags)
 {
 	if (!(flags & 0x1))
@@ -124,7 +123,6 @@ static void statistic_check(unsigned int flags)
 	                           global_info->u.nth.packet;
 }
=20
-/* Prints out the matchinfo. */
 static void print_match(const struct xt_statistic_info *info, char *pr=
efix)
 {
 	if (info->flags & XT_STATISTIC_INVERT)
@@ -153,7 +151,6 @@ statistic_print(const void *ip, const struct xt_ent=
ry_match *match, int numeric)
 	print_match(info, "");
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void statistic_save(const void *ip, const struct xt_entry_match=
 *match)
 {
 	struct xt_statistic_info *info =3D (struct xt_statistic_info *)match-=
>data;
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 61b5bb5..5b3ebf6 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -30,7 +30,6 @@
 #include <stddef.h>
 #include <linux/netfilter/xt_string.h>
=20
-/* Function which prints out usage message. */
 static void string_help(void)
 {
 	printf(
@@ -166,8 +165,6 @@ parse_hex_string(const char *s, struct xt_string_in=
fo *info)
 #define TO     0x8
 #define ICASE  0x10
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 string_parse(int c, char **argv, int invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
@@ -245,8 +242,6 @@ string_parse(int c, char **argv, int invert, unsign=
ed int *flags,
 	return 1;
 }
=20
-
-/* Final check; must have specified --string. */
 static void string_check(unsigned int flags)
 {
 	if (!(flags & STRING))
@@ -303,7 +298,6 @@ print_string(const char *str, const unsigned short =
int len)
 	printf("\" ");  /* closing space and quote */
 }
=20
-/* Prints out the matchinfo. */
 static void
 string_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
 {
@@ -329,8 +323,6 @@ string_print(const void *ip, const struct xt_entry_=
match *match, int numeric)
 		printf("ICASE ");
 }
=20
-
-/* Saves the union ipt_matchinfo in parseable form to stdout. */
 static void string_save(const void *ip, const struct xt_entry_match *m=
atch)
 {
 	const struct xt_string_info *info =3D
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index d780064..eef94a1 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -7,7 +7,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpudp.h>
=20
-/* Function which prints out usage message. */
 static void tcp_help(void)
 {
 	printf(
@@ -127,7 +126,6 @@ parse_tcp_option(const char *option, u_int8_t *resu=
lt)
 	*result =3D (u_int8_t)ret;
 }
=20
-/* Initialize the match. */
 static void tcp_init(struct xt_entry_match *m)
 {
 	struct xt_tcp *tcpinfo =3D (struct xt_tcp *)m->data;
@@ -140,8 +138,6 @@ static void tcp_init(struct xt_entry_match *m)
 #define TCP_FLAGS 0x04
 #define TCP_OPTION	0x08
=20
-/* Function which parses command options; returns true if it
-   ate an option. */
 static int
 tcp_parse(int c, char **argv, int invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
@@ -304,7 +300,6 @@ print_flags(u_int8_t mask, u_int8_t cmp, int invert=
, int numeric)
 	}
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void
 tcp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
 {
@@ -328,7 +323,6 @@ tcp_print(const void *ip, const struct xt_entry_mat=
ch *match, int numeric)
 		       tcp->invflags & ~XT_TCP_INV_MASK);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void tcp_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct xt_tcp *tcpinfo =3D (struct xt_tcp *)match->data;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 8f56a41..59218b8 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -8,7 +8,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpmss.h>
=20
-/* Function which prints out usage message. */
 static void tcpmss_help(void)
 {
 	printf(
@@ -54,8 +53,6 @@ parse_tcp_mssvalues(const char *mssvaluestring,
 	free(buffer);
 }
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
              const void *entry, struct xt_entry_match **match)
@@ -93,7 +90,6 @@ print_tcpmss(u_int16_t mss_min, u_int16_t mss_max, in=
t invert, int numeric)
 		printf("%u:%u ", mss_min, mss_max);
 }
=20
-/* Final check; must have specified --mss. */
 static void tcpmss_check(unsigned int flags)
 {
 	if (!flags)
@@ -101,7 +97,6 @@ static void tcpmss_check(unsigned int flags)
 			   "tcpmss match: You must specify `--mss'");
 }
=20
-/* Prints out the matchinfo. */
 static void
 tcpmss_print(const void *ip, const struct xt_entry_match *match, int n=
umeric)
 {
@@ -113,7 +108,6 @@ tcpmss_print(const void *ip, const struct xt_entry_=
match *match, int numeric)
 		     mssinfo->invert, numeric);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void tcpmss_save(const void *ip, const struct xt_entry_match *m=
atch)
 {
 	const struct xt_tcpmss_match_info *mssinfo =3D
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 77245ab..256d15f 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -101,7 +101,6 @@ static u_int32_t parse_number(char **s, int pos)
 	return number;
 }
=20
-/* Function which parses command options; returns true if it ate an op=
tion */
 static int u32_parse(int c, char **argv, int invert, unsigned int *fla=
gs,
 		     const void *entry, struct xt_entry_match **match)
 {
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index a749f13..0dfa367 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -7,7 +7,6 @@
 #include <xtables.h>
 #include <linux/netfilter/xt_tcpudp.h>
=20
-/* Function which prints out usage message. */
 static void udp_help(void)
 {
 	printf(
@@ -51,7 +50,6 @@ parse_udp_ports(const char *portstring, u_int16_t *po=
rts)
 	free(buffer);
 }
=20
-/* Initialize the match. */
 static void udp_init(struct xt_entry_match *m)
 {
 	struct xt_udp *udpinfo =3D (struct xt_udp *)m->data;
@@ -62,8 +60,6 @@ static void udp_init(struct xt_entry_match *m)
 #define UDP_SRC_PORTS 0x01
 #define UDP_DST_PORTS 0x02
=20
-/* Function which parses command options; returns true if it
-   ate an option */
 static int
 udp_parse(int c, char **argv, int invert, unsigned int *flags,
           const void *entry, struct xt_entry_match **match)
@@ -143,7 +139,6 @@ print_ports(const char *name, u_int16_t min, u_int1=
6_t max,
 	}
 }
=20
-/* Prints out the union ipt_matchinfo. */
 static void
 udp_print(const void *ip, const struct xt_entry_match *match, int nume=
ric)
 {
@@ -161,7 +156,6 @@ udp_print(const void *ip, const struct xt_entry_mat=
ch *match, int numeric)
 		       udp->invflags & ~XT_UDP_INV_MASK);
 }
=20
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void udp_save(const void *ip, const struct xt_entry_match *matc=
h)
 {
 	const struct xt_udp *udpinfo =3D (struct xt_udp *)match->data;
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
