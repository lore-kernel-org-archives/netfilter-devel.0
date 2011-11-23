From: kaber@trash.net
Subject: [PATCH 6/6] extensions: add IPv6 NETMAP extension
Date: Wed, 23 Nov 2011 17:12:30 +0100
Message-ID: <1322064750-26744-7-git-send-email-kaber@trash.net>
References: <1322064750-26744-1-git-send-email-kaber@trash.net>
Cc: kaber@trash.net, ulrich.weber@sophos.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55474 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752907Ab1KWQMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:12:38 -0500
In-Reply-To: <1322064750-26744-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 extensions/libip6t_NETMAP.c |   93 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 93 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libip6t_NETMAP.c

diff --git a/extensions/libip6t_NETMAP.c b/extensions/libip6t_NETMAP.c
new file mode 100644
index 0000000..d14dece
--- /dev/null
+++ b/extensions/libip6t_NETMAP.c
@@ -0,0 +1,93 @@
+/*
+ * Copyright (c) 2011 Patrick McHardy <kaber@trash.net>
+ *
+ * Based on Svenning Soerensen's IPv4 NETMAP target. Development of IPv6 NAT
+ * funded by Astaro.
+ */
+
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <libiptc/libip6tc.h>
+#include <linux/netfilter/nf_nat.h>
+
+#define MODULENAME "NETMAP"
+
+enum {
+	O_TO = 0,
+};
+
+static const struct xt_option_entry NETMAP_opts[] = {
+	{.name = "to", .id = O_TO, .type = XTTYPE_HOSTMASK,
+	 .flags = XTOPT_MAND},
+	XTOPT_TABLEEND,
+};
+
+static void NETMAP_help(void)
+{
+	printf(MODULENAME" target options:\n"
+	       "  --%s address[/mask]\n"
+	       "				Network address to map to.\n\n",
+	       NETMAP_opts[0].name);
+}
+
+static void NETMAP_parse(struct xt_option_call *cb)
+{
+	struct nf_nat_range *range = cb->data;
+	unsigned int i;
+
+	xtables_option_parse(cb);
+	range->flags |= NF_NAT_RANGE_MAP_IPS;
+	for (i = 0; i < 4; i++) {
+		range->min_addr.ip6[i] = cb->val.haddr.ip6[i] &
+					 cb->val.hmask.ip6[i];
+		range->max_addr.ip6[i] = range->min_addr.ip6[i] |
+					 ~cb->val.hmask.ip6[i];
+	}
+}
+
+static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
+{
+	const struct nf_nat_range *r = (const void *)target->data;
+	struct in6_addr a;
+	unsigned int i;
+	int bits;
+
+	a = r->min_addr.in6;
+	printf("%s", xtables_ip6addr_to_numeric(&a));
+	for (i = 0; i < 4; i++)
+		a.s6_addr32[i] = ~(r->min_addr.ip6[i] ^ r->max_addr.ip6[i]);
+	bits = ipv6_prefix_length(&a);
+	if (bits < 0)
+		printf("/%s", xtables_ip6addr_to_numeric(&a));
+	else
+		printf("/%d", bits);
+}
+
+static void NETMAP_save(const void *ip, const struct xt_entry_target *target)
+{
+	printf(" --%s ", NETMAP_opts[0].name);
+	NETMAP_print(ip, target, 0);
+}
+
+static struct xtables_target netmap_tg_reg = {
+	.name		= MODULENAME,
+	.version	= XTABLES_VERSION,
+	.family		= NFPROTO_IPV6,
+	.size		= XT_ALIGN(sizeof(struct nf_nat_range)),
+	.userspacesize	= XT_ALIGN(sizeof(struct nf_nat_range)),
+	.help		= NETMAP_help,
+	.x6_parse	= NETMAP_parse,
+	.print		= NETMAP_print,
+	.save		= NETMAP_save,
+	.x6_options	= NETMAP_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&netmap_tg_reg);
+}
-- 
1.7.1

