From: Ana Rey <anarey@gmail.com>
Subject: [PATCH 1/6] [nft] tests: Add Automated regression testing
Date: Thu, 31 Jul 2014 11:08:06 +0200
Message-ID: <1406797691-1080-2-git-send-email-anarey@gmail.com>
References: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60107 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284AbaGaJIc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jul 2014 05:08:32 -0400
Received: by mail-wi0-f182.google.com with SMTP id d1so3653661wiv.9
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Jul 2014 02:08:26 -0700 (PDT)
In-Reply-To: <1406797691-1080-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Here, the automated regression testing to nftables and some test files.

This is a python script to check the command-line in nft.

This script checks the input of rules of nft-tool from the command-line
and the output of them to the command-line. A bit more details here
below.

A) What is it checking?

This script tests two different paths:

1) The input of rules of nft-tool from the command-line. It checks the
different steps from the command-line to the kernel: parse step,
evaluate step, compile step, the generate of netlink message and after
this is sent into the kernel.

2) The output that is obtained from the kernel. It checks the different
steps from the kernel to the command-line: getting the netlink message,
the parse step, the postproces step, the textify step and the listing
the rule in the command-line.

As a last step, It compares the rule is added and rule is listed by nft.

B) What options are available?

The script offers the following options:

1) Execute all set of test files (or one test file):

./nft-test.sh => Run all test files
./nft-test.sh path/file.t => Run this test file

So, It tests the input of rules of nft-tool from the command-line and
then, It checks if the rule is added correctly.

If there is a problem, It lists the differences between the rule is
added and the rule is listed by nft.

(If there are more than one family of table indicated in the test file
and there is an error or a warning in this execution of the rule, the
execution of this rule stop and it does not run in the others families
of the tables).

2) List all rules are added in nft-tool while this script is run. (It
is similar a debug mode of this test.)

./nft-test.sh -d
./nft-test.sh -d path/file.t

3) Run marked-line. This mode runs the lines that starts with a "-"
symbol (these rules only).
./nft-test.sh -r
./nft-test.sh -r path/file.t

4) Run a rule in all families of table. Run all rules in all families
of the tables defined in the test file. (although there were an error
or a warning in a previous families.)
./nft-test.sh -a
./nft-test.sh -a path/file.t

C) What is the structure of the test file?

A test file contains a set of rules that are added in the system.

Here, an example of a test file:

*ip;test-ipv4                               # line 1
*ip6;test-ipv6                              # line 2
*inet;test-inet                             # line 3

:input;type filter hook input priority 0    # line 4

ah hdrlength != 11-23;ok;ah hdrlength < 11 ah hdrlength > 23   # line 5
- tcp dport != {22-25}                                         # line 6

!set1 ipv4_addr;ok                          # line 7
?set1 192.168.3.8 192.168.3.9;ok            # line 8
 # This is a commented-line.                # line 9

1) Tables:
 # Line 1: it defines a table where chains and rules are added.
It defines a table. the name of the table is  test-ip and the family is
ip.
In line 2 and 3, It define more tables of different families (ip6 and
inet). It's possible to add different type of tables.

2) Chains:
 # Line 4: It defines the chain/s (and the type, hook and priority of
this chain) where rules are added.  The name of this chain is "input".
The type is "filter", the hook is "input" and the priority is 0.

3) Rules:
line: 4: This line is divided by a ";" character.
   Part 1: "ah hdrlength != 11-23" is the rule to check.
   Part 2: "ok" is the result expected with the execute of this rule.
(This rule is added without errors.)
   Part 3: "ah hdrlength < 11 ah hdrlength > 23". This is the look of
the rule if it is run in the command-line. If the look of the output
rule is the same that the rule in the input, this part is omit.

4) Marked-line:
Line 6: This is a marked-line. It means this rule is not run in a
general execution of this script.
If if want to execute this line, It's necessary run this script with
"-r" option.

It's useful to mark a known bugs or lines that don't want to execute.

5) Named set:
Line 7: It adds a new set. The name of this set is "set1" and the type
of this set is "ipv4_add"
Line 8: It adds two element into the set1 set: "192.168.3.8" and
"192.168.3.9" A whitespace divide the diferent elements of the set.

The Anonymous sets is added as a normal rule. It doesn't an especial
handling.

6) Comments:
Line 9: "#" symbol means that line is a comment about the test.

D) The test folders
The test files are divide in directory: ip, ip6, inet, arp, bridge
and any folders:

 * "ip" folder: Here are the test files are executed in ip and inet
table.
 * "ip" folder: Here are the test files are executed in ip6 and inet
table.
 * "inet" folder: Here are the test files are executed in ip, ip6 and
inet table.
 * "arp" folder: Here are the test files are executed in arp tables.
"bridge" folder: Here are the test files are executed in bridge
table.
 * "any" folder: Here are the test files are executed in ip, ip6, inet,
arp and bridge tables.

Moreover, It adds the "ip4" folder with expecific test files for ip and
inet tables.

Signed-off-by: Ana Rey <anarey@gmail.com>
---
 tests/ip/chains.t |  22 ++
 tests/ip/icmp.t   |  98 +++++++
 tests/ip/ip.t     | 108 +++++++
 tests/ip/nat.t    |  18 ++
 tests/ip/reject.t |   5 +
 tests/ip/sets.t   |  31 ++
 tests/nft-test.py | 842 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1124 insertions(+)
 create mode 100644 tests/ip/chains.t
 create mode 100644 tests/ip/icmp.t
 create mode 100644 tests/ip/ip.t
 create mode 100644 tests/ip/nat.t
 create mode 100644 tests/ip/reject.t
 create mode 100644 tests/ip/sets.t
 create mode 100755 tests/nft-test.py

diff --git a/tests/ip/chains.t b/tests/ip/chains.t
new file mode 100644
index 0000000..92a1147
--- /dev/null
+++ b/tests/ip/chains.t
@@ -0,0 +1,22 @@
+*ip;test-ip4
+-*inet;test-inet
+
+# filter chains available are: input, output, forward, prerouting, postrouting
+:filter-input;type filter hook input priority 0
+:filter-pre;type filter hook prerouting priority 0
+:filter-forw;type filter hook forward priority 0
+:filter-out;type filter hook output priority 0
+:filter-post;type filter hook postrouting priority 0
+# nat chains available are: input, output, prerouting, postrouting
+:nat-input-t;type nat hook input priority 0
+:nat-pre-t;type nat hook prerouting priority 0
+:nat-out-t;type nat hook output priority 0
+:nat-post-t;type nat hook postrouting priority 0
+# route chain available are: output
+:route-out-t;type route hook output priority 0
+
+#ip daddr 192.168.0.1-192.168.0.250;ok
+#ip daddr 192.168.0.1;ok
+#ip daddr 192.168.0.1 drop;ok
+#ip daddr 192.168.0.2 log;ok
+#ip daddr 192.168.0.2 log;ok
diff --git a/tests/ip/icmp.t b/tests/ip/icmp.t
new file mode 100644
index 0000000..57a8d8f
--- /dev/null
+++ b/tests/ip/icmp.t
@@ -0,0 +1,98 @@
+*ip;test-ip4
+# BUG: There is a bug with icmp and inet tables.
+- *inet;test-inet
+:input;type filter hook input priority 0
+
+icmp type echo-reply accept;ok
+icmp type destination-unreachable accept;ok
+icmp type source-quench accept;ok
+icmp type redirect accept;ok
+icmp type echo-request accept;ok
+icmp type time-exceeded accept;ok
+icmp type parameter-problem accept;ok
+icmp type timestamp-request accept;ok
+icmp type timestamp-reply accept;ok
+icmp type info-request accept;ok
+icmp type info-reply accept;ok
+icmp type address-mask-request accept;ok
+icmp type address-mask-reply accept;ok
+icmp type {echo-reply, destination-unreachable, source-quench, redirect, echo-request, time-exceeded, parameter-problem, timestamp-request, timestamp-reply, info-request, info-reply, address-mask-request, address-mask-reply} accept;ok
+# $ sudo nft add rule ip test input icmp type != {echo-reply, destination-unreachable, source-quench}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp code 111 accept;ok
+icmp code != 111 accept;ok
+icmp code 33-55;ok;icmp code >= 33 icmp code <= 55
+icmp code != 33-55;ok;icmp code < 33 icmp code > 55
+icmp code { 33-55};ok
+-icmp code != { 33-55};ok
+icmp code { 2, 4, 54, 33, 56};ok
+-icmp code != { 2, 4, 54, 33, 56};ok
+# $ sudo nft add rule ip test input icmp code != {2, 4, 54, 33, 56}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp checksum 12343 accept;ok
+icmp checksum != 12343 accept;ok
+icmp checksum 11-343 accept;ok;icmp checksum >= 11 icmp checksum <= 343 accept
+icmp checksum != 11-343 accept;ok;icmp checksum < 11 icmp checksum > 343 accept
+icmp checksum { 11-343} accept;ok
+-icmp checksum != { 11-343} accept;ok
+icmp checksum { 1111, 222, 343} accept;ok
+-icmp checksum != { 1111, 222, 343} accept;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp id 1245 log;ok
+icmp id 22;ok
+icmp id != 233;ok
+icmp id 33-45;ok;icmp id >= 33 icmp id <= 45
+icmp id != 33-45;ok;icmp id < 33 icmp id > 45
+icmp id { 33-55};ok
+- icmp id != { 33-55};ok
+icmp id { 22, 34, 333};ok
+- icmp id != { 22, 34, 333};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp sequence 22;ok
+icmp sequence != 233;ok
+icmp sequence 33-45;ok;icmp sequence >= 33 icmp sequence <= 45
+icmp sequence != 33-45;ok;icmp sequence < 33 icmp sequence > 45
+icmp sequence { 33, 55, 67, 88};ok
+- icmp sequence != { 33, 55, 67, 88};ok
+icmp sequence { 33-55};ok
+- icmp sequence != { 33-55};ok
+
+icmp mtu 33;ok
+# BUG It set sequence value.
+icmp mtu 22-33;ok
+# BUG: invalid byte order conversion 0 => 2
+# nft: src/evaluate.c:153: byteorder_conversion_op: Assertion '0' failed.
+
+# bug to list icmp sequence 33
+icmp mtu { 22-33};ok
+-icmp mtu != { 22-33};ok
+icmp mtu 22;ok
+icmp mtu != 233;ok
+icmp mtu 33-45;ok
+icmp mtu != 33-45;ok
+icmp mtu { 33, 55, 67, 88};ok
+-icmp mtu != { 33, 55, 67, 88};ok
+icmp mtu { 33-55};ok
+-icmp mtu != { 33-55};ok
+
+icmp gateway 22;ok
+icmp gateway != 233;ok
+icmp gateway 33-45;ok;icmp gateway >= 33 icmp gateway <= 45
+icmp gateway != 33-45;ok;icmp gateway < 33 icmp gateway > 45
+icmp gateway { 33, 55, 67, 88};ok
+-icmp gateway != { 33, 55, 67, 88};ok
+icmp gateway { 33-55};ok
+-icmp gateway != { 33-55};ok
+icmp gateway != 34;ok
+# BUG list: icmp id 0 icmp sequence 22
+- icmp gateway != { 333, 334};ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed
diff --git a/tests/ip/ip.t b/tests/ip/ip.t
new file mode 100644
index 0000000..f1b4a70
--- /dev/null
+++ b/tests/ip/ip.t
@@ -0,0 +1,108 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+# bug ip version
+-ip version 2;ok
+
+# bug ip hdrlength
+-ip hdrlength 10;ok
+-ip hdrlength != 5;ok
+-ip hdrlength 5-8;ok
+-ip hdrlength != 3-13;ok
+-ip hdrlength {3, 5, 6, 8};ok
+-ip hdrlength != {3, 5, 7, 8};ok
+-ip hdrlength { 3-5};ok
+-ip hdrlength != { 3-59};ok
+# ip hdrlength 12
+# <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
+# add rule ip test input ip hdrlength 12
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# <cmdline>:1:37-38: Error: Value 22 exceeds valid range 0-15
+# add rule ip test input ip hdrlength 22
+
+# bug: ip dscp
+-ip dscp CS1;ok
+-ip dscp != CS1;ok
+-ip dscp 0x38;ok
+-ip dscp != 0x20;ok
+-ip dscp {CS1, CS2, CS3, CS4, CS5, CS6, CS7, BE, AF11, AF12, AF13, AF21, AF22, AF23, AF31, AF32, AF33, AF41, AF42, AF43, EF};ok
+-ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
+-ip dscp != {CS0, CS3};ok
+
+ip length 232;ok
+ip length != 233;ok
+ip length 333-435;ok;ip length >= 333 ip length <= 435
+ip length != 333-453;ok;ip length < 333 ip length > 453
+ip length { 333, 553, 673, 838};ok
+-ip length != { 333, 535, 637, 883};ok
+ip length { 333-535};ok
+-ip length != { 333-553};ok
+
+ip id 22;ok
+ip id != 233;ok
+ip id 33-45;ok;ip id >= 33 ip id <= 45
+ip id != 33-45;ok;ip id < 33 ip id > 45
+ip id { 33, 55, 67, 88};ok
+- ip id != { 33, 55, 67, 88};ok
+ip id { 33-55};ok
+- ip id != { 33-55};ok
+
+ip frag-off 222 accept;ok
+ip frag-off != 233;ok
+ip frag-off 33-45;ok;ip frag-off >= 33 ip frag-off <= 45
+ip frag-off != 33-45;ok;ip frag-off < 33 ip frag-off > 45
+ip frag-off { 33, 55, 67, 88};ok
+-ip frag-off != { 33, 55, 67, 88};ok
+ip frag-off { 33-55};ok
+-ip frag-off != { 33-55};ok
+
+ip ttl 0 drop;ok
+ip ttl 233 log;ok
+ip ttl 33-55;ok;ip ttl >= 33 ip ttl <= 55
+ip ttl != 45-50;ok;ip ttl < 45 ip ttl > 50
+ip ttl {43, 53, 45 };ok
+- ip ttl != {46, 56, 93 };ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+ip ttl { 33-55};ok
+- ip ttl != { 33-55};ok
+
+ip protocol tcp log;ok
+ip protocol != tcp log;ok
+ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
+- ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
+
+ip checksum 13172 drop;ok
+ip checksum 22;ok
+ip checksum != 233;ok
+ip checksum 33-45;ok;ip checksum >= 33 ip checksum <= 45
+ip checksum != 33-45;ok;ip checksum < 33 ip checksum > 45
+ip checksum { 33, 55, 67, 88};ok
+-ip checksum != { 33, 55, 67, 88};ok
+ip checksum { 33-55};ok
+-ip checksum != { 33-55};ok
+
+ip saddr 192.168.2.0/24;ok
+ip saddr != 192.168.2.0/24;ok
+ip saddr 192.168.3.1 ip daddr 192.168.3.100;ok
+ip saddr != 1.1.1.1 log prefix giuseppe;ok
+ip saddr 1.1.1.1 log prefix example group 1;ok
+ip daddr 192.168.0.1-192.168.0.250;ok;ip daddr >= 192.168.0.1 ip daddr <= 192.168.0.250
+ip daddr 10.0.0.0-10.255.255.255;ok;ip daddr >= 10.0.0.0 ip daddr <= 10.255.255.255
+ip daddr 172.16.0.0-172.31.255.255;ok;ip daddr >= 172.16.0.0 ip daddr <= 172.31.255.255
+ip daddr 192.168.3.1-192.168.4.250;ok;ip daddr >= 192.168.3.1 ip daddr <= 192.168.4.250
+ip daddr != 192.168.0.1-192.168.0.250;ok;ip daddr < 192.168.0.1 ip daddr > 192.168.0.250
+ip daddr { 192.168.0.1-192.168.0.250};ok
+-ip daddr != { 192.168.0.1-192.168.0.250};ok
+ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+-ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+
+ip daddr 192.168.1.2-192.168.1.55;ok;ip daddr >= 192.168.1.2 ip daddr <= 192.168.1.55
+ip daddr != 192.168.1.2-192.168.1.55;ok;ip daddr < 192.168.1.2 ip daddr > 192.168.1.55
+ip saddr 192.168.1.3-192.168.33.55;ok;ip saddr >= 192.168.1.3 ip saddr <= 192.168.33.55
+ip saddr != 192.168.1.3-192.168.33.55;ok;ip saddr < 192.168.1.3 ip saddr > 192.168.33.55
+
+ip daddr 192.168.0.1;ok
+ip daddr 192.168.0.1 drop;ok
+ip daddr 192.168.0.2 log;ok
diff --git a/tests/ip/nat.t b/tests/ip/nat.t
new file mode 100644
index 0000000..23e0bce
--- /dev/null
+++ b/tests/ip/nat.t
@@ -0,0 +1,18 @@
+*ip;test-ip4
+# bug: Nat tables is not supported yet in inet table.
+-*inet;test-inet
+
+:output;type nat hook output priority 0
+
+iifname eth0 tcp dport 80-90 dnat 192.168.3.2;ok
+iifname eth0 tcp dport != 80-90 dnat 192.168.3.2;ok
+iifname eth0 tcp dport {80, 90, 23} dnat 192.168.3.2;ok
+- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+
+iifname eth0 tcp sport 23-34 snat 192.168.3.2;ok
+
+- iifname eth0 tcp dport != {80, 90, 23} dnat 192.168.3.2;ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+iifname eth0 tcp dport != 23-34 dnat 192.168.3.2;ok
diff --git a/tests/ip/reject.t b/tests/ip/reject.t
new file mode 100644
index 0000000..e7fb15b
--- /dev/null
+++ b/tests/ip/reject.t
@@ -0,0 +1,5 @@
+*ip;test-ip4
+*ip;test-inet
+:output;type filter hook output priority 0
+
+reject;ok
diff --git a/tests/ip/sets.t b/tests/ip/sets.t
new file mode 100644
index 0000000..a74d308
--- /dev/null
+++ b/tests/ip/sets.t
@@ -0,0 +1,31 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+!set_ipv4_add ipv4_addr;ok
+!set_inet inet_proto;ok
+!set_inet_serv inet_service;ok
+!set_time time;ok
+
+!set1 ipv4_addr;ok
+?set1 192.168.3.4;ok
+
+?set1 192.168.3.4;fail
+?set1 192.168.3.5 192.168.3.6;ok
+?set1 192.168.3.5 192.168.3.6;fail
+?set1 192.168.3.8 192.168.3.9;ok
+?set1 192.168.3.10 192.168.3.11;ok
+?set1 1234:1234:1234:1234:1234:1234:1234:1234;fail
+?set2 192.168.3.4;fail
+
+!set2 ipv4_addr;ok
+?set2 192.168.3.4;ok
+?set2 192.168.3.5 192.168.3.6;ok
+?set2 192.168.3.5 192.168.3.6;fail
+?set2 192.168.3.8 192.168.3.9;ok
+?set2 192.168.3.10 192.168.3.11;ok
+
+-ip saddr @set1 drop;ok
+-ip saddr @set2 drop;ok
+-ip saddr @set33 drop;fail
+-ip saddr @set21 drop;fail
diff --git a/tests/nft-test.py b/tests/nft-test.py
new file mode 100755
index 0000000..28799c1
--- /dev/null
+++ b/tests/nft-test.py
@@ -0,0 +1,842 @@
+#!/usr/bin/python
+#
+# (C) 2014 by Ana Rey Botello <anarey@gmail.com>
+#
+# Based on iptables-test.py:
+# (C) 2012 by Pablo Neira Ayuso <pablo@netfilter.org>"
+#
+# This program is free software; you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation; either version 2 of the License, or
+# (at your option) any later version.
+
+import sys
+import os
+import subprocess
+import argparse
+
+TESTS_PATH = os.getcwd()
+LOGFILE = "/tmp/nftables-test.log"
+log_file = None
+
+
+class Colors:
+    HEADER = '\033[95m'
+    GREEN = '\033[92m'
+    YELLOW = '\033[93m'
+    RED = '\033[91m'
+    ENDC = '\033[0m'
+
+
+def print_error(reason, filename=None, lineno=None):
+    '''
+    Prints an error with nice colors, indicating file and line number.
+    '''
+    print (filename + ": " + Colors.RED + "ERROR" +
+           Colors.ENDC + ": line %d: %s" % (lineno + 1, reason))
+
+
+def print_warning(reason, filename=None, lineno=None):
+    '''
+    Prints a warning with nice colors, indicating file and line number.
+    '''
+    print (filename + ": " + Colors.YELLOW + "WARNING" + \
+           Colors.ENDC + ": line %d: %s" % (lineno + 1, reason))
+
+
+def exist_table(table, filename, lineno):
+    '''
+    Exists a table.
+    '''
+    cmd = "nft list -n table " + table[0] + " " + table[1]
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret != 1) else False
+
+
+def flush_table(table, filename, lineno):
+    '''
+    Flush a table.
+    '''
+    cmd = "nft flush table " + str(table[0]) + " " + str(table[1])
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return cmd
+
+
+def create_table(table, table_list, filename, lineno):
+    '''
+    Adds a table.
+    '''
+    ## We check if table exists.
+    if exist_table(table, filename, lineno):
+        reason = "Reason: Table " + table[1] + " exists: " + \
+                 Colors.RED + "The test execution stops here." + Colors.ENDC
+        print_error(reason, filename, lineno)
+        return -1
+
+    ## We add a new table
+    cmd = "nft add table " + table[0] + " " + table[1]
+    ret = execute_cmd(cmd, filename, lineno)
+
+    if ret != 0:
+        reason = cmd + "Reason: Cannot add the table '" + table[1] + "'. " + \
+            Colors.RED + "The test execution stops here." + Colors.ENDC
+        print_error(reason, filename, lineno)
+        return -1
+
+    ## We check if table was added correctly.
+    if not exist_table(table, filename, lineno):
+        reason = "You have just added the table " + table[1] + \
+            " but It does not exist." + \
+            Colors.RED + "The test execution stops here." + Colors.ENDC
+        print_error(reason, filename, lineno)
+        return -1
+
+    table_list.append(table)
+
+    return 0
+
+
+def delete_table(table, filename, lineno):
+    '''
+    Deletes a table.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if not exist_table(table, filename, lineno):
+        reason = "Table " + table[1] + "does not exist." + \
+            Colors.RED + " The test execution stops here." + Colors.ENDC
+        return -1
+
+    cmd = "nft delete table" + table_info
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret == 1:
+        reason = cmd + ": " \
+            "Cannot delete table '" + table[1] + "'. " + \
+            print_error(reason, filename, lineno)
+        return -1
+
+    if exist_table(table, filename, lineno):
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + \
+            "Reason: You have just deleted the table " + table[1] + \
+            " but the table exists." \
+            + Colors.RED + "Can not delete the table" \
+            + "The test execution stops here." + Colors.ENDC
+        print_error(reason, filename, lineno)
+        return -1
+
+    return 0
+
+
+def chain_exist(chain, table, filename, lineno):
+    '''
+    Checks a chain
+    '''
+
+    table_info = " " + table[0] + " " + table[1] + " "
+    cmd = "nft list -n chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret != 1) else False
+
+
+def create_chain(chain, f_chain, chain_list, table, filename, lineno):
+    '''
+    Adds a chain
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if chain_exist(chain, table, filename, lineno):
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + \
+            "Reason: This chain '" + chain + "' exits in " + table[1] + "." + \
+            "You cannot create two chains with same name."
+        print_error(reason, filename, lineno)
+        return -1
+
+    if f_chain:
+        cmd = "nft add chain" + table_info + chain + "\{ " + f_chain + "\; \}"
+    else:
+        cmd = "nft add chain" + table_info + chain
+
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret == 1:
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + cmd + ": " \
+            "Reason: cannot create this chain"
+        print_error(reason, filename, lineno)
+        return -1
+
+    if not chain_exist(chain, table, filename, lineno):
+        info = "Reason: This chain '" + chain + "' does not exits in " + \
+            table[1] + ". There was a problem. Can not add the chain"
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + info
+        print_error(reason, filename, lineno)
+        return -1
+
+    if not chain in chain_list:
+        chain_list.append(chain)
+
+    return 0
+
+
+def delete_chain(chain, table, filename, lineno):
+    '''
+    Deletes (and flushes) a chain.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if not chain_exist(chain, table, filename, lineno):
+        info = "This chain " + chain + " not exits in " + table[1] + ". " +\
+            "It can not delete it."
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + info + Colors.RED + \
+            Colors.ENDC
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = "nft flush chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret == 1:
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + cmd + ": " \
+            "Reason: Cannot flush this chain."
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = "nft delete chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret != 0:
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + cmd + ": " \
+            "Reason: cannot delete this chain."
+        print_error(reason, filename, lineno)
+        return -1
+
+    if chain_exist(chain, table, filename, lineno):
+        err_info = "Reason: This chain " + chain + " exits in " + table[1] + \
+            ". There was problem. Can not delete the chain"
+        reason = Colors.RED + "FAIL: " + Colors.ENDC + err_info
+        print_error(reason, filename, lineno)
+        return -1
+
+    return 0
+
+
+def add_set(set_info, table_list, filename, lineno):
+    '''
+    Adds a set
+    '''
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        if exist_set(set_info[0], table, filename, lineno):
+            reason = "This set " + set_info + " exists in " + table[1] + \
+                ". You cannot add it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_info = " " + table[0] + " " + table[1] + " "
+        set_text = " " + set_info[0] + " { type " + set_info[1] + " \;}"
+        cmd = "nft add set" + table_info + set_text
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (ret == 0 and set_info[2].rstrip() == "fail") or \
+           (ret != 0 and set_info[2].rstrip() == "ok"):
+                reason = cmd + ": " + "Can not add this set."
+                print_error(reason, filename, lineno)
+                return -1
+
+        if not exist_set(set_info[0], table, filename, lineno):
+            reason = "You have just add this set " + set_info[0] + \
+                " but it does not exist in " + table[1]
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def add_elements_set(element_set, set_name, set_set, state, table_list,
+                     filename, lineno):
+    '''
+    Adds elements in a set
+    '''
+    if not table_list:
+        reason = "ERROR: " + "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    # TODO Check if a element was added correctly into the set.
+    for t in table_list:
+        # Check if set exists.
+        if (not exist_set(set_name, t, filename, lineno) or
+           not set_name in set_set) and state == "ok":
+            reason = "ERROR: " + "You can not add a element. The set " + \
+                set_name + " does not exists."
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_info = " " + t[0] + " " + t[1] + " "
+
+        # Add element-elements in the set.
+        element = ""
+        for e in element_set:
+            if not element:
+                element = e
+            else:
+                element = element + ", " + e
+
+        set_text = set_name + " { " + element + " }"
+        cmd = "nft add element -n" + table_info + set_text
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (state == "fail" and ret == 0) or (state == "ok" and ret == 1):
+                test_state = "This rule should have failed."
+                reason = cmd + ": " + test_state
+                print_error(reason, filename, lineno)
+                return -1
+
+        # Add element into a dic_set.
+        if (ret == 0 and state == "ok"):
+            for e in element_set:
+                set_set[set_name].add(e)
+
+    return 0
+
+
+def delete_elements_set(element_set, set_name, table, filename, lineno):
+    '''
+    Deletes elements in a set
+    '''
+
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    for element in element_set:
+        set_text = set_name + " {" + element + "}"
+        cmd = "nft delete element -n" + table_info + set_text
+        ret = execute_cmd(cmd, filename, lineno)
+        if ret != 0:
+            reason = "ERROR:" + "Can not delete a element" + element + \
+                     " in the set '" + set_name
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def delete_set(dic_set, table, filename, lineno):
+    '''
+    Deletes elememts of the set and deletes the set.
+    '''
+    for set_name in dic_set.keys():
+        # Check if exists the set
+        if not exist_set(set_name, table, filename, lineno):
+            reason = "ERROR:" + "The set " + set_name + \
+                     " is not exits. It can not delete it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        # We delete all elements in the set
+        delete_elements_set(dic_set[set_name], set_name, table, filename,
+                            lineno)
+
+        # We delete the set.
+        table_info = " " + table[0] + " " + table[1] + " "
+        cmd = "nft delete set" + table_info + " " + set_name
+        ret = execute_cmd(cmd, filename, lineno)
+
+        # Check if exits the set after I deleted it.
+        if ret != 0 or exist_set(set_name, table, filename, lineno):
+            reason = "ERROR:" + "Error to remove the set'" + set_name
+            print_error(reason, filename, lineno)
+            return -1
+    return 0
+
+
+def exist_set(set_name, table, filename, lineno):
+    '''
+    Exits a set
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+    cmd = "nft list -n set" + table_info + set_name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
+def set_check(rule1, rule2):
+    '''
+    Check element in anonymous sets.
+    '''
+    ret = -1
+    pos1 = rule1.find("{")
+    pos2 = rule2.find("{")
+    end1 = rule1.find("}")
+    end2 = rule2.find("}")
+
+    if ((pos1 != -1) and (pos2 != -1) and (end1 != -1) and (end2 != -1)):
+        list1 = (rule1[pos1 + 1:end1].replace(" ", "")).split(",")
+        list2 = (rule2[pos2 + 1:end2].replace(" ", "")).split(",")
+        list1.sort()
+        list2.sort()
+        if (cmp(list1, list2) == 0):
+            ret = 0
+    return ret
+
+
+def print_differences(table, rule1, rule2, cmd, lineno):
+    print Colors.YELLOW + "[WARNING] " + Colors.ENDC + \
+        "[" + table + "] line " + str(lineno + 1) + ": '" + rule1 + \
+        "' mismatches '" + rule2 + "'"
+
+
+def add_rule_op(rule, table_list, chain_list, filename, lineno, run_all):
+    '''
+    Adds a rule
+    '''
+    # TODO Check if a rule was added correctly.
+    # We need a get_handler_rule(rule)
+    ret = warning = error = unit_tests = 0
+
+    if not table_list or not chain_list:
+        reason = "ERROR: Missing table or chain to add rule"
+        print_error(reason, filename, lineno)
+        return [-1, warning, error, unit_tests]
+
+    for t in table_list:
+        for c in chain_list:
+            if len(rule) == 1:
+                reason = "Skipping malformed test. (" + str(rule[0].rstrip('\n')) + ")"
+                print_warning(reason, filename, lineno)
+                continue
+
+            unit_tests += 1
+            flush_table(t, filename, lineno)
+            table_info = " " + t[0] + " " + t[1] + " "
+            cmd = "nft add rule -n" + table_info + c + " " + rule[0]
+
+            ret = execute_cmd(cmd, filename, lineno)
+
+            state = rule[1].rstrip()
+            if (ret == 0 and state == "fail") or (ret != 0 and state == "ok"):
+                if state == "fail":
+                    test_state = "This rule should have failed."
+                else:
+                    test_state = "This rule should not have failed."
+                reason = "[" + t[0] + "] " + cmd + ": " + test_state
+                print_error(reason, filename, lineno)
+                ret = -1
+                error += 1
+                if not run_all:
+                    return [ret, warning, error, unit_tests]
+
+            if (state == "fail" and ret != 0):
+                ret = 0
+                continue
+
+            if ret == 0:
+            # Check output of nft
+                num_word = len(rule[0])
+                process = subprocess.Popen(['nft', '-n', 'list', 'table'] + t,
+                                           shell=False, stdout=subprocess.PIPE)
+                pre_output = process.communicate()
+                output = pre_output[0].split(";")
+                if len(output) < 2:
+                    reason = cmd + ": " + "This rule braeks the list of rule in this tables"
+                    print_error(reason, filename, lineno)
+                    ret = -1
+                    error += 1
+                    if not run_all:
+                        return [ret, warning, error, unit_tests]
+                else:
+                    rule_exit = output[1]
+                    rule_exit = rule_exit.replace("\t", "").replace("\n", "")
+                    rule_exit = rule_exit.strip()
+                    rule_exit = rule_exit[:-2]  # It Deletes two last braces.
+                    if (len(rule) == 3):
+                        teoric_exit = rule[2]
+                    else:
+                        teoric_exit = rule[0]
+                    if (rule_exit.rstrip() != teoric_exit.rstrip()):
+                        if (rule[0].find("{") != -1):
+                            if (set_check(teoric_exit, rule_exit) != 0):
+                                warning += 1
+                                print_differences(t[0], rule[0], rule_exit, cmd,
+                                                  lineno)
+                                if not run_all:
+                                    return [ret, warning, error, unit_tests]
+                        else:
+                            warning += 1
+                            print_differences(t[0], rule[0], rule_exit, cmd,
+                                              lineno)
+                            if not run_all:
+                                return [ret, warning, error, unit_tests]
+
+    return [ret, warning, error, unit_tests]
+
+
+def insert_rule(rule, position, table_list, chain_list, filename, lineno):
+    '''
+    Inserts a rule
+    '''
+
+    # TODO Check if a rule was added correctly.
+    # We need a get_handler_rule(rule)
+    if not table_list or not chain_list:
+        reason = "ERROR: Missing table or chain to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    if position:
+        position_info = " position " + position
+    else:
+        position_info = ""
+
+    ret = 0
+    for t in table_list:
+        for c in chain_list:
+            table_info = " " + t[0] + " " + t[1] + " "
+            cmd = "nft insert rule" + table_info + c + position_info + " " +\
+                  rule[0]
+            ret = execute_cmd(cmd, filename, lineno)
+
+            if (ret == 0 and rule[1].rstrip() == "fail") or \
+               (ret != 0 and rule[1].rstrip() == "ok"):
+                if rule[1].rstrip() == "fail":
+                    test_state = "This rule should have failed."
+                else:
+                    test_state = "This rule should not have failed."
+                reason = cmd + ": " + test_state
+                print_error(reason, filename, lineno)
+                ret = -1
+
+    return ret
+
+
+def delete_rule(chain, table, filename, lineno):
+    '''
+    Deletes rules.
+    '''
+    # TODO Check if a rule was deleted correctly.
+    # We need a get_handler_rule(rule)
+
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    cmd = "nft delete rule" + table_info + chain[0]
+    ret = execute_cmd(cmd, filename, lineno)
+    if (ret == 0 and chain[1].rstrip() == "fail") or \
+       (ret != 0 and chain[1].rstrip() == "ok"):
+        reason = "cannot delete rule in a chain: " + cmd
+        print_error(reason, filename, lineno)
+        return -1
+
+    return 0
+
+
+def execute_cmd(cmd, filename, lineno):
+    '''
+    Executes a command, checking for segfaults and returning the command exit
+    code.
+
+    :param cmd: string with the command to be executed
+    :param filename: name of the file tested (used for print_error purposes)
+    :param lineno: line number being tested (used for print_error purposes)
+    '''
+    global log_file
+    print >> log_file, "command: %s" % cmd
+    if debug_option:
+        print cmd
+    ret = subprocess.call(cmd, shell=True, universal_newlines=True,
+                          stderr=subprocess.STDOUT, stdout=log_file)
+    log_file.flush()
+
+    if ret == -11:
+        reason = "command segfaults: " + cmd
+        print_error(reason, filename, lineno)
+
+    return ret
+
+
+def print_result(tests, passed, warning):
+    return str(tests) + " unit tests, " + \
+        str(tests - passed - warning) + " error, " + \
+        str(warning) + " warning"
+
+
+def print_result_all(tests, passed, warning, error, unit_tests):
+        return str(tests) + " unit tests, " +\
+            str(unit_tests) + " total test executed, " + \
+            str(error) + " error, " + \
+            str(warning) + " warning"
+
+
+def run_test_file(filename, run_all):
+    '''
+    Runs a test file
+
+    :param filename: name of the file with the test rules
+    '''
+    #
+    # if this is not a test file, skip.
+    #
+    if not filename.endswith(".t"):
+        return [0, 0, 0, 0, 0]
+
+    f = open(filename)
+
+    tests = passed = total_unit_run = total_warning = total_error = 0
+    table = ""
+    total_test_passed = True
+    table_list = []
+    chain_list = []
+    dic_set = dict()
+
+    for lineno, line in enumerate(f):
+        if line.isspace():
+            continue
+
+        if line[0] == "#":
+            continue
+
+        # Table
+        if line[0] == '*':
+            table = []
+            t = line.rstrip()[1:]
+            if ";" in t:
+                table = t.split(";")
+            else:
+                table.append("ip")
+                table.append(t)
+
+            if create_table(table, table_list, filename, lineno) != 0:
+                total_test_passed = False
+                break
+            continue
+
+        # Chain
+        if line[0] == ":":
+            chain_array = line.rstrip()[1:].split(",")
+            for t in table_list:
+                for chain in chain_array:
+                    f_chain = ""
+                    if ";" in chain:
+                        cc = chain.split(";")
+                        chain = cc[0]
+                        f_chain = cc[1]
+                    ret = create_chain(chain, f_chain, chain_list, t, filename,
+                                       lineno)
+                    if ret != 0:
+                        total_test_passed = False
+                        break
+            continue
+
+        if line[0] == "!":  # Adds this set
+            set_t = []
+            set_info = line.rstrip()[0:].split(" ")
+            set_t.append("".join(set_info[0].rstrip()[1:]))
+            set_name = set_info[1].split(";")  # rule[1] Ok or FAIL
+            set_t.append(set_name[0])
+            set_t.append(set_name[1])
+            ret = add_set(set_t, table_list, filename, lineno)
+            tests += 1
+            if ret == -1:
+                total_test_passed = False
+                continue
+            passed += 1
+            # adds a empty set in dic_set with the key 'set_name'
+            dic_set[set_t[0]] = set()
+            continue
+
+        if line[0] == "?":  # Adds elements in a set
+            set_t = []
+            l_info = line.rstrip()[0:].split(";")
+            info_estado = l_info[1]
+            ii = l_info[0].split(" ")
+            set_name = ii[0].rstrip()[1:]
+            # Delete the name
+            ii.remove(ii[0])
+            ret = add_elements_set(ii, set_name, dic_set, info_estado,
+                                   table_list, filename, lineno)
+            tests += 1
+            if ret == -1:
+                total_test_passed = False
+                continue
+
+            passed += 1
+            continue
+
+        # Rule
+        rule = line.split(';')  # rule[1] Ok or FAIL
+        if line[0] == "-":  # Run Marked-line
+            if run_option:
+                rule[0] = rule[0].rstrip()[1:]
+                result = add_rule_op(rule, table_list, chain_list, filename,
+                                     lineno, run_all)
+                tests += 1
+                warning = result[1]
+                ret = result[0]
+                total_warning += warning
+                total_error += result[2]
+                total_unit_run += result[3]
+
+                if ret != 0:
+                    total_test_passed = False
+                elif warning == 0:
+                    passed += 1
+                continue
+            else:
+                continue
+        if run_option:
+            continue
+
+        result = add_rule_op(rule, table_list, chain_list, filename,
+                             lineno, run_all)
+        tests += 1
+        ret = result[0]
+        warning = result[1]
+        total_warning += warning
+        total_error += result[2]
+        total_unit_run += result[3]
+
+        if ret != 0:
+            total_test_passed = False
+            continue
+
+        if warning == 0:  # All ok.
+            passed += 1
+
+    # Delete rules, sets, chains and tables
+    for t in table_list:
+        # We delete chains
+        for c in chain_list:
+            ret = delete_chain(c, t, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+
+        # We delete sets.
+        if dic_set:
+            ret = delete_set(dic_set, t, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+                info = "There is a problem when we delete a set"
+                reason = Colors.RED + "FAIL: " + Colors.ENDC + info + \
+                    Colors.RED + Colors.ENDC
+
+                print_error(reason, filename, lineno)
+
+        # We delete tables.
+        ret = delete_table(t, filename, lineno)
+
+        if ret != 0:
+            total_test_passed = False
+
+    if run_all:
+        if not total_test_passed:
+            print filename + ": " + Colors.RED + "ERROR: " + Colors.ENDC + \
+                print_result_all(tests, passed, total_warning, total_error,
+                                 total_unit_run)
+        elif total_warning > 0:
+            print filename + ": " + Colors.YELLOW + "WARNING IN THE OUTPUT: " \
+                + Colors.ENDC + print_result_all(tests, passed, total_warning,
+                                                 total_error, total_unit_run)
+        else:
+            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
+    else:
+        if not total_test_passed:
+            print filename + ": " + Colors.RED + "ERROR: " + Colors.ENDC + \
+                print_result(tests, passed, total_warning)
+        elif total_warning > 0:
+            print filename + ": " + Colors.YELLOW + "WARNING IN THE OUTPUT: " \
+                + Colors.ENDC + print_result(tests, passed, total_warning)
+        else:
+            print filename + ": " + Colors.GREEN + "OK" + Colors.ENDC
+    f.close()
+    return [tests, passed, total_warning, total_error, total_unit_run]
+
+
+#
+# main
+#
+def main():
+    parser = argparse.ArgumentParser(description='Run nft tests',
+                                     version='1.0')
+
+    parser.add_argument('filename', nargs='?',
+                        metavar='path/to/file.t',
+                        help='Run only this test')
+
+    parser.add_argument('-d', '--debug', action='store_true',
+                        dest='debug',
+                        help='Debug mode: list all commands that are run')
+
+    parser.add_argument('-r', '--run-marked-lines', action='store_true',
+                        dest='run_lines',
+                        help='Run marked-lines in test files')
+
+    parser.add_argument('-a', '--run_all', action='store_true',
+                        dest='run_all',
+                        help='Run rules in all families of tables indicated.')
+
+    args = parser.parse_args()
+    global debug_option, run_option
+    debug_option = args.debug
+    run_option = args.run_lines
+    run_all = args.run_all
+
+    #
+    # show list of missing test files
+    #
+    if os.getuid() != 0:
+        print "You need to be root to run this, sorry"
+        return
+
+    test_files = files_ok = run_total = 0
+    tests = passed = warnings = errors = 0
+    # setup global var log file
+    global log_file
+    try:
+        log_file = open(LOGFILE, 'w')
+    except IOError:
+        print "Couldn't open log file %s" % LOGFILE
+        return
+
+    file_list = []
+    if args.filename:
+        file_list = [args.filename]
+    else:
+        for root, dirs, files in os.walk(TESTS_PATH):
+            for f in files:
+                if f.endswith(".t"):
+                    file_list.append(os.path.join(root, f))
+    for filename in file_list:
+        result = run_test_file(filename, run_all)
+        file_tests = result[0]
+        file_passed = result[1]
+        file_warnings = result[2]
+        file_errors = result[3]
+        file_unit_run = result[4]
+
+        if file_warnings == 0 and file_tests == file_passed:
+            files_ok += 1
+        if file_tests:
+            tests += file_tests
+            passed += file_passed
+            errors += file_errors
+            warnings += file_warnings
+            test_files += 1
+        if run_all:
+            run_total += file_unit_run
+
+    if test_files == 0:
+        print Colors.YELLOW + "WARNING: There are not any tests to run" + \
+            Colors.ENDC
+    else:
+        if run_all:
+            print ("%d test files, %d files passed, %d unit tests, %d total executed, %d error, %d warning" %
+                  (test_files, files_ok, tests, run_total, errors, warnings))
+        else:
+            print ("%d test files, %d files passed, %d unit tests, %d error, %d warning" %
+                  (test_files, files_ok, tests, tests - passed - warnings,
+                   warnings))
+
+if __name__ == '__main__':
+    main()
-- 
2.0.0

