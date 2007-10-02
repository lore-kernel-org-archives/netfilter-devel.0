From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target (iptables)
Date: Tue, 2 Oct 2007 19:51:47 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <87tzpd266j.fsf@begreifnix.intranet.astaro.de>
 <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> <87abr11tth.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Sven Schnelle <sschnelle@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42167 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456AbXJBRvs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:51:48 -0400
In-Reply-To: <87abr11tth.fsf@begreifnix.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 2 2007 16:20, Sven Schnelle wrote:
>+static void tcpoptstrip_help(void)
>+{
>+    printf("TCPOPTSTRIP target options:\n"
>+	   "  --strip-tcp-options option(s)  strip specified tcp options from TCP Header\n"
>+	   "  --strip-wscale                 strip windows scaling option\n"
>+	   "  --strip-timestamp              strip timestamp option\n"
>+	   "  --strip-mss                    strip mss option\n"
>+	   "  --strip-sack                   strip sack option\n"
>+	   "  --strip-sack-permitted         strip sack permitted option\n");
>+}

I have added a strip-md5.

>+	case OPT_STRIP_OPTIONS:
>+	    for (p = strtok(optarg, ","); p; p = strtok(NULL, ",")) {

I have added option processing validation.

>+/* Saves the union ipt_targinfo in parsable form to stdout. */
>+static void tcpoptstrip_save(const void *ip,
>+			     const struct xt_entry_target *target)
>+{
>+    const struct xt_tcpoptstrip_info *optinfo =
>+	(const struct xt_tcpoptstrip_info *)target->data;
>+    printf("--strip-tcp-options");
>+    tcpoptstrip_print_options(optinfo);
>+
>+}

Bogus. The parser code does not know how to handle a comma-separated
list, so save() should not produce one.

This here is untested.

=== Patch begins here ===
---
 extensions/Makefile                      |    2 
 extensions/libxt_TCPOPTSTRIP.c           |  218 +++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_TCPOPTSTRIP.h |   13 +
 3 files changed, 232 insertions(+), 1 deletion(-)

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
@@ -0,0 +1,218 @@
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
+#ifndef TCPOPT_MD5SIG
+#	define TCPOPT_MD5SIG 19
+#endif
+
+enum {
+	F_STRIP          = 1 << 0,
+	F_MSS            = 1 << 1,
+	F_WSCALE         = 1 << 2,
+	F_SACK_PERMITTED = 1 << 3,
+	F_SACK           = 1 << 4,
+	F_TIMESTAMP      = 1 << 5,
+	F_MD5            = 1 << 6,
+};
+
+static const struct option tcpoptstrip_opts[] = {
+	{"strip-options",        true,  NULL, '0'},
+	{"strip-mss",            false, NULL, 'm'},
+	{"strip-wscale",         false, NULL, 'w'},
+	{"strip-sack-permitted", false, NULL, 'S'},
+	{"strip-sack",           false, NULL, 's'},
+	{"strip-timestamp",      false, NULL, 't'},
+	{"strip-md5",            false, NULL, '5'},
+	{NULL},
+};
+
+static void tcpoptstrip_help(void)
+{
+	printf(
+"TCPOPTSTRIP target options:\n"
+"  --strip-options value     strip specified TCP options denoted by value\n"
+"                            (separated by comma) from TCP header\n"
+"  --strip-mss               strip MSS option\n"
+"  --strip-wscale            strip window scaling option\n"
+"  --strip-sack-permitted    strip \"SACK permitted\" option\n"
+"  --strip-sack              strip SACK option\n"
+"  --strip-timestamp         strip timestamp option\n"
+"  --strip-md5               strip MD5 signature (RFC2385) option\n"
+	);
+}
+
+static void tcpoptstrip_init(struct xt_entry_target *t)
+{
+	struct xt_tcpoptstrip_info *info = (void *)t->data;
+
+	/* strictly necessary? play safe for now. */
+	memset(info->strip_bmap, 0, sizeof(info->strip_bmap));
+}
+
+static void parse_list(struct xt_tcpoptstrip_info *info, char *arg)
+{
+	unsigned int option;
+	char *p;
+
+	while (true) {
+		p = strchr(arg, ',');
+		if (p != NULL)
+			*p = '\0';
+
+		if (string_to_number(arg, 0, 255, &option) == -1)
+			exit_error(PARAMETER_PROBLEM,
+			           "Bad TCP option value \"%s\"", arg);
+		if (option < 2)
+			exit_error(PARAMETER_PROBLEM,
+			           "Option value may not be 0 or 1");
+
+		tcpoptstrip_set_bit(info->strip_bmap, option);
+		if (p == NULL)
+			break;
+		arg = p + 1;
+	}
+}
+
+static int tcpoptstrip_parse(int c, char **argv, int invert,
+                             unsigned int *flags, const void *entry,
+                             struct xt_entry_target **target)
+{
+	struct xt_tcpoptstrip_info *info = (void *)(*target)->data;
+
+	switch (c) {
+	case '0':
+		if (*flags & F_STRIP)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-options only once");
+		parse_list(info, optarg);
+		*flags |= F_STRIP;
+		return 1;
+	case 'm':
+		if (*flags & F_MSS)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-mss only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_MAXSEG);
+		*flags |= F_MSS;
+		return 1;
+	case 'w':
+		if (*flags & F_WSCALE)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-wscale only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_WINDOW);
+		*flags |= F_WSCALE;
+		return 1;
+	case 'S':
+		if (*flags & F_SACK_PERMITTED)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-sack-permitted only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_SACK_PERMITTED);
+		*flags |= F_SACK_PERMITTED;
+		return 1;
+	case 's':
+		if (*flags & F_SACK)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-sack only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_SACK);
+		*flags |= F_SACK;
+		return 1;
+	case 't':
+		if (*flags & F_TIMESTAMP)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-timestamp only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_TIMESTAMP);
+		*flags |= F_TIMESTAMP;
+		return 1;
+	case '5':
+		if (*flags & F_MD5)
+			exit_error(PARAMETER_PROBLEM,
+			           "You can specify --strip-md5 only once");
+		tcpoptstrip_set_bit(info->strip_bmap, TCPOPT_MD5SIG);
+		*flags |= F_MD5;
+		return 1;
+	}
+
+	return 0;
+}
+
+static void tcpoptstrip_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM,
+		           "TCPOPTSTRIP: At least one of the strip options must be specified");
+}
+
+static void tcpoptstrip_print_list(const struct xt_tcpoptstrip_info *info)
+{
+	bool first = true;
+	unsigned int i;
+
+	for (i = 0; i < 256; ++i) {
+		if (!tcpoptstrip_test_bit(info->strip_bmap, i))
+			continue;
+		printf("%s%u", first ? "" : ",", i);
+		first = false;
+	}
+}
+
+static void tcpoptstrip_print(const void *ip,
+                              const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+
+	printf("TCPOPTSTRIP options ");
+	tcpoptstrip_print_list(info);
+}
+
+static void tcpoptstrip_save(const void *ip,
+                             const struct xt_entry_target *target)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+
+	printf("--strip-options ");
+	tcpoptstrip_print_list(info);
+}
+
+static struct xtables_target tcpoptstrip_reg = {
+	.name          = "TCPOPTSTRIP",
+	.family        = AF_INET,
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
@@ -0,0 +1,13 @@
+#ifndef _XT_TCPOPTSTRIP_H
+#define _XT_TCPOPTSTRIP_H
+
+#define tcpoptstrip_set_bit(bmap, idx) \
+	(bmap[(idx) >> 5] |= 1UL << (idx & 31))
+#define tcpoptstrip_test_bit(bmap, idx) \
+	(((1UL << (idx & 31)) & bmap[(idx) >> 5]) != 0)
+
+struct xt_tcpoptstrip_info {
+	u_int32_t strip_bmap[8];
+};
+
+#endif /* _XT_TCPOPTSTRIP_H */
