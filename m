From: Krzysztof Oledzki <ole@ans.pl>
Subject: [PATCH 3/3] Add ICMPv6 support in conntrack-tools
Date: Mon, 24 Mar 2008 03:05:35 +0100
Message-ID: <47e70c6f.izcz7xqp25fqRcfr%ole@ans.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:35811 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754008AbYCXCF5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2008 22:05:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patch adds ICMPv6 (-p icmpv6) support for conntrack-tools and adds
possibility to distinguish between invalid (unknown) and empty proto:

# conntrack -L --protonum wrong
conntrack v0.9.6: unknown proto
Try `conntrack -h' or 'conntrack --help' for more information.

# conntrack -L --protonum ""
conntrack v0.9.6: proto needed
Try `conntrack -h' or 'conntrack --help' for more information.

Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>

diff -Nur conntrack-tools-20080309-orig/ChangeLog conntrack-tools-20080309-tmp/ChangeLog
--- conntrack-tools-20080309-orig/ChangeLog	2008-03-08 12:35:38.000000000 +0100
+++ conntrack-tools-20080309-tmp/ChangeLog	2008-03-23 20:46:11.000000000 +0100
@@ -152,7 +152,7 @@
 o lots of cleanups
 
 = conntrack =
-o fix segfault with conntrack --output (Krzysztof Oledzky)
+o fix segfault with conntrack --output (Krzysztof Oledzki)
 o use NFCT_SOPT_SETUP_* facilities: nfct_setobjopt
 o remove bogus option to get a conntrack in test.sh example file
 o add aliases --sport and --dport to make it more iptables-like
diff -Nur conntrack-tools-20080309-orig/extensions/Makefile.am conntrack-tools-20080309-tmp/extensions/Makefile.am
--- conntrack-tools-20080309-orig/extensions/Makefile.am	2007-06-09 21:24:07.000000000 +0200
+++ conntrack-tools-20080309-tmp/extensions/Makefile.am	2008-03-23 20:44:31.000000000 +0100
@@ -1,8 +1,9 @@
 include $(top_srcdir)/Make_global.am
 
 noinst_LTLIBRARIES = libct_proto_tcp.la libct_proto_udp.la \
-		     libct_proto_icmp.la
+		     libct_proto_icmp.la libct_proto_icmpv6.la
 
 libct_proto_tcp_la_SOURCES = libct_proto_tcp.c
 libct_proto_udp_la_SOURCES = libct_proto_udp.c
 libct_proto_icmp_la_SOURCES = libct_proto_icmp.c
+libct_proto_icmpv6_la_SOURCES = libct_proto_icmpv6.c
diff -Nur conntrack-tools-20080309-orig/extensions/libct_proto_icmpv6.c conntrack-tools-20080309-tmp/extensions/libct_proto_icmpv6.c
--- conntrack-tools-20080309-orig/extensions/libct_proto_icmpv6.c	1970-01-01 01:00:00.000000000 +0100
+++ conntrack-tools-20080309-tmp/extensions/libct_proto_icmpv6.c	2008-03-23 22:52:07.000000000 +0100
@@ -0,0 +1,129 @@
+/*
+ * (C) 2008 by Krzysztof Piotr Oledzki <ole@ans.pl>
+ *
+ * Based on libct_proto_icmp.c:
+ * (C) 2005-2007 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *     2005 by Harald Welte <laforge@netfilter.org>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+
+#include "conntrack.h"
+
+#include <stdio.h>
+#include <getopt.h>
+#include <stdlib.h>
+#include <netinet/in.h> /* For htons */
+#include <netinet/icmp6.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+#include <libnetfilter_conntrack/libnetfilter_conntrack_icmp.h>
+
+static struct option opts[] = {
+	{ "icmpv6-type", 1, 0, '1' },
+	{ "icmpv6-code", 1, 0, '2' },
+	{ "icmpv6-id",  1, 0, '3' },
+	{ 0, 0, 0, 0 },
+};
+
+#define ICMPV6_NUMBER_OF_OPT 4
+
+static const char *icmpv6_optflags[ICMPV6_NUMBER_OF_OPT] = {
+	"icmpv6-type", "icmpv6-code", "icmpv6-id"
+};
+
+static char icmpv6_commands_v_options[NUMBER_OF_CMD][ICMPV6_NUMBER_OF_OPT] =
+/* Well, it's better than "Re: Maradona vs Pele" */
+{
+		/* 1 2 3 */
+/*CT_LIST*/	  {2,2,2},
+/*CT_CREATE*/	  {1,1,2},
+/*CT_UPDATE*/	  {1,1,2},
+/*CT_DELETE*/	  {1,1,2},
+/*CT_GET*/	  {1,1,2},
+/*CT_FLUSH*/	  {0,0,0},
+/*CT_EVENT*/	  {2,2,2},
+/*CT_VERSION*/	  {0,0,0},
+/*CT_HELP*/	  {0,0,0},
+/*EXP_LIST*/	  {0,0,0},
+/*EXP_CREATE*/	  {0,0,0},
+/*EXP_DELETE*/	  {0,0,0},
+/*EXP_GET*/	  {0,0,0},
+/*EXP_FLUSH*/	  {0,0,0},
+/*EXP_EVENT*/	  {0,0,0},
+};
+
+static void help(void)
+{
+	fprintf(stdout, "  --icmpv6-type\t\t\ticmpv6 type\n");
+	fprintf(stdout, "  --icmpv6-code\t\t\ticmpv6 code\n");
+	fprintf(stdout, "  --icmpv6-id\t\t\ticmpv6 id\n");
+}
+
+static int parse(char c,
+		 struct nf_conntrack *ct,
+		 struct nf_conntrack *exptuple,
+		 struct nf_conntrack *mask,
+		 unsigned int *flags)
+{
+	switch(c) {
+		case '1':
+			if (!optarg)
+				break;
+
+			nfct_set_attr_u8(ct, 
+					 ATTR_ICMP_TYPE,
+					 atoi(optarg));
+			*flags |= ICMP_TYPE;
+			break;
+
+		case '2':
+			if (!optarg)
+				break;
+
+			nfct_set_attr_u8(ct, 
+					 ATTR_ICMP_CODE,
+					 atoi(optarg));
+			*flags |= ICMP_CODE;
+			break;
+
+		case '3':
+			if (!optarg)
+				break;
+
+			nfct_set_attr_u16(ct, 
+					 ATTR_ICMP_ID,
+					 htons(atoi(optarg)));
+			*flags |= ICMP_ID;
+			break;
+	}
+	return 1;
+}
+
+static void final_check(unsigned int flags,
+		        unsigned int cmd,
+		        struct nf_conntrack *ct)
+{
+	generic_opt_check(flags,
+			  ICMPV6_NUMBER_OF_OPT,
+			  icmpv6_commands_v_options[cmd],
+			  icmpv6_optflags);
+}
+
+static struct ctproto_handler icmpv6 = {
+	.name 		= "icmpv6",
+	.protonum	= IPPROTO_ICMPV6,
+	.parse_opts	= parse,
+	.final_check	= final_check,
+	.help		= help,
+	.opts		= opts,
+	.version	= VERSION,
+};
+
+void register_icmpv6(void)
+{
+	register_proto(&icmpv6);
+}
diff -Nur conntrack-tools-20080309-orig/include/conntrack.h conntrack-tools-20080309-tmp/include/conntrack.h
--- conntrack-tools-20080309-orig/include/conntrack.h	2008-01-17 18:36:32.000000000 +0100
+++ conntrack-tools-20080309-tmp/include/conntrack.h	2008-03-23 21:06:38.000000000 +0100
@@ -188,5 +188,6 @@
 extern void register_tcp(void);
 extern void register_udp(void);
 extern void register_icmp(void);
+extern void register_icmpv6(void);
 
 #endif
diff -Nur conntrack-tools-20080309-orig/src/Makefile.am conntrack-tools-20080309-tmp/src/Makefile.am
--- conntrack-tools-20080309-orig/src/Makefile.am	2008-02-20 00:04:49.000000000 +0100
+++ conntrack-tools-20080309-tmp/src/Makefile.am	2008-03-23 21:32:51.000000000 +0100
@@ -7,7 +7,7 @@
 sbin_PROGRAMS = conntrack conntrackd
 
 conntrack_SOURCES = conntrack.c
-conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la
+conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la
 conntrack_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
diff -Nur conntrack-tools-20080309-orig/src/conntrack.c conntrack-tools-20080309-tmp/src/conntrack.c
--- conntrack-tools-20080309-orig/src/conntrack.c	2008-03-23 19:35:51.000000000 +0100
+++ conntrack-tools-20080309-tmp/src/conntrack.c	2008-03-23 21:42:27.000000000 +0100
@@ -684,6 +684,7 @@
 	register_tcp();
 	register_udp();
 	register_icmp();
+	register_icmpv6();
 
 	while ((c = getopt_long(argc, argv, "L::I::U::D::G::E::F::hVs:d:r:q:"
 					    "p:t:u:e:a:z[:]:{:}:m:i::f:o:n::"
@@ -819,10 +820,13 @@
 			nfct_set_attr_u8(obj, ATTR_REPL_L3PROTO, l3protonum);
 			break;
 		case 'p':
+			if (!optarg || !*optarg)
+				exit_error(PARAMETER_PROBLEM, "proto needed\n");
+
 			options |= CT_OPT_PROTO;
 			h = findproto(optarg);
 			if (!h)
-				exit_error(PARAMETER_PROBLEM, "proto needed\n");
+				exit_error(PARAMETER_PROBLEM, "unknown proto\n");
 
 			nfct_set_attr_u8(obj, ATTR_ORIG_L4PROTO, h->protonum);
 			nfct_set_attr_u8(obj, ATTR_REPL_L4PROTO, h->protonum);
