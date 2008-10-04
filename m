From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack-tools unknown protocol search by number
Date: Sat, 04 Oct 2008 11:37:51 +0200
Message-ID: <48E7396F.1010107@netfilter.org>
References: <48E6952B.5090905@astrocorp.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------040901060806090604080402"
Cc: netfilter-devel@vger.kernel.org
To: Bryan Duff <bduff@astrocorp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38280 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752196AbYJDJiB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Oct 2008 05:38:01 -0400
In-Reply-To: <48E6952B.5090905@astrocorp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040901060806090604080402
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Bryan,

Bryan Duff wrote:
> Now instead of "conntrack -L -p tcp" you can do "conntrack -L -p 6" -
> useful for "unknown" proto's like gre, ah, esp.

Thanks for the patch. I have rework it a bit, the new patch is attached.
I'll push it to git if nobody complains.

BTW: udplite, dccp and sctp support are missing, in case that you want
to contribute something else. You'll also have to add the missing bits
into libnetfilter_conntrack.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------040901060806090604080402
Content-Type: text/x-diff;
 name="y.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="y.patch"

commit e44561766b025600e4af55a35166db46206dd42c
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Sat Oct 4 11:32:37 2008 +0200

    conntrack: fix filtering for unsupported protocol
    
    This patch fixes filtering for unsupported protocol. Thus, you can
    use -L -p 47 or -L -p gre to filter `gre' traffic.
    
    Based on an initial patch from Bryan Duff <bduff@astrocorp.com>.
    
    Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
diff --git a/extensions/Makefile.am b/extensions/Makefile.am
index 0eede22..7b48f05 100644
--- a/extensions/Makefile.am
+++ b/extensions/Makefile.am
@@ -1,9 +1,11 @@
 include $(top_srcdir)/Make_global.am
 
 noinst_LTLIBRARIES = libct_proto_tcp.la libct_proto_udp.la \
-		     libct_proto_icmp.la libct_proto_icmpv6.la
+		     libct_proto_icmp.la libct_proto_icmpv6.la \
+		     libct_proto_unknown.la
 
 libct_proto_tcp_la_SOURCES = libct_proto_tcp.c
 libct_proto_udp_la_SOURCES = libct_proto_udp.c
 libct_proto_icmp_la_SOURCES = libct_proto_icmp.c
 libct_proto_icmpv6_la_SOURCES = libct_proto_icmpv6.c
+libct_proto_unknown_la_SOURCES = libct_proto_unknown.c
diff --git a/extensions/libct_proto_unknown.c b/extensions/libct_proto_unknown.c
new file mode 100644
index 0000000..2a47704
--- /dev/null
+++ b/extensions/libct_proto_unknown.c
@@ -0,0 +1,34 @@
+/*
+ * (C) 2005-2008 by Pablo Neira Ayuso <pablo@netfilter.org>
+ *
+ *      This program is free software; you can redistribute it and/or modify
+ *      it under the terms of the GNU General Public License as published by
+ *      the Free Software Foundation; either version 2 of the License, or
+ *      (at your option) any later version.
+ *
+ */
+#include <stdio.h>
+#include <getopt.h>
+
+#include "conntrack.h"
+
+static struct option opts[] = {
+        {0, 0, 0, 0}
+};
+
+static void help(void)
+{
+	fprintf(stdout, "  no options (unsupported)\n");
+}
+
+struct ctproto_handler ct_proto_unknown = {
+	.name 		= "unknown",
+	.help		= help,
+	.opts		= opts,
+	.version	= VERSION,
+};
+
+void register_unknown(void)
+{
+	/* we don't actually insert this protocol in the list */
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
index 73c102b..eccaa7b 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -53,6 +53,7 @@
 #endif
 #include <signal.h>
 #include <string.h>
+#include <netdb.h>
 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>
 
 static const char cmdflags[NUMBER_OF_CMD]
@@ -156,26 +157,61 @@ void register_proto(struct ctproto_handler *h)
 	list_add(&h->head, &proto_list);
 }
 
-static struct ctproto_handler *findproto(char *name)
+extern struct ctproto_handler ct_proto_unknown;
+
+static struct ctproto_handler *findproto(char *name, int *pnum)
 {
 	struct ctproto_handler *cur;
+	struct protoent *pent;
+	int protonum;
 
-	if (!name) 
-		return NULL;
-
+	/* is it in the list of supported protocol? */
 	list_for_each_entry(cur, &proto_list, head) {
-		if (strcmp(cur->name, name) == 0)
+		if (strcmp(cur->name, name) == 0) {
+			*pnum = cur->protonum;
 			return cur;
+		}
+	}
+	/* using the protocol name for an unsupported protocol? */
+	if ((pent = getprotobyname(name))) {
+		*pnum = pent->p_proto;
+		return &ct_proto_unknown;
+	}
+	/* using a protocol number? */
+	protonum = atoi(name);
+	if (protonum > 0 && protonum <= IPPROTO_MAX) {
+		/* try lookup by number, perhaps this protocol is supported */
+		list_for_each_entry(cur, &proto_list, head) {
+			if (cur->protonum == protonum) {
+				*pnum = protonum;
+				return cur;
+			}
+		}
+		*pnum = protonum;
+		return &ct_proto_unknown;
 	}
 
 	return NULL;
 }
 
 static void
-extension_help(struct ctproto_handler *h)
+extension_help(struct ctproto_handler *h, int protonum)
 {
-	fprintf(stdout, "\n");
-	fprintf(stdout, "Proto `%s' help:\n", h->name);
+	const char *name;
+
+	if (h == &ct_proto_unknown) {
+		struct protoent *pent;
+
+		pent = getprotobynumber(protonum);
+		if (!pent)
+			name = h->name;
+		else
+			name = pent->p_name;
+	} else {
+		name = h->name;
+	}
+
+	fprintf(stdout, "Proto `%s' help:\n", name);
 	h->help();
 }
 
@@ -908,7 +944,7 @@ int main(int argc, char *argv[])
 	struct nf_conntrack *mask = (struct nf_conntrack *)(void*) __mask;
 	char __exp[nfexp_maxsize()];
 	struct nf_expect *exp = (struct nf_expect *)(void*) __exp;
-	int l3protonum;
+	int l3protonum, protonum = 0;
 	union ct_address ad;
 	unsigned int command = 0;
 
@@ -921,6 +957,7 @@ int main(int argc, char *argv[])
 	register_udp();
 	register_icmp();
 	register_icmpv6();
+	register_unknown();
 
 	/* disable explicit missing arguments error output from getopt_long */
 	opterr = 0;
@@ -990,7 +1027,7 @@ int main(int argc, char *argv[])
 			break;
 		case 'p':
 			options |= CT_OPT_PROTO;
-			h = findproto(optarg);
+			h = findproto(optarg, &protonum);
 			if (!h)
 				exit_error(PARAMETER_PROBLEM,
 					   "`%s' unsupported protocol",
@@ -999,6 +1036,8 @@ int main(int argc, char *argv[])
 			opts = merge_options(opts, h->opts, &h->option_offset);
 			if (opts == NULL)
 				exit_error(OTHER_PROBLEM, "out of memory");
+
+			nfct_set_attr_u8(obj, ATTR_L4PROTO, protonum);
 			break;
 		case 't':
 			options |= CT_OPT_TIMEOUT;
@@ -1090,11 +1129,6 @@ int main(int argc, char *argv[])
 	if (family == AF_UNSPEC)
 		family = AF_INET;
 
-	/* set the protocol number if we have seen -p with no parameters */
-	if (h && !nfct_attr_is_set(obj, ATTR_ORIG_L4PROTO) &&
-	    !nfct_attr_is_set(obj, ATTR_REPL_L4PROTO))
-		nfct_set_attr_u8(obj, ATTR_L4PROTO, h->protonum);
-
 	cmd = bit2cmd(command);
 	generic_cmd_check(cmd, options);
 	generic_opt_check(options,
@@ -1304,7 +1338,7 @@ int main(int argc, char *argv[])
 	case CT_HELP:
 		usage(argv[0]);
 		if (options & CT_OPT_PROTO)
-			extension_help(h);
+			extension_help(h, protonum);
 		break;
 	default:
 		usage(argv[0]);

--------------040901060806090604080402--
