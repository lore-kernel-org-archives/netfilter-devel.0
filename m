From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 09/17] libxt_policy: use guided option parser
Date: Mon,  9 May 2011 21:55:03 +0200
Message-ID: <1304970912-11520-10-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49355 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754585Ab1EITz0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:26 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_policy.c |  269 ++++++++++++---------------------------------
 1 files changed, 73 insertions(+), 196 deletions(-)

diff --git a/extensions/libxt_policy.c b/extensions/libxt_policy.c
index 16e8c53..a514246 100644
--- a/extensions/libxt_policy.c
+++ b/extensions/libxt_policy.c
@@ -1,25 +1,23 @@
-/* Shared library add-on to iptables to add policy support. */
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
-#include <netdb.h>
 #include <string.h>
-#include <stdlib.h>
-#include <syslog.h>
-#include <getopt.h>
 #include <netdb.h>
-#include <errno.h>
-#include <sys/socket.h>
-#include <netinet/in.h>
-#include <arpa/inet.h>
 #include <xtables.h>
-
 #include <linux/netfilter/xt_policy.h>
 
-/*
- * HACK: global pointer to current matchinfo for making
- * final checks and adjustments in final_check.
- */
-static struct xt_policy_info *policy_info;
+enum {
+	O_DIRECTION = 0,
+	O_POLICY,
+	O_STRICT,
+	O_REQID,
+	O_SPI,
+	O_PROTO,
+	O_MODE,
+	O_TUNNELSRC,
+	O_TUNNELDST,
+	O_NEXT
+};
 
 static void policy_help(void)
 {
@@ -39,62 +37,22 @@ static void policy_help(void)
 "  --next 			begin next element in policy\n");
 }
 
-static const struct option policy_opts[] =
-{
-	{
-		.name		= "dir",
-		.has_arg	= true,
-		.val		= '1',
-	},
-	{
-		.name		= "pol",
-		.has_arg	= true,
-		.val		= '2',
-	},
-	{
-		.name		= "strict",
-		.has_arg	= false,
-		.val		= '3'
-	},
-	{
-		.name		= "reqid",
-		.has_arg	= true,
-		.val		= '4',
-	},
-	{
-		.name		= "spi",
-		.has_arg	= true,
-		.val		= '5'
-	},
-	{
-		.name		= "tunnel-src",
-		.has_arg	= true,
-		.val		= '6'
-	},
-	{
-		.name		= "tunnel-dst",
-		.has_arg	= true,
-		.val		= '7'
-	},
-	{
-		.name		= "proto",
-		.has_arg	= true,
-		.val		= '8'
-	},
-	{
-		.name		= "mode",
-		.has_arg	= true,
-		.val		= '9'
-	},
-	{
-		.name		= "next",
-		.has_arg	= false,
-		.val		= 'a'
-	},
-	XT_GETOPT_TABLEEND,
+static const struct xt_option_entry policy_opts[] = {
+	{.name = "dir", .id = O_DIRECTION, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "pol", .id = O_POLICY, .type = XTTYPE_STRING},
+	{.name = "strict", .id = O_STRICT, .type = XTTYPE_NONE},
+	{.name = "reqid", .id = O_REQID, .type = XTTYPE_UINT32},
+	{.name = "spi", .id = O_SPI, .type = XTTYPE_UINT32},
+	{.name = "tunnel-src", .id = O_TUNNELSRC, .type = XTTYPE_HOSTMASK},
+	{.name = "tunnel-dst", .id = O_TUNNELDST, .type = XTTYPE_HOSTMASK},
+	{.name = "proto", .id = O_PROTO, .type = XTTYPE_STRING},
+	{.name = "mode", .id = O_MODE, .type = XTTYPE_STRING},
+	{.name = "next", .id = O_NEXT, .type = XTTYPE_NONE},
+	XTOPT_TABLEEND,
 };
 
-static int parse_direction(char *s)
+static int parse_direction(const char *s)
 {
 	if (strcmp(s, "in") == 0)
 		return XT_POLICY_MATCH_IN;
@@ -103,7 +61,7 @@ static int parse_direction(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy_match: invalid dir \"%s\"", s);
 }
 
-static int parse_policy(char *s)
+static int parse_policy(const char *s)
 {
 	if (strcmp(s, "none") == 0)
 		return XT_POLICY_MATCH_NONE;
@@ -112,7 +70,7 @@ static int parse_policy(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid policy \"%s\"", s);
 }
 
-static int parse_mode(char *s)
+static int parse_mode(const char *s)
 {
 	if (strcmp(s, "transport") == 0)
 		return XT_POLICY_MODE_TRANSPORT;
@@ -121,176 +79,95 @@ static int parse_mode(char *s)
 	xtables_error(PARAMETER_PROBLEM, "policy match: invalid mode \"%s\"", s);
 }
 
-static int policy_parse(int c, char **argv, int invert, unsigned int *flags,
-                        struct xt_policy_info *info, uint8_t family)
+static void policy_parse(struct xt_option_call *cb)
 {
+	struct xt_policy_info *info = cb->data;
 	struct xt_policy_elem *e = &info->pol[info->len];
-	struct in_addr *addr = NULL, mask;
-	struct in6_addr *addr6 = NULL, mask6;
-	unsigned int naddr = 0, num;
-	int mode;
-
-	xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 
-	switch (c) {
-	case '1':
-		if (info->flags & (XT_POLICY_MATCH_IN | XT_POLICY_MATCH_OUT))
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: double --dir option");
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: can't invert --dir option");
-
-		info->flags |= parse_direction(optarg);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_DIRECTION:
+		info->flags |= parse_direction(cb->arg);
 		break;
-	case '2':
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: can't invert --policy option");
-
-		info->flags |= parse_policy(optarg);
+	case O_POLICY:
+		info->flags |= parse_policy(cb->arg);
 		break;
-	case '3':
-		if (info->flags & XT_POLICY_MATCH_STRICT)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: double --strict option");
-
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: can't invert --strict option");
-
+	case O_STRICT:
 		info->flags |= XT_POLICY_MATCH_STRICT;
 		break;
-	case '4':
+	case O_REQID:
 		if (e->match.reqid)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --reqid option");
-
 		e->match.reqid = 1;
-		e->invert.reqid = invert;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "policy", "--spi", optarg);
-		e->reqid = num;
+		e->invert.reqid = cb->invert;
+		e->reqid = cb->val.u32;
 		break;
-	case '5':
+	case O_SPI:
 		if (e->match.spi)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --spi option");
-
 		e->match.spi = 1;
-		e->invert.spi = invert;
-		if (!xtables_strtoui(optarg, NULL, &num, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "policy", "--spi", optarg);
-		e->spi = num;
+		e->invert.spi = cb->invert;
+		e->spi = cb->val.u32;
 		break;
-	case '6':
+	case O_TUNNELSRC:
 		if (e->match.saddr)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
-		if (family == NFPROTO_IPV6)
-			xtables_ip6parse_any(optarg, &addr6, &mask6, &naddr);
-		else
-			xtables_ipparse_any(optarg, &addr, &mask, &naddr);
-		if (naddr > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: name resolves to multiple IPs");
-
 		e->match.saddr = 1;
-		e->invert.saddr = invert;
-		if (family == NFPROTO_IPV6) {
-			memcpy(&e->saddr.a6, addr6, sizeof(*addr6));
-			memcpy(&e->smask.a6, &mask6, sizeof(mask6));
-		} else {
-			e->saddr.a4 = addr[0];
-			e->smask.a4 = mask;
-		}
+		e->invert.saddr = cb->invert;
+		memcpy(&e->saddr, &cb->val.haddr, sizeof(cb->val.haddr));
+		memcpy(&e->smask, &cb->val.hmask, sizeof(cb->val.hmask));
                 break;
-	case '7':
+	case O_TUNNELDST:
 		if (e->match.daddr)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
-
-		if (family == NFPROTO_IPV6)
-			xtables_ip6parse_any(optarg, &addr6, &mask6, &naddr);
-		else
-			xtables_ipparse_any(optarg, &addr, &mask, &naddr);
-		if (naddr > 1)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: name resolves to multiple IPs");
-
 		e->match.daddr = 1;
-		e->invert.daddr = invert;
-		if (family == NFPROTO_IPV6) {
-			memcpy(&e->daddr.a6, addr6, sizeof(*addr6));
-			memcpy(&e->dmask.a6, &mask6, sizeof(mask6));
-		} else {
-			e->daddr.a4 = addr[0];
-			e->dmask.a4 = mask;
-		}
+		e->invert.daddr = cb->invert;
+		memcpy(&e->daddr, &cb->val.haddr, sizeof(cb->val.haddr));
+		memcpy(&e->dmask, &cb->val.hmask, sizeof(cb->val.hmask));
 		break;
-	case '8':
+	case O_PROTO:
 		if (e->match.proto)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --proto option");
-
-		e->proto = xtables_parse_protocol(optarg);
+		e->proto = xtables_parse_protocol(cb->arg);
 		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
 		    e->proto != IPPROTO_COMP)
 			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: protocol must ah/esp/ipcomp");
+			           "policy match: protocol must be ah/esp/ipcomp");
 		e->match.proto = 1;
-		e->invert.proto = invert;
+		e->invert.proto = cb->invert;
 		break;
-	case '9':
+	case O_MODE:
 		if (e->match.mode)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: double --mode option");
-
-		mode = parse_mode(optarg);
 		e->match.mode = 1;
-		e->invert.mode = invert;
-		e->mode = mode;
+		e->invert.mode = cb->invert;
+		e->mode = parse_mode(cb->arg);
 		break;
-	case 'a':
-		if (invert)
-			xtables_error(PARAMETER_PROBLEM,
-			           "policy match: can't invert --next option");
-
+	case O_NEXT:
 		if (++info->len == XT_POLICY_MAX_ELEM)
 			xtables_error(PARAMETER_PROBLEM,
 			           "policy match: maximum policy depth reached");
 		break;
 	}
-
-	policy_info = info;
-	return 1;
-}
-
-static int policy4_parse(int c, char **argv, int invert, unsigned int *flags,
-                         const void *entry, struct xt_entry_match **match)
-{
-	return policy_parse(c, argv, invert, flags, (void *)(*match)->data,
-	       NFPROTO_IPV4);
 }
 
-static int policy6_parse(int c, char **argv, int invert, unsigned int *flags,
-                        const void *entry, struct xt_entry_match **match)
+static void policy_check(struct xt_fcheck_call *cb)
 {
-	return policy_parse(c, argv, invert, flags, (void *)(*match)->data,
-	       NFPROTO_IPV6);
-}
-
-static void policy_check(unsigned int flags)
-{
-	struct xt_policy_info *info = policy_info;
-	struct xt_policy_elem *e;
+	struct xt_policy_info *info = cb->data;
+	const struct xt_policy_elem *e;
 	int i;
 
-	if (info == NULL)
-		xtables_error(PARAMETER_PROBLEM,
-		           "policy match: no parameters given");
-
+	/*
+	 * The old "no parameters given" check is carried out
+	 * by testing for --dir.
+	 */
 	if (!(info->flags & (XT_POLICY_MATCH_IN | XT_POLICY_MATCH_OUT)))
 		xtables_error(PARAMETER_PROBLEM,
 		           "policy match: neither --dir in nor --dir out specified");
@@ -487,11 +364,11 @@ static struct xtables_match policy_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_policy_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_policy_info)),
 		.help          = policy_help,
-		.parse         = policy4_parse,
-		.final_check   = policy_check,
+		.x6_parse      = policy_parse,
+		.x6_fcheck     = policy_check,
 		.print         = policy4_print,
 		.save          = policy4_save,
-		.extra_opts    = policy_opts,
+		.x6_options    = policy_opts,
 	},
 	{
 		.name          = "policy",
@@ -500,11 +377,11 @@ static struct xtables_match policy_mt_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_policy_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_policy_info)),
 		.help          = policy_help,
-		.parse         = policy6_parse,
-		.final_check   = policy_check,
+		.x6_parse      = policy_parse,
+		.x6_fcheck     = policy_check,
 		.print         = policy6_print,
 		.save          = policy6_save,
-		.extra_opts    = policy_opts,
+		.x6_options    = policy_opts,
 	},
 };
 
-- 
1.7.1

