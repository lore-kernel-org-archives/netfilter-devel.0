From: Sven Schnelle <svens@bitebene.org>
Subject: Re: [RFC] TCPOPTSTRIP target (iptables)
Date: Sat, 06 Oct 2007 16:10:53 +0200
Message-ID: <874ph4bafm.fsf@apollo.sven.bitebene.org>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
	<87tzpd266j.fsf@begreifnix.intranet.astaro.de>
	<87hcl91ubt.fsf@begreifnix.intranet.astaro.de>
	<87abr11tth.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from woomax.duncanthrax.net ([195.2.162.46]:33671 "EHLO
	woomax.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759433AbXJFOK6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 6 Oct 2007 10:10:58 -0400
In-Reply-To: <Pine.LNX.4.64.0710021656510.7130@fbirervta.pbzchgretzou.qr> (Jan Engelhardt's message of "Tue\, 2 Oct 2007 19\:51\:47 +0200 \(CEST\)")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> writes:

> On Oct 2 2007 16:20, Sven Schnelle wrote:
>>+static void tcpoptstrip_help(void)
>>+{
>>+    printf("TCPOPTSTRIP target options:\n"
>>+	   "  --strip-tcp-options option(s)  strip specified tcp options from TCP Header\n"
>>+	   "  --strip-wscale                 strip windows scaling option\n"
>>+	   "  --strip-timestamp              strip timestamp option\n"
>>+	   "  --strip-mss                    strip mss option\n"
>>+	   "  --strip-sack                   strip sack option\n"
>>+	   "  --strip-sack-permitted         strip sack permitted option\n");
>>+}
>
> I have added a strip-md5.

Thanks. I've added only a few options, so this list may still be
extensible ;-)

> This here is untested.

> [iptables patch]

I've changed the code in the meantime so that names could be specified
inside the --strip-options argument list, instead of having extra
options for every tcp option, this makes code smaller, and it is even
simpler to add new names.

For example:

--strip-options 3 is the same as --strip-options wscale. iptables-save
and iptables -L would give the names of the options, instead of the
numbers.

Output looks like this now:

  root@deprecated(1058):~0# iptables -nvL -t mangle                                                                   
  Chain PREROUTING (policy ACCEPT 161 packets, 123K bytes)
  pkts bytes target     prot opt in     out     source               destination         

  Chain INPUT (policy ACCEPT 161 packets, 123K bytes)
  pkts bytes target     prot opt in     out     source               destination         

  Chain FORWARD (policy ACCEPT 0 packets, 0 bytes)
  pkts bytes target     prot opt in     out     source               destination         
  0     0 TCPOPTSTRIP  tcp  --  *      *       0.0.0.0/0            0.0.0.0/0           tcp flags:0x17/0x02 TCPOPTSTRIP options wscale,77

  Chain OUTPUT (policy ACCEPT 124 packets, 13460 bytes)
  pkts bytes target     prot opt in     out     source               destination         

  Chain POSTROUTING (policy ACCEPT 124 packets, 13460 bytes)
  pkts bytes target     prot opt in     out     source               destination         


My version of the patch right now:

Index: libxt_TCPOPTSTRIP.c
===================================================================
--- libxt_TCPOPTSTRIP.c	(revision 0)
+++ libxt_TCPOPTSTRIP.c	(revision 0)
@@ -0,0 +1,205 @@
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
+};
+
+static const struct option tcpoptstrip_opts[] = {
+	{"strip-options",        true,  NULL, '0'},
+	{NULL},
+};
+
+struct tcp_optionmap_struct {
+	const char *name;
+	const int option;
+};
+
+static const struct tcp_optionmap_struct tcp_optionmap[] = {
+	{"wscale", TCPOPT_WINDOW},
+	{"mss", TCPOPT_MAXSEG},
+	{"sack-permitted", TCPOPT_SACK_PERMITTED},
+	{"sack", TCPOPT_SACK},
+	{"timestamp", TCPOPT_TIMESTAMP},
+	{"md5", TCPOPT_MD5SIG},
+	{NULL},
+};
+
+static void tcpoptstrip_help(void)
+{
+	printf(
+"TCPOPTSTRIP target options:\n"
+"  --strip-options value     strip specified TCP options denoted by value\n"
+"                            (separated by comma) from TCP header\n"
+"  instead of the numeric value, you can also use the following names: \n"
+"   mss               strip MSS option\n"
+"   wscale            strip window scaling option\n"
+"   sack-permitted    strip \"SACK permitted\" option\n"
+"   sack              strip SACK option\n"
+"   timestamp         strip timestamp option\n"
+"   md5               strip MD5 signature (RFC2385) option\n"
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
+	int i;
+
+	while (true) {
+		p = strchr(arg, ',');
+		if (p != NULL)
+			*p = '\0';
+
+		option = 0;
+		for (i = 0; tcp_optionmap[i].name != NULL; i++) {
+			if (!strcmp(tcp_optionmap[i].name, arg)) {
+				option = tcp_optionmap[i].option;
+				break;
+			}
+		}
+		
+		if (option != 0 && string_to_number(arg, 0, 255, &option) == -1)
+			exit_error(PARAMETER_PROBLEM,
+				   "Bad TCP option value \"%s\"", arg);
+
+		if (option < 2)
+			exit_error(PARAMETER_PROBLEM,
+				   "Option value may not be 0 or 1");
+
+		if(tcpoptstrip_test_bit(info->strip_bmap, option))
+			exit_error(PARAMETER_PROBLEM,
+				   "Option \"%s\" already specified", arg);
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
+static void tcpoptstrip_print_list(bool parse, const struct xt_tcpoptstrip_info *info)
+{
+	bool first = true;
+	unsigned int i,j;
+	const char *name;
+
+	for (i = 0; i < 256; ++i) {
+		if (!tcpoptstrip_test_bit(info->strip_bmap, i))
+			continue;
+
+		putchar(first ? ' ' : ',');
+		first = false;
+
+		name = NULL;
+		for (j = 0; tcp_optionmap[j].name != NULL; j++) {
+			if (tcp_optionmap[j].option == i)
+				name = tcp_optionmap[j].name;
+		}
+
+		if(name)
+			fputs(name, stdout);
+		else
+			printf("%u", i);
+	}
+}
+
+static void tcpoptstrip_print(const void *ip,
+                              const struct xt_entry_target *target, int numeric)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+	printf("TCPOPTSTRIP options");
+	tcpoptstrip_print_list(false, info);
+}
+
+static void tcpoptstrip_save(const void *ip,
+                             const struct xt_entry_target *target)
+{
+	const struct xt_tcpoptstrip_info *info = (const void *)target->data;
+	printf("--strip-options");
+	tcpoptstrip_print_list(true, info);
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
Index: Makefile
===================================================================
--- Makefile	(revision 7065)
+++ Makefile	(working copy)
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TCPOPTSTRIP TRACE
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
