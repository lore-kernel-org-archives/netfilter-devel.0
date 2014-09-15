From: Ana Rey <anarey@gmail.com>
Subject: [PATCH nft v2 1/6] tests: Add Automated regression testing
Date: Mon, 15 Sep 2014 14:47:05 +0200
Message-ID: <1410785230-8498-2-git-send-email-anarey@gmail.com>
References: <1410785230-8498-1-git-send-email-anarey@gmail.com>
Cc: Ana Rey <anarey@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:43119 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752486AbaIOMpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Sep 2014 08:45:05 -0400
Received: by mail-wg0-f48.google.com with SMTP id m15so3820058wgh.31
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Sep 2014 05:44:58 -0700 (PDT)
In-Reply-To: <1410785230-8498-1-git-send-email-anarey@gmail.com>
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

3) Run rules that they need to fix: This mode runs the lines of a file
that starts with a "-" symbol (these rules only).
./nft-test.sh -e
./nft-test.sh -e path/file.t

4) Keep testing all families on error. Run all rules in all families
of the tables defined in the test file. (although there were an error
or a warning in a previous families.)
./nft-test.sh -f
./nft-test.sh -f path/file.t

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
 tests/regression/ip/chains.t |   22 ++
 tests/regression/ip/icmp.t   |   93 +++++
 tests/regression/ip/ip.t     |  107 ++++++
 tests/regression/ip/nat.t    |   18 +
 tests/regression/ip/reject.t |    5 +
 tests/regression/ip/sets.t   |   31 ++
 tests/regression/nft-test.py |  805 ++++++++++++++++++++++++++++++++++++++++++
 7 files changed, 1081 insertions(+)
 create mode 100644 tests/regression/ip/chains.t
 create mode 100644 tests/regression/ip/icmp.t
 create mode 100644 tests/regression/ip/ip.t
 create mode 100644 tests/regression/ip/nat.t
 create mode 100644 tests/regression/ip/reject.t
 create mode 100644 tests/regression/ip/sets.t
 create mode 100755 tests/regression/nft-test.py

diff --git a/tests/regression/ip/chains.t b/tests/regression/ip/chains.t
new file mode 100644
index 0000000..92a1147
--- /dev/null
+++ b/tests/regression/ip/chains.t
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
diff --git a/tests/regression/ip/icmp.t b/tests/regression/ip/icmp.t
new file mode 100644
index 0000000..cd43a66
--- /dev/null
+++ b/tests/regression/ip/icmp.t
@@ -0,0 +1,93 @@
+*ip;test-ip4
+# BUG: There is a bug with icmp protocol and inet family.
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
+- icmp type != {echo-reply, destination-unreachable, source-quench};ok
+# BUG: icmp type != {echo-reply, destination-unreachable, source-quench}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp code 111 accept;ok
+icmp code != 111 accept;ok
+icmp code 33-55;ok;icmp code >= 33 icmp code <= 55
+icmp code != 33-55;ok;icmp code < 33 icmp code > 55
+icmp code { 33-55};ok
+- icmp code != { 33-55};ok
+icmp code { 2, 4, 54, 33, 56};ok
+- icmp code != { 2, 4, 54, 33, 56};ok
+# $ sudo nft add rule ip test input icmp code != {2, 4, 54, 33, 56}
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+
+icmp checksum 12343 accept;ok
+icmp checksum != 12343 accept;ok
+icmp checksum 11-343 accept;ok;icmp checksum >= 11 icmp checksum <= 343 accept
+icmp checksum != 11-343 accept;ok;icmp checksum < 11 icmp checksum > 343 accept
+icmp checksum { 11-343} accept;ok
+- icmp checksum != { 11-343} accept;ok
+icmp checksum { 1111, 222, 343} accept;ok
+- icmp checksum != { 1111, 222, 343} accept;ok
+# BUG: invalid expression type set
+# icmp checksum != { 1111, 222, 343} accept;ok
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
+# icmp id != { 22, 34, 333}
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
+icmp mtu 22-33;ok
+icmp mtu { 22-33};ok
+- icmp mtu != { 22-33};ok
+icmp mtu 22;ok
+icmp mtu != 233;ok
+icmp mtu 33-45;ok
+icmp mtu != 33-45;ok
+icmp mtu { 33, 55, 67, 88};ok
+- icmp mtu != { 33, 55, 67, 88};ok
+icmp mtu { 33-55};ok
+- icmp mtu != { 33-55};ok
+
+icmp gateway 22;ok
+icmp gateway != 233;ok
+icmp gateway 33-45;ok;icmp gateway >= 33 icmp gateway <= 45
+icmp gateway != 33-45;ok;icmp gateway < 33 icmp gateway > 45
+icmp gateway { 33, 55, 67, 88};ok
+- icmp gateway != { 33, 55, 67, 88};ok
+icmp gateway { 33-55};ok
+- icmp gateway != { 33-55};ok
+icmp gateway != 34;ok
+- icmp gateway != { 333, 334};ok
diff --git a/tests/regression/ip/ip.t b/tests/regression/ip/ip.t
new file mode 100644
index 0000000..b02df80
--- /dev/null
+++ b/tests/regression/ip/ip.t
@@ -0,0 +1,107 @@
+*ip;test-ip4
+*inet;test-inet
+:input;type filter hook input priority 0
+
+- ip version 2;ok
+
+# bug ip hdrlength
+- ip hdrlength 10;ok
+- ip hdrlength != 5;ok
+- ip hdrlength 5-8;ok
+- ip hdrlength != 3-13;ok
+- ip hdrlength {3, 5, 6, 8};ok
+- ip hdrlength != {3, 5, 7, 8};ok
+- ip hdrlength { 3-5};ok
+- ip hdrlength != { 3-59};ok
+# ip hdrlength 12
+# <cmdline>:1:1-38: Error: Could not process rule: Invalid argument
+# add rule ip test input ip hdrlength 12
+# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+# <cmdline>:1:37-38: Error: Value 22 exceeds valid range 0-15
+# add rule ip test input ip hdrlength 22
+
+- ip dscp CS1;ok
+- ip dscp != CS1;ok
+- ip dscp 0x38;ok
+- ip dscp != 0x20;ok
+- ip dscp {CS1, CS2, CS3, CS4, CS5, CS6, CS7, BE, AF11, AF12, AF13, AF21, AF22, AF23, AF31, AF32, AF33, AF41, AF42, AF43, EF};ok
+- ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
+-ip dscp != {CS0, CS3};ok
+
+ip length 232;ok
+ip length != 233;ok
+ip length 333-435;ok;ip length >= 333 ip length <= 435
+ip length != 333-453;ok;ip length < 333 ip length > 453
+ip length { 333, 553, 673, 838};ok
+- ip length != { 333, 535, 637, 883};ok
+ip length { 333-535};ok
+- ip length != { 333-553};ok
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
+- ip frag-off != { 33, 55, 67, 88};ok
+ip frag-off { 33-55};ok
+- ip frag-off != { 33-55};ok
+
+ip ttl 0 drop;ok
+ip ttl 233 log;ok
+ip ttl 33-55;ok;ip ttl >= 33 ip ttl <= 55
+ip ttl != 45-50;ok;ip ttl < 45 ip ttl > 50
+ip ttl {43, 53, 45 };ok
+- ip ttl != {46, 56, 93 };ok
+# BUG: ip ttl != {46, 56, 93 };ok
+# BUG: invalid expression type set
+# nft: src/evaluate.c:975: expr_evaluate_relational: Assertion '0' failed.
+ip ttl { 33-55};ok
+- ip ttl != { 33-55};ok
+
+ip protocol tcp log;ok
+ip protocol != tcp log;ok
+ip protocol { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok;ip protocol { 33, 136, 17, 51, 50, 6, 132, 1, 108} accept
+- ip protocol != { icmp, esp, ah, comp, udp, udplite, tcp, dccp, sctp} accept;ok
+
+ip checksum 13172 drop;ok
+ip checksum 22;ok
+ip checksum != 233;ok
+ip checksum 33-45;ok;ip checksum >= 33 ip checksum <= 45
+ip checksum != 33-45;ok;ip checksum < 33 ip checksum > 45
+ip checksum { 33, 55, 67, 88};ok
+- ip checksum != { 33, 55, 67, 88};ok
+ip checksum { 33-55};ok
+- ip checksum != { 33-55};ok
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
+- ip daddr != { 192.168.0.1-192.168.0.250};ok
+ip daddr { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+- ip daddr != { 192.168.5.1, 192.168.5.2, 192.168.5.3 } accept;ok
+
+ip daddr 192.168.1.2-192.168.1.55;ok;ip daddr >= 192.168.1.2 ip daddr <= 192.168.1.55
+ip daddr != 192.168.1.2-192.168.1.55;ok;ip daddr < 192.168.1.2 ip daddr > 192.168.1.55
+ip saddr 192.168.1.3-192.168.33.55;ok;ip saddr >= 192.168.1.3 ip saddr <= 192.168.33.55
+ip saddr != 192.168.1.3-192.168.33.55;ok;ip saddr < 192.168.1.3 ip saddr > 192.168.33.55
+
+ip daddr 192.168.0.1;ok
+ip daddr 192.168.0.1 drop;ok
+ip daddr 192.168.0.2 log;ok
diff --git a/tests/regression/ip/nat.t b/tests/regression/ip/nat.t
new file mode 100644
index 0000000..23e0bce
--- /dev/null
+++ b/tests/regression/ip/nat.t
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
diff --git a/tests/regression/ip/reject.t b/tests/regression/ip/reject.t
new file mode 100644
index 0000000..e7fb15b
--- /dev/null
+++ b/tests/regression/ip/reject.t
@@ -0,0 +1,5 @@
+*ip;test-ip4
+*ip;test-inet
+:output;type filter hook output priority 0
+
+reject;ok
diff --git a/tests/regression/ip/sets.t b/tests/regression/ip/sets.t
new file mode 100644
index 0000000..a74d308
--- /dev/null
+++ b/tests/regression/ip/sets.t
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
diff --git a/tests/regression/nft-test.py b/tests/regression/nft-test.py
new file mode 100755
index 0000000..027ed6f
--- /dev/null
+++ b/tests/regression/nft-test.py
@@ -0,0 +1,805 @@
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
+#
+# Thanks to the Outreach Program for Women (OPW) for sponsoring this test
+# infrastructure.
+
+import sys
+import os
+import subprocess
+import argparse
+import signal
+
+TERMINAL_PATH = os.getcwd()
+TESTS_PATH = os.path.dirname(os.path.abspath(__file__))
+TESTS_DIRECTORY = ["any", "ip", "ip6", "inet", "arp", "bridge"]
+LOGFILE = "/tmp/nftables-test.log"
+log_file = None
+table_list = []
+chain_list = []
+all_set = dict()
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
+    if filename and lineno:
+        print (filename + ": " + Colors.RED + "ERROR:" +
+               Colors.ENDC + " line %d: %s" % (lineno + 1, reason))
+    else:
+        print (Colors.RED + "ERROR:" + Colors.ENDC + " %s" % (reason))
+
+
+def print_warning(reason, filename=None, lineno=None):
+    '''
+    Prints a warning with nice colors, indicating file and line number.
+    '''
+    if filename and lineno:
+        print (filename + ": " + Colors.YELLOW + "WARNING:" + \
+               Colors.ENDC + " line %d: %s" % (lineno + 1, reason))
+    else:
+        print (Colors.YELLOW + "WARNING:" + " %s" % (reason))
+
+
+def print_differences(filename, lineno, table, rule1, rule2, cmd):
+    reason = "'" + rule1 + "' mismatches '" + rule2 + "'"
+    print filename + ": " + Colors.YELLOW + "WARNING: " + Colors.ENDC + \
+        "line: " + str(lineno + 1) + ": '" + cmd + ": " + reason
+
+
+def table_exist(table, filename, lineno):
+    '''
+    Exists a table.
+    '''
+    cmd = "nft list -nnn table " + table[0] + " " + table[1]
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
+def table_flush(table, filename, lineno):
+    '''
+    Flush a table.
+    '''
+    cmd = "nft flush table " + str(table[0]) + " " + str(table[1])
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return cmd
+
+
+def table_create(table, filename, lineno):
+    '''
+    Adds a table.
+    '''
+    ## We check if table exists.
+    if table_exist(table, filename, lineno):
+        reason = "Table " + table[1] + \
+            " exists: Test environment is not clean. Giving up!"
+        print_error(reason, filename, lineno)
+        return -1
+
+    ## We add a new table
+    cmd = "nft add table " + table[0] + " " + table[1]
+    ret = execute_cmd(cmd, filename, lineno)
+
+    if ret != 0:
+        reason = "Table " + table[1] + \
+            " does not exist. Test environment is not clean. Giving up!"
+        print_error(reason, filename, lineno)
+        return -1
+
+    ## We check if table was added correctly.
+    if not table_exist(table, filename, lineno):
+        reason = "You have just added the table " + table[1] + \
+            " but It does not exist. Test environment is not clean. Giving up!"
+        print_error(reason, filename, lineno)
+        return -1
+    table_list.append(table)
+
+    return 0
+
+
+def table_delete(table, filename=None, lineno=None):
+    '''
+    Deletes a table.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if not table_exist(table, filename, lineno):
+        reason = "Table " + table[1] + \
+            " does not exist. Test environment is not clean. Giving up!"
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = "nft delete table" + table_info
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret == 1:
+        reason = cmd + ": " \
+            "I cannot delete table '" + table[1] + "'. Giving up! "
+        print_error(reason, filename, lineno)
+        return -1
+
+    if table_exist(table, filename, lineno):
+        reason = "It has just deleted the table " + table[1] + \
+            " but the table exists. I cannot delete the table. " + \
+            "Test environment is not clean. Giving up!"
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
+    cmd = "nft list -nnn chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
+def chain_create(chain, f_chain, chain_list, table, filename, lineno):
+    '''
+    Adds a chain
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if chain_exist(chain, table, filename, lineno):
+        reason = "This chain '" + chain + "' exits in " + table[1] + "." + \
+            "I cannot create two chains with same name."
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
+        reason = "I cannot create this chain"
+        print_error(reason, filename, lineno)
+        return -1
+
+    if not chain_exist(chain, table, filename, lineno):
+        reason = "This chain '" + chain + "' does not exits in " + table[1] + \
+            ". I cannot add the chain"
+        print_error(reason, filename, lineno)
+        return -1
+
+    if not chain in chain_list:
+        chain_list.append(chain)
+
+    return 0
+
+
+def chain_delete(chain, table,  filename=None, lineno=None):
+    '''
+    Deletes (and flushes) a chain.
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    if not chain_exist(chain, table, filename, lineno):
+        reason = "This chain " + chain + " not exits in " + table[1] + \
+            ". I cannot delete it."
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = "nft flush chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret == 1:
+        reason = "I cannot flush this chain " + chain
+        print_error(reason, filename, lineno)
+        return -1
+
+    cmd = "nft delete chain" + table_info + chain
+    ret = execute_cmd(cmd, filename, lineno)
+    if ret != 0:
+        reason = cmd + "I cannot delete this chain."
+        print_error(reason, filename, lineno)
+        return -1
+
+    if chain_exist(chain, table, filename, lineno):
+        reason = "This chain " + chain + " exists in " + table[1] + \
+            ". I cannot delete the chain"
+        print_error(reason, filename, lineno)
+        return -1
+
+    return 0
+
+
+def set_add(set_info, table_list, filename, lineno):
+    '''
+    Adds a set
+    '''
+    if not table_list:
+        reason = "Missing table to add rule"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        if set_exist(set_info[0], table, filename, lineno):
+            reason = "This set " + set_info + " exists in " + table[1] + \
+                ". I cannot add it again"
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
+                reason = cmd + ": " + "I cannot add this set."
+                print_error(reason, filename, lineno)
+                return -1
+
+        if not set_exist(set_info[0], table, filename, lineno):
+            reason = "It has just added this set " + set_info[0] + \
+                " in " + table[1] + "table but it does not exist"
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def set_add_elements(set_element, set_name, set_all, state, table_list,
+                     filename, lineno):
+    '''
+    Adds elements in a set
+    '''
+    if not table_list:
+        reason = "Missing table to add rules"
+        print_error(reason, filename, lineno)
+        return -1
+
+    for table in table_list:
+        # Check if set exists.
+        if (not set_exist(set_name, table, filename, lineno) or
+           not set_name in set_all) and state == "ok":
+            reason = "I cannot add an element. The set " + set_name + \
+                " does not exist."
+            print_error(reason, filename, lineno)
+            return -1
+
+        table_info = " " + table[0] + " " + table[1] + " "
+
+        element = ""
+        for e in set_element:
+            if not element:
+                element = e
+            else:
+                element = element + ", " + e
+
+        set_text = set_name + " { " + element + " }"
+        cmd = "nft add element -nnn" + table_info + set_text
+        ret = execute_cmd(cmd, filename, lineno)
+
+        if (state == "fail" and ret == 0) or (state == "ok" and ret == 1):
+                test_state = "This rule should have failed."
+                reason = cmd + ": " + test_state
+                print_error(reason, filename, lineno)
+                return -1
+
+        # Add element into a all_set.
+        if (ret == 0 and state == "ok"):
+            for e in set_element:
+                set_all[set_name].add(e)
+
+    return 0
+
+
+def set_delete_elements(set_element, set_name, table, filename=None,
+                        lineno=None):
+    '''
+    Deletes elements in a set
+    '''
+
+    table_info = " " + table[0] + " " + table[1] + " "
+
+    for element in set_element:
+        set_text = set_name + " {" + element + "}"
+        cmd = "nft delete element -nnn" + table_info + set_text
+        ret = execute_cmd(cmd, filename, lineno)
+        if ret != 0:
+            reason = "I cannot delete an element" + element + \
+                " in the set '" + set_name
+            print_error(reason, filename, lineno)
+            return -1
+
+    return 0
+
+
+def set_delete(all_set, table, filename=None, lineno=None):
+    '''
+    Deletes elememts of the set and deletes the set.
+    '''
+    for set_name in all_set.keys():
+        # Check if exists the set
+        if not set_exist(set_name, table, filename, lineno):
+            reason = "The set " + set_name + \
+                " does not exist. I cannot delete it"
+            print_error(reason, filename, lineno)
+            return -1
+
+        # We delete all elements in the set
+        set_delete_elements(all_set[set_name], set_name, table, filename,
+                            lineno)
+
+        # We delete the set.
+        table_info = " " + table[0] + " " + table[1] + " "
+        cmd = "nft delete set " + table_info + " " + set_name
+        ret = execute_cmd(cmd, filename, lineno)
+
+        # Check if exits the set after I deleted it.
+        if ret != 0 or set_exist(set_name, table, filename, lineno):
+            reason = "Error to remove the set " + set_name
+            print_error(reason, filename, lineno)
+            return -1
+    return 0
+
+
+def set_exist(set_name, table, filename, lineno):
+    '''
+    Exits a set
+    '''
+    table_info = " " + table[0] + " " + table[1] + " "
+    cmd = "nft list -nnn set" + table_info + set_name
+    ret = execute_cmd(cmd, filename, lineno)
+
+    return True if (ret == 0) else False
+
+
+def set_check_element(rule1, rule2):
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
+def rule_add(rule, table_list, chain_list, filename, lineno, force_all_family_option):
+    '''
+    Adds a rule
+    '''
+    # TODO Check if a rule is added correctly.
+    ret = warning = error = unit_tests = 0
+
+    if not table_list or not chain_list:
+        reason = "Missing table or chain to add rule."
+        print_error(reason, filename, lineno)
+        return [-1, warning, error, unit_tests]
+
+    for table in table_list:
+        for chain in chain_list:
+            if len(rule) == 1:
+                reason = "Skipping malformed test. (" + \
+                    str(rule[0].rstrip('\n')) + ")"
+                print_warning(reason, filename, lineno)
+                continue
+
+            unit_tests += 1
+            table_flush(table, filename, lineno)
+            table_info = " " + table[0] + " " + table[1] + " "
+            cmd = "nft add rule -nnn" + table_info + chain + " " + rule[0]
+
+            ret = execute_cmd(cmd, filename, lineno)
+
+            state = rule[1].rstrip()
+            if (ret == 0 and state == "fail") or (ret != 0 and state == "ok"):
+                if state == "fail":
+                    test_state = "This rule should have failed."
+                else:
+                    test_state = "This rule should not have failed."
+                reason = cmd + ": " + test_state
+                print_error(reason, filename, lineno)
+                ret = -1
+                error += 1
+                if not force_all_family_option:
+                    return [ret, warning, error, unit_tests]
+
+            if (state == "fail" and ret != 0):
+                ret = 0
+                continue
+
+            if ret == 0:
+            # Check output of nft
+                num_word = len(rule[0])
+                process = subprocess.Popen(['nft', '-nnn', 'list', 'table'] + table,
+                                           shell=False, stdout=subprocess.PIPE)
+                pre_output = process.communicate()
+                output = pre_output[0].split(";")
+                if len(output) < 2:
+                    reason = cmd + ": " + \
+                        "This rule braeks the list of rule in this tables"
+                    print_error(reason, filename, lineno)
+                    ret = -1
+                    error += 1
+                    if not force_all_family_option:
+                        return [ret, warning, error, unit_tests]
+                else:
+                    rule_exit = output[1]
+                    rule_exit = rule_exit.replace("\t", "").replace("\n", "")
+                    rule_exit = rule_exit.strip()
+                    rule_exit = rule_exit[:-2]  # It deletes two last braces.
+                    if (len(rule) == 3):
+                        teoric_exit = rule[2]
+                    else:
+                        teoric_exit = rule[0]
+                    if (rule_exit.rstrip() != teoric_exit.rstrip()):
+                        if (rule[0].find("{") != -1):
+                            if (set_check_element(teoric_exit, rule_exit) != 0):
+                                warning += 1
+                                print_differences(filename, lineno, table[0],
+                                                  rule[0], rule_exit, cmd)
+                                if not force_all_family_option:
+                                    return [ret, warning, error, unit_tests]
+                        else:
+                            warning += 1
+                            print_differences(filename, lineno, table[0],
+                                              rule[0], rule_exit, cmd)
+                            if not force_all_family_option:
+                                return [ret, warning, error, unit_tests]
+
+    return [ret, warning, error, unit_tests]
+
+
+def cleanup_on_exit():
+    for table in table_list:
+        for chain in chain_list:
+            ret = chain_delete(chain, table, "", "")
+        if all_set:
+            ret = set_delete(all_set, table)
+        ret = table_delete(table)
+
+
+def signal_handler(signal, frame):
+    print "\nSignal received. Cleaning up and exitting..."
+    cleanup_on_exit()
+    sys.exit(0)
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
+def print_result(filename, tests, passed, warning):
+    return str(filename) + ": " + str(tests) + " unit tests, " + \
+        str(tests - passed - warning) + " error, " + \
+        str(warning) + " warning"
+
+
+def print_result_all(filename, tests, passed, warning, error, unit_tests):
+        return str(filename) + ": " + str(tests) + " unit tests, " +\
+            str(unit_tests) + " total test executed, " + \
+            str(error) + " error, " + \
+            str(warning) + " warning"
+
+
+def table_process(table_line, filename, lineno):
+    if ";" in table_line:
+        table_info = table_line.split(";")
+    else:
+        table_info.append("ip")
+        table_info.append(table_line)
+
+    return table_create(table_info, filename, lineno)
+
+
+def chain_process(chain_line, filename, lineno):
+    chain_name = chain_line[0]
+    chain_type = ""
+    for table in table_list:
+        if len(chain_line) > 1:
+            chain_type = chain_line[1]
+        ret = chain_create(chain_name, chain_type, chain_list, table,
+                            filename, lineno)
+        if ret != 0:
+            return -1
+    return ret
+
+
+def set_process(set_line, filename, lineno):
+    set_info = []
+    set_name = "".join(set_line[0].rstrip()[1:])
+    set_info.append(set_name)
+    set_type = set_line[1].split(";")[0]
+    set_state = set_line[1].split(";")[1]  # Ok or FAIL
+    set_info.append(set_type)
+    set_info.append(set_state)
+    ret = set_add(set_info, table_list, filename, lineno)
+    if ret == 0:
+        all_set[set_name] = set()
+
+    return ret
+
+
+def set_element_process(element_line, filename, lineno):
+    rule_state = element_line[1]
+    set_name = element_line[0].split(" ")[0]
+    set_element = element_line[0].split(" ")
+    set_element.remove(set_name)
+    return set_add_elements(set_element, set_name, all_set, rule_state,
+                            table_list, filename, lineno)
+
+
+def run_test_file(filename, force_all_family_option, specific_file):
+    '''
+    Runs a test file
+
+    :param filename: name of the file with the test rules
+    '''
+
+    if specific_file:
+        filename_path = os.path.join(TERMINAL_PATH, filename)
+    else:
+        filename_path = os.path.join(TESTS_PATH, filename)
+
+    f = open(filename_path)
+    tests = passed = total_unit_run = total_warning = total_error = 0
+    table = ""
+    total_test_passed = True
+
+    for lineno, line in enumerate(f):
+        if line.isspace():
+            continue
+
+        if line[0] == "#":  # Command-line
+            continue
+
+        if line[0] == '*':  # Table
+            table_line = line.rstrip()[1:]
+            ret = table_process(table_line, filename, lineno)
+            if (ret != 0):
+                total_test_passed = False
+                break
+            continue
+
+        if line[0] == ":":  # Chain
+            chain_line = line.rstrip()[1:].split(";")
+            ret = chain_process(chain_line, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+                break
+            continue
+
+        if line[0] == "!":  # Adds this set
+            set_line = line.rstrip()[0:].split(" ")
+            ret = set_process(set_line, filename, lineno)
+            tests += 1
+            if ret == -1:
+                total_test_passed = False
+                continue
+            passed += 1
+            continue
+
+        if line[0] == "?":  # Adds elements in a set
+            element_line = line.rstrip()[1:].split(";")
+            ret = set_element_process(element_line, filename, lineno)
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
+        if line[0] == "-":  # Run omitted lines
+            if need_fix_option:
+                rule[0] = rule[0].rstrip()[1:]
+                result = rule_add(rule, table_list, chain_list, filename,
+                                  lineno, force_all_family_option)
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
+        if need_fix_option:
+            continue
+
+        result = rule_add(rule, table_list, chain_list, filename, lineno,
+                          force_all_family_option)
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
+    for table in table_list:
+        # We delete chains
+        for chain in chain_list:
+            ret = chain_delete(chain, table, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+
+        # We delete sets.
+        if all_set:
+            ret = set_delete(all_set, table, filename, lineno)
+            if ret != 0:
+                total_test_passed = False
+                reason = "There is a problem when we delete a set"
+                print_error(reason, filename, lineno)
+
+        # We delete tables.
+        ret = table_delete(table, filename, lineno)
+
+        if ret != 0:
+            total_test_passed = False
+
+    if specific_file:
+        if force_all_family_option:
+            print print_result_all(filename, tests, passed, total_warning,
+                             total_error, total_unit_run)
+        else:
+            print print_result(filename, tests, passed, total_warning)
+
+    f.close()
+    del table_list[:]
+    del chain_list[:]
+    all_set.clear()
+
+    return [tests, passed, total_warning, total_error, total_unit_run]
+
+
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
+                        help='debug mode: list all commands that are run')
+
+    parser.add_argument('-e', '--need-fix', action='store_true',
+                        dest='need_fix_line',
+                        help='run rules that they need to fix')
+
+    parser.add_argument('-f', '--force-family', action='store_true',
+                        dest='force_all_family',
+                        help='keep testing all families on error')
+
+    args = parser.parse_args()
+    global debug_option, need_fix_option
+    debug_option = args.debug
+    need_fix_option = args.need_fix_line
+    force_all_family_option = args.force_all_family
+    specific_file = False
+
+    signal.signal(signal.SIGINT, signal_handler)
+    signal.signal(signal.SIGTERM, signal_handler)
+
+    if os.getuid() != 0:
+        print "You need to be root to run this, sorry"
+        return
+
+    test_files = files_ok = run_total = 0
+    tests = passed = warnings = errors = 0
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
+        specific_file = True
+    else:
+        for directory in TESTS_DIRECTORY:
+            path = os.path.join(TESTS_PATH, directory)
+            for root, dirs, files in os.walk(path):
+                for f in files:
+                    if f.endswith(".t"):
+                        file_list.append(os.path.join(directory, f))
+
+    for filename in file_list:
+        result = run_test_file(filename, force_all_family_option, specific_file)
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
+        if force_all_family_option:
+            run_total += file_unit_run
+
+    if test_files == 0:
+        print "There are not any tests to run"
+    else:
+        if not specific_file:
+            if force_all_family_option:
+                print ("%d test files, %d files passed, %d unit tests, %d total executed, %d error, %d warning" %
+                      (test_files, files_ok, tests, run_total, errors, warnings))
+            else:
+                print ("%d test files, %d files passed, %d unit tests, %d error, %d warning" %
+                      (test_files, files_ok, tests, tests - passed - warnings,
+                       warnings))
+
+if __name__ == '__main__':
+    main()
-- 
1.7.10.4

