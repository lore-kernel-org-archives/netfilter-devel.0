Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C2C8C43219
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbiJQLEb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiJQLEX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A35F9309
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:22 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 15/16] tests: py: add gretap tests
Date:   Mon, 17 Oct 2022 13:04:07 +0200
Message-Id: <20221017110408.742223-16-pablo@netfilter.org>
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
 tests/py/inet/gretap.t         | 21 ++++++++
 tests/py/inet/gretap.t.payload | 87 ++++++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)
 create mode 100644 tests/py/inet/gretap.t
 create mode 100644 tests/py/inet/gretap.t.payload

diff --git a/tests/py/inet/gretap.t b/tests/py/inet/gretap.t
new file mode 100644
index 000000000000..cd7ee2158ede
--- /dev/null
+++ b/tests/py/inet/gretap.t
@@ -0,0 +1,21 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
+
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*netdev;test-netdev;ingress,egress
+
+gretap ip saddr 10.141.11.2;ok
+gretap ip saddr 10.141.11.0/24;ok
+gretap ip protocol 1;ok
+gretap udp sport 8888;ok
+gretap icmp type echo-reply;ok
+gretap ether saddr 62:87:4d:d6:19:05;ok
+gretap vlan id 10;ok
+gretap ip dscp 0x02;ok
+gretap ip dscp 0x02;ok
+gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 };ok
+
+gretap ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/gretap.t.payload b/tests/py/inet/gretap.t.payload
new file mode 100644
index 000000000000..654c71e4541a
--- /dev/null
+++ b/tests/py/inet/gretap.t.payload
@@ -0,0 +1,87 @@
+# gretap ip saddr 10.141.11.2
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x020b8d0a ]
+
+# gretap ip saddr 10.141.11.0/24
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 3b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x000b8d0a ]
+
+# gretap ip protocol 1
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 1b @ network header + 9 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# gretap udp sport 8888
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 2b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x0000b822 ]
+
+# gretap icmp type echo-reply
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 1b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# gretap ether saddr 62:87:4d:d6:19:05
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 6b @ link header + 6 => reg 1 ] ]
+  [ cmp eq reg 1 0xd64d8762 0x00000519 ]
+
+# gretap vlan id 10
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 2b @ link header + 14 => reg 1 ] ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000a00 ]
+
+# gretap ip dscp 0x02
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 1b @ network header + 1 => reg 1 ] ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000008 ]
+
+# gretap ip saddr . gretap ip daddr { 1.2.3.4 . 4.3.2.1 }
+__set%d test-ip4 3 size 1
+__set%d test-ip4 0
+	element 04030201 01020304  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 4 hdrsize 4 flags e [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ inner type 4 hdrsize 4 flags e [ payload load 4b @ network header + 16 => reg 9 ] ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.30.2

