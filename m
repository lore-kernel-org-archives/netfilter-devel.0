From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] policy: use direct xt_policy_info instead of ipt/ip6t
Date: Mon,  1 Jun 2009 12:06:30 +0200
Message-ID: <1243850793-9526-3-git-send-email-jengelh@medozas.de>
References: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53163 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbZFAKGe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jun 2009 06:06:34 -0400
In-Reply-To: <1243850793-9526-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_policy.c |   66 +++++++++++++++++++++---------------------
 extensions/libipt_policy.c  |   66 +++++++++++++++++++++---------------------
 2 files changed, 66 insertions(+), 66 deletions(-)

diff --git a/extensions/libip6t_policy.c b/extensions/libip6t_policy.c
index 697ac24..daeff89 100644
--- a/extensions/libip6t_policy.c
+++ b/extensions/libip6t_policy.c
@@ -12,13 +12,13 @@
 #include <arpa/inet.h>
 #include <xtables.h>
 #include <libiptc/libip6tc.h>
-#include <linux/netfilter_ipv6/ip6t_policy.h>
+#include <linux/netfilter/xt_policy.h>
 
 /*
  * HACK: global pointer to current matchinfo for making
  * final checks and adjustments in final_check.
  */
-static struct ip6t_policy_info *policy_info;
+static struct xt_policy_info *policy_info;
 
 static void policy_help(void)
 {
@@ -94,16 +94,16 @@ static const struct option policy_opts[] =
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
-		return IP6T_POLICY_MATCH_IN;
+		return XT_POLICY_MATCH_IN;
 	if (strcmp(s, "out") == 0)
-		return IP6T_POLICY_MATCH_OUT;
+		return XT_POLICY_MATCH_OUT;
 	xtables_error(PARAMETER_PROBLEM, "policy_match: invalid dir \"%s\"", s);
 }
 
 static int parse_policy(char *s)
 {
 	if (strcmp(s, "none") == 0)
-		return IP6T_POLICY_MATCH_NONE;
+		return XT_POLICY_MATCH_NONE;
 	if (strcmp(s, "ipsec") == 0)
 		return 0;
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid policy \"%s\"", s);
@@ -112,17 +112,17 @@ static int parse_policy(char *s)
 static int parse_mode(char *s)
 {
 	if (strcmp(s, "transport") == 0)
-		return IP6T_POLICY_MODE_TRANSPORT;
+		return XT_POLICY_MODE_TRANSPORT;
 	if (strcmp(s, "tunnel") == 0)
-		return IP6T_POLICY_MODE_TUNNEL;
+		return XT_POLICY_MODE_TUNNEL;
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
 static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
-	struct ip6t_policy_info *info = (void *)(*match)->data;
-	struct ip6t_policy_elem *e = &info->pol[info->len];
+	struct xt_policy_info *info = (void *)(*match)->data;
+	struct xt_policy_elem *e = &info->pol[info->len];
 	struct in6_addr *addr = NULL, mask;
 	unsigned int naddr = 0, num;
 	int mode;
@@ -131,7 +131,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT))
+		if (info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT))
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --dir option");
 		if (invert)
@@ -148,7 +148,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->flags |= parse_policy(argv[optind-1]);
 		break;
 	case '3':
-		if (info->flags & IP6T_POLICY_MATCH_STRICT)
+		if (info->flags & XT_POLICY_MATCH_STRICT)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --strict option");
 
@@ -156,7 +156,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --strict option");
 
-		info->flags |= IP6T_POLICY_MATCH_STRICT;
+		info->flags |= XT_POLICY_MATCH_STRICT;
 		break;
 	case '4':
 		if (e->match.reqid)
@@ -238,7 +238,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --next option");
 
-		if (++info->len == IP6T_POLICY_MAX_ELEM)
+		if (++info->len == XT_POLICY_MAX_ELEM)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
@@ -252,20 +252,20 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void policy_check(unsigned int flags)
 {
-	struct ip6t_policy_info *info = policy_info;
-	struct ip6t_policy_elem *e;
+	struct xt_policy_info *info = policy_info;
+	struct xt_policy_elem *e;
 	int i;
 
 	if (info == NULL)
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: no parameters given");
 
-	if (!(info->flags & (IP6T_POLICY_MATCH_IN|IP6T_POLICY_MATCH_OUT)))
+	if (!(info->flags & (XT_POLICY_MATCH_IN|XT_POLICY_MATCH_OUT)))
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: neither --in nor --out specified");
 
-	if (info->flags & IP6T_POLICY_MATCH_NONE) {
-		if (info->flags & IP6T_POLICY_MATCH_STRICT)
+	if (info->flags & XT_POLICY_MATCH_NONE) {
+		if (info->flags & XT_POLICY_MATCH_STRICT)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but --strict given");
 
@@ -275,22 +275,22 @@ static void policy_check(unsigned int flags)
 	} else
 		info->len++;	/* increase len by 1, no --next after last element */
 
-	if (!(info->flags & IP6T_POLICY_MATCH_STRICT) && info->len > 1)
+	if (!(info->flags & XT_POLICY_MATCH_STRICT) && info->len > 1)
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: multiple elements but no --strict");
 
 	for (i = 0; i < info->len; i++) {
 		e = &info->pol[i];
 
-                if (info->flags & IP6T_POLICY_MATCH_STRICT &&
+                if (info->flags & XT_POLICY_MATCH_STRICT &&
 		    !(e->match.reqid || e->match.spi || e->match.saddr ||
                       e->match.daddr || e->match.proto || e->match.mode))
 			xtables_error(PARAMETER_PROBLEM,
                                    "policy match: empty policy element");
 
 		if ((e->match.saddr || e->match.daddr)
-		    && ((e->mode == IP6T_POLICY_MODE_TUNNEL && e->invert.mode) ||
-		        (e->mode == IP6T_POLICY_MODE_TRANSPORT && !e->invert.mode)))
+		    && ((e->mode == XT_POLICY_MODE_TUNNEL && e->invert.mode) ||
+		        (e->mode == XT_POLICY_MODE_TRANSPORT && !e->invert.mode)))
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: --tunnel-src/--tunnel-dst "
 			           "is only valid in tunnel mode");
@@ -302,10 +302,10 @@ static void print_mode(char *prefix, u_int8_t mode, int numeric)
 	printf("%smode ", prefix);
 
 	switch (mode) {
-	case IP6T_POLICY_MODE_TRANSPORT:
+	case XT_POLICY_MODE_TRANSPORT:
 		printf("transport ");
 		break;
-	case IP6T_POLICY_MODE_TUNNEL:
+	case XT_POLICY_MODE_TUNNEL:
 		printf("tunnel ");
 		break;
 	default:
@@ -333,7 +333,7 @@ do {				\
 		printf("! ");	\
 } while(0)
 
-static void print_entry(char *prefix, const struct ip6t_policy_elem *e,
+static void print_entry(char *prefix, const struct xt_policy_elem *e,
                         int numeric)
 {
 	if (e->match.reqid) {
@@ -366,26 +366,26 @@ static void print_entry(char *prefix, const struct ip6t_policy_elem *e,
 	}
 }
 
-static void print_flags(char *prefix, const struct ip6t_policy_info *info)
+static void print_flags(char *prefix, const struct xt_policy_info *info)
 {
-	if (info->flags & IP6T_POLICY_MATCH_IN)
+	if (info->flags & XT_POLICY_MATCH_IN)
 		printf("%sdir in ", prefix);
 	else
 		printf("%sdir out ", prefix);
 
-	if (info->flags & IP6T_POLICY_MATCH_NONE)
+	if (info->flags & XT_POLICY_MATCH_NONE)
 		printf("%spol none ", prefix);
 	else
 		printf("%spol ipsec ", prefix);
 
-	if (info->flags & IP6T_POLICY_MATCH_STRICT)
+	if (info->flags & XT_POLICY_MATCH_STRICT)
 		printf("%sstrict ", prefix);
 }
 
 static void policy_print(const void *ip, const struct xt_entry_match *match,
                          int numeric)
 {
-	const struct ip6t_policy_info *info = (void *)match->data;
+	const struct xt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
 	printf("policy match ");
@@ -401,7 +401,7 @@ static void policy_print(const void *ip, const struct xt_entry_match *match,
 
 static void policy_save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ip6t_policy_info *info = (void *)match->data;
+	const struct xt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
 	print_flags("--", info);
@@ -416,8 +416,8 @@ static struct xtables_match policy_mt6_reg = {
 	.name		= "policy",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV6,
-	.size		= XT_ALIGN(sizeof(struct ip6t_policy_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_policy_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_policy_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_policy_info)),
 	.help		= policy_help,
 	.parse		= policy_parse,
 	.final_check	= policy_check,
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index ae7282a..d6bad00 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -12,13 +12,13 @@
 #include <arpa/inet.h>
 #include <xtables.h>
 
-#include <linux/netfilter_ipv4/ipt_policy.h>
+#include <linux/netfilter/xt_policy.h>
 
 /*
  * HACK: global pointer to current matchinfo for making
  * final checks and adjustments in final_check.
  */
-static struct ipt_policy_info *policy_info;
+static struct xt_policy_info *policy_info;
 
 static void policy_help(void)
 {
@@ -94,16 +94,16 @@ static const struct option policy_opts[] =
 static int parse_direction(char *s)
 {
 	if (strcmp(s, "in") == 0)
-		return IPT_POLICY_MATCH_IN;
+		return XT_POLICY_MATCH_IN;
 	if (strcmp(s, "out") == 0)
-		return IPT_POLICY_MATCH_OUT;
+		return XT_POLICY_MATCH_OUT;
 	xtables_error(PARAMETER_PROBLEM, "policy_match: invalid dir \"%s\"", s);
 }
 
 static int parse_policy(char *s)
 {
 	if (strcmp(s, "none") == 0)
-		return IPT_POLICY_MATCH_NONE;
+		return XT_POLICY_MATCH_NONE;
 	if (strcmp(s, "ipsec") == 0)
 		return 0;
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid policy \"%s\"", s);
@@ -112,17 +112,17 @@ static int parse_policy(char *s)
 static int parse_mode(char *s)
 {
 	if (strcmp(s, "transport") == 0)
-		return IPT_POLICY_MODE_TRANSPORT;
+		return XT_POLICY_MODE_TRANSPORT;
 	if (strcmp(s, "tunnel") == 0)
-		return IPT_POLICY_MODE_TUNNEL;
+		return XT_POLICY_MODE_TUNNEL;
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
 static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
                         const void *entry, struct xt_entry_match **match)
 {
-	struct ipt_policy_info *info = (void *)(*match)->data;
-	struct ipt_policy_elem *e = &info->pol[info->len];
+	struct xt_policy_info *info = (void *)(*match)->data;
+	struct xt_policy_elem *e = &info->pol[info->len];
 	struct in_addr *addr = NULL, mask;
 	unsigned int naddr = 0, num;
 	int mode;
@@ -131,7 +131,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case '1':
-		if (info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT))
+		if (info->flags & (XT_POLICY_MATCH_IN | XT_POLICY_MATCH_OUT))
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --dir option");
 		if (invert)
@@ -148,7 +148,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 		info->flags |= parse_policy(argv[optind-1]);
 		break;
 	case '3':
-		if (info->flags & IPT_POLICY_MATCH_STRICT)
+		if (info->flags & XT_POLICY_MATCH_STRICT)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --strict option");
 
@@ -156,7 +156,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --strict option");
 
-		info->flags |= IPT_POLICY_MATCH_STRICT;
+		info->flags |= XT_POLICY_MATCH_STRICT;
 		break;
 	case '4':
 		if (e->match.reqid)
@@ -238,7 +238,7 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: can't invert --next option");
 
-		if (++info->len == IPT_POLICY_MAX_ELEM)
+		if (++info->len == XT_POLICY_MAX_ELEM)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
@@ -252,20 +252,20 @@ static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
 
 static void policy_check(unsigned int flags)
 {
-	struct ipt_policy_info *info = policy_info;
-	struct ipt_policy_elem *e;
+	struct xt_policy_info *info = policy_info;
+	struct xt_policy_elem *e;
 	int i;
 
 	if (info == NULL)
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: no parameters given");
 
-	if (!(info->flags & (IPT_POLICY_MATCH_IN|IPT_POLICY_MATCH_OUT)))
+	if (!(info->flags & (XT_POLICY_MATCH_IN | XT_POLICY_MATCH_OUT)))
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: neither --in nor --out specified");
 
-	if (info->flags & IPT_POLICY_MATCH_NONE) {
-		if (info->flags & IPT_POLICY_MATCH_STRICT)
+	if (info->flags & XT_POLICY_MATCH_NONE) {
+		if (info->flags & XT_POLICY_MATCH_STRICT)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: policy none but --strict given");
 
@@ -275,22 +275,22 @@ static void policy_check(unsigned int flags)
 	} else
 		info->len++;	/* increase len by 1, no --next after last element */
 
-	if (!(info->flags & IPT_POLICY_MATCH_STRICT) && info->len > 1)
+	if (!(info->flags & XT_POLICY_MATCH_STRICT) && info->len > 1)
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: multiple elements but no --strict");
 
 	for (i = 0; i < info->len; i++) {
 		e = &info->pol[i];
 
-		if (info->flags & IPT_POLICY_MATCH_STRICT &&
+		if (info->flags & XT_POLICY_MATCH_STRICT &&
 		    !(e->match.reqid || e->match.spi || e->match.saddr ||
 		      e->match.daddr || e->match.proto || e->match.mode))
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: empty policy element");
 
 		if ((e->match.saddr || e->match.daddr)
-		    && ((e->mode == IPT_POLICY_MODE_TUNNEL && e->invert.mode) ||
-		        (e->mode == IPT_POLICY_MODE_TRANSPORT && !e->invert.mode)))
+		    && ((e->mode == XT_POLICY_MODE_TUNNEL && e->invert.mode) ||
+		        (e->mode == XT_POLICY_MODE_TRANSPORT && !e->invert.mode)))
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: --tunnel-src/--tunnel-dst "
 			           "is only valid in tunnel mode");
@@ -302,10 +302,10 @@ static void print_mode(char *prefix, u_int8_t mode, int numeric)
 	printf("%smode ", prefix);
 
 	switch (mode) {
-	case IPT_POLICY_MODE_TRANSPORT:
+	case XT_POLICY_MODE_TRANSPORT:
 		printf("transport ");
 		break;
-	case IPT_POLICY_MODE_TUNNEL:
+	case XT_POLICY_MODE_TUNNEL:
 		printf("tunnel ");
 		break;
 	default:
@@ -333,7 +333,7 @@ do {				\
 		printf("! ");	\
 } while(0)
 
-static void print_entry(char *prefix, const struct ipt_policy_elem *e,
+static void print_entry(char *prefix, const struct xt_policy_elem *e,
                         int numeric)
 {
 	if (e->match.reqid) {
@@ -366,26 +366,26 @@ static void print_entry(char *prefix, const struct ipt_policy_elem *e,
 	}
 }
 
-static void print_flags(char *prefix, const struct ipt_policy_info *info)
+static void print_flags(char *prefix, const struct xt_policy_info *info)
 {
-	if (info->flags & IPT_POLICY_MATCH_IN)
+	if (info->flags & XT_POLICY_MATCH_IN)
 		printf("%sdir in ", prefix);
 	else
 		printf("%sdir out ", prefix);
 
-	if (info->flags & IPT_POLICY_MATCH_NONE)
+	if (info->flags & XT_POLICY_MATCH_NONE)
 		printf("%spol none ", prefix);
 	else
 		printf("%spol ipsec ", prefix);
 
-	if (info->flags & IPT_POLICY_MATCH_STRICT)
+	if (info->flags & XT_POLICY_MATCH_STRICT)
 		printf("%sstrict ", prefix);
 }
 
 static void policy_print(const void *ip, const struct xt_entry_match *match,
                          int numeric)
 {
-	const struct ipt_policy_info *info = (void *)match->data;
+	const struct xt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
 	printf("policy match ");
@@ -399,7 +399,7 @@ static void policy_print(const void *ip, const struct xt_entry_match *match,
 
 static void policy_save(const void *ip, const struct xt_entry_match *match)
 {
-	const struct ipt_policy_info *info = (void *)match->data;
+	const struct xt_policy_info *info = (void *)match->data;
 	unsigned int i;
 
 	print_flags("--", info);
@@ -414,8 +414,8 @@ static struct xtables_match policy_mt_reg = {
 	.name		= "policy",
 	.version	= XTABLES_VERSION,
 	.family		= NFPROTO_IPV4,
-	.size		= XT_ALIGN(sizeof(struct ipt_policy_info)),
-	.userspacesize	= XT_ALIGN(sizeof(struct ipt_policy_info)),
+	.size		= XT_ALIGN(sizeof(struct xt_policy_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_policy_info)),
 	.help		= policy_help,
 	.parse		= policy_parse,
 	.final_check	= policy_check,
-- 
1.6.3.1

