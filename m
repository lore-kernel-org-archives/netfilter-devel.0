From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: [PATCH] Transparent Proxying Patches, Take 3 - userspace
Date: Sun, 30 Sep 2007 23:18:11 +0200
Message-ID: <200709302318.11465@nessa>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from centaur.sch.bme.hu ([152.66.208.5]:38962 "EHLO
	centaur.sch.bme.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbXI3VSJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 30 Sep 2007 17:18:09 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Here is the patch adding iptables components of the 'socket' match
and the 'TPROXY' target. The code is pretty straightforward and basic
manual pages describing what the two modules do are included in the
patch.

The patch should apply cleanly to current SVN.

---
 .socket-testx     |    2
 .tproxy-test      |    2
 libipt_TPROXY.c   |  143 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 libipt_TPROXY.man |   32 ++++++++++++
 libipt_socket.man |    1
 libxt_socket.c    |   58 +++++++++++++++++++++
 6 files changed, 238 insertions(+)

Index: iptables/extensions/libipt_TPROXY.man
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libipt_TPROXY.man	2007-09-30 18:23:07.000000000 +0200
@@ -0,0 +1,32 @@
+This target is only valid in the
+.B mangle
+table, in the
+.B PREROUTING
+chain, and user-defined chains which are only called from that chain. It
+redirects the packet to a local socket without changing the packet header in
+any way. It can also change the mark value which can then be used in advanced
+routing rules.
+It takes three options:
+.TP
+.BR "--on-port " "\fIport\fP"
+This specifies a destination port to use. It is a required option, 0
+means the new destination port is the same as the original. This is
+only valid if the rule also specifies
+.B "-p tcp"
+or
+.BR "-p udp" .
+.TP
+.BR "--on-ip " "\fIaddress\fP"
+This specifies a destination address to use. By default the address is
+the IP address of the incoming interface. This is only valid if the
+rule also specifies
+.B "-p tcp"
+or
+.BR "-p udp" .
+.TP
+.BR "--tproxy-mark " "\fIvalue[/mask]\fP"
+Marks packets with the given value/mask. The fwmark value set here can be used
+by advanced routing. (Required for transparent proxying to work: otherwise
+these packets will get forwarded, which is probably not what you want.)
+.RS
+.PP
Index: iptables/extensions/libipt_TPROXY.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libipt_TPROXY.c	2007-09-30 21:04:11.000000000 +0200
@@ -0,0 +1,143 @@
+/* Shared library add-on to iptables to add TPROXY target support.
+ *
+ * Copyright (C) 2002-2007 BalaBit IT Ltd.
+ */
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <limits.h>
+
+#include <iptables.h>
+#include <xtables.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_TPROXY.h>
+
+static const struct option tproxy_opts[] = {
+	{"on-port", 1, NULL, '1'},
+	{"on-ip", 1, NULL, '2'},
+	{"tproxy-mark", 1, NULL, '3'},
+	{NULL},
+};
+
+#define PARAM_ONPORT	1
+#define PARAM_ONIP	2
+#define PARAM_MARK	4
+
+static void tproxy_help(void)
+{
+	printf(
+"TPROXY target v%s options:\n"
+"  --on-port port                   Redirect connection to port, or the original port if 0\n"
+"  --on-ip ip                       Optionally redirect to the given IP\n"
+"  --tproxy-mark value/mask         Mark packets with the given value/mask\n",
+IPTABLES_VERSION);
+}
+
+static void parse_tproxy_lport(const char *s, struct ipt_tproxy_target_info *info)
+{
+	unsigned int lport;
+
+	if (string_to_number(s, 0, 65535, &lport) != -1)
+	        info->lport = htons(lport);
+	else
+	        exit_error(PARAMETER_PROBLEM, "bad --on-port `%s'", s);
+}
+
+static void parse_tproxy_laddr(const char *s, struct ipt_tproxy_target_info *info)
+{
+	struct in_addr *laddr;
+
+	if ((laddr = dotted_to_addr(s)) == NULL)
+	        exit_error(PARAMETER_PROBLEM, "bad --on-ip `%s'", s);
+ 	info->laddr = laddr->s_addr;
+}
+
+static void parse_tproxy_mark(char *s, struct ipt_tproxy_target_info *info)
+{
+        char *slash;
+
+        slash = strchr(s, '/');
+        info->mark_mask = ULONG_MAX;
+        if (slash) {
+        	if (string_to_number_l(slash + 1, 0, ULONG_MAX, &info->mark_mask) < 0)
+        		exit_error(PARAMETER_PROBLEM, "bad mask in --tproxy-mark `%s'", s);
+		*slash = 0;
+        }
+        if (string_to_number_l(s, 0, ULONG_MAX, &info->mark_value) < 0)
+        	exit_error(PARAMETER_PROBLEM, "bad value in --tproxy-mark `%s'", s);
+}
+
+static int tproxy_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
+{
+	struct ipt_tproxy_target_info *tproxyinfo = (void *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags != 0)
+			exit_error(PARAMETER_PROBLEM,
+				"TPROXY target: Can't specify --on-port twice");
+		parse_tproxy_lport(optarg, tproxyinfo);
+		*flags |= PARAM_ONPORT;
+		break;
+	case '2':
+		parse_tproxy_laddr(optarg, tproxyinfo);
+		*flags |= PARAM_ONIP;
+		break;
+        case '3':
+                parse_tproxy_mark(optarg, tproxyinfo);
+		*flags |= PARAM_MARK;
+                break;
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void tproxy_check(unsigned int flags)
+{
+	if (!(flags & PARAM_ONPORT))
+		exit_error(PARAMETER_PROBLEM,
+		           "TPROXY target: Parameter --on-port is required");
+}
+
+static void tproxy_print(const void *ip, const struct xt_entry_target *target,
+                         int numeric)
+{
+	const struct ipt_tproxy_target_info *tproxyinfo = (const void *)target->data;
+	printf("TPROXY redirect %s:%d mark 0x%lx/0x%lx",
+	       addr_to_dotted((const struct in_addr *)&tproxyinfo->laddr),
+	       ntohs(tproxyinfo->lport), tproxyinfo->mark_value, tproxyinfo->mark_mask);
+}
+
+static void tproxy_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct ipt_tproxy_target_info *tproxyinfo = (const void *)target->data;
+
+	printf("--on-port %d ", ntohs(tproxyinfo->lport));
+	printf("--on-ip %s ",
+	       addr_to_dotted((const struct in_addr *)&tproxyinfo->laddr));
+	printf("--tproxy-mark 0x%lx/0x%lx ",
+	       tproxyinfo->mark_value, tproxyinfo->mark_mask);
+}
+
+static struct xtables_target tproxy_reg = {
+	.name          = "TPROXY",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct ipt_tproxy_target_info)),
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
Index: iptables/extensions/.tproxy-test
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/.tproxy-test	2007-09-30 21:03:20.000000000 +0200
@@ -0,0 +1,2 @@
+#!/bin/sh
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_TPROXY.h ] && echo TPROXY
Index: iptables/extensions/libipt_socket.man
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libipt_socket.man	2007-09-30 20:21:59.000000000 +0200
@@ -0,0 +1 @@
+This matches if an open socket can be found by doing a socket lookup on the packet.
Index: iptables/extensions/.socket-testx
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/.socket-testx	2007-09-30 20:25:52.000000000 +0200
@@ -0,0 +1,2 @@
+#!/bin/sh
+echo socket
Index: iptables/extensions/libxt_socket.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libxt_socket.c	2007-09-30 20:19:11.000000000 +0200
@@ -0,0 +1,58 @@
+/* Shared library add-on to iptables to add early socket matching support.
+ *
+ * Copyright (C) 2007 BalaBit IT Ltd.
+ */
+#include <stdio.h>
+#include <getopt.h>
+
+#include <iptables.h>
+
+static struct option opts[] = {
+	{ 0 }
+};
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf("socket v%s has no options\n", IPTABLES_VERSION);
+}
+
+static void
+print(const void *ip,
+      const struct xt_entry_match *match,
+      int numeric)
+{
+	printf("socket ");
+}
+
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry, struct xt_entry_match **match)
+{
+	return 0;
+}
+
+static void
+final_check(unsigned int flags)
+{
+}
+
+static struct xtables_match socket_match = {
+	.name		= "socket",
+	.family		= AF_INET,
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(0),
+	.userspacesize	= IPT_ALIGN(0),
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.help		= &help,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&socket_match);
+}


-- 
 KOVACS Krisztian
