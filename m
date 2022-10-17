Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76CBFC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230145AbiJQLE1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiJQLEW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 72E9CF3C
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:21 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 12/16] tests: py: add geneve tests
Date:   Mon, 17 Oct 2022 13:04:04 +0200
Message-Id: <20221017110408.742223-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221017110408.742223-1-pablo@netfilter.org>
References: <20221017110408.742223-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/geneve.t         |  23 +++++++
 tests/py/inet/geneve.t.payload | 114 +++++++++++++++++++++++++++++++++
 2 files changed, 137 insertions(+)
 create mode 100644 tests/py/inet/geneve.t
 create mode 100644 tests/py/inet/geneve.t.payload

diff --git a/tests/py/inet/geneve.t b/tests/py/inet/geneve.t
new file mode 100644
index 000000000000..101f6dfcdb7e
--- /dev/null
+++ b/tests/py/inet/geneve.t
@@ -0,0 +1,23 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
+
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*netdev;test-netdev;ingress,egress
+
+geneve vni 10;fail
+udp dport 6081 geneve vni 10;ok
+udp dport 6081 geneve ip saddr 10.141.11.2;ok
+udp dport 6081 geneve ip saddr 10.141.11.0/24;ok
+udp dport 6081 geneve ip protocol 1;ok
+udp dport 6081 geneve udp sport 8888;ok
+udp dport 6081 geneve icmp type echo-reply;ok
+udp dport 6081 geneve ether saddr 62:87:4d:d6:19:05;ok
+udp dport 6081 geneve vlan id 10;ok
+udp dport 6081 geneve ip dscp 0x02;ok
+udp dport 6081 geneve ip dscp 0x02;ok
+udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 };ok
+
+udp dport 6081 geneve ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/geneve.t.payload b/tests/py/inet/geneve.t.payload
new file mode 100644
index 000000000000..1ce54de6cd3a
--- /dev/null
+++ b/tests/py/inet/geneve.t.payload
@@ -0,0 +1,114 @@
+# udp dport 6081 geneve vni 10
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 3b @ unknown header + 4 => reg 1 ] ]
+  [ cmp eq reg 1 0x000a0000 ]
+
+# udp dport 6081 geneve ip saddr 10.141.11.2
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x020b8d0a ]
+
+# udp dport 6081 geneve ip saddr 10.141.11.0/24
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 3b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x000b8d0a ]
+
+# udp dport 6081 geneve ip protocol 1
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 1b @ network header + 9 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# udp dport 6081 geneve udp sport 8888
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 2b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x0000b822 ]
+
+# udp dport 6081 geneve icmp type echo-reply
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 1b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# udp dport 6081 geneve ether saddr 62:87:4d:d6:19:05
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 6b @ link header + 6 => reg 1 ] ]
+  [ cmp eq reg 1 0xd64d8762 0x00000519 ]
+
+# udp dport 6081 geneve vlan id 10
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 2b @ link header + 14 => reg 1 ] ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000a00 ]
+
+# udp dport 6081 geneve ip dscp 0x02
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 1b @ network header + 1 => reg 1 ] ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000008 ]
+
+# udp dport 6081 geneve ip saddr . geneve ip daddr { 1.2.3.4 . 4.3.2.1 }
+__set%d test-ip4 3 size 1
+__set%d test-ip4 0
+	element 04030201 01020304  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ cmp eq reg 1 0x0000c117 ]
+  [ inner type 2 hdrsize 8 flags f [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ inner type 2 hdrsize 8 flags f [ payload load 4b @ network header + 16 => reg 9 ] ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.30.2

