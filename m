From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/5] TPROXY: add support for revision 1
Date: Fri,  3 Dec 2010 22:58:42 +0100
Message-ID: <1291413524-15016-5-git-send-email-jengelh@medozas.de>
References: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44591 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab0LCV6u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Dec 2010 16:58:50 -0500
In-Reply-To: <1291413524-15016-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_TPROXY.c |  193 ++++++++++++++++++++++++++++++++++++++-------
 1 files changed, 165 insertions(+), 28 deletions(-)

diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index cd0b50a..26419f5 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -5,6 +5,7 @@
  */
 #include <getopt.h>
 #include <stdbool.h>
+#include <stdint.h>
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
@@ -36,27 +37,39 @@ static void tproxy_tg_help(void)
 "  --tproxy-mark value[/mask]	    Mark packets with the given value/mask\n\n");
 }
 
-static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info)
+static void parse_tproxy_lport(const char *s, uint16_t *portp)
 {
 	unsigned int lport;
 
 	if (xtables_strtoui(s, NULL, &lport, 0, UINT16_MAX))
-		info->lport = htons(lport);
+		*portp = htons(lport);
 	else
 		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-port", s);
 }
 
-static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info)
+static void parse_tproxy_laddr(const char *s, union nf_inet_addr *addrp,
+			       unsigned int nfproto)
 {
-	struct in_addr *laddr;
+	struct in6_addr *laddr6 = NULL;
+	struct in_addr *laddr4 = NULL;
 
-	if ((laddr = xtables_numeric_to_ipaddr(s)) == NULL)
-		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-ip", s);
-
-	info->laddr = laddr->s_addr;
+	if (nfproto == NFPROTO_IPV6) {
+		laddr6 = xtables_numeric_to_ip6addr(s);
+		if (laddr6 == NULL)
+			goto out;
+		addrp->in6 = *laddr6;
+	} else if (nfproto == NFPROTO_IPV4) {
+		laddr4 = xtables_numeric_to_ipaddr(s);
+		if (laddr4 == NULL)
+			goto out;
+		addrp->in = *laddr4;
+	}
+	return;
+ out:
+	xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--on-ip", s);
 }
 
-static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
+static void parse_tproxy_mark(char *s, uint32_t *markp, uint32_t *maskp)
 {
 	unsigned int value, mask = UINT32_MAX;
 	char *end;
@@ -69,32 +82,32 @@ static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
 	if (*end != '\0')
 		xtables_param_act(XTF_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
 
-	info->mark_mask = mask;
-	info->mark_value = value;
+	*markp = value;
+	*maskp = mask;
 }
 
 static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 			const void *entry, struct xt_entry_target **target)
 {
-	struct xt_tproxy_target_info *tproxyinfo = (void *)(*target)->data;
+	struct xt_tproxy_target_info *info = (void *)(*target)->data;
 
 	switch (c) {
 	case '1':
 		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
-		parse_tproxy_lport(optarg, tproxyinfo);
+		parse_tproxy_lport(optarg, &info->lport);
 		*flags |= PARAM_ONPORT;
 		return 1;
 	case '2':
 		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
-		parse_tproxy_laddr(optarg, tproxyinfo);
+		parse_tproxy_laddr(optarg, (void *)&info->laddr, NFPROTO_IPV4);
 		*flags |= PARAM_ONIP;
 		return 1;
 	case '3':
 		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
 		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
-		parse_tproxy_mark(optarg, tproxyinfo);
+		parse_tproxy_mark(optarg, &info->mark_value, &info->mark_mask);
 		*flags |= PARAM_MARK;
 		return 1;
 	}
@@ -102,6 +115,49 @@ static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
 	return 0;
 }
 
+static int
+tproxy_tg_parse1(int c, char **argv, int invert, unsigned int *flags,
+		 struct xt_tproxy_target_info_v1 *info, unsigned int nfproto)
+{
+	switch (c) {
+	case '1':
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-port", invert);
+		parse_tproxy_lport(optarg, &info->lport);
+		*flags |= PARAM_ONPORT;
+		return true;
+	case '2':
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--on-ip", invert);
+		parse_tproxy_laddr(optarg, (void *)&info->laddr, nfproto);
+		*flags |= PARAM_ONIP;
+		return true;
+	case '3':
+		xtables_param_act(XTF_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
+		xtables_param_act(XTF_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
+		parse_tproxy_mark(optarg, &info->mark_value, &info->mark_mask);
+		*flags |= PARAM_MARK;
+		return true;
+	}
+	return false;
+}
+
+static int
+tproxy_tg_parse4(int c, char **argv, int invert, unsigned int *flags,
+		 const void *entry, struct xt_entry_target **target)
+{
+	struct xt_tproxy_target_info_v1 *info = (void *)(*target)->data;
+	return tproxy_tg_parse1(c, argv, invert, flags, info, NFPROTO_IPV4);
+}
+
+static int
+tproxy_tg_parse6(int c, char **argv, int invert, unsigned int *flags,
+		 const void *entry, struct xt_entry_target **target)
+{
+	struct xt_tproxy_target_info_v1 *info = (void *)(*target)->data;
+	return tproxy_tg_parse1(c, argv, invert, flags, info, NFPROTO_IPV6);
+}
+
 static void tproxy_tg_check(unsigned int flags)
 {
 	if (!(flags & PARAM_ONPORT))
@@ -119,6 +175,32 @@ static void tproxy_tg_print(const void *ip, const struct xt_entry_target *target
 	       (unsigned int)info->mark_mask);
 }
 
+static void
+tproxy_tg_print4(const void *ip, const struct xt_entry_target *target,
+		 int numeric)
+{
+	const struct xt_tproxy_target_info_v1 *info =
+		(const void *)target->data;
+
+	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
+	       xtables_ipaddr_to_numeric(&info->laddr.in),
+	       ntohs(info->lport), (unsigned int)info->mark_value,
+	       (unsigned int)info->mark_mask);
+}
+
+static void
+tproxy_tg_print6(const void *ip, const struct xt_entry_target *target,
+		 int numeric)
+{
+	const struct xt_tproxy_target_info_v1 *info =
+		(const void *)target->data;
+
+	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
+	       xtables_ip6addr_to_numeric(&info->laddr.in6),
+	       ntohs(info->lport), (unsigned int)info->mark_value,
+	       (unsigned int)info->mark_mask);
+}
+
 static void tproxy_tg_save(const void *ip, const struct xt_entry_target *target)
 {
 	const struct xt_tproxy_target_info *info = (const void *)target->data;
@@ -130,21 +212,76 @@ static void tproxy_tg_save(const void *ip, const struct xt_entry_target *target)
 	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
 }
 
-static struct xtables_target tproxy_tg_reg = {
-	.name	       = "TPROXY",
-	.family	       = NFPROTO_IPV4,
-	.version       = XTABLES_VERSION,
-	.size	       = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
-	.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
-	.help	       = tproxy_tg_help,
-	.parse	       = tproxy_tg_parse,
-	.final_check   = tproxy_tg_check,
-	.print	       = tproxy_tg_print,
-	.save	       = tproxy_tg_save,
-	.extra_opts    = tproxy_tg_opts,
+static void
+tproxy_tg_save4(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tproxy_target_info_v1 *info;
+
+	info = (const void *)target->data;
+	printf("--on-port %u ", ntohs(info->lport));
+	printf("--on-ip %s ", xtables_ipaddr_to_numeric(&info->laddr.in));
+	printf("--tproxy-mark 0x%x/0x%x ",
+	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
+}
+
+static void
+tproxy_tg_save6(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tproxy_target_info_v1 *info;
+
+	info = (const void *)target->data;
+	printf("--on-port %u ", ntohs(info->lport));
+	printf("--on-ip %s ", xtables_ip6addr_to_numeric(&info->laddr.in6));
+	printf("--tproxy-mark 0x%x/0x%x ",
+	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
+}
+
+static struct xtables_target tproxy_tg_reg[] = {
+	{
+		.name          = "TPROXY",
+		.revision      = 0,
+		.family        = NFPROTO_IPV4,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
+		.help          = tproxy_tg_help,
+		.parse         = tproxy_tg_parse,
+		.final_check   = tproxy_tg_check,
+		.print         = tproxy_tg_print,
+		.save          = tproxy_tg_save,
+		.extra_opts    = tproxy_tg_opts,
+	},
+	{
+		.name          = "TPROXY",
+		.revision      = 1,
+		.family        = NFPROTO_IPV4,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
+		.help          = tproxy_tg_help,
+		.parse         = tproxy_tg_parse4,
+		.final_check   = tproxy_tg_check,
+		.print         = tproxy_tg_print4,
+		.save          = tproxy_tg_save4,
+		.extra_opts    = tproxy_tg_opts,
+	},
+	{
+		.name          = "TPROXY",
+		.revision      = 1,
+		.family        = NFPROTO_IPV6,
+		.version       = XTABLES_VERSION,
+		.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info_v1)),
+		.help          = tproxy_tg_help,
+		.parse         = tproxy_tg_parse6,
+		.final_check   = tproxy_tg_check,
+		.print         = tproxy_tg_print6,
+		.save          = tproxy_tg_save6,
+		.extra_opts    = tproxy_tg_opts,
+	},
 };
 
 void _init(void)
 {
-	xtables_register_target(&tproxy_tg_reg);
+	xtables_register_targets(tproxy_tg_reg, ARRAY_SIZE(tproxy_tg_reg));
 }
-- 
1.7.1

