From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Transparent proxy patches, take 4 - userspace
Date: Tue, 2 Oct 2007 22:37:56 +0200
Message-ID: <200710022237.56478@nessa>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Balazs Scheidler <bazsi@balabit.hu>,
	Toth Laszlo Attila <panther@balabit.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:2382 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXJBUiA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 16:38:00 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

Here is the current version of the iptables (userspace) tproxy patch.
After the last round Jan Engelhardt provided all kinds of cleanups and
fixes, this is basically based on his work. Thanks a lot, Jan.

Should apply cleanly on top of current SVN.

---
 extensions/Makefile                 |    2
 extensions/libipt_TPROXY.man        |   21 ++++
 extensions/libipt_socket.man        |    2
 extensions/libxt_TPROXY.c           |  155 ++++++++++++++++++++++++++++++++++++
 extensions/libxt_socket.c           |   39 +++++++++
 include/linux/netfilter/xt_TPROXY.h |   16 +++
 6 files changed, 234 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile	2007-10-01 23:46:19.000000000 +0200
+++ iptables/extensions/Makefile	2007-10-01 23:46:26.000000000 +0200
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp socket state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TPROXY TRACE
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
Index: iptables/extensions/libipt_TPROXY.man
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libipt_TPROXY.man	2007-10-01 23:46:26.000000000 +0200
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
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libipt_socket.man	2007-10-01 23:46:26.000000000 +0200
@@ -0,0 +1,2 @@
+This matches if an open socket can be found by doing a socket lookup on the
+packet.
Index: iptables/extensions/libxt_TPROXY.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libxt_TPROXY.c	2007-10-02 22:03:55.000000000 +0200
@@ -0,0 +1,155 @@
+/*
+ * Shared library add-on to iptables to add TPROXY target support.
+ *
+ * Copyright (C) 2002-2007 BalaBit IT Ltd.
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
+static const struct option tproxy_opts[] = {
+	{"on-port",     true, NULL, '1'},
+	{"on-ip",       true, NULL, '2'},
+	{"tproxy-mark", true, NULL, '3'},
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
+"  --tproxy-mark value/mask         Mark packets with the given value/mask\n\n",
+IPTABLES_VERSION);
+}
+
+static void parse_tproxy_lport(const char *s, struct xt_tproxy_target_info *info)
+{
+	unsigned int lport;
+
+	if (string_to_number(s, 0, 65535, &lport) != -1)
+		info->lport = htons(lport);
+	else
+		exit_error(PARAMETER_PROBLEM, "bad --on-port \"%s\"", s);
+}
+
+static void parse_tproxy_laddr(const char *s, struct xt_tproxy_target_info *info)
+{
+	struct in_addr *laddr;
+
+	if ((laddr = dotted_to_addr(s)) == NULL)
+		exit_error(PARAMETER_PROBLEM, "bad --on-ip \"%s\"", s);
+	info->laddr = laddr->s_addr;
+}
+
+static void parse_tproxy_mark(char *s, struct xt_tproxy_target_info *info)
+{
+	unsigned long tmp;
+	char *slash;
+
+	slash = strchr(s, '/');
+	info->mark_mask = ULONG_MAX;
+	if (slash != NULL) {
+		*slash = '\0';
+		if (string_to_number_l(slash + 1, 0, ULONG_MAX, &tmp) < 0)
+			exit_error(PARAMETER_PROBLEM,
+			           "bad mask in --tproxy-mark \"%s\"", s);
+		info->mark_mask = tmp;
+	}
+	if (string_to_number_l(s, 0, ULONG_MAX, &tmp) < 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "bad value in --tproxy-mark \"%s\"", s);
+	info->mark_value = tmp;
+}
+
+static int tproxy_parse(int c, char **argv, int invert, unsigned int *flags,
+                        const void *entry, struct xt_entry_target **target)
+{
+	struct xt_tproxy_target_info *tproxyinfo = (void *)(*target)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & PARAM_ONPORT)
+			exit_error(PARAMETER_PROBLEM,
+				"TPROXY target: Can't specify --on-port twice");
+		parse_tproxy_lport(optarg, tproxyinfo);
+		*flags |= PARAM_ONPORT;
+		return 1;
+	case '2':
+		if (*flags & PARAM_ONIP)
+			exit_error(PARAMETER_PROBLEM,
+				"TPROXY target: Can't specify --on-ip twice");
+		parse_tproxy_laddr(optarg, tproxyinfo);
+		*flags |= PARAM_ONIP;
+		return 1;
+	case '3':
+		if (*flags & PARAM_MARK)
+			exit_error(PARAMETER_PROBLEM,
+				"TPROXY target: Can't specify --ptoxy-mark twice");
+		parse_tproxy_mark(optarg, tproxyinfo);
+		*flags |= PARAM_MARK;
+		return 1;
+	}
+
+	return 0;
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
+	const struct xt_tproxy_target_info *info = (const void *)target->data;
+	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
+	       addr_to_dotted((const struct in_addr *)&info->laddr),
+	       ntohs(info->lport), (unsigned int)info->mark_value,
+	       (unsigned int)info->mark_mask);
+}
+
+static void tproxy_save(const void *ip, const struct xt_entry_target *target)
+{
+	const struct xt_tproxy_target_info *info = (const void *)target->data;
+
+	printf("--on-port %u ", ntohs(info->lport));
+	printf("--on-ip %s ",
+	       addr_to_dotted((const struct in_addr *)&info->laddr));
+	printf("--tproxy-mark 0x%x/0x%x ",
+	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
+}
+
+static struct xtables_target tproxy_reg = {
+	.name          = "TPROXY",
+	.family        = AF_INET,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_tproxy_target_info)),
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
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/extensions/libxt_socket.c	2007-10-02 22:03:55.000000000 +0200
@@ -0,0 +1,39 @@
+/*
+ * Shared library add-on to iptables to add early socket matching support.
+ *
+ * Copyright (C) 2007 BalaBit IT Ltd.
+ */
+#include <stdio.h>
+#include <getopt.h>
+#include <iptables.h>
+
+static void socket_help(void)
+{
+	printf("socket v%s has no options\n\n", IPTABLES_VERSION);
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
+	.version       = IPTABLES_VERSION,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(0),
+	.userspacesize = XT_ALIGN(0),
+	.parse         = socket_parse,
+	.final_check   = socket_check,
+	.help          = socket_help,
+};
+
+void _init(void)
+{
+	xtables_register_match(&socket_reg);
+}
Index: iptables/include/linux/netfilter/xt_TPROXY.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ iptables/include/linux/netfilter/xt_TPROXY.h	2007-10-01 23:48:30.000000000 +0200
@@ -0,0 +1,16 @@
+#ifndef _XT_TPROXY_H_target
+#define _XT_TPROXY_H_target
+
+/*
+ * TPROXY target is capable of marking the packet to perform
+ * redirection. We can get rid of that whenever we get support for
+ * mutliple targets in the same rule.
+ */
+struct xt_tproxy_target_info {
+	u_int32_t mark_mask;
+	u_int32_t mark_value;
+	__be32 laddr;
+	__be16 lport;
+};
+
+#endif /* _XT_TPROXY_H_target */
