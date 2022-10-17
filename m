Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D7DC4167B
	for <netfilter-devel@archiver.kernel.org>; Mon, 17 Oct 2022 11:04:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiJQLE3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 17 Oct 2022 07:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiJQLEW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 17 Oct 2022 07:04:22 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 393562DA
        for <netfilter-devel@vger.kernel.org>; Mon, 17 Oct 2022 04:04:20 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 09/16] tests: py: add gre tests
Date:   Mon, 17 Oct 2022 13:04:01 +0200
Message-Id: <20221017110408.742223-10-pablo@netfilter.org>
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
 tests/py/inet/gre.t         | 22 +++++++++++
 tests/py/inet/gre.t.payload | 78 +++++++++++++++++++++++++++++++++++++
 2 files changed, 100 insertions(+)
 create mode 100644 tests/py/inet/gre.t
 create mode 100644 tests/py/inet/gre.t.payload

diff --git a/tests/py/inet/gre.t b/tests/py/inet/gre.t
new file mode 100644
index 000000000000..a3e046a1aea5
--- /dev/null
+++ b/tests/py/inet/gre.t
@@ -0,0 +1,22 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
+
+*ip;test-ip4;input
+*ip6;test-ip6;input
+*inet;test-inet;input
+*netdev;test-netdev;ingress,egress
+
+gre version 0;ok
+gre ip saddr 10.141.11.2;ok
+gre ip saddr 10.141.11.0/24;ok
+gre ip protocol 1;ok
+gre udp sport 8888;ok
+gre icmp type echo-reply;ok
+gre ether saddr 62:87:4d:d6:19:05;fail
+gre vlan id 10;fail
+gre ip dscp 0x02;ok
+gre ip dscp 0x02;ok
+gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 };ok
+
+gre ip saddr set 1.2.3.4;fail
diff --git a/tests/py/inet/gre.t.payload b/tests/py/inet/gre.t.payload
new file mode 100644
index 000000000000..333133ede415
--- /dev/null
+++ b/tests/py/inet/gre.t.payload
@@ -0,0 +1,78 @@
+# gre version 0
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ payload load 1b @ transport header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000007 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# gre ip saddr 10.141.11.2
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x020b8d0a ]
+
+# gre ip saddr 10.141.11.0/24
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 3b @ network header + 12 => reg 1 ] ]
+  [ cmp eq reg 1 0x000b8d0a ]
+
+# gre ip protocol 1
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 1b @ network header + 9 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+
+# gre udp sport 8888
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 2b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x0000b822 ]
+
+# gre icmp type echo-reply
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ meta load l4proto => reg 1 ] ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 1b @ transport header + 0 => reg 1 ] ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# gre ip dscp 0x02
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 1b @ network header + 1 => reg 1 ] ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000008 ]
+
+# gre ip saddr . gre ip daddr { 1.2.3.4 . 4.3.2.1 }
+__set%d test-ip4 3 size 1
+__set%d test-ip4 0
+	element 04030201 01020304  : 0 [end]
+ip test-ip4 input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x0000002f ]
+  [ inner type 3 hdrsize 4 flags c [ meta load protocol => reg 1 ] ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 12 => reg 1 ] ]
+  [ inner type 3 hdrsize 4 flags c [ payload load 4b @ network header + 16 => reg 9 ] ]
+  [ lookup reg 1 set __set%d ]
+
-- 
2.30.2

