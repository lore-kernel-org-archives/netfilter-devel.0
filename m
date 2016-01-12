From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/3 nft] tests/py: test udp from ip and ip6 families
Date: Tue, 12 Jan 2016 23:40:37 +0100
Message-ID: <1452638438-19193-2-git-send-email-pablo@netfilter.org>
References: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55854 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbcALWlC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 17:41:02 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1E0C32791A4
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F3A0FDA843
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 26C42DA801
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 23:40:53 +0100 (CET)
In-Reply-To: <1452638438-19193-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The existing test was checking for the ip family three times, fix it.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/udp.t              |   4 +-
 tests/py/inet/udp.t.payload.inet | 222 +++++++++++++++++++++++++++++++++++++++
 tests/py/inet/udp.t.payload.ip6  | 222 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 446 insertions(+), 2 deletions(-)
 create mode 100644 tests/py/inet/udp.t.payload.inet
 create mode 100644 tests/py/inet/udp.t.payload.ip6

diff --git a/tests/py/inet/udp.t b/tests/py/inet/udp.t
index 30c06e4..d5b8653 100644
--- a/tests/py/inet/udp.t
+++ b/tests/py/inet/udp.t
@@ -1,8 +1,8 @@
 :input;type filter hook input priority 0
 
 *ip;test-ip4;input
-*ip;test-ip6;input
-*ip;test-inet;input
+*ip6;test-ip6;input
+*inet;test-inet;input
 
 udp sport 80 accept;ok
 udp sport != 60 accept;ok
diff --git a/tests/py/inet/udp.t.payload.inet b/tests/py/inet/udp.t.payload.inet
new file mode 100644
index 0000000..918aca6
--- /dev/null
+++ b/tests/py/inet/udp.t.payload.inet
@@ -0,0 +1,222 @@
+# udp sport 80 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport 50-70 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004600 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 50-60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport { 49, 50} drop
+set%d test-inet 3
+set%d test-inet 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp sport { 12-40}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp dport 80 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport 70-75 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00004600 ]
+  [ cmp lte reg 1 0x00004b00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 50-60 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport { 49, 50} drop
+set%d test-inet 3
+set%d test-inet 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp dport { 70-75} accept
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length 6666
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+
+# udp length != 6666
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x00000a1a ]
+
+# udp length 50-65 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length != 50-65 accept
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length { 50, 65} accept
+set%d test-inet 3
+set%d test-inet 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length { 35-50}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum 6666 drop
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+  [ immediate reg 0 drop ]
+
+# udp checksum 22
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# udp checksum != 233
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# udp checksum 33-45
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# udp checksum != 33-45
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# udp checksum { 33, 55, 67, 88}
+set%d test-inet 3
+set%d test-inet 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum { 33-55}
+set%d test-inet 7
+set%d test-inet 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+inet test-inet input 
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
diff --git a/tests/py/inet/udp.t.payload.ip6 b/tests/py/inet/udp.t.payload.ip6
new file mode 100644
index 0000000..39d8bac
--- /dev/null
+++ b/tests/py/inet/udp.t.payload.ip6
@@ -0,0 +1,222 @@
+# udp sport 80 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 60 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport 50-70 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004600 ]
+  [ immediate reg 0 accept ]
+
+# udp sport != 50-60 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp sport { 49, 50} drop
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp sport { 12-40}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00000c00  : 0 [end]	element 00002900  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 0 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp dport 80 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00005000 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 60 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp neq reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport 70-75 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp gte reg 1 0x00004600 ]
+  [ cmp lte reg 1 0x00004b00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport != 50-60 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00003c00 ]
+  [ immediate reg 0 accept ]
+
+# udp dport { 49, 50} drop
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00003100  : 0 [end]	element 00003200  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 drop ]
+
+# udp dport { 70-75} accept
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00004600  : 0 [end]	element 00004c00  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length 6666
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+
+# udp length != 6666
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp neq reg 1 0x00000a1a ]
+
+# udp length 50-65 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp gte reg 1 0x00003200 ]
+  [ cmp lte reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length != 50-65 accept
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ cmp lt reg 1 0x00003200 ]
+  [ cmp gt reg 1 0x00004100 ]
+  [ immediate reg 0 accept ]
+
+# udp length { 50, 65} accept
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00003200  : 0 [end]	element 00004100  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+  [ immediate reg 0 accept ]
+
+# udp length { 35-50}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002300  : 0 [end]	element 00003300  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum 6666 drop
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000a1a ]
+  [ immediate reg 0 drop ]
+
+# udp checksum 22
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# udp checksum != 233
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp neq reg 1 0x0000e900 ]
+
+# udp checksum 33-45
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp gte reg 1 0x00002100 ]
+  [ cmp lte reg 1 0x00002d00 ]
+
+# udp checksum != 33-45
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ cmp lt reg 1 0x00002100 ]
+  [ cmp gt reg 1 0x00002d00 ]
+
+# udp checksum { 33, 55, 67, 88}
+set%d test-ip6 3
+set%d test-ip6 0
+	element 00002100  : 0 [end]	element 00003700  : 0 [end]	element 00004300  : 0 [end]	element 00005800  : 0 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
+# udp checksum { 33-55}
+set%d test-ip6 7
+set%d test-ip6 0
+	element 00000000  : 1 [end]	element 00002100  : 0 [end]	element 00003800  : 1 [end]
+ip6 test-ip6 input 
+  [ payload load 1b @ network header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 6 => reg 1 ]
+  [ lookup reg 1 set set%d ]
+
-- 
2.1.4

