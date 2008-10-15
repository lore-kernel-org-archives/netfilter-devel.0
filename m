From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [iptables PATCH 1/2] Add iptables support for the TPROXY target
Date: Wed, 15 Oct 2008 10:10:14 +0200
Message-ID: <200810151010.15083@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from balu.sch.bme.hu ([152.66.208.40]:40030 "EHLO balu.sch.bme.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbYJOIKV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 04:10:21 -0400
Received: from nessa.odu ([89.132.101.55])
 by balu.sch.bme.hu (Sun Java System Messaging Server 6.2-7.05 (built Sep  5
 2006)) with ESMTPSA id <0K8R00AOLTBXY370@balu.sch.bme.hu> for
 netfilter-devel@vger.kernel.org; Wed, 15 Oct 2008 10:09:37 +0200 (CEST)
Content-disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add user-space code for the TPROXY target.

Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
---

 extensions/libxt_TPROXY.c           |  151 +++++++++++++++++++++++++++++++++++
 extensions/libxt_TPROXY.man         |   21 +++++
 include/linux/netfilter/xt_TPROXY.h |   14 +++
 3 files changed, 186 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libxt_TPROXY.c
 create mode 100644 extensions/libxt_TPROXY.man
 create mode 100644 include/linux/netfilter/xt_TPROXY.h


diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
new file mode 100644
index 0000000..0f910f4
--- /dev/null
+++ b/extensions/libxt_TPROXY.c
@@ -0,0 +1,151 @@
+/*
+ * Shared library add-on to iptables to add TPROXY target support.
+ *
+ * Copyright (C) 2002-2008 BalaBit IT Ltd.
+ */
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <limits.h>
+
+#include <iptables.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TPROXY.h>
+
+static const struct option tproxy_tg_opts[] = {
+	{ .name = "on-port", .has_arg = 1, .val = '1'},
+	{ .name = "on-ip", .has_arg = 1, .val = '2'},
+	{ .name = "tproxy-mark", .has_arg = 1, .val = '3'},
+	{NULL},
+};
+
+enum {
+	PARAM_ONPORT = 1 << 0,
+	PARAM_ONIP = 1 << 1,
+	PARAM_MARK = 1 << 2,
+};
+
+static void tproxy_tg_help(void)
+{
+	printf(
+"TPROXY target options:\n"
+"  --on-port port		    Redirect connection to port, or the original port if 0\n"
+"  --on-ip ip			    Optionally redirect to the given IP\n"
+"  --tproxy-mark value[/mask]	    Mark packets with the given value/mask\n\n");
+}
+
+static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info)
+{
+	unsigned int lport;
+
+	if (string_to_number(s, 0, 65535, &lport) != -1)
+		info->lport = htons(lport);
+	else
+		param_act(P_BAD_VALUE, "TPROXY", "--on-port", s);
+}
+
+static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info)
+{
+	struct in_addr *laddr;
+
+	if ((laddr = numeric_to_ipaddr(s)) == NULL)
+		param_act(P_BAD_VALUE, "TPROXY", "--on-ip", s);
+
+	info->laddr = laddr->s_addr;
+}
+
+static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
+{
+	unsigned int value, mask = ~0U;
+	char *end;
+
+	if (!strtonum(s, &end, &value, 0, UINT_MAX))
+		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+	if (*end == '/')
+		if (!strtonum(end + 1, &end, &mask, 0, UINT_MAX))
+			param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+	if (*end != '\0')
+		param_act(P_BAD_VALUE, "TPROXY", "--tproxy-mark", s);
+
+	info->mark_mask = mask;
+	info->mark_value = value;
+}
+
+static int tproxy_tg_parse(int c, char **argv, int invert, unsigned int *flags,
+			const void *entry, struct xt_entry_target **target)
+{
+	struct xt_tproxy_target_info *tproxyinfo = (void *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		param_act(P_ONLY_ONCE, "TPROXY", "--on-port", *flags & PARAM_ONPORT);
+		param_act(P_NO_INVERT, "TPROXY", "--on-port", invert);
+		parse_tproxy_lport(optarg, tproxyinfo);
+		*flags |= PARAM_ONPORT;
+		return 1;
+	case '2':
+		param_act(P_ONLY_ONCE, "TPROXY", "--on-ip", *flags & PARAM_ONIP);
+		param_act(P_NO_INVERT, "TPROXY", "--on-ip", invert);
+		parse_tproxy_laddr(optarg, tproxyinfo);
+		*flags |= PARAM_ONIP;
+		return 1;
+	case '3':
+		param_act(P_ONLY_ONCE, "TPROXY", "--tproxy-mark", *flags & PARAM_MARK);
+		param_act(P_NO_INVERT, "TPROXY", "--tproxy-mark", invert);
+		parse_tproxy_mark(optarg, tproxyinfo);
+		*flags |= PARAM_MARK;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void tproxy_tg_check(unsigned int flags)
+{
+	if (!(flags & PARAM_ONPORT))
+		exit_error(PARAMETER_PROBLEM,
+			   "TPROXY target: Parameter --on-port is required");
+}
+
+static void tproxy_tg_print(const void *ip, const struct xt_entry_target *target,
+			 int numeric)
+{
+	const struct xt_tproxy_target_info *info = (const void *)target->data;
+	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
+	       ipaddr_to_numeric((const struct in_addr *)&info->laddr),
+	       ntohs(info->lport), (unsigned int)info->mark_value,
+	       (unsigned int)info->mark_mask);
+}
+
+static void tproxy_tg_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tproxy_target_info *info = (const void *)target->data;
+
+	printf("--on-port %u ", ntohs(info->lport));
+	printf("--on-ip %s ",
+	       ipaddr_to_numeric((const struct in_addr *)&info->laddr));
+	printf("--tproxy-mark 0x%x/0x%x ",
+	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
+}
+
+static struct xtables_target tproxy_tg_reg = {
+	.name	       = "TPROXY",
+	.family	       = AF_INET,
+	.version       = XTABLES_VERSION,
+	.size	       = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
+	.help	       = tproxy_tg_help,
+	.parse	       = tproxy_tg_parse,
+	.final_check   = tproxy_tg_check,
+	.print	       = tproxy_tg_print,
+	.save	       = tproxy_tg_save,
+	.extra_opts    = tproxy_tg_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tproxy_tg_reg);
+}
diff --git a/extensions/libxt_TPROXY.man b/extensions/libxt_TPROXY.man
new file mode 100644
index 0000000..f17848c
--- /dev/null
+++ b/extensions/libxt_TPROXY.man
@@ -0,0 +1,21 @@
+This target is only valid in the \fBmangle\fR table, in the \fBPREROUTING\fR
+chain and user-defined chains which are only called from this chain. It
+redirects the packet to a local socket without changing the packet header in
+any way. It can also change the mark value which can then be used in advanced
+routing rules.
+It takes three options:
+.TP
+\fB--on-port\fR \fIport\fR
+This specifies a destination port to use. It is a required option, 0 means the
+new destination port is the same as the original. This is only valid if the
+rule also specifies \fB-p tcp\fR or \fB-p udp\fR.
+.TP
+\fB--on-ip\fR \fIaddress\fR
+This specifies a destination address to use. By default the address is the IP
+address of the incoming interface. This is only valid if the rule also
+specifies \fB-p tcp\fR or \fR-p udp\fR.
+.TP
+\fB--tproxy-mark\fR \fIvalue\fR[\fB/\fR\fImask\fR]
+Marks packets with the given value/mask. The fwmark value set here can be used
+by advanced routing. (Required for transparent proxying to work: otherwise
+these packets will get forwarded, which is probably not what you want.)
diff --git a/include/linux/netfilter/xt_TPROXY.h b/include/linux/netfilter/xt_TPROXY.h
new file mode 100644
index 0000000..152e8f9
--- /dev/null
+++ b/include/linux/netfilter/xt_TPROXY.h
@@ -0,0 +1,14 @@
+#ifndef _XT_TPROXY_H_target
+#define _XT_TPROXY_H_target
+
+/* TPROXY target is capable of marking the packet to perform
+ * redirection. We can get rid of that whenever we get support for
+ * mutliple targets in the same rule. */
+struct xt_tproxy_target_info {
+	u_int32_t mark_mask;
+	u_int32_t mark_value;
+	__be32 laddr;
+	__be16 lport;
+};
+
+#endif /* _XT_TPROXY_H_target */
