From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: [PATCH 1/2] iptables (userspace): add secmark match
Date: Tue, 05 Mar 2013 12:48:47 +0000
Message-ID: <5135E9AF.6010800@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Fedora SELinux Users <selinux@lists.fedoraproject.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:58282 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3CEMs5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Mar 2013 07:48:57 -0500
Received: by mail-wg0-f41.google.com with SMTP id ds1so2911518wgb.4
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Mar 2013 04:48:56 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch is part of the userspace changes needed for the "secmark" match
in iptables.

Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
---
  extensions/libxt_secmark.c           |  100 ++++++++++++++++++++++++++++++++++
  extensions/libxt_secmark.man         |   22 ++++++++
  include/linux/netfilter/xt_secmark.h |   24 ++++++++
  3 files changed, 146 insertions(+)
  create mode 100644 extensions/libxt_secmark.c
  create mode 100644 extensions/libxt_secmark.man
  create mode 100644 include/linux/netfilter/xt_secmark.h

diff --git a/extensions/libxt_secmark.c b/extensions/libxt_secmark.c
new file mode 100644
index 0000000..92ecc6b
--- /dev/null
+++ b/extensions/libxt_secmark.c
@@ -0,0 +1,100 @@
+/*
+ * Shared library add-on to iptables to add secmark match support.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 (or
+ * any later at your option) as published by the Free Software Foundation.
+ */
+#include <stdbool.h>
+#include <stdlib.h>
+#include <stdio.h>
+#include <string.h>
+#include <getopt.h>
+#include <xtables.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_secmark.h>
+
+#define PFX "secmark match: "
+
+enum {
+	O_SELCTX = 0,
+};
+
+#define s struct xt_secmark_match_info
+static const struct xt_option_entry secmark_opts[] = {
+	{.name = "selctx", .id = O_SELCTX, .type = XTTYPE_STRING,
+	 .flags = XTOPT_MAND|XTOPT_PUT, XTOPT_POINTER(s, secctx)},
+	XTOPT_TABLEEND,
+};
+#undef s
+
+static void secmark_help(void)
+{
+	printf("secmark match options:\n"
+	       " --selctx STRING              SELinux security context\n");
+}
+
+static void secmark_parse(struct xt_option_call *cb)
+{
+	struct xt_secmark_match_info *info = cb->data;
+
+	xtables_option_parse(cb);
+	switch (cb->entry->id) {
+	case O_SELCTX:
+		if (strchr(cb->arg, '\n') != NULL)
+			xtables_error(PARAMETER_PROBLEM, PFX
+				     "new lines not allowed in --selctx");
+		info->mode = SECMARK_MODE_SEL;
+		break;
+	}
+}
+
+static void
+secmark_print_selctx(const struct xt_secmark_match_info *info, char *str)
+{
+	switch (info->mode) {
+	case SECMARK_MODE_SEL:
+		printf(" %sselctx %s", str, info->secctx);
+		break;
+	
+	default:
+		xtables_error(OTHER_PROBLEM, PFX "invalid mode %hhu\n", info->mode);
+	}
+}
+
+static void secmark_print(const void *ip, const struct xt_entry_match *match,
+                        int numeric)
+{
+	const struct xt_secmark_match_info *info =
+		(struct xt_secmark_match_info *)match->data;
+
+	secmark_print_selctx(info, "");
+}
+
+static void secmark_save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_secmark_match_info *info =
+		(struct xt_secmark_match_info *)match->data;
+
+	secmark_print_selctx(info, "--");
+}
+
+static struct xtables_match secmark_match = {
+	.family		= NFPROTO_UNSPEC,
+	.name		= "secmark",
+	.version	= XTABLES_VERSION,
+	.revision	= 0,
+	.size		= XT_ALIGN(sizeof(struct xt_secmark_match_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_secmark_match_info)),
+	.help		= secmark_help,
+	.print		= secmark_print,
+	.save		= secmark_save,
+	.x6_parse	= secmark_parse,
+	.x6_options	= secmark_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&secmark_match);
+}
diff --git a/extensions/libxt_secmark.man b/extensions/libxt_secmark.man
new file mode 100644
index 0000000..b38e32c
--- /dev/null
+++ b/extensions/libxt_secmark.man
@@ -0,0 +1,22 @@
+The secmark match is used to match the security mark value
+associated with a packet.
+.PP
+Only one option is available with this match which needs
+to be specified:
+.TP
+\fB\-\-selctx\fP \fIselctx\fP
+This option selects the SELinux security context (\fBselctx\fP) to
+be used for packet matching. This security context needs to have already
+been assigned to a packet by using the \fBSECMARK\fP target.
+.PP
+For this extension to be used, the appropriate SELinux support needs
+to be installed and present in the Linux kernel.
+.PP
+Examples:
+.IP
+iptables \-I INPUT \-p icmp \-\-icmp-type 3 \-m secmark \-\-selctx
+system_u:object_r:dns_packet_t:s0 \-j ACCEPT
+.IP
+iptables \-I OUTPUT \-m secmark \-\-selctx
+system_u:object_r:ssh_packet_t:s0 \-j DROP
+
diff --git a/include/linux/netfilter/xt_secmark.h b/include/linux/netfilter/xt_secmark.h
new file mode 100644
index 0000000..c74a35d
--- /dev/null
+++ b/include/linux/netfilter/xt_secmark.h
@@ -0,0 +1,24 @@
+#ifndef _XT_SECMARK_MATCH_H
+#define _XT_SECMARK_MATCH_H
+
+#include <linux/types.h>
+
+/*
+ * Header file for iptables xt_secmark match
+ *
+ * This is intended for use by various security subsystems (but not
+ * at the same time).
+ *
+ * 'mode' refers to the specific security subsystem which the
+ * packets are being marked for.
+ */
+#define SECMARK_MODE_SEL	0x01		/* SELinux */
+#define SECMARK_SECCTX_MAX	256
+
+struct xt_secmark_match_info {
+	__u8 mode;
+	__u32 secid;
+	char secctx[SECMARK_SECCTX_MAX];
+};
+
+#endif /* _XT_SECMARK_MATCH_H */




