From: Colin Zeidler <czeidler@solananetworks.com>
Subject: [PATCH] iptables: add support for rmirror target
Date: Fri, 5 Jan 2018 16:10:01 -0500
Message-ID: <5fdf6dca-6ba6-f950-28a5-253f29a6ff74@solananetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail733.megamailservers.com ([69.49.98.43]:52216 "EHLO
        mail119c7.megamailservers.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750980AbeAEVkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jan 2018 16:40:06 -0500
Received: from [192.168.1.107] (69-196-152-194.dsl.teksavvy.com [69.196.152.194])
        (authenticated bits=0)
        by mail119c7.megamailservers.com (8.14.9/8.13.1) with ESMTP id w05LA1Zx015417
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <netfilter-devel@vger.kernel.org>; Fri, 5 Jan 2018 16:10:02 -0500
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds a new target to iptables called RMIRROR that duplicates packets and then
encapsulates the duplicate in a GRE transparent Ethernet packet before sending
it to a specified destination.

Signed-off-by: Colin Zeidler <czeidler@solananetworks.com>
---
 extensions/libxt_RMIRROR.c           | 95 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_RMIRROR.man         | 15 ++++++
 include/linux/netfilter/xt_RMIRROR.h | 16 ++++++
 3 files changed, 126 insertions(+)
 create mode 100644 extensions/libxt_RMIRROR.c
 create mode 100644 extensions/libxt_RMIRROR.man
 create mode 100644 include/linux/netfilter/xt_RMIRROR.h

diff --git a/extensions/libxt_RMIRROR.c b/extensions/libxt_RMIRROR.c
new file mode 100644
index 0000000..0fbad98
--- /dev/null
+++ b/extensions/libxt_RMIRROR.c
@@ -0,0 +1,95 @@
+/*
+ * Author Colin Zeidler <czeidler@solananetworks.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ */
+#include <sys/socket.h>
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include <arpa/inet.h>
+#include <net/if.h>
+#include <netinet/in.h>
+
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_RMIRROR.h>
+
+//#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))
+
+enum {
+	O_DST = 0,
+	O_LEN = 1,
+};
+
+#define s struct xt_rmirror_tginfo
+static const struct xt_option_entry rmirror_tg_opts[] = {
+	{.name = "target", .id = O_DST, .type = XTTYPE_HOST,
+	 .flags = XTOPT_MAND | XTOPT_PUT, XTOPT_POINTER(s, dst)},
+	{.name = "len", .id = O_LEN, .type = XTTYPE_UINT32,
+	 .flags = XTOPT_PUT, XTOPT_POINTER(s, len)},
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static void rmirror_tg_help(void)
+{
+	printf(
+"RMIRROR target options:\n"
+"  --target IPADDR   RMIRROR destination IP\n"
+"  --len BYTES       number of bytes to trim packet to, defaults to full packet\n"
+"       0 is equivilant to full length, Byte count is offset from end of GRE Header\n"
+"\n");
+}
+
+static void rmirror_tg_print(
+		const void *ip,
+		const struct xt_entry_target *target,
+		int numeric
+		)
+{
+	const struct xt_rmirror_tginfo *info = (const void *)target->data;
+
+	if (numeric)
+		printf(" RMIRROR target:%s", xtables_ipaddr_to_numeric(&info->dst.in));
+	else
+		printf(" RMIRROR target:%s", xtables_ipaddr_to_anyname(&info->dst.in));
+
+	if (info->len > 0)
+		printf(" len: %u", info->len);
+}
+
+static void rmirror_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_rmirror_tginfo *info = (const void *)target->data;
+
+	printf(" --target %s", xtables_ipaddr_to_numeric(&info->dst.in));
+	printf(" --len %u", info->len);
+}
+
+static struct xtables_target rmirror_tg_reg[] = {
+	{
+		.name = "RMIRROR",
+		.version = XTABLES_VERSION,
+		.revision = 0,
+		.family = NFPROTO_IPV4,
+		.size = XT_ALIGN(sizeof(struct xt_rmirror_tginfo)),
+		.userspacesize = XT_ALIGN(sizeof(struct xt_rmirror_tginfo)),
+		.help = rmirror_tg_help,
+		.print = rmirror_tg_print,
+		.save = rmirror_tg_save,
+		.x6_parse = xtables_option_parse,
+		.x6_options = rmirror_tg_opts,
+	},
+};
+
+void _init(void)
+{
+	xtables_register_targets(rmirror_tg_reg, ARRAY_SIZE(rmirror_tg_reg));
+}
diff --git a/extensions/libxt_RMIRROR.man b/extensions/libxt_RMIRROR.man
new file mode 100644
index 0000000..015404c
--- /dev/null
+++ b/extensions/libxt_RMIRROR.man
@@ -0,0 +1,15 @@
+The \fBRMIRROR\fP target will clone a packet and encapsulate the clone in a GRE
+transparent ethernet header, the encapsulated clone will then be sent to a
+destination machine.
+.TP
+\fB\-\-target\fp \fIipaddr\fp
+Send the new GRE encapsulated packet to the host reachable at the given IP
+address.
+.TP
+\fB\-\-len\fp \fIBytes\fp
+Trim the GRE packet down to \fIBytes\fp after the GRE header, total packet
+size will be 14 (MAC) + 20 (IP) + 4 (GRE) + \fIBytes\fp
+.PP
+To duplicate all local outgoing traffic to another system:
+.PP
+\-A OUTPUT \-j RMIRROR \-\-target 192.168.1.101
diff --git a/include/linux/netfilter/xt_RMIRROR.h b/include/linux/netfilter/xt_RMIRROR.h
new file mode 100644
index 0000000..479bf33
--- /dev/null
+++ b/include/linux/netfilter/xt_RMIRROR.h
@@ -0,0 +1,16 @@
+/*
+ * Author Colin Zeidler <czeidler@solananetworks.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * version 2, as published by the Free Software Foundation.
+ */
+#ifndef _LINUX_NETFILTER_XT_RMIRROR_H
+#define _LINUX_NETFILTER_XT_RMIRROR_H
+
+struct xt_rmirror_tginfo {
+	union nf_inet_addr dst;
+	unsigned int len;
+};
+
+#endif /* _LINUX_NETFILTER_XT_RMIRROR_H */
-- 
2.1.4
