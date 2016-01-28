From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft 11/11] tests/py: test vlan on ingress
Date: Thu, 28 Jan 2016 22:25:00 +0100
Message-ID: <1454016300-29969-12-git-send-email-pablo@netfilter.org>
References: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43806 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755852AbcA1VZX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jan 2016 16:25:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9810DC8815
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 87D14DA809
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6CE24DA795
	for <netfilter-devel@vger.kernel.org>; Thu, 28 Jan 2016 22:25:20 +0100 (CET)
In-Reply-To: <1454016300-29969-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This generates the same code as bridge does, but it includes this check
in first place.

  [ meta load iiftype => reg 1 ]
  [ cmp eq reg 1 0x00000001 ]

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/bridge/vlan.t                |   2 +
 tests/py/bridge/vlan.t.payload.netdev | 235 ++++++++++++++++++++++++++++++++++
 2 files changed, 237 insertions(+)
 create mode 100644 tests/py/bridge/vlan.t.payload.netdev

diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index e7c75bb..526d7cc 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -1,6 +1,8 @@
 :input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
 
 *bridge;test-bridge;input
+*netdev;test-netdev;ingress
 
 vlan id 4094;ok
 vlan id 0;ok
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
new file mode 100644
index 0000000..62c7adf
--- /dev/null
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -0,0 +1,235 @@
+# vlan id 4094
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+
+# vlan id 0
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# vlan id 4094 vlan cfi 0
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# vlan id 4094 vlan cfi != 1
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000010 ]
+
+# vlan id 4094 vlan cfi 1
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+
+# ether type vlan vlan id 4094
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+
+# ether type vlan vlan id 0
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ether type vlan vlan id 4094 vlan cfi 0
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# ether type vlan vlan id 4094 vlan cfi 1
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+
+# vlan id 4094 tcp dport 22
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
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
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
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
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
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
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
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
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
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
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x000000e0 ]
+
+# vlan id 4094 vlan cfi 1 vlan pcp 3
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x0000fe0f ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x00000010 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000010 ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000060 ]
+
+# vlan id { 1, 2, 4, 100, 4095 } vlan pcp 1-3
+set%d test-netdev 3
+set%d test-netdev 0
+	element 00000100  : 0 [end]	element 00000200  : 0 [end]	element 00000400  : 0 [end]	element 00006400  : 0 [end]	element 0000ff0f  : 0 [end]
+netdev test-netdev ingress 
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ lookup reg 1 set set%d ]
+  [ payload load 1b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000000e0 ) ^ 0x00000000 ]
+  [ cmp gte reg 1 0x00000001 ]
+  [ cmp lte reg 1 0x00000003 ]
+
-- 
2.1.4

