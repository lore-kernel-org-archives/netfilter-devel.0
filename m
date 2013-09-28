From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH 2/2] ipset: Add userspace code to support hash:net,port,net kernel module.
Date: Sat, 28 Sep 2013 20:20:01 +0200
Message-ID: <1380392401-53264-2-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1380392401-53264-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:52271 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3I1SVJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:21:09 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 78241A28EA
	for <netfilter-devel@vger.kernel.org>; Sat, 28 Sep 2013 19:21:08 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id v3xtGP8YakcQ for <netfilter-devel@vger.kernel.org>;
	Sat, 28 Sep 2013 19:20:03 +0100 (BST)
In-Reply-To: <1380392401-53264-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds the userspace library, tests to validate correct operation of
the module and also provides appropriate usage information in the man
page.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 lib/Makefile.am                   |   1 +
 lib/ipset_hash_netportnet.c       | 191 ++++++++++++++++++++++++++++++++++++++
 src/ipset.8                       |  62 +++++++++++++
 tests/hash:net,port,net.t         | 183 ++++++++++++++++++++++++++++++++++++
 tests/hash:net,port,net.t.list0   |  10 ++
 tests/hash:net6,port,net6.t       | 143 ++++++++++++++++++++++++++++
 tests/hash:net6,port,net6.t.list0 |  10 ++
 tests/resizen.sh                  |  13 +++
 tests/resizet.sh                  |   8 ++
 tests/runtest.sh                  |   1 +
 10 files changed, 622 insertions(+)
 create mode 100644 lib/ipset_hash_netportnet.c
 create mode 100644 tests/hash:net,port,net.t
 create mode 100644 tests/hash:net,port,net.t.list0
 create mode 100644 tests/hash:net6,port,net6.t
 create mode 100644 tests/hash:net6,port,net6.t.list0

diff --git a/lib/Makefile.am b/lib/Makefile.am
index 32fc820..2234670 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -10,6 +10,7 @@ IPSET_SETTYPE_LIST = \
 	ipset_hash_ipportnet.c \
 	ipset_hash_net.c \
 	ipset_hash_netnet.c \
+	ipset_hash_netportnet.c \
 	ipset_hash_netport.c \
 	ipset_hash_netiface.c \
 	ipset_list_set.c
diff --git a/lib/ipset_hash_netportnet.c b/lib/ipset_hash_netportnet.c
new file mode 100644
index 0000000..728c4a3
--- /dev/null
+++ b/lib/ipset_hash_netportnet.c
@@ -0,0 +1,191 @@
+/* Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <libipset/data.h>			/* IPSET_OPT_* */
+#include <libipset/parse.h>			/* parser functions */
+#include <libipset/print.h>			/* printing functions */
+#include <libipset/ui.h>			/* ipset_port_usage */
+#include <libipset/types.h>			/* prototypes */
+
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netportnet_create_args0[] = {
+	{ .name = { "family", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,		.print = ipset_print_family,
+	},
+	/* Alias: family inet */
+	{ .name = { "-4", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	/* Alias: family inet6 */
+	{ .name = { "-6", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_FAMILY,
+	  .parse = ipset_parse_family,
+	},
+	{ .name = { "hashsize", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_HASHSIZE,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "maxelem", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_MAXELEM,
+	  .parse = ipset_parse_uint32,		.print = ipset_print_number,
+	},
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "counters", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_COUNTERS,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_CREATE_COMMENT,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_netportnet_add_args0[] = {
+	{ .name = { "timeout", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_TIMEOUT,
+	  .parse = ipset_parse_timeout,		.print = ipset_print_number,
+	},
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ .name = { "packets", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_PACKETS,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "bytes", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_BYTES,
+	  .parse = ipset_parse_uint64,		.print = ipset_print_number,
+	},
+	{ .name = { "comment", NULL },
+	  .has_arg = IPSET_MANDATORY_ARG,	.opt = IPSET_OPT_ADT_COMMENT,
+	  .parse = ipset_parse_comment,		.print = ipset_print_comment,
+	},
+	{ },
+};
+
+static const struct ipset_arg hash_netportnet_test_args0[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_netportnet_usage0[] =
+"create SETNAME hash:net,port,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters] [comment]\n"
+"add    SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR] [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE] [comment \"string\"]\n"
+"del    SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR]\n"
+"test   SETNAME IP[/CIDR],PROTO:PORT,IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP are valid IPv4 or IPv6 addresses (or hostnames),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements in IP/CIDR or FROM-TO form\n"
+"      in both IP components are supported for IPv4.\n"
+"      Adding/deleting multiple elements with TCP/SCTP/UDP/UDPLITE\n"
+"      port range is supported both for IPv4 and IPv6.\n";
+
+static struct ipset_type ipset_hash_netportnet0 = {
+	.name = "hash:net,port,net",
+	.alias = { "netportnethash", NULL },
+	.revision = 0,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_THREE,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_proto_port,
+			.print = ipset_print_proto_port,
+			.opt = IPSET_OPT_PORT
+		},
+		[IPSET_DIM_THREE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netportnet_create_args0,
+		[IPSET_ADD] = hash_netportnet_add_args0,
+		[IPSET_TEST] = hash_netportnet_test_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS)
+			| IPSET_FLAG(IPSET_OPT_CREATE_COMMENT),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES)
+			| IPSET_FLAG(IPSET_OPT_ADT_COMMENT),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PORT_TO)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_PORT)
+			| IPSET_FLAG(IPSET_OPT_PROTO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netportnet_usage0,
+	.usagefn = ipset_port_usage,
+	.description = "initial revision",
+};
+
+void _init(void);
+void _init(void)
+{
+	ipset_type_add(&ipset_hash_netportnet0);
+}
diff --git a/src/ipset.8 b/src/ipset.8
index 20fb4d4..08b1d8a 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -878,6 +878,68 @@ ipset add foo 192.168.1,80,10.0.0/24
 ipset add foo 192.168.2,25,10.1.0.0/16
 .IP 
 ipset test foo 192.168.1,80.10.0.0/24
+.SS hash:net,port,net
+The \fBhash:net,port,net\fR set type behaves similarly to hash:ip,port,net but accepts a
+cidr value for both the first and last parameter. Either subnet is permitted to be a /0
+should you wish to match port between all destinations.
+.PP 
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ]
+.PP 
+\fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fInetaddr\fR
+.PP 
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]  [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ] [ \fBcomment\fR \fIstring\fR ]
+.PP 
+\fIDEL\-ENTRY\fR := \fInetaddr\fR,[\fIproto\fR:]\fIport\fR,\fInetaddr\fR
+.PP 
+\fITEST\-ENTRY\fR := \fInetaddr\fR,[\fIproto\fR:]\fIport\fR,\fInetaddr\fR
+.PP 
+where
+\fInetaddr\fR := \fIip\fR[/\fIcidr\fR]
+.PP 
+For the [\fIproto\fR:]\fIport\fR
+part of the elements see the description at the
+\fBhash:ip,port\fR set type. For the \fInetaddr\fR part of the elements
+see the description at the \fBhash:net\fR set type.
+.PP 
+Optional \fBcreate\fR options:
+.TP 
+\fBfamily\fR { \fBinet\fR | \fBinet6\fR }
+The protocol family of the IP addresses to be stored in the set. The default is
+\fBinet\fR, i.e IPv4.
+.TP 
+\fBhashsize\fR \fIvalue\fR
+The initial hash size for the set, default is 1024. The hash size must be a power
+of two, the kernel automatically rounds up non power of two hash sizes to the first
+correct value.
+.TP 
+\fBmaxelem\fR \fIvalue\fR
+The maximal number of elements which can be stored in the set, default 65536.
+.PP 
+From the \fBset\fR netfilter match point of view the searching for a match
+always  starts  from  the smallest  size  of netblock (most specific
+cidr) to the largest one (least specific cidr) added to the set.
+When  adding/deleting triples
+to the set by the \fBSET\fR netfilter target, it  will  be
+added/deleted by the most specific cidr which can be found in  the
+set, or by the host cidr value if the set is empty. The first subnet has
+precedence when performing the most-specific lookup, just as for hash:net,net
+.PP 
+The lookup time grows linearly with the number of the different \fIcidr\fR
+values added to the set and by the number of secondary \fIcidr\fR values per
+primary.
+.PP 
+The \fBhash:net,port,net\fR type of sets require three \fBsrc\fR/\fBdst\fR parameters of
+the \fBset\fR match and \fBSET\fR target kernel modules.
+.PP 
+Examples:
+.IP 
+ipset create foo hash:net,port,net
+.IP 
+ipset add foo 192.168.1.0/24,0,10.0.0/24
+.IP 
+ipset add foo 192.168.2.0/24,25,10.1.0.0/16
+.IP 
+ipset test foo 192.168.1.1,80,10.0.0.1
 .SS hash:net,iface
 The \fBhash:net,iface\fR set type uses a hash to store different sized IP network
 address and interface name pairs.
diff --git a/tests/hash:net,port,net.t b/tests/hash:net,port,net.t
new file mode 100644
index 0000000..4b55631
--- /dev/null
+++ b/tests/hash:net,port,net.t
@@ -0,0 +1,183 @@
+# Create a set with timeout
+0 ipset create test hash:net,port,net timeout 5
+# Add partly zero valued element
+0 ipset add test 2.0.0.1/24,0,192.168.0.0/24
+# Test partly zero valued element
+0 ipset test test 2.0.0.1/24,0,192.168.0.0/24
+# Delete partly zero valued element
+0 ipset del test 2.0.0.1/24,0,192.168.0.0/24
+# Add first random value
+0 ipset add test 2.0.0.1/24,5,192.168.0.0/24
+# Add second random value
+0 ipset add test 2.1.0.0/24,128,10.0.0.0/16
+# Test first random value
+0 ipset test test 2.0.0.1,5,192.168.0.1
+# Test second random value
+0 ipset test test 2.1.0.0,128,10.0.1.1
+# Test value not added to the set
+1 ipset test test 2.5.0.1,4,10.0.0.1
+# Delete value not added to the set
+1 ipset del test 2.0.0.1/8,6,10.0.0.0/16
+# Test value before first random value
+1 ipset test test 2.0.0.0/25,5,192.168.0.0/24
+# Test value after second random value
+1 ipset test test 2.4.0.1,128,10.0.0.100
+# Try to add value before first random value
+0 ipset add test 2.0.0.0/24,5,192.168.0.0/25
+# Try to add value after second random value
+0 ipset add test 2.1.0.1,128,10.0.0.0/17
+# List set
+0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net,port,net.t.list0
+# Sleep 5s so that elements can time out
+0 sleep 5
+# List set
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Flush test set
+0 ipset flush test
+# Delete set
+0 ipset destroy test
+# Create set to add a range
+0 ipset new test hash:net,port,net hashsize 64
+# Add a range
+0 ipset add test 10.0.0.0-10.0.3.255,tcp:80-82,192.168.0.1/24
+# Check that correct number of elements are added
+0 n=`ipset list test|grep '^10.0'|wc -l` && test $n -eq 3
+# Destroy set
+0 ipset -X test
+# Create set to add a range and with range notation in the network
+0 ipset new test hash:net,port,net hashsize 64
+# Add a range which forces a resizing
+0 ipset add test 10.0.0.0-10.0.3.255,tcp:80-82,192.168.0.0-192.168.2.255
+# Check that correct number of elements are added
+0 n=`ipset list test|grep '^10.0'|wc -l` && test $n -eq 6
+# Destroy set
+0 ipset -X test
+# Create test set with timeout support
+0 ipset create test hash:net,port,net timeout 30
+# Add a non-matching IP address entry
+0 ipset -A test 2.2.2.2,80,1.1.1.1 nomatch
+# Add an overlapping matching small net
+0 ipset -A test 2.2.2.2,80,1.1.1.0/30
+# Add an overlapping non-matching larger net
+0 ipset -A test 2.2.2.2,80,1.1.1.0/28 nomatch
+# Add an even larger matching net
+0 ipset -A test 2.2.2.2,80,1.1.1.0/26
+# Check non-matching IP
+1 ipset -T test 2.2.2.2,80,1.1.1.1
+# Check matching IP from non-matchin small net
+0 ipset -T test 2.2.2.2,80,1.1.1.3
+# Check non-matching IP from larger net
+1 ipset -T test 2.2.2.2,80,1.1.1.4
+# Check matching IP from even larger net
+0 ipset -T test 2.2.2.2,80,1.1.1.16
+# Update non-matching IP to matching one
+0 ipset -! -A test 2.2.2.2,80,1.1.1.1
+# Delete overlapping small net
+0 ipset -D test 2.2.2.2,80,1.1.1.0/30
+# Check matching IP
+0 ipset -T test 2.2.2.2,80,1.1.1.1
+# Add overlapping small net
+0 ipset -A test 2.2.2.2,80,1.1.1.0/30
+# Update matching IP as a non-matching one, with shorter timeout
+0 ipset -! -A test 2.2.2.2,80,1.1.1.1 nomatch timeout 2
+# Check non-matching IP
+1 ipset -T test 2.2.2.2,80,1.1.1.1
+# Sleep 3s so that element can time out
+0 sleep 3
+# Check non-matching IP
+0 ipset -T test 2.2.2.2,80,1.1.1.1
+# Check matching IP
+0 ipset -T test 2.2.2.2,80,1.1.1.3
+# Delete test set
+0 ipset destroy test
+# Create set
+0 ipset create test hash:net,port,net
+# Add a single element
+0 ipset add test 10.0.0.1,tcp:80,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 2
+# Delete the single element
+0 ipset del test 10.0.0.1,tcp:80,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Add an IP range
+0 ipset add test 10.0.0.1-10.0.0.10,tcp:80,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 6
+# Delete the IP range
+0 ipset del test 10.0.0.1-10.0.0.10,tcp:80,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Add a port range
+0 ipset add test 10.0.0.1,tcp:80-89,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 11
+# Delete the port range
+0 ipset del test 10.0.0.1,tcp:80-89,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Add an IP and port range
+0 ipset add test 10.0.0.1-10.0.0.10,tcp:80-89,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 51
+# Delete the IP and port range
+0 ipset del test 10.0.0.1-10.0.0.10,tcp:80-89,2.2.2.0/24
+# Check number of elements
+0 n=`ipset save test|wc -l` && test $n -eq 1
+# Destroy set
+0 ipset -X test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -4 netportnet
+# Nomatch: Check that resizing keeps the nomatch flag
+0 ./resizen.sh -4 netportnet
+# Counters: create set
+0 ipset n test hash:net,port,net counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.1,80,192.168.199.200 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2.0.0.1,80,192.168.199.200
+# Counters: check counters
+0 ./check_counters test 2.0.0.1 5 3456
+# Counters: delete element
+0 ipset d test 2.0.0.1,80,192.168.199.200
+# Counters: test deleted element
+1 ipset t test 2.0.0.1,80,192.168.199.200
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.20,453,10.0.0.1 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2.0.0.20 12 9876
+# Counters: update counters
+0 ipset -! a test 2.0.0.20,453,10.0.0.1 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2.0.0.20 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:net,port,net counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.1,80,192.168.199.200 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2.0.0.1,80,192.168.199.200
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.1 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2.0.0.1,80,192.168.199.200
+# Counters and timeout: test deleted element
+1 ipset t test 2.0.0.1,80,192.168.199.200
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.20,453,10.0.0.1 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2.0.0.20,453,10.0.0.1 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2.0.0.20,453,10.0.0.1 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.20 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:net,port,net.t.list0 b/tests/hash:net,port,net.t.list0
new file mode 100644
index 0000000..0d90e62
--- /dev/null
+++ b/tests/hash:net,port,net.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:net,port,net
+Header: family inet hashsize 1024 maxelem 65536 timeout x
+Size in memory: 17672
+References: 0
+Members:
+2.0.0.0/24,tcp:5,192.168.0.0/24 timeout x
+2.0.0.0/24,tcp:5,192.168.0.0/25 timeout x
+2.1.0.0/24,tcp:128,10.0.0.0/16 timeout x
+2.1.0.1,tcp:128,10.0.0.0/17 timeout x
diff --git a/tests/hash:net6,port,net6.t b/tests/hash:net6,port,net6.t
new file mode 100644
index 0000000..63587e3
--- /dev/null
+++ b/tests/hash:net6,port,net6.t
@@ -0,0 +1,143 @@
+# Range: Create a set
+0 ipset -N test netportnethash -6
+# Range: Add zero valued element
+1 ipset -A test 2:0:0::1/24,0,0:0:0::0/0
+# Range: Test zero valued element
+1 ipset -T test 2:0:0::1/24,0,0:0:0::0/0
+# Range: Delete zero valued element
+1 ipset -D test 2:0:0::1,0,0:0:0::0/0
+# Range: Add almost zero valued element
+0 ipset -A test 2:0:0::1,0,0:0:0::0/24
+# Range: Test almost zero valued element
+0 ipset -T test 2:0:0::1,0,0:0:0::0/24
+# Range: Delete almost zero valued element
+0 ipset -D test 2:0:0::1,0,0:0:0::0/24
+# Range: Add first random value
+0 ipset -A test 2:0:0::1,5,1:1:1::1/24
+# Range: Add second random value
+0 ipset -A test 2:1:0::0,128,2:2:2::2/12
+# Range: Test first random value
+0 ipset -T test 2:0:0::1,5,1:1:1::2
+# Range: Test second random value
+0 ipset -T test 2:1:0::0,128,2:2:2::0
+# Range: Test value not added to the set
+1 ipset -T test 2:0:0::1,5,2:1:1::255
+# Range: Test value not added to the set
+1 ipset -T test 2:0:0::1,6,1:1:1::1
+# Range: Test value not added to the set
+1 ipset -T test 2:0:0::2,6,1:1:1::1
+# Range: Test value before first random value
+1 ipset -T test 2:0:0::0,5,1:1:1::1
+# Range: Test value after second random value
+1 ipset -T test 2:1:0::1,128,2:2:2::2
+# Range: Try to add value before first random value
+0 ipset -A test 2:0:0::0,5,1:1:1::1/24
+# Range: Try to add value after second random value
+0 ipset -A test 2:1:0::1,128,2:2:2::2/12
+# Range: List set
+0 ipset -L test | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Range: Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net6,port,net6.t.list0
+# Range: Flush test set
+0 ipset -F test
+# Range: Delete test set
+0 ipset -X test
+# Create set to add a range
+0 ipset new test hash:net,port,net -6 hashsize 64
+# Add a range which forces a resizing
+0 ipset add test 1::1,tcp:80-1105,2::2/12
+# Check that correct number of elements are added
+0 n=`ipset list test|grep 1::1|wc -l` && test $n -eq 1026
+# Destroy set
+0 ipset -X test
+# Create test set with timeout support
+0 ipset create test hash:net,port,net family inet6 timeout 30
+# Add a non-matching IP address entry
+0 ipset -A test 2:2:2::2,80,1:1:1::1 nomatch
+# Add an overlapping matching small net
+0 ipset -A test 2:2:2::2,80,1:1:1::/124
+# Add an overlapping non-matching larger net
+0 ipset -A test 2:2:2::2,80,1:1:1::/120 nomatch
+# Add an even larger matching net
+0 ipset -A test 2:2:2::2,80,1:1:1::/116
+# Check non-matching IP
+1 ipset -T test 2:2:2::2,80,1:1:1::1
+# Check matching IP from non-matchin small net
+0 ipset -T test 2:2:2::2,80,1:1:1::F
+# Check non-matching IP from larger net
+1 ipset -T test 2:2:2::2,80,1:1:1::10
+# Check matching IP from even larger net
+0 ipset -T test 2:2:2::2,80,1:1:1::100
+# Update non-matching IP to matching one
+0 ipset -! -A test 2:2:2::2,80,1:1:1::1
+# Delete overlapping small net
+0 ipset -D test 2:2:2::2,80,1:1:1::/124
+# Check matching IP
+0 ipset -T test 2:2:2::2,80,1:1:1::1
+# Add overlapping small net
+0 ipset -A test 2:2:2::2,80,1:1:1::/124
+# Update matching IP as a non-matching one, with shorter timeout
+0 ipset -! -A test 2:2:2::2,80,1:1:1::1 nomatch timeout 2
+# Check non-matching IP
+1 ipset -T test 2:2:2::2,80,1:1:1::1
+# Sleep 3s so that element can time out
+0 sleep 3
+# Check non-matching IP
+0 ipset -T test 2:2:2::2,80,1:1:1::1
+# Check matching IP
+0 ipset -T test 2:2:2::2,80,1:1:1::F
+# Delete test set
+0 ipset destroy test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -6 netportnet
+# Nomatch: Check that resizing keeps the nomatch flag
+0 ./resizen.sh -6 netportnet
+# Counters: create set
+0 ipset n test hash:net,port,net -6 counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::1,80,2002:24:ff::1/64 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2:0:0::1,80,2002:24:ff::1/64
+# Counters: check counters
+0 ./check_counters test 2::1 5 3456
+# Counters: delete element
+0 ipset d test 2:0:0::1,80,2002:24:ff::1/64
+# Counters: test deleted element
+1 ipset t test 2:0:0::1,80,2002:24:ff::1/64
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::20,453,2002:ff:24::ab/54 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2::20 12 9876
+# Counters: update counters
+0 ipset -! a test 2:0:0::20,453,2002:ff:24::ab/54 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2::20 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:net,port,net -6 counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::1,80,2002:24:ff::1/64 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2:0:0::1,80,2002:24:ff::1/64
+# Counters and timeout: check counters
+0 ./check_extensions test 2::1 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2:0:0::1,80,2002:24:ff::1/64
+# Counters and timeout: test deleted element
+1 ipset t test 2:0:0::1,80,2002:24:ff::1/64
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::20,453,2002:ff:24::ab/54 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2:0:0::20,453,2002:ff:24::ab/54 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2:0:0::20,453,2002:ff:24::ab/54 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2::20 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:net6,port,net6.t.list0 b/tests/hash:net6,port,net6.t.list0
new file mode 100644
index 0000000..8a927ec
--- /dev/null
+++ b/tests/hash:net6,port,net6.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:net,port,net
+Header: family inet6 hashsize 1024 maxelem 65536
+Size in memory: 18824
+References: 0
+Members:
+2:1::,tcp:128,::/12
+2:1::1,tcp:128,::/12
+2::,tcp:5,1::/24
+2::1,tcp:5,1::/24
diff --git a/tests/resizen.sh b/tests/resizen.sh
index f473b0b..9ceee88 100644
--- a/tests/resizen.sh
+++ b/tests/resizen.sh
@@ -34,6 +34,19 @@ case "$2" in
     	    done
     	done
     	;;
+    netportnet)
+    	$ipset n test hash:net,port,net $1 hashsize 64
+    	for x in `seq 0 16`; do
+    	    for y in `seq 0 255`; do
+    	    	$ipset a test $ip$x$sep$y,1023,$ip2/$net nomatch
+    	    done
+    	done
+    	for x in `seq 0 16`; do
+    	    for y in `seq 0 255`; do
+    	    	$ipset t test $ip$x$sep$y,1023,$ip2/$net nomatch 2>/dev/null
+    	    done
+    	done
+    	;;
     net)
     	$ipset n test hash:net $1 hashsize 64
     	for x in `seq 0 16`; do
diff --git a/tests/resizet.sh b/tests/resizet.sh
index ff98d58..c121357 100644
--- a/tests/resizet.sh
+++ b/tests/resizet.sh
@@ -53,6 +53,14 @@ case "$2" in
     	    done
     	done
     	;;
+    netportnet)
+    	$ipset n test hash:net,port,net $1 hashsize 64 timeout 100
+    	for x in `seq 0 16`; do
+    	    for y in `seq 0 128`; do
+    	    	$ipset a test $ip$x$sep$y/$net,1023,$ip$y$sep$x/$net
+    	    done
+    	done
+    	;;
     net)
     	$ipset n test hash:net $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
diff --git a/tests/runtest.sh b/tests/runtest.sh
index 64708ac..a82b802 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -10,6 +10,7 @@ tests="$tests ipporthash hash:ip,port hash:ip6,port"
 tests="$tests ipportiphash hash:ip,port,ip hash:ip6,port,ip6"
 tests="$tests nethash hash:net hash:net6 hash:net,port hash:net6,port"
 tests="$tests hash:ip,port,net hash:ip6,port,net6 hash:net,net hash:net6,net6"
+tests="$tests hash:net,port,net hash:net6,port,net6"
 tests="$tests hash:net,iface.t"
 tests="$tests comment setlist restore"
 # tests="$tests iptree iptreemap"
-- 
1.8.3.2

