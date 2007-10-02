From: Sven Schnelle <sschnelle@astaro.com>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Tue, 02 Oct 2007 16:20:58 +0200
Message-ID: <87abr11tth.fsf@begreifnix.intranet.astaro.de>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
	<Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
	<46FD1798.2020302@trash.net>
	<87tzpd266j.fsf@begreifnix.intranet.astaro.de>
	<87hcl91ubt.fsf@begreifnix.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vpn.astaro.de ([213.144.15.3]:36815 "EHLO vpn.astaro.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362AbXJBOVB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Oct 2007 10:21:01 -0400
Received: from MailerDaemon by vpn.astaro.de with local-bsmtp (Exim 4.63)
	(envelope-from <sschnelle@astaro.com>)
	id 1IcicO-0002gb-C0
	for netfilter-devel@vger.kernel.org; Tue, 02 Oct 2007 16:21:00 +0200
In-Reply-To: <87hcl91ubt.fsf@begreifnix.intranet.astaro.de> (Sven Schnelle's message of "Tue\, 02 Oct 2007 16\:09\:58 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Sven Schnelle <sschnelle@astaro.com> writes:

> Sven Schnelle <svens@bitebene.org> writes:
>
>> As i'm currently travelling, i can't test the code above - will do the
>> end of next week, and resubmit.
>
> Ok, i've cleaned up the code and followed the suggestions here. I've
> also added the possibility to strip more than one option from the Headers.
>
> Signed-off-by: Sven Schnelle <svens@bitebene.org>

Please ignore the last iptables patch, there was a typo in there. This
one should be fine.

Index: extensions/libxt_TCPOPTSTRIP.c
===================================================================
--- extensions/libxt_TCPOPTSTRIP.c	(revision 0)
+++ extensions/libxt_TCPOPTSTRIP.c	(revision 0)
@@ -0,0 +1,182 @@
+/* Shared library add-on to iptables to add TCPOPTSTRIP target support.
+ *
+ * Copyright (c) 2007 Sven Schnelle <svens@bitebene.org>
+*/
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+
+#include <xtables.h>
+
+#include <linux/netfilter/x_tables.h>
+#include <linux/netfilter/xt_TCPOPTSTRIP.h>
+
+enum {
+    OPT_STRIP_OPTIONS=1,
+    OPT_STRIP_WSCALE,
+    OPT_STRIP_TIMESTAMP,
+    OPT_STRIP_MSS,
+    OPT_STRIP_SACK,
+    OPT_STRIP_SACK_PERMITTED,
+};
+
+static const struct option tcpoptstrip_opts[] = {
+	{ "strip-tcp-options", 1, NULL, OPT_STRIP_OPTIONS },
+	{ "strip-wscale", 0, NULL, OPT_STRIP_WSCALE },
+	{ "strip-timestamp", 0, NULL, OPT_STRIP_TIMESTAMP },
+	{ "strip-mss", 0, NULL, OPT_STRIP_MSS },
+	{ "strip-sack", 0, NULL, OPT_STRIP_SACK },
+	{ "strip-sack-permitted", 0, NULL, OPT_STRIP_SACK_PERMITTED },
+	{ }
+};
+
+/* Function which prints out usage message. */
+static void tcpoptstrip_help(void)
+{
+    printf("TCPOPTSTRIP target options:\n"
+	   "  --strip-tcp-options option(s)  strip specified tcp options from TCP Header\n"
+	   "  --strip-wscale                 strip windows scaling option\n"
+	   "  --strip-timestamp              strip timestamp option\n"
+	   "  --strip-mss                    strip mss option\n"
+	   "  --strip-sack                   strip sack option\n"
+	   "  --strip-sack-permitted         strip sack permitted option\n");
+}
+
+/* Initialize the target. */
+static void tcpoptstrip_init(struct xt_entry_target *target)
+{
+    struct xt_tcpoptstrip_info *optinfo
+	= (struct xt_tcpoptstrip_info *)target->data;
+    memset(optinfo->tcpoptions, 0, sizeof(optinfo->tcpoptions));
+}
+
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int tcpoptstrip_parse(int c, char **argv, int invert,
+			     unsigned int *flags, const void *entry,
+			     struct xt_entry_target **target)
+{
+    char *p;
+    struct xt_tcpoptstrip_info *optinfo
+	= (struct xt_tcpoptstrip_info *)(*target)->data;
+
+	switch (c) {
+		unsigned int option;
+
+	case OPT_STRIP_OPTIONS:
+	    for (p = strtok(optarg, ","); p; p = strtok(NULL, ",")) {
+		if (string_to_number(p, 0, 255, &option) == -1)
+		    exit_error(PARAMETER_PROBLEM, "Bad TCPOPTSTRIP value `%s'",
+			       p);
+
+		if (option < 2) 
+		    exit_error(PARAMETER_PROBLEM, "option has to be > 2");
+
+		SET_OPTION(optinfo->tcpoptions, option);
+	    }
+	    break;
+
+	case OPT_STRIP_WSCALE:
+	    SET_OPTION(optinfo->tcpoptions, TCPOPT_WINDOW);
+	    break;
+
+	case OPT_STRIP_MSS:
+	    SET_OPTION(optinfo->tcpoptions, TCPOPT_MAXSEG);
+	    break;
+
+	case OPT_STRIP_SACK:
+	    SET_OPTION(optinfo->tcpoptions, TCPOPT_SACK);
+	    break;
+
+	case OPT_STRIP_SACK_PERMITTED:
+	    SET_OPTION(optinfo->tcpoptions, TCPOPT_SACK_PERMITTED);
+	    break;
+
+	case OPT_STRIP_TIMESTAMP:
+	    SET_OPTION(optinfo->tcpoptions, TCPOPT_TIMESTAMP);
+	    break;
+
+	default:
+	    return 0;
+	}
+	*flags = 1;
+	return 1;
+}
+
+static void tcpoptstrip_final_check(unsigned int flags)
+{
+    if (!flags)
+	exit_error(PARAMETER_PROBLEM,
+		   "TCPOPTSTRIP target: At least one parameter is required");
+}
+
+static void tcpoptstrip_print_options(const struct xt_tcpoptstrip_info *optinfo)
+{
+    int first = 1, option;
+    for(option = 0; option < 256; option++) {
+	if(OPTION_IS_SET(optinfo->tcpoptions, option)) {
+	    printf("%c%d", first ? ' ' : ',', option);
+	    first = 0;
+	}
+    }
+}
+
+/* Prints out the targinfo. */
+static void tcpoptstrip_print(const void *ip,
+			      const struct xt_entry_target *target,
+      int numeric)
+{
+    const struct xt_tcpoptstrip_info *optinfo =
+	(const struct xt_tcpoptstrip_info *)target->data;
+    printf("TCPOPTSTRIP options");
+    tcpoptstrip_print_options(optinfo);
+}
+
+/* Saves the union ipt_targinfo in parsable form to stdout. */
+static void tcpoptstrip_save(const void *ip,
+			     const struct xt_entry_target *target)
+{
+    const struct xt_tcpoptstrip_info *optinfo =
+	(const struct xt_tcpoptstrip_info *)target->data;
+    printf("--strip-tcp-options");
+    tcpoptstrip_print_options(optinfo);
+
+}
+
+static struct xtables_target tcpoptstrip_reg = {
+	.family		= AF_INET,
+	.name		= "TCPOPTSTRIP",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help		= tcpoptstrip_help,
+	.init		= tcpoptstrip_init,
+	.parse		= tcpoptstrip_parse,
+	.final_check	= tcpoptstrip_final_check,
+	.print		= tcpoptstrip_print,
+	.save		= tcpoptstrip_save,
+	.extra_opts	= tcpoptstrip_opts
+};
+
+static struct xtables_target tcpoptstrip_reg6 = {
+	.family		= AF_INET6,
+	.name		= "TCPOPTSTRIP",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcpoptstrip_info)),
+	.help		= tcpoptstrip_help,
+	.init		= tcpoptstrip_init,
+	.parse		= tcpoptstrip_parse,
+	.final_check	= tcpoptstrip_final_check,
+	.print		= tcpoptstrip_print,
+	.save		= tcpoptstrip_save,
+	.extra_opts	= tcpoptstrip_opts
+};
+
+void _init(void)
+{
+    xtables_register_target(&tcpoptstrip_reg);
+    xtables_register_target(&tcpoptstrip_reg6);
+}
Index: extensions/Makefile
===================================================================
--- extensions/Makefile	(revision 7050)
+++ extensions/Makefile	(working copy)
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK TCPMSS TRACE TCPOPTSTRIP
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
