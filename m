From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH] iptables: PKTTYPE target support
Date: Wed, 28 Jan 2009 16:05:00 +0100
Message-ID: <20090128150459.7933.35154.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58681 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752311AbZA1PFI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Jan 2009 10:05:08 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds support for the PKTTYPE target to iptables.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---

 extensions/libxt_PKTTYPE.c           |  113 ++++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_PKTTYPE.h |    8 ++
 2 files changed, 121 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_PKTTYPE.c
 create mode 100644 include/linux/netfilter/xt_PKTTYPE.h

diff --git a/extensions/libxt_PKTTYPE.c b/extensions/libxt_PKTTYPE.c
new file mode 100644
index 0000000..878897d
--- /dev/null
+++ b/extensions/libxt_PKTTYPE.c
@@ -0,0 +1,113 @@
+/*
+ * (C) 2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#if defined(__GLIBC__) && __GLIBC__ == 2
+#include <net/ethernet.h>
+#else
+#include <linux/if_ether.h>
+#endif
+#include <xtables.h>
+#include <linux/if_packet.h>
+#include <linux/netfilter/xt_PKTTYPE.h>
+
+static void
+pkttype_help(void)
+{
+	printf(
+"PKTTYPE target options:\n"
+"  --to-pkt-type packettype		new packet type\n"
+"Valid packet types:\n"
+"	unicast			to us\n");
+}
+
+enum {
+	PKTTYPE_OPT_PKTTYPE,
+};
+
+static const struct option pkttype_opts[] = {
+	{ "to-pkt-type", 	1, NULL, PKTTYPE_OPT_PKTTYPE },
+	{ .name = NULL }
+};
+
+static int 
+pkttype_parse(int c, char **argv, int invert, unsigned int *flags,
+	      const void *entry, struct xt_entry_target **target)
+{
+	struct xt_pkttype_target_info *info = (void *)(*target)->data;
+
+	switch (c) {
+	case PKTTYPE_OPT_PKTTYPE:
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "Can only specify `--to-pkttype' once");
+
+		if (strncmp(optarg, "unicast", strlen("unicast")) != 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "Unknown packet type `%s'", optarg);
+
+		info->pkt_type = PACKET_HOST;
+		*flags |= 1 << c;
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+pkttype_check(unsigned int flags)
+{
+	if ((flags & ((1 << PKTTYPE_OPT_PKTTYPE)))
+		== ((1 << PKTTYPE_OPT_PKTTYPE))) {
+		return;
+	}
+
+	exit_error(PARAMETER_PROBLEM,
+		   "PKTTYPE target: Invalid parameter combination");
+}
+
+static void
+pkttype_print(const void *ip, const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_pkttype_target_info *info = (void *)target->data;
+
+	printf("PKTTYPE to-pkt-type=%s",
+		info->pkt_type == PACKET_HOST ? "unicast" : "unknown");
+}
+
+static void
+pkttype_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_pkttype_target_info *info = (void *)target->data;
+
+	printf("--to-pkt-type %s", 
+		info->pkt_type == PACKET_HOST ? "unicast" : "unknown");
+}
+
+static struct xtables_target pkttype_tg_reg = {
+	.family		= AF_UNSPEC,
+	.name		= "PKTTYPE",
+	.version	= XTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_pkttype_target_info)),
+ 	.help		= pkttype_help,
+	.parse		= pkttype_parse,
+	.final_check	= pkttype_check,
+	.print		= pkttype_print,
+	.save		= pkttype_save,
+	.extra_opts	= pkttype_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&pkttype_tg_reg);
+}
diff --git a/include/linux/netfilter/xt_PKTTYPE.h b/include/linux/netfilter/xt_PKTTYPE.h
new file mode 100644
index 0000000..cc67cbf
--- /dev/null
+++ b/include/linux/netfilter/xt_PKTTYPE.h
@@ -0,0 +1,8 @@
+#ifndef _XT_PKTTYPE_TARGET_H
+#define _XT_PKTTYPE_TARGET_H
+
+struct xt_pkttype_target_info {
+	u_int8_t pkt_type;
+};
+
+#endif /* _XT_PKTTYPE_TARGET_H */

