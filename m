From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 25/26] libxt_TPROXY: use guided option parser
Date: Wed, 13 Apr 2011 18:13:46 +0200
Message-ID: <1302711228-15947-26-git-send-email-jengelh@medozas.de>
References: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42489 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933055Ab1DMQOR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:14:17 -0400
In-Reply-To: <1302711228-15947-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am starting with a simple module here that does not require a
final_check function.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TPROXY.c |  216 +++++++++++++--------------------------------
 1 files changed, 62 insertions(+), 154 deletions(-)

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index 890dd86..5264ea7 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -1,32 +1,42 @@
 /*
- * Shared library add-on to iptables to add TPROXY target support.
+ * shared library add-on to iptables to add TPROXY target support.
  *
  * Copyright (C) 2002-2008 BalaBit IT Ltd.
  */
-#include <getopt.h>
-#include <stdbool.h>
-#include <stdint.h>
 #include <stdio.h>
-#include <string.h>
-#include <stdlib.h>
 #include <limits.h>
-
 #include <xtables.h>
-#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_TPROXY.h>
+#include <arpa/inet.h>
 
-static const struct option tproxy_tg_opts[] = {
-	{.name = "on-port",     .has_arg = true, .val = '1'},
-	{.name = "on-ip",       .has_arg = true, .val = '2'},
-	{.name = "tproxy-mark", .has_arg = true, .val = '3'},
-	XT_GETOPT_TABLEEND,
+enum {
+	P_PORT = 0,
+	P_ADDR,
+	P_MARK,
+	F_PORT = 1 << P_PORT,
+	F_ADDR = 1 << P_ADDR,
+	F_MARK = 1 << P_MARK,
 };
 
-enum {
-	PARAM_ONPORT = 1 << 0,
-	PARAM_ONIP = 1 << 1,
-	PARAM_MARK = 1 << 2,
+#define s struct xt_tproxy_target_info
+static const struct xt_option_entry tproxy_tg0_opts[] = {
+	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
+	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_ONEHOST},
+	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
+	XTOPT_TABLEEND,
 };
+#undef s
+#define s struct xt_tproxy_target_info_v1
+static const struct xt_option_entry tproxy_tg1_opts[] = {
+	{.name = "on-port", .id = P_PORT, .type = XTTYPE_PORT_NE,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, lport)},
+	{.name = "on-ip", .id = P_ADDR, .type = XTTYPE_ONEHOST,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, laddr)},
+	{.name = "tproxy-mark", .id = P_MARK, .type = XTTYPE_MARKMASK32},
+	XTOPT_TABLEEND,
+};
+#undef s
 
 static void tproxy_tg_help(void)
 {
@@ -37,134 +47,6 @@ static void tproxy_tg_help(void)
 "  --tproxy-mark value[/mask]	    Mark packets with the given value/mask\n\n");
 }
 
-static void parse_tproxy_lport(const char *s, uint16_t *portp)
-{
-	unsigned int lport;
-
-	if (xtables_strtoui(s, NULL, &lport, 0, UINT16_MAX))
-		*portp = htons(lport);
-	else
-		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-port", s);
-}
-
-static void parse_tproxy_laddr(const char *s, union nf_inet_addr *addrp,
-			       unsigned int nfproto)
-{
-	struct in6_addr *laddr6 = NULL;
-	struct in_addr *laddr4 = NULL;
-
-	if (nfproto == NFPROTO_IPV6) {
-		laddr6 = xtables_numeric_to_ip6addr(s);
-		if (laddr6 == NULL)
-			goto out;
-		addrp->in6 = *laddr6;
-	} else if (nfproto == NFPROTO_IPV4) {
-		laddr4 = xtables_numeric_to_ipaddr(s);
-		if (laddr4 == NULL)
-			goto out;
-		addrp->in = *laddr4;
-	}
-	return;
- out:
-	xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-ip", s);
-}
-
-static void parse_tproxy_mark(char *s, uint32_t *markp, uint32_t *maskp)
-{
-	unsigned int value, mask = UINT32_MAX;
-	char *end;
-
-	if (!xtables_strtoui(s, &end, &value, 0, UINT32_MAX))
-		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
-	if (*end == '/')
-		if (!xtables_strtoui(end + 1, &end, &mask, 0, UINT32_MAX))
-			xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
-	if (*end != '\0')
-		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
-
-	*markp = value;
-	*maskp = mask;
-}
-
-static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
-			const void *entry, struct xt_entry_target **target)
-{
-	struct xt_tproxy_target_info *info = (void *)(*target)->data;
-
-	switch (c) {
-	case '1':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
-		parse_tproxy_lport(optarg, &info->lport);
-		*flags |= PARAM_ONPORT;
-		return 1;
-	case '2':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
-		parse_tproxy_laddr(optarg, (void *)&info->laddr, NFPROTO_IPV4);
-		*flags |= PARAM_ONIP;
-		return 1;
-	case '3':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
-		parse_tproxy_mark(optarg, &info->mark_value, &info->mark_mask);
-		*flags |= PARAM_MARK;
-		return 1;
-	}
-
-	return 0;
-}
-
-static int
-tproxy_tg_parse1(int c, char **argv, int invert, unsigned int *flags,
-		 struct xt_tproxy_target_info_v1 *info, unsigned int nfproto)
-{
-	switch (c) {
-	case '1':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
-		parse_tproxy_lport(optarg, &info->lport);
-		*flags |= PARAM_ONPORT;
-		return true;
-	case '2':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
-		parse_tproxy_laddr(optarg, (void *)&info->laddr, nfproto);
-		*flags |= PARAM_ONIP;
-		return true;
-	case '3':
-		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
-		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
-		parse_tproxy_mark(optarg, &info->mark_value, &info->mark_mask);
-		*flags |= PARAM_MARK;
-		return true;
-	}
-	return false;
-}
-
-static int
-tproxy_tg_parse4(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry, struct xt_entry_target **target)
-{
-	struct xt_tproxy_target_info_v1 *info = (void *)(*target)->data;
-	return tproxy_tg_parse1(c, argv, invert, flags, info, NFPROTO_IPV4);
-}
-
-static int
-tproxy_tg_parse6(int c, char **argv, int invert, unsigned int *flags,
-		 const void *entry, struct xt_entry_target **target)
-{
-	struct xt_tproxy_target_info_v1 *info = (void *)(*target)->data;
-	return tproxy_tg_parse1(c, argv, invert, flags, info, NFPROTO_IPV6);
-}
-
-static void tproxy_tg_check(unsigned int flags)
-{
-	if (!(flags & PARAM_ONPORT))
-		xtables_error(PARAMETER_PROBLEM,
-			   "TPROXY target: Parameter --on-port is required");
-}
-
 static void tproxy_tg_print(const void *ip, const struct xt_entry_target *target,
 			 int numeric)
 {
@@ -236,6 +118,35 @@ tproxy_tg_save6(const void *ip, const struct xt_entry_target *target)
 	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
 }
 
+static void tproxy_tg0_parse(struct xt_option_call *cb)
+{
+	struct xt_tproxy_target_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case P_MARK:
+		info->mark_value = cb->val.mark;
+		info->mark_mask  = cb->val.mask;
+		break;
+	case P_ADDR:
+		info->laddr = cb->val.inetaddr.ip;
+		break;
+	}
+}
+
+static void tproxy_tg1_parse(struct xt_option_call *cb)
+{
+	struct xt_tproxy_target_info_v1 *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case P_MARK:
+		info->mark_value = cb->val.mark;
+		info->mark_mask  = cb->val.mask;
+		break;
+	}
+}
+
 static struct xtables_target tproxy_tg_reg[] = {
 	{
 		.name          = "TPROXY",
@@ -245,11 +156,10 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
 		.help          = tproxy_tg_help,
-		.parse         = tproxy_tg_parse,
-		.final_check   = tproxy_tg_check,
 		.print         = tproxy_tg_print,
 		.save          = tproxy_tg_save,
-		.extra_opts    = tproxy_tg_opts,
+		.x6_options    = tproxy_tg0_opts,
+		.x6_parse      = tproxy_tg0_parse,
 	},
 	{
 		.name          = "TPROXY",
@@ -259,11 +169,10 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
 		.help          = tproxy_tg_help,
-		.parse         = tproxy_tg_parse4,
-		.final_check   = tproxy_tg_check,
 		.print         = tproxy_tg_print4,
 		.save          = tproxy_tg_save4,
-		.extra_opts    = tproxy_tg_opts,
+		.x6_options    = tproxy_tg1_opts,
+		.x6_parse      = tproxy_tg1_parse,
 	},
 	{
 		.name          = "TPROXY",
@@ -273,11 +182,10 @@ static struct xtables_target tproxy_tg_reg[] = {
 		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
 		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
 		.help          = tproxy_tg_help,
-		.parse         = tproxy_tg_parse6,
-		.final_check   = tproxy_tg_check,
 		.print         = tproxy_tg_print6,
 		.save          = tproxy_tg_save6,
-		.extra_opts    = tproxy_tg_opts,
+		.x6_options    = tproxy_tg1_opts,
+		.x6_parse      = tproxy_tg1_parse,
 	},
 };
 
-- 
1.7.1

