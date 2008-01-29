From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/6] [IPTABLES]: revert r7306
Date: Tue, 29 Jan 2008 18:31:17 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291828030.14907@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34768 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYA2RbT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:31:19 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


 - Revert part of svn r7306, as some gcc warnings are truly unhelpful.
   "{}" clearly means to me: I want an empty thing, aka. {0};
   and {.something = NULL} is just the same in verbose

 - Change "unsigned" to explicit "unsigned int".

 - Remove a few casts I have stumbled upon in the process.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 configure.ac                    |    2 +-
 extensions/dscp_helper.c        |    2 +-
 extensions/libip6t_HL.c         |    2 +-
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_REJECT.c     |    2 +-
 extensions/libip6t_ah.c         |    2 +-
 extensions/libip6t_dst.c        |    4 ++--
 extensions/libip6t_hbh.c        |    4 ++--
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |    2 +-
 extensions/libip6t_ipv6header.c |    2 +-
 extensions/libip6t_mh.c         |    2 +-
 extensions/libip6t_policy.c     |    2 +-
 extensions/libip6t_rt.c         |    4 ++--
 extensions/libipt_CLUSTERIP.c   |    2 +-
 extensions/libipt_DNAT.c        |    2 +-
 extensions/libipt_ECN.c         |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_MASQUERADE.c  |    2 +-
 extensions/libipt_NETMAP.c      |    2 +-
 extensions/libipt_REDIRECT.c    |    2 +-
 extensions/libipt_REJECT.c      |    2 +-
 extensions/libipt_SAME.c        |    8 ++++----
 extensions/libipt_SNAT.c        |    2 +-
 extensions/libipt_TTL.c         |    2 +-
 extensions/libipt_ULOG.c        |    2 +-
 extensions/libipt_addrtype.c    |    2 +-
 extensions/libipt_ah.c          |    2 +-
 extensions/libipt_ecn.c         |    2 +-
 extensions/libipt_icmp.c        |    2 +-
 extensions/libipt_policy.c      |    2 +-
 extensions/libipt_realm.c       |    2 +-
 extensions/libipt_recent.c      |    2 +-
 extensions/libipt_ttl.c         |    2 +-
 extensions/libxt_CLASSIFY.c     |    2 +-
 extensions/libxt_CONNMARK.c     |    4 ++--
 extensions/libxt_CONNSECMARK.c  |    2 +-
 extensions/libxt_DSCP.c         |    2 +-
 extensions/libxt_MARK.c         |    4 ++--
 extensions/libxt_NFLOG.c        |    2 +-
 extensions/libxt_NFQUEUE.c      |    2 +-
 extensions/libxt_RATEEST.c      |    2 +-
 extensions/libxt_SECMARK.c      |    2 +-
 extensions/libxt_TCPMSS.c       |    2 +-
 extensions/libxt_TCPOPTSTRIP.c  |    6 +++---
 extensions/libxt_TOS.c          |    4 ++--
 extensions/libxt_comment.c      |    2 +-
 extensions/libxt_connbytes.c    |    2 +-
 extensions/libxt_connlimit.c    |    2 +-
 extensions/libxt_connmark.c     |    2 +-
 extensions/libxt_conntrack.c    |    8 +++-----
 extensions/libxt_dccp.c         |    2 +-
 extensions/libxt_dscp.c         |    2 +-
 extensions/libxt_esp.c          |    2 +-
 extensions/libxt_hashlimit.c    |    2 +-
 extensions/libxt_helper.c       |    2 +-
 extensions/libxt_iprange.c      |    2 +-
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |    2 +-
 extensions/libxt_mac.c          |    2 +-
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |    2 +-
 extensions/libxt_owner.c        |    6 +++---
 extensions/libxt_physdev.c      |    2 +-
 extensions/libxt_pkttype.c      |    2 +-
 extensions/libxt_quota.c        |    6 +++---
 extensions/libxt_rateest.c      |    4 ++--
 extensions/libxt_sctp.c         |    2 +-
 extensions/libxt_state.c        |    2 +-
 extensions/libxt_statistic.c    |    2 +-
 extensions/libxt_string.c       |    2 +-
 extensions/libxt_tcp.c          |    2 +-
 extensions/libxt_tcpmss.c       |    2 +-
 extensions/libxt_time.c         |    2 +-
 extensions/libxt_tos.c          |    2 +-
 extensions/libxt_u32.c          |    2 +-
 extensions/libxt_udp.c          |    2 +-
 extensions/tos_values.c         |    2 +-
 iptables-xml.c                  |   24 ++++++++++++------------
 xtables.c                       |    6 +++---
 80 files changed, 111 insertions(+), 113 deletions(-)

Index: iptables/configure.ac
===================================================================
--- iptables.orig/configure.ac
+++ iptables/configure.ac
@@ -37,7 +37,7 @@ AM_CONDITIONAL([ENABLE_SHARED], [test "$
 AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" == "yes"])
 
 regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 \
-	-D_REENTRANT -W -Wall -Waggregate-return -Wmissing-declarations \
+	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
 	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" -DIP6T_LIB_DIR=\\\"\${iptdir}\\\"";
Index: iptables/extensions/dscp_helper.c
===================================================================
--- iptables.orig/extensions/dscp_helper.c
+++ iptables/extensions/dscp_helper.c
@@ -49,7 +49,7 @@ static const struct ds_class
 static unsigned int
 class_to_dscp(const char *name)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) {
 		if (!strncasecmp(name, ds_classes[i].name,
Index: iptables/extensions/libip6t_HL.c
===================================================================
--- iptables.orig/extensions/libip6t_HL.c
+++ iptables/extensions/libip6t_HL.c
@@ -136,7 +136,7 @@ static const struct option HL_opts[] = {
 	{ "hl-set", 1, NULL, '1' },
 	{ "hl-dec", 1, NULL, '2' },
 	{ "hl-inc", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static struct ip6tables_target hl_target6 = {
Index: iptables/extensions/libip6t_LOG.c
===================================================================
--- iptables.orig/extensions/libip6t_LOG.c
+++ iptables/extensions/libip6t_LOG.c
@@ -38,7 +38,7 @@ static const struct option LOG_opts[] = 
 	{ .name = "log-tcp-options",  .has_arg = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .val = '3' },
 	{ .name = "log-uid",          .has_arg = 0, .val = '4' },
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
Index: iptables/extensions/libip6t_REJECT.c
===================================================================
--- iptables.orig/extensions/libip6t_REJECT.c
+++ iptables/extensions/libip6t_REJECT.c
@@ -66,7 +66,7 @@ static void REJECT_help(void)
 
 static const struct option REJECT_opts[] = {
 	{ "reject-with", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 /* Allocate and initialize the target. */
Index: iptables/extensions/libip6t_ah.c
===================================================================
--- iptables.orig/extensions/libip6t_ah.c
+++ iptables/extensions/libip6t_ah.c
@@ -23,7 +23,7 @@ static const struct option ah_opts[] = {
 	{ .name = "ahspi", .has_arg = 1, .val = '1' },
 	{ .name = "ahlen", .has_arg = 1, .val = '2' },
 	{ .name = "ahres", .has_arg = 0, .val = '3' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
Index: iptables/extensions/libip6t_dst.c
===================================================================
--- iptables.orig/extensions/libip6t_dst.c
+++ iptables/extensions/libip6t_dst.c
@@ -26,7 +26,7 @@ static const struct option dst_opts[] = 
 	{ .name = "dst-len",        .has_arg = 1, .val = '1' },
 	{ .name = "dst-opts",       .has_arg = 1, .val = '2' },
 	{ .name = "dst-not-strict", .has_arg = 1, .val = '3' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
@@ -168,7 +168,7 @@ static int dst_parse(int c, char **argv,
 }
 
 static void
-print_options(unsigned optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
Index: iptables/extensions/libip6t_hbh.c
===================================================================
--- iptables.orig/extensions/libip6t_hbh.c
+++ iptables/extensions/libip6t_hbh.c
@@ -29,7 +29,7 @@ static const struct option hbh_opts[] = 
 	{ "hbh-len", 1, NULL, '1' },
 	{ "hbh-opts", 1, NULL, '2' },
 	{ "hbh-not-strict", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
@@ -162,7 +162,7 @@ static int hbh_parse(int c, char **argv,
 }
 
 static void
-print_options(unsigned optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, u_int16_t *optsp)
 {
 	unsigned int i;
 
Index: iptables/extensions/libip6t_hl.c
===================================================================
--- iptables.orig/extensions/libip6t_hl.c
+++ iptables/extensions/libip6t_hl.c
@@ -122,7 +122,7 @@ static const struct option hl_opts[] = {
 	{ .name = "hl-eq", .has_arg = 1, .val = '2' },
 	{ .name = "hl-lt", .has_arg = 1, .val = '3' },
 	{ .name = "hl-gt", .has_arg = 1, .val = '4' },
-	{ .name = NULL }
+	{},
 };
 
 static struct ip6tables_match hl_match6 = {
Index: iptables/extensions/libip6t_icmp6.c
===================================================================
--- iptables.orig/extensions/libip6t_icmp6.c
+++ iptables/extensions/libip6t_icmp6.c
@@ -86,7 +86,7 @@ static void icmp6_help(void)
 
 static const struct option icmp6_opts[] = {
 	{ "icmpv6-type", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libip6t_ipv6header.c
===================================================================
--- iptables.orig/extensions/libip6t_ipv6header.c
+++ iptables/extensions/libip6t_ipv6header.c
@@ -150,7 +150,7 @@ static void ipv6header_help(void)
 static const struct option ipv6header_opts[] = {
 	{ "header", 1, NULL, '1' },
 	{ "soft", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 static void ipv6header_init(struct xt_entry_match *m)
Index: iptables/extensions/libip6t_mh.c
===================================================================
--- iptables.orig/extensions/libip6t_mh.c
+++ iptables/extensions/libip6t_mh.c
@@ -220,7 +220,7 @@ static void mh_save(const void *ip, cons
 
 static const struct option mh_opts[] = {
 	{ "mh-type", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static struct ip6tables_match mh_match6 = {
Index: iptables/extensions/libip6t_policy.c
===================================================================
--- iptables.orig/extensions/libip6t_policy.c
+++ iptables/extensions/libip6t_policy.c
@@ -91,7 +91,7 @@ static const struct option policy_opts[]
 		.name		= "next",
 		.val		= 'a'
 	},
-	{ .name = NULL }
+	{},
 };
 
 /* FIXME - Duplicated code from ip6tables.c */
Index: iptables/extensions/libip6t_rt.c
===================================================================
--- iptables.orig/extensions/libip6t_rt.c
+++ iptables/extensions/libip6t_rt.c
@@ -35,7 +35,7 @@ static const struct option rt_opts[] = {
 	{ "rt-0-res", 0, NULL, '4' },
 	{ "rt-0-addrs", 1, NULL, '5' },
 	{ "rt-0-not-strict", 0, NULL, '6' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
@@ -255,7 +255,7 @@ print_nums(const char *name, u_int32_t m
 }
 
 static void
-print_addresses(unsigned addrnr, struct in6_addr *addrp)
+print_addresses(unsigned int addrnr, struct in6_addr *addrp)
 {
 	unsigned int i;
 
Index: iptables/extensions/libipt_CLUSTERIP.c
===================================================================
--- iptables.orig/extensions/libipt_CLUSTERIP.c
+++ iptables/extensions/libipt_CLUSTERIP.c
@@ -50,7 +50,7 @@ static const struct option CLUSTERIP_opt
 	{ "total-nodes", 1, NULL, '4' },
 	{ "local-node", 1, NULL, '5' },
 	{ "hash-init", 1, NULL, '6' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libipt_DNAT.c
===================================================================
--- iptables.orig/extensions/libipt_DNAT.c
+++ iptables/extensions/libipt_DNAT.c
@@ -34,7 +34,7 @@ IPTABLES_VERSION);
 static const struct option DNAT_opts[] = {
 	{ "to-destination", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 static struct ipt_natinfo *
Index: iptables/extensions/libipt_ECN.c
===================================================================
--- iptables.orig/extensions/libipt_ECN.c
+++ iptables/extensions/libipt_ECN.c
@@ -38,7 +38,7 @@ static const struct option ECN_opts[] = 
 	{ "ecn-tcp-cwr", 1, NULL, 'G' },
 	{ "ecn-tcp-ece", 1, NULL, 'H' },
 	{ "ecn-ip-ect", 1, NULL, '9' },
-	{ .name = NULL }
+	{},
 };
 
 static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
Index: iptables/extensions/libipt_LOG.c
===================================================================
--- iptables.orig/extensions/libipt_LOG.c
+++ iptables/extensions/libipt_LOG.c
@@ -38,7 +38,7 @@ static const struct option LOG_opts[] = 
 	{ .name = "log-tcp-options",  .has_arg = 0, .val = '2' },
 	{ .name = "log-ip-options",   .has_arg = 0, .val = '3' },
 	{ .name = "log-uid",          .has_arg = 0, .val = '4' },
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
Index: iptables/extensions/libipt_MASQUERADE.c
===================================================================
--- iptables.orig/extensions/libipt_MASQUERADE.c
+++ iptables/extensions/libipt_MASQUERADE.c
@@ -25,7 +25,7 @@ IPTABLES_VERSION);
 static const struct option MASQUERADE_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
Index: iptables/extensions/libipt_NETMAP.c
===================================================================
--- iptables.orig/extensions/libipt_NETMAP.c
+++ iptables/extensions/libipt_NETMAP.c
@@ -15,7 +15,7 @@
 
 static const struct option NETMAP_opts[] = {
 	{ "to", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 /* Function which prints out usage message. */
Index: iptables/extensions/libipt_REDIRECT.c
===================================================================
--- iptables.orig/extensions/libipt_REDIRECT.c
+++ iptables/extensions/libipt_REDIRECT.c
@@ -24,7 +24,7 @@ IPTABLES_VERSION);
 static const struct option REDIRECT_opts[] = {
 	{ "to-ports", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
Index: iptables/extensions/libipt_REJECT.c
===================================================================
--- iptables.orig/extensions/libipt_REJECT.c
+++ iptables/extensions/libipt_REJECT.c
@@ -81,7 +81,7 @@ static void REJECT_help(void)
 
 static const struct option REJECT_opts[] = {
 	{ "reject-with", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 /* Allocate and initialize the target. */
Index: iptables/extensions/libipt_SAME.c
===================================================================
--- iptables.orig/extensions/libipt_SAME.c
+++ iptables/extensions/libipt_SAME.c
@@ -32,7 +32,7 @@ static const struct option SAME_opts[] =
 	{ "to", 1, NULL, '1' },
 	{ "nodst", 0, NULL, '2'},
 	{ "random", 0, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
@@ -90,7 +90,7 @@ static int SAME_parse(int c, char **argv
 {
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)(*target)->data;
-	unsigned count;
+	unsigned int count;
 
 	switch (c) {
 	case '1':
@@ -146,7 +146,7 @@ static void SAME_check(unsigned int flag
 static void SAME_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	unsigned count;
+	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
@@ -180,7 +180,7 @@ static void SAME_print(const void *ip, c
 /* Saves the union ipt_targinfo in parsable form to stdout. */
 static void SAME_save(const void *ip, const struct xt_entry_target *target)
 {
-	unsigned count;
+	unsigned int count;
 	struct ipt_same_info *mr
 		= (struct ipt_same_info *)target->data;
 	int random = 0;
Index: iptables/extensions/libipt_SNAT.c
===================================================================
--- iptables.orig/extensions/libipt_SNAT.c
+++ iptables/extensions/libipt_SNAT.c
@@ -34,7 +34,7 @@ IPTABLES_VERSION);
 static const struct option SNAT_opts[] = {
 	{ "to-source", 1, NULL, '1' },
 	{ "random", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 static struct ipt_natinfo *
Index: iptables/extensions/libipt_TTL.c
===================================================================
--- iptables.orig/extensions/libipt_TTL.c
+++ iptables/extensions/libipt_TTL.c
@@ -136,7 +136,7 @@ static const struct option TTL_opts[] = 
 	{ "ttl-set", 1, NULL, '1' },
 	{ "ttl-dec", 1, NULL, '2' },
 	{ "ttl-inc", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static struct iptables_target ttl_target = {
Index: iptables/extensions/libipt_ULOG.c
===================================================================
--- iptables.orig/extensions/libipt_ULOG.c
+++ iptables/extensions/libipt_ULOG.c
@@ -49,7 +49,7 @@ static const struct option ULOG_opts[] =
 	{"ulog-prefix", 1, NULL, '#'},
 	{"ulog-cprange", 1, NULL, 'A'},
 	{"ulog-qthreshold", 1, NULL, 'B'},
-	{ .name = NULL }
+	{},
 };
 
 /* Initialize the target. */
Index: iptables/extensions/libipt_addrtype.c
===================================================================
--- iptables.orig/extensions/libipt_addrtype.c
+++ iptables/extensions/libipt_addrtype.c
@@ -180,7 +180,7 @@ static void addrtype_save(const void *ip
 static const struct option addrtype_opts[] = {
 	{ "src-type", 1, NULL, '1' },
 	{ "dst-type", 1, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 static struct iptables_match addrtype_match = {
Index: iptables/extensions/libipt_ah.c
===================================================================
--- iptables.orig/extensions/libipt_ah.c
+++ iptables/extensions/libipt_ah.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option ah_opts[] = {
 	{ "ahspi", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
Index: iptables/extensions/libipt_ecn.c
===================================================================
--- iptables.orig/extensions/libipt_ecn.c
+++ iptables/extensions/libipt_ecn.c
@@ -30,7 +30,7 @@ static const struct option ecn_opts[] = 
 	{ .name = "ecn-tcp-cwr", .has_arg = 0, .val = 'F' },
 	{ .name = "ecn-tcp-ece", .has_arg = 0, .val = 'G' },
 	{ .name = "ecn-ip-ect",  .has_arg = 1, .val = 'H' },
-	{ .name = NULL }
+	{},
 };
 
 static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
Index: iptables/extensions/libipt_icmp.c
===================================================================
--- iptables.orig/extensions/libipt_icmp.c
+++ iptables/extensions/libipt_icmp.c
@@ -110,7 +110,7 @@ static void icmp_help(void)
 
 static const struct option icmp_opts[] = {
 	{ "icmp-type", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static void 
Index: iptables/extensions/libipt_policy.c
===================================================================
--- iptables.orig/extensions/libipt_policy.c
+++ iptables/extensions/libipt_policy.c
@@ -90,7 +90,7 @@ static const struct option policy_opts[]
 		.name		= "next",
 		.val		= 'a'
 	},
-	{ .name = NULL }
+	{},
 };
 
 static int parse_direction(char *s)
Index: iptables/extensions/libipt_realm.c
===================================================================
--- iptables.orig/extensions/libipt_realm.c
+++ iptables/extensions/libipt_realm.c
@@ -26,7 +26,7 @@ static void realm_help(void)
 
 static const struct option realm_opts[] = {
 	{ "realm", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 struct realmname { 
Index: iptables/extensions/libipt_recent.c
===================================================================
--- iptables.orig/extensions/libipt_recent.c
+++ iptables/extensions/libipt_recent.c
@@ -33,7 +33,7 @@ static const struct option recent_opts[]
 	{ .name = "name",     .has_arg = 1, .val = 208 },
 	{ .name = "rsource",  .has_arg = 0, .val = 209 },
 	{ .name = "rdest",    .has_arg = 0, .val = 210 },
-	{ .name = NULL }
+	{},
 };
 
 /* Function which prints out usage message. */
Index: iptables/extensions/libipt_ttl.c
===================================================================
--- iptables.orig/extensions/libipt_ttl.c
+++ iptables/extensions/libipt_ttl.c
@@ -145,7 +145,7 @@ static const struct option ttl_opts[] = 
 	{ "ttl-eq", 1, NULL, '2'},
 	{ "ttl-lt", 1, NULL, '3'},
 	{ "ttl-gt", 1, NULL, '4'},
-	{ .name = NULL }
+	{},
 };
 
 static struct iptables_match ttl_match = {
Index: iptables/extensions/libxt_CLASSIFY.c
===================================================================
--- iptables.orig/extensions/libxt_CLASSIFY.c
+++ iptables/extensions/libxt_CLASSIFY.c
@@ -23,7 +23,7 @@ IPTABLES_VERSION);
 
 static const struct option CLASSIFY_opts[] = {
 	{ "set-class", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static int CLASSIFY_string_to_priority(const char *s, unsigned int *p)
Index: iptables/extensions/libxt_CONNMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNMARK.c
+++ iptables/extensions/libxt_CONNMARK.c
@@ -50,7 +50,7 @@ static const struct option CONNMARK_opts
 	{ "save-mark", 0, NULL, '2' },
 	{ "restore-mark", 0, NULL, '3' },
 	{ "mask", 1, NULL, '4' },
-	{ .name = NULL }
+	{},
 };
 
 static const struct option connmark_tg_opts[] = {
@@ -64,7 +64,7 @@ static const struct option connmark_tg_o
 	{.name = "ctmask",        .has_arg = true,  .val = 'c'},
 	{.name = "nfmask",        .has_arg = true,  .val = 'n'},
 	{.name = "mask",          .has_arg = true,  .val = 'm'},
-	{.name = NULL},
+	{},
 };
 
 static void connmark_tg_help(void)
Index: iptables/extensions/libxt_CONNSECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_CONNSECMARK.c
+++ iptables/extensions/libxt_CONNSECMARK.c
@@ -27,7 +27,7 @@ IPTABLES_VERSION);
 static const struct option CONNSECMARK_opts[] = {
 	{ "save", 0, 0, '1' },
 	{ "restore", 0, 0, '2' },
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_DSCP.c
===================================================================
--- iptables.orig/extensions/libxt_DSCP.c
+++ iptables/extensions/libxt_DSCP.c
@@ -40,7 +40,7 @@ static void DSCP_help(void)
 static const struct option DSCP_opts[] = {
 	{ "set-dscp", 1, NULL, 'F' },
 	{ "set-dscp-class", 1, NULL, 'G' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_MARK.c
===================================================================
--- iptables.orig/extensions/libxt_MARK.c
+++ iptables/extensions/libxt_MARK.c
@@ -29,7 +29,7 @@ static const struct option MARK_opts[] =
 	{ "set-mark", 1, NULL, '1' },
 	{ "and-mark", 1, NULL, '2' },
 	{ "or-mark", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static const struct option mark_tg_opts[] = {
@@ -38,7 +38,7 @@ static const struct option mark_tg_opts[
 	{.name = "and-mark",  .has_arg = true, .val = '&'},
 	{.name = "or-mark",   .has_arg = true, .val = '|'},
 	{.name = "xor-mark",  .has_arg = true, .val = '^'},
-	{ .name = NULL }
+	{},
 };
 
 static void mark_tg_help(void)
Index: iptables/extensions/libxt_NFLOG.c
===================================================================
--- iptables.orig/extensions/libxt_NFLOG.c
+++ iptables/extensions/libxt_NFLOG.c
@@ -19,7 +19,7 @@ static const struct option NFLOG_opts[] 
 	{ "nflog-prefix",    1, NULL, NFLOG_PREFIX },
 	{ "nflog-range",     1, NULL, NFLOG_RANGE },
 	{ "nflog-threshold", 1, NULL, NFLOG_THRESHOLD },
-	{ .name = NULL }
+	{},
 };
 
 static void NFLOG_help(void)
Index: iptables/extensions/libxt_NFQUEUE.c
===================================================================
--- iptables.orig/extensions/libxt_NFQUEUE.c
+++ iptables/extensions/libxt_NFQUEUE.c
@@ -25,7 +25,7 @@ static void NFQUEUE_help(void)
 
 static const struct option NFQUEUE_opts[] = {
 	{ "queue-num", 1, NULL, 'F' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_RATEEST.c
===================================================================
--- iptables.orig/extensions/libxt_RATEEST.c
+++ iptables/extensions/libxt_RATEEST.c
@@ -36,7 +36,7 @@ static const struct option RATEEST_opts[
 	{ "rateest-name",	1, NULL, RATEEST_OPT_NAME },
 	{ "rateest-interval",	1, NULL, RATEEST_OPT_INTERVAL },
 	{ "rateest-ewmalog",	1, NULL, RATEEST_OPT_EWMALOG },
-	{ .name = NULL },
+	{},
 };
 
 /* Copied from iproute */
Index: iptables/extensions/libxt_SECMARK.c
===================================================================
--- iptables.orig/extensions/libxt_SECMARK.c
+++ iptables/extensions/libxt_SECMARK.c
@@ -25,7 +25,7 @@ IPTABLES_VERSION);
 
 static const struct option SECMARK_opts[] = {
 	{ "selctx", 1, 0, '1' },
-	{ .name = NULL }
+	{},
 };
 
 /*
Index: iptables/extensions/libxt_TCPMSS.c
===================================================================
--- iptables.orig/extensions/libxt_TCPMSS.c
+++ iptables/extensions/libxt_TCPMSS.c
@@ -39,7 +39,7 @@ static void TCPMSS_help6(void)
 static const struct option TCPMSS_opts[] = {
 	{ "set-mss", 1, NULL, '1' },
 	{ "clamp-mss-to-pmtu", 0, NULL, '2' },
-	{ .name = NULL }
+	{},
 };
 
 /* Function which parses command options; returns true if it
Index: iptables/extensions/libxt_TCPOPTSTRIP.c
===================================================================
--- iptables.orig/extensions/libxt_TCPOPTSTRIP.c
+++ iptables/extensions/libxt_TCPOPTSTRIP.c
@@ -22,12 +22,12 @@ enum {
 
 struct tcp_optionmap {
 	const char *name, *desc;
-	const unsigned option;
+	const unsigned int option;
 };
 
 static const struct option tcpoptstrip_tg_opts[] = {
 	{.name = "strip-options", .has_arg = true, .val = 's'},
-	{ .name = NULL }
+	{},
 };
 
 static const struct tcp_optionmap tcp_optionmap[] = {
@@ -37,7 +37,7 @@ static const struct tcp_optionmap tcp_op
 	{"sack",           "Selective ACK",        TCPOPT_SACK},
 	{"timestamp",      "Timestamp",            TCPOPT_TIMESTAMP},
 	{"md5",            "MD5 signature",        TCPOPT_MD5SIG},
-	{ .name = NULL }
+	{},
 };
 
 static void tcpoptstrip_tg_help(void)
Index: iptables/extensions/libxt_TOS.c
===================================================================
--- iptables.orig/extensions/libxt_TOS.c
+++ iptables/extensions/libxt_TOS.c
@@ -20,7 +20,7 @@ enum {
 
 static const struct option tos_tg_opts_v0[] = {
 	{.name = "set-tos", .has_arg = true, .val = '='},
-	{ .name = NULL }
+	{},
 };
 
 static const struct option tos_tg_opts[] = {
@@ -28,7 +28,7 @@ static const struct option tos_tg_opts[]
 	{.name = "and-tos", .has_arg = true, .val = '&'},
 	{.name = "or-tos",  .has_arg = true, .val = '|'},
 	{.name = "xor-tos", .has_arg = true, .val = '^'},
-	{ .name = NULL }
+	{},
 };
 
 static void tos_tg_help_v0(void)
Index: iptables/extensions/libxt_comment.c
===================================================================
--- iptables.orig/extensions/libxt_comment.c
+++ iptables/extensions/libxt_comment.c
@@ -25,7 +25,7 @@ static void comment_help(void)
 
 static const struct option comment_opts[] = {
 	{ "comment", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_connbytes.c
===================================================================
--- iptables.orig/extensions/libxt_connbytes.c
+++ iptables/extensions/libxt_connbytes.c
@@ -23,7 +23,7 @@ static const struct option connbytes_opt
 	{ "connbytes", 1, NULL, '1' },
 	{ "connbytes-dir", 1, NULL, '2' },
 	{ "connbytes-mode", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_connlimit.c
===================================================================
--- iptables.orig/extensions/libxt_connlimit.c
+++ iptables/extensions/libxt_connlimit.c
@@ -21,7 +21,7 @@ static void connlimit_help(void)
 static const struct option connlimit_opts[] = {
 	{"connlimit-above", 1, NULL, 'A'},
 	{"connlimit-mask",  1, NULL, 'M'},
-	{ .name = NULL }
+	{},
 };
 
 static void connlimit_init(struct xt_entry_match *match)
Index: iptables/extensions/libxt_connmark.c
===================================================================
--- iptables.orig/extensions/libxt_connmark.c
+++ iptables/extensions/libxt_connmark.c
@@ -42,7 +42,7 @@ static void connmark_mt_help(void)
 
 static const struct option connmark_mt_opts[] = {
 	{.name = "mark", .has_arg = true, .val = '1'},
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_conntrack.c
===================================================================
--- iptables.orig/extensions/libxt_conntrack.c
+++ iptables/extensions/libxt_conntrack.c
@@ -57,7 +57,7 @@ static const struct option conntrack_mt_
 	{.name = "ctrepldst", .has_arg = true, .val = '6'},
 	{.name = "ctstatus",  .has_arg = true, .val = '7'},
 	{.name = "ctexpire",  .has_arg = true, .val = '8'},
-	{ .name = NULL }
+	{},
 };
 
 static const struct option conntrack_mt_opts[] = {
@@ -74,7 +74,7 @@ static const struct option conntrack_mt_
 	{.name = "ctreplsrcport", .has_arg = true, .val = 'c'},
 	{.name = "ctrepldstport", .has_arg = true, .val = 'd'},
 	{.name = "ctdir",         .has_arg = true, .val = 'e'},
-	{.name = NULL},
+	{},
 };
 
 static int
@@ -250,9 +250,7 @@ parse_expires(const char *s, struct xt_c
 		cp++;
 
 		sinfo->expires_min = buffer[0] ? parse_expire(buffer) : 0;
-		sinfo->expires_max = cp[0]
-			? parse_expire(cp)
-			: (unsigned long)-1;
+		sinfo->expires_max = cp[0] ? parse_expire(cp) : -1;
 	}
 	free(buffer);
 
Index: iptables/extensions/libxt_dccp.c
===================================================================
--- iptables.orig/extensions/libxt_dccp.c
+++ iptables/extensions/libxt_dccp.c
@@ -51,7 +51,7 @@ static const struct option dccp_opts[] =
 	{ .name = "dport", .has_arg = 1, .val = '2' },
 	{ .name = "dccp-types", .has_arg = 1, .val = '3' },
 	{ .name = "dccp-option", .has_arg = 1, .val = '4' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_dscp.c
===================================================================
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -42,7 +42,7 @@ static void dscp_help(void)
 static const struct option dscp_opts[] = {
 	{ "dscp", 1, NULL, 'F' },
 	{ "dscp-class", 1, NULL, 'G' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_esp.c
===================================================================
--- iptables.orig/extensions/libxt_esp.c
+++ iptables/extensions/libxt_esp.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option esp_opts[] = {
 	{ "espspi", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int32_t
Index: iptables/extensions/libxt_hashlimit.c
===================================================================
--- iptables.orig/extensions/libxt_hashlimit.c
+++ iptables/extensions/libxt_hashlimit.c
@@ -54,7 +54,7 @@ static const struct option hashlimit_opt
 	{ "hashlimit-htable-expire", 1, NULL, ')' },
 	{ "hashlimit-mode", 1, NULL, '_' },
 	{ "hashlimit-name", 1, NULL, '"' },
-	{ .name = NULL }
+	{},
 };
 
 static
Index: iptables/extensions/libxt_helper.c
===================================================================
--- iptables.orig/extensions/libxt_helper.c
+++ iptables/extensions/libxt_helper.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option helper_opts[] = {
 	{ "helper", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 /* Function which parses command options; returns true if it
Index: iptables/extensions/libxt_iprange.c
===================================================================
--- iptables.orig/extensions/libxt_iprange.c
+++ iptables/extensions/libxt_iprange.c
@@ -27,7 +27,7 @@ static void iprange_mt_help(void)
 static const struct option iprange_mt_opts[] = {
 	{.name = "src-range", .has_arg = true, .val = '1'},
 	{.name = "dst-range", .has_arg = true, .val = '2'},
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_length.c
===================================================================
--- iptables.orig/extensions/libxt_length.c
+++ iptables/extensions/libxt_length.c
@@ -21,7 +21,7 @@ IPTABLES_VERSION);
   
 static const struct option length_opts[] = {
 	{ "length", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int16_t
Index: iptables/extensions/libxt_limit.c
===================================================================
--- iptables.orig/extensions/libxt_limit.c
+++ iptables/extensions/libxt_limit.c
@@ -32,7 +32,7 @@ static void limit_help(void)
 static const struct option limit_opts[] = {
 	{ "limit", 1, NULL, '%' },
 	{ "limit-burst", 1, NULL, '$' },
-	{ .name = NULL }
+	{},
 };
 
 static
Index: iptables/extensions/libxt_mac.c
===================================================================
--- iptables.orig/extensions/libxt_mac.c
+++ iptables/extensions/libxt_mac.c
@@ -24,7 +24,7 @@ static void mac_help(void)
 
 static const struct option mac_opts[] = {
 	{ "mac-source", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_mark.c
===================================================================
--- iptables.orig/extensions/libxt_mark.c
+++ iptables/extensions/libxt_mark.c
@@ -23,7 +23,7 @@ static void mark_mt_help(void)
 
 static const struct option mark_mt_opts[] = {
 	{.name = "mark", .has_arg = true, .val = '1'},
-	{ .name = NULL }
+	{},
 };
 
 static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
Index: iptables/extensions/libxt_multiport.c
===================================================================
--- iptables.orig/extensions/libxt_multiport.c
+++ iptables/extensions/libxt_multiport.c
@@ -49,7 +49,7 @@ static const struct option multiport_opt
 	{ "destination-ports", 1, NULL, '2' },
 	{ "dports", 1, NULL, '2' }, /* synonym */
 	{ "ports", 1, NULL, '3' },
-	{ .name = NULL }
+	{},
 };
 
 static char *
Index: iptables/extensions/libxt_owner.c
===================================================================
--- iptables.orig/extensions/libxt_owner.c
+++ iptables/extensions/libxt_owner.c
@@ -81,7 +81,7 @@ static const struct option owner_mt_opts
 #ifdef IPT_OWNER_COMM
 	{.name = "cmd-owner", .has_arg = true, .val = 'c'},
 #endif
-	{ .name = NULL }
+	{},
 };
 
 static const struct option owner_mt6_opts_v0[] = {
@@ -89,14 +89,14 @@ static const struct option owner_mt6_opt
 	{.name = "gid-owner", .has_arg = true, .val = 'g'},
 	{.name = "pid-owner", .has_arg = true, .val = 'p'},
 	{.name = "sid-owner", .has_arg = true, .val = 's'},
-	{ .name = NULL }
+	{},
 };
 
 static const struct option owner_mt_opts[] = {
 	{.name = "uid-owner",     .has_arg = true,  .val = 'u'},
 	{.name = "gid-owner",     .has_arg = true,  .val = 'g'},
 	{.name = "socket-exists", .has_arg = false, .val = 'k'},
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_physdev.c
===================================================================
--- iptables.orig/extensions/libxt_physdev.c
+++ iptables/extensions/libxt_physdev.c
@@ -30,7 +30,7 @@ static const struct option physdev_opts[
 	{ "physdev-is-in", 0, NULL, '3' },
 	{ "physdev-is-out", 0, NULL, '4' },
 	{ "physdev-is-bridged", 0, NULL, '5' },
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_pkttype.c
===================================================================
--- iptables.orig/extensions/libxt_pkttype.c
+++ iptables/extensions/libxt_pkttype.c
@@ -66,7 +66,7 @@ static void pkttype_help(void)
 
 static const struct option pkttype_opts[] = {
 	{"pkt-type", 1, NULL, '1'},
-	{ .name = NULL }
+	{},
 };
 
 static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
Index: iptables/extensions/libxt_quota.c
===================================================================
--- iptables.orig/extensions/libxt_quota.c
+++ iptables/extensions/libxt_quota.c
@@ -13,7 +13,7 @@
 
 static const struct option quota_opts[] = {
 	{"quota", 1, NULL, '1'},
-	{ .name = NULL }
+	{},
 };
 
 /* print usage */
@@ -43,13 +43,13 @@ quota_save(const void *ip, const struct 
 static int
 parse_quota(const char *s, u_int64_t * quota)
 {
-	*quota = strtoull(s, (char **) NULL, 10);
+	*quota = strtoull(s, NULL, 10);
 
 #ifdef DEBUG_XT_QUOTA
 	printf("Quota: %llu\n", *quota);
 #endif
 
-	if (*quota == (u_int64_t)-1)
+	if (*quota == -1)
 		exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
 	else
 		return 1;
Index: iptables/extensions/libxt_rateest.c
===================================================================
--- iptables.orig/extensions/libxt_rateest.c
+++ iptables/extensions/libxt_rateest.c
@@ -55,7 +55,7 @@ static const struct option rateest_opts[
 	{ "rateest-lt",		0, NULL, OPT_RATEEST_LT },
 	{ "rateest-gt",		0, NULL, OPT_RATEEST_GT },
 	{ "rateest-eq",		0, NULL, OPT_RATEEST_EQ },
-	{ .name = NULL }
+	{},
 };
 
 /* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.html */
@@ -81,7 +81,7 @@ static const struct rate_suffix {
 	{ "GBps",	8000000000. },
 	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
 	{ "TBps",	8000000000000. },
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_sctp.c
===================================================================
--- iptables.orig/extensions/libxt_sctp.c
+++ iptables/extensions/libxt_sctp.c
@@ -73,7 +73,7 @@ static const struct option sctp_opts[] =
 	{ .name = "destination-port", .has_arg = 1, .val = '2' },
 	{ .name = "dport", .has_arg = 1, .val = '2' },
 	{ .name = "chunk-types", .has_arg = 1, .val = '3' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_state.c
===================================================================
--- iptables.orig/extensions/libxt_state.c
+++ iptables/extensions/libxt_state.c
@@ -25,7 +25,7 @@ state_help(void)
 
 static const struct option state_opts[] = {
 	{ "state", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static int
Index: iptables/extensions/libxt_statistic.c
===================================================================
--- iptables.orig/extensions/libxt_statistic.c
+++ iptables/extensions/libxt_statistic.c
@@ -27,7 +27,7 @@ static const struct option statistic_opt
 	{ "probability", 1, NULL, '2' },
 	{ "every", 1, NULL, '3' },
 	{ "packet", 1, NULL, '4' },
-	{ .name = NULL }
+	{},
 };
 
 static struct xt_statistic_info *info;
Index: iptables/extensions/libxt_string.c
===================================================================
--- iptables.orig/extensions/libxt_string.c
+++ iptables/extensions/libxt_string.c
@@ -49,7 +49,7 @@ static const struct option string_opts[]
 	{ "algo", 1, NULL, '3' },
 	{ "string", 1, NULL, '4' },
 	{ "hex-string", 1, NULL, '5' },
-	{ .name = NULL }
+	{},
 };
 
 static void string_init(struct xt_entry_match *m)
Index: iptables/extensions/libxt_tcp.c
===================================================================
--- iptables.orig/extensions/libxt_tcp.c
+++ iptables/extensions/libxt_tcp.c
@@ -34,7 +34,7 @@ static const struct option tcp_opts[] = 
 	{ "syn", 0, NULL, '3' },
 	{ "tcp-flags", 1, NULL, '4' },
 	{ "tcp-option", 1, NULL, '5' },
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/libxt_tcpmss.c
===================================================================
--- iptables.orig/extensions/libxt_tcpmss.c
+++ iptables/extensions/libxt_tcpmss.c
@@ -20,7 +20,7 @@ IPTABLES_VERSION);
 
 static const struct option tcpmss_opts[] = {
 	{ "mss", 1, NULL, '1' },
-	{ .name = NULL }
+	{},
 };
 
 static u_int16_t
Index: iptables/extensions/libxt_time.c
===================================================================
--- iptables.orig/extensions/libxt_time.c
+++ iptables/extensions/libxt_time.c
@@ -44,7 +44,7 @@ static const struct option time_opts[] =
 	{"monthdays", true,  NULL, 'm'},
 	{"localtz",   false, NULL, 'l'},
 	{"utc",       false, NULL, 'u'},
-	{ .name = NULL }
+	{},
 };
 
 static void time_help(void)
Index: iptables/extensions/libxt_tos.c
===================================================================
--- iptables.orig/extensions/libxt_tos.c
+++ iptables/extensions/libxt_tos.c
@@ -22,7 +22,7 @@ enum {
 
 static const struct option tos_mt_opts[] = {
 	{.name = "tos", .has_arg = true, .val = 't'},
-	{ .name = NULL }
+	{},
 };
 
 static void tos_mt_help(void)
Index: iptables/extensions/libxt_u32.c
===================================================================
--- iptables.orig/extensions/libxt_u32.c
+++ iptables/extensions/libxt_u32.c
@@ -24,7 +24,7 @@
 
 static const struct option u32_opts[] = {
 	{"u32", 1, NULL, 'u'},
-	{ .name = NULL }
+	{},
 };
 
 static void u32_help(void)
Index: iptables/extensions/libxt_udp.c
===================================================================
--- iptables.orig/extensions/libxt_udp.c
+++ iptables/extensions/libxt_udp.c
@@ -26,7 +26,7 @@ static const struct option udp_opts[] = 
 	{ "sport", 1, NULL, '1' }, /* synonym */
 	{ "destination-port", 1, NULL, '2' },
 	{ "dport", 1, NULL, '2' }, /* synonym */
-	{ .name = NULL }
+	{},
 };
 
 static void
Index: iptables/extensions/tos_values.c
===================================================================
--- iptables.orig/extensions/tos_values.c
+++ iptables/extensions/tos_values.c
@@ -15,7 +15,7 @@ static const struct tos_symbol_info {
 	{IPTOS_RELIABILITY, "Maximize-Reliability"},
 	{IPTOS_MINCOST,     "Minimize-Cost"},
 	{IPTOS_NORMALSVC,   "Normal-Service"},
-	{ .name = NULL }
+	{},
 };
 
 /*
Index: iptables/iptables-xml.c
===================================================================
--- iptables.orig/iptables-xml.c
+++ iptables/iptables-xml.c
@@ -50,11 +50,11 @@ static int verbose = 0;
 /* Whether to combine actions of sequential rules with identical conditions */
 static int combine = 0;
 /* Keeping track of external matches and targets.  */
-static struct option options[] = {
-	{"verbose", 0, 0, 'v'},
-	{"combine", 0, 0, 'c'},
-	{"help", 0, 0, 'h'},
-	{ .name = NULL }
+static const struct option options[] = {
+	{.name = "verbose", .has_arg = false, .val = 'v'},
+	{.name = "combine", .has_arg = false, .val = 'c'},
+	{.name = "help",    .has_arg = false, .val = 'h'},
+	{},
 };
 
 static void
@@ -85,10 +85,10 @@ parse_counters(char *string, struct ipt_
 
 /* global new argv and argc */
 static char *newargv[255];
-static unsigned newargc = 0;
+static unsigned int newargc = 0;
 
 static char *oldargv[255];
-static unsigned oldargc = 0;
+static unsigned int oldargc = 0;
 
 /* arg meta data, were they quoted, frinstance */
 static int newargvattr[255];
@@ -129,7 +129,7 @@ add_argv(char *what, int quoted)
 static void
 free_argv(void)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < newargc; i++) {
 		free(newargv[i]);
@@ -149,7 +149,7 @@ free_argv(void)
 static void
 save_argv(void)
 {
-	unsigned i;
+	unsigned int i;
 
 	for (i = 0; i < oldargc; i++)
 		free(oldargv[i]);
@@ -545,8 +545,8 @@ compareRules(void)
 	   is the case when processing the ACTUAL output of actual iptables-save 
 	   rather than a file merely in a compatable format */
 
-	unsigned old = 0;
-	unsigned new = 0;
+	unsigned int old = 0;
+	unsigned int new = 0;
 
 	int compare = 0;
 
@@ -748,7 +748,7 @@ main(int argc, char *argv[])
 
 			ret = 1;
 		} else if (curTable[0]) {
-			unsigned a;
+			unsigned int a;
 			char *ptr = buffer;
 			char *pcnt = NULL;
 			char *bcnt = NULL;
Index: iptables/xtables.c
===================================================================
--- iptables.orig/xtables.c
+++ iptables/xtables.c
@@ -257,11 +257,11 @@ int service_to_port(const char *name, co
 
 u_int16_t parse_port(const char *port, const char *proto)
 {
-	unsigned portnum;
+	unsigned int portnum;
 
 	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
-	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
-		return (u_int16_t)portnum;
+	    (portnum = service_to_port(port, proto)) != -1)
+		return portnum;
 
 	exit_error(PARAMETER_PROBLEM,
 		   "invalid port/service `%s' specified", port);


