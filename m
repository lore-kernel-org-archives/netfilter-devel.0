From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 16:57:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281655490.25099@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Sven Schnelle <svens@bitebene.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57579 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166AbXI1O5H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 10:57:07 -0400
In-Reply-To: <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

>Since I had nothing better to do, I did a cleanup :)

iptables part.

---
 extensions/Makefile                      |    2 
 extensions/libxt_TCPOPTSTRIP.c           |  108 +++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_TCPOPTSTRIP.h |    8 ++
 3 files changed, 117 insertions(+), 1 deletion(-)

Index: iptables/extensions/Makefile
===================================================================
--- iptables.orig/extensions/Makefile
+++ iptables/extensions/Makefile
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TCPOPTSTRIP TRACE
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
Index: iptables/extensions/libxt_TCPOPTSTRIP.c
===================================================================
--- /dev/null
+++ iptables/extensions/libxt_TCPOPTSTRIP.c
@@ -0,0 +1,108 @@
+/*
+ * Shared library add-on to iptables to add TCPOPTSTRIP target support.
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+ */
+#include <getopt.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <xtables.h>
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+static void tcpoptstrip_help(void)
+{
+	printf(
+"TCPOPTSTRIP target options:\n"
+"  --strip-tcp-option value    strip TCP option denoted by \"value\"\n"
+"                              from TCP header\n");
+}
+
+static const struct option tcpoptstrip_opts[] = {
+	{"strip-tcp-option", true, NULL, '1'},
+	{NULL},
+};
+
+static void tcpoptstrip_init(struct xt_entry_target *t)
+{
+}
+
+static int tcpoptstrip_parse(int c, char **argv, int invert,
+                             unsigned int *flags, const void *entry,
+                             struct xt_entry_target **target)
+{
+	struct xt_tcpoptstrip_info *info = (void *)(*target)->data;
+	unsigned int option;
+
+	switch (c) {
+	case '1':
+		if (string_to_number(optarg, 0, 255, &option) == -1)
+			exit_error(PARAMETER_PROBLEM,
+			           "Bad TCPOPTSTRIP value \"%s\"", optarg);
+		info->tcpoption = option;
+		*flags |= 1;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void tcpoptstrip_check(unsigned int flags)
+{
+	if (flags != 1)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPOPTSTRIP: --value is required");
+}
+
+static void tcpoptstrip_print(const void *ip,
+                              const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+
+	printf("TCPOPTSTRIP option %u ", info->tcpoption);
+}
+
+static void tcpoptstrip_save(const void *ip,
+                             const struct xt_entry_target *target)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+
+	printf("--strip-tcp-option %u ", info->tcpoption);
+}
+
+static struct xtables_target tcpoptstrip_reg = {
+	.name          = "TCPOPTSTRIP",
+	.family        = AF_INET6,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help          = tcpoptstrip_help,
+	.init          = tcpoptstrip_init,
+	.parse         = tcpoptstrip_parse,
+	.final_check   = tcpoptstrip_check,
+	.print         = tcpoptstrip_print,
+	.save          = tcpoptstrip_save,
+	.extra_opts    = tcpoptstrip_opts,
+};
+
+static struct xtables_target tcpoptstrip6_reg = {
+	.name          = "TCPOPTSTRIP",
+	.family        = AF_INET6,
+	.version       = IPTABLES_VERSION,
+	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help          = tcpoptstrip_help,
+	.init          = tcpoptstrip_init,
+	.parse         = tcpoptstrip_parse,
+	.final_check   = tcpoptstrip_check,
+	.print         = tcpoptstrip_print,
+	.save          = tcpoptstrip_save,
+	.extra_opts    = tcpoptstrip_opts,
+};
+
+void _init(void)
+{
+	xtables_register_target(&tcpoptstrip_reg);
+	xtables_register_target(&tcpoptstrip6_reg);
+}
Index: iptables/include/linux/netfilter/xt_TCPOPTSTRIP.h
===================================================================
--- /dev/null
+++ iptables/include/linux/netfilter/xt_TCPOPTSTRIP.h
@@ -0,0 +1,8 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+struct xt_tcpoptstrip_info {
+	u_int8_t tcpoption;
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
