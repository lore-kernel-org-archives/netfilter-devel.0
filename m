From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] libxtables: prefix exit_error to xtables_error
Date: Sat, 21 Feb 2009 04:18:01 +0100
Message-ID: <1235186284-31661-4-git-send-email-jengelh@medozas.de>
References: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org, hadi@cyberus.ca
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37808 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbZBUDSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 22:18:07 -0500
In-Reply-To: <1235186284-31661-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/dscp_helper.c        |    4 +-
 extensions/expr                 |  179 +++++++++++++++++++++++++++++++++++++++
 extensions/libip6t_HL.c         |   14 ++--
 extensions/libip6t_LOG.c        |   26 +++---
 extensions/libip6t_REJECT.c     |    4 +-
 extensions/libip6t_ah.c         |   12 ++--
 extensions/libip6t_dst.c        |   24 +++---
 extensions/libip6t_frag.c       |   18 ++--
 extensions/libip6t_hbh.c        |   24 +++---
 extensions/libip6t_hl.c         |   10 +-
 extensions/libip6t_icmp6.c      |   10 +-
 extensions/libip6t_ipv6header.c |   12 ++--
 extensions/libip6t_mh.c         |    6 +-
 extensions/libip6t_policy.c     |   52 ++++++------
 extensions/libip6t_rt.c         |   32 ++++----
 extensions/libipt_CLUSTERIP.c   |   38 ++++----
 extensions/libipt_DNAT.c        |   22 +++---
 extensions/libipt_ECN.c         |   16 ++--
 extensions/libipt_LOG.c         |   26 +++---
 extensions/libipt_MASQUERADE.c  |   10 +-
 extensions/libipt_NETMAP.c      |   14 ++--
 extensions/libipt_REDIRECT.c    |   12 ++--
 extensions/libipt_REJECT.c      |    4 +-
 extensions/libipt_SAME.c        |   14 ++--
 extensions/libipt_SET.c         |   10 +-
 extensions/libipt_SNAT.c        |   22 +++---
 extensions/libipt_TTL.c         |   14 ++--
 extensions/libipt_ULOG.c        |   26 +++---
 extensions/libipt_addrtype.c    |   22 +++---
 extensions/libipt_ah.c          |    8 +-
 extensions/libipt_ecn.c         |   10 +-
 extensions/libipt_icmp.c        |    8 +-
 extensions/libipt_policy.c      |   52 ++++++------
 extensions/libipt_realm.c       |    6 +-
 extensions/libipt_set.c         |    8 +-
 extensions/libipt_set.h         |   18 ++--
 extensions/libipt_ttl.c         |   14 ++--
 extensions/libxt_CLASSIFY.c     |    6 +-
 extensions/libxt_CONNMARK.c     |   20 ++--
 extensions/libxt_CONNSECMARK.c  |   10 +-
 extensions/libxt_DSCP.c         |   10 +-
 extensions/libxt_MARK.c         |   16 ++--
 extensions/libxt_NFLOG.c        |   24 +++---
 extensions/libxt_NFQUEUE.c      |    4 +-
 extensions/libxt_RATEEST.c      |   20 ++--
 extensions/libxt_SECMARK.c      |    8 +-
 extensions/libxt_TCPMSS.c       |    8 +-
 extensions/libxt_TCPOPTSTRIP.c  |   10 +-
 extensions/libxt_TOS.c          |    4 +-
 extensions/libxt_TPROXY.c       |    2 +-
 extensions/libxt_comment.c      |    6 +-
 extensions/libxt_connbytes.c    |   10 +-
 extensions/libxt_connlimit.c    |   10 +-
 extensions/libxt_connmark.c     |    4 +-
 extensions/libxt_conntrack.c    |   54 ++++++------
 extensions/libxt_dccp.c         |   14 ++--
 extensions/libxt_dscp.c         |   10 +-
 extensions/libxt_esp.c          |   10 +-
 extensions/libxt_hashlimit.c    |   32 ++++----
 extensions/libxt_helper.c       |    4 +-
 extensions/libxt_iprange.c      |   10 +-
 extensions/libxt_length.c       |    8 +-
 extensions/libxt_limit.c        |   10 +-
 extensions/libxt_mac.c          |    6 +-
 extensions/libxt_mark.c         |    4 +-
 extensions/libxt_multiport.c    |   26 +++---
 extensions/libxt_owner.c        |    4 +-
 extensions/libxt_physdev.c      |    4 +-
 extensions/libxt_pkttype.c      |    4 +-
 extensions/libxt_quota.c        |    6 +-
 extensions/libxt_rateest.c      |   44 +++++-----
 extensions/libxt_recent.c       |   12 ++--
 extensions/libxt_sctp.c         |   18 ++--
 extensions/libxt_state.c        |    8 +-
 extensions/libxt_statistic.c    |   32 ++++----
 extensions/libxt_string.c       |   38 ++++----
 extensions/libxt_tcp.c          |   18 ++--
 extensions/libxt_tcpmss.c       |    6 +-
 extensions/libxt_time.c         |   36 ++++----
 extensions/libxt_tos.c          |    4 +-
 extensions/libxt_u32.c          |   30 +++---
 extensions/libxt_udp.c          |    6 +-
 extensions/tos_values.c         |    6 +-
 include/xtables.h.in            |    2 +-
 ip6tables-restore.c             |   26 +++---
 ip6tables-save.c                |    8 +-
 ip6tables.c                     |   72 ++++++++--------
 iptables-restore.c              |   26 +++---
 iptables-save.c                 |    8 +-
 iptables-xml.c                  |   16 ++--
 iptables.c                      |   76 ++++++++--------
 91 files changed, 925 insertions(+), 746 deletions(-)
 create mode 100644 extensions/expr

diff --git a/extensions/dscp_helper.c b/extensions/dscp_helper.c
index 217df09..8fa0f4a 100644
--- a/extensions/dscp_helper.c
+++ b/extensions/dscp_helper.c
@@ -57,7 +57,7 @@ class_to_dscp(const char *name)
 			return ds_classes[i].dscp;
 	}
 
-	exit_error(PARAMETER_PROBLEM,
+	xtables_error(PARAMETER_PROBLEM,
 			"Invalid DSCP value `%s'\n", name);
 }
 
@@ -74,7 +74,7 @@ dscp_to_name(unsigned int dscp)
 	}
 
 
-	exit_error(PARAMETER_PROBLEM,
+	xtables_error(PARAMETER_PROBLEM,
 			"Invalid DSCP value `%d'\n", dscp);
 }
 #endif
diff --git a/extensions/expr b/extensions/expr
new file mode 100644
index 0000000..f00b70d
--- /dev/null
+++ b/extensions/expr
@@ -0,0 +1,179 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <libHX/option.h>
+
+enum ttl_rel {
+	REL_EQ,
+	REL_LT,
+	REL_GT,
+};
+
+static bool ttl_inv;
+static uint8_t ttl_value;
+static unsigned int ttl_rel;
+
+/**
+ * @name:	name of the option
+ * @act:	pointer to variable to indicate the action
+ */
+struct edesc {
+	const char *name;
+	unsigned int *act;
+};
+
+static const struct HXoption ttl_options[] = {
+	{.name = "ttl-eq", .act = &ttl_rel, .avl = TTL_EQ,
+	 .type = XTO_UINT8, .ptr = &ttl_value,
+	 .inv = &ttl_inv, .opt_id = 0x01, .opt_conflict = 0xFF,
+	 .help = "Match time to live value"},
+	{.ln = "ttl-lt", .type = XTO_UINT8, .ptr = &ttl_value,
+	 .inv = &ttl_inv, .optid = 0x02, .optconflict = 0xFF,
+	 .help = "Match TTL < value"},
+	{.ln = "ttl-gt", .type = XTO_UINT8, .ptr = &ttl_value,
+	 .val = TTL_GT,
+	 .help = "Match TTL > value"},
+	HXOPT_TABLEEND,
+};
+
+static const char *const ttl_relsym[] = {"=", "<", ">"};
+
+static int ttl_mt_expr(void)
+{
+	snprintf(exprbuf, sizeof(exprbuf), "*8(nh+1)%s%hhu", ttl_relsym, ttl_rel);
+}
+
+static struct expr_expander ttl_reg[] = {
+	{.name = "ttl", .build_expr = ttl_mt_expr},
+	{.name = "TTL", .build_expr = ttl_tg_expr},
+};
+
+
+			if (invert)
+				info->mode = IPT_TTL_NE;
+			else
+				info->mode = IPT_TTL_EQ;
+
+			/* is 0 allowed? */
+			info->ttl = value;
+			break;
+		case '3':
+			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
+				exit_error(PARAMETER_PROBLEM,
+				           "ttl: Expected value between 0 and 255");
+
+			if (invert) 
+				exit_error(PARAMETER_PROBLEM,
+						"ttl: unexpected `!'");
+
+			info->mode = IPT_TTL_LT;
+			info->ttl = value;
+			break;
+		case '4':
+			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
+				exit_error(PARAMETER_PROBLEM,
+				           "ttl: Expected value between 0 and 255");
+
+			if (invert)
+				exit_error(PARAMETER_PROBLEM,
+						"ttl: unexpected `!'");
+
+			info->mode = IPT_TTL_GT;
+			info->ttl = value;
+			break;
+		default:
+			return 0;
+
+	}
+
+	if (*flags) 
+		exit_error(PARAMETER_PROBLEM, 
+				"Can't specify TTL option twice");
+	*flags = 1;
+
+	return 1;
+}
+
+static void ttl_check(unsigned int flags)
+{
+	if (!flags) 
+		exit_error(PARAMETER_PROBLEM,
+			"TTL match: You must specify one of "
+			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
+}
+
+static void ttl_print(const void *ip, const struct xt_entry_match *match,
+                      int numeric)
+{
+	const struct ipt_ttl_info *info = 
+		(struct ipt_ttl_info *) match->data;
+
+	printf("TTL match ");
+	switch (info->mode) {
+		case IPT_TTL_EQ:
+			printf("TTL == ");
+			break;
+		case IPT_TTL_NE:
+			printf("TTL != ");
+			break;
+		case IPT_TTL_LT:
+			printf("TTL < ");
+			break;
+		case IPT_TTL_GT:
+			printf("TTL > ");
+			break;
+	}
+	printf("%u ", info->ttl);
+}
+
+static void ttl_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct ipt_ttl_info *info =
+		(struct ipt_ttl_info *) match->data;
+
+	switch (info->mode) {
+		case IPT_TTL_EQ:
+			printf("--ttl-eq ");
+			break;
+		case IPT_TTL_NE:
+			printf("! --ttl-eq ");
+			break;
+		case IPT_TTL_LT:
+			printf("--ttl-lt ");
+			break;
+		case IPT_TTL_GT:
+			printf("--ttl-gt ");
+			break;
+		default:
+			/* error */
+			break;
+	}
+	printf("%u ", info->ttl);
+}
+
+static const struct option ttl_opts[] = {
+	{ "ttl", 1, NULL, '2' },
+	{ "ttl-eq", 1, NULL, '2'},
+	{ "ttl-lt", 1, NULL, '3'},
+	{ "ttl-gt", 1, NULL, '4'},
+	{ .name = NULL }
+};
+
+static struct xtables_match ttl_mt_reg = {
+	.name		= "ttl",
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV4,
+	.size		= XT_ALIGN(sizeof(struct ipt_ttl_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct ipt_ttl_info)),
+	.help		= ttl_help,
+	.parse		= ttl_parse,
+	.final_check	= ttl_check,
+	.print		= ttl_print,
+	.save		= ttl_save,
+	.extra_opts	= ttl_opts,
+};
+
+
+void _init(void) 
+{
+	xtables_register_match(&ttl_mt_reg);
+}
diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 0a98713..ee117f1 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -32,20 +32,20 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 	unsigned int value;
 
 	if (*flags & IP6T_HL_USED) {
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"Can't specify HL option twice");
 	}
 
 	if (!optarg) 
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"HL: You must specify a value");
 
 	if (xtables_check_inverse(optarg, &invert, NULL, 0))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"HL: unexpected `!'");
 	
 	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM,	
+		xtables_error(PARAMETER_PROBLEM,
 		           "HL: Expected value between 0 and 255");
 
 	switch (c) {
@@ -56,7 +56,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case '2':
 			if (value == 0) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"HL: decreasing by 0?");
 			}
 
@@ -65,7 +65,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case '3':
 			if (value == 0) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"HL: increasing by 0?");
 			}
 
@@ -86,7 +86,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 static void HL_check(unsigned int flags)
 {
 	if (!(flags & IP6T_HL_USED))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"HL: You must specify an action");
 }
 
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 7987735..c6bf2a7 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -79,7 +79,7 @@ parse_level(const char *level)
 			if (strncasecmp(level, ip6t_log_names[i].name,
 					strlen(level)) == 0) {
 				if (set++)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "log-level `%s' ambiguous",
 						   level);
 				lev = ip6t_log_names[i].level;
@@ -87,7 +87,7 @@ parse_level(const char *level)
 		}
 
 		if (!set)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "log-level `%s' unknown", level);
 	}
 
@@ -109,11 +109,11 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '!':
 		if (*flags & IP6T_LOG_OPT_LEVEL)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
 		loginfo->level = parse_level(optarg);
@@ -122,24 +122,24 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '#':
 		if (*flags & IP6T_LOG_OPT_PREFIX)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
 		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Maximum prefix length %u for --log-prefix",
 				   (unsigned int)sizeof(loginfo->prefix) - 1);
 
 		if (strlen(optarg) == 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "No prefix specified for --log-prefix");
 
 		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
 
 		strcpy(loginfo->prefix, optarg);
@@ -148,7 +148,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '1':
 		if (*flags & IP6T_LOG_OPT_TCPSEQ)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-sequence "
 				   "twice");
 
@@ -158,7 +158,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & IP6T_LOG_OPT_TCPOPT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-options twice");
 
 		loginfo->logflags |= IP6T_LOG_TCPOPT;
@@ -167,7 +167,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		if (*flags & IP6T_LOG_OPT_IPOPT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-ip-options twice");
 
 		loginfo->logflags |= IP6T_LOG_IPOPT;
@@ -176,7 +176,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '4':
 		if (*flags & IP6T_LOG_OPT_UID)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-uid twice");
 
 		loginfo->logflags |= IP6T_LOG_UID;
diff --git a/extensions/libip6t_REJECT.c b/extensions/libip6t_REJECT.c
index 1c2be68..94013ec 100644
--- a/extensions/libip6t_REJECT.c
+++ b/extensions/libip6t_REJECT.c
@@ -86,7 +86,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch(c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < limit; i++) {
 			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
@@ -95,7 +95,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 				return 1;
 			}
 		}
-		exit_error(PARAMETER_PROBLEM, "unknown reject type `%s'",optarg);
+		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
 	default:
 		/* Fall through */
 		break;
diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 83ed451..19b7ad4 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -33,16 +33,16 @@ parse_ah_spi(const char *spistr, const char *typestr)
 	spi = strtoul(spistr, &ep, 0);
 
 	if ( spistr == ep )
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "AH no valid digits in %s `%s'", typestr, spistr);
 
 	if ( spi == ULONG_MAX  && errno == ERANGE )
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, spistr);
 
 	if ( *spistr != '\0'  && *ep != '\0' )
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "AH error parsing %s `%s'", typestr, spistr);
 
 	return spi;
@@ -84,7 +84,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IP6T_AH_SPI)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
@@ -94,7 +94,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IP6T_AH_LEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahlen' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		ahinfo->hdrlen = parse_ah_spi(argv[optind-1], "length");
@@ -104,7 +104,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IP6T_AH_RES)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahres' allowed");
 		ahinfo->hdrres = 1;
 		*flags |= IP6T_AH_RES;
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index e19abc4..a47e3a3 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -37,16 +37,16 @@ parse_opts_num(const char *idstr, const char *typestr)
 	id = strtoul(idstr, &ep, 0);
 
 	if ( idstr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "dst: no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}
 	if ( *idstr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "dst: error parsing %s `%s'", typestr, idstr);
 	}
 	return id;
@@ -60,7 +60,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 	
 	buffer = strdup(optsstr);
         if (!buffer)
-		exit_error(OTHER_PROBLEM, "strdup failed");
+		xtables_error(OTHER_PROBLEM, "strdup failed");
 			
         for (cp = buffer, i = 0; cp && i < IP6T_OPTS_OPTSNR; cp = next, i++)
         {
@@ -73,7 +73,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 
                 if (range) {
                         if (i == IP6T_OPTS_OPTSNR-1)
-                                exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
                                            "too many ports specified");
                         *range++ = '\0';
                 }
@@ -81,7 +81,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
-        			exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"PAD0 hasn't got length");
 			opts[i] |= parse_opts_num(range, "length") & 0xFF;
                 } else
@@ -94,7 +94,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 	}
 
         if (cp)
-		exit_error(PARAMETER_PROBLEM, "too many addresses specified");
+		xtables_error(PARAMETER_PROBLEM, "too many addresses specified");
 
 	free(buffer);
 
@@ -123,7 +123,7 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IP6T_OPTS_LEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
@@ -134,11 +134,11 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IP6T_OPTS_OPTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-opts' allowed");
                 xtables_check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
-                        exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--dst-opts'");
 		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
@@ -146,10 +146,10 @@ static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IP6T_OPTS_NSTRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dst-not-strict' allowed");
 		if ( !(*flags & IP6T_OPTS_OPTS) )
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "`--dst-opts ...' required before "
 				   "`--dst-not-strict'");
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index b55ef26..905b494 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -39,16 +39,16 @@ parse_frag_id(const char *idstr, const char *typestr)
 	id = strtoul(idstr, &ep, 0);
 
 	if ( idstr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "FRAG no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}	
 	if ( *idstr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "FRAG error parsing %s `%s'", typestr, idstr);
 	}
 	return id;
@@ -92,7 +92,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IP6T_FRAG_IDS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fragid' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_frag_ids(argv[optind-1], fraginfo->ids);
@@ -103,7 +103,7 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IP6T_FRAG_LEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fraglen' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		fraginfo->hdrlen = parse_frag_id(argv[optind-1], "length");
@@ -114,28 +114,28 @@ static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IP6T_FRAG_RES)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fragres' allowed");
 		fraginfo->flags |= IP6T_FRAG_RES;
 		*flags |= IP6T_FRAG_RES;
 		break;
 	case '4':
 		if (*flags & IP6T_FRAG_FST)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--fragfirst' allowed");
 		fraginfo->flags |= IP6T_FRAG_FST;
 		*flags |= IP6T_FRAG_FST;
 		break;
 	case '5':
 		if (*flags & (IP6T_FRAG_MF|IP6T_FRAG_NMF)) 
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			   "Only one `--fragmore' or `--fraglast' allowed");
 		fraginfo->flags |= IP6T_FRAG_MF;
 		*flags |= IP6T_FRAG_MF;
 		break;
 	case '6':
 		if (*flags & (IP6T_FRAG_MF|IP6T_FRAG_NMF)) 
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			   "Only one `--fragmore' or `--fraglast' allowed");
 		fraginfo->flags |= IP6T_FRAG_NMF;
 		*flags |= IP6T_FRAG_NMF;
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index 3354eae..e08d84a 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -40,16 +40,16 @@ parse_opts_num(const char *idstr, const char *typestr)
 	id =  strtoul(idstr,&ep,0) ;
 
 	if ( idstr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "hbh: no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}	
 	if ( *idstr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "hbh: error parsing %s `%s'", typestr, idstr);
 	}
 	return id;
@@ -62,7 +62,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
         unsigned int i;
 	
 	buffer = strdup(optsstr);
-        if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
 			
         for (cp=buffer, i=0; cp && i<IP6T_OPTS_OPTSNR; cp=next,i++)
         {
@@ -71,14 +71,14 @@ parse_options(const char *optsstr, u_int16_t *opts)
                 range = strchr(cp, ':');
                 if (range) {
                         if (i == IP6T_OPTS_OPTSNR-1)
-                                exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
                                            "too many ports specified");
                         *range++ = '\0';
                 }
 		opts[i] = (parse_opts_num(cp, "opt") & 0xFF) << 8;
                 if (range) {
 			if (opts[i] == 0)
-        			exit_error(PARAMETER_PROBLEM, "PAD0 hasn't got length");
+				xtables_error(PARAMETER_PROBLEM, "PAD0 has not got length");
 			opts[i] |= parse_opts_num(range, "length") & 0xFF;
                 } else {
                         opts[i] |= (0x00FF);
@@ -89,7 +89,7 @@ parse_options(const char *optsstr, u_int16_t *opts)
 		printf("opts opt: %04X\n", opts[i]);
 #endif
 	}
-        if (cp) exit_error(PARAMETER_PROBLEM, "too many addresses specified");
+	if (cp) xtables_error(PARAMETER_PROBLEM, "too many addresses specified");
 
 	free(buffer);
 
@@ -118,7 +118,7 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IP6T_OPTS_LEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		optinfo->hdrlen = parse_opts_num(argv[optind-1], "length");
@@ -129,11 +129,11 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IP6T_OPTS_OPTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-opts' allowed");
                 xtables_check_inverse(optarg, &invert, &optind, 0);
                 if (invert)
-                        exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				" '!' not allowed with `--hbh-opts'");
 		optinfo->optsnr = parse_options(argv[optind-1], optinfo->opts);
 		optinfo->flags |= IP6T_OPTS_OPTS;
@@ -141,10 +141,10 @@ static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IP6T_OPTS_NSTRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--hbh-not-strict' allowed");
 		if ( !(*flags & IP6T_OPTS_OPTS) )
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "`--hbh-opts ...' required before `--hbh-not-strict'");
 		optinfo->flags |= IP6T_OPTS_NSTRICT;
 		*flags |= IP6T_OPTS_NSTRICT;
diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 286f432..2280e03 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -34,11 +34,11 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 	value = atoi(argv[optind-1]);
 
 	if (*flags) 
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"Can't specify HL option twice");
 
 	if (!optarg)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"hl: You must specify a value");
 	switch (c) {
 		case '2':
@@ -54,7 +54,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 		case '3':
 			if (invert) 
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 						"hl: unexpected `!'");
 
 			info->mode = IP6T_HL_LT;
@@ -64,7 +64,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 		case '4':
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 						"hl: unexpected `!'");
 
 			info->mode = IP6T_HL_GT;
@@ -82,7 +82,7 @@ static int hl_parse(int c, char **argv, int invert, unsigned int *flags,
 static void hl_check(unsigned int flags)
 {
 	if (!flags) 
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"HL match: You must specify one of "
 			"`--hl-eq', `--hl-lt', `--hl-gt'");
 }
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 5af9b02..69171d1 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -98,7 +98,7 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 		if (strncasecmp(icmpv6_codes[i].name, icmpv6type, strlen(icmpv6type))
 		    == 0) {
 			if (match != limit)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Ambiguous ICMPv6 type `%s':"
 					   " `%s' or `%s'?",
 					   icmpv6type,
@@ -124,12 +124,12 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 			*slash = '\0';
 
 		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid ICMPv6 type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
 			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Invalid ICMPv6 code `%s'\n",
 					   slash+1);
 			code[0] = code[1] = number;
@@ -155,7 +155,7 @@ static int icmp6_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags == 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "icmpv6 match: only use --icmpv6-type once!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
@@ -240,7 +240,7 @@ static void icmp6_save(const void *ip, const struct xt_entry_match *match)
 static void icmp6_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "icmpv6 match: You must specify `--icmpv6-type'");
 }
 
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index 982e6a7..296bd5f 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -105,7 +105,7 @@ name_to_proto(const char *s)
         	}
 
         	if (i == sizeof(chain_protos)/sizeof(struct pprot))
-        		exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
         			"unknown header `%s' specified",
         			s);
         }
@@ -127,7 +127,7 @@ add_proto_to_mask(int proto){
 	}
 
 	if (i == sizeof(chain_flags)/sizeof(struct numflag))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		"unknown header `%d' specified",
 		proto);
 	
@@ -189,13 +189,13 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 		case '1' : 
 			/* Parse the provided header names */
 			if (*flags & IPV6_HDR_HEADER)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"Only one `--header' allowed");
 
 			xtables_check_inverse(optarg, &invert, &optind, 0);
 
 			if (! (info->matchflags = parse_header(argv[optind-1])) )
-				exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
+				xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: cannot parse header names");
 
 			if (invert) 
 				info->invflags |= 0xFF;
@@ -204,7 +204,7 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 		case '2' : 
 			/* Soft-mode requested? */
 			if (*flags & IPV6_HDR_SOFT)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"Only one `--soft' allowed");
 
 			info->modeflag |= 0xFF;
@@ -219,7 +219,7 @@ ipv6header_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void ipv6header_check(unsigned int flags)
 {
-	if (!flags) exit_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no options specified");
+	if (!flags) xtables_error(PARAMETER_PROBLEM, "ip6t_ipv6header: no options specified");
 }
 
 static void
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 78fc804..f476c93 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -94,7 +94,7 @@ static unsigned int name_to_type(const char *name)
 		unsigned int number;
 
 		if (!xtables_strtoui(name, NULL, &number, 0, UINT8_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid MH type `%s'\n", name);
 		return number;
 	}
@@ -116,7 +116,7 @@ static void parse_mh_types(const char *mhtype, u_int8_t *types)
 		types[1] = cp[0] ? name_to_type(cp) : 0xFF;
 
 		if (types[0] > types[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid MH type range (min > max)");
 	}
 	free(buffer);
@@ -132,7 +132,7 @@ static int mh_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & MH_TYPES)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mh-type' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_mh_types(argv[optind-1], mhinfo->types);
diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 7ea72cd..70f320f 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -130,7 +130,7 @@ static int parse_direction(char *s)
 		return IP6T_POLICY_MATCH_IN;
 	if (strcmp(s, "out") == 0)
 		return IP6T_POLICY_MATCH_OUT;
-	exit_error(PARAMETER_PROBLEM, "policy_match: invalid dir `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy_match: invalid dir \"%s\"", s);
 }
 
 static int parse_policy(char *s)
@@ -139,7 +139,7 @@ static int parse_policy(char *s)
 		return IP6T_POLICY_MATCH_NONE;
 	if (strcmp(s, "ipsec") == 0)
 		return 0;
-	exit_error(PARAMETER_PROBLEM, "policy match: invalid policy `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy match: invalid policy \"%s\"", s);
 }
 
 static int parse_mode(char *s)
@@ -148,7 +148,7 @@ static int parse_mode(char *s)
 		return IP6T_POLICY_MODE_TRANSPORT;
 	if (strcmp(s, "tunnel") == 0)
 		return IP6T_POLICY_MODE_TUNNEL;
-	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
 static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -165,35 +165,35 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --dir option");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --dir option");
 
 		info->flags |= parse_direction(argv[optind-1]);
 		break;
 	case '2':
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --policy option");
 
 		info->flags |= parse_policy(argv[optind-1]);
 		break;
 	case '3':
 		if (info->flags & IP6T_POLICY_MATCH_STRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --strict option");
 
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --strict option");
 
 		info->flags |= IP6T_POLICY_MATCH_STRICT;
 		break;
 	case '4':
 		if (e->match.reqid)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --reqid option");
 
 		e->match.reqid = 1;
@@ -202,7 +202,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '5':
 		if (e->match.spi)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --spi option");
 
 		e->match.spi = 1;
@@ -211,12 +211,12 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '6':
 		if (e->match.saddr)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
 		xtables_ip6parse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
 
 		e->match.saddr = 1;
@@ -226,12 +226,12 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
                 break;
 	case '7':
 		if (e->match.daddr)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
 
 		xtables_ip6parse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
 
 		e->match.daddr = 1;
@@ -241,20 +241,20 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '8':
 		if (e->match.proto)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
 
 		e->proto = xtables_parse_protocol(argv[optind-1]);
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: protocol must ah/esp/ipcomp");
 		e->match.proto = 1;
 		e->invert.proto = invert;
 		break;
 	case '9':
 		if (e->match.mode)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --mode option");
 
 		mode = parse_mode(argv[optind-1]);
@@ -264,11 +264,11 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'a':
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --next option");
 
 		if (++info->len == IP6T_POLICY_MAX_ELEM)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
 	default:
@@ -286,26 +286,26 @@ static void policy_check(unsigned int flags)
 	int i;
 
 	if (info == NULL)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: no parameters given");
 
 	if (!(info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: neither --in nor --out specified");
 
 	if (info->flags & IP6T_POLICY_MATCH_NONE) {
 		if (info->flags & IP6T_POLICY_MATCH_STRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but --strict given");
 
 		if (info->len != 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but policy given");
 	} else
 		info->len++;	/* increase len by 1, no --next after last element */
 
 	if (!(info->flags & IP6T_POLICY_MATCH_STRICT) && info->len > 1)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: multiple elements but no --strict");
 
 	for (i = 0; i < info->len; i++) {
@@ -314,13 +314,13 @@ static void policy_check(unsigned int flags)
                 if (info->flags & IP6T_POLICY_MATCH_STRICT &&
 		    !(e->match.reqid || e->match.spi || e->match.saddr ||
                       e->match.daddr || e->match.proto || e->match.mode))
-                        exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
                                    "policy match: empty policy element");
 
 		if ((e->match.saddr || e->match.daddr)
 		    && ((e->mode == IP6T_POLICY_MODE_TUNNEL && e->invert.mode) ||
 		        (e->mode == IP6T_POLICY_MODE_TRANSPORT && !e->invert.mode)))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: --tunnel-src/--tunnel-dst "
 			           "is only valid in tunnel mode");
 	}
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index 64c98ef..c9bf994 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -46,16 +46,16 @@ parse_rt_num(const char *idstr, const char *typestr)
 	id =  strtoul(idstr,&ep,0) ;
 
 	if ( idstr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "RT no valid digits in %s `%s'", typestr, idstr);
 	}
 	if ( id == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s `%s' specified too big: would overflow",
 			   typestr, idstr);
 	}	
 	if ( *idstr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "RT error parsing %s `%s'", typestr, idstr);
 	}
 	return id;
@@ -98,7 +98,7 @@ numeric_to_addr(const char *num)
 #ifdef DEBUG
 	fprintf(stderr, "\nnumeric2addr: %d\n", err);
 #endif
-        exit_error(PARAMETER_PROBLEM, "bad address: %s", num);
+	xtables_error(PARAMETER_PROBLEM, "bad address: %s", num);
 
 	return (struct in6_addr *)NULL;
 }
@@ -111,7 +111,7 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
         unsigned int i;
 	
 	buffer = strdup(addrstr);
-        if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
 			
         for (cp=buffer, i=0; cp && i<IP6T_RT_HOPS; cp=next,i++)
         {
@@ -124,7 +124,7 @@ parse_addresses(const char *addrstr, struct in6_addr *addrp)
 		printf("addr [%d]: %s\n", i, addr_to_numeric(&(addrp[i])));
 #endif
 	}
-        if (cp) exit_error(PARAMETER_PROBLEM, "too many addresses specified");
+	if (cp) xtables_error(PARAMETER_PROBLEM, "too many addresses specified");
 
 	free(buffer);
 
@@ -156,7 +156,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IP6T_RT_TYP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-type' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		rtinfo->rt_type = parse_rt_num(argv[optind-1], "type");
@@ -167,7 +167,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IP6T_RT_SGS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-segsleft' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_rt_segsleft(argv[optind-1], rtinfo->segsleft);
@@ -178,7 +178,7 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IP6T_RT_LEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-len' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		rtinfo->hdrlen = parse_rt_num(argv[optind-1], "length");
@@ -189,24 +189,24 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '4':
 		if (*flags & IP6T_RT_RES)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-0-res' allowed");
 		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-res'");
 		rtinfo->flags |= IP6T_RT_RES;
 		*flags |= IP6T_RT_RES;
 		break;
 	case '5':
 		if (*flags & IP6T_RT_FST)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-0-addrs' allowed");
 		if ( !(*flags & IP6T_RT_TYP) || (rtinfo->rt_type != 0) || (rtinfo->invflags & IP6T_RT_INV_TYP) )
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-type 0' required before `--rt-0-addrs'");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   " '!' not allowed with `--rt-0-addrs'");
 		rtinfo->addrnr = parse_addresses(argv[optind-1], rtinfo->addrs);
 		rtinfo->flags |= IP6T_RT_FST;
@@ -214,10 +214,10 @@ static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '6':
 		if (*flags & IP6T_RT_FST_NSTRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--rt-0-not-strict' allowed");
 		if ( !(*flags & IP6T_RT_FST) )
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "`--rt-0-addr ...' required before `--rt-0-not-strict'");
 		rtinfo->flags |= IP6T_RT_FST_NSTRICT;
 		*flags |= IP6T_RT_FST_NSTRICT;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index 38909ea..2bb2292 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -57,7 +57,7 @@ parse_mac(const char *mac, char *macbuf)
 	unsigned int i = 0;
 
 	if (strlen(mac) != ETH_ALEN*3-1)
-		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
+		xtables_error(PARAMETER_PROBLEM, "Bad mac address \"%s\"", mac);
 
 	for (i = 0; i < ETH_ALEN; i++) {
 		long number;
@@ -70,7 +70,7 @@ parse_mac(const char *mac, char *macbuf)
 		    && number <= 255)
 			macbuf[i] = number;
 		else
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Bad mac address `%s'", mac);
 	}
 }
@@ -86,14 +86,14 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		cipinfo->flags |= CLUSTERIP_FLAG_NEW;
 		if (*flags & PARAM_NEW)
-			exit_error(PARAMETER_PROBLEM, "Can only specify `--new' once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify \"--new\" once\n");
 		*flags |= PARAM_NEW;
 		break;
 	case '2':
 		if (!(*flags & PARAM_NEW))
-			exit_error(PARAMETER_PROBLEM, "Can only specify hashmode combined with `--new'\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify hashmode combined with \"--new\"\n");
 		if (*flags & PARAM_HMODE)
-			exit_error(PARAMETER_PROBLEM, "Can only specify hashmode once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify hashmode once\n");
 		if (!strcmp(optarg, "sourceip"))
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP;
 		else if (!strcmp(optarg, "sourceip-sourceport"))
@@ -101,48 +101,48 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 		else if (!strcmp(optarg, "sourceip-sourceport-destport"))
 			cipinfo->hash_mode = CLUSTERIP_HASHMODE_SIP_SPT_DPT;
 		else
-			exit_error(PARAMETER_PROBLEM, "Unknown hashmode `%s'\n",
+			xtables_error(PARAMETER_PROBLEM, "Unknown hashmode \"%s\"\n",
 				   optarg);
 		*flags |= PARAM_HMODE;
 		break;
 	case '3':
 		if (!(*flags & PARAM_NEW))
-			exit_error(PARAMETER_PROBLEM, "Can only specify MAC combined with `--new'\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify MAC combined with \"--new\"\n");
 		if (*flags & PARAM_MAC)
-			exit_error(PARAMETER_PROBLEM, "Can only specify MAC once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify MAC once\n");
 		parse_mac(optarg, (char *)cipinfo->clustermac);
 		if (!(cipinfo->clustermac[0] & 0x01))
-			exit_error(PARAMETER_PROBLEM, "MAC has to be a multicast ethernet address\n");
+			xtables_error(PARAMETER_PROBLEM, "MAC has to be a multicast ethernet address\n");
 		*flags |= PARAM_MAC;
 		break;
 	case '4':
 		if (!(*flags & PARAM_NEW))
-			exit_error(PARAMETER_PROBLEM, "Can only specify node number combined with `--new'\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify node number combined with \"--new\"\n");
 		if (*flags & PARAM_TOTALNODE)
-			exit_error(PARAMETER_PROBLEM, "Can only specify total node number once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify total node number once\n");
 		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
-			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
 		cipinfo->num_total_nodes = num;
 		*flags |= PARAM_TOTALNODE;
 		break;
 	case '5':
 		if (!(*flags & PARAM_NEW))
-			exit_error(PARAMETER_PROBLEM, "Can only specify node number combined with `--new'\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify node number combined with \"--new\"\n");
 		if (*flags & PARAM_LOCALNODE)
-			exit_error(PARAMETER_PROBLEM, "Can only specify local node number once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify local node number once\n");
 		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
-			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
 		cipinfo->num_local_nodes = 1;
 		cipinfo->local_nodes[0] = num;
 		*flags |= PARAM_LOCALNODE;
 		break;
 	case '6':
 		if (!(*flags & PARAM_NEW))
-			exit_error(PARAMETER_PROBLEM, "Can only specify hash init value combined with `--new'\n");
+			xtables_error(PARAMETER_PROBLEM, "Can only specify hash init value combined with \"--new\"\n");
 		if (*flags & PARAM_HASHINIT)
-			exit_error(PARAMETER_PROBLEM, "Can specify hash init value only once\n");
+			xtables_error(PARAMETER_PROBLEM, "Can specify hash init value only once\n");
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT_MAX))
-			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Unable to parse \"%s\"\n", optarg);
 		cipinfo->hash_initval = num;
 		*flags |= PARAM_HASHINIT;
 		break;
@@ -162,7 +162,7 @@ static void CLUSTERIP_check(unsigned int flags)
 		== (PARAM_NEW|PARAM_HMODE|PARAM_MAC|PARAM_TOTALNODE|PARAM_LOCALNODE))
 		return;
 
-	exit_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
+	xtables_error(PARAMETER_PROBLEM, "CLUSTERIP target: Invalid parameter combination\n");
 }
 
 static char *hashmode2str(enum clusterip_hashmode mode)
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index 371ec79..a3e1462 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -45,7 +45,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 
 	info = realloc(info, size);
 	if (!info)
-		exit_error(OTHER_PROBLEM, "Out of memory\n");
+		xtables_error(OTHER_PROBLEM, "Out of memory\n");
 
 	info->t.u.target_size = size;
 	info->mr.range[info->mr.rangesize] = *range;
@@ -69,19 +69,19 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 		int port;
 
 		if (!portok)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
 		error = strchr(colon+1, ':');
 		if (error)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid port:port syntax - use dash\n");
 
 		dash = strchr(colon, '-');
@@ -94,11 +94,11 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 
 			maxport = atoi(dash + 1);
 			if (maxport <= 0 || maxport > 65535)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
 				/* People are stupid. */
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Port range `%s' funky\n", colon+1);
 			range.min.tcp.port = htons(port);
 			range.max.tcp.port = htons(maxport);
@@ -119,13 +119,13 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 
 	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
-			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 				   dash+1);
 		range.max_ip = ip->s_addr;
 	} else
@@ -153,14 +153,14 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-destination");
 
 		if (*flags) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Multiple --to-destination not supported");
 		}
 		*target = parse_to(optarg, portok, info);
@@ -185,7 +185,7 @@ static int DNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 static void DNAT_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify --to-destination");
 }
 
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index c4e8e34..b107d16 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -50,7 +50,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'F':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			        "ECN target: Only use --ecn-tcp-remove ONCE!");
 		einfo->operation = IPT_ECN_OP_SET_ECE | IPT_ECN_OP_SET_CWR;
 		einfo->proto.tcp.ece = 0;
@@ -59,10 +59,10 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'G':
 		if (*flags & IPT_ECN_OP_SET_CWR)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-tcp-cwr ONCE!");
 		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_CWR;
 		einfo->proto.tcp.cwr = result;
@@ -70,10 +70,10 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'H':
 		if (*flags & IPT_ECN_OP_SET_ECE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-tcp-ece ONCE!");
 		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_ECE;
 		einfo->proto.tcp.ece = result;
@@ -81,10 +81,10 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '9':
 		if (*flags & IPT_ECN_OP_SET_IP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-ip-ect ONCE!");
 		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_IP;
 		einfo->ip_ect = result;
@@ -100,7 +100,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 static void ECN_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "ECN target: Parameter --ecn-tcp-remove is required");
 }
 
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index bc7e8a4..4da412c 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -79,7 +79,7 @@ parse_level(const char *level)
 			if (strncasecmp(level, ipt_log_names[i].name,
 					strlen(level)) == 0) {
 				if (set++)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "log-level `%s' ambiguous",
 						   level);
 				lev = ipt_log_names[i].level;
@@ -87,7 +87,7 @@ parse_level(const char *level)
 		}
 
 		if (!set)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "log-level `%s' unknown", level);
 	}
 
@@ -109,11 +109,11 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '!':
 		if (*flags & IPT_LOG_OPT_LEVEL)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-level twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-level");
 
 		loginfo->level = parse_level(optarg);
@@ -122,24 +122,24 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '#':
 		if (*flags & IPT_LOG_OPT_PREFIX)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-prefix twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --log-prefix");
 
 		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Maximum prefix length %u for --log-prefix",
 				   (unsigned int)sizeof(loginfo->prefix) - 1);
 
 		if (strlen(optarg) == 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "No prefix specified for --log-prefix");
 
 		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --log-prefix");
 
 		strcpy(loginfo->prefix, optarg);
@@ -148,7 +148,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '1':
 		if (*flags & IPT_LOG_OPT_TCPSEQ)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-sequence "
 				   "twice");
 
@@ -158,7 +158,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & IPT_LOG_OPT_TCPOPT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-tcp-options twice");
 
 		loginfo->logflags |= IPT_LOG_TCPOPT;
@@ -167,7 +167,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		if (*flags & IPT_LOG_OPT_IPOPT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-ip-options twice");
 
 		loginfo->logflags |= IPT_LOG_IPOPT;
@@ -176,7 +176,7 @@ static int LOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '4':
 		if (*flags & IPT_LOG_OPT_UID)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --log-uid twice");
 
 		loginfo->logflags |= IPT_LOG_UID;
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 0ee155c..0180bf6 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -44,7 +44,7 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 
 	port = atoi(arg);
 	if (port <= 0 || port > 65535)
-		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);
+		xtables_error(PARAMETER_PROBLEM, "Port \"%s\" not valid\n", arg);
 
 	dash = strchr(arg, '-');
 	if (!dash) {
@@ -56,11 +56,11 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 
 		maxport = atoi(dash + 1);
 		if (maxport == 0 || maxport > 65535)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", dash+1);
 		if (maxport < port)
 			/* People are stupid.  Present reader excepted. */
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port range `%s' funky\n", arg);
 		mr->range[0].min.tcp.port = htons(port);
 		mr->range[0].max.tcp.port = htons(maxport);
@@ -87,11 +87,11 @@ static int MASQUERADE_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (!portok)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
 		parse_ports(optarg, mr);
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 9949c99..b1d79ce 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -77,26 +77,26 @@ parse_to(char *arg, struct ip_nat_range *range)
 
 	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 	if (slash) {
 		if (strchr(slash+1, '.')) {
 			ip = xtables_numeric_to_ipmask(slash+1);
 			if (!ip)
-				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
+				xtables_error(PARAMETER_PROBLEM, "Bad netmask \"%s\"\n",
 					   slash+1);
 			netmask = ip->s_addr;
 		}
 		else {
 			if (!xtables_strtoui(slash+1, NULL, &bits, 0, 32))
-				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
+				xtables_error(PARAMETER_PROBLEM, "Bad netmask \"%s\"\n",
 					   slash+1);
 			netmask = bits2netmask(bits);
 		}
 		/* Don't allow /0 (/1 is probably insane, too) */
 		if (netmask == 0)
-			exit_error(PARAMETER_PROBLEM, "Netmask needed\n");
+			xtables_error(PARAMETER_PROBLEM, "Netmask needed\n");
 	}
 	else
 		netmask = ~0;
@@ -104,7 +104,7 @@ parse_to(char *arg, struct ip_nat_range *range)
 	if (range->min_ip & ~netmask) {
 		if (slash)
 			*slash = '/';
-		exit_error(PARAMETER_PROBLEM, "Bad network address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "Bad network address \"%s\"\n",
 			   arg);
 	}
 	range->max_ip = range->min_ip | ~netmask;
@@ -119,7 +119,7 @@ static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --%s", NETMAP_opts[0].name);
 
 		parse_to(optarg, &mr->range[0]);
@@ -134,7 +134,7 @@ static int NETMAP_parse(int c, char **argv, int invert, unsigned int *flags,
 static void NETMAP_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   MODULENAME" needs --%s", NETMAP_opts[0].name);
 }
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index c6afbdc..8fcb46a 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -44,14 +44,14 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 	mr->range[0].flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 	if (strchr(arg, '.'))
-		exit_error(PARAMETER_PROBLEM, "IP address not permitted\n");
+		xtables_error(PARAMETER_PROBLEM, "IP address not permitted\n");
 
 	port = atoi(arg);
 	if (port == 0)
 		port = xtables_service_to_port(arg, NULL);
 
 	if (port == 0 || port > 65535)
-		exit_error(PARAMETER_PROBLEM, "Port `%s' not valid\n", arg);
+		xtables_error(PARAMETER_PROBLEM, "Port \"%s\" not valid\n", arg);
 
 	dash = strchr(arg, '-');
 	if (!dash) {
@@ -63,11 +63,11 @@ parse_ports(const char *arg, struct ip_nat_multi_range *mr)
 
 		maxport = atoi(dash + 1);
 		if (maxport == 0 || maxport > 65535)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", dash+1);
 		if (maxport < port)
 			/* People are stupid. */
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port range `%s' funky\n", arg);
 		mr->range[0].min.tcp.port = htons(port);
 		mr->range[0].max.tcp.port = htons(maxport);
@@ -94,11 +94,11 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (!portok)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-ports");
 
 		parse_ports(optarg, mr);
diff --git a/extensions/libipt_REJECT.c b/extensions/libipt_REJECT.c
index db94306..98d8dcb 100644
--- a/extensions/libipt_REJECT.c
+++ b/extensions/libipt_REJECT.c
@@ -100,7 +100,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch(c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --reject-with");
 		for (i = 0; i < limit; i++) {
 			if ((strncasecmp(reject_table[i].name, optarg, strlen(optarg)) == 0)
@@ -114,7 +114,7 @@ static int REJECT_parse(int c, char **argv, int invert, unsigned int *flags,
 		    || strncasecmp("echoreply", optarg, strlen(optarg)) == 0)
 			fprintf(stderr, "--reject-with echo-reply no longer"
 				" supported\n");
-		exit_error(PARAMETER_PROBLEM, "unknown reject type `%s'",optarg);
+		xtables_error(PARAMETER_PROBLEM, "unknown reject type \"%s\"", optarg);
 	default:
 		/* Fall through */
 		break;
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 007ebc3..444a520 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -58,20 +58,20 @@ parse_to(char *arg, struct ip_nat_range *range)
 
 	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
-			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 				   dash+1);
 	}
 	range->max_ip = ip->s_addr;
 	if (dash)
 		if (range->min_ip > range->max_ip)
-			exit_error(PARAMETER_PROBLEM, "Bad IP range `%s-%s'\n", 
+			xtables_error(PARAMETER_PROBLEM, "Bad IP range \"%s-%s\"\n",
 				   arg, dash+1);
 }
 
@@ -89,12 +89,12 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (mr->rangesize == IPT_SAME_MAX_RANGE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Too many ranges specified, maximum "
 				   "is %i ranges.\n",
 				   IPT_SAME_MAX_RANGE);
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to");
 
 		parse_to(optarg, &mr->range[mr->rangesize]);
@@ -108,7 +108,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 		
 	case '2':
 		if (*flags & IPT_SAME_OPT_NODST)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nodst twice");
 		
 		mr->info |= IPT_SAME_NODST;
@@ -131,7 +131,7 @@ static int SAME_parse(int c, char **argv, int invert, unsigned int *flags,
 static void SAME_check(unsigned int flags)
 {
 	if (!(flags & IPT_SAME_OPT_TO))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "SAME needs --to");
 }
 
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 45967be..e9bdab4 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -54,20 +54,20 @@ parse_target(char **argv, int invert, unsigned int *flags,
              struct ipt_set_info *info, const char *what)
 {
 	if (info->flags[0])
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--%s can be specified only once", what);
 
 	if (xtables_check_inverse(optarg, &invert, NULL, 0))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Unexpected `!' after --%s", what);
 
 	if (!argv[optind]
 	    || argv[optind][0] == '-' || argv[optind][0] == '!')
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--%s requires two args.", what);
 
 	if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "setname `%s' too long, max %d characters.",
 			   argv[optind-1], IP_SET_MAXNAMELEN - 1);
 
@@ -103,7 +103,7 @@ static int SET_parse(int c, char **argv, int invert, unsigned int *flags,
 static void SET_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify either `--add-set' or `--del-set'");
 }
 
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 96ef56e..fda03ea 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -45,7 +45,7 @@ append_range(struct ipt_natinfo *info, const struct ip_nat_range *range)
 
 	info = realloc(info, size);
 	if (!info)
-		exit_error(OTHER_PROBLEM, "Out of memory\n");
+		xtables_error(OTHER_PROBLEM, "Out of memory\n");
 
 	info->t.u.target_size = size;
 	info->mr.range[info->mr.rangesize] = *range;
@@ -69,19 +69,19 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 		int port;
 
 		if (!portok)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Need TCP, UDP, SCTP or DCCP with port specification");
 
 		range.flags |= IP_NAT_RANGE_PROTO_SPECIFIED;
 
 		port = atoi(colon+1);
 		if (port <= 0 || port > 65535)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Port `%s' not valid\n", colon+1);
 
 		error = strchr(colon+1, ':');
 		if (error)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid port:port syntax - use dash\n");
 
 		dash = strchr(colon, '-');
@@ -94,11 +94,11 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 
 			maxport = atoi(dash + 1);
 			if (maxport <= 0 || maxport > 65535)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Port `%s' not valid\n", dash+1);
 			if (maxport < port)
 				/* People are stupid. */
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Port range `%s' funky\n", colon+1);
 			range.min.tcp.port = htons(port);
 			range.max.tcp.port = htons(maxport);
@@ -119,13 +119,13 @@ parse_to(char *arg, int portok, struct ipt_natinfo *info)
 
 	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
-			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
+			xtables_error(PARAMETER_PROBLEM, "Bad IP address \"%s\"\n",
 				   dash+1);
 		range.max_ip = ip->s_addr;
 	} else
@@ -153,14 +153,14 @@ static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --to-source");
 
 		if (*flags & IPT_SNAT_OPT_SOURCE) {
 			if (!kernel_version)
 				get_kernel_version();
 			if (kernel_version > LINUX_VERSION(2, 6, 10))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Multiple --to-source not supported");
 		}
 		*target = parse_to(optarg, portok, info);
@@ -186,7 +186,7 @@ static int SNAT_parse(int c, char **argv, int invert, unsigned int *flags,
 static void SNAT_check(unsigned int flags)
 {
 	if (!(flags & IPT_SNAT_OPT_SOURCE))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify --to-source");
 }
 
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 15d23ba..2501877 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -32,20 +32,20 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 	unsigned int value;
 
 	if (*flags & IPT_TTL_USED) {
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"Can't specify TTL option twice");
 	}
 
 	if (!optarg) 
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"TTL: You must specify a value");
 
 	if (xtables_check_inverse(optarg, &invert, NULL, 0))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
 	
 	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "TTL: Expected value between 0 and 255");
 
 	switch (c) {
@@ -56,7 +56,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case '2':
 			if (value == 0) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"TTL: decreasing by 0?");
 			}
 
@@ -65,7 +65,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case '3':
 			if (value == 0) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"TTL: increasing by 0?");
 			}
 
@@ -86,7 +86,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 static void TTL_check(unsigned int flags)
 {
 	if (!(flags & IPT_TTL_USED))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"TTL: You must specify an action");
 }
 
diff --git a/extensions/libipt_ULOG.c b/extensions/libipt_ULOG.c
index 89d0940..9633a87 100644
--- a/extensions/libipt_ULOG.c
+++ b/extensions/libipt_ULOG.c
@@ -74,15 +74,15 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '!':
 		if (*flags & IPT_LOG_OPT_NLGROUP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-nlgroup twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-nlgroup");
 		group_d = atoi(optarg);
 		if (group_d > 32 || group_d < 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--ulog-nlgroup has to be between 1 and 32");
 
 		loginfo->nl_group = (1 << (group_d - 1));
@@ -92,24 +92,24 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '#':
 		if (*flags & IPT_LOG_OPT_PREFIX)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-prefix twice");
 
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --ulog-prefix");
 
 		if (strlen(optarg) > sizeof(loginfo->prefix) - 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Maximum prefix length %u for --ulog-prefix",
 				   (unsigned int)sizeof(loginfo->prefix) - 1);
 
 		if (strlen(optarg) == 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "No prefix specified for --ulog-prefix");
 
 		if (strlen(optarg) != strlen(strtok(optarg, "\n")))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines not allowed in --ulog-prefix");
 
 		strcpy(loginfo->prefix, optarg);
@@ -117,23 +117,23 @@ static int ULOG_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'A':
 		if (*flags & IPT_LOG_OPT_CPRANGE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-cprange twice");
 		if (atoi(optarg) < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Negative copy range?");
 		loginfo->copy_range = atoi(optarg);
 		*flags |= IPT_LOG_OPT_CPRANGE;
 		break;
 	case 'B':
 		if (*flags & IPT_LOG_OPT_QTHRESHOLD)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --ulog-qthreshold twice");
 		if (atoi(optarg) < 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Negative or zero queue threshold ?");
 		if (atoi(optarg) > ULOG_MAX_QLEN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Maximum queue length exceeded");
 		loginfo->qthreshold = atoi(optarg);
 		*flags |= IPT_LOG_OPT_QTHRESHOLD;
diff --git a/extensions/libipt_addrtype.c b/extensions/libipt_addrtype.c
index 446cf0f..22b35d4 100644
--- a/extensions/libipt_addrtype.c
+++ b/extensions/libipt_addrtype.c
@@ -81,13 +81,13 @@ static void parse_types(const char *arg, u_int16_t *mask)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !parse_type(arg, comma-arg, mask))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: bad type `%s'", arg);
 		arg = comma + 1;
 	}
 
 	if (strlen(arg) == 0 || !parse_type(arg, strlen(arg), mask))
-		exit_error(PARAMETER_PROBLEM, "addrtype: bad type `%s'", arg);
+		xtables_error(PARAMETER_PROBLEM, "addrtype: bad type \"%s\"", arg);
 }
 	
 #define IPT_ADDRTYPE_OPT_SRCTYPE	0x1
@@ -105,7 +105,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags&IPT_ADDRTYPE_OPT_SRCTYPE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->source);
@@ -115,7 +115,7 @@ addrtype_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags&IPT_ADDRTYPE_OPT_DSTTYPE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->dest);
@@ -140,7 +140,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IPT_ADDRTYPE_OPT_SRCTYPE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify src-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->source);
@@ -150,7 +150,7 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '2':
 		if (*flags & IPT_ADDRTYPE_OPT_DSTTYPE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify dst-type twice");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_types(argv[optind-1], &info->dest);
@@ -160,14 +160,14 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '3':
 		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify limit-iface-in twice");
 		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_IN;
 		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN;
 		break;
 	case '4':
 		if (*flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "addrtype: can't specify limit-iface-out twice");
 		info->flags |= IPT_ADDRTYPE_LIMIT_IFACE_OUT;
 		*flags |= IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT;
@@ -182,18 +182,18 @@ addrtype_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 static void addrtype_check_v0(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 }
 
 static void addrtype_check_v1(unsigned int flags)
 {
 	if (!(flags & (IPT_ADDRTYPE_OPT_SRCTYPE|IPT_ADDRTYPE_OPT_DSTTYPE)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you must specify --src-type or --dst-type");
 	if (flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_IN &&
 	    flags & IPT_ADDRTYPE_OPT_LIMIT_IFACE_OUT)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "addrtype: you can't specify both --limit-iface-in "
 			   "and --limit-iface-out");
 }
diff --git a/extensions/libipt_ah.c b/extensions/libipt_ah.c
index 31977dd..d049b42 100644
--- a/extensions/libipt_ah.c
+++ b/extensions/libipt_ah.c
@@ -30,15 +30,15 @@ parse_ah_spi(const char *spistr)
 	spi =  strtoul(spistr,&ep,0) ;
 
 	if ( spistr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "AH no valid digits in spi `%s'", spistr);
 	}
 	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "spi `%s' specified too big: would overflow", spistr);
 	}	
 	if ( *spistr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "AH error parsing spi `%s'", spistr);
 	}
 	return spi;
@@ -80,7 +80,7 @@ static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & AH_SPI)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--ahspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_ah_spis(argv[optind-1], ahinfo->spis);
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 3b9da71..0f8849d 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -42,7 +42,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'F':
 		if (*flags & IPT_ECN_OP_MATCH_CWR)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "ECN match: can only use parameter ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->operation |= IPT_ECN_OP_MATCH_CWR;
@@ -53,7 +53,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'G':
 		if (*flags & IPT_ECN_OP_MATCH_ECE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		einfo->operation |= IPT_ECN_OP_MATCH_ECE;
@@ -64,7 +64,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'H':
 		if (*flags & IPT_ECN_OP_MATCH_IP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN match: can only use parameter ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
@@ -72,7 +72,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 		*flags |= IPT_ECN_OP_MATCH_IP;
 		einfo->operation |= IPT_ECN_OP_MATCH_IP;
 		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "ECN match: Value out of range");
 		einfo->ip_ect = result;
 		break;
@@ -86,7 +86,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 static void ecn_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "ECN match: some option required");
 }
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 0fd132b..7dac0b7 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -122,7 +122,7 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 		if (strncasecmp(icmp_codes[i].name, icmptype, strlen(icmptype))
 		    == 0) {
 			if (match != limit)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Ambiguous ICMP type `%s':"
 					   " `%s' or `%s'?",
 					   icmptype,
@@ -148,12 +148,12 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 			*slash = '\0';
 
 		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid ICMP type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
 			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Invalid ICMP code `%s'\n",
 					   slash+1);
 			code[0] = code[1] = number;
@@ -180,7 +180,7 @@ static int icmp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags == 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "icmp match: only use --icmp-type once!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_icmp(argv[optind-1], &icmpinfo->type, 
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index a538927..964c19a 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -98,7 +98,7 @@ static int parse_direction(char *s)
 		return IPT_POLICY_MATCH_IN;
 	if (strcmp(s, "out") == 0)
 		return IPT_POLICY_MATCH_OUT;
-	exit_error(PARAMETER_PROBLEM, "policy_match: invalid dir `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy_match: invalid dir \"%s\"", s);
 }
 
 static int parse_policy(char *s)
@@ -107,7 +107,7 @@ static int parse_policy(char *s)
 		return IPT_POLICY_MATCH_NONE;
 	if (strcmp(s, "ipsec") == 0)
 		return 0;
-	exit_error(PARAMETER_PROBLEM, "policy match: invalid policy `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy match: invalid policy \"%s\"", s);
 }
 
 static int parse_mode(char *s)
@@ -116,7 +116,7 @@ static int parse_mode(char *s)
 		return IPT_POLICY_MODE_TRANSPORT;
 	if (strcmp(s, "tunnel") == 0)
 		return IPT_POLICY_MODE_TUNNEL;
-	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
 static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -133,35 +133,35 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --dir option");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --dir option");
 
 		info->flags |= parse_direction(argv[optind-1]);
 		break;
 	case '2':
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --policy option");
 
 		info->flags |= parse_policy(argv[optind-1]);
 		break;
 	case '3':
 		if (info->flags & IPT_POLICY_MATCH_STRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --strict option");
 
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --strict option");
 
 		info->flags |= IPT_POLICY_MATCH_STRICT;
 		break;
 	case '4':
 		if (e->match.reqid)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --reqid option");
 
 		e->match.reqid = 1;
@@ -170,7 +170,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '5':
 		if (e->match.spi)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --spi option");
 
 		e->match.spi = 1;
@@ -179,12 +179,12 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '6':
 		if (e->match.saddr)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
 		xtables_ipparse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
 
 		e->match.saddr = 1;
@@ -194,12 +194,12 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
                 break;
 	case '7':
 		if (e->match.daddr)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
 
 		xtables_ipparse_any(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
 
 		e->match.daddr = 1;
@@ -209,20 +209,20 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case '8':
 		if (e->match.proto)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
 
 		e->proto = xtables_parse_protocol(argv[optind-1]);
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: protocol must ah/esp/ipcomp");
 		e->match.proto = 1;
 		e->invert.proto = invert;
 		break;
 	case '9':
 		if (e->match.mode)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --mode option");
 
 		mode = parse_mode(argv[optind-1]);
@@ -232,11 +232,11 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'a':
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --next option");
 
 		if (++info->len == IPT_POLICY_MAX_ELEM)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
 	default:
@@ -254,26 +254,26 @@ static void policy_check(unsigned int flags)
 	int i;
 
 	if (info == NULL)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: no parameters given");
 
 	if (!(info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: neither --in nor --out specified");
 
 	if (info->flags & IPT_POLICY_MATCH_NONE) {
 		if (info->flags & IPT_POLICY_MATCH_STRICT)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but --strict given");
 
 		if (info->len != 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but policy given");
 	} else
 		info->len++;	/* increase len by 1, no --next after last element */
 
 	if (!(info->flags & IPT_POLICY_MATCH_STRICT) && info->len > 1)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: multiple elements but no --strict");
 
 	for (i = 0; i < info->len; i++) {
@@ -282,13 +282,13 @@ static void policy_check(unsigned int flags)
 		if (info->flags & IPT_POLICY_MATCH_STRICT &&
 		    !(e->match.reqid || e->match.spi || e->match.saddr ||
 		      e->match.daddr || e->match.proto || e->match.mode))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: empty policy element");
 
 		if ((e->match.saddr || e->match.daddr)
 		    && ((e->mode == IPT_POLICY_MODE_TUNNEL && e->invert.mode) ||
 		        (e->mode == IPT_POLICY_MODE_TRANSPORT && !e->invert.mode)))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: --tunnel-src/--tunnel-dst "
 			           "is only valid in tunnel mode");
 	}
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index e602dad..3dd63d3 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -166,12 +166,12 @@ static int realm_parse(int c, char **argv, int invert, unsigned int *flags,
 			else
 				realminfo->mask = 0xffffffff;
 			if (*end != '\0' || end == optarg)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Bad realm value `%s'", optarg);
 		} else {
 			id = realm_name2id(optarg);
 			if (id == -1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Realm `%s' not found", optarg);
 			realminfo->id = id;
 			realminfo->mask = 0xffffffff;
@@ -230,7 +230,7 @@ static void realm_save(const void *ip, const struct xt_entry_match *match)
 static void realm_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "realm match: You must specify `--realm'");
 }
 
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 5b9e1fd..845b2b0 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -55,7 +55,7 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':		/* --set <set> <flag>[,<flag> */
 		if (info->flags[0])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--set can be specified only once");
 
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -65,11 +65,11 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (!argv[optind]
 		    || argv[optind][0] == '-'
 		    || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--set requires two args.");
 
 		if (strlen(argv[optind-1]) > IP_SET_MAXNAMELEN - 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "setname `%s' too long, max %d characters.",
 				   argv[optind-1], IP_SET_MAXNAMELEN - 1);
 
@@ -91,7 +91,7 @@ static int set_parse(int c, char **argv, int invert, unsigned int *flags,
 static void set_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify `--set' with proper arguments");
 	DEBUGP("final check OK\n");
 }
diff --git a/extensions/libipt_set.h b/extensions/libipt_set.h
index 3e70d7b..f521e05 100644
--- a/extensions/libipt_set.h
+++ b/extensions/libipt_set.h
@@ -25,12 +25,12 @@ parse_bindings(const char *opt_arg, struct ipt_set_info *info)
 		else if (strncmp(ptr, "dst", 3) == 0)
 			info->flags[i++] |= IPSET_DST;
 		else
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "You must spefify (the comma separated list of) 'src' or 'dst'.");
 	}
 
 	if (tmp)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Can't follow bindings deeper than %i.", 
 			   IP_SET_MAX_BINDINGS - 1);
 
@@ -42,7 +42,7 @@ static int get_set_getsockopt(void *data, socklen_t * size)
 	int sockfd = -1;
 	sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_RAW);
 	if (sockfd < 0)
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Can't open socket to ipset.\n");
 	/* Send! */
 	return getsockopt(sockfd, SOL_IP, SO_IP_SET, data, size);
@@ -60,16 +60,16 @@ static void get_set_byname(const char *setname, struct ipt_set_info *info)
 	req.set.name[IP_SET_MAXNAMELEN - 1] = '\0';
 	res = get_set_getsockopt(&req, &size);
 	if (res != 0)
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Problem when communicating with ipset, errno=%d.\n",
 			   errno);
 	if (size != sizeof(struct ip_set_req_get_set))
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Incorrect return size from kernel during ipset lookup, "
 			   "(want %zu, got %zu)\n",
 			   sizeof(struct ip_set_req_get_set), (size_t)size);
 	if (req.set.index == IP_SET_INVALID_ID)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Set %s doesn't exist.\n", setname);
 
 	info->index = req.set.index;
@@ -86,16 +86,16 @@ static void get_set_byid(char * setname, ip_set_id_t idx)
 	req.set.index = idx;
 	res = get_set_getsockopt(&req, &size);
 	if (res != 0)
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Problem when communicating with ipset, errno=%d.\n",
 			   errno);
 	if (size != sizeof(struct ip_set_req_get_set))
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Incorrect return size from kernel during ipset lookup, "
 			   "(want %zu, got %zu)\n",
 			   sizeof(struct ip_set_req_get_set), (size_t)size);
 	if (req.set.name[0] == '\0')
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Set id %i in kernel doesn't exist.\n", idx);
 
 	strncpy(setname, req.set.name, IP_SET_MAXNAMELEN);
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 3387e92..67f0b1a 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -34,7 +34,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		case '2':
 			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
 			if (invert)
@@ -47,11 +47,11 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 		case '3':
 			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
 			if (invert) 
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 						"ttl: unexpected `!'");
 
 			info->mode = IPT_TTL_LT;
@@ -59,11 +59,11 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 		case '4':
 			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 						"ttl: unexpected `!'");
 
 			info->mode = IPT_TTL_GT;
@@ -75,7 +75,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (*flags) 
-		exit_error(PARAMETER_PROBLEM, 
+		xtables_error(PARAMETER_PROBLEM,
 				"Can't specify TTL option twice");
 	*flags = 1;
 
@@ -85,7 +85,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 static void ttl_check(unsigned int flags)
 {
 	if (!flags) 
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"TTL match: You must specify one of "
 			"`--ttl-eq', `--ttl-lt', `--ttl-gt");
 }
diff --git a/extensions/libxt_CLASSIFY.c b/extensions/libxt_CLASSIFY.c
index 113f680..119922d 100644
--- a/extensions/libxt_CLASSIFY.c
+++ b/extensions/libxt_CLASSIFY.c
@@ -45,10 +45,10 @@ CLASSIFY_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (CLASSIFY_string_to_priority(optarg, &clinfo->priority))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Bad class value `%s'", optarg);
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "CLASSIFY: Can't specify --set-class twice");
 		*flags = 1;
 		break;
@@ -64,7 +64,7 @@ static void
 CLASSIFY_final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "CLASSIFY: Parameter --set-class is required");
 }
 
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index e426e4f..6e42898 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -111,34 +111,34 @@ CONNMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 		    markinfo->mask = strtoul(end+1, &end, 0);
 
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --set-mark twice");
 		*flags = 1;
 		break;
 	case '2':
 		markinfo->mode = XT_CONNMARK_SAVE;
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --save-mark twice");
 		*flags = 1;
 		break;
 	case '3':
 		markinfo->mode = XT_CONNMARK_RESTORE;
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --restore-mark twice");
 		*flags = 1;
 		break;
 	case '4':
 		if (!*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "CONNMARK target: Can't specify --mask without a operation");
 		markinfo->mask = strtoul(optarg, &end, 0);
 
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MASK value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad MASK value \"%s\"", optarg);
 		break;
 	default:
 		return 0;
@@ -218,7 +218,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case 'n': /* --nfmask */
 		if (!(*flags & F_SR_MARK))
-			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--nfmask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
@@ -228,7 +228,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case 'c': /* --ctmask */
 		if (!(*flags & F_SR_MARK))
-			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--ctmask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
@@ -238,7 +238,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case 'm': /* --mask */
 		if (!(*flags & F_SR_MARK))
-			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
+			xtables_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--mask");
 		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
@@ -253,7 +253,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 static void connmark_tg_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "CONNMARK target: No operation specified");
 }
 
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 05dbf70..1515f6f 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -38,7 +38,7 @@ CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & CONNSECMARK_SAVE)
-			exit_error(PARAMETER_PROBLEM, PFX
+			xtables_error(PARAMETER_PROBLEM, PFX
 				   "Can't specify --save twice");
 		info->mode = CONNSECMARK_SAVE;
 		*flags |= CONNSECMARK_SAVE;
@@ -46,7 +46,7 @@ CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & CONNSECMARK_RESTORE)
-			exit_error(PARAMETER_PROBLEM, PFX
+			xtables_error(PARAMETER_PROBLEM, PFX
 				   "Can't specify --restore twice");
 		info->mode = CONNSECMARK_RESTORE;
 		*flags |= CONNSECMARK_RESTORE;
@@ -62,10 +62,10 @@ CONNSECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 static void CONNSECMARK_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
+		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
 
 	if (flags == (CONNSECMARK_SAVE|CONNSECMARK_RESTORE))
-		exit_error(PARAMETER_PROBLEM, PFX "only one flag of --save "
+		xtables_error(PARAMETER_PROBLEM, PFX "only one flag of --save "
 		           "or --restore is allowed");
 }
 
@@ -81,7 +81,7 @@ static void print_connsecmark(struct xt_connsecmark_target_info *info)
 		break;
 		
 	default:
-		exit_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
 	}
 }
 
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index aac8f9b..ddb9c99 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -49,11 +49,11 @@ parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 	unsigned int dscp;
        
 	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
 	if (dscp > XT_DSCP_MAX)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "DSCP `%d` out of range\n", dscp);
 
 	dinfo->dscp = dscp;
@@ -79,14 +79,14 @@ static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'F':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "DSCP target: Only use --set-dscp ONCE!");
 		parse_dscp(optarg, dinfo);
 		*flags = 1;
 		break;
 	case 'G':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "DSCP target: Only use --set-dscp-class ONCE!");
 		parse_class(optarg, dinfo);
 		*flags = 1;
@@ -102,7 +102,7 @@ static int DSCP_parse(int c, char **argv, int invert, unsigned int *flags,
 static void DSCP_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "DSCP target: Parameter --set-dscp is required");
 }
 
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index 8f04e8e..ec2fe96 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -63,18 +63,18 @@ MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		markinfo->mark = mark;
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "MARK target: Can't specify --set-mark twice");
 		*flags = 1;
 		break;
 	case '2':
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "MARK target: kernel too old for --and-mark");
 	case '3':
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "MARK target: kernel too old for --or-mark");
 	default:
 		return 0;
@@ -86,7 +86,7 @@ MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 static void MARK_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "MARK target: Parameter --set/and/or-mark"
 			   " is required");
 }
@@ -114,10 +114,10 @@ MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
-		exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 	markinfo->mark = mark;
 	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "MARK target: Can't specify --set-mark twice");
 
 	*flags = 1;
@@ -188,7 +188,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 static void mark_tg_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "MARK: One of the --set-xmark, "
+		xtables_error(PARAMETER_PROBLEM, "MARK: One of the --set-xmark, "
 		           "--{and,or,xor,set}-mark options is required");
 }
 
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index 6d8c9dc..007c7b4 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -49,56 +49,56 @@ static int NFLOG_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case NFLOG_GROUP:
 		if (*flags & NFLOG_GROUP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-group twice");
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-group");
 
 		n = atoi(optarg);
 		if (n < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--nflog-group can not be negative");
 		info->group = n;
 		break;
 	case NFLOG_PREFIX:
 		if (*flags & NFLOG_PREFIX)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-prefix twice");
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unexpected `!' after --nflog-prefix");
 
 		length = strlen(optarg);
 		if (length == 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "No prefix specified for --nflog-prefix");
 		if (length >= sizeof(info->prefix))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--nflog-prefix too long, max %Zu characters",
 				   sizeof(info->prefix) - 1);
 		if (length != strlen(strtok(optarg, "\n")))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Newlines are not allowed in --nflog-prefix");
 		strcpy(info->prefix, optarg);
 		break;
 	case NFLOG_RANGE:
 		if (*flags & NFLOG_RANGE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-range twice");
 		n = atoi(optarg);
 		if (n < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid --nflog-range, must be >= 0");
 		info->len = n;
 		break;
 	case NFLOG_THRESHOLD:
 		if (*flags & NFLOG_THRESHOLD)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify --nflog-threshold twice");
 		n = atoi(optarg);
 		if (n < 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid --nflog-threshold, must be >= 1");
 		info->threshold = n;
 		break;
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 1c0c23d..3ca2239 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -34,7 +34,7 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
 	unsigned int num;
        
 	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid queue number `%s'\n", s);
 
     	tinfo->queuenum = num & 0xffff;
@@ -50,7 +50,7 @@ NFQUEUE_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'F':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM, "NFQUEUE target: "
+			xtables_error(PARAMETER_PROBLEM, "NFQUEUE target: "
 				   "Only use --queue-num ONCE!");
 		parse_num(optarg, tinfo);
 		break;
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index cf1284f..d4fd6dd 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -99,7 +99,7 @@ RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case RATEEST_OPT_NAME:
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: can't specify --rateest-name twice");
 		*flags |= 1 << c;
 
@@ -108,24 +108,24 @@ RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case RATEEST_OPT_INTERVAL:
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: can't specify --rateest-interval twice");
 		*flags |= 1 << c;
 
 		if (RATEEST_get_time(&interval, optarg) < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad interval value `%s'", optarg);
 
 		break;
 
 	case RATEEST_OPT_EWMALOG:
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: can't specify --rateest-ewmalog twice");
 		*flags |= 1 << c;
 
 		if (RATEEST_get_time(&ewma_log, optarg) < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "RATEEST: bad ewmalog value `%s'", optarg);
 
 		break;
@@ -143,11 +143,11 @@ RATEEST_final_check(unsigned int flags)
 	struct xt_rateest_target_info *info = RATEEST_info;
 
 	if (!(flags & (1 << RATEEST_OPT_NAME)))
-		exit_error(PARAMETER_PROBLEM, "RATEEST: no name specified");
+		xtables_error(PARAMETER_PROBLEM, "RATEEST: no name specified");
 	if (!(flags & (1 << RATEEST_OPT_INTERVAL)))
-		exit_error(PARAMETER_PROBLEM, "RATEEST: no interval specified");
+		xtables_error(PARAMETER_PROBLEM, "RATEEST: no interval specified");
 	if (!(flags & (1 << RATEEST_OPT_EWMALOG)))
-		exit_error(PARAMETER_PROBLEM, "RATEEST: no ewmalog specified");
+		xtables_error(PARAMETER_PROBLEM, "RATEEST: no ewmalog specified");
 
 	for (info->interval = 0; info->interval <= 5; info->interval++) {
 		if (interval <= (1 << info->interval) * (TIME_UNITS_PER_SEC / 4))
@@ -155,7 +155,7 @@ RATEEST_final_check(unsigned int flags)
 	}
 
 	if (info->interval > 5)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "RATEEST: interval value is too large");
 	info->interval -= 2;
 
@@ -167,7 +167,7 @@ RATEEST_final_check(unsigned int flags)
 	info->ewma_log--;
 
 	if (info->ewma_log == 0 || info->ewma_log >= 31)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "RATEEST: ewmalog value is out of range");
 }
 
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index c62fb44..9db2327 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -35,12 +35,12 @@ static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & SECMARK_MODE_SEL)
-			exit_error(PARAMETER_PROBLEM, PFX
+			xtables_error(PARAMETER_PROBLEM, PFX
 				   "Can't specify --selctx twice");
 		info->mode = SECMARK_MODE_SEL;
 
 		if (strlen(optarg) > SECMARK_SELCTX_MAX-1)
-			exit_error(PARAMETER_PROBLEM, PFX
+			xtables_error(PARAMETER_PROBLEM, PFX
 				   "Maximum length %u exceeded by --selctx"
 				   " parameter (%zu)",
 				   SECMARK_SELCTX_MAX-1, strlen(optarg));
@@ -58,7 +58,7 @@ static int SECMARK_parse(int c, char **argv, int invert, unsigned int *flags,
 static void SECMARK_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, PFX "parameter required");
+		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
 }
 
 static void print_secmark(struct xt_secmark_target_info *info)
@@ -69,7 +69,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 		break;
 	
 	default:
-		exit_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
 	}
 }
 
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 33fc71c..ac9e2d0 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -53,11 +53,11 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '1':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "TCPMSS target: Only one option may be specified");
 		if (!xtables_strtoui(optarg, NULL, &mssval,
 		    0, UINT16_MAX - hdrsize))
-			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad TCPMSS value \"%s\"", optarg);
 		
 		mssinfo->mss = mssval;
 		*flags = 1;
@@ -65,7 +65,7 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "TCPMSS target: Only one option may be specified");
 		mssinfo->mss = XT_TCPMSS_CLAMP_PMTU;
 		*flags = 1;
@@ -93,7 +93,7 @@ static int TCPMSS_parse6(int c, char **argv, int invert, unsigned int *flags,
 static void TCPMSS_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "TCPMSS target: At least one parameter is required");
 }
 
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index c053a8b..cf946fc 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -84,15 +84,15 @@ static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 
 		if (option == 0 &&
 		    !xtables_strtoui(arg, NULL, &option, 0, UINT8_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Bad TCP option value \"%s\"", arg);
 
 		if (option < 2)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Option value may not be 0 or 1");
 
 		if (tcpoptstrip_test_bit(info->strip_bmap, option))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Option \"%s\" already specified", arg);
 
 		tcpoptstrip_set_bit(info->strip_bmap, option);
@@ -111,7 +111,7 @@ static int tcpoptstrip_tg_parse(int c, char **argv, int invert,
 	switch (c) {
 	case 's':
 		if (*flags & FLAG_STRIP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "You can specify --strip-options only once");
 		parse_list(info, optarg);
 		*flags |= FLAG_STRIP;
@@ -124,7 +124,7 @@ static int tcpoptstrip_tg_parse(int c, char **argv, int invert,
 static void tcpoptstrip_tg_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "TCPOPTSTRIP: --strip-options parameter required");
 }
 
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index 7b1f7f8..c08f53b 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -87,7 +87,7 @@ static int tos_tg_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
 			xtables_param_act(XTF_BAD_VALUE, "TOS", "--set-tos", optarg);
 		if (tvm.mask != 0xFF)
-			exit_error(PARAMETER_PROBLEM, "tos match: Your kernel "
+			xtables_error(PARAMETER_PROBLEM, "tos match: Your kernel "
 			           "is too old to support anything besides "
 				   "/0xFF as a mask.");
 		info->tos = tvm.value;
@@ -153,7 +153,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 static void tos_tg_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "TOS: The --set-tos parameter is required");
 }
 
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 54ae96d..d410c52 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -105,7 +105,7 @@ static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 static void tproxy_tg_check(unsigned int flags)
 {
 	if (!(flags & PARAM_ONPORT))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "TPROXY target: Parameter --on-port is required");
 }
 
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 9bad125..0ff0144 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -32,7 +32,7 @@ parse_comment(const char *s, struct xt_comment_info *info)
 	int slen = strlen(s);
 
 	if (slen >= XT_MAX_COMMENT_LEN) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"COMMENT must be shorter than %i characters", XT_MAX_COMMENT_LEN);
 	}
 	strcpy((char *)info->comment, s);
@@ -48,7 +48,7 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '1':
 		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 		if (invert) {
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 					"Sorry, you can't have an inverted comment");
 		}
 		parse_comment(argv[optind-1], commentinfo);
@@ -64,7 +64,7 @@ comment_parse(int c, char **argv, int invert, unsigned int *flags,
 static void comment_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "COMMENT match: You must specify `--comment'");
 }
 
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 5fc0f2a..9f6af1c 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -31,14 +31,14 @@ parse_range(const char *arg, struct xt_connbytes_info *si)
 
 	si->count.from = strtoul(arg,&colon,10);
 	if (*colon != ':') 
-		exit_error(PARAMETER_PROBLEM, "Bad range `%s'", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad range \"%s\"", arg);
 	si->count.to = strtoul(colon+1,&p,10);
 	if (p == colon+1) {
 		/* second number omited */
 		si->count.to = 0xffffffff;
 	}
 	if (si->count.from > si->count.to)
-		exit_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
+		xtables_error(PARAMETER_PROBLEM, "%llu should be less than %llu",
 			   (unsigned long long)si->count.from,
 			   (unsigned long long)si->count.to);
 }
@@ -71,7 +71,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 		else if (!strcmp(optarg, "both"))
 			sinfo->direction = XT_CONNBYTES_DIR_BOTH;
 		else
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown --connbytes-dir `%s'", optarg);
 
 		*flags |= 2;
@@ -84,7 +84,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 		else if (!strcmp(optarg, "avgpkt"))
 			sinfo->what = XT_CONNBYTES_AVGPKT;
 		else
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown --connbytes-mode `%s'", optarg);
 		*flags |= 4;
 		break;
@@ -98,7 +98,7 @@ connbytes_parse(int c, char **argv, int invert, unsigned int *flags,
 static void connbytes_check(unsigned int flags)
 {
 	if (flags != 7)
-		exit_error(PARAMETER_PROBLEM, "You must specify `--connbytes'"
+		xtables_error(PARAMETER_PROBLEM, "You must specify `--connbytes'"
 			   "`--connbytes-dir' and `--connbytes-mode'");
 }
 
diff --git a/extensions/libxt_connlimit.c b/extensions/libxt_connlimit.c
index f43eada..f001a2e 100644
--- a/extensions/libxt_connlimit.c
+++ b/extensions/libxt_connlimit.c
@@ -60,7 +60,7 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'A':
 		if (*flags & 0x1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"--connlimit-above may be given only once");
 		*flags |= 0x1;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -69,20 +69,20 @@ static int connlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 	case 'M':
 		if (*flags & 0x2)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"--connlimit-mask may be given only once");
 
 		*flags |= 0x2;
 		i = strtoul(argv[optind-1], &err, 0);
 		if (family == NFPROTO_IPV6) {
 			if (i > 128 || *err != '\0')
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"--connlimit-mask must be between "
 					"0 and 128");
 			prefix_to_netmask(info->v6_mask, i);
 		} else {
 			if (i > 32 || *err != '\0')
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"--connlimit-mask must be between "
 					"0 and 32");
 			if (i == 0)
@@ -117,7 +117,7 @@ static int connlimit_parse6(int c, char **argv, int invert,
 static void connlimit_check(unsigned int flags)
 {
 	if (!(flags & 0x1))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"You must specify \"--connlimit-above\"");
 }
 
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index d5ca4e0..2dca5a5 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -91,7 +91,7 @@ connmark_parse(int c, char **argv, int invert, unsigned int *flags,
 			markinfo->mask = strtoul(end+1, &end, 0);
 
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
@@ -114,7 +114,7 @@ static void print_mark(unsigned int mark, unsigned int mask)
 static void connmark_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "connmark: The --mark option is required");
 }
 
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 45783f4..a3fcafc 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -103,15 +103,15 @@ parse_states(const char *arg, struct xt_conntrack_info *sinfo)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !parse_state(arg, comma-arg, sinfo))
-			exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
+			xtables_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
 		arg = comma+1;
 	}
 	if (!*arg)
-		exit_error(PARAMETER_PROBLEM, "`--ctstate' requires a list of "
+		xtables_error(PARAMETER_PROBLEM, "\"--ctstate\" requires a list of "
 					      "states with no spaces, e.g. "
 					      "ESTABLISHED,RELATED");
 	if (strlen(arg) == 0 || !parse_state(arg, strlen(arg), sinfo))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
 }
 
 static bool
@@ -144,13 +144,13 @@ conntrack_ps_states(struct xt_conntrack_mtinfo1 *info, const char *arg)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !conntrack_ps_state(info, arg, comma - arg))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Bad ctstate \"%s\"", arg);
 		arg = comma + 1;
 	}
 
 	if (strlen(arg) == 0 || !conntrack_ps_state(info, arg, strlen(arg)))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad ctstate \"%s\"", arg);
 }
 
 static int
@@ -180,12 +180,12 @@ parse_statuses(const char *arg, struct xt_conntrack_info *sinfo)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !parse_status(arg, comma-arg, sinfo))
-			exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
+			xtables_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
 		arg = comma+1;
 	}
 
 	if (strlen(arg) == 0 || !parse_status(arg, strlen(arg), sinfo))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
 }
 
 static bool
@@ -214,13 +214,13 @@ conntrack_ps_statuses(struct xt_conntrack_mtinfo1 *info, const char *arg)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !conntrack_ps_status(info, arg, comma - arg))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Bad ctstatus \"%s\"", arg);
 		arg = comma + 1;
 	}
 
 	if (strlen(arg) == 0 || !conntrack_ps_status(info, arg, strlen(arg)))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad ctstatus \"%s\"", arg);
 }
 
 static unsigned long
@@ -229,7 +229,7 @@ parse_expire(const char *s)
 	unsigned int len;
 
 	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
-		exit_error(PARAMETER_PROBLEM, "expire value invalid: `%s'\n", s);
+		xtables_error(PARAMETER_PROBLEM, "expire value invalid: \"%s\"\n", s);
 	else
 		return len;
 }
@@ -257,7 +257,7 @@ parse_expires(const char *s, struct xt_conntrack_info *sinfo)
 	free(buffer);
 
 	if (sinfo->expires_min > sinfo->expires_max)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "expire min. range value `%lu' greater than max. "
 		           "range value `%lu'", sinfo->expires_min, sinfo->expires_max);
 }
@@ -278,7 +278,7 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 		xtables_param_act(XTF_BAD_VALUE, "conntrack", "--expires", s);
 
 	if (min > max)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "expire min. range value \"%u\" greater than max. "
 		           "range value \"%u\"", min, max);
 
@@ -322,7 +322,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
 		    && (sinfo->invflags & XT_INV_PROTO))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rule would never match protocol");
 
 		sinfo->flags |= XT_CONNTRACK_PROTO;
@@ -338,7 +338,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"multiple IP addresses not allowed");
 
 		if(naddrs == 1) {
@@ -358,7 +358,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"multiple IP addresses not allowed");
 
 		if(naddrs == 1) {
@@ -378,7 +378,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 					&sinfo->sipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"multiple IP addresses not allowed");
 
 		if(naddrs == 1) {
@@ -398,7 +398,7 @@ static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
 					&sinfo->dipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"multiple IP addresses not allowed");
 
 		if(naddrs == 1) {
@@ -459,7 +459,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->l4proto = xtables_parse_protocol(optarg);
 
 		if (info->l4proto == 0 && (info->invert_flags & XT_INV_PROTO))
-			exit_error(PARAMETER_PROBLEM, "conntrack: rule would "
+			xtables_error(PARAMETER_PROBLEM, "conntrack: rule would "
 			           "never match protocol");
 
 		info->match_flags |= XT_CONNTRACK_PROTO;
@@ -555,7 +555,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ipparse_any(optarg, &addr, &info->origsrc_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->origsrc_addr.in, addr, sizeof(*addr));
@@ -568,7 +568,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ipparse_any(optarg, &addr, &info->origdst_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
@@ -581,7 +581,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ipparse_any(optarg, &addr, &info->replsrc_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
@@ -594,7 +594,7 @@ conntrack_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ipparse_any(optarg, &addr, &info->repldst_mask.in,
 		                        &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
@@ -625,7 +625,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ip6parse_any(optarg, &addr,
 		                         &info->origsrc_mask.in6, &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->origsrc_addr.in6, addr, sizeof(*addr));
@@ -638,7 +638,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ip6parse_any(optarg, &addr,
 		                         &info->origdst_mask.in6, &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->origdst_addr.in, addr, sizeof(*addr));
@@ -651,7 +651,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ip6parse_any(optarg, &addr,
 		                         &info->replsrc_mask.in6, &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->replsrc_addr.in, addr, sizeof(*addr));
@@ -664,7 +664,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_ip6parse_any(optarg, &addr,
 		                         &info->repldst_mask.in6, &naddrs);
 		if (naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "multiple IP addresses not allowed");
 		if (naddrs == 1)
 			memcpy(&info->repldst_addr.in, addr, sizeof(*addr));
@@ -685,7 +685,7 @@ conntrack_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 static void conntrack_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "conntrack: At least one option "
+		xtables_error(PARAMETER_PROBLEM, "conntrack: At least one option "
 		           "is required");
 }
 
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index dbf6223..413624e 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -72,7 +72,7 @@ parse_dccp_ports(const char *portstring,
 		ports[1] = cp[0] ? xtables_parse_port(cp, "dccp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "invalid portrange (min > max)");
 	}
 	free(buffer);
@@ -109,7 +109,7 @@ parse_dccp_types(const char *typestring)
 			}
 		}
 		if (i == sizeof(dccp_pkt_types)/sizeof(char *))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown DCCP type `%s'", ptr);
 	}
 
@@ -122,7 +122,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 	unsigned int ret;
 
 	if (!xtables_strtoui(optstring, NULL, &ret, 1, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
+		xtables_error(PARAMETER_PROBLEM, "Bad DCCP option \"%s\"",
 			   optstring);
 
 	return ret;
@@ -138,7 +138,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & XT_DCCP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_DCCP_SRC_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -150,7 +150,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & XT_DCCP_DEST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_DCCP_DEST_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -162,7 +162,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		if (*flags & XT_DCCP_TYPE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-types' allowed");
 		einfo->flags |= XT_DCCP_TYPE;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -174,7 +174,7 @@ dccp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '4':
 		if (*flags & XT_DCCP_OPTION)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--dccp-option' allowed");
 		einfo->flags |= XT_DCCP_OPTION;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index e57c267..62fa6af 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -49,11 +49,11 @@ parse_dscp(const char *s, struct xt_dscp_info *dinfo)
 	unsigned int dscp;
        
 	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
 	if (dscp > XT_DSCP_MAX)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "DSCP `%d` out of range\n", dscp);
 
 	dinfo->dscp = dscp;
@@ -80,7 +80,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'F':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "DSCP match: Only use --dscp ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_dscp(argv[optind-1], dinfo);
@@ -91,7 +91,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'G':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 					"DSCP match: Only use --dscp-class ONCE!");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_class(argv[optind - 1], dinfo);
@@ -110,7 +110,7 @@ dscp_parse(int c, char **argv, int invert, unsigned int *flags,
 static void dscp_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "DSCP match: Parameter --dscp is required");
 }
 
diff --git a/extensions/libxt_esp.c b/extensions/libxt_esp.c
index 2cc6b60..5769edb 100644
--- a/extensions/libxt_esp.c
+++ b/extensions/libxt_esp.c
@@ -32,15 +32,15 @@ parse_esp_spi(const char *spistr)
 	spi =  strtoul(spistr,&ep,0) ;
 
 	if ( spistr == ep ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "ESP no valid digits in spi `%s'", spistr);
 	}
 	if ( spi == ULONG_MAX  && errno == ERANGE ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "spi `%s' specified too big: would overflow", spistr);
 	}	
 	if ( *spistr != '\0'  && *ep != '\0' ) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "ESP error parsing spi `%s'", spistr);
 	}
 	return spi;
@@ -62,7 +62,7 @@ parse_esp_spis(const char *spistring, u_int32_t *spis)
 		spis[0] = buffer[0] ? parse_esp_spi(buffer) : 0;
 		spis[1] = cp[0] ? parse_esp_spi(cp) : 0xFFFFFFFF;
 		if (spis[0] > spis[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid ESP spi range: %s", spistring);
 	}
 	free(buffer);
@@ -86,7 +86,7 @@ esp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & ESP_SPI)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--espspi' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_esp_spis(argv[optind-1], espinfo->spis);
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index b05e8c8..5377b6d 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -124,7 +124,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 	/* This would get mapped to infinite (1/day is minimum they
            can specify, so we're ok at that end). */
 	if (r / mult > XT_HASHLIMIT_SCALE)
-		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 
 	*val = XT_HASHLIMIT_SCALE * mult / r;
 	return 1;
@@ -221,7 +221,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_LIMIT);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->cfg.avg))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		*flags |= PARAM_LIMIT;
 		break;
@@ -231,7 +231,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_BURST);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-burst `%s'", optarg);
 		r->cfg.burst = num;
 		*flags |= PARAM_BURST;
@@ -241,7 +241,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_SIZE);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
 		r->cfg.size = num;
 		*flags |= PARAM_SIZE;
@@ -251,7 +251,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_MAX);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
 		r->cfg.max = num;
 		*flags |= PARAM_MAX;
@@ -262,7 +262,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_GCINTERVAL);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
 				optarg);
 		/* FIXME: not HZ dependent!! */
@@ -274,7 +274,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
 		/* FIXME: not HZ dependent */
 		r->cfg.expire = num;
@@ -285,7 +285,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_MODE);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (parse_mode(&r->cfg.mode, optarg) < 0)
-			exit_error(PARAMETER_PROBLEM, 
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-mode: `%s'\n", optarg);
 		*flags |= PARAM_MODE;
 		break;
@@ -294,7 +294,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & PARAM_NAME);
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (strlen(optarg) == 0)
-			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
+			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(r->name, optarg, sizeof(r->name));
 		*flags |= PARAM_NAME;
 		break;
@@ -303,7 +303,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "hashlimit does not support invert");
 
 	return 1;
@@ -404,7 +404,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		xtables_param_act(XTF_ONLY_ONCE, "hashlimit", "--hashlimit-name",
 		          *flags & PARAM_NAME);
 		if (strlen(optarg) == 0)
-			exit_error(PARAMETER_PROBLEM, "Zero-length name?");
+			xtables_error(PARAMETER_PROBLEM, "Zero-length name?");
 		strncpy(info->name, optarg, sizeof(info->name));
 		info->name[sizeof(info->name)-1] = '\0';
 		*flags |= PARAM_NAME;
@@ -452,23 +452,23 @@ hashlimit_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 static void hashlimit_check(unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit");
 	if (!(flags & PARAM_MODE))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit-mode");
 	if (!(flags & PARAM_NAME))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 				"You have to specify --hashlimit-name");
 }
 
 static void hashlimit_mt_check(unsigned int flags)
 {
 	if (!(flags & PARAM_LIMIT))
-		exit_error(PARAMETER_PROBLEM, "You have to specify "
+		xtables_error(PARAMETER_PROBLEM, "You have to specify "
 		           "--hashlimit-upto or --hashlimit-above");
 	if (!(flags & PARAM_NAME))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "You have to specify --hashlimit-name");
 }
 
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 569ad69..8378be7 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -29,7 +29,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 					"helper match: Only use --helper ONCE!");
 		xtables_check_inverse(optarg, &invert, &invert, 0);
 		strncpy(info->name, optarg, 29);
@@ -48,7 +48,7 @@ helper_parse(int c, char **argv, int invert, unsigned int *flags,
 static void helper_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "helper match: You must specify `--helper'");
 }
 
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index df6be14..bc5b2ae 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -42,14 +42,14 @@ parse_iprange(char *arg, struct ipt_iprange *range)
 
 	ip = xtables_numeric_to_ipaddr(arg);
 	if (!ip)
-		exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
+		xtables_error(PARAMETER_PROBLEM, "iprange match: Bad IP address \"%s\"\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash != NULL) {
 		ip = xtables_numeric_to_ipaddr(dash+1);
 		if (!ip)
-			exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
+			xtables_error(PARAMETER_PROBLEM, "iprange match: Bad IP address \"%s\"\n",
 				   dash+1);
 		range->max_ip = ip->s_addr;
 	} else {
@@ -65,7 +65,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & IPRANGE_SRC)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "iprange match: Only use --src-range ONCE!");
 		*flags |= IPRANGE_SRC;
 
@@ -79,7 +79,7 @@ static int iprange_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & IPRANGE_DST)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "iprange match: Only use --dst-range ONCE!");
 		*flags |= IPRANGE_DST;
 
@@ -201,7 +201,7 @@ iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
 static void iprange_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "iprange match: You must specify `--src-range' or `--dst-range'");
 }
 
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index cf944e2..7bb31a8 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -27,7 +27,7 @@ parse_length(const char *s)
 	unsigned int len;
 	
 	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
-		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
+		xtables_error(PARAMETER_PROBLEM, "length invalid: \"%s\"\n", s);
 	else
 		return len;
 }
@@ -52,7 +52,7 @@ parse_lengths(const char *s, struct xt_length_info *info)
 	free(buffer);
 	
 	if (info->min > info->max)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "length min. range value `%u' greater than max. "
 		           "range value `%u'", info->min, info->max);
 	
@@ -67,7 +67,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		case '1':
 			if (*flags)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "length: `--length' may only be "
 				           "specified once");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -86,7 +86,7 @@ length_parse(int c, char **argv, int invert, unsigned int *flags,
 static void length_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "length: You must specify `--length'");
 }
 
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 7edfa3d..f785d2d 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -64,7 +64,7 @@ int parse_rate(const char *rate, u_int32_t *val)
 	/* This would get mapped to infinite (1/day is minimum they
            can specify, so we're ok at that end). */
 	if (r / mult > XT_LIMIT_SCALE)
-		exit_error(PARAMETER_PROBLEM, "Rate too fast `%s'\n", rate);
+		xtables_error(PARAMETER_PROBLEM, "Rate too fast \"%s\"\n", rate);
 
 	*val = XT_LIMIT_SCALE * mult / r;
 	return 1;
@@ -81,7 +81,7 @@ static void limit_init(struct xt_entry_match *m)
 
 /* FIXME: handle overflow:
 	if (r->avg*r->burst/r->burst != r->avg)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Sorry: burst too large for that avg rate.\n");
 */
 
@@ -96,14 +96,14 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '%':
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!parse_rate(optarg, &r->avg))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad rate `%s'", optarg);
 		break;
 
 	case '$':
 		if (xtables_check_inverse(argv[optind-1], &invert, &optind, 0)) break;
 		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
 		r->burst = num;
 		break;
@@ -113,7 +113,7 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "limit does not support invert");
 
 	return 1;
diff --git a/extensions/libxt_mac.c b/extensions/libxt_mac.c
index b516d80..a57e341 100644
--- a/extensions/libxt_mac.c
+++ b/extensions/libxt_mac.c
@@ -31,7 +31,7 @@ parse_mac(const char *mac, struct xt_mac_info *info)
 	unsigned int i = 0;
 
 	if (strlen(mac) != ETH_ALEN*3-1)
-		exit_error(PARAMETER_PROBLEM, "Bad mac address `%s'", mac);
+		xtables_error(PARAMETER_PROBLEM, "Bad mac address \"%s\"", mac);
 
 	for (i = 0; i < ETH_ALEN; i++) {
 		long number;
@@ -44,7 +44,7 @@ parse_mac(const char *mac, struct xt_mac_info *info)
 		    && number <= 255)
 			info->srcaddr[i] = number;
 		else
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Bad mac address `%s'", mac);
 	}
 }
@@ -84,7 +84,7 @@ static void print_mac(const unsigned char macaddress[ETH_ALEN])
 static void mac_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "You must specify `--mac-source'");
 }
 
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 1143ba9..ceca995 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -69,7 +69,7 @@ mark_parse(int c, char **argv, int invert, unsigned int *flags,
 		} else
 			markinfo->mask = 0xffffffff;
 		if (*end != '\0' || end == optarg)
-			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad MARK value \"%s\"", optarg);
 		if (invert)
 			markinfo->invert = 1;
 		*flags = 1;
@@ -92,7 +92,7 @@ static void print_mark(unsigned int mark, unsigned int mask)
 static void mark_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "mark match: The --mark option is required");
 }
 
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index d0e830d..8141441 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -75,7 +75,7 @@ parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 	unsigned int i;
 
 	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
 
 	for (cp=buffer, i=0; cp && i<XT_MULTI_PORTS; cp=next,i++)
 	{
@@ -83,7 +83,7 @@ parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 		if (next) *next++='\0';
 		ports[i] = xtables_parse_port(cp, proto);
 	}
-	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+	if (cp) xtables_error(PARAMETER_PROBLEM, "too many ports specified");
 	free(buffer);
 	return i;
 }
@@ -98,7 +98,7 @@ parse_multi_ports_v1(const char *portstring,
 	u_int16_t m;
 
 	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+	if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
 
 	for (i=0; i<XT_MULTI_PORTS; i++)
 		multiinfo->pflags[i] = 0;
@@ -109,7 +109,7 @@ parse_multi_ports_v1(const char *portstring,
 		range = strchr(cp, ':');
 		if (range) {
 			if (i == XT_MULTI_PORTS-1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "too many ports specified");
 			*range++ = '\0';
 		}
@@ -118,13 +118,13 @@ parse_multi_ports_v1(const char *portstring,
 			multiinfo->pflags[i] = 1;
 			multiinfo->ports[++i] = xtables_parse_port(range, proto);
 			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "invalid portrange specified");
 			m <<= 1;
 		}
  	}
 	multiinfo->count = i;
- 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+	if (cp) xtables_error(PARAMETER_PROBLEM, "too many ports specified");
  	free(buffer);
 }
 
@@ -134,17 +134,17 @@ check_proto(u_int16_t pnum, u_int8_t invflags)
 	char *proto;
 
 	if (invflags & XT_INV_PROTO)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 
 	if ((proto = proto_to_name(pnum)) != NULL)
 		return proto;
 	else if (!pnum)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport needs `-p tcp', `-p udp', `-p udplite', "
 			   "`-p sctp' or `-p dccp'");
 	else
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 }
 
@@ -189,11 +189,11 @@ __multiport_parse(int c, char **argv, int invert, unsigned int *flags,
 	}
 
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport does not support invert");
 
 	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
 	*flags = 1;
 	return 1;
@@ -256,7 +256,7 @@ __multiport_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		multiinfo->invert = 1;
 
 	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
 	*flags = 1;
 	return 1;
@@ -284,7 +284,7 @@ multiport_parse6_v1(int c, char **argv, int invert, unsigned int *flags,
 static void multiport_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
+		xtables_error(PARAMETER_PROBLEM, "multiport expection an option");
 }
 
 static char *
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index bf26f35..d27b3ae 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -163,7 +163,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	case 'c':
 		xtables_param_act(XTF_ONLY_ONCE, "owner", "--cmd-owner", *flags & FLAG_COMM);
 		if (strlen(optarg) > sizeof(info->comm))
-			exit_error(PARAMETER_PROBLEM, "owner match: command "
+			xtables_error(PARAMETER_PROBLEM, "owner match: command "
 			           "\"%s\" too long, max. %zu characters",
 			           optarg, sizeof(info->comm));
 
@@ -316,7 +316,7 @@ static int owner_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 static void owner_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "owner: At least one of "
+		xtables_error(PARAMETER_PROBLEM, "owner: At least one of "
 		           "--uid-owner, --gid-owner or --socket-exists "
 		           "is required");
 }
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index 4275a1a..c87779b 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -100,7 +100,7 @@ physdev_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	return 1;
 multiple_use:
-	exit_error(PARAMETER_PROBLEM,
+	xtables_error(PARAMETER_PROBLEM,
 	   "multiple use of the same physdev option is not allowed");
 
 }
@@ -108,7 +108,7 @@ multiple_use:
 static void physdev_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
+		xtables_error(PARAMETER_PROBLEM, "PHYSDEV: no physdev option specified");
 }
 
 static void
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 8caba91..0fa933f 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -80,7 +80,7 @@ static void parse_pkttype(const char *pkttype, struct xt_pkttype_info *info)
 		}
 	}
 	
-	exit_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
+	xtables_error(PARAMETER_PROBLEM, "Bad packet type '%s'", pkttype);
 }
 
 static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
@@ -108,7 +108,7 @@ static int pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
 static void pkttype_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "You must specify `--pkt-type'");
+		xtables_error(PARAMETER_PROBLEM, "You must specify \"--pkt-type\"");
 }
 
 static void print_pkttype(struct xt_pkttype_info *info)
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 8c91fb8..2657b2a 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -47,7 +47,7 @@ parse_quota(const char *s, u_int64_t * quota)
 #endif
 
 	if (*quota == UINT64_MAX)
-		exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
+		xtables_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
 	else
 		return 1;
 }
@@ -61,9 +61,9 @@ quota_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (xtables_check_inverse(optarg, &invert, NULL, 0))
-			exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
+			xtables_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
 		if (!parse_quota(optarg, &info->quota))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "bad quota: '%s'", optarg);
 		break;
 
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 8a8836b..3cff07d 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -120,11 +120,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST1:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest1 twice");
 		*flags |= 1 << c;
 
@@ -134,11 +134,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST2:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest2 twice");
 		*flags |= 1 << c;
 
@@ -149,11 +149,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST_BPS1:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest-bps1 twice");
 		*flags |= 1 << c;
 
@@ -164,7 +164,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		if (rateest_get_rate(&info->bps1, argv[optind]) < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
 				   argv[optind]);
 		optind++;
@@ -173,11 +173,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST_PPS1:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest-pps1 twice");
 		*flags |= 1 << c;
 
@@ -188,7 +188,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
 				   argv[optind]);
 		info->pps1 = val;
@@ -198,11 +198,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST_BPS2:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest-bps2 twice");
 		*flags |= 1 << c;
 
@@ -213,7 +213,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		if (rateest_get_rate(&info->bps2, argv[optind]) < 0)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse rate `%s'",
 				   argv[optind]);
 		optind++;
@@ -222,11 +222,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST_PPS2:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest-pps2 twice");
 		*flags |= 1 << c;
 
@@ -237,7 +237,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 			break;
 
 		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
 				   argv[optind]);
 		info->pps2 = val;
@@ -247,11 +247,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	case OPT_RATEEST_DELTA:
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-delta can't be inverted");
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify --rateest-delta twice");
 		*flags |= 1 << c;
 
@@ -262,7 +262,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
 		*flags |= 1 << c;
 
@@ -275,7 +275,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
 		*flags |= 1 << c;
 
@@ -288,7 +288,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
 
 		if (*flags & (1 << c))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
 		*flags |= 1 << c;
 
@@ -310,7 +310,7 @@ rateest_final_check(unsigned int flags)
 	struct xt_rateest_match_info *info = rateest_info;
 
 	if (info == NULL)
-		exit_error(PARAMETER_PROBLEM, "rateest match: "
+		xtables_error(PARAMETER_PROBLEM, "rateest match: "
 		           "you need to specify some flags");
 	if (!(info->flags & XT_RATEEST_MATCH_REL))
 		info->flags |= XT_RATEEST_MATCH_ABS;
diff --git a/extensions/libxt_recent.c b/extensions/libxt_recent.c
index 1646705..47c35ff 100644
--- a/extensions/libxt_recent.c
+++ b/extensions/libxt_recent.c
@@ -70,7 +70,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 		case 201:
 			if (*flags & RECENT_CMDS)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -81,7 +81,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case 202:
 			if (*flags & RECENT_CMDS)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -92,7 +92,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case 203:
 			if (*flags & RECENT_CMDS)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -103,7 +103,7 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 
 		case 206:
 			if (*flags & RECENT_CMDS)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"recent: only one of `--set', `--rcheck' "
 					"`--update' or `--remove' may be set");
 			xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -148,12 +148,12 @@ static int recent_parse(int c, char **argv, int invert, unsigned int *flags,
 static void recent_check(unsigned int flags)
 {
 	if (!(flags & RECENT_CMDS))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"recent: you must specify one of `--set', `--rcheck' "
 			"`--update' or `--remove'");
 	if ((flags & XT_RECENT_TTL) &&
 	    (flags & (XT_RECENT_SET | XT_RECENT_REMOVE)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "recent: --rttl may only be used with --rcheck or "
 		           "--update");
 }
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 2ee4861..b889406 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -95,7 +95,7 @@ parse_sctp_ports(const char *portstring,
 		ports[1] = cp[0] ? xtables_parse_port(cp, "sctp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "invalid portrange (min > max)");
 	}
 	free(buffer);
@@ -151,7 +151,7 @@ save_chunk_flag_info(struct xt_sctp_flag_info *flag_info,
 	}
 	
 	if (*flag_count == XT_NUM_SCTP_FLAGS) {
-		exit_error (PARAMETER_PROBLEM,
+		xtables_error (PARAMETER_PROBLEM,
 			"Number of chunk types with flags exceeds currently allowed limit."
 			"Increasing this limit involves changing IPT_NUM_SCTP_FLAGS and"
 			"recompiling both the kernel space and user space modules\n");
@@ -208,7 +208,7 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 			}
 		}
 		if (!found)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown sctp chunk `%s'", ptr);
 
 		if (chunk_flags) {
@@ -226,7 +226,7 @@ parse_sctp_chunk(struct xt_sctp_info *einfo,
 						&(einfo->flag_count), i, bit, 
 						isupper(chunk_flags[j]));
 				} else {
-					exit_error(PARAMETER_PROBLEM, 
+					xtables_error(PARAMETER_PROBLEM,
 						"Invalid flags for chunk type %d\n", i);
 				}
 			}
@@ -249,7 +249,7 @@ parse_sctp_chunks(struct xt_sctp_info *einfo,
 	} else 	if (!strcasecmp(match_type, "ONLY")) {
 		einfo->chunk_match_type = SCTP_CHUNK_MATCH_ONLY;
 	} else {
-		exit_error (PARAMETER_PROBLEM, 
+		xtables_error (PARAMETER_PROBLEM,
 			"Match type has to be one of \"ALL\", \"ANY\" or \"ONLY\"");
 	}
 
@@ -267,7 +267,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & XT_SCTP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_SCTP_SRC_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -279,7 +279,7 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & XT_SCTP_DEST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_SCTP_DEST_PORTS;
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -291,13 +291,13 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		if (*flags & XT_SCTP_CHUNK_TYPES)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--chunk-types' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (!argv[optind] 
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--chunk-types requires two args");
 
 		einfo->flags |= XT_SCTP_CHUNK_TYPES;
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 5182230..0f26443 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -51,15 +51,15 @@ state_parse_states(const char *arg, struct xt_state_info *sinfo)
 
 	while ((comma = strchr(arg, ',')) != NULL) {
 		if (comma == arg || !state_parse_state(arg, comma-arg, sinfo))
-			exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
+			xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
 		arg = comma+1;
 	}
 	if (!*arg)
-		exit_error(PARAMETER_PROBLEM, "`--state' requires a list of "
+		xtables_error(PARAMETER_PROBLEM, "\"--state\" requires a list of "
 					      "states with no spaces, e.g. "
 					      "ESTABLISHED,RELATED");
 	if (strlen(arg) == 0 || !state_parse_state(arg, strlen(arg), sinfo))
-		exit_error(PARAMETER_PROBLEM, "Bad state `%s'", arg);
+		xtables_error(PARAMETER_PROBLEM, "Bad state \"%s\"", arg);
 }
 
 static int
@@ -89,7 +89,7 @@ state_parse(int c, char **argv, int invert, unsigned int *flags,
 static void state_final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "You must specify `--state'");
+		xtables_error(PARAMETER_PROBLEM, "You must specify \"--state\"");
 }
 
 static void state_print_state(unsigned int statemask)
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index 574f8f7..fa044ad 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -49,42 +49,42 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & 0x1)
-			exit_error(PARAMETER_PROBLEM, "double --mode");
+			xtables_error(PARAMETER_PROBLEM, "double --mode");
 		if (!strcmp(optarg, "random"))
 			info->mode = XT_STATISTIC_MODE_RANDOM;
 		else if (!strcmp(optarg, "nth"))
 			info->mode = XT_STATISTIC_MODE_NTH;
 		else
-			exit_error(PARAMETER_PROBLEM, "Bad mode `%s'", optarg);
+			xtables_error(PARAMETER_PROBLEM, "Bad mode \"%s\"", optarg);
 		*flags |= 0x1;
 		break;
 	case '2':
 		if (*flags & 0x2)
-			exit_error(PARAMETER_PROBLEM, "double --probability");
+			xtables_error(PARAMETER_PROBLEM, "double --probability");
 		prob = atof(optarg);
 		if (prob < 0 || prob > 1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--probability must be between 0 and 1");
 		info->u.random.probability = 0x80000000 * prob;
 		*flags |= 0x2;
 		break;
 	case '3':
 		if (*flags & 0x4)
-			exit_error(PARAMETER_PROBLEM, "double --every");
+			xtables_error(PARAMETER_PROBLEM, "double --every");
 		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "cannot parse --every `%s'", optarg);
 		info->u.nth.every = val;
 		if (info->u.nth.every == 0)
-			exit_error(PARAMETER_PROBLEM, "--every cannot be 0");
+			xtables_error(PARAMETER_PROBLEM, "--every cannot be 0");
 		info->u.nth.every--;
 		*flags |= 0x4;
 		break;
 	case '4':
 		if (*flags & 0x8)
-			exit_error(PARAMETER_PROBLEM, "double --packet");
+			xtables_error(PARAMETER_PROBLEM, "double --packet");
 		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "cannot parse --packet `%s'", optarg);
 		info->u.nth.packet = val;
 		*flags |= 0x8;
@@ -98,25 +98,25 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 static void statistic_check(unsigned int flags)
 {
 	if (!(flags & 0x1))
-		exit_error(PARAMETER_PROBLEM, "no mode specified");
+		xtables_error(PARAMETER_PROBLEM, "no mode specified");
 	if ((flags & 0x2) && (flags & (0x4 | 0x8)))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "both nth and random parameters given");
 	if (flags & 0x2 && global_info->mode != XT_STATISTIC_MODE_RANDOM)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--probability can only be used in random mode");
 	if (flags & 0x4 && global_info->mode != XT_STATISTIC_MODE_NTH)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--every can only be used in nth mode");
 	if (flags & 0x8 && global_info->mode != XT_STATISTIC_MODE_NTH)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--packet can only be used in nth mode");
 	if ((flags & 0x8) && !(flags & 0x4))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "--packet can only be used with --every");
 	/* at this point, info->u.nth.every have been decreased. */
 	if (global_info->u.nth.packet > global_info->u.nth.every)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			  "the --packet p must be 0 <= p <= n-1");
 
 
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index aa52fa8..5ea529e 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -69,7 +69,7 @@ parse_string(const char *s, struct xt_string_info *info)
 		info->patlen = strlen(s);
 		return;
 	}
-	exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "STRING too long \"%s\"", s);
 }
 
 static void
@@ -79,7 +79,7 @@ parse_algo(const char *s, struct xt_string_info *info)
 		strncpy(info->algo, s, XT_STRING_MAX_ALGO_NAME_SIZE);
 		return;
 	}
-	exit_error(PARAMETER_PROBLEM, "ALGO too long `%s'", s);
+	xtables_error(PARAMETER_PROBLEM, "ALGO too long \"%s\"", s);
 }
 
 static void
@@ -92,7 +92,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 	slen = strlen(s);
 
 	if (slen == 0) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			"STRING must contain at least one char");
 	}
 
@@ -100,7 +100,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 		if (s[i] == '\\' && !hex_f) {
 			literal_f = 1;
 		} else if (s[i] == '\\') {
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				"Cannot include literals in hex data");
 		} else if (s[i] == '|') {
 			if (hex_f)
@@ -119,7 +119,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 
 		if (literal_f) {
 			if (i+1 >= slen) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"Bad literal placement at end of string");
 			}
 			info->pattern[sindex] = s[i+1];
@@ -127,22 +127,22 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 			literal_f = 0;
 		} else if (hex_f) {
 			if (i+1 >= slen) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"Odd number of hex digits");
 			}
 			if (i+2 >= slen) {
 				/* must end with a "|" */
-				exit_error(PARAMETER_PROBLEM, "Invalid hex block");
+				xtables_error(PARAMETER_PROBLEM, "Invalid hex block");
 			}
 			if (! isxdigit(s[i])) /* check for valid hex char */
-				exit_error(PARAMETER_PROBLEM, "Invalid hex char `%c'", s[i]);
+				xtables_error(PARAMETER_PROBLEM, "Invalid hex char '%c'", s[i]);
 			if (! isxdigit(s[i+1])) /* check for valid hex char */
-				exit_error(PARAMETER_PROBLEM, "Invalid hex char `%c'", s[i+1]);
+				xtables_error(PARAMETER_PROBLEM, "Invalid hex char '%c'", s[i+1]);
 			hextmp[0] = s[i];
 			hextmp[1] = s[i+1];
 			hextmp[2] = '\0';
 			if (! sscanf(hextmp, "%x", &schar))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"Invalid hex char `%c'", s[i]);
 			info->pattern[sindex] = (char) schar;
 			if (s[i+2] == ' ')
@@ -154,7 +154,7 @@ parse_hex_string(const char *s, struct xt_string_info *info)
 			i++;
 		}
 		if (sindex > XT_STRING_MAX_PATTERN_SIZE)
-			exit_error(PARAMETER_PROBLEM, "STRING too long `%s'", s);
+			xtables_error(PARAMETER_PROBLEM, "STRING too long \"%s\"", s);
 		sindex++;
 	}
 	info->patlen = sindex;
@@ -177,28 +177,28 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & FROM)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --from");
 		stringinfo->from_offset = atoi(optarg);
 		*flags |= FROM;
 		break;
 	case '2':
 		if (*flags & TO)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --to");
 		stringinfo->to_offset = atoi(optarg);
 		*flags |= TO;
 		break;
 	case '3':
 		if (*flags & ALGO)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --algo");
 		parse_algo(optarg, stringinfo);
 		*flags |= ALGO;
 		break;
 	case '4':
 		if (*flags & STRING)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --string");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_string(argv[optind-1], stringinfo);
@@ -215,7 +215,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '5':
 		if (*flags & STRING)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Can't specify multiple --hex-string");
 
 		xtables_check_inverse(optarg, &invert, &optind, 0);
@@ -231,7 +231,7 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '6':
 		if (revision == 0)
-			exit_error(VERSION_PROBLEM,
+			xtables_error(VERSION_PROBLEM,
 				   "Kernel doesn't support --icase");
 
 		stringinfo->u.v1.flags |= XT_STRING_FLAG_IGNORECASE;
@@ -247,11 +247,11 @@ string_parse(int c, char **argv, int invert, unsigned int *flags,
 static void string_check(unsigned int flags)
 {
 	if (!(flags & STRING))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "STRING match: You must specify `--string' or "
 			   "`--hex-string'");
 	if (!(flags & ALGO))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "STRING match: You must specify `--algo'");
 }
 
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 069bb7f..d2ad53b 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -53,7 +53,7 @@ parse_tcp_ports(const char *portstring, u_int16_t *ports)
 		ports[1] = cp[0] ? xtables_parse_port(cp, "tcp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "invalid portrange (min > max)");
 	}
 	free(buffer);
@@ -95,7 +95,7 @@ parse_tcp_flag(const char *flags)
 			}
 		}
 		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Unknown TCP flag `%s'", ptr);
 		}
 
@@ -122,7 +122,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 	unsigned int ret;
 
 	if (!xtables_strtoui(option, NULL, &ret, 1, UINT8_MAX))
-		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
+		xtables_error(PARAMETER_PROBLEM, "Bad TCP option \"%s\"", option);
 
 	*result = ret;
 }
@@ -148,7 +148,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & TCP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
@@ -159,7 +159,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & TCP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
@@ -170,7 +170,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one of `--syn' or `--tcp-flags' "
 				   " allowed");
 		parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", invert);
@@ -179,14 +179,14 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '4':
 		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one of `--syn' or `--tcp-flags' "
 				   " allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 
 		if (!argv[optind]
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "--tcp-flags requires two args.");
 
 		parse_tcp_flags(tcpinfo, argv[optind-1], argv[optind],
@@ -197,7 +197,7 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '5':
 		if (*flags & TCP_OPTION)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--tcp-option' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_option(argv[optind-1], &tcpinfo->option);
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index 5c013a7..43a4a0d 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -29,7 +29,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 	if (!xtables_strtoui(mssvalue, NULL, &mssvaluenum, 0, UINT16_MAX))
 		return mssvaluenum;
 
-	exit_error(PARAMETER_PROBLEM,
+	xtables_error(PARAMETER_PROBLEM,
 		   "Invalid mss `%s' specified", mssvalue);
 }
 
@@ -63,7 +63,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--mss' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_tcp_mssvalues(argv[optind-1],
@@ -81,7 +81,7 @@ tcpmss_parse(int c, char **argv, int invert, unsigned int *flags,
 static void tcpmss_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "tcpmss match: You must specify `--mss'");
 }
 
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index 41aa5c7..eb8b671 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -142,10 +142,10 @@ static time_t time_parse_date(const char *s, bool end)
 	if (ret >= 0)
 		return ret;
 	perror("mktime");
-	exit_error(OTHER_PROBLEM, "mktime returned an error");
+	xtables_error(OTHER_PROBLEM, "mktime returned an error");
 
  out:
-	exit_error(PARAMETER_PROBLEM, "Invalid date \"%s\" specified. Should "
+	xtables_error(PARAMETER_PROBLEM, "Invalid date \"%s\" specified. Should "
 	           "be YYYY[-MM[-DD[Thh[:mm[:ss]]]]]", os);
 	return -1;
 }
@@ -175,7 +175,7 @@ static unsigned int time_parse_minutes(const char *s)
 	return 60 * 60 * hour + 60 * minute + second;
 
  out:
-	exit_error(PARAMETER_PROBLEM, "invalid time \"%s\" specified, "
+	xtables_error(PARAMETER_PROBLEM, "invalid time \"%s\" specified, "
 	           "should be hh:mm[:ss] format and within the boundaries", s);
 	return -1;
 }
@@ -207,7 +207,7 @@ static uint32_t time_parse_monthdays(const char *arg)
 	while (my_strseg(day, sizeof(day), &arg, ',') != NULL) {
 		i = strtoul(day, &err, 0);
 		if ((*err != ',' && *err != '\0') || i > 31)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "%s is not a valid day for --monthdays", day);
 		ret |= 1 << i;
 	}
@@ -225,7 +225,7 @@ static unsigned int time_parse_weekdays(const char *arg)
 		i = strtoul(day, &err, 0);
 		if (*err == '\0') {
 			if (i == 0)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "No, the week does NOT begin with Sunday.");
 			ret |= 1 << i;
 			continue;
@@ -239,7 +239,7 @@ static unsigned int time_parse_weekdays(const char *arg)
 			}
 
 		if (!valid)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "%s is not a valid day specifier", day);
 	}
 
@@ -254,54 +254,54 @@ static int time_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case 'D': /* --datestart */
 		if (*flags & F_DATE_START)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --datestart twice");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Unexpected \"!\" with --datestart");
 		info->date_start = time_parse_date(optarg, false);
 		*flags |= F_DATE_START;
 		return 1;
 	case 'E': /* --datestop */
 		if (*flags & F_DATE_STOP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --datestop more than once");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "unexpected \"!\" with --datestop");
 		info->date_stop = time_parse_date(optarg, true);
 		*flags |= F_DATE_STOP;
 		return 1;
 	case 'X': /* --timestart */
 		if (*flags & F_TIME_START)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --timestart more than once");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Unexpected \"!\" with --timestart");
 		info->daytime_start = time_parse_minutes(optarg);
 		*flags |= F_TIME_START;
 		return 1;
 	case 'Y': /* --timestop */
 		if (*flags & F_TIME_STOP)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --timestop more than once");
 		if (invert)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Unexpected \"!\" with --timestop");
 		info->daytime_stop = time_parse_minutes(optarg);
 		*flags |= F_TIME_STOP;
 		return 1;
 	case 'l': /* --localtz */
 		if (*flags & F_TIMEZONE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Can only specify exactly one of --localtz or --utc");
 		info->flags |= XT_TIME_LOCAL_TZ;
 		*flags |= F_TIMEZONE;
 		return 1;
 	case 'm': /* --monthdays */
 		if (*flags & F_MONTHDAYS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --monthdays more than once");
 		info->monthdays_match = time_parse_monthdays(optarg);
 		if (invert)
@@ -310,7 +310,7 @@ static int time_parse(int c, char **argv, int invert, unsigned int *flags,
 		return 1;
 	case 'w': /* --weekdays */
 		if (*flags & F_WEEKDAYS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Cannot specify --weekdays more than once");
 		info->weekdays_match = time_parse_weekdays(optarg);
 		if (invert)
@@ -319,7 +319,7 @@ static int time_parse(int c, char **argv, int invert, unsigned int *flags,
 		return 1;
 	case 'u': /* --utc */
 		if (*flags & F_TIMEZONE)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 			           "Can only specify exactly one of --localtz or --utc");
 		info->flags &= ~XT_TIME_LOCAL_TZ;
 		*flags |= F_TIMEZONE;
diff --git a/extensions/libxt_tos.c b/extensions/libxt_tos.c
index a611840..b810ea6 100644
--- a/extensions/libxt_tos.c
+++ b/extensions/libxt_tos.c
@@ -54,7 +54,7 @@ static int tos_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (!tos_parse_symbolic(optarg, &tvm, 0xFF))
 			xtables_param_act(XTF_BAD_VALUE, "tos", "--tos", optarg);
 		if (tvm.mask != 0xFF)
-			exit_error(PARAMETER_PROBLEM, "tos: Your kernel is "
+			xtables_error(PARAMETER_PROBLEM, "tos: Your kernel is "
 			           "too old to support anything besides /0xFF "
 				   "as a mask.");
 		info->tos = tvm.value;
@@ -90,7 +90,7 @@ static int tos_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 static void tos_mt_check(unsigned int flags)
 {
 	if (flags == 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 		           "tos: --tos parameter required");
 }
 
diff --git a/extensions/libxt_u32.c b/extensions/libxt_u32.c
index f0bb61a..c2aeb27 100644
--- a/extensions/libxt_u32.c
+++ b/extensions/libxt_u32.c
@@ -92,10 +92,10 @@ static u_int32_t parse_number(char **s, int pos)
 	errno  = 0;
 	number = strtoul(*s, &end, 0);
 	if (end == *s)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "u32: at char %d: expected number", pos);
 	if (errno != 0)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "u32: at char %d: error reading number", pos);
 	*s = end;
 	return number;
@@ -129,10 +129,10 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*arg == '\0') {
 			/* end of argument found */
 			if (state == 0)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "u32: abrupt end of input after location specifier");
 			if (valind == 0)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "u32: test ended with no value specified");
 
 			ct->nnums    = locind;
@@ -140,7 +140,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 			data->ntests = ++testind;
 
 			if (testind > XT_U32_MAXSIZE)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 				           "u32: at char %u: too many \"&&\"s",
 				           (unsigned int)(arg - start));
 			return 1;
@@ -153,7 +153,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 			 */
 			if (*arg == '=') {
 				if (locind == 0) {
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 					           "u32: at char %u: "
 					           "location spec missing",
 					           (unsigned int)(arg - start));
@@ -168,18 +168,18 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 						ct->location[locind].nextop = XT_U32_AND;
 					} else if (*arg == '<') {
 						if (*++arg != '<')
-							exit_error(PARAMETER_PROBLEM,
+							xtables_error(PARAMETER_PROBLEM,
 								   "u32: at char %u: a second '<' was expected", (unsigned int)(arg - start));
 						ct->location[locind].nextop = XT_U32_LEFTSH;
 					} else if (*arg == '>') {
 						if (*++arg != '>')
-							exit_error(PARAMETER_PROBLEM,
+							xtables_error(PARAMETER_PROBLEM,
 								   "u32: at char %u: a second '>' was expected", (unsigned int)(arg - start));
 						ct->location[locind].nextop = XT_U32_RIGHTSH;
 					} else if (*arg == '@') {
 						ct->location[locind].nextop = XT_U32_AT;
 					} else {
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							"u32: at char %u: operator expected", (unsigned int)(arg - start));
 					}
 					++arg;
@@ -188,7 +188,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 				ct->location[locind].number =
 					parse_number(&arg, arg - start);
 				if (++locind > XT_U32_MAXSIZE)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "u32: at char %u: too many operators", (unsigned int)(arg - start));
 			}
 		} else {
@@ -199,17 +199,17 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 			 */
 			if (*arg == '&') {
 				if (*++arg != '&')
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "u32: at char %u: a second '&' was expected", (unsigned int)(arg - start));
 				if (valind == 0) {
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "u32: at char %u: value spec missing", (unsigned int)(arg - start));
 				} else {
 					ct->nnums   = locind;
 					ct->nvalues = valind;
 					ct = &data->tests[++testind];
 					if (testind > XT_U32_MAXSIZE)
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "u32: at char %u: too many \"&&\"s", (unsigned int)(arg - start));
 					++arg;
 					state  = 0;
@@ -219,7 +219,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 			} else { /* read value range */
 				if (valind > 0) { /* need , before number */
 					if (*arg != ',')
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "u32: at char %u: expected \",\" or \"&&\"", (unsigned int)(arg - start));
 					++arg;
 				}
@@ -239,7 +239,7 @@ static int u32_parse(int c, char **argv, int invert, unsigned int *flags,
 				}
 
 				if (++valind > XT_U32_MAXSIZE)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "u32: at char %u: too many \",\"s", (unsigned int)(arg - start));
 			}
 		}
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
index 8f57f4e..4b4e84f 100644
--- a/extensions/libxt_udp.c
+++ b/extensions/libxt_udp.c
@@ -45,7 +45,7 @@ parse_udp_ports(const char *portstring, u_int16_t *ports)
 		ports[1] = cp[0] ? xtables_parse_port(cp, "udp") : 0xFFFF;
 
 		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "invalid portrange (min > max)");
 	}
 	free(buffer);
@@ -70,7 +70,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		if (*flags & UDP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_udp_ports(argv[optind-1], udpinfo->spts);
@@ -81,7 +81,7 @@ udp_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		if (*flags & UDP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		xtables_check_inverse(optarg, &invert, &optind, 0);
 		parse_udp_ports(argv[optind-1], udpinfo->dpts);
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 81f6de1..2676d81 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -42,13 +42,13 @@ static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
 		const char *p = end + 1;
 
 		if (!xtables_strtoui(p, &end, &value, 0, max))
-			exit_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
+			xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
 			           str);
 		tvm->mask = value;
 	}
 
 	if (*end != '\0')
-		exit_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"", str);
+		xtables_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"", str);
 	return true;
 }
 
@@ -70,7 +70,7 @@ static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
 			return true;
 		}
 
-	exit_error(PARAMETER_PROBLEM, "Symbolic name \"%s\" is unknown", str);
+	xtables_error(PARAMETER_PROBLEM, "Symbolic name \"%s\" is unknown", str);
 	return false;
 }
 
diff --git a/include/xtables.h.in b/include/xtables.h.in
index c4d2b92..3f556c1 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -234,7 +234,7 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 int xtables_check_inverse(const char option[], int *invert,
 	int *my_optind, int argc);
 extern struct xtables_globals *xt_params;
-#define exit_error xt_params->exit_err
+#define xtables_error (xt_params->exit_err)
 
 extern void xtables_param_act(unsigned int, const char *, ...);
 
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 9b8596e..324dd1f 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -70,7 +70,7 @@ static struct ip6tc_handle *create_handle(const char *tablename)
 	}
 
 	if (!handle) {
-		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
+		xtables_error(PARAMETER_PROBLEM, "%s: unable to initialize "
 			"table '%s'\n", ip6tables_globals.program_name,
 			tablename);
 		exit(1);
@@ -211,7 +211,7 @@ int main(int argc, char *argv[])
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					ip6tables_globals.program_name,
 					line);
@@ -246,7 +246,7 @@ int main(int argc, char *argv[])
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
 			if (!chain) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   ip6tables_globals.program_name,
 					   line);
@@ -257,14 +257,14 @@ int main(int argc, char *argv[])
 				if (noflush && ip6tc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
 					if (!ip6tc_flush_entries(chain, handle))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
 					if (!ip6tc_create_chain(chain, handle))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
@@ -274,7 +274,7 @@ int main(int argc, char *argv[])
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
 			if (!policy) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   ip6tables_globals.program_name,
 					   line);
@@ -289,7 +289,7 @@ int main(int argc, char *argv[])
 					ctrs = strtok(NULL, " \t\n");
 
 					if (!ctrs || !parse_counters(ctrs, &count))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							  "invalid policy counters "
 							  "for chain '%s'\n", chain);
 
@@ -303,7 +303,7 @@ int main(int argc, char *argv[])
 
 				if (!ip6tc_set_policy(chain, policy, &count,
 						     handle))
-					exit_error(OTHER_PROBLEM,
+					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
 						chain, policy, line,
@@ -331,19 +331,19 @@ int main(int argc, char *argv[])
 				/* we have counters in our input */
 				ptr = strchr(buffer, ']');
 				if (!ptr)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
 				pcnt = strtok(buffer+1, ":");
 				if (!pcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need :\n",
 						   line);
 
 				bcnt = strtok(NULL, "]");
 				if (!bcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
@@ -410,7 +410,7 @@ int main(int argc, char *argv[])
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 2)
                                             || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
 						exit(1);
@@ -423,7 +423,7 @@ int main(int argc, char *argv[])
 					param_buffer[param_len++] = *curchar;
 
 					if (param_len >= sizeof(param_buffer))
-						exit_error(PARAMETER_PROBLEM, 
+						xtables_error(PARAMETER_PROBLEM,
 						   "Parameter too long!");
 				}
 			}
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 874542d..55010c4 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -42,13 +42,13 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	procfile = fopen("/proc/net/ip6_tables_names", "r");
 	if (!procfile)
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Unable to open /proc/net/ip6_tables_names: %s\n",
 			   strerror(errno));
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
-			exit_error(OTHER_PROBLEM, 
+			xtables_error(OTHER_PROBLEM,
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
@@ -69,7 +69,7 @@ static int do_output(const char *tablename)
 
 	h = ip6tc_init(tablename);
 	if (!h)
-		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
+		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s\n",
 			   ip6tc_strerror(errno));
 
 	if (!show_binary) {
@@ -115,7 +115,7 @@ static int do_output(const char *tablename)
 		printf("# Completed on %s", ctime(&now));
 	} else {
 		/* Binary, huh?  OK. */
-		exit_error(OTHER_PROBLEM, "Binary NYI\n");
+		xtables_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
 	ip6tc_free(h);
diff --git a/ip6tables.c b/ip6tables.c
index 7847ebc..87663ef 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -361,7 +361,7 @@ generic_opt_check(int command, int options)
 
 			if (!(options & (1<<i))) {
 				if (commands_v_options[j][i] == '+')
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "You need to supply the `-%c' "
 						   "option for this command\n",
 						   optflags[i]);
@@ -373,7 +373,7 @@ generic_opt_check(int command, int options)
 			}
 		}
 		if (legal == -1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Illegal option `-%c' with this command\n",
 				   optflags[i]);
 	}
@@ -402,9 +402,9 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 	    int invert)
 {
 	if (invert)
-		exit_error(PARAMETER_PROBLEM, "unexpected ! flag");
+		xtables_error(PARAMETER_PROBLEM, "unexpected '!' flag");
 	if (*cmd & (~othercmds))
-		exit_error(PARAMETER_PROBLEM, "Can't use -%c with -%c\n",
+		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
 			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
 	*cmd |= newcmd;
 }
@@ -452,7 +452,7 @@ parse_rulenumber(const char *rule)
 	unsigned int rulenum;
 
 	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
 	return rulenum;
@@ -464,17 +464,17 @@ parse_target(const char *targetname)
 	const char *ptr;
 
 	if (strlen(targetname) < 1)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
 	if (strlen(targetname)+1 > sizeof(ip6t_chainlabel))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
 			   targetname, (unsigned int)sizeof(ip6t_chainlabel)-1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid target name `%s'", targetname);
 	return targetname;
 }
@@ -484,7 +484,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	   int invert)
 {
 	if (*options & option)
-		exit_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
+		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
 			   opt2char(option));
 	*options |= option;
 
@@ -493,7 +493,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 		for (i = 0; 1 << i != option; i++);
 
 		if (!inverse_for_options[i])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "cannot have ! before -%c",
 				   opt2char(option));
 		*invflg |= inverse_for_options[i];
@@ -1362,7 +1362,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			    && argv[optind][0] != '!')
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a rule number",
 					   cmd2char(CMD_REPLACE));
 			break;
@@ -1421,11 +1421,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'N':
 			if (optarg && (*optarg == '-' || *optarg == '!'))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
 			if (xtables_find_target(optarg, XTF_TRY_LOAD))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
@@ -1450,7 +1450,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			    && argv[optind][0] != '!')
 				newname = argv[optind++];
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires old-chain-name and "
 					   "new-chain-name",
 					    cmd2char(CMD_RENAME_CHAIN));
@@ -1464,7 +1464,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			    && argv[optind][0] != '!')
 				policy = argv[optind++];
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a chain and a policy",
 					   cmd2char(CMD_SET_POLICY));
 			break;
@@ -1498,7 +1498,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 			if (fw.ipv6.proto == 0
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
 			if (is_exthdr(fw.ipv6.proto)
@@ -1556,7 +1556,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
-					exit_error(OTHER_PROBLEM,
+					xtables_error(OTHER_PROBLEM,
 						   "can't alloc memory!");
 			}
 			break;
@@ -1591,7 +1591,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			size_t size;
 
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
 			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
@@ -1617,7 +1617,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 't':
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			*table = optarg;
 			break;
@@ -1656,18 +1656,18 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			    && argv[optind][0] != '!')
 				bcnt = argv[optind++];
 			if (!bcnt)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
 			if (sscanf(pcnt, "%llu", &cnt) != 1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.pcnt = cnt;
 
 			if (sscanf(bcnt, "%llu", &cnt) != 1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.bcnt = cnt;
@@ -1676,7 +1676,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
 				invert = TRUE;
@@ -1763,21 +1763,21 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				if (!m) {
 					if (c == '?') {
 						if (optopt) {
-							exit_error(
+							xtables_error(
 							   PARAMETER_PROBLEM,
 							   "option `%s' "
 							   "requires an "
 							   "argument",
 							   argv[optind-1]);
 						} else {
-							exit_error(
+							xtables_error(
 							   PARAMETER_PROBLEM,
 							   "unknown option "
 							   "`%s'",
 							   argv[optind-1]);
 						}
 					}
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'", optarg);
 				}
 			}
@@ -1795,12 +1795,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	/* Fix me: must put inverse options checking here --MN */
 
 	if (optind < argc)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "unknown arguments found on commandline");
 	if (!command)
-		exit_error(PARAMETER_PROBLEM, "no command specified");
+		xtables_error(PARAMETER_PROBLEM, "no command specified");
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
@@ -1820,17 +1820,17 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
-		exit_error(PARAMETER_PROBLEM, "! not allowed with multiple"
+		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 			   " source or destination IP addresses");
 
 	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
-		exit_error(PARAMETER_PROBLEM, "Replacement rule does not "
+		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
 	generic_opt_check(command, options);
 
 	if (chain && strlen(chain) > IP6T_FUNCTION_MAXNAMELEN)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "chain name `%s' too long (must be under %i chars)",
 			   chain, IP6T_FUNCTION_MAXNAMELEN);
 
@@ -1843,7 +1843,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		*handle = ip6tc_init(*table);
 
 	if (!*handle)
-		exit_error(VERSION_PROBLEM,
+		xtables_error(VERSION_PROBLEM,
 			"can't initialize ip6tables table `%s': %s",
 			*table, ip6tc_strerror(errno));
 
@@ -1855,7 +1855,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		    || strcmp(chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
 			if (options & OPT_VIANAMEOUT)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEOUT),
 					   chain);
@@ -1865,7 +1865,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		    || strcmp(chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
 			if (options & OPT_VIANAMEIN)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEIN),
 					   chain);
@@ -1908,7 +1908,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * chain. */
 #ifdef IP6T_F_GOTO
 			if (fw.ipv6.flags & IP6T_F_GOTO)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 						"goto '%s' is not a chain\n", jumpto);
 #endif
 			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
diff --git a/iptables-restore.c b/iptables-restore.c
index c8eb2e3..f1c5e3e 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -71,7 +71,7 @@ static struct iptc_handle *create_handle(const char *tablename)
 	}
 
 	if (!handle) {
-		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
+		xtables_error(PARAMETER_PROBLEM, "%s: unable to initialize "
 			"table '%s'\n", prog_name, tablename);
 		exit(1);
 	}
@@ -217,7 +217,7 @@ main(int argc, char *argv[])
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					prog_name, line);
 				exit(1);
@@ -253,7 +253,7 @@ main(int argc, char *argv[])
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
 			if (!chain) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   prog_name, line);
 				exit(1);
@@ -263,14 +263,14 @@ main(int argc, char *argv[])
 				if (noflush && iptc_is_chain(chain, handle)) {
 					DEBUGP("Flushing existing user defined chain '%s'\n", chain);
 					if (!iptc_flush_entries(chain, handle))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "error flushing chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
 				} else {
 					DEBUGP("Creating new chain '%s'\n", chain);
 					if (!iptc_create_chain(chain, handle))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "error creating chain "
 							   "'%s':%s\n", chain,
 							   strerror(errno));
@@ -280,7 +280,7 @@ main(int argc, char *argv[])
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
 			if (!policy) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   prog_name, line);
 				exit(1);
@@ -294,7 +294,7 @@ main(int argc, char *argv[])
 					ctrs = strtok(NULL, " \t\n");
 
 					if (!ctrs || !parse_counters(ctrs, &count))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "invalid policy counters "
 							   "for chain '%s'\n", chain);
 
@@ -308,7 +308,7 @@ main(int argc, char *argv[])
 
 				if (!iptc_set_policy(chain, policy, &count,
 						     handle))
-					exit_error(OTHER_PROBLEM,
+					xtables_error(OTHER_PROBLEM,
 						"Can't set policy `%s'"
 						" on `%s' line %u: %s\n",
 						chain, policy, line,
@@ -336,19 +336,19 @@ main(int argc, char *argv[])
 				/* we have counters in our input */
 				ptr = strchr(buffer, ']');
 				if (!ptr)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
 				pcnt = strtok(buffer+1, ":");
 				if (!pcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need :\n",
 						   line);
 
 				bcnt = strtok(NULL, "]");
 				if (!bcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
@@ -415,7 +415,7 @@ main(int argc, char *argv[])
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 2)
 					    || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
 						exit(1);
@@ -428,7 +428,7 @@ main(int argc, char *argv[])
 					param_buffer[param_len++] = *curchar;
 
 					if (param_len >= sizeof(param_buffer))
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 						   "Parameter too long!");
 				}
 			}
diff --git a/iptables-save.c b/iptables-save.c
index e273435..55cfe6a 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -40,13 +40,13 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	procfile = fopen("/proc/net/ip_tables_names", "r");
 	if (!procfile)
-		exit_error(OTHER_PROBLEM,
+		xtables_error(OTHER_PROBLEM,
 			   "Unable to open /proc/net/ip_tables_names: %s\n",
 			   strerror(errno));
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
-			exit_error(OTHER_PROBLEM, 
+			xtables_error(OTHER_PROBLEM,
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
@@ -67,7 +67,7 @@ static int do_output(const char *tablename)
 
 	h = iptc_init(tablename);
 	if (!h)
-		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
+		xtables_error(OTHER_PROBLEM, "Cannot initialize: %s\n",
 			   iptc_strerror(errno));
 
 	if (!show_binary) {
@@ -113,7 +113,7 @@ static int do_output(const char *tablename)
 		printf("# Completed on %s", ctime(&now));
 	} else {
 		/* Binary, huh?  OK. */
-		exit_error(OTHER_PROBLEM, "Binary NYI\n");
+		xtables_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
 	iptc_free(h);
diff --git a/iptables-xml.c b/iptables-xml.c
index f1837ed..543715b 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -296,7 +296,7 @@ static void
 saveChain(char *chain, char *policy, struct ipt_counters *ctr)
 {
 	if (nextChain >= maxChains) {
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "%s: line %u chain name invalid\n",
 			   prog_name, line);
 		exit(1);
@@ -697,7 +697,7 @@ main(int argc, char *argv[])
 			table = strtok(buffer + 1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u table name invalid\n",
 					   prog_name, line);
 				exit(1);
@@ -714,7 +714,7 @@ main(int argc, char *argv[])
 			chain = strtok(buffer + 1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
 			if (!chain) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   prog_name, line);
 				exit(1);
@@ -725,7 +725,7 @@ main(int argc, char *argv[])
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
 			if (!policy) {
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   prog_name, line);
 				exit(1);
@@ -755,19 +755,19 @@ main(int argc, char *argv[])
 				/* we have counters in our input */
 				ptr = strchr(buffer, ']');
 				if (!ptr)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
 				pcnt = strtok(buffer + 1, ":");
 				if (!pcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need :\n",
 						   line);
 
 				bcnt = strtok(NULL, "]");
 				if (!bcnt)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Bad line %u: need ]\n",
 						   line);
 
@@ -827,7 +827,7 @@ main(int argc, char *argv[])
 					if (!strncmp(param_buffer, "-t", 3)
 					    || !strncmp(param_buffer,
 							"--table", 8)) {
-						exit_error(PARAMETER_PROBLEM,
+						xtables_error(PARAMETER_PROBLEM,
 							   "Line %u seems to have a "
 							   "-t table option.\n",
 							   line);
diff --git a/iptables.c b/iptables.c
index 8448c18..bd177c7 100644
--- a/iptables.c
+++ b/iptables.c
@@ -375,7 +375,7 @@ generic_opt_check(int command, int options)
 
 			if (!(options & (1<<i))) {
 				if (commands_v_options[j][i] == '+')
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "You need to supply the `-%c' "
 						   "option for this command\n",
 						   optflags[i]);
@@ -387,7 +387,7 @@ generic_opt_check(int command, int options)
 			}
 		}
 		if (legal == -1)
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Illegal option `-%c' with this command\n",
 				   optflags[i]);
 	}
@@ -416,9 +416,9 @@ add_command(unsigned int *cmd, const int newcmd, const int othercmds,
 	    int invert)
 {
 	if (invert)
-		exit_error(PARAMETER_PROBLEM, "unexpected ! flag");
+		xtables_error(PARAMETER_PROBLEM, "unexpected ! flag");
 	if (*cmd & (~othercmds))
-		exit_error(PARAMETER_PROBLEM, "Can't use -%c with -%c\n",
+		xtables_error(PARAMETER_PROBLEM, "Cannot use -%c with -%c\n",
 			   cmd2char(newcmd), cmd2char(*cmd & (~othercmds)));
 	*cmd |= newcmd;
 }
@@ -457,7 +457,7 @@ parse_rulenumber(const char *rule)
 	unsigned int rulenum;
 
 	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
 	return rulenum;
@@ -469,17 +469,17 @@ parse_target(const char *targetname)
 	const char *ptr;
 
 	if (strlen(targetname) < 1)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name (too short)");
 
 	if (strlen(targetname)+1 > sizeof(ipt_chainlabel))
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "Invalid target name `%s' (%u chars max)",
 			   targetname, (unsigned int)sizeof(ipt_chainlabel)-1);
 
 	for (ptr = targetname; *ptr; ptr++)
 		if (isspace(*ptr))
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "Invalid target name `%s'", targetname);
 	return targetname;
 }
@@ -489,7 +489,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	   int invert)
 {
 	if (*options & option)
-		exit_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
+		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
 			   opt2char(option));
 	*options |= option;
 
@@ -498,7 +498,7 @@ set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 		for (i = 0; 1 << i != option; i++);
 
 		if (!inverse_for_options[i])
-			exit_error(PARAMETER_PROBLEM,
+			xtables_error(PARAMETER_PROBLEM,
 				   "cannot have ! before -%c",
 				   opt2char(option));
 		*invflg |= inverse_for_options[i];
@@ -1385,7 +1385,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			    && argv[optind][0] != '!')
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a rule number",
 					   cmd2char(CMD_REPLACE));
 			break;
@@ -1444,11 +1444,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'N':
 			if (optarg && (*optarg == '-' || *optarg == '!'))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `%c'\n", *optarg);
 			if (xtables_find_target(optarg, XTF_TRY_LOAD))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
@@ -1473,7 +1473,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			    && argv[optind][0] != '!')
 				newname = argv[optind++];
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires old-chain-name and "
 					   "new-chain-name",
 					    cmd2char(CMD_RENAME_CHAIN));
@@ -1487,7 +1487,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			    && argv[optind][0] != '!')
 				policy = argv[optind++];
 			else
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a chain and a policy",
 					   cmd2char(CMD_SET_POLICY));
 			break;
@@ -1520,7 +1520,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 			if (fw.ip.proto == 0
 			    && (fw.ip.invflags & IPT_INV_PROTO))
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 			break;
 
@@ -1571,7 +1571,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
-					exit_error(OTHER_PROBLEM,
+					xtables_error(OTHER_PROBLEM,
 						   "can't alloc memory!");
 			}
 			break;
@@ -1612,7 +1612,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			size_t size;
 
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
 			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
@@ -1631,7 +1631,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 						     m->extra_opts,
 						     &m->option_offset);
 				if (opts == NULL)
-					exit_error(OTHER_PROBLEM,
+					xtables_error(OTHER_PROBLEM,
 						   "can't alloc memory!");
 			}
 		}
@@ -1644,7 +1644,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 't':
 			if (invert)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			*table = optarg;
 			break;
@@ -1683,18 +1683,18 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			    && argv[optind][0] != '!')
 				bcnt = argv[optind++];
 			if (!bcnt)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
 			if (sscanf(pcnt, "%llu", &cnt) != 1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.pcnt = cnt;
 
 			if (sscanf(bcnt, "%llu", &cnt) != 1)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
 			fw.counters.bcnt = cnt;
@@ -1704,7 +1704,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
 				invert = TRUE;
@@ -1785,7 +1785,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 							     m->extra_opts,
 							     &m->option_offset);
 					if (opts == NULL)
-						exit_error(OTHER_PROBLEM,
+						xtables_error(OTHER_PROBLEM,
 							"can't alloc memory!");
 
 					optind--;
@@ -1794,21 +1794,21 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				if (!m) {
 					if (c == '?') {
 						if (optopt) {
-							exit_error(
+							xtables_error(
 							   PARAMETER_PROBLEM,
 							   "option `%s' "
 							   "requires an "
 							   "argument",
 							   argv[optind-1]);
 						} else {
-							exit_error(
+							xtables_error(
 							   PARAMETER_PROBLEM,
 							   "unknown option "
 							   "`%s'",
 							   argv[optind-1]);
 						}
 					}
-					exit_error(PARAMETER_PROBLEM,
+					xtables_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'", optarg);
 				}
 			}
@@ -1834,12 +1834,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	/* Fix me: must put inverse options checking here --MN */
 
 	if (optind < argc)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "unknown arguments found on commandline");
 	if (!command)
-		exit_error(PARAMETER_PROBLEM, "no command specified");
+		xtables_error(PARAMETER_PROBLEM, "no command specified");
 	if (invert)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
@@ -1859,17 +1859,17 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
-		exit_error(PARAMETER_PROBLEM, "! not allowed with multiple"
+		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 			   " source or destination IP addresses");
 
 	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
-		exit_error(PARAMETER_PROBLEM, "Replacement rule does not "
+		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
 	generic_opt_check(command, options);
 
 	if (chain && strlen(chain) > IPT_FUNCTION_MAXNAMELEN)
-		exit_error(PARAMETER_PROBLEM,
+		xtables_error(PARAMETER_PROBLEM,
 			   "chain name `%s' too long (must be under %i chars)",
 			   chain, IPT_FUNCTION_MAXNAMELEN);
 
@@ -1882,7 +1882,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		*handle = iptc_init(*table);
 
 	if (!*handle)
-		exit_error(VERSION_PROBLEM,
+		xtables_error(VERSION_PROBLEM,
 			   "can't initialize iptables table `%s': %s",
 			   *table, iptc_strerror(errno));
 
@@ -1894,7 +1894,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		    || strcmp(chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
 			if (options & OPT_VIANAMEOUT)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEOUT),
 					   chain);
@@ -1904,7 +1904,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		    || strcmp(chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
 			if (options & OPT_VIANAMEIN)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEIN),
 					   chain);
@@ -1950,7 +1950,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			 * chain. */
 #ifdef IPT_F_GOTO
 			if (fw.ip.flags & IPT_F_GOTO)
-				exit_error(PARAMETER_PROBLEM,
+				xtables_error(PARAMETER_PROBLEM,
 					   "goto '%s' is not a chain\n", jumpto);
 #endif
 			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
-- 
1.6.1.3

