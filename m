From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 2/2] tests: add tests for dup
Date: Tue, 29 Sep 2015 20:27:48 +0200
Message-ID: <1443551268-3317-2-git-send-email-pablo@netfilter.org>
References: <1443551268-3317-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37676 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965094AbbI2SVB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Sep 2015 14:21:01 -0400
In-Reply-To: <1443551268-3317-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/regression/ip/dup.t             |  6 ++++++
 tests/regression/ip/dup.t.payload     | 21 +++++++++++++++++++++
 tests/regression/ip/dup.t.payload.got | 26 ++++++++++++++++++++++++++
 tests/regression/ip6/dup.t            |  6 ++++++
 tests/regression/ip6/dup.t.payload    | 21 +++++++++++++++++++++
 5 files changed, 80 insertions(+)
 create mode 100644 tests/regression/ip/dup.t
 create mode 100644 tests/regression/ip/dup.t.payload
 create mode 100644 tests/regression/ip/dup.t.payload.got
 create mode 100644 tests/regression/ip6/dup.t
 create mode 100644 tests/regression/ip6/dup.t.payload

diff --git a/tests/regression/ip/dup.t b/tests/regression/ip/dup.t
new file mode 100644
index 0000000..9320d54
--- /dev/null
+++ b/tests/regression/ip/dup.t
@@ -0,0 +1,6 @@
+*ip;test-ip4
+:input;type filter hook input priority 0
+
+dup to 192.168.2.1;ok
+dup to 192.168.2.1 device eth0;ok
+dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0;ok
diff --git a/tests/regression/ip/dup.t.payload b/tests/regression/ip/dup.t.payload
new file mode 100644
index 0000000..7928d5d
--- /dev/null
+++ b/tests/regression/ip/dup.t.payload
@@ -0,0 +1,21 @@
+# dup to 192.168.2.1
+ip test-ip4 test 
+  [ immediate reg 1 0x0102a8c0 ]
+  [ dup sreg_addr 1 ]
+
+# dup to 192.168.2.1 device eth0
+ip test-ip4 test 
+  [ immediate reg 1 0x0102a8c0 ]
+  [ immediate reg 2 0x00000002 ]
+  [ dup sreg_addr 1 sreg_dev 2 ]
+
+# dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0
+map%d test-ip4 b
+map%d test-ip4 0
+        element 7802a8c0  : 0102a8c0 0 [end]
+ip test-ip4 test 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ immediate reg 2 0x00000002 ]
+  [ dup sreg_addr 1 sreg_dev 2 ]
+
diff --git a/tests/regression/ip/dup.t.payload.got b/tests/regression/ip/dup.t.payload.got
new file mode 100644
index 0000000..23e0a7e
--- /dev/null
+++ b/tests/regression/ip/dup.t.payload.got
@@ -0,0 +1,26 @@
+# dup to 192.168.2.1 device eth0
+ip test-ip4 input 
+  [ immediate reg 1 0x0102a8c0 ]
+  [ immediate reg 2 0x00000002 0x00000000 0x00000000 0x00000000 ]
+  [ dup sreg_addr 1  sreg_dev 2 ]
+
+# dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0
+map%d test-ip4 b
+map%d test-ip4 0
+	element 7802a8c0  : 0102a8c0 0 [end]
+ip test-ip4 input 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ immediate reg 2 0x00000002 0x00000000 0x00000000 0x00000000 ]
+  [ dup sreg_addr 1  sreg_dev 2 ]
+
+# dup to ip saddr map { 192.168.2.120 : 192.168.2.1 } device eth0
+map%d test-ip4 b
+map%d test-ip4 0
+	element 7802a8c0  : 0102a8c0 0 [end]
+ip test-ip4 input 
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ immediate reg 2 0x00000002 0x00000000 0x00000000 0x00000000 ]
+  [ dup sreg_addr 1 sreg_dev 2 ]
+
diff --git a/tests/regression/ip6/dup.t b/tests/regression/ip6/dup.t
new file mode 100644
index 0000000..34f302f
--- /dev/null
+++ b/tests/regression/ip6/dup.t
@@ -0,0 +1,6 @@
+*ip6;test-ip6
+:input;type filter hook input priority 0
+
+dup to abcd::1;ok
+dup to abcd::1 device eth0;ok
+dup to ip6 saddr map { abcd::1 : cafe::cafe } device eth0;ok
diff --git a/tests/regression/ip6/dup.t.payload b/tests/regression/ip6/dup.t.payload
new file mode 100644
index 0000000..1df414c
--- /dev/null
+++ b/tests/regression/ip6/dup.t.payload
@@ -0,0 +1,21 @@
+# dup to abcd::1
+ip6 test test 
+  [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
+  [ dup sreg_addr 1 ]
+
+# dup to abcd::1 device eth0
+ip6 test test 
+  [ immediate reg 1 0x0000cdab 0x00000000 0x00000000 0x01000000 ]
+  [ immediate reg 2 0x00000002 ]
+  [ dup sreg_addr 1 sreg_dev 2 ]
+
+# dup to ip6 saddr map { abcd::1 : cafe::cafe } device eth0
+map%d test-ip6 b
+map%d test-ip6 0
+        element 0000cdab 00000000 00000000 01000000  : 0000feca 00000000 00000000 feca0000 0 [end]
+ip6 test-ip6 input 
+  [ payload load 16b @ network header + 8 => reg 1 ]
+  [ lookup reg 1 set map%d dreg 1 ]
+  [ immediate reg 2 0x00000002 ]
+  [ dup sreg_addr 1 sreg_dev 2 ]
+
-- 
2.1.4

