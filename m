Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD24E732D0
	for <netfilter-devel@archiver.kernel.org>; Fri, 29 Sep 2023 10:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjI2KUn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 29 Sep 2023 06:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbjI2KUm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2023 06:20:42 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6017EC0
        for <netfilter-devel@vger.kernel.org>; Fri, 29 Sep 2023 03:20:40 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qmAbu-0005G1-2E; Fri, 29 Sep 2023 12:20:38 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft] rule: never merge across non-expr statements
Date:   Fri, 29 Sep 2023 12:20:30 +0200
Message-ID: <20230929102033.22140-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The existing logic can merge across non-expression statements,
if there is only one payload expression.

Example:
ether saddr 00:11:22:33:44:55 counter ether type 8021q

is turned into
counter ether saddr 00:11:22:33:44:55 ether type 8021q

which isn't the same thing.

Fix this up and add test cases for adjacent vlan and ip header
fields.  'Counter' serves as a non-merge fence.

Currently we also prevent merging of the two saddr/daddr loads
in the 'ip' case, as two distinct 32 bit loads are handled by
the interpreter directly without a function call.

This might change at some point, so cover this too.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 src/rule.c                            |  6 ++----
 tests/py/bridge/vlan.t                |  2 ++
 tests/py/bridge/vlan.t.payload        |  8 ++++++++
 tests/py/bridge/vlan.t.payload.netdev | 10 ++++++++++
 tests/py/ip/ip.t                      |  3 +++
 tests/py/ip/ip.t.payload              | 15 +++++++++++++++
 6 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/src/rule.c b/src/rule.c
index 52c0672d4cf0..739b7a541583 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -2744,10 +2744,8 @@ static void stmt_reduce(const struct rule *rule)
 
 		/* Must not merge across other statements */
 		if (stmt->ops->type != STMT_EXPRESSION) {
-			if (idx < 2)
-				continue;
-
-			payload_do_merge(sa, idx);
+			if (idx >= 2)
+				payload_do_merge(sa, idx);
 			idx = 0;
 			continue;
 		}
diff --git a/tests/py/bridge/vlan.t b/tests/py/bridge/vlan.t
index 95bdff4f1b75..8fa90dac7416 100644
--- a/tests/py/bridge/vlan.t
+++ b/tests/py/bridge/vlan.t
@@ -52,3 +52,5 @@ ether saddr 00:01:02:03:04:05 vlan id 1;ok
 vlan id 2 ether saddr 0:1:2:3:4:6;ok;ether saddr 00:01:02:03:04:06 vlan id 2
 
 ether saddr . vlan id { 0a:0b:0c:0d:0e:0f . 42, 0a:0b:0c:0d:0e:0f . 4095 };ok
+
+ether saddr 00:11:22:33:44:55 counter ether type 8021q;ok
diff --git a/tests/py/bridge/vlan.t.payload b/tests/py/bridge/vlan.t.payload
index 62e4b89bd0b2..2592bb96ad7c 100644
--- a/tests/py/bridge/vlan.t.payload
+++ b/tests/py/bridge/vlan.t.payload
@@ -304,3 +304,11 @@ bridge test-bridge input
   [ payload load 2b @ link header + 14 => reg 10 ]
   [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
+
+# ether saddr 00:11:22:33:44:55 counter ether type 8021q
+bridge test-bridge input
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x33221100 0x00005544 ]
+  [ counter pkts 0 bytes 0 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
diff --git a/tests/py/bridge/vlan.t.payload.netdev b/tests/py/bridge/vlan.t.payload.netdev
index 1018d4c6588f..f33419470ad5 100644
--- a/tests/py/bridge/vlan.t.payload.netdev
+++ b/tests/py/bridge/vlan.t.payload.netdev
@@ -356,3 +356,13 @@ netdev test-netdev ingress
   [ payload load 2b @ link header + 14 => reg 10 ]
   [ bitwise reg 10 = ( reg 10 & 0x0000ff0f ) ^ 0x00000000 ]
   [ lookup reg 1 set __set%d ]
+
+# ether saddr 00:11:22:33:44:55 counter ether type 8021q
+bridge test-bridge input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 6b @ link header + 6 => reg 1 ]
+  [ cmp eq reg 1 0x33221100 0x00005544 ]
+  [ counter pkts 0 bytes 0 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index a8f0d8202400..720d9ae92b60 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -130,3 +130,6 @@ iif "lo" ip dscp set cs0;ok
 
 ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 };ok
 ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept };ok
+
+ip saddr 1.2.3.4 ip daddr 3.4.5.6;ok
+ip saddr 1.2.3.4 counter ip daddr 3.4.5.6;ok
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 8224d4cd46de..43605a361a7a 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -541,3 +541,18 @@ ip
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 0 ]
+
+# ip saddr 1.2.3.4 ip daddr 3.4.5.6
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x06050403 ]
+
+# ip saddr 1.2.3.4 counter ip daddr 3.4.5.6
+ip test-ip4 input
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x04030201 ]
+  [ counter pkts 0 bytes 0 ]
+  [ payload load 4b @ network header + 16 => reg 1 ]
+  [ cmp eq reg 1 0x06050403 ]
-- 
2.41.0

