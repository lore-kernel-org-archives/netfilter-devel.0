From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Transparent Proxying Patches, Take 3 - userspace
Date: Sun, 30 Sep 2007 23:39:25 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709302330270.7130@fbirervta.pbzchgretzou.qr>
References: <200709302318.11465@nessa>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: KOVACS Krisztian <hidden@sch.bme.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46547 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013AbXI3Vj0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:39:26 -0400
In-Reply-To: <200709302318.11465@nessa>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 30 2007 23:18, KOVACS Krisztian wrote:
>Hi Patrick,
>
>Here is the patch adding iptables components of the 'socket' match
>and the 'TPROXY' target. The code is pretty straightforward and basic
>manual pages describing what the two modules do are included in the
>patch.

Hm, you asked me for my kernel patch, well you could have also asked 
for the iptables part :-p

Uses the kernel-level xt_TPROXY.

---
 extensions/.tproxy-testx     |    3 +
 extensions/libipt_TPROXY.man |   21 +++++++
 extensions/libipt_socket.man |    2 
 extensions/libxt_TPROXY.c    |  114 +++++++++++++++++++++++++++++++++++++++++++
 extensions/libxt_socket.c    |   48 ++++++++++++++++++
 5 files changed, 188 insertions(+)

Index: iptables/extensions/.tproxy-testx
===================================================================
--- /dev/null
+++ iptables/extensions/.tproxy-testx
@@ -0,0 +1,3 @@
+#!/bin/sh
+[ -f "$KERNEL_DIR/include/linux/netfilter/xt_TPROXY.h" ] && echo TPROXY;
+echo socket;
Index: iptables/extensions/libipt_TPROXY.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_TPROXY.man
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
Index: iptables/extensions/libipt_socket.man
===================================================================
--- /dev/null
+++ iptables/extensions/libipt_socket.man
@@ -0,0 +1,2 @@
+This matches if an open socket can be found by doing a socket lookup on the
+packet.
Index: iptables/extensions/libxt_TPROXY.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_TPROXY.c
@@ -0,0 +1,114 @@
+/* Shared library add-on to iptables to add TPROXY target support.
+ *
+ * Copyright (C) 2002-2007 BalaBit IT Ltd.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <iptables.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter/xt_TPROXY.h>
+
+static const struct option tproxy_opts[] = {
+	{"on-port", 1, NULL, '1'},
+	{"on-ip",   1, NULL, '2'},
+	{NULL},
+};
+
+static void tproxy_help(void)
+{
+	printf(
+"TPROXY target v%s options:\n"
+"  --on-port port                   Redirect connection to port, or the original port if 0\n"
+"  --on-ip ip                       Optionally redirect to the given IP\n",
+IPTABLES_VERSION);
+}
+
+static void parse_tproxy_lport(const char *s, struct xt_tproxy_info *info)
+{
+	unsigned int lport;
+
+	if (string_to_number(s, 0, 65535, &lport) != -1)
+	        info->lport = htons(lport);
+	else
+	        exit_error(PARAMETER_PROBLEM, "bad --on-proxy `%s'", s);
+}
+
+static void parse_tproxy_laddr(const char *s, struct xt_tproxy_info *info)
+{
+	struct in_addr *laddr;
+
+	if ((laddr = dotted_to_addr(s)) == NULL)
+	        exit_error(PARAMETER_PROBLEM, "bad --on-ip `%s'", s);
+ 	info->laddr = laddr->s_addr;
+}
+
+static int tproxy_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
+{
+	struct xt_tproxy_info *tproxyinfo = (void *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags != 0)
+			exit_error(PARAMETER_PROBLEM,
+				"TPROXY target: Can't specify --to-port twice");
+		parse_tproxy_lport(optarg, tproxyinfo);
+		*flags = 1;
+		break;
+	case '2':
+		parse_tproxy_laddr(optarg, tproxyinfo);
+		break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void tproxy_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "TPROXY target: Parameter --on-port is required");
+}
+
+static void tproxy_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
+{
+	const struct xt_tproxy_info *tproxyinfo = (const void *)target->data;
+	printf("TPROXY redirect %s:%d",
+	       addr_to_dotted((const struct in_addr *)&tproxyinfo->laddr),
+	       ntohs(tproxyinfo->lport));
+}
+
+static void tproxy_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tproxy_info *tproxyinfo = (const void *)target->data;
+
+	printf("--on-port %d ", ntohs(tproxyinfo->lport));
+	printf("--on-ip %s ",
+	       addr_to_dotted((const struct in_addr *)&tproxyinfo->laddr));
+}
+
+static struct xtables_target tproxy_reg = {
+	.name          = "TPROXY",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_tproxy_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_info)),
+	.help          = tproxy_help,
+	.parse         = tproxy_parse,
+	.final_check   = tproxy_check,
+	.print         = tproxy_print,
+	.save          = tproxy_save,
+	.extra_opts    = tproxy_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tproxy_reg);
+}
Index: iptables/extensions/libxt_socket.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_socket.c
@@ -0,0 +1,48 @@
+/* Shared library add-on to iptables to add early socket matching support. */
+#include <stdio.h>
+#include <getopt.h>
+#include <xtables.h>
+
+static void socket_print(const void *ip, const struct xt_entry_match *match,
+                         int numeric)
+{
+	printf("socket ");
+}
+
+static int socket_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_match **match)
+{
+	return 0;
+}
+
+static void socket_check(unsigned int flags)
+{
+}
+
+static struct xtables_match socket_reg = {
+	.name          = "socket",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(0),
+	.userspacesize = XT_ALIGN(0),
+	.parse         = socket_parse,
+	.final_check   = socket_check,
+	.print         = socket_print,
+};
+
+static struct xtables_match socket_reg6 = {
+	.name          = "socket",
+	.family        = AF_INET6,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(0),
+	.userspacesize = XT_ALIGN(0),
+	.parse         = socket_parse,
+	.final_check   = socket_check,
+	.print         = socket_print,
+};
+
+void _init(void)
+{
+	xtables_register_match(&socket_reg);
+	xtables_register_match(&socket_reg6);
+}
