From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 05/16] extensions: use UINT_MAX constants over open-coded numbers (2/2)
Date: Mon,  9 Feb 2009 18:34:49 +0100
Message-ID: <1234200900-5964-6-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51465 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbZBIRfF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:05 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use the handy constants for ranges.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_HL.c        |    2 +-
 extensions/libip6t_icmp6.c     |    4 ++--
 extensions/libip6t_mh.c        |    2 +-
 extensions/libipt_TTL.c        |    2 +-
 extensions/libipt_icmp.c       |    4 ++--
 extensions/libipt_ttl.c        |    6 +++---
 extensions/libxt_DSCP.c        |    2 +-
 extensions/libxt_NFQUEUE.c     |    2 +-
 extensions/libxt_TCPMSS.c      |    2 +-
 extensions/libxt_TCPOPTSTRIP.c |    2 +-
 extensions/libxt_TOS.c         |    6 +++---
 extensions/libxt_TPROXY.c      |    2 +-
 extensions/libxt_dccp.c        |    2 +-
 extensions/libxt_dscp.c        |    2 +-
 extensions/libxt_hashlimit.c   |   16 ++++++++--------
 extensions/libxt_length.c      |    2 +-
 extensions/libxt_statistic.c   |    4 ++--
 extensions/libxt_tcp.c         |    2 +-
 extensions/libxt_tcpmss.c      |    2 +-
 extensions/tos_values.c        |    2 +-
 ip6tables.c                    |    4 ++--
 iptables.c                     |    4 ++--
 xtables.c                      |    8 ++++----
 23 files changed, 42 insertions(+), 42 deletions(-)

diff --git a/extensions/libip6t_HL.c b/extensions/libip6t_HL.c
index 92266e4..8f55572 100644
--- a/extensions/libip6t_HL.c
+++ b/extensions/libip6t_HL.c
@@ -44,7 +44,7 @@ static int HL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM,
 				"HL: unexpected `!'");
 	
-	if (string_to_number(optarg, 0, 255, &value) == -1)	
+	if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)	
 		exit_error(PARAMETER_PROBLEM,	
 		           "HL: Expected value between 0 and 255");
 
diff --git a/extensions/libip6t_icmp6.c b/extensions/libip6t_icmp6.c
index b87538f..17567df 100644
--- a/extensions/libip6t_icmp6.c
+++ b/extensions/libip6t_icmp6.c
@@ -123,12 +123,12 @@ parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 		if (slash)
 			*slash = '\0';
 
-		if (string_to_number(buffer, 0, 255, &number) == -1)
+		if (string_to_number(buffer, 0, UINT8_MAX, &number) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid ICMPv6 type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
-			if (string_to_number(slash+1, 0, 255, &number) == -1)
+			if (string_to_number(slash+1, 0, UINT8_MAX, &number) == -1)
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid ICMPv6 code `%s'\n",
 					   slash+1);
diff --git a/extensions/libip6t_mh.c b/extensions/libip6t_mh.c
index e76d7c3..8b58bcd 100644
--- a/extensions/libip6t_mh.c
+++ b/extensions/libip6t_mh.c
@@ -93,7 +93,7 @@ static unsigned int name_to_type(const char *name)
 	} else {
 		unsigned int number;
 
-		if (string_to_number(name, 0, 255, &number) == -1)
+		if (string_to_number(name, 0, UINT8_MAX, &number) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid MH type `%s'\n", name);
 		return number;
diff --git a/extensions/libipt_TTL.c b/extensions/libipt_TTL.c
index 7647f2f..e124381 100644
--- a/extensions/libipt_TTL.c
+++ b/extensions/libipt_TTL.c
@@ -44,7 +44,7 @@ static int TTL_parse(int c, char **argv, int invert, unsigned int *flags,
 		exit_error(PARAMETER_PROBLEM,
 				"TTL: unexpected `!'");
 	
-	if (string_to_number(optarg, 0, 255, &value) == -1)
+	if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
 		exit_error(PARAMETER_PROBLEM,
 		           "TTL: Expected value between 0 and 255");
 
diff --git a/extensions/libipt_icmp.c b/extensions/libipt_icmp.c
index fa5a540..7aff9ca 100644
--- a/extensions/libipt_icmp.c
+++ b/extensions/libipt_icmp.c
@@ -147,12 +147,12 @@ parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 		if (slash)
 			*slash = '\0';
 
-		if (string_to_number(buffer, 0, 255, &number) == -1)
+		if (string_to_number(buffer, 0, UINT8_MAX, &number) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "Invalid ICMP type `%s'\n", buffer);
 		*type = number;
 		if (slash) {
-			if (string_to_number(slash+1, 0, 255, &number) == -1)
+			if (string_to_number(slash+1, 0, UINT8_MAX, &number) == -1)
 				exit_error(PARAMETER_PROBLEM,
 					   "Invalid ICMP code `%s'\n",
 					   slash+1);
diff --git a/extensions/libipt_ttl.c b/extensions/libipt_ttl.c
index 055c92e..a8455e1 100644
--- a/extensions/libipt_ttl.c
+++ b/extensions/libipt_ttl.c
@@ -33,7 +33,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 		case '2':
-			if (string_to_number(optarg, 0, 255, &value) == -1)
+			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
@@ -46,7 +46,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->ttl = value;
 			break;
 		case '3':
-			if (string_to_number(optarg, 0, 255, &value) == -1)
+			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
@@ -58,7 +58,7 @@ static int ttl_parse(int c, char **argv, int invert, unsigned int *flags,
 			info->ttl = value;
 			break;
 		case '4':
-			if (string_to_number(optarg, 0, 255, &value) == -1)
+			if (string_to_number(optarg, 0, UINT8_MAX, &value) == -1)
 				exit_error(PARAMETER_PROBLEM,
 				           "ttl: Expected value between 0 and 255");
 
diff --git a/extensions/libxt_DSCP.c b/extensions/libxt_DSCP.c
index 409fa19..92a6de5 100644
--- a/extensions/libxt_DSCP.c
+++ b/extensions/libxt_DSCP.c
@@ -48,7 +48,7 @@ parse_dscp(const char *s, struct xt_DSCP_info *dinfo)
 {
 	unsigned int dscp;
        
-	if (string_to_number(s, 0, 255, &dscp) == -1)
+	if (string_to_number(s, 0, UINT8_MAX, &dscp) == -1)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
diff --git a/extensions/libxt_NFQUEUE.c b/extensions/libxt_NFQUEUE.c
index 5880785..1a58760 100644
--- a/extensions/libxt_NFQUEUE.c
+++ b/extensions/libxt_NFQUEUE.c
@@ -33,7 +33,7 @@ parse_num(const char *s, struct xt_NFQ_info *tinfo)
 {
 	unsigned int num;
        
-	if (string_to_number(s, 0, 65535, &num) == -1)
+	if (string_to_number(s, 0, UINT16_MAX, &num) == -1)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid queue number `%s'\n", s);
 
diff --git a/extensions/libxt_TCPMSS.c b/extensions/libxt_TCPMSS.c
index 2227eb4..9b62a56 100644
--- a/extensions/libxt_TCPMSS.c
+++ b/extensions/libxt_TCPMSS.c
@@ -55,7 +55,7 @@ static int __TCPMSS_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags)
 			exit_error(PARAMETER_PROBLEM,
 			           "TCPMSS target: Only one option may be specified");
-		if (string_to_number(optarg, 0, 65535 - hdrsize, &mssval) == -1)
+		if (string_to_number(optarg, 0, UINT16_MAX - hdrsize, &mssval) == -1)
 			exit_error(PARAMETER_PROBLEM, "Bad TCPMSS value `%s'", optarg);
 		
 		mssinfo->mss = mssval;
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 758f847..7211288 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -82,7 +82,7 @@ static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 				break;
 			}
 
-		if (option == 0 && string_to_number(arg, 0, 255, &option) == -1)
+		if (option == 0 && string_to_number(arg, 0, UINT8_MAX, &option) == -1)
 			exit_error(PARAMETER_PROBLEM,
 			           "Bad TCP option value \"%s\"", arg);
 
diff --git a/extensions/libxt_TOS.c b/extensions/libxt_TOS.c
index c185681..a04f741 100644
--- a/extensions/libxt_TOS.c
+++ b/extensions/libxt_TOS.c
@@ -118,7 +118,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '&': /* --and-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--and-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--and-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, 0xFF))
+		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--and-tos", optarg);
 		info->tos_value = 0;
 		info->tos_mask  = ~bits;
@@ -127,7 +127,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '|': /* --or-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--or-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--or-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, 0xFF))
+		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--or-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = bits;
@@ -136,7 +136,7 @@ static int tos_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '^': /* --xor-tos */
 		param_act(P_ONLY_ONCE, "TOS", "--xor-tos", *flags & FLAG_TOS);
 		param_act(P_NO_INVERT, "TOS", "--xor-tos", invert);
-		if (!strtonum(optarg, NULL, &bits, 0, 0xFF))
+		if (!strtonum(optarg, NULL, &bits, 0, UINT8_MAX))
 			param_act(P_BAD_VALUE, "TOS", "--xor-tos", optarg);
 		info->tos_value = bits;
 		info->tos_mask  = 0;
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index e9a41a1..41ca243 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -40,7 +40,7 @@ static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info
 {
 	unsigned int lport;
 
-	if (string_to_number(s, 0, 65535, &lport) != -1)
+	if (string_to_number(s, 0, UINT16_MAX, &lport) != -1)
 		info->lport = htons(lport);
 	else
 		param_act(P_BAD_VALUE, "TPROXY", "--on-port", s);
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index b1ae62e..0eb95ce 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -121,7 +121,7 @@ static u_int8_t parse_dccp_option(char *optstring)
 {
 	unsigned int ret;
 
-	if (string_to_number(optstring, 1, 255, &ret) == -1)
+	if (string_to_number(optstring, 1, UINT8_MAX, &ret) == -1)
 		exit_error(PARAMETER_PROBLEM, "Bad DCCP option `%s'",
 			   optstring);
 
diff --git a/extensions/libxt_dscp.c b/extensions/libxt_dscp.c
index 315e219..ae5a624 100644
--- a/extensions/libxt_dscp.c
+++ b/extensions/libxt_dscp.c
@@ -48,7 +48,7 @@ parse_dscp(const char *s, struct xt_dscp_info *dinfo)
 {
 	unsigned int dscp;
        
-	if (string_to_number(s, 0, 255, &dscp) == -1)
+	if (string_to_number(s, 0, UINT8_MAX, &dscp) == -1)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid dscp `%s'\n", s);
 
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 1c50685..278e098 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -240,7 +240,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
+		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-size: `%s'", optarg);
 		r->cfg.size = num;
@@ -250,7 +250,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
+		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-max: `%s'", optarg);
 		r->cfg.max = num;
@@ -261,7 +261,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
+		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-gcinterval: `%s'", 
 				optarg);
@@ -273,7 +273,7 @@ hashlimit_parse(int c, char **argv, int invert, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
 		if (check_inverse(argv[optind-1], &invert, &optind, 0)) break;
-		if (string_to_number(optarg, 0, 0xffffffff, &num) == -1)
+		if (string_to_number(optarg, 0, UINT32_MAX, &num) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				"bad --hashlimit-htable-expire: `%s'", optarg);
 		/* FIXME: not HZ dependent */
@@ -351,7 +351,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '&': /* --hashlimit-htable-size */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-size",
 		          *flags & PARAM_SIZE);
-		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-size", optarg);
 		info->cfg.size = num;
@@ -361,7 +361,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case '*': /* --hashlimit-htable-max */
 		param_act(P_ONLY_ONCE, "hashlimit", "--hashlimit-htable-max",
 		          *flags & PARAM_MAX);
-		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-max", optarg);
 		info->cfg.max = num;
@@ -372,7 +372,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-gcinterval",
 		          *flags & PARAM_GCINTERVAL);
-		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-gcinterval", optarg);
 		/* FIXME: not HZ dependent!! */
@@ -383,7 +383,7 @@ hashlimit_mt_parse(struct xt_hashlimit_mtinfo1 *info, unsigned int *flags,
 	case ')': /* --hashlimit-htable-expire */
 		param_act(P_ONLY_ONCE, "hashlimit",
 		          "--hashlimit-htable-expire", *flags & PARAM_EXPIRE);
-		if (!strtonum(optarg, NULL, &num, 0, 0xffffffff))
+		if (!strtonum(optarg, NULL, &num, 0, UINT32_MAX))
 			param_act(P_BAD_VALUE, "hashlimit",
 			          "--hashlimit-htable-expire", optarg);
 		/* FIXME: not HZ dependent */
diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
index e350431..0e196d7 100644
--- a/extensions/libxt_length.c
+++ b/extensions/libxt_length.c
@@ -26,7 +26,7 @@ parse_length(const char *s)
 {
 	unsigned int len;
 	
-	if (string_to_number(s, 0, 0xFFFF, &len) == -1)
+	if (string_to_number(s, 0, UINT16_MAX, &len) == -1)
 		exit_error(PARAMETER_PROBLEM, "length invalid: `%s'\n", s);
 	else
 		return len;
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index d85aacb..e43de7d 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -70,7 +70,7 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '3':
 		if (*flags & 0x4)
 			exit_error(PARAMETER_PROBLEM, "double --every");
-		if (string_to_number(optarg, 0, 0xFFFFFFFF,
+		if (string_to_number(optarg, 0, UINT32_MAX,
 				     &info->u.nth.every) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "cannot parse --every `%s'", optarg);
@@ -82,7 +82,7 @@ statistic_parse(int c, char **argv, int invert, unsigned int *flags,
 	case '4':
 		if (*flags & 0x8)
 			exit_error(PARAMETER_PROBLEM, "double --packet");
-		if (string_to_number(optarg, 0, 0xFFFFFFFF,
+		if (string_to_number(optarg, 0, UINT32_MAX,
 				     &info->u.nth.packet) == -1)
 			exit_error(PARAMETER_PROBLEM,
 				   "cannot parse --packet `%s'", optarg);
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index a9039f0..82954a4 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -121,7 +121,7 @@ parse_tcp_option(const char *option, u_int8_t *result)
 {
 	unsigned int ret;
 
-	if (string_to_number(option, 1, 255, &ret) == -1)
+	if (string_to_number(option, 1, UINT8_MAX, &ret) == -1)
 		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
 
 	*result = ret;
diff --git a/extensions/libxt_tcpmss.c b/extensions/libxt_tcpmss.c
index a720c42..e64a1b3 100644
--- a/extensions/libxt_tcpmss.c
+++ b/extensions/libxt_tcpmss.c
@@ -26,7 +26,7 @@ parse_tcp_mssvalue(const char *mssvalue)
 {
 	unsigned int mssvaluenum;
 
-	if (string_to_number(mssvalue, 0, 65535, &mssvaluenum) != -1)
+	if (string_to_number(mssvalue, 0, UINT16_MAX, &mssvaluenum) != -1)
 		return mssvaluenum;
 
 	exit_error(PARAMETER_PROBLEM,
diff --git a/extensions/tos_values.c b/extensions/tos_values.c
index 0ab784d..2d5b431 100644
--- a/extensions/tos_values.c
+++ b/extensions/tos_values.c
@@ -55,7 +55,7 @@ static bool tos_parse_numeric(const char *str, struct tos_value_mask *tvm,
 static bool tos_parse_symbolic(const char *str, struct tos_value_mask *tvm,
     unsigned int def_mask)
 {
-	const unsigned int max = 255;
+	const unsigned int max = UINT8_MAX;
 	const struct tos_symbol_info *symbol;
 	char *tmp;
 
diff --git a/ip6tables.c b/ip6tables.c
index 0a6f75b..6d1277b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -486,7 +486,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 {
 	unsigned int proto;
 
-	if (string_to_number(pname, 0, 255, &proto) != -1) {
+	if (string_to_number(pname, 0, UINT8_MAX, &proto) != -1) {
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
@@ -502,7 +502,7 @@ parse_protocol(const char *s)
 {
 	unsigned int proto;
 
-	if (string_to_number(s, 0, 255, &proto) == -1) {
+	if (string_to_number(s, 0, UINT8_MAX, &proto) == -1) {
 		struct protoent *pent;
 
 		/* first deal with the special case of 'all' to prevent
diff --git a/iptables.c b/iptables.c
index 7b8d239..07ace19 100644
--- a/iptables.c
+++ b/iptables.c
@@ -488,7 +488,7 @@ find_proto(const char *pname, enum xtables_tryload tryload,
 {
 	unsigned int proto;
 
-	if (string_to_number(pname, 0, 255, &proto) != -1) {
+	if (string_to_number(pname, 0, UINT8_MAX, &proto) != -1) {
 		char *protoname = proto_to_name(proto, nolookup);
 
 		if (protoname)
@@ -504,7 +504,7 @@ parse_protocol(const char *s)
 {
 	unsigned int proto;
 
-	if (string_to_number(s, 0, 255, &proto) == -1) {
+	if (string_to_number(s, 0, UINT8_MAX, &proto) == -1) {
 		struct protoent *pent;
 
 		/* first deal with the special case of 'all' to prevent
diff --git a/xtables.c b/xtables.c
index 10a2268..fb5cc62 100644
--- a/xtables.c
+++ b/xtables.c
@@ -263,7 +263,7 @@ u_int16_t parse_port(const char *port, const char *proto)
 {
 	unsigned int portnum;
 
-	if ((string_to_number(port, 0, 65535, &portnum)) != -1 ||
+	if (string_to_number(port, 0, UINT16_MAX, &portnum) != -1 ||
 	    (portnum = service_to_port(port, proto)) != (unsigned)-1)
 		return portnum;
 
@@ -817,7 +817,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 				return NULL;
 
 			/* autocomplete, this is a network address */
-			if (!strtonum(p, NULL, &onebyte, 0, 255))
+			if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
 				return NULL;
 
 			addrp[i] = onebyte;
@@ -828,7 +828,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 		}
 
 		*q = '\0';
-		if (!strtonum(p, NULL, &onebyte, 0, 255))
+		if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
 			return NULL;
 
 		addrp[i] = onebyte;
@@ -836,7 +836,7 @@ static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
 	}
 
 	/* we have checked 3 bytes, now we check the last one */
-	if (!strtonum(p, NULL, &onebyte, 0, 255))
+	if (!strtonum(p, NULL, &onebyte, 0, UINT8_MAX))
 		return NULL;
 
 	addrp[3] = onebyte;
-- 
1.6.1.2

