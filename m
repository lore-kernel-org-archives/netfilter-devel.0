From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [17/19] libxt_iprange r1
Date: Wed, 16 Jan 2008 14:54:00 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161453370.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38606 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbYAPNyC (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:54:02 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for xt_iprange revision 1

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libxt_iprange.c |  223 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 222 insertions(+), 1 deletion(-)

Index: iptables-modules/extensions/libxt_iprange.c
===================================================================
--- iptables-modules.orig/extensions/libxt_iprange.c
+++ iptables-modules/extensions/libxt_iprange.c
@@ -5,9 +5,16 @@
 #include <stdlib.h>
 #include <getopt.h>
 
-#include <iptables.h>
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/xt_iprange.h>
 #include <linux/netfilter_ipv4/ipt_iprange.h>
 
+enum {
+	F_SRCIP = 1 << 0,
+	F_DSTIP = 1 << 1,
+};
+
 static void iprange_mt_help(void)
 {
 	printf(
@@ -91,6 +98,100 @@ static int iprange_parse(int c, char **a
 	return 1;
 }
 
+static int
+iprange_mt4_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
+{
+	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
+	const struct in_addr *ia;
+	char *end;
+
+	switch (c) {
+	case '1': /* --src-ip */
+		end = strchr(optarg, '-');
+		if (end == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+		*end = '\0';
+		ia = numeric_to_ipaddr(optarg);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+		memcpy(&info->src_min.in, ia, sizeof(*ia));
+		ia = numeric_to_ipaddr(end+1);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", end + 1);
+		memcpy(&info->src_max.in, ia, sizeof(*ia));
+		*flags |= F_SRCIP;
+		return true;
+
+	case '2': /* --dst-ip */
+		end = strchr(optarg, '-');
+		if (end == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+		*end = '\0';
+		ia = numeric_to_ipaddr(optarg);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+		memcpy(&info->dst_min.in, ia, sizeof(*ia));
+		ia = numeric_to_ipaddr(end + 1);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", end + 1);
+		memcpy(&info->dst_max.in, ia, sizeof(*ia));
+		*flags |= F_DSTIP;
+		return true;
+	}
+	return false;
+}
+
+static int
+iprange_mt6_parse(int c, char **argv, int invert, unsigned int *flags,
+                  const void *entry, struct xt_entry_match **match)
+{
+	struct xt_iprange_mtinfo *info = (void *)(*match)->data;
+	const struct in6_addr *ia;
+	char *end;
+
+	switch (c) {
+	case '1': /* --src-ip */
+		end = strchr(optarg, '-');
+		if (end == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+		*end = '\0';
+		ia = numeric_to_ip6addr(optarg);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", optarg);
+		memcpy(&info->src_min.in, ia, sizeof(*ia));
+		ia = numeric_to_ip6addr(end+1);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--src-ip", end + 1);
+		memcpy(&info->src_max.in, ia, sizeof(*ia));
+		info->flags |= IPRANGE_SRC;
+		if (invert)
+			info->flags |= IPRANGE_SRC_INV;
+		*flags |= F_SRCIP;
+		return true;
+
+	case '2': /* --dst-ip */
+		end = strchr(optarg, '-');
+		if (end == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+		*end = '\0';
+		ia = numeric_to_ip6addr(optarg);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", optarg);
+		memcpy(&info->dst_min.in, ia, sizeof(*ia));
+		ia = numeric_to_ip6addr(end + 1);
+		if (ia == NULL)
+			param_act(P_BAD_VALUE, "iprange", "--dst-ip", end + 1);
+		memcpy(&info->dst_max.in, ia, sizeof(*ia));
+		info->flags |= IPRANGE_DST;
+		if (invert)
+			info->flags |= IPRANGE_DST_INV;
+		*flags |= F_DSTIP;
+		return true;
+	}
+	return false;
+}
+
 static void iprange_mt_check(unsigned int flags)
 {
 	if (flags == 0)
@@ -129,6 +230,58 @@ static void iprange_print(const void *ip
 	}
 }
 
+static void
+iprange_mt4_print(const void *ip, const struct xt_entry_match *match,
+                  int numeric)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		printf("source IP range ");
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		/*
+		 * ipaddr_to_numeric() uses a static buffer, so cannot
+		 * combine the printf() calls.
+		 */
+		printf("%s", ipaddr_to_numeric(&info->src_min.in));
+		printf("-%s ", ipaddr_to_numeric(&info->src_max.in));
+	}
+	if (info->flags & IPRANGE_DST) {
+		printf("destination IP range ");
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		printf("%s", ipaddr_to_numeric(&info->dst_min.in));
+		printf("-%s ", ipaddr_to_numeric(&info->dst_max.in));
+	}
+}
+
+static void
+iprange_mt6_print(const void *ip, const struct xt_entry_match *match,
+                  int numeric)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		printf("source IP range ");
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		/*
+		 * ipaddr_to_numeric() uses a static buffer, so cannot
+		 * combine the printf() calls.
+		 */
+		printf("%s", ip6addr_to_numeric(&info->src_min.in6));
+		printf("-%s ", ip6addr_to_numeric(&info->src_max.in6));
+	}
+	if (info->flags & IPRANGE_DST) {
+		printf("destination IP range ");
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		printf("%s", ip6addr_to_numeric(&info->dst_min.in6));
+		printf("-%s ", ip6addr_to_numeric(&info->dst_max.in6));
+	}
+}
+
 static void iprange_save(const void *ip, const struct xt_entry_match *match)
 {
 	const struct ipt_iprange_info *info = (const void *)match->data;
@@ -149,6 +302,42 @@ static void iprange_save(const void *ip,
 	}
 }
 
+static void iprange_mt4_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		printf("--src-range %s", ipaddr_to_numeric(&info->src_min.in));
+		printf("-%s ", ipaddr_to_numeric(&info->src_max.in));
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		printf("--dst-range %s", ipaddr_to_numeric(&info->dst_min.in));
+		printf("-%s ", ipaddr_to_numeric(&info->dst_max.in));
+	}
+}
+
+static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_iprange_mtinfo *info = (const void *)match->data;
+
+	if (info->flags & IPRANGE_SRC) {
+		if (info->flags & IPRANGE_SRC_INV)
+			printf("! ");
+		printf("--src-range %s", ip6addr_to_numeric(&info->src_min.in6));
+		printf("-%s ", ip6addr_to_numeric(&info->src_max.in6));
+	}
+	if (info->flags & IPRANGE_DST) {
+		if (info->flags & IPRANGE_DST_INV)
+			printf("! ");
+		printf("--dst-range %s", ip6addr_to_numeric(&info->dst_min.in6));
+		printf("-%s ", ip6addr_to_numeric(&info->dst_max.in6));
+	}
+}
+
 static struct xtables_match iprange_match = {
 	.version       = IPTABLES_VERSION,
 	.name          = "iprange",
@@ -164,7 +353,39 @@ static struct xtables_match iprange_matc
 	.extra_opts    = iprange_mt_opts,
 };
 
+static struct xtables_match iprange_mt_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "iprange",
+	.revision       = 1,
+	.family         = AF_INET,
+	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+	.help           = iprange_mt_help,
+	.parse          = iprange_mt4_parse,
+	.final_check    = iprange_mt_check,
+	.print          = iprange_mt4_print,
+	.save           = iprange_mt4_save,
+	.extra_opts     = iprange_mt_opts,
+};
+
+static struct xtables_match iprange_mt6_reg = {
+	.version        = IPTABLES_VERSION,
+	.name           = "iprange",
+	.revision       = 1,
+	.family         = AF_INET6,
+	.size           = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+	.userspacesize  = XT_ALIGN(sizeof(struct xt_iprange_mtinfo)),
+	.help           = iprange_mt_help,
+	.parse          = iprange_mt6_parse,
+	.final_check    = iprange_mt_check,
+	.print          = iprange_mt6_print,
+	.save           = iprange_mt6_save,
+	.extra_opts     = iprange_mt_opts,
+};
+
 void _init(void)
 {
 	xtables_register_match(&iprange_match);
+	xtables_register_match(&iprange_mt_reg);
+	xtables_register_match(&iprange_mt6_reg);
 }
