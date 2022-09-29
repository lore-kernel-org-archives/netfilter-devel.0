Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5B93C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Sep 2022 13:01:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiI2NBz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbiI2NBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Sep 2022 09:01:37 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E98316F9F3
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Sep 2022 06:01:33 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1odtAR-000320-C6; Thu, 29 Sep 2022 15:01:31 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/3] tests: py: add vlan test case for ip/inet family
Date:   Thu, 29 Sep 2022 15:01:13 +0200
Message-Id: <20220929130113.22289-4-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220929130113.22289-1-fw@strlen.de>
References: <20220929130113.22289-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

before fixup, this failed with:

line 4: 'add rule ip test-ip4 input vlan id 1': '[ payload load 2b @ link header + 12 => reg 1 ]' mismatches '[ payload load 2b @ link header + 0 => reg 1 ]'

... because the auto-dependency did not add the preceeding ethernet
header, so vlan was using the wrong offset.

Note than vlan id match in inet input families will only work if header
removal was disabled, i.e.

... add link vethin1 name vethin1.3 type vlan id 3 reorder_hdr off

otherwise, kernel will strip the vlan tag and interface appears as
a normal ethernet interface.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/py/inet/ether.t                |  6 ++++++
 tests/py/inet/ether.t.json           | 32 ++++++++++++++++++++++++++++
 tests/py/inet/ether.t.payload        | 20 +++++++++++++++++
 tests/py/inet/ether.t.payload.bridge | 16 ++++++++++++++
 tests/py/inet/ether.t.payload.ip     | 20 +++++++++++++++++
 5 files changed, 94 insertions(+)

diff --git a/tests/py/inet/ether.t b/tests/py/inet/ether.t
index c4b1ced7a685..8625f70b7793 100644
--- a/tests/py/inet/ether.t
+++ b/tests/py/inet/ether.t
@@ -12,3 +12,9 @@ tcp dport 22 iiftype ether ether saddr 00:0f:54:0c:11:4 accept;ok;tcp dport 22 e
 tcp dport 22 ether saddr 00:0f:54:0c:11:04 accept;ok
 
 ether saddr 00:0f:54:0c:11:04 accept;ok
+
+vlan id 1;ok
+ether type vlan vlan id 2;ok;vlan id 2
+
+# invalid dependency
+ether type ip vlan id 1;fail
diff --git a/tests/py/inet/ether.t.json b/tests/py/inet/ether.t.json
index 84b184c71ac3..c7a7f88687f8 100644
--- a/tests/py/inet/ether.t.json
+++ b/tests/py/inet/ether.t.json
@@ -88,3 +88,35 @@
     }
 ]
 
+# vlan id 1
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 1
+        }
+    }
+]
+
+# ether type vlan vlan id 2
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "id",
+                    "protocol": "vlan"
+                }
+            },
+            "op": "==",
+            "right": 2
+        }
+    }
+]
+
diff --git a/tests/py/inet/ether.t.payload b/tests/py/inet/ether.t.payload
index 53648413d588..8b74a7815d8e 100644
--- a/tests/py/inet/ether.t.payload
+++ b/tests/py/inet/ether.t.payload
@@ -30,3 +30,23 @@ inet test-inet input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
+# vlan id 1
+netdev test-netdev ingress
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# ether type vlan vlan id 2
+netdev test-netdev ingress
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+
diff --git a/tests/py/inet/ether.t.payload.bridge b/tests/py/inet/ether.t.payload.bridge
index e9208008214a..0128d5f02b97 100644
--- a/tests/py/inet/ether.t.payload.bridge
+++ b/tests/py/inet/ether.t.payload.bridge
@@ -26,3 +26,19 @@ bridge test-bridge input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
+# vlan id 1
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# ether type vlan vlan id 2
+bridge test-bridge input
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+
diff --git a/tests/py/inet/ether.t.payload.ip b/tests/py/inet/ether.t.payload.ip
index a604f603c69e..7c91f412c33e 100644
--- a/tests/py/inet/ether.t.payload.ip
+++ b/tests/py/inet/ether.t.payload.ip
@@ -30,3 +30,23 @@ ip test-ip4 input
   [ cmp eq reg 1 0x0c540f00 0x00000411 ]
   [ immediate reg 0 accept ]
 
+# vlan id 1
+ip test-ip4 input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000100 ]
+
+# ether type vlan vlan id 2
+ip test-ip4 input
+  [ meta load iiftype => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ link header + 12 => reg 1 ]
+  [ cmp eq reg 1 0x00000081 ]
+  [ payload load 2b @ link header + 14 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000ff0f ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000200 ]
+
-- 
2.35.1

