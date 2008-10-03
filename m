From: Bryan Duff <bduff@astrocorp.com>
Subject: conntrack-tools unknown protocol search by number
Date: Fri, 03 Oct 2008 16:56:59 -0500
Message-ID: <48E6952B.5090905@astrocorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060607070105050904080707"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.astrocorp.com ([64.122.215.18]:21461 "EHLO
	mail.astrocorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYJCVy1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2008 17:54:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.astrocorp.com (Postfix) with ESMTP id 97D376310D
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Oct 2008 16:54:23 -0500 (CDT)
Received: from mail.astrocorp.com ([127.0.0.1])
	by localhost (mail.astrocorp.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DizUYjkz44ZQ for <netfilter-devel@vger.kernel.org>;
	Fri,  3 Oct 2008 16:54:21 -0500 (CDT)
Received: from Win2003.astrocorp.com (unknown [192.168.1.146])
	by mail.astrocorp.com (Postfix) with ESMTP id D49C8630F1
	for <netfilter-devel@vger.kernel.org>; Fri,  3 Oct 2008 16:54:21 -0500 (CDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060607070105050904080707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Now instead of "conntrack -L -p tcp" you can do "conntrack -L -p 6" - 
useful for "unknown" proto's like gre, ah, esp.

Thanks.

-Bryan Duff

--------------060607070105050904080707
Content-Type: text/plain;
 name="conntrack-tools-unknown_proto.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="conntrack-tools-unknown_proto.patch"

diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index 0eede22..8165e05 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -1,9 +1,11 @@
 include $(top_srcdir)/Make_global.am
 
 noinst_LTLIBRARIES = libct_proto_tcp.la libct_proto_udp.la \
-		     libct_proto_icmp.la libct_proto_icmpv6.la
+		     libct_proto_icmp.la libct_proto_icmpv6.la \
+				 libct_proto_unknown.la
 
 libct_proto_tcp_la_SOURCES = libct_proto_tcp.c
 libct_proto_udp_la_SOURCES = libct_proto_udp.c
 libct_proto_icmp_la_SOURCES = libct_proto_icmp.c
 libct_proto_icmpv6_la_SOURCES = libct_proto_icmpv6.c
+libct_proto_unknown_la_SOURCES = libct_proto_unknown.c
diff --git a/extensions/libct_proto_unknown.c b/extensions/libct_proto_unknown.c
new file mode 100644
index 0000000..cbb5b2b
--- /dev/null
+++ b/extensions/libct_proto_unknown.c
@@ -0,0 +1,65 @@
+/*
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
+#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
+
+static struct option opts[] = {
+        {0, 0, 0, 0}
+};
+
+#define UNKNOWN_NUMBER_OF_OPT 1
+
+static void help(void)
+{
+	fprintf(stdout, "  no options\n");
+}
+
+static int parse(char c,
+		 struct nf_conntrack *ct,
+		 struct nf_conntrack *exptuple,
+		 struct nf_conntrack *mask,
+		 unsigned int *flags)
+{
+	return 1;
+}
+
+static void final_check(unsigned int flags,
+			unsigned int cmd,
+			struct nf_conntrack *ct)
+{
+#if 0
+	generic_opt_check(flags,
+			  UNKNOWN_NUMBER_OF_OPT,
+			  unknown_commands_v_options[cmd],
+			  unknown_optflags);
+#endif
+}
+
+static struct ctproto_handler unknown = {
+	.name 		= "unknown",
+	.protonum	= IPPROTO_ICMP, //default
+	.parse_opts	= parse,
+	.final_check	= final_check,
+	.help		= help,
+	.opts		= opts,
+	.version	= VERSION,
+};
+
+void register_unknown(void)
+{
+	register_proto(&unknown);
+}
diff --git a/include/conntrack.h b/include/conntrack.h
index 69c2317..4787809 100644
--- a/include/conntrack.h
+++ b/include/conntrack.h
@@ -191,5 +191,6 @@ extern void register_tcp(void);
 extern void register_udp(void);
 extern void register_icmp(void);
 extern void register_icmpv6(void);
+extern void register_unknown(void);
 
 #endif
diff --git a/src/Makefile.am b/src/Makefile.am
index 805e50d..82f7dfe 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -7,7 +7,7 @@ CLEANFILES = read_config_yy.c read_config_lex.c
 sbin_PROGRAMS = conntrack conntrackd
 
 conntrack_SOURCES = conntrack.c
-conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la
+conntrack_LDADD = ../extensions/libct_proto_tcp.la ../extensions/libct_proto_udp.la ../extensions/libct_proto_icmp.la ../extensions/libct_proto_icmpv6.la ../extensions/libct_proto_unknown.la
 conntrack_LDFLAGS = $(all_libraries) @LIBNETFILTER_CONNTRACK_LIBS@
 
 conntrackd_SOURCES = alarm.c main.c run.c hash.c queue.c rbtree.c \
diff --git a/src/conntrack.c b/src/conntrack.c
index 73c102b..38d4f6d 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -158,6 +158,7 @@ void register_proto(struct ctproto_handler *h)
 
 static struct ctproto_handler *findproto(char *name)
 {
+	uint16_t protonum;
 	struct ctproto_handler *cur;
 
 	if (!name) 
@@ -168,6 +169,18 @@ static struct ctproto_handler *findproto(char *name)
 			return cur;
 	}
 
+	protonum = atol(name);
+
+	if (protonum > 0 && protonum <= IPPROTO_MAX) {
+	//get and use "unknown" proto
+		list_for_each_entry(cur, &proto_list, head) {
+			if (strcmp(cur->name, "unknown") == 0) {
+				cur->protonum = protonum;
+				return cur;
+			}
+		}
+	}
+
 	return NULL;
 }
 
@@ -921,6 +934,7 @@ int main(int argc, char *argv[])
 	register_udp();
 	register_icmp();
 	register_icmpv6();
+	register_unknown();
 
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;

--------------060607070105050904080707--
