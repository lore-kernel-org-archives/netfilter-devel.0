From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 07/16] libxtables: prefix/order - strtoui
Date: Mon,  9 Feb 2009 18:34:51 +0100
Message-ID: <1234200900-5964-8-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51467 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118AbZBIRfG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:06 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit also throws out the redundant string_to_number_*.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c        |    2 +-
 extensions/libip6t_LOG.c       |    2 +-
 extensions/libip6t_icmp6.c     |    4 +-
 extensions/libip6t_mh.c        |    2 +-
 extensions/libipt_CLUSTERIP.c  |    6 +-
 extensions/libipt_ECN.c        |    6 +-
 extensions/libipt_LOG.c        |    2 +-
 extensions/libipt_NETMAP.c     |    2 +-
 extensions/libipt_TTL.c        |    2 +-
 extensions/libipt_ecn.c        |    2 +-
 extensions/libipt_icmp.c       |    4 +-
 extensions/libipt_ttl.c        |    6 +-
 extensions/libxt_CONNMARK.c    |   16 ++++----
 extensions/libxt_DSCP.c        |    2 +-
 extensions/libxt_MARK.c        |   20 +++++----
 extensions/libxt_NFQUEUE.c     |    2 +-
 extensions/libxt_TCPMSS.c      |    3 +-
 extensions/libxt_TCPOPTSTRIP.c |    3 +-
 extensions/libxt_TOS.c         |    6 +-
 extensions/libxt_TPROXY.c      |    6 +-
 extensions/libxt_connmark.c    |    4 +-
 extensions/libxt_conntrack.c   |   14 +++---
 extensions/libxt_dccp.c        |    2 +-
 extensions/libxt_dscp.c        |    2 +-
 extensions/libxt_hashlimit.c   |   24 ++++++------
 extensions/libxt_length.c      |    2 +-
 extensions/libxt_limit.c       |    2 +-
 extensions/libxt_mark.c        |    4 +-
 extensions/libxt_owner.c       |   25 +++++++-----
 extensions/libxt_rateest.c     |    7 ++-
 extensions/libxt_statistic.c   |    9 ++--
 extensions/libxt_tcp.c         |    2 +-
 extensions/libxt_tcpmss.c      |    2 +-
 extensions/tos_values.c        |    6 +-
 include/xtables.h.in           |   16 +-------
 ip6tables.c                    |    6 +-
 iptables.c                     |    6 +-
 xtables.c                      |   83 ++++++++++++----------------------------
 38 files changed, 141 insertions(+), 173 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 8f55572..4aed4fd 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -44,7 +44,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM,
 				"HL: unexpected `!'");
 	
-	if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)	
+	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM,	
 		           "HL: Expected value between 0 and 255");
 
diff --git a/extensions/libip6t_LOG.c b/extensions/libip6t_LOG.c
index 1b21d5d..a8ac135 100644
--- a/extensions/libip6t_LOG.c
+++ b/extensions/libip6t_LOG.c
@@ -70,7 +70,7 @@ parse_level(const char *level)
 	unsigned int lev = -1;
 	unsigned int set = 0;
 
-	if (string_to_number(level, 0, 7, &lev) == -1) {
+	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
 		unsigned int i = 0;
 
 		for (i = 0;
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index 17567df..401c278 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -123,12 +123,12 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 		if (slash)
 			*slash = '\0';
 
-		if (string_to_number(buffer, 0, UINT8_MAX, &number) == -1)
+		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid ICMPv6 type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
-			if (string_to_number(slash+1, 0, UINT8_MAX, &number) == -1)
+			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid ICMPv6 code `%s'\n",
 					   slash+1);
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index 8b58bcd..f8c4e24 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -93,7 +93,7 @@ static unsigned int name_to_type(const char *name)
 	} else {
 		unsigned int number;
 
-		if (string_to_number(name, 0, UINT8_MAX, &number) == -1)
+		if (!xtables_strtoui(name, NULL, &number, 0, UINT8_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid MH type `%s'\n", name);
 		return number;
diff --git a/extensions/libipt_CLUSTERIP.c b/extensions/libipt_CLUSTERIP.c
index e93290a..38909ea 100644
--- a/extensions/libipt_CLUSTERIP.c
+++ b/extensions/libipt_CLUSTERIP.c
@@ -120,7 +120,7 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM, "Can only specify node number combined with `--new'\n");
 		if (*flags & PARAM_TOTALNODE)
 			exit_error(PARAMETER_PROBLEM, "Can only specify total node number once\n");
-		if (string_to_number(optarg, 1, CLUSTERIP_MAX_NODES, &num) < 0)
+		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
 			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
 		cipinfo->num_total_nodes = num;
 		*flags |= PARAM_TOTALNODE;
@@ -130,7 +130,7 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM, "Can only specify node number combined with `--new'\n");
 		if (*flags & PARAM_LOCALNODE)
 			exit_error(PARAMETER_PROBLEM, "Can only specify local node number once\n");
-		if (string_to_number(optarg, 1, CLUSTERIP_MAX_NODES, &num) < 0)
+		if (!xtables_strtoui(optarg, NULL, &num, 1, CLUSTERIP_MAX_NODES))
 			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
 		cipinfo->num_local_nodes = 1;
 		cipinfo->local_nodes[0] = num;
@@ -141,7 +141,7 @@ static int CLUSTERIP_parse(int c, char **argv, int invert, unsigned int *flags,
 			exit_error(PARAMETER_PROBLEM, "Can only specify hash init value combined with `--new'\n");
 		if (*flags & PARAM_HASHINIT)
 			exit_error(PARAMETER_PROBLEM, "Can specify hash init value only once\n");
-		if (string_to_number(optarg, 0, UINT_MAX, &num) < 0)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT_MAX))
 			exit_error(PARAMETER_PROBLEM, "Unable to parse `%s'\n", optarg);
 		cipinfo->hash_initval = num;
 		*flags |= PARAM_HASHINIT;
diff --git a/extensions/libipt_ECN.c b/extensions/libipt_ECN.c
index e9312f0..c4e8e34 100644
--- a/extensions/libipt_ECN.c
+++ b/extensions/libipt_ECN.c
@@ -61,7 +61,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_SET_CWR)
 			exit_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-tcp-cwr ONCE!");
-		if (string_to_number(optarg, 0, 1, &result))
+		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_CWR;
@@ -72,7 +72,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_SET_ECE)
 			exit_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-tcp-ece ONCE!");
-		if (string_to_number(optarg, 0, 1, &result))
+		if (!xtables_strtoui(optarg, NULL, &result, 0, 1))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_ECE;
@@ -83,7 +83,7 @@ static int ECN_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & IPT_ECN_OP_SET_IP)
 			exit_error(PARAMETER_PROBLEM,
 				"ECN target: Only use --ecn-ip-ect ONCE!");
-		if (string_to_number(optarg, 0, 3, &result))
+		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN target: Value out of range");
 		einfo->operation |= IPT_ECN_OP_SET_IP;
diff --git a/extensions/libipt_LOG.c b/extensions/libipt_LOG.c
index 2aee910..aefb54a 100644
--- a/extensions/libipt_LOG.c
+++ b/extensions/libipt_LOG.c
@@ -70,7 +70,7 @@ parse_level(const char *level)
 	unsigned int lev = -1;
 	unsigned int set = 0;
 
-	if (string_to_number(level, 0, 7, &lev) == -1) {
+	if (!xtables_strtoui(level, NULL, &lev, 0, 7)) {
 		unsigned int i = 0;
 
 		for (i = 0;
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index f6c688d..d8f34cc 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -89,7 +89,7 @@ parse_to(char *arg, struct ip_nat_range *range)
 			netmask = ip->s_addr;
 		}
 		else {
-			if (string_to_number(slash+1, 0, 32, &bits) == -1)
+			if (!xtables_strtoui(slash+1, NULL, &bits, 0, 32))
 				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
 					   slash+1);
 			netmask = bits2netmask(bits);
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index e124381..6036161 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -44,7 +44,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
 	
-	if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
+	if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM,
 		           "TTL: Expected value between 0 and 255");
 
diff --git a/extensions/libipt_ecn.c b/extensions/libipt_ecn.c
index 72353d5..c2276e9 100644
--- a/extensions/libipt_ecn.c
+++ b/extensions/libipt_ecn.c
@@ -71,7 +71,7 @@ static int ecn_parse(int c, char **argv, int invert, unsigned int *flags,
 			einfo->invert |= IPT_ECN_OP_MATCH_IP;
 		*flags |= IPT_ECN_OP_MATCH_IP;
 		einfo->operation |= IPT_ECN_OP_MATCH_IP;
-		if (string_to_number(optarg, 0, 3, &result))
+		if (!xtables_strtoui(optarg, NULL, &result, 0, 3))
 			exit_error(PARAMETER_PROBLEM,
 				   "ECN match: Value out of range");
 		einfo->ip_ect = result;
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index 7aff9ca..de4c338 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -147,12 +147,12 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 		if (slash)
 			*slash = '\0';
 
-		if (string_to_number(buffer, 0, UINT8_MAX, &number) == -1)
+		if (!xtables_strtoui(buffer, NULL, &number, 0, UINT8_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid ICMP type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
-			if (string_to_number(slash+1, 0, UINT8_MAX, &number) == -1)
+			if (!xtables_strtoui(slash+1, NULL, &number, 0, UINT8_MAX))
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid ICMP code `%s'\n",
 					   slash+1);
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index a8455e1..1fa7bd3 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -33,7 +33,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 		case '2':
-			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
+			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
@@ -46,7 +46,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->ttl = value;
 			break;
 		case '3':
-			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
+			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
@@ -58,7 +58,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->ttl = value;
 			break;
 		case '4':
-			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
+			if (!xtables_strtoui(optarg, NULL, &value, 0, UINT8_MAX))
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
diff --git a/extensions/libxt_CONNMARK.c b/extensions/libxt_CONNMARK.c
index d5d963d..f979f28 100644
--- a/extensions/libxt_CONNMARK.c
+++ b/extensions/libxt_CONNMARK.c
@@ -159,10 +159,10 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 	case '=': /* --set-xmark */
 	case '-': /* --set-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
+			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "CONNMARK", "--set-xmark/--set-mark", optarg);
@@ -176,7 +176,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '&': /* --and-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &mask, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--and-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = 0;
@@ -186,7 +186,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '|': /* --or-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--or-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
@@ -196,7 +196,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 
 	case '^': /* --xor-mark */
 		param_act(P_ONE_ACTION, "CONNMARK", *flags & F_MARK);
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--xor-mark", optarg);
 		info->mode   = XT_CONNMARK_SET;
 		info->ctmark = value;
@@ -221,7 +221,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--nfmask");
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--nfmask", optarg);
 		info->nfmask = value;
 		return true;
@@ -231,7 +231,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--ctmask");
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--ctmask", optarg);
 		info->ctmask = value;
 		return true;
@@ -241,7 +241,7 @@ static int connmark_tg_parse(int c, char **argv, int invert,
 			exit_error(PARAMETER_PROBLEM, "CONNMARK: --save-mark "
 			           "or --restore-mark is required for "
 			           "--mask");
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "CONNMARK", "--mask", optarg);
 		info->nfmask = info->ctmask = value;
 		return true;
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 92a6de5..aac8f9b 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -48,7 +48,7 @@ parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 {
 	unsigned int dscp;
        
-	if (string_to_number(s, 0, UINT8_MAX, &dscp) == -1)
+	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
diff --git a/extensions/libxt_MARK.c b/extensions/libxt_MARK.c
index b02322b..fd28196 100644
--- a/extensions/libxt_MARK.c
+++ b/extensions/libxt_MARK.c
@@ -58,12 +58,13 @@ MARK_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct xt_mark_target_info *markinfo
 		= (struct xt_mark_target_info *)(*target)->data;
+	unsigned int mark = 0;
 
 	switch (c) {
 	case '1':
-		if (string_to_number_l(optarg, 0, 0, 
-				     &markinfo->mark))
+		if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
+		markinfo->mark = mark;
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "MARK target: Can't specify --set-mark twice");
@@ -96,6 +97,7 @@ MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 {
 	struct xt_mark_target_info_v1 *markinfo
 		= (struct xt_mark_target_info_v1 *)(*target)->data;
+	unsigned int mark = 0;
 
 	switch (c) {
 	case '1':
@@ -111,9 +113,9 @@ MARK_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		return 0;
 	}
 
-	if (string_to_number_l(optarg, 0, 0, &markinfo->mark))
+	if (!xtables_strtoui(optarg, NULL, &mark, 0, UINT32_MAX))
 		exit_error(PARAMETER_PROBLEM, "Bad MARK value `%s'", optarg);
-
+	markinfo->mark = mark;
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "MARK target: Can't specify --set-mark twice");
@@ -134,10 +136,10 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '=': /* --set-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--set-xmark/--set-mark", invert);
-		if (!strtonum(optarg, &end, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, &end, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
+			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "MARK", "--set-xmark/--set-mark", optarg);
@@ -151,7 +153,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&': /* --and-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--and-mark", invert);
-		if (!strtonum(optarg, NULL, &mask, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &mask, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--and-mark", optarg);
 		info->mark = 0;
 		info->mask = ~mask;
@@ -160,7 +162,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '|': /* --or-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--or-mark", invert);
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--or-mark", optarg);
 		info->mark = value;
 		info->mask = value;
@@ -169,7 +171,7 @@ static int mark_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '^': /* --xor-mark */
 		param_act(P_ONE_ACTION, "MARK", *flags & F_MARK);
 		param_act(P_NO_INVERT, "MARK", "--xor-mark", invert);
-		if (!strtonum(optarg, NULL, &value, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &value, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "MARK", "--xor-mark", optarg);
 		info->mark = value;
 		info->mask = 0;
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 1a58760..1c0c23d 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -33,7 +33,7 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
 {
 	unsigned int num;
        
-	if (string_to_number(s, 0, UINT16_MAX, &num) == -1)
+	if (!xtables_strtoui(s, NULL, &num, 0, UINT16_MAX))
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid queue number `%s'\n", s);
 
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 9b62a56..33fc71c 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -55,7 +55,8 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "TCPMSS target: Only one option may be specified");
-		if (string_to_number(optarg, 0, UINT16_MAX - hdrsize, &mssval) == -1)
+		if (!xtables_strtoui(optarg, NULL, &mssval,
+		    0, UINT16_MAX - hdrsize))
 			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
 		
 		mssinfo->mss = mssval;
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 7211288..c053a8b 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -82,7 +82,8 @@ static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 				break;
 			}
 
-		if (option == 0 && string_to_number(arg, 0, UINT8_MAX, &option) == -1)
+		if (option == 0 &&
+		    !xtables_strtoui(arg, NULL, &option, 0, UINT8_MAX))
 			exit_error(PARAMETER_PROBLEM,
 			           "Bad TCP option value \"%s\"", arg);
 
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index a04f741..96eb420 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -118,7 +118,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&': /* --and-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--and-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--and-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
+		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--and-tos", optarg);
 		info->tos_value = 0;
 		info->tos_mask  = ~bits;
@@ -127,7 +127,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '|': /* --or-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--or-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--or-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
+		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--or-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = bits;
@@ -136,7 +136,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '^': /* --xor-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--xor-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--xor-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
+		if (!xtables_strtoui(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--xor-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = 0;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 41ca243..6c5c6b7 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -40,7 +40,7 @@ static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info
 {
 	unsigned int lport;
 
-	if (string_to_number(s, 0, UINT16_MAX, &lport) != -1)
+	if (xtables_strtoui(s, NULL, &lport, 0, UINT16_MAX))
 		info->lport = htons(lport);
 	else
 		param_act(P_BAD_VALUE, "TPROXY", "--on-port", s);
@@ -61,10 +61,10 @@ static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 	unsigned int value, mask = UINT32_MAX;
 	char *end;
 
-	if (!strtonum(s, &end, &value, 0, UINT_MAX))
+	if (!xtables_strtoui(s, &end, &value, 0, UINT32_MAX))
 		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 	if (*end == '/')
-		if (!strtonum(end + 1, &end, &mask, 0, UINT_MAX))
+		if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 	if (*end != '\0')
 		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index fbd3e62..afa63e3 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -55,10 +55,10 @@ connmark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1': /* --mark */
 		param_act(P_ONLY_ONCE, "connmark", "--mark", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &mark, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
+			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "connmark", "--mark", optarg);
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 532f5ee..2b98ab0 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -228,7 +228,7 @@ parse_expire(const char *s)
 {
 	unsigned int len;
 
-	if (string_to_number(s, 0, 0, &len) == -1)
+	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
 		exit_error(PARAMETER_PROBLEM, "expire value invalid: `%s'\n", s);
 	else
 		return len;
@@ -268,11 +268,11 @@ conntrack_ps_expires(struct xt_conntrack_mtinfo1 *info, const char *s)
 	unsigned int min, max;
 	char *end;
 
-	if (!strtonum(s, &end, &min, 0, ~0))
+	if (!xtables_strtoui(s, &end, &min, 0, UINT32_MAX))
 		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
 	max = min;
 	if (*end == ':')
-		if (!strtonum(s, &end, &max, 0, UINT32_MAX))
+		if (!xtables_strtoui(s, &end, &max, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "conntrack", "--expires", s);
 	if (*end != '\0')
 		param_act(P_BAD_VALUE, "conntrack", "--expires", s);
@@ -481,7 +481,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'a': /* --ctorigsrcport */
-		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
+		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctorigsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGSRC_PORT;
@@ -491,7 +491,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'b': /* --ctorigdstport */
-		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
+		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctorigdstport", optarg);
 		info->match_flags |= XT_CONNTRACK_ORIGDST_PORT;
@@ -501,7 +501,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'c': /* --ctreplsrcport */
-		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
+		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctreplsrcport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLSRC_PORT;
@@ -511,7 +511,7 @@ conntrack_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case 'd': /* --ctrepldstport */
-		if (!strtonum(optarg, NULL, &port, 0, UINT16_MAX))
+		if (!xtables_strtoui(optarg, NULL, &port, 0, UINT16_MAX))
 			param_act(P_BAD_VALUE, "conntrack",
 			          "--ctrepldstport", optarg);
 		info->match_flags |= XT_CONNTRACK_REPLDST_PORT;
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 0eb95ce..b7b55e2 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -121,7 +121,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 {
 	unsigned int ret;
 
-	if (string_to_number(optstring, 1, UINT8_MAX, &ret) == -1)
+	if (!xtables_strtoui(optstring, NULL, &ret, 1, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
 			   optstring);
 
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index ae5a624..fce14c2 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -48,7 +48,7 @@ parse_dscp(const char *s, struct xt_dscp_info *dinfo)
 {
 	unsigned int dscp;
        
-	if (string_to_number(s, 0, UINT8_MAX, &dscp) == -1)
+	if (!xtables_strtoui(s, NULL, &dscp, 0, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 278e098..06d026a 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -230,7 +230,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 10000, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --hashlimit-burst `%s'", optarg);
 		r->cfg.burst = num;
@@ -240,7 +240,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
 		r->cfg.size = num;
@@ -250,7 +250,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
 		r->cfg.max = num;
@@ -261,7 +261,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
 				optarg);
@@ -273,7 +273,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
 		/* FIXME: not HZ dependent */
@@ -341,7 +341,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '$': /* --hashlimit-burst */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-burst",
 		          *flags & PARAM_BURST);
-		if (!strtonum(optarg, NULL, &num, 0, 10000))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-burst", optarg);
 		info->cfg.burst = num;
@@ -351,7 +351,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '&': /* --hashlimit-htable-size */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
-		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-size", optarg);
 		info->cfg.size = num;
@@ -361,7 +361,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '*': /* --hashlimit-htable-max */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
-		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-max", optarg);
 		info->cfg.max = num;
@@ -372,7 +372,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
-		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-gcinterval", optarg);
 		/* FIXME: not HZ dependent!! */
@@ -383,7 +383,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case ')': /* --hashlimit-htable-expire */
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-expire", optarg);
 		/* FIXME: not HZ dependent */
@@ -413,7 +413,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '<': /* --hashlimit-srcmask */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-srcmask",
 		          *flags & PARAM_SRCMASK);
-		if (!strtonum(optarg, NULL, &num, 0, maxmask))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-srcmask", optarg);
 		info->cfg.srcmask = num;
@@ -423,7 +423,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '>': /* --hashlimit-dstmask */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-dstmask",
 		          *flags & PARAM_DSTMASK);
-		if (!strtonum(optarg, NULL, &num, 0, maxmask))
+		if (!xtables_strtoui(optarg, NULL, &num, 0, maxmask))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-dstmask", optarg);
 		info->cfg.dstmask = num;
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index 0e196d7..d039904 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -26,7 +26,7 @@ parse_length(const char *s)
 {
 	unsigned int len;
 	
-	if (string_to_number(s, 0, UINT16_MAX, &len) == -1)
+	if (!xtables_strtoui(s, NULL, &len, 0, UINT32_MAX))
 		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
 	else
 		return len;
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index 3ed7b96..1df9114 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -102,7 +102,7 @@ limit_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '$':
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 10000, &num) == -1)
+		if (!xtables_strtoui(optarg, NULL, &num, 0, 10000))
 			exit_error(PARAMETER_PROBLEM,
 				   "bad --limit-burst `%s'", optarg);
 		r->burst = num;
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index 5a95d51..31957e7 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -35,10 +35,10 @@ static int mark_mt_parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1': /* --mark */
 		param_act(P_ONLY_ONCE, "mark", "--mark", *flags & F_MARK);
-		if (!strtonum(optarg, &end, &mark, 0, UINT32_MAX))
+		if (!xtables_strtoui(optarg, &end, &mark, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end == '/')
-			if (!strtonum(end + 1, &end, &mask, 0, UINT32_MAX))
+			if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
 				param_act(P_BAD_VALUE, "mark", "--mark", optarg);
 		if (*end != '\0')
 			param_act(P_BAD_VALUE, "mark", "--mark", optarg);
diff --git a/extensions/libxt_owner.c b/extensions/libxt_owner.c
index c8677a8..54d841c 100644
--- a/extensions/libxt_owner.c
+++ b/extensions/libxt_owner.c
@@ -19,6 +19,11 @@
 #include <linux/netfilter_ipv4/ipt_owner.h>
 #include <linux/netfilter_ipv6/ip6t_owner.h>
 
+/*
+ *	Note: "UINT32_MAX - 1" is used in the code because -1 is a reserved
+ *	UID/GID value anyway.
+ */
+
 enum {
 	FLAG_UID_OWNER     = 1 << 0,
 	FLAG_GID_OWNER     = 1 << 1,
@@ -110,7 +115,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "owner", "--uid-owner", *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
-		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
+		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_UID;
@@ -123,7 +128,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "owner", "--gid-owner", *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
-		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
+		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_GID;
@@ -134,7 +139,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	case 'p':
 		param_act(P_ONLY_ONCE, "owner", "--pid-owner", *flags & FLAG_PID_OWNER);
-		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
 			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_PID;
@@ -145,7 +150,7 @@ owner_mt_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 
 	case 's':
 		param_act(P_ONLY_ONCE, "owner", "--sid-owner", *flags & FLAG_SID_OWNER);
-		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
 			param_act(P_BAD_VALUE, "owner", "--sid-value", optarg);
 		if (invert)
 			info->invert |= IPT_OWNER_SID;
@@ -190,7 +195,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & FLAG_UID_OWNER);
 		if ((pwd = getpwnam(optarg)) != NULL)
 			id = pwd->pw_uid;
-		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
+		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--uid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_UID;
@@ -204,7 +209,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		          *flags & FLAG_GID_OWNER);
 		if ((grp = getgrnam(optarg)) != NULL)
 			id = grp->gr_gid;
-		else if (!strtonum(optarg, NULL, &id, 0, UINT32_MAX - 1))
+		else if (!xtables_strtoui(optarg, NULL, &id, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", "--gid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_GID;
@@ -216,7 +221,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	case 'p':
 		param_act(P_ONLY_ONCE, "owner", "--pid-owner",
 		          *flags & FLAG_PID_OWNER);
-		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
 			param_act(P_BAD_VALUE, "owner", "--pid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_PID;
@@ -228,7 +233,7 @@ owner_mt6_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 	case 's':
 		param_act(P_ONLY_ONCE, "owner", "--sid-owner",
 		          *flags & FLAG_SID_OWNER);
-		if (!strtonum(optarg, NULL, &id, 0, INT_MAX))
+		if (!xtables_strtoui(optarg, NULL, &id, 0, INT_MAX))
 			param_act(P_BAD_VALUE, "owner", "--sid-owner", optarg);
 		if (invert)
 			info->invert |= IP6T_OWNER_SID;
@@ -246,11 +251,11 @@ static void owner_parse_range(const char *s, unsigned int *from,
 	char *end;
 
 	/* -1 is reversed, so the max is one less than that. */
-	if (!strtonum(s, &end, from, 0, UINT32_MAX - 1))
+	if (!xtables_strtoui(s, &end, from, 0, UINT32_MAX - 1))
 		param_act(P_BAD_VALUE, "owner", opt, s);
 	*to = *from;
 	if (*end == '-' || *end == ':')
-		if (!strtonum(end + 1, &end, to, 0, UINT32_MAX - 1))
+		if (!xtables_strtoui(end + 1, &end, to, 0, UINT32_MAX - 1))
 			param_act(P_BAD_VALUE, "owner", opt, s);
 	if (*end != '\0')
 		param_act(P_BAD_VALUE, "owner", opt, s);
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 333239d..285b7ba 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -112,6 +112,7 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_match **match)
 {
 	struct xt_rateest_match_info *info = (void *)(*match)->data;
+	unsigned int val;
 
 	rateest_info = info;
 
@@ -186,10 +187,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
 			break;
 
-		if (string_to_number(argv[optind], 0, 0, &info->pps1) < 0)
+		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
 				   argv[optind]);
+		info->pps1 = val;
 		optind++;
 		break;
 
@@ -234,10 +236,11 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
 			break;
 
-		if (string_to_number(argv[optind], 0, 0, &info->pps2) < 0)
+		if (!xtables_strtoui(argv[optind], NULL, &val, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "rateest: could not parse pps `%s'",
 				   argv[optind]);
+		info->pps2 = val;
 		optind++;
 		break;
 
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index e43de7d..574f8f7 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -40,6 +40,7 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
                 const void *entry, struct xt_entry_match **match)
 {
 	struct xt_statistic_info *info = (void *)(*match)->data;
+	unsigned int val;
 	double prob;
 
 	if (invert)
@@ -70,10 +71,10 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (*flags & 0x4)
 			exit_error(PARAMETER_PROBLEM, "double --every");
-		if (string_to_number(optarg, 0, UINT32_MAX,
-				     &info->u.nth.every) == -1)
+		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "cannot parse --every `%s'", optarg);
+		info->u.nth.every = val;
 		if (info->u.nth.every == 0)
 			exit_error(PARAMETER_PROBLEM, "--every cannot be 0");
 		info->u.nth.every--;
@@ -82,10 +83,10 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '4':
 		if (*flags & 0x8)
 			exit_error(PARAMETER_PROBLEM, "double --packet");
-		if (string_to_number(optarg, 0, UINT32_MAX,
-				     &info->u.nth.packet) == -1)
+		if (!xtables_strtoui(optarg, NULL, &val, 0, UINT32_MAX))
 			exit_error(PARAMETER_PROBLEM,
 				   "cannot parse --packet `%s'", optarg);
+		info->u.nth.packet = val;
 		*flags |= 0x8;
 		break;
 	default:
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 82954a4..56bdba5 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -121,7 +121,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 {
 	unsigned int ret;
 
-	if (string_to_number(option, 1, UINT8_MAX, &ret) == -1)
+	if (!xtables_strtoui(option, NULL, &ret, 1, UINT8_MAX))
 		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
 
 	*result = ret;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index e64a1b3..d30aa24 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -26,7 +26,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 {
 	unsigned int mssvaluenum;
 
-	if (string_to_number(mssvalue, 0, UINT16_MAX, &mssvaluenum) != -1)
+	if (!xtables_strtoui(mssvalue, NULL, &mssvaluenum, 0, UINT16_MAX))
 		return mssvaluenum;
 
 	exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 2d5b431..81f6de1 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -34,14 +34,14 @@ static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
 	unsigned int value;
 	char *end;
 
-	strtonum(str, &end, &value, 0, max);
+	xtables_strtoui(str, &end, &value, 0, max);
 	tvm->value = value;
 	tvm->mask  = max;
 
 	if (*end == '/') {
 		const char *p = end + 1;
 
-		if (!strtonum(p, &end, &value, 0, max))
+		if (!xtables_strtoui(p, &end, &value, 0, max))
 			exit_error(PARAMETER_PROBLEM, "Illegal value: \"%s\"",
 			           str);
 		tvm->mask = value;
@@ -59,7 +59,7 @@ static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
 	const struct tos_symbol_info *symbol;
 	char *tmp;
 
-	if (strtonum(str, &tmp, NULL, 0, max))
+	if (xtables_strtoui(str, &tmp, NULL, 0, max))
 		return tos_parse_numeric(str, tvm, max);
 
 	/* Do not consider ECN bits */
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 268c42e..f372d33 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -175,21 +175,9 @@ extern struct xtables_target *xtables_find_target(const char *name,
 extern void xtables_register_match(struct xtables_match *me);
 extern void xtables_register_target(struct xtables_target *me);
 
-extern int string_to_number_ll(const char *s,
-			       unsigned long long min,
-			       unsigned long long max,
-			       unsigned long long *ret);
-extern int string_to_number_l(const char *s,
-			      unsigned long min,
-			      unsigned long max,
-			      unsigned long *ret);
-extern int string_to_number(const char *s,
-			    unsigned int min,
-			    unsigned int max,
-			    unsigned int *ret);
-extern bool strtonuml(const char *, char **, unsigned long *,
+extern bool xtables_strtoul(const char *, char **, unsigned long *,
 	unsigned long, unsigned long);
-extern bool strtonum(const char *, char **, unsigned int *,
+extern bool xtables_strtoui(const char *, char **, unsigned int *,
 	unsigned int, unsigned int);
 extern int service_to_port(const char *name, const char *proto);
 extern u_int16_t parse_port(const char *port, const char *proto);
diff --git a/ip6tables.c b/ip6tables.c
index 6d1277b..0464185 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -486,7 +486,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 {
 	unsigned int proto;
 
-	if (string_to_number(pname, 0, UINT8_MAX, &proto) != -1) {
+	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
@@ -502,7 +502,7 @@ parse_protocol(const char *s)
 {
 	unsigned int proto;
 
-	if (string_to_number(s, 0, UINT8_MAX, &proto) == -1) {
+	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
 		struct protoent *pent;
 
 		/* first deal with the special case of 'all' to prevent
@@ -549,7 +549,7 @@ parse_rulenumber(const char *rule)
 {
 	unsigned int rulenum;
 
-	if (string_to_number(rule, 1, INT_MAX, &rulenum) == -1)
+	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
diff --git a/iptables.c b/iptables.c
index 07ace19..15b5b6f 100644
--- a/iptables.c
+++ b/iptables.c
@@ -488,7 +488,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 {
 	unsigned int proto;
 
-	if (string_to_number(pname, 0, UINT8_MAX, &proto) != -1) {
+	if (xtables_strtoui(pname, NULL, &proto, 0, UINT8_MAX)) {
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
@@ -504,7 +504,7 @@ parse_protocol(const char *s)
 {
 	unsigned int proto;
 
-	if (string_to_number(s, 0, UINT8_MAX, &proto) == -1) {
+	if (!xtables_strtoui(s, NULL, &proto, 0, UINT8_MAX)) {
 		struct protoent *pent;
 
 		/* first deal with the special case of 'all' to prevent
@@ -542,7 +542,7 @@ parse_rulenumber(const char *rule)
 {
 	unsigned int rulenum;
 
-	if (string_to_number(rule, 1, INT_MAX, &rulenum) == -1)
+	if (!xtables_strtoui(rule, NULL, &rulenum, 1, INT_MAX))
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
diff --git a/xtables.c b/xtables.c
index 85bd76c..9e57679 100644
--- a/xtables.c
+++ b/xtables.c
@@ -178,57 +178,24 @@ int xtables_load_ko(const char *modprobe, bool quiet)
 	return ret;
 }
 
-int string_to_number_ll(const char *s, unsigned long long min,
-			unsigned long long max, unsigned long long *ret)
-{
-	unsigned long long number;
-	char *end;
-
-	/* Handle hex, octal, etc. */
-	errno = 0;
-	number = strtoull(s, &end, 0);
-	if (*end == '\0' && end != s) {
-		/* we parsed a number, let's see if we want this */
-		if (errno != ERANGE && min <= number && (!max || number <= max)) {
-			*ret = number;
-			return 0;
-		}
-	}
-	return -1;
-}
-
-int string_to_number_l(const char *s, unsigned long min, unsigned long max,
-		       unsigned long *ret)
-{
-	int result;
-	unsigned long long number;
-
-	result = string_to_number_ll(s, min, max, &number);
-	*ret = (unsigned long)number;
-
-	return result;
-}
-
-int string_to_number(const char *s, unsigned int min, unsigned int max,
-		unsigned int *ret)
-{
-	int result;
-	unsigned long number;
-
-	result = string_to_number_l(s, min, max, &number);
-	*ret = (unsigned int)number;
-
-	return result;
-}
-
-/*
- * strtonum{,l} - string to number conversion
+/**
+ * xtables_strtou{i,l} - string to number conversion
+ * @s:	input string
+ * @end:	like strtoul's "end" pointer
+ * @value:	pointer for result
+ * @min:	minimum accepted value
+ * @max:	maximum accepted value
+ *
+ * If @end is NULL, we assume the caller wants a "strict strtoul", and hence
+ * "15a" is rejected.
+ * In either case, the value obtained is compared for min-max compliance.
+ * Base is always 0, i.e. autodetect depending on @s.
  *
- * If @end is NULL, we assume the caller does not want
- * a case like "15a", so reject it.
+ * Returns true/false whether number was accepted. On failure, *value has
+ * undefined contents.
  */
-bool strtonuml(const char *s, char **end, unsigned long *value,
-               unsigned long min, unsigned long max)
+bool xtables_strtoul(const char *s, char **end, unsigned long *value,
+                     unsigned long min, unsigned long max)
 {
 	unsigned long v;
 	char *my_end;
@@ -252,13 +219,13 @@ bool strtonuml(const char *s, char **end, unsigned long *value,
 	return false;
 }
 
-bool strtonum(const char *s, char **end, unsigned int *value,
-                  unsigned int min, unsigned int max)
+bool xtables_strtoui(const char *s, char **end, unsigned int *value,
+                     unsigned int min, unsigned int max)
 {
 	unsigned long v;
 	bool ret;
 
-	ret = strtonuml(s, end, &v, min, max);
+	ret = xtables_strtoul(s, end, &v, min, max);
 	if (value != NULL)
 		*value = v;
 	return ret;
@@ -278,7 +245,7 @@ u_int16_t parse_port(const char *port, const char *proto)
 {
 	unsigned int portnum;
 
-	if (string_to_number(port, 0, UINT16_MAX, &portnum) != -1 ||
+	if (xtables_strtoui(port, NULL, &portnum, 0, UINT16_MAX) ||
 	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
 		return portnum;
 
@@ -834,7 +801,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 				return NULL;
 
 			/* autocomplete, this is a network address */
-			if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
+			if (!xtables_strtoui(p, NULL, &onebyte, 0, UINT8_MAX))
 				return NULL;
 
 			addrp[i] = onebyte;
@@ -845,7 +812,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 		}
 
 		*q = '\0';
-		if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
+		if (!xtables_strtoui(p, NULL, &onebyte, 0, UINT8_MAX))
 			return NULL;
 
 		addrp[i] = onebyte;
@@ -853,7 +820,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 	}
 
 	/* we have checked 3 bytes, now we check the last one */
-	if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
+	if (!xtables_strtoui(p, NULL, &onebyte, 0, UINT8_MAX))
 		return NULL;
 
 	addrp[3] = onebyte;
@@ -941,7 +908,7 @@ static struct in_addr *parse_ipmask(const char *mask)
 	if ((addrp = numeric_to_ipmask(mask)) != NULL)
 		/* dotted_to_addr already returns a network byte order addr */
 		return addrp;
-	if (string_to_number(mask, 0, 32, &bits) == -1)
+	if (!xtables_strtoui(mask, NULL, &bits, 0, 32))
 		exit_error(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
@@ -1162,7 +1129,7 @@ static struct in6_addr *parse_ip6mask(char *mask)
 	}
 	if ((addrp = numeric_to_ip6addr(mask)) != NULL)
 		return addrp;
-	if (string_to_number(mask, 0, 128, &bits) == -1)
+	if (!xtables_strtoui(mask, NULL, &bits, 0, 128))
 		exit_error(PARAMETER_PROBLEM,
 			   "invalid mask `%s' specified", mask);
 	if (bits != 0) {
-- 
1.6.1.2

