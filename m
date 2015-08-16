From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 11/12] tests: vlan tests
Date: Sun, 16 Aug 2015 21:05:54 +0200
Message-ID: <1439751955-31190-12-git-send-email-fw@strlen.de>
References: <1439751955-31190-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:34752 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751AbbHPTGQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Aug 2015 15:06:16 -0400
In-Reply-To: <1439751955-31190-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

add a few regression tests that match vlan id/dei/pcp fields
of the vlan header.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/regression/bridge/vlan.t         |  33 ++++++
 tests/regression/bridge/vlan.t.payload | 190 +++++++++++++++++++++++++++++++++
 2 files changed, 223 insertions(+)
 create mode 100644 tests/regression/bridge/vlan.t
 create mode 100644 tests/regression/bridge/vlan.t.payload

diff --git a/tests/regression/bridge/vlan.t b/tests/regression/bridge/vlan.t
new file mode 100644
index 0000000..e80ea50
--- /dev/null
+++ b/tests/regression/bridge/vlan.t
@@ -0,0 +1,33 @@
+*bridge;test-bridge
+:input;type filter hook input priority 0
+
+vlan id 4094;ok
+vlan id 0;ok
+# bad vlan id
+vlan id 4096;fail
+vlan id 4094 vlan cfi 0;ok
+vlan id 4094 vlan cfi 1;ok
+# bad cfi
+vlan id 4094 vlan cfi 2;fail
+vlan id 4094 vlan cfi 1 vlan pcp 8;fail
+vlan id 4094 vlan cfi 1 vlan pcp 7;ok
+vlan id 4094 vlan cfi 1 vlan pcp 3;ok
+
+ether type vlan vlan id 4094;ok;vlan id 4094
+ether type vlan vlan id 0;ok;vlan id 0
+ether type vlan vlan id 4094 vlan cfi 0;ok;vlan id 4094 vlan cfi 0
+ether type vlan vlan id 4094 vlan cfi 1;ok;vlan id 4094 vlan cfi 1
+ether type vlan vlan id 4094 vlan cfi 2;fail
+
+vlan id 4094 tcp dport 22;ok
+vlan id 1 ip saddr 10.0.0.1;ok
+vlan id 1 ip saddr 10.0.0.0/23;ok
+vlan id 1 ip saddr 10.0.0.0/23 udp dport 53;ok
+ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53;ok;vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
+
+vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3;ok
+vlan id { 1, 2, 4, 100, 4096 };fail
+
+# illegal dependencies
+ether type ip vlan id 1;fail
+ether type ip vlan id 1 ip saddr 10.0.0.1;fail
diff --git a/tests/regression/bridge/vlan.t.payload b/tests/regression/bridge/vlan.t.payload
new file mode 100644
index 0000000..4a5714a
--- /dev/null
+++ b/tests/regression/bridge/vlan.t.payload
@@ -0,0 +1,190 @@
+# vlan id 4094
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+
+# vlan id 0
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# vlan id 4094 vlan cfi 0
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# vlan id 4094 vlan cfi 1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+
+# ether type vlan vlan id 4094
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+
+# ether type vlan vlan id 0
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ether type vlan vlan id 4094 vlan cfi 0
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ether type vlan vlan id 4094 vlan cfi 1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+
+# vlan id 4094 tcp dport 22
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00001600 ]
+
+# vlan id 1 ip saddr 10.0.0.1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x0100000a ]
+
+# vlan id 1 ip saddr 10.0.0.0/23
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000a ]
+
+# vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00003500 ]
+
+# ether type vlan vlan id 1 ip saddr 10.0.0.0/23 udp dport 53
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+  [ payload load 2b @ link header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00feffff ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 1b @ network header + 9 => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x00003500 ]
+
+# vlan id 4094 vlan cfi 1 vlan pcp 7
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x000000e0 ]
+
+# vlan id 4094 vlan cfi 1 vlan pcp 3
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000060 ]
+
+# vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
+set%d test-bridge 3
+set%d test-bridge 0
+	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+  [ payload load 1b @ link header + 15 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000001 ]
+  [ cmp lte reg 1 0x00000003 ]
+
-- 
2.0.5

