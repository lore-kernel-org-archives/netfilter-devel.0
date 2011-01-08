From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 04/13] src: use C99/POSIX types
Date: Sat,  8 Jan 2011 16:20:05 +0100
Message-ID: <1294500015-10691-5-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32889 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752770Ab1AHPUV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:21 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

"u_int" was a non-standardized extension predating C99 on some platforms.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_LOG.c        |    2 +-
 extensions/libip6t_ah.c         |    8 ++++----
 extensions/libip6t_dst.c        |   10 +++++-----
 extensions/libip6t_frag.c       |    6 +++---
 extensions/libip6t_hbh.c        |   10 +++++-----
 extensions/libip6t_hl.c         |    2 +-
 extensions/libip6t_icmp6.c      |   10 +++++-----
 extensions/libip6t_ipv6header.c |   12 ++++++------
 extensions/libip6t_mh.c         |   10 +++++-----
 extensions/libip6t_rt.c         |    6 +++---
 extensions/libipt_CLUSTERIP.c   |    2 +-
 extensions/libipt_LOG.c         |    2 +-
 extensions/libipt_NETMAP.c      |   10 +++++-----
 extensions/libipt_addrtype.c    |    6 +++---
 extensions/libipt_ah.c          |    6 +++---
 extensions/libipt_icmp.c        |   10 +++++-----
 extensions/libxt_CONNMARK.c     |    4 ++--
 extensions/libxt_DSCP.c         |    2 +-
 extensions/libxt_MARK.c         |    4 ++--
 extensions/libxt_TOS.c          |    4 ++--
 extensions/libxt_connlimit.c    |    8 ++++----
 extensions/libxt_connmark.c     |    2 +-
 extensions/libxt_conntrack.c    |    4 ++--
 extensions/libxt_dccp.c         |   16 ++++++++--------
 extensions/libxt_esp.c          |    6 +++---
 extensions/libxt_hashlimit.c    |   10 +++++-----
 extensions/libxt_iprange.c      |    4 ++--
 extensions/libxt_ipvs.c         |    2 +-
 extensions/libxt_length.c       |    2 +-
 extensions/libxt_limit.c        |   10 +++++-----
 extensions/libxt_mark.c         |    2 +-
 extensions/libxt_multiport.c    |   28 ++++++++++++++--------------
 extensions/libxt_owner.c        |   10 +++++-----
 extensions/libxt_policy.c       |    4 ++--
 extensions/libxt_quota.c        |    2 +-
 extensions/libxt_rateest.c      |    4 ++--
 extensions/libxt_sctp.c         |   14 +++++++-------
 extensions/libxt_tcp.c          |   14 +++++++-------
 extensions/libxt_tcpmss.c       |    4 ++--
 extensions/libxt_tos.c          |    4 ++--
 extensions/libxt_u32.c          |    4 ++--
 extensions/libxt_udp.c          |    6 +++---
 extensions/tos_values.c         |    2 +-
 ip6tables.c                     |   14 +++++++-------
 iptables.c                      |   16 ++++++++--------
 libipq/libipq.c                 |    4 ++--
 libiptc/libip4tc.c              |    4 ++--
 xtables.c                       |   10 +++++-----
 48 files changed, 168 insertions(+), 168 deletions(-)

diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 727ce6a..bb85acb 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -66,7 +66,7 @@ static const struct ip6t_log_names ip6t_log_names[]
     { .name = "warning", .level = LOG_WARNING }
 };
 
-static u_int8_t
+static uint8_t
 parse_level(const char *level)
 {
 	unsigned int lev = -1;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 41c5385..fc17429 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -25,7 +25,7 @@ static const struct option ah_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_ah_spi(const char *spistr, const char *typestr)
 {
 	unsigned long int spi;
@@ -50,7 +50,7 @@ parse_ah_spi(const char *spistr, const char *typestr)
 }
 
 static void
-parse_ah_spis(const char *spistring, u_int32_t *spis)
+parse_ah_spis(const char *spistring, uint32_t *spis)
 {
 	char *buffer;
 	char *cp;
@@ -118,7 +118,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
+print_spis(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
@@ -132,7 +132,7 @@ print_spis(const char *name, u_int32_t min, u_int32_t max,
 }
 
 static void
-print_len(const char *name, u_int32_t len, int invert)
+print_len(const char *name, uint32_t len, int invert)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 9e4875e..f4036f0 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -29,7 +29,7 @@ static const struct option dst_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_opts_num(const char *idstr, const char *typestr)
 {
 	unsigned long int id;
@@ -54,7 +54,7 @@ parse_opts_num(const char *idstr, const char *typestr)
 }
 
 static int
-parse_options(const char *optsstr, u_int16_t *opts)
+parse_options(const char *optsstr, uint16_t *opts)
 {
         char *buffer, *cp, *next, *range;
         unsigned int i;
@@ -164,7 +164,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(unsigned int optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, uint16_t *optsp)
 {
 	unsigned int i;
 
@@ -192,7 +192,7 @@ static void dst_print(const void *ip, const struct xt_entry_match *match,
 	if (optinfo->flags & IP6T_OPTS_OPTS)
 		printf("opts ");
 
-	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
+	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 
 	if (optinfo->flags & IP6T_OPTS_NSTRICT)
 		printf("not-strict ");
@@ -215,7 +215,7 @@ static void dst_save(const void *ip, const struct xt_entry_match *match)
 	if (optinfo->flags & IP6T_OPTS_OPTS)
 		printf("--dst-opts ");
 
-	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
+	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 
 	if (optinfo->flags & IP6T_OPTS_NSTRICT)
 		printf("--dst-not-strict ");
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index dd23cda..fcaa72b 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -31,7 +31,7 @@ static const struct option frag_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_frag_id(const char *idstr, const char *typestr)
 {
 	unsigned long int id;
@@ -56,7 +56,7 @@ parse_frag_id(const char *idstr, const char *typestr)
 }
 
 static void
-parse_frag_ids(const char *idstring, u_int32_t *ids)
+parse_frag_ids(const char *idstring, uint32_t *ids)
 {
 	char *buffer;
 	char *cp;
@@ -149,7 +149,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_ids(const char *name, u_int32_t min, u_int32_t max,
+print_ids(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index cddd615..b706f51 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -31,7 +31,7 @@ static const struct option hbh_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_opts_num(const char *idstr, const char *typestr)
 {
 	unsigned long int id;
@@ -56,7 +56,7 @@ parse_opts_num(const char *idstr, const char *typestr)
 }
 
 static int
-parse_options(const char *optsstr, u_int16_t *opts)
+parse_options(const char *optsstr, uint16_t *opts)
 {
         char *buffer, *cp, *next, *range;
         unsigned int i;
@@ -157,7 +157,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_options(unsigned int optsnr, u_int16_t *optsp)
+print_options(unsigned int optsnr, uint16_t *optsp)
 {
 	unsigned int i;
 
@@ -183,7 +183,7 @@ static void hbh_print(const void *ip, const struct xt_entry_match *match,
 		printf(" ");
 	}
 	if (optinfo->flags & IP6T_OPTS_OPTS) printf("opts ");
-	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
+	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 	if (optinfo->flags & IP6T_OPTS_NSTRICT) printf("not-strict ");
 	if (optinfo->invflags & ~IP6T_OPTS_INV_MASK)
 		printf("Unknown invflags: 0x%X ",
@@ -202,7 +202,7 @@ static void hbh_save(const void *ip, const struct xt_entry_match *match)
 
 	if (optinfo->flags & IP6T_OPTS_OPTS)
 		printf("--hbh-opts ");
-	print_options(optinfo->optsnr, (u_int16_t *)optinfo->opts);
+	print_options(optinfo->optsnr, (uint16_t *)optinfo->opts);
 	if (optinfo->flags & IP6T_OPTS_NSTRICT)
 		printf("--hbh-not-strict ");
 }
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 6e58250..ce4392e 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -27,7 +27,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
                     const void *entry, struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
-	u_int8_t value;
+	uint8_t value;
 
 	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 	value = atoi(optarg);
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index b8a6ec9..2adba82 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -11,8 +11,8 @@
 
 struct icmpv6_names {
 	const char *name;
-	u_int8_t type;
-	u_int8_t code_min, code_max;
+	uint8_t type;
+	uint8_t code_min, code_max;
 };
 
 static const struct icmpv6_names icmpv6_codes[] = {
@@ -90,7 +90,7 @@ static const struct option icmp6_opts[] = {
 };
 
 static void
-parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
+parse_icmpv6(const char *icmpv6type, uint8_t *type, uint8_t code[])
 {
 	static const unsigned int limit = ARRAY_SIZE(icmpv6_codes);
 	unsigned int match = limit;
@@ -174,8 +174,8 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void print_icmpv6type(u_int8_t type,
-			   u_int8_t code_min, u_int8_t code_max,
+static void print_icmpv6type(uint8_t type,
+			   uint8_t code_min, uint8_t code_max,
 			   int invert,
 			   int numeric)
 {
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index d6ce248..d4d64e0 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -26,12 +26,12 @@ on whether they contain certain headers */
  *    /etc/protocols */
 struct pprot {
 	char *name;
-	u_int8_t num;
+	uint8_t num;
 };
 
 struct numflag {
-	u_int8_t proto;
-	u_int8_t flag;
+	uint8_t proto;
+	uint8_t flag;
 };
 
 static const struct pprot chain_protos[] = {
@@ -68,7 +68,7 @@ static const struct numflag chain_flags[] = {
 };
 
 static char *
-proto_to_name(u_int8_t proto, int nolookup)
+proto_to_name(uint8_t proto, int nolookup)
 {
         unsigned int i;
 
@@ -85,7 +85,7 @@ proto_to_name(u_int8_t proto, int nolookup)
         return NULL;
 }
 
-static u_int16_t
+static uint16_t
 name_to_proto(const char *s)
 {
         unsigned int proto=0;
@@ -217,7 +217,7 @@ static void ipv6header_check(unsigned int flags)
 }
 
 static void
-print_header(u_int8_t flags){
+print_header(uint8_t flags){
         int have_flag = 0;
 
         while (flags) {
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 54dd8c6..16cc9ac 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -22,7 +22,7 @@
 
 struct mh_name {
 	const char *name;
-	u_int8_t type;
+	uint8_t type;
 };
 
 static const struct mh_name mh_names[] = {
@@ -100,7 +100,7 @@ static unsigned int name_to_type(const char *name)
 	}
 }
 
-static void parse_mh_types(const char *mhtype, u_int8_t *types)
+static void parse_mh_types(const char *mhtype, uint8_t *types)
 {
 	char *buffer;
 	char *cp;
@@ -148,7 +148,7 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static const char *type_to_name(u_int8_t type)
+static const char *type_to_name(uint8_t type)
 {
 	unsigned int i;
 
@@ -159,7 +159,7 @@ static const char *type_to_name(u_int8_t type)
 	return NULL;
 }
 
-static void print_type(u_int8_t type, int numeric)
+static void print_type(uint8_t type, int numeric)
 {
 	const char *name;
 	if (numeric || !(name = type_to_name(type)))
@@ -168,7 +168,7 @@ static void print_type(u_int8_t type, int numeric)
 		printf("%s", name);
 }
 
-static void print_types(u_int8_t min, u_int8_t max, int invert, int numeric)
+static void print_types(uint8_t min, uint8_t max, int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
 
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index f1a50eb..ec0290c 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -38,7 +38,7 @@ static const struct option rt_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_rt_num(const char *idstr, const char *typestr)
 {
 	unsigned long int id;
@@ -63,7 +63,7 @@ parse_rt_num(const char *idstr, const char *typestr)
 }
 
 static void
-parse_rt_segsleft(const char *idstring, u_int32_t *ids)
+parse_rt_segsleft(const char *idstring, uint32_t *ids)
 {
 	char *buffer;
 	char *cp;
@@ -231,7 +231,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_nums(const char *name, u_int32_t min, u_int32_t max,
+print_nums(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 492eefc..d622e63 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -185,7 +185,7 @@ static char *hashmode2str(enum clusterip_hashmode mode)
 	return retstr;
 }
 
-static char *mac2str(const u_int8_t mac[ETH_ALEN])
+static char *mac2str(const uint8_t mac[ETH_ALEN])
 {
 	static char buf[ETH_ALEN*3];
 	sprintf(buf, "%02X:%02X:%02X:%02X:%02X:%02X",
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 0c41271..097aec8 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -66,7 +66,7 @@ static const struct ipt_log_names ipt_log_names[]
     { .name = "warning", .level = LOG_WARNING }
 };
 
-static u_int8_t
+static uint8_t
 parse_level(const char *level)
 {
 	unsigned int lev = -1;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 09262ba..23731af 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -25,10 +25,10 @@ static void NETMAP_help(void)
 	       NETMAP_opts[0].name);
 }
 
-static u_int32_t
+static uint32_t
 bits2netmask(int bits)
 {
-	u_int32_t netmask, bm;
+	uint32_t netmask, bm;
 
 	if (bits >= 32 || bits < 0)
 		return(~0);
@@ -38,9 +38,9 @@ bits2netmask(int bits)
 }
 
 static int
-netmask2bits(u_int32_t netmask)
+netmask2bits(uint32_t netmask)
 {
-	u_int32_t bm;
+	uint32_t bm;
 	int bits;
 
 	netmask = ntohl(netmask);
@@ -66,7 +66,7 @@ parse_to(char *arg, struct nf_nat_range *range)
 {
 	char *slash;
 	const struct in_addr *ip;
-	u_int32_t netmask;
+	uint32_t netmask;
 	unsigned int bits;
 
 	range->flags |= IP_NAT_RANGE_MAP_IPS;
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 9391b4e..8a64211 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -60,7 +60,7 @@ static void addrtype_help_v1(void)
 }
 
 static int
-parse_type(const char *name, size_t len, u_int16_t *mask)
+parse_type(const char *name, size_t len, uint16_t *mask)
 {
 	int i;
 
@@ -74,7 +74,7 @@ parse_type(const char *name, size_t len, u_int16_t *mask)
 	return 0;
 }
 
-static void parse_types(const char *arg, u_int16_t *mask)
+static void parse_types(const char *arg, uint16_t *mask)
 {
 	const char *comma;
 
@@ -197,7 +197,7 @@ static void addrtype_check_v1(unsigned int flags)
 			   "and --limit-iface-out");
 }
 
-static void print_types(u_int16_t mask)
+static void print_types(uint16_t mask)
 {
 	const char *sep = "";
 	int i;
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 58ed6d1..3369c66 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -22,7 +22,7 @@ static const struct option ah_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_ah_spi(const char *spistr)
 {
 	unsigned long int spi;
@@ -46,7 +46,7 @@ parse_ah_spi(const char *spistr)
 }
 
 static void
-parse_ah_spis(const char *spistring, u_int32_t *spis)
+parse_ah_spis(const char *spistring, uint32_t *spis)
 {
 	char *buffer;
 	char *cp;
@@ -97,7 +97,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
+print_spis(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 28985b9..2204027 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -19,8 +19,8 @@
 
 struct icmp_names {
 	const char *name;
-	u_int8_t type;
-	u_int8_t code_min, code_max;
+	uint8_t type;
+	uint8_t code_min, code_max;
 };
 
 static const struct icmp_names icmp_codes[] = {
@@ -114,7 +114,7 @@ static const struct option icmp_opts[] = {
 };
 
 static void 
-parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
+parse_icmp(const char *icmptype, uint8_t *type, uint8_t code[])
 {
 	static const unsigned int limit = ARRAY_SIZE(icmp_codes);
 	unsigned int match = limit;
@@ -199,8 +199,8 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
-static void print_icmptype(u_int8_t type,
-			   u_int8_t code_min, u_int8_t code_max,
+static void print_icmptype(uint8_t type,
+			   uint8_t code_min, uint8_t code_max,
 			   int invert,
 			   int numeric)
 {
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index 6772877..0d43a0d 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -32,7 +32,7 @@
 struct xt_connmark_target_info {
 	unsigned long mark;
 	unsigned long mask;
-	u_int8_t mode;
+	uint8_t mode;
 };
 
 enum {
@@ -314,7 +314,7 @@ connmark_tg_print(const void *ip, const struct xt_entry_target *target,
 	case XT_CONNMARK_SET:
 		if (info->ctmark == 0)
 			printf("CONNMARK and 0x%x ",
-			       (unsigned int)(u_int32_t)~info->ctmask);
+			       (unsigned int)(uint32_t)~info->ctmask);
 		else if (info->ctmark == info->ctmask)
 			printf("CONNMARK or 0x%x ", info->ctmark);
 		else if (info->ctmask == 0)
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 9a69824..a6280bf 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -108,7 +108,7 @@ static void DSCP_check(unsigned int flags)
 }
 
 static void
-print_dscp(u_int8_t dscp, int numeric)
+print_dscp(uint8_t dscp, int numeric)
 {
  	printf("0x%02x ", dscp);
 }
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 39996d0..e33e0c3 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -23,7 +23,7 @@ enum {
 
 struct xt_mark_target_info_v1 {
 	unsigned long mark;
-	u_int8_t mode;
+	uint8_t mode;
 };
 
 enum {
@@ -259,7 +259,7 @@ static void mark_tg_print(const void *ip, const struct xt_entry_target *target,
 	const struct xt_mark_tginfo2 *info = (const void *)target->data;
 
 	if (info->mark == 0)
-		printf("MARK and 0x%x ", (unsigned int)(u_int32_t)~info->mask);
+		printf("MARK and 0x%x ", (unsigned int)(uint32_t)~info->mask);
 	else if (info->mark == info->mask)
 		printf("MARK or 0x%x ", info->mark);
 	else if (info->mask == 0)
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 9575c05..6ad2216 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -16,7 +16,7 @@
 #include "tos_values.c"
 
 struct ipt_tos_target_info {
-	u_int8_t tos;
+	uint8_t tos;
 };
 
 enum {
@@ -185,7 +185,7 @@ static void tos_tg_print(const void *ip, const struct xt_entry_target *target,
 		return;
 	else if (info->tos_value == 0)
 		printf("TOS and 0x%02x ",
-		       (unsigned int)(u_int8_t)~info->tos_mask);
+		       (unsigned int)(uint8_t)~info->tos_mask);
 	else if (info->tos_value == info->tos_mask)
 		printf("TOS or 0x%02x ", info->tos_value);
 	else if (info->tos_mask == 0)
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index b01d301..0cbcf01 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -32,7 +32,7 @@ static void connlimit_init(struct xt_entry_match *match)
 	memset(info->v6_mask, 0xFF, sizeof(info->v6_mask));
 }
 
-static void prefix_to_netmask(u_int32_t *mask, unsigned int prefix_len)
+static void prefix_to_netmask(uint32_t *mask, unsigned int prefix_len)
 {
 	if (prefix_len == 0) {
 		mask[0] = mask[1] = mask[2] = mask[3] = 0;
@@ -124,7 +124,7 @@ static void connlimit_check(unsigned int flags)
 			"You must specify \"--connlimit-above\"");
 }
 
-static unsigned int count_bits4(u_int32_t mask)
+static unsigned int count_bits4(uint32_t mask)
 {
 	unsigned int bits = 0;
 
@@ -134,10 +134,10 @@ static unsigned int count_bits4(u_int32_t mask)
 	return 32 - bits;
 }
 
-static unsigned int count_bits6(const u_int32_t *mask)
+static unsigned int count_bits6(const uint32_t *mask)
 {
 	unsigned int bits = 0, i;
-	u_int32_t tmp[4];
+	uint32_t tmp[4];
 
 	for (i = 0; i < 4; ++i)
 		for (tmp[i] = ~ntohl(mask[i]); tmp[i] != 0; tmp[i] >>= 1)
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 6bb2689..a953443 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -31,7 +31,7 @@
 
 struct xt_connmark_info {
 	unsigned long mark, mask;
-	u_int8_t invert;
+	uint8_t invert;
 };
 
 enum {
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index dd3fb6f..dcb1771 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -50,9 +50,9 @@ struct xt_conntrack_info {
 	unsigned long expires_min, expires_max;
 
 	/* Flags word */
-	u_int8_t flags;
+	uint8_t flags;
 	/* Inverse flags */
-	u_int8_t invflags;
+	uint8_t invflags;
 };
 
 static void conntrack_mt_help(void)
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 104f46f..84f1536 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -55,7 +55,7 @@ static const struct option dccp_opts[] = {
 
 static void
 parse_dccp_ports(const char *portstring, 
-		 u_int16_t *ports)
+		 uint16_t *ports)
 {
 	char *buffer;
 	char *cp;
@@ -93,10 +93,10 @@ static const char *const dccp_pkt_types[] = {
 	[DCCP_PKT_INVALID]	= "INVALID",
 };
 
-static u_int16_t
+static uint16_t
 parse_dccp_types(const char *typestring)
 {
-	u_int16_t typemask = 0;
+	uint16_t typemask = 0;
 	char *ptr, *buffer;
 
 	buffer = strdup(typestring);
@@ -117,7 +117,7 @@ parse_dccp_types(const char *typestring)
 	return typemask;
 }
 
-static u_int8_t parse_dccp_option(char *optstring)
+static uint8_t parse_dccp_option(char *optstring)
 {
 	unsigned int ret;
 
@@ -201,7 +201,7 @@ port_to_service(int port)
 }
 
 static void
-print_port(u_int16_t port, int numeric)
+print_port(uint16_t port, int numeric)
 {
 	char *service;
 
@@ -212,7 +212,7 @@ print_port(u_int16_t port, int numeric)
 }
 
 static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
+print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
@@ -233,7 +233,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 }
 
 static void
-print_types(u_int16_t types, int inverted, int numeric)
+print_types(uint16_t types, int inverted, int numeric)
 {
 	int have_type = 0;
 
@@ -260,7 +260,7 @@ print_types(u_int16_t types, int inverted, int numeric)
 }
 
 static void
-print_option(u_int8_t option, int invert, int numeric)
+print_option(uint8_t option, int invert, int numeric)
 {
 	if (option || invert)
 		printf("option=%s%u ", invert ? "!" : "", option);
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 070a6a4..b95ae1c 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -24,7 +24,7 @@ static const struct option esp_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int32_t
+static uint32_t
 parse_esp_spi(const char *spistr)
 {
 	unsigned long int spi;
@@ -48,7 +48,7 @@ parse_esp_spi(const char *spistr)
 }
 
 static void
-parse_esp_spis(const char *spistring, u_int32_t *spis)
+parse_esp_spis(const char *spistring, uint32_t *spis)
 {
 	char *buffer;
 	char *cp;
@@ -103,7 +103,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static void
-print_spis(const char *name, u_int32_t min, u_int32_t max,
+print_spis(const char *name, uint32_t min, uint32_t max,
 	    int invert)
 {
 	const char *inv = invert ? "!" : "";
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index fbf19d2..b26628a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -95,11 +95,11 @@ static const struct option hashlimit_mt_opts[] = {
 };
 
 static
-int parse_rate(const char *rate, u_int32_t *val)
+int parse_rate(const char *rate, uint32_t *val)
 {
 	const char *delim;
-	u_int32_t r;
-	u_int32_t mult = 1;  /* Seconds by default. */
+	uint32_t r;
+	uint32_t mult = 1;  /* Seconds by default. */
 
 	delim = strchr(rate, '/');
 	if (delim) {
@@ -475,13 +475,13 @@ static void hashlimit_mt_check(unsigned int flags)
 static const struct rates
 {
 	const char *name;
-	u_int32_t mult;
+	uint32_t mult;
 } rates[] = { { "day", XT_HASHLIMIT_SCALE*24*60*60 },
 	      { "hour", XT_HASHLIMIT_SCALE*60*60 },
 	      { "min", XT_HASHLIMIT_SCALE*60 },
 	      { "sec", XT_HASHLIMIT_SCALE } };
 
-static void print_rate(u_int32_t period)
+static void print_rate(uint32_t period)
 {
 	unsigned int i;
 
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 6b511b5..6565d42 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -21,7 +21,7 @@ struct ipt_iprange_info {
 	struct ipt_iprange dst;
 
 	/* Flags from above */
-	u_int8_t flags;
+	uint8_t flags;
 };
 
 enum {
@@ -74,7 +74,7 @@ iprange_parse_spec(const char *from, const char *to, union nf_inet_addr *range,
 }
 
 static void iprange_parse_range(char *arg, union nf_inet_addr *range,
-				u_int8_t family, const char *optname)
+				uint8_t family, const char *optname)
 {
 	char *dash;
 
diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index 493d975..83de042 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -85,7 +85,7 @@ static int ipvs_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct xt_ipvs_mtinfo *data = (void *)(*match)->data;
 	char *p = NULL;
-	u_int8_t op = 0;
+	uint8_t op = 0;
 
 	if ('0' <= c && c <= '6') {
 		static const int ops[] = {
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index aeba52f..edcb6b5 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -22,7 +22,7 @@ static const struct option length_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int16_t
+static uint16_t
 parse_length(const char *s)
 {
 	unsigned int len;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 3f94e21..350cb24 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -35,11 +35,11 @@ static const struct option limit_opts[] = {
 };
 
 static
-int parse_rate(const char *rate, u_int32_t *val)
+int parse_rate(const char *rate, uint32_t *val)
 {
 	const char *delim;
-	u_int32_t r;
-	u_int32_t mult = 1;  /* Seconds by default. */
+	uint32_t r;
+	uint32_t mult = 1;  /* Seconds by default. */
 
 	delim = strchr(rate, '/');
 	if (delim) {
@@ -122,13 +122,13 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 static const struct rates
 {
 	const char *name;
-	u_int32_t mult;
+	uint32_t mult;
 } rates[] = { { "day", XT_LIMIT_SCALE*24*60*60 },
 	      { "hour", XT_LIMIT_SCALE*60*60 },
 	      { "min", XT_LIMIT_SCALE*60 },
 	      { "sec", XT_LIMIT_SCALE } };
 
-static void print_rate(u_int32_t period)
+static void print_rate(uint32_t period)
 {
 	unsigned int i;
 
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index a2bc4f8..d17a7b2 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -11,7 +11,7 @@
 
 struct xt_mark_info {
 	unsigned long mark, mask;
-	u_int8_t invert;
+	uint8_t invert;
 };
 
 enum {
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index 5b823b6..9ed5931 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -54,7 +54,7 @@ static const struct option multiport_opts[] = {
 };
 
 static char *
-proto_to_name(u_int8_t proto)
+proto_to_name(uint8_t proto)
 {
 	switch (proto) {
 	case IPPROTO_TCP:
@@ -73,7 +73,7 @@ proto_to_name(u_int8_t proto)
 }
 
 static unsigned int
-parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
+parse_multi_ports(const char *portstring, uint16_t *ports, const char *proto)
 {
 	char *buffer, *cp, *next;
 	unsigned int i;
@@ -99,7 +99,7 @@ parse_multi_ports_v1(const char *portstring,
 {
 	char *buffer, *cp, *next, *range;
 	unsigned int i;
-	u_int16_t m;
+	uint16_t m;
 
 	buffer = strdup(portstring);
 	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
@@ -133,7 +133,7 @@ parse_multi_ports_v1(const char *portstring,
 }
 
 static const char *
-check_proto(u_int16_t pnum, u_int8_t invflags)
+check_proto(uint16_t pnum, uint8_t invflags)
 {
 	char *proto;
 
@@ -156,8 +156,8 @@ check_proto(u_int16_t pnum, u_int8_t invflags)
    ate an option */
 static int
 __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
-                  struct xt_entry_match **match, u_int16_t pnum,
-                  u_int8_t invflags)
+                  struct xt_entry_match **match, uint16_t pnum,
+                  uint8_t invflags)
 {
 	const char *proto;
 	struct xt_multiport *multiinfo
@@ -223,8 +223,8 @@ multiport_parse6(int c, char **argv, int invert, unsigned int *flags,
 
 static int
 __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
-                     struct xt_entry_match **match, u_int16_t pnum,
-                     u_int8_t invflags)
+                     struct xt_entry_match **match, uint16_t pnum,
+                     uint8_t invflags)
 {
 	const char *proto;
 	struct xt_multiport_v1 *multiinfo
@@ -292,7 +292,7 @@ static void multiport_check(unsigned int flags)
 }
 
 static char *
-port_to_service(int port, u_int8_t proto)
+port_to_service(int port, uint8_t proto)
 {
 	struct servent *service;
 
@@ -303,7 +303,7 @@ port_to_service(int port, u_int8_t proto)
 }
 
 static void
-print_port(u_int16_t port, u_int8_t protocol, int numeric)
+print_port(uint16_t port, uint8_t protocol, int numeric)
 {
 	char *service;
 
@@ -316,7 +316,7 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
 /* Prints out the matchinfo. */
 static void
 __multiport_print(const struct xt_entry_match *match, int numeric,
-                  u_int16_t proto)
+                  uint16_t proto)
 {
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
@@ -364,7 +364,7 @@ static void multiport_print6(const void *ip_void,
 }
 
 static void __multiport_print_v1(const struct xt_entry_match *match,
-                                 int numeric, u_int16_t proto)
+                                 int numeric, uint16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
@@ -420,7 +420,7 @@ static void multiport_print6_v1(const void *ip_void,
 
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void __multiport_save(const struct xt_entry_match *match,
-                             u_int16_t proto)
+                             uint16_t proto)
 {
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
@@ -462,7 +462,7 @@ static void multiport_save6(const void *ip_void,
 }
 
 static void __multiport_save_v1(const struct xt_entry_match *match,
-                                u_int16_t proto)
+                                uint16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index 867ed49..b9b1104 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -37,7 +37,7 @@ struct ipt_owner_info {
 	pid_t pid;
 	pid_t sid;
 	char comm[16];
-	u_int8_t match, invert;	/* flags */
+	uint8_t match, invert;	/* flags */
 };
 
 struct ip6t_owner_info {
@@ -46,7 +46,7 @@ struct ip6t_owner_info {
 	pid_t pid;
 	pid_t sid;
 	char comm[16];
-	u_int8_t match, invert;	/* flags */
+	uint8_t match, invert;	/* flags */
 };
 
 /*
@@ -353,7 +353,7 @@ static void owner_mt_check(unsigned int flags)
 
 static void
 owner_mt_print_item_v0(const struct ipt_owner_info *info, const char *label,
-                       u_int8_t flag, bool numeric)
+                       uint8_t flag, bool numeric)
 {
 	if (!(info->match & flag))
 		return;
@@ -404,7 +404,7 @@ owner_mt_print_item_v0(const struct ipt_owner_info *info, const char *label,
 
 static void
 owner_mt6_print_item_v0(const struct ip6t_owner_info *info, const char *label,
-                        u_int8_t flag, bool numeric)
+                        uint8_t flag, bool numeric)
 {
 	if (!(info->match & flag))
 		return;
@@ -449,7 +449,7 @@ owner_mt6_print_item_v0(const struct ip6t_owner_info *info, const char *label,
 
 static void
 owner_mt_print_item(const struct xt_owner_match_info *info, const char *label,
-                    u_int8_t flag, bool numeric)
+                    uint8_t flag, bool numeric)
 {
 	if (!(info->match & flag))
 		return;
diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 3ddb3ec..3fea146 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -330,7 +330,7 @@ static void policy_check(unsigned int flags)
 	}
 }
 
-static void print_mode(const char *prefix, u_int8_t mode, int numeric)
+static void print_mode(const char *prefix, uint8_t mode, int numeric)
 {
 	printf("%smode ", prefix);
 
@@ -347,7 +347,7 @@ static void print_mode(const char *prefix, u_int8_t mode, int numeric)
 	}
 }
 
-static void print_proto(const char *prefix, u_int8_t proto, int numeric)
+static void print_proto(const char *prefix, uint8_t proto, int numeric)
 {
 	struct protoent *p = NULL;
 
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index cfd975d..9a88cba 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -39,7 +39,7 @@ quota_save(const void *ip, const struct xt_entry_match *match)
 
 /* parse quota option */
 static int
-parse_quota(const char *s, u_int64_t * quota)
+parse_quota(const char *s, uint64_t * quota)
 {
 	*quota = strtoull(s, NULL, 10);
 
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 6aefb5c..3809fe7 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -84,7 +84,7 @@ static const struct rate_suffix {
 };
 
 static int
-rateest_get_rate(u_int32_t *rate, const char *str)
+rateest_get_rate(uint32_t *rate, const char *str)
 {
 	char *p;
 	double bps = strtod(str, &p);
@@ -318,7 +318,7 @@ rateest_final_check(unsigned int flags)
 }
 
 static void
-rateest_print_rate(u_int32_t rate, int numeric)
+rateest_print_rate(uint32_t rate, int numeric)
 {
 	double tmp = (double)rate*8;
 
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 80406f7..fe010aa 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -28,7 +28,7 @@
 #endif
 
 static void
-print_chunk(u_int32_t chunknum, int numeric);
+print_chunk(uint32_t chunknum, int numeric);
 
 static void sctp_init(struct xt_entry_match *m)
 {
@@ -66,7 +66,7 @@ static const struct option sctp_opts[] = {
 
 static void
 parse_sctp_ports(const char *portstring, 
-		 u_int16_t *ports)
+		 uint16_t *ports)
 {
 	char *buffer;
 	char *cp;
@@ -315,7 +315,7 @@ port_to_service(int port)
 }
 
 static void
-print_port(u_int16_t port, int numeric)
+print_port(uint16_t port, int numeric)
 {
 	char *service;
 
@@ -326,7 +326,7 @@ print_port(u_int16_t port, int numeric)
 }
 
 static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
+print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
@@ -347,7 +347,7 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 }
 
 static void
-print_chunk_flags(u_int32_t chunknum, u_int8_t chunk_flags, u_int8_t chunk_flags_mask)
+print_chunk_flags(uint32_t chunknum, uint8_t chunk_flags, uint8_t chunk_flags_mask)
 {
 	int i;
 
@@ -370,7 +370,7 @@ print_chunk_flags(u_int32_t chunknum, u_int8_t chunk_flags, u_int8_t chunk_flags
 }
 
 static void
-print_chunk(u_int32_t chunknum, int numeric)
+print_chunk(uint32_t chunknum, int numeric)
 {
 	if (numeric) {
 		printf("0x%04X", chunknum);
@@ -387,7 +387,7 @@ print_chunk(u_int32_t chunknum, int numeric)
 static void
 print_chunks(const struct xt_sctp_info *einfo, int numeric)
 {
-	u_int32_t chunk_match_type = einfo->chunk_match_type;
+	uint32_t chunk_match_type = einfo->chunk_match_type;
 	const struct xt_sctp_flag_info *flag_info = einfo->flag_info;
 	int flag_count = einfo->flag_count;
 	int i, j;
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 26e533c..df5077f 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -38,7 +38,7 @@ static const struct option tcp_opts[] = {
 };
 
 static void
-parse_tcp_ports(const char *portstring, u_int16_t *ports)
+parse_tcp_ports(const char *portstring, uint16_t *ports)
 {
 	char *buffer;
 	char *cp;
@@ -115,7 +115,7 @@ parse_tcp_flags(struct xt_tcp *tcpinfo,
 }
 
 static void
-parse_tcp_option(const char *option, u_int8_t *result)
+parse_tcp_option(const char *option, uint8_t *result)
 {
 	unsigned int ret;
 
@@ -223,7 +223,7 @@ port_to_service(int port)
 }
 
 static void
-print_port(u_int16_t port, int numeric)
+print_port(uint16_t port, int numeric)
 {
 	char *service;
 
@@ -234,7 +234,7 @@ print_port(u_int16_t port, int numeric)
 }
 
 static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
+print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
@@ -255,14 +255,14 @@ print_ports(const char *name, u_int16_t min, u_int16_t max,
 }
 
 static void
-print_option(u_int8_t option, int invert, int numeric)
+print_option(uint8_t option, int invert, int numeric)
 {
 	if (option || invert)
 		printf("option=%s%u ", invert ? "!" : "", option);
 }
 
 static void
-print_tcpf(u_int8_t flags)
+print_tcpf(uint8_t flags)
 {
 	int have_flag = 0;
 
@@ -284,7 +284,7 @@ print_tcpf(u_int8_t flags)
 }
 
 static void
-print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
+print_flags(uint8_t mask, uint8_t cmp, int invert, int numeric)
 {
 	if (mask || invert) {
 		printf("flags:%s", invert ? "!" : "");
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 110c60d..8dfbb14 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -22,7 +22,7 @@ static const struct option tcpmss_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static u_int16_t
+static uint16_t
 parse_tcp_mssvalue(const char *mssvalue)
 {
 	unsigned int mssvaluenum;
@@ -36,7 +36,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 
 static void
 parse_tcp_mssvalues(const char *mssvaluestring,
-		    u_int16_t *mss_min, u_int16_t *mss_max)
+		    uint16_t *mss_min, uint16_t *mss_max)
 {
 	char *buffer;
 	char *cp;
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index f78594a..435f68e 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -16,8 +16,8 @@
 #include "tos_values.c"
 
 struct ipt_tos_info {
-	u_int8_t tos;
-	u_int8_t invert;
+	uint8_t tos;
+	uint8_t invert;
 };
 
 enum {
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index 67e6068..054a5b2 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -85,9 +85,9 @@ static void u32_dump(const struct xt_u32 *data)
 }
 
 /* string_to_number() is not quite what we need here ... */
-static u_int32_t parse_number(char **s, int pos)
+static uint32_t parse_number(char **s, int pos)
 {
-	u_int32_t number;
+	uint32_t number;
 	char *end;
 
 	errno  = 0;
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 3006c04..70e939d 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -30,7 +30,7 @@ static const struct option udp_opts[] = {
 };
 
 static void
-parse_udp_ports(const char *portstring, u_int16_t *ports)
+parse_udp_ports(const char *portstring, uint16_t *ports)
 {
 	char *buffer;
 	char *cp;
@@ -110,7 +110,7 @@ port_to_service(int port)
 }
 
 static void
-print_port(u_int16_t port, int numeric)
+print_port(uint16_t port, int numeric)
 {
 	char *service;
 
@@ -121,7 +121,7 @@ print_port(u_int16_t port, int numeric)
 }
 
 static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
+print_ports(const char *name, uint16_t min, uint16_t max,
 	    int invert, int numeric)
 {
 	const char *inv = invert ? "!" : "";
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index a65ef25..129203b 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -82,7 +82,7 @@ static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
 }
 
 static bool tos_try_print_symbolic(const char *prefix,
-    u_int8_t value, u_int8_t mask)
+    uint8_t value, uint8_t mask)
 {
 	const struct tos_symbol_info *symbol;
 
diff --git a/ip6tables.c b/ip6tables.c
index 0284791..84908eb 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -202,11 +202,11 @@ static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
    /etc/protocols */
 struct pprot {
 	const char *name;
-	u_int8_t num;
+	uint8_t num;
 };
 
 static const char *
-proto_to_name(u_int8_t proto, int nolookup)
+proto_to_name(uint8_t proto, int nolookup)
 {
 	unsigned int i;
 
@@ -425,7 +425,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 }
 
 /* These are invalid numbers as upper layer protocol */
-static int is_exthdr(u_int16_t proto)
+static int is_exthdr(uint16_t proto)
 {
 	return (proto == IPPROTO_ROUTING ||
 		proto == IPPROTO_FRAGMENT ||
@@ -468,7 +468,7 @@ parse_target(const char *targetname)
 }
 
 static void
-set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
 	   int invert)
 {
 	if (*options & option)
@@ -489,7 +489,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 }
 
 static void
-print_num(u_int64_t number, unsigned int format)
+print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
 		if (number > 99999) {
@@ -595,7 +595,7 @@ print_firewall(const struct ip6t_entry *fw,
 {
 	const struct xtables_target *target = NULL;
 	const struct ip6t_entry_target *t;
-	u_int8_t flags;
+	uint8_t flags;
 	char buf[BUFSIZ];
 
 	if (!ip6tc_is_chain(targname, handle))
@@ -1029,7 +1029,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 }
 
 /* The ip6tables looks up the /etc/protocols. */
-static void print_proto(u_int16_t proto, int invert)
+static void print_proto(uint16_t proto, int invert)
 {
 	if (proto) {
 		unsigned int i;
diff --git a/iptables.c b/iptables.c
index 342ea04..6549c1d 100644
--- a/iptables.c
+++ b/iptables.c
@@ -214,7 +214,7 @@ int kernel_version;
 #endif
 
 static const char *
-proto_to_name(u_int8_t proto, int nolookup)
+proto_to_name(uint8_t proto, int nolookup)
 {
 	unsigned int i;
 
@@ -472,7 +472,7 @@ parse_target(const char *targetname)
 }
 
 static void
-set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
+set_option(unsigned int *options, unsigned int option, uint8_t *invflg,
 	   int invert)
 {
 	if (*options & option)
@@ -493,7 +493,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 }
 
 static void
-print_num(u_int64_t number, unsigned int format)
+print_num(uint64_t number, unsigned int format)
 {
 	if (format & FMT_KILOMEGAGIGA) {
 		if (number > 99999) {
@@ -599,7 +599,7 @@ print_firewall(const struct ipt_entry *fw,
 {
 	const struct xtables_target *target = NULL;
 	const struct ipt_entry_target *t;
-	u_int8_t flags;
+	uint8_t flags;
 	char buf[BUFSIZ];
 
 	if (!iptc_is_chain(targname, handle))
@@ -1002,7 +1002,7 @@ list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
 	return found;
 }
 
-static void print_proto(u_int16_t proto, int invert)
+static void print_proto(uint16_t proto, int invert)
 {
 	if (proto) {
 		unsigned int i;
@@ -1085,10 +1085,10 @@ static int print_match_save(const struct ipt_entry_match *e,
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(const char *prefix, u_int32_t ip,
-		     u_int32_t mask, int invert)
+static void print_ip(const char *prefix, uint32_t ip,
+		     uint32_t mask, int invert)
 {
-	u_int32_t bits, hmask = ntohl(mask);
+	uint32_t bits, hmask = ntohl(mask);
 	int i;
 
 	if (!mask && !ip && !invert)
diff --git a/libipq/libipq.c b/libipq/libipq.c
index 620cc2d..e330487 100644
--- a/libipq/libipq.c
+++ b/libipq/libipq.c
@@ -206,7 +206,7 @@ static char *ipq_strerror(int errcode)
 /*
  * Create and initialise an ipq handle.
  */
-struct ipq_handle *ipq_create_handle(u_int32_t flags, u_int32_t protocol)
+struct ipq_handle *ipq_create_handle(uint32_t flags, uint32_t protocol)
 {
 	int status;
 	struct ipq_handle *h;
@@ -267,7 +267,7 @@ int ipq_destroy_handle(struct ipq_handle *h)
 }
 
 int ipq_set_mode(const struct ipq_handle *h,
-                 u_int8_t mode, size_t range)
+                 uint8_t mode, size_t range)
 {
 	struct {
 		struct nlmsghdr nlh;
diff --git a/libiptc/libip4tc.c b/libiptc/libip4tc.c
index 0c64ac8..c1d78e2 100644
--- a/libiptc/libip4tc.c
+++ b/libiptc/libip4tc.c
@@ -220,8 +220,8 @@ unconditional(const struct ipt_ip *ip)
 {
 	unsigned int i;
 
-	for (i = 0; i < sizeof(*ip)/sizeof(u_int32_t); i++)
-		if (((u_int32_t *)ip)[i])
+	for (i = 0; i < sizeof(*ip)/sizeof(uint32_t); i++)
+		if (((uint32_t *)ip)[i])
 			return 0;
 
 	return 1;
diff --git a/xtables.c b/xtables.c
index 2137c98..566b5c3 100644
--- a/xtables.c
+++ b/xtables.c
@@ -438,7 +438,7 @@ int xtables_service_to_port(const char *name, const char *proto)
 	return -1;
 }
 
-u_int16_t xtables_parse_port(const char *port, const char *proto)
+uint16_t xtables_parse_port(const char *port, const char *proto)
 {
 	unsigned int portnum;
 
@@ -669,7 +669,7 @@ xtables_find_target(const char *name, enum xtables_tryload tryload)
 	return ptr;
 }
 
-static int compatible_revision(const char *name, u_int8_t revision, int opt)
+static int compatible_revision(const char *name, uint8_t revision, int opt)
 {
 	struct xt_get_revision rev;
 	socklen_t s = sizeof(rev);
@@ -717,12 +717,12 @@ static int compatible_revision(const char *name, u_int8_t revision, int opt)
 }
 
 
-static int compatible_match_revision(const char *name, u_int8_t revision)
+static int compatible_match_revision(const char *name, uint8_t revision)
 {
 	return compatible_revision(name, revision, afinfo->so_rev_match);
 }
 
-static int compatible_target_revision(const char *name, u_int8_t revision)
+static int compatible_target_revision(const char *name, uint8_t revision)
 {
 	return compatible_revision(name, revision, afinfo->so_rev_target);
 }
@@ -1688,7 +1688,7 @@ const struct xtables_pprot xtables_chain_protos[] = {
 	{NULL},
 };
 
-u_int16_t
+uint16_t
 xtables_parse_protocol(const char *s)
 {
 	unsigned int proto;
-- 
1.7.1

