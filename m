From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 16/17] libxt_ipvs: use guided option parser
Date: Mon,  9 May 2011 21:55:10 +0200
Message-ID: <1304970912-11520-17-git-send-email-jengelh@medozas.de>
References: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:49381 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754621Ab1EITzf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 15:55:35 -0400
In-Reply-To: <1304970912-11520-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_ipvs.c |  208 +++++++++++++++--------------------------------
 1 files changed, 65 insertions(+), 143 deletions(-)

diff --git a/extensions/libxt_ipvs.c b/extensions/libxt_ipvs.c
index 89303a1..88d235f 100644
--- a/extensions/libxt_ipvs.c
+++ b/extensions/libxt_ipvs.c
@@ -5,31 +5,43 @@
  *
  * Author: Hannes Eder <heder@google.com>
  */
-#include <sys/types.h>
-#include <assert.h>
-#include <ctype.h>
-#include <errno.h>
-#include <getopt.h>
-#include <netdb.h>
 #include <stdbool.h>
-#include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
 #include <xtables.h>
 #include <linux/ip_vs.h>
 #include <linux/netfilter/xt_ipvs.h>
 
-static const struct option ipvs_mt_opts[] = {
-	{ .name = "ipvs",     .has_arg = false, .val = '0' },
-	{ .name = "vproto",   .has_arg = true,  .val = '1' },
-	{ .name = "vaddr",    .has_arg = true,  .val = '2' },
-	{ .name = "vport",    .has_arg = true,  .val = '3' },
-	{ .name = "vdir",     .has_arg = true,  .val = '4' },
-	{ .name = "vmethod",  .has_arg = true,  .val = '5' },
-	{ .name = "vportctl", .has_arg = true,  .val = '6' },
-	XT_GETOPT_TABLEEND,
+enum {
+	/* For xt_ipvs: make sure this matches up with %XT_IPVS_*'s order */
+	O_IPVS = 0,
+	O_VPROTO,
+	O_VADDR,
+	O_VPORT,
+	O_VDIR,
+	O_VMETHOD,
+	O_VPORTCTL,
 };
 
+#define s struct xt_ipvs_mtinfo
+static const struct xt_option_entry ipvs_mt_opts[] = {
+	{.name = "ipvs", .id = O_IPVS, .type = XTTYPE_NONE,
+	 .flags = XTOPT_INVERT},
+	{.name = "vproto", .id = O_VPROTO, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, l4proto)},
+	{.name = "vaddr", .id = O_VADDR, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_INVERT},
+	{.name = "vport", .id = O_VPORT, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vport)},
+	{.name = "vdir", .id = O_VDIR, .type = XTTYPE_STRING},
+	{.name = "vmethod", .id = O_VMETHOD, .type = XTTYPE_STRING,
+	 .flags = XTOPT_INVERT},
+	{.name = "vportctl", .id = O_VPORTCTL, .type = XTTYPE_PORT,
+	 .flags = XTOPT_INVERT | XTOPT_PUT, XTOPT_POINTER(s, vportctl)},
+	XTOPT_TABLEEND,
+};
+#undef s
+
 static void ipvs_mt_help(void)
 {
 	printf(
@@ -49,152 +61,62 @@ static void ipvs_mt_help(void)
 		);
 }
 
-static void ipvs_mt_parse_addr_and_mask(const char *arg,
-					union nf_inet_addr *address,
-					union nf_inet_addr *mask,
-					unsigned int family)
-{
-	struct in_addr *addr = NULL;
-	struct in6_addr *addr6 = NULL;
-	unsigned int naddrs = 0;
-
-	if (family == NFPROTO_IPV4) {
-		xtables_ipparse_any(arg, &addr, &mask->in, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&address->in, addr, sizeof(*addr));
-	} else if (family == NFPROTO_IPV6) {
-		xtables_ip6parse_any(arg, &addr6, &mask->in6, &naddrs);
-		if (naddrs > 1)
-			xtables_error(PARAMETER_PROBLEM,
-				      "multiple IP addresses not allowed");
-		if (naddrs == 1)
-			memcpy(&address->in6, addr6, sizeof(*addr6));
-	} else {
-		/* Hu? */
-		assert(false);
-	}
-}
-
-/* Function which parses command options; returns true if it ate an option */
-static int ipvs_mt_parse(int c, char **argv, int invert, unsigned int *flags,
-			 const void *entry, struct xt_entry_match **match,
-			 unsigned int family)
+static void ipvs_mt_parse(struct xt_option_call *cb)
 {
-	struct xt_ipvs_mtinfo *data = (void *)(*match)->data;
-	char *p = NULL;
-	uint8_t op = 0;
-
-	if ('0' <= c && c <= '6') {
-		static const int ops[] = {
-			XT_IPVS_IPVS_PROPERTY,
-			XT_IPVS_PROTO,
-			XT_IPVS_VADDR,
-			XT_IPVS_VPORT,
-			XT_IPVS_DIR,
-			XT_IPVS_METHOD,
-			XT_IPVS_VPORTCTL
-		};
-		op = ops[c - '0'];
-	} else
-		return 0;
-
-	if (*flags & op & XT_IPVS_ONCE_MASK)
-		goto multiple_use;
-
-	switch (c) {
-	case '0': /* --ipvs */
-		/* Nothing to do here. */
-		break;
+	struct xt_ipvs_mtinfo *data = cb->data;
 
-	case '1': /* --vproto */
-		/* Canonicalize into lower case */
-		for (p = optarg; *p != '\0'; ++p)
-			*p = tolower(*p);
-
-		data->l4proto = xtables_parse_protocol(optarg);
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_VPROTO:
+		data->l4proto = cb->val.protocol;
 		break;
-
-	case '2': /* --vaddr */
-		ipvs_mt_parse_addr_and_mask(optarg, &data->vaddr,
-					    &data->vmask, family);
+	case O_VADDR:
+		memcpy(&data->vaddr, &cb->val.haddr, sizeof(cb->val.haddr));
+		memcpy(&data->vmask, &cb->val.hmask, sizeof(cb->val.hmask));
 		break;
-
-	case '3': /* --vport */
-		data->vport = htons(xtables_parse_port(optarg, "tcp"));
-		break;
-
-	case '4': /* --vdir */
-		xtables_param_act(XTF_NO_INVERT, "ipvs", "--vdir", invert);
-		if (strcasecmp(optarg, "ORIGINAL") == 0) {
+	case O_VDIR:
+		if (strcasecmp(cb->arg, "ORIGINAL") == 0) {
 			data->bitmask |= XT_IPVS_DIR;
 			data->invert   &= ~XT_IPVS_DIR;
-		} else if (strcasecmp(optarg, "REPLY") == 0) {
+		} else if (strcasecmp(cb->arg, "REPLY") == 0) {
 			data->bitmask |= XT_IPVS_DIR;
 			data->invert  |= XT_IPVS_DIR;
 		} else {
 			xtables_param_act(XTF_BAD_VALUE,
-					  "ipvs", "--vdir", optarg);
+					  "ipvs", "--vdir", cb->arg);
 		}
 		break;
-
-	case '5': /* --vmethod */
-		if (strcasecmp(optarg, "GATE") == 0)
+	case O_VMETHOD:
+		if (strcasecmp(cb->arg, "GATE") == 0)
 			data->fwd_method = IP_VS_CONN_F_DROUTE;
-		else if (strcasecmp(optarg, "IPIP") == 0)
+		else if (strcasecmp(cb->arg, "IPIP") == 0)
 			data->fwd_method = IP_VS_CONN_F_TUNNEL;
-		else if (strcasecmp(optarg, "MASQ") == 0)
+		else if (strcasecmp(cb->arg, "MASQ") == 0)
 			data->fwd_method = IP_VS_CONN_F_MASQ;
 		else
 			xtables_param_act(XTF_BAD_VALUE,
-					  "ipvs", "--vmethod", optarg);
-		break;
-
-	case '6': /* --vportctl */
-		data->vportctl = htons(xtables_parse_port(optarg, "tcp"));
+					  "ipvs", "--vmethod", cb->arg);
 		break;
 	}
-
-	if (op & XT_IPVS_ONCE_MASK) {
-		if (data->invert & XT_IPVS_IPVS_PROPERTY)
-			xtables_error(PARAMETER_PROBLEM,
-				      "! --ipvs cannot be together with"
-				      " other options");
-		data->bitmask |= XT_IPVS_IPVS_PROPERTY;
-	}
-
-	data->bitmask |= op;
-	if (invert)
-		data->invert |= op;
-	*flags |= op;
-	return 1;
-
-multiple_use:
-	xtables_error(PARAMETER_PROBLEM,
-		      "multiple use of the same IPVS option is not allowed");
+	data->bitmask |= 1 << cb->entry->id;
+	if (cb->invert)
+		data->invert |= 1 << cb->entry->id;
 }
 
-static int ipvs_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
-			  const void *entry, struct xt_entry_match **match)
+static void ipvs_mt_check(struct xt_fcheck_call *cb)
 {
-	return ipvs_mt_parse(c, argv, invert, flags, entry, match,
-			     NFPROTO_IPV4);
-}
-
-static int ipvs_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
-			  const void *entry, struct xt_entry_match **match)
-{
-	return ipvs_mt_parse(c, argv, invert, flags, entry, match,
-			     NFPROTO_IPV6);
-}
+	struct xt_ipvs_mtinfo *info = cb->data;
 
-static void ipvs_mt_check(unsigned int flags)
-{
-	if (flags == 0)
+	if (cb->xflags == 0)
 		xtables_error(PARAMETER_PROBLEM,
 			      "IPVS: At least one option is required");
+	if (info->bitmask & XT_IPVS_ONCE_MASK) {
+		if (info->invert & XT_IPVS_IPVS_PROPERTY)
+			xtables_error(PARAMETER_PROBLEM,
+				      "! --ipvs cannot be together with"
+				      " other options");
+		info->bitmask |= XT_IPVS_IPVS_PROPERTY;
+	}
 }
 
 /* Shamelessly copied from libxt_conntrack.c */
@@ -332,11 +254,11 @@ static struct xtables_match ipvs_matches_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_ipvs_mtinfo)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_ipvs_mtinfo)),
 		.help          = ipvs_mt_help,
-		.parse         = ipvs_mt4_parse,
-		.final_check   = ipvs_mt_check,
+		.x6_parse      = ipvs_mt_parse,
+		.x6_fcheck     = ipvs_mt_check,
 		.print         = ipvs_mt4_print,
 		.save          = ipvs_mt4_save,
-		.extra_opts    = ipvs_mt_opts,
+		.x6_options    = ipvs_mt_opts,
 	},
 	{
 		.version       = XTABLES_VERSION,
@@ -346,11 +268,11 @@ static struct xtables_match ipvs_matches_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_ipvs_mtinfo)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_ipvs_mtinfo)),
 		.help          = ipvs_mt_help,
-		.parse         = ipvs_mt6_parse,
-		.final_check   = ipvs_mt_check,
+		.x6_parse      = ipvs_mt_parse,
+		.x6_fcheck     = ipvs_mt_check,
 		.print         = ipvs_mt6_print,
 		.save          = ipvs_mt6_save,
-		.extra_opts    = ipvs_mt_opts,
+		.x6_options    = ipvs_mt_opts,
 	},
 };
 
-- 
1.7.1

