From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: [PATCH v2 2/2] ipset: Add userspace code to support hash:net,net kernel module.
Date: Fri, 20 Sep 2013 10:13:54 +0200
Message-ID: <1379664834-41326-3-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
References: <1379664834-41326-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:44999 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3ITIQb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Sep 2013 04:16:31 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 6955BA3419
	for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2013 09:16:30 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id 5J7GI_3vfx6m for <netfilter-devel@vger.kernel.org>;
	Fri, 20 Sep 2013 09:15:05 +0100 (BST)
In-Reply-To: <1379664834-41326-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>

This adds the userspace library, tests to validate correct operation of
the module and also provides appropriate usage information in the man
page. The library version has been bumped accordingly.

Signed-off-by: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
---
 lib/Makefile.am              |   1 +
 lib/ipset_hash_netnet.c      | 158 ++++++++++++++++++++++++++++++++++++++++
 src/ipset.8                  |  74 +++++++++++++++++++
 tests/hash:net,net.t         | 169 +++++++++++++++++++++++++++++++++++++++++++
 tests/hash:net,net.t.list0   |  10 +++
 tests/hash:net,net.t.list1   |   6 ++
 tests/hash:net,net.t.list2   |  22 ++++++
 tests/hash:net6,net6.t       | 151 ++++++++++++++++++++++++++++++++++++++
 tests/hash:net6,net6.t.list0 |  10 +++
 tests/hash:net6,net6.t.list1 |   6 ++
 tests/netnetgen.sh           |   9 +++
 tests/resizen.sh             |  14 ++++
 tests/resizet.sh             |   8 ++
 tests/runtest.sh             |   2 +-
 14 files changed, 639 insertions(+), 1 deletion(-)
 create mode 100644 lib/ipset_hash_netnet.c
 create mode 100644 tests/hash:net,net.t
 create mode 100644 tests/hash:net,net.t.list0
 create mode 100644 tests/hash:net,net.t.list1
 create mode 100644 tests/hash:net,net.t.list2
 create mode 100644 tests/hash:net6,net6.t
 create mode 100644 tests/hash:net6,net6.t.list0
 create mode 100644 tests/hash:net6,net6.t.list1
 create mode 100755 tests/netnetgen.sh

diff --git a/lib/Makefile.am b/lib/Makefile.am
index ccc02aa..32fc820 100644
--- a/lib/Makefile.am
+++ b/lib/Makefile.am
@@ -9,6 +9,7 @@ IPSET_SETTYPE_LIST = \
 	ipset_hash_ipportip.c \
 	ipset_hash_ipportnet.c \
 	ipset_hash_net.c \
+	ipset_hash_netnet.c \
 	ipset_hash_netport.c \
 	ipset_hash_netiface.c \
 	ipset_list_set.c
diff --git a/lib/ipset_hash_netnet.c b/lib/ipset_hash_netnet.c
new file mode 100644
index 0000000..ea65c8f
--- /dev/null
+++ b/lib/ipset_hash_netnet.c
@@ -0,0 +1,158 @@
+/* Copyright 2007-2010 Jozsef Kadlecsik (kadlec@blackhole.kfki.hu)
+ * Copyright 2013 Oliver Smith (oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+#include <libipset/data.h>			/* IPSET_OPT_* */
+#include <libipset/parse.h>			/* parser functions */
+#include <libipset/print.h>			/* printing functions */
+#include <libipset/types.h>			/* prototypes */
+
+/* Parse commandline arguments */
+static const struct ipset_arg hash_netnet_create_args0[] = {
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
+	{ },
+};
+
+static const struct ipset_arg hash_netnet_add_args0[] = {
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
+	{ },
+};
+
+static const struct ipset_arg hash_netnet_test_args0[] = {
+	{ .name = { "nomatch", NULL },
+	  .has_arg = IPSET_NO_ARG,		.opt = IPSET_OPT_NOMATCH,
+	  .parse = ipset_parse_flag,		.print = ipset_print_flag,
+	},
+	{ },
+};
+
+static const char hash_netnet_usage0[] =
+"create SETNAME hash:net,net\n"
+"		[family inet|inet6]\n"
+"               [hashsize VALUE] [maxelem VALUE]\n"
+"               [timeout VALUE] [counters]\n"
+"add    SETNAME IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO [timeout VALUE] [nomatch]\n"
+"               [packets VALUE] [bytes VALUE]\n"
+"del    SETNAME IP[/CIDR]|FROM-TO,IP[/CIDR]|FROM-TO\n"
+"test   SETNAME IP[/CIDR],IP[/CIDR]\n\n"
+"where depending on the INET family\n"
+"      IP is an IPv4 or IPv6 address (or hostname),\n"
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      IP range is not supported with IPv6.\n";
+
+static struct ipset_type ipset_hash_netnet0 = {
+	.name = "hash:net,net",
+	.alias = { "netnethash", NULL },
+	.revision = 0,
+	.family = NFPROTO_IPSET_IPV46,
+	.dimension = IPSET_DIM_TWO,
+	.elem = {
+		[IPSET_DIM_ONE - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP
+		},
+		[IPSET_DIM_TWO - 1] = {
+			.parse = ipset_parse_ip4_net6,
+			.print = ipset_print_ip,
+			.opt = IPSET_OPT_IP2
+		},
+	},
+	.args = {
+		[IPSET_CREATE] = hash_netnet_create_args0,
+		[IPSET_ADD] = hash_netnet_add_args0,
+		[IPSET_TEST] = hash_netnet_test_args0,
+	},
+	.mandatory = {
+		[IPSET_CREATE] = 0,
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_IP2),
+	},
+	.full = {
+		[IPSET_CREATE] = IPSET_FLAG(IPSET_OPT_HASHSIZE)
+			| IPSET_FLAG(IPSET_OPT_MAXELEM)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_COUNTERS),
+		[IPSET_ADD] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO)
+			| IPSET_FLAG(IPSET_OPT_TIMEOUT)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH)
+			| IPSET_FLAG(IPSET_OPT_PACKETS)
+			| IPSET_FLAG(IPSET_OPT_BYTES),
+		[IPSET_DEL] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP_TO)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_IP2_TO),
+		[IPSET_TEST] = IPSET_FLAG(IPSET_OPT_IP)
+			| IPSET_FLAG(IPSET_OPT_CIDR)
+			| IPSET_FLAG(IPSET_OPT_IP2)
+			| IPSET_FLAG(IPSET_OPT_CIDR2)
+			| IPSET_FLAG(IPSET_OPT_NOMATCH),
+	},
+
+	.usage = hash_netnet_usage0,
+	.description = "initial revision",
+};
+
+void _init(void);
+void _init(void)
+{
+	ipset_type_add(&ipset_hash_netnet0);
+}
diff --git a/src/ipset.8 b/src/ipset.8
index d7fa964..b53e94d 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -534,6 +534,80 @@ ipset add foo 192.168.0/30 nomatch
 When matching the elements in the set above, all IP addresses will match
 from the networks 192.168.0.0/24, 10.1.0.0/16 and 192.168.0/24 except
 the ones from 192.168.0/30.
+.SS hash:net,net
+The \fBhash:net,net\fR set type uses a hash to store pairs of different sized IP
+network addresses.  Bear  in  mind  that  the  first parameter has precedence
+over the second, so a nomatch entry could be potentially be ineffective if a more specific
+first parameter existed with a suitable second parameter.
+Network address with zero prefix size cannot be stored in this type of set.
+.PP
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ]
+.PP
+\fIADD\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
+.PP
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ] [ \fBnomatch\fR ] [ \fBpackets\fR \fIvalue\fR ] [ \fBbytes\fR \fIvalue\fR ]
+.PP
+\fIDEL\-ENTRY\fR := \fInetaddr\fR,\fInetaddr\fR
+.PP
+\fITEST\-ENTRY\fR := \fInetaddr\fR,\fInetaddr,\fR
+.PP
+where
+\fInetaddr\fR := \fIip\fR[/\fIcidr\fR]
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
+For the \fBinet\fR family one can add or delete multiple entries by specifying
+a range, which is converted internally to network(s) equal to the range:
+.PP
+\fInetaddr\fR := { \fIip\fR[/\fIcidr\fR] | \fIfromaddr\fR\-\fItoaddr\fR }
+.PP
+When adding/deleting/testing entries, if the cidr prefix parameter is not specified,
+then the host prefix value is assumed. When adding/deleting entries, the exact
+element is added/deleted and overlapping elements are not checked by the kernel.
+When testing entries, if a host address is tested, then the kernel tries to match
+the host address in the networks added to the set and reports the result accordingly.
+.PP
+From the \fBset\fR netfilter match point of view the searching for a match
+always  starts  from  the smallest  size  of netblock (most specific
+prefix) to the largest one (least specific prefix) with the first param
+having precedence.
+When  adding/deleting IP addresses  to the set by the \fBSET\fR netfilter target,
+it  will  be  added/deleted  by  the most specific prefix which can be found in
+the set, or by the host prefix value if the set is empty.
+.PP
+The lookup time grows linearly with the number of the different prefix
+values added to the first parameter of the set. The number of secondary prefixes
+further increases this as the list of secondary prefixes is traversed per primary
+prefix.
+.PP
+Example:
+.IP
+ipset create foo hash:net,net
+.IP
+ipset add foo 192.168.0.0/24,10.0.1.0/24
+.IP
+ipset add foo 10.1.0.0/16,10.255.0.0/24
+.IP
+ipset add foo 192.168.0/24,192.168.54.0-192.168.54.255
+.IP
+ipset add foo 192.168.0/30,192.168.64/30 nomatch
+.PP
+When matching the elements in the set above, all IP addresses will match
+from the networks 192.168.0.0/24<->10.0.1.0/24, 10.1.0.0/16<->10.255.0.0/24
+and 192.168.0/24<->192.168.54.0/24 except the ones from
+192.168.0/30<->192.168.64/30.
 .SS hash:ip,port
 The \fBhash:ip,port\fR set type uses a hash to store IP address and port number pairs.
 The port number is interpreted together with a protocol (default TCP) and zero
diff --git a/tests/hash:net,net.t b/tests/hash:net,net.t
new file mode 100644
index 0000000..b63ff32
--- /dev/null
+++ b/tests/hash:net,net.t
@@ -0,0 +1,169 @@
+# Create a set with timeout
+0 ipset create test hash:net,net hashsize 128 timeout 5
+# Add zero valued element
+1 ipset add test 0.0.0.0/0,0.0.0.0/0
+# Test zero valued element
+1 ipset test test 0.0.0.0/0,0.0.0.0/0
+# Delete zero valued element
+1 ipset del test 0.0.0.0/0,0.0.0.0/0
+# Try to add /0
+1 ipset add test 1.1.1.1/0,1.1.1.1/0
+# Try to add /32
+0 ipset add test 1.1.1.1/32,1.1.1.2/32
+# Add almost zero valued element
+0 ipset add test 0.0.0.0/1,0.0.0.0/1
+# Test almost zero valued element
+0 ipset test test 0.0.0.0/1,0.0.0.0/1
+# Delete almost zero valued element
+0 ipset del test 0.0.0.0/1,0.0.0.0/1
+# Test deleted element
+1 ipset test test 0.0.0.0/1,0.0.0.0/1
+# Delete element not added to the set
+1 ipset del test 0.0.0.0/1,0.0.0.0/1
+# Add first random network
+0 ipset add test 2.0.0.1/24,2.0.1.1/24
+# Add second random network
+0 ipset add test 192.168.68.69/27,192.168.129.69/27
+# Test first random value
+0 ipset test test 2.0.0.255,2.0.1.255
+# Test second random value
+0 ipset test test 192.168.68.95,192.168.129.75
+# Test value not added to the set
+1 ipset test test 2.0.1.0,2.0.0.1
+# Try to add IP address
+0 ipset add test 2.0.0.1,2.0.0.2
+# List set
+0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list0
+# Sleep 5s so that element can time out
+0 sleep 5
+# List set
+0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list1
+# Flush test set
+0 ipset flush test
+# Delete test set
+0 ipset destroy test
+# Create test set
+0 ipset new test hash:net,net
+# Add networks in range notation
+0 ipset add test 10.2.0.0-10.2.1.12,10.3.0.0-10.3.1.12
+# List set
+0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net,net.t.list2
+# Delete test set
+0 ipset destroy test
+# Stress test with range notation
+0 ./netnetgen.sh | ipset restore
+# List set and check the number of elements
+0 n=`ipset -L test|grep '^10.'|wc -l` && test $n -eq 87040
+# Destroy test set
+0 ipset destroy test
+# Create test set with timeout support
+0 ipset create test hash:net,net timeout 30
+# Add a non-matching IP address entry
+0 ipset -A test 1.1.1.1,1.1.1.2 nomatch
+# Add an overlapping matching small net
+0 ipset -A test 1.1.1.0/30,1.1.1.0/30
+# Add an overlapping non-matching larger net
+0 ipset -A test 1.1.1.0/28,1.1.1.0/28 nomatch
+# Add an even larger matching net
+0 ipset -A test 1.1.1.0/26,1.1.1.0/26
+# Check non-matching IP
+1 ipset -T test 1.1.1.1,1.1.1.2
+# Check matching IP from non-matchin small net
+0 ipset -T test 1.1.1.3,1.1.1.2
+# Check non-matching IP from larger net
+1 ipset -T test 1.1.1.4,1.1.1.4
+# Check matching IP from even larger net
+0 ipset -T test 1.1.1.16,1.1.1.16
+# Update non-matching IP to matching one
+0 ipset -! -A test 1.1.1.1,1.1.1.2
+# Delete overlapping small net
+0 ipset -D test 1.1.1.0/30,1.1.1.0/30
+# Check matching IP
+0 ipset -T test 1.1.1.1,1.1.1.2
+# Add overlapping small net
+0 ipset -A test 1.1.1.0/30,1.1.1.0/30
+# Update matching IP as a non-matching one, with shorter timeout
+0 ipset -! -A test 1.1.1.1,1.1.1.2 nomatch timeout 2
+# Check non-matching IP
+1 ipset -T test 1.1.1.1,1.1.1.2
+# Sleep 3s so that element can time out
+0 sleep 3
+# Check non-matching IP
+0 ipset -T test 1.1.1.1,1.1.1.2
+# Check matching IP
+0 ipset -T test 1.1.1.3,1.1.1.2
+# flush ipset
+0 ipset -F test
+# Add matching IP
+0 ipset -A test 10.0.0.0/16,192.168.0.0/24
+# Add more-specific non-matching IP
+0 ipset -A test 10.0.0.0/24,192.168.0.0/24 nomatch
+# Add even more-specific matching IP
+0 ipset -A test 10.0.0.0/30,192.168.0.0/23
+# Check non-matching IP
+1 ipset -T test 10.0.0.10,192.168.0.1
+# Check non-matching IP with nomatch specified
+0 ipset -T test 10.0.0.10,192.168.0.1 nomatch
+# Check matching IP
+0 ipset -T test 10.0.0.1,192.168.0.1
+# Delete test set
+0 ipset destroy test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -4 netnet
+# Nomatch: Check that resizing keeps the nomatch flag
+0 ./resizen.sh -4 netnet
+# Counters: create set
+0 ipset n test hash:net,net counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.1/24,2.0.0.1/24 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2.0.0.1/24,2.0.0.1/24
+# Counters: check counters
+0 ./check_counters test 2.0.0.0/24,2.0.0.0/24 5 3456
+# Counters: delete element
+0 ipset d test 2.0.0.1/24,2.0.0.1/24
+# Counters: test deleted element
+1 ipset t test 2.0.0.1/24,2.0.0.1/24
+# Counters: add element with packet, byte counters
+0 ipset a test 2.0.0.20/25,2.0.0.20/25 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2.0.0.0/25,2.0.0.0/25 12 9876
+# Counters: update counters
+0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2.0.0.0/25,2.0.0.0/25 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:net,net counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.1/24,2.0.0.1/24 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2.0.0.1/24,2.0.0.1/24
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.0/24,2.0.0.0/24 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2.0.0.1/24,2.0.0.1/24
+# Counters and timeout: test deleted element
+1 ipset t test 2.0.0.1/24,2.0.0.1/24
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2.0.0.20/25,2.0.0.20/25 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2.0.0.20/25,2.0.0.20/25 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2.0.0.0/25,2.0.0.0/25 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:net,net.t.list0 b/tests/hash:net,net.t.list0
new file mode 100644
index 0000000..b759316
--- /dev/null
+++ b/tests/hash:net,net.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:net,net
+Header: family inet hashsize 128 maxelem 65536 timeout x
+Size in memory: 3040
+References: 0
+Members:
+1.1.1.1,1.1.1.2 timeout x
+192.168.68.64/27,192.168.129.64/27 timeout x
+2.0.0.0/24,2.0.1.0/24 timeout x
+2.0.0.1,2.0.0.2 timeout x
diff --git a/tests/hash:net,net.t.list1 b/tests/hash:net,net.t.list1
new file mode 100644
index 0000000..d27b4a4
--- /dev/null
+++ b/tests/hash:net,net.t.list1
@@ -0,0 +1,6 @@
+Name: test
+Type: hash:net,net
+Header: family inet hashsize 128 maxelem 65536 timeout 5
+Size in memory: 3040
+References: 0
+Members:
diff --git a/tests/hash:net,net.t.list2 b/tests/hash:net,net.t.list2
new file mode 100644
index 0000000..adf26ff
--- /dev/null
+++ b/tests/hash:net,net.t.list2
@@ -0,0 +1,22 @@
+Name: test
+Type: hash:net,net
+Header: family inet hashsize 1024 maxelem 65536
+Size in memory: 17664
+References: 0
+Members:
+10.2.0.0/24,10.3.0.0/24
+10.2.0.0/24,10.3.1.0/29
+10.2.0.0/24,10.3.1.12
+10.2.0.0/24,10.3.1.8/30
+10.2.1.0/29,10.3.0.0/24
+10.2.1.0/29,10.3.1.0/29
+10.2.1.0/29,10.3.1.12
+10.2.1.0/29,10.3.1.8/30
+10.2.1.12,10.3.0.0/24
+10.2.1.12,10.3.1.0/29
+10.2.1.12,10.3.1.12
+10.2.1.12,10.3.1.8/30
+10.2.1.8/30,10.3.0.0/24
+10.2.1.8/30,10.3.1.0/29
+10.2.1.8/30,10.3.1.12
+10.2.1.8/30,10.3.1.8/30
diff --git a/tests/hash:net6,net6.t b/tests/hash:net6,net6.t
new file mode 100644
index 0000000..3d6f447
--- /dev/null
+++ b/tests/hash:net6,net6.t
@@ -0,0 +1,151 @@
+# Create a set with timeout
+0 ipset create test hash:net,net family inet6 hashsize 128 timeout 5
+# Add zero valued element
+1 ipset add test ::/0,::/0
+# Test zero valued element
+1 ipset test test ::/0,::/0
+# Delete zero valued element
+1 ipset del test ::/0,::/0
+# Try to add /0
+1 ipset add test 1:1:1::1/0,1:1:1::1/0
+# Try to add /128
+0 ipset add test 1:1:1::1/128,2:2:2::2/128
+# Add almost zero valued element
+0 ipset add test 0:0:0::0/1,0:0:0::0/1
+# Test almost zero valued element
+0 ipset test test 0:0:0::0/1,0:0:0::0/1
+# Delete almost zero valued element
+0 ipset del test 0:0:0::0/1,0:0:0::0/1
+# Test deleted element
+1 ipset test test 0:0:0::0/1,0:0:0::0/1
+# Delete element not added to the set
+1 ipset del test 0:0:0::0/1,0:0:0::0/1
+# Add first random network
+0 ipset add test 2:0:0::1/24,4:0:0::1/32
+# Add second random network
+0 ipset add test 192:168:68::69/27,172:16:68::69/48
+# Test first random value
+0 ipset test test 2:0:0::255,4:0:0::54
+# Test second random value
+0 ipset test test 192:168:68::95,172:16:68::68
+# Test value not added to the set
+1 ipset test test 3:0:0::1,172:255:24::1
+# Try to add IP address
+0 ipset add test 3:0:0::1,8:0:0::1
+# List set
+0 ipset list test | grep -v Revision: | sed 's/timeout ./timeout x/' > .foo0 && ./sort.sh .foo0
+# Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net6,net6.t.list0
+# Sleep 5s so that element can time out
+0 sleep 5
+# IP: List set
+0 ipset -L test 2>/dev/null | grep -v Revision: > .foo0 && ./sort.sh .foo0
+# IP: Check listing
+0 diff -u -I 'Size in memory.*' .foo hash:net6,net6.t.list1
+# Flush test set
+0 ipset flush test
+# Add matching IP address entry
+0 ipset -A test 2001:db8::1/64,2001:db8:fe9::1/126
+# Add more-specific non-matching IP address entry
+0 ipset -A test 2001:db8::1/68,2001:db8:fe9::1/64 nomatch
+# Add even-more-specific matching IP address entry
+0 ipset -A test 2001:db8::1/72,2001:db8:fe9::1/64
+# Check non-matching IP
+1 ipset -T test 2001:db8:0:0:0f00::,2001:db8:fe9::1
+# Check non-matching IP with nomatch
+0 ipset -T test 2001:db8:0:0:0f00::,2001:db8:fe9::1 nomatch
+# Check matching IP
+0 ipset -T test 2001:db8::1,2001:db8:fe9::1
+# Delete test set
+0 ipset destroy test
+# Create test set with timeout support
+0 ipset create test hash:net,net family inet6 timeout 30
+# Add a non-matching IP address entry
+0 ipset -A test 1:1:1::1,2:2:2::2 nomatch
+# Add an overlapping matching small net
+0 ipset -A test 1:1:1::/124,2:2:2::/124
+# Add an overlapping non-matching larger net
+0 ipset -A test 1:1:1::/120,2:2:2::/120 nomatch
+# Add an even larger matching net
+0 ipset -A test 1:1:1::/116,2:2:2::/116
+# Check non-matching IP
+1 ipset -T test 1:1:1::1,2:2:2::2
+# Check matching IP from non-matchin small net
+0 ipset -T test 1:1:1::f,2:2:2::f
+# Check non-matching IP from larger net
+1 ipset -T test 1:1:1::10,2:2:2::10
+# Check matching IP from even larger net
+0 ipset -T test 1:1:1::100,2:2:2::100
+# Update non-matching IP to matching one
+0 ipset -! -A test 1:1:1::1,2:2:2::2
+# Delete overlapping small net
+0 ipset -D test 1:1:1::/124,2:2:2::/124
+# Check matching IP
+0 ipset -T test 1:1:1::1,2:2:2::2
+# Add overlapping small net
+0 ipset -A test 1:1:1::/124,2:2:2::/124
+# Update matching IP as a non-matching one, with shorter timeout
+0 ipset -! -A test 1:1:1::1,2:2:2::2 nomatch timeout 2
+# Check non-matching IP
+1 ipset -T test 1:1:1::1,2:2:2::2
+# Sleep 3s so that element can time out
+0 sleep 3
+# Check non-matching IP
+0 ipset -T test 1:1:1::1,2:2:2::2
+# Check matching IP
+0 ipset -T test 1:1:1::f,2:2:2::f
+# Delete test set
+0 ipset destroy test
+# Timeout: Check that resizing keeps timeout values
+0 ./resizet.sh -6 netnet
+# Nomatch: Check that resizing keeps the nomatch flag
+0 ./resizen.sh -6 netnet
+# Counters: create set
+0 ipset n test hash:net,net -6 counters
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::1/64,3:0:0::1/64 packets 5 bytes 3456
+# Counters: check element
+0 ipset t test 2:0:0::1/64,3:0:0::1/64
+# Counters: check counters
+0 ./check_counters test 2:: 5 3456
+# Counters: delete element
+0 ipset d test 2:0:0::1/64,3:0:0::1/64
+# Counters: test deleted element
+1 ipset t test 2:0:0::1/64,3:0:0::1/64
+# Counters: add element with packet, byte counters
+0 ipset a test 2:0:0::20/54,3:0:0::20/54 packets 12 bytes 9876
+# Counters: check counters
+0 ./check_counters test 2:: 12 9876
+# Counters: update counters
+0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 packets 13 bytes 12479
+# Counters: check counters
+0 ./check_counters test 2:: 13 12479
+# Counters: destroy set
+0 ipset x test
+# Counters and timeout: create set
+0 ipset n test hash:net,net -6 counters timeout 600
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::1/64,3:0:0::1/64 packets 5 bytes 3456
+# Counters and timeout: check element
+0 ipset t test 2:0:0::1/64,3:0:0::1/64
+# Counters and timeout: check counters
+0 ./check_extensions test 2:: 600 5 3456
+# Counters and timeout: delete element
+0 ipset d test 2:0:0::1/64,3:0:0::1/64
+# Counters and timeout: test deleted element
+1 ipset t test 2:0:0::1/64,3:0:0::1/64
+# Counters and timeout: add element with packet, byte counters
+0 ipset a test 2:0:0::20/54,3:0:0::20/54 packets 12 bytes 9876
+# Counters and timeout: check counters
+0 ./check_extensions test 2:: 600 12 9876
+# Counters and timeout: update counters
+0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 packets 13 bytes 12479
+# Counters and timeout: check counters
+0 ./check_extensions test 2:: 600 13 12479
+# Counters and timeout: update timeout
+0 ipset -! a test 2:0:0::20/54,3:0:0::20/54 timeout 700
+# Counters and timeout: check counters
+0 ./check_extensions test 2:: 700 13 12479
+# Counters and timeout: destroy set
+0 ipset x test
+# eof
diff --git a/tests/hash:net6,net6.t.list0 b/tests/hash:net6,net6.t.list0
new file mode 100644
index 0000000..ea78bbb
--- /dev/null
+++ b/tests/hash:net6,net6.t.list0
@@ -0,0 +1,10 @@
+Name: test
+Type: hash:net,net
+Header: family inet6 hashsize 128 maxelem 65536 timeout x
+Size in memory: 4672
+References: 0
+Members:
+192:160::/27,172:16:68::/48 timeout x
+1:1:1::1,2:2:2::2 timeout x
+2::/24,4::/32 timeout x
+3::1,8::1 timeout x
diff --git a/tests/hash:net6,net6.t.list1 b/tests/hash:net6,net6.t.list1
new file mode 100644
index 0000000..0e1b7d2
--- /dev/null
+++ b/tests/hash:net6,net6.t.list1
@@ -0,0 +1,6 @@
+Name: test
+Type: hash:net,net
+Header: family inet6 hashsize 128 maxelem 65536 timeout 5
+Size in memory: 4672
+References: 0
+Members:
diff --git a/tests/netnetgen.sh b/tests/netnetgen.sh
new file mode 100755
index 0000000..e33710e
--- /dev/null
+++ b/tests/netnetgen.sh
@@ -0,0 +1,9 @@
+#!/bin/sh
+
+echo "n test hash:net,net hashsize 32 maxelem 87040"
+for x in `seq 0 255`; do
+    for y in `seq 0 3 253`; do
+	z=$((y+2))
+	echo "a test 10.0.0.0-10.0.2.255,10.$x.$y.0-10.$x.$z.255"
+    done
+done
diff --git a/tests/resizen.sh b/tests/resizen.sh
index 1294efc..f473b0b 100644
--- a/tests/resizen.sh
+++ b/tests/resizen.sh
@@ -47,6 +47,20 @@ case "$2" in
     	    done
     	done
     	;;
+    netnet)
+	$ipset n test hash:net,net $1 hashsize 64
+	for x in `seq 0 16`; do
+	    for y in `seq 0 255`; do
+		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch
+	    done
+	done
+	for x in `seq 0 16`; do
+	    for y in `seq 0 255`; do
+		$ipset t test $ip$x$sep$y/$net,$ip$y$sep$x/$net nomatch \
+		2>/dev/null
+	    done
+	done
+	;;
     netport)
     	$ipset n test hash:net,port $1 hashsize 64
     	for x in `seq 0 16`; do
diff --git a/tests/resizet.sh b/tests/resizet.sh
index 74fb19e..ff98d58 100644
--- a/tests/resizet.sh
+++ b/tests/resizet.sh
@@ -61,6 +61,14 @@ case "$2" in
     	    done
     	done
     	;;
+    netnet)
+	$ipset n test hash:net,net $1 hashsize 64 timeout 100
+	for x in `seq 0 16`; do
+	    for y in `seq 0 255`; do
+		$ipset a test $ip$x$sep$y/$net,$ip$y$sep$x/$net
+	    done
+	done
+	;;
     netport)
     	$ipset n test hash:net,port $1 hashsize 64 timeout 100
     	for x in `seq 0 16`; do
diff --git a/tests/runtest.sh b/tests/runtest.sh
index b14f151..962e1c6 100755
--- a/tests/runtest.sh
+++ b/tests/runtest.sh
@@ -9,7 +9,7 @@ tests="$tests iphash hash:ip hash:ip6"
 tests="$tests ipporthash hash:ip,port hash:ip6,port"
 tests="$tests ipportiphash hash:ip,port,ip hash:ip6,port,ip6"
 tests="$tests nethash hash:net hash:net6 hash:net,port hash:net6,port"
-tests="$tests hash:ip,port,net hash:ip6,port,net6"
+tests="$tests hash:ip,port,net hash:ip6,port,net6 hash:net,net hash:net6,net6"
 tests="$tests hash:net,iface.t"
 tests="$tests setlist restore"
 # tests="$tests iptree iptreemap"
-- 
1.8.3.2

