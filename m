Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B94E5C10DCE
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 02:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98F3E206D7
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 02:26:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgCGC0n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 6 Mar 2020 21:26:43 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:36972 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgCGC0n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Mar 2020 21:26:43 -0500
Received: from localhost ([::1]:50062 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1jAPAo-0001Xl-3c; Sat, 07 Mar 2020 03:26:42 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Eric Garver <e@erig.me>, netfilter-devel@vger.kernel.org
Subject: [nft PATCH v2 2/2] tests/py: Add tests involving concatenated ranges
Date:   Sat,  7 Mar 2020 03:26:33 +0100
Message-Id: <20200307022633.6181-2-phil@nwl.cc>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200307022633.6181-1-phil@nwl.cc>
References: <20200307022633.6181-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Very basic testing, just a set definition, a rule which references it
and another one with an anonymous set.

Sadly this is already enough to expose some pending issues:

* Payload dependency killing ignores the concatenated IP header
  expressions on LHS, so rule output is asymmetric.

* Anonymous sets don't accept concatenated ranges yet, so the second
  rule is manually disabled for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- New patch.
---
 tests/py/inet/sets.t                |  6 +++++
 tests/py/inet/sets.t.json           | 35 +++++++++++++++++++++++++++++
 tests/py/inet/sets.t.payload.bridge | 13 +++++++++++
 tests/py/inet/sets.t.payload.inet   | 11 +++++++++
 tests/py/inet/sets.t.payload.netdev | 12 ++++++++++
 5 files changed, 77 insertions(+)

diff --git a/tests/py/inet/sets.t b/tests/py/inet/sets.t
index daf8f2d6ca302..e0b0ee867f9b7 100644
--- a/tests/py/inet/sets.t
+++ b/tests/py/inet/sets.t
@@ -16,3 +16,9 @@ ip saddr != @set2 drop;fail
 
 ip6 daddr != @set2 accept;ok
 ip6 daddr @set1 drop;fail
+
+!set3 type ipv4_addr . ipv4_addr . inet_service flags interval;ok
+?set3 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535;ok
+
+ip saddr . ip daddr . tcp dport @set3 accept;ok
+-ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept;ok
diff --git a/tests/py/inet/sets.t.json b/tests/py/inet/sets.t.json
index bcb638f2664d5..58e19ef647058 100644
--- a/tests/py/inet/sets.t.json
+++ b/tests/py/inet/sets.t.json
@@ -36,3 +36,38 @@
     }
 ]
 
+# ip saddr . ip daddr . tcp dport @set3 accept
+[
+    {
+        "match": {
+            "left": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "saddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "daddr",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "tcp"
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": "@set3"
+        }
+    },
+    {
+        "accept": null
+    }
+]
+
diff --git a/tests/py/inet/sets.t.payload.bridge b/tests/py/inet/sets.t.payload.bridge
index f5aaab1d79bc6..089d9dd7a28dd 100644
--- a/tests/py/inet/sets.t.payload.bridge
+++ b/tests/py/inet/sets.t.payload.bridge
@@ -13,3 +13,16 @@ bridge test-inet input
   [ payload load 16b @ network header + 24 => reg 1 ]
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
+
+# ip saddr . ip daddr . tcp dport @set3 accept
+bridge 
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ lookup reg 1 set set3 ]
+  [ immediate reg 0 accept ]
+
diff --git a/tests/py/inet/sets.t.payload.inet b/tests/py/inet/sets.t.payload.inet
index 1584fc07451eb..c5acd6103a038 100644
--- a/tests/py/inet/sets.t.payload.inet
+++ b/tests/py/inet/sets.t.payload.inet
@@ -14,4 +14,15 @@ inet test-inet input
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
 
+# ip saddr . ip daddr . tcp dport @set3 accept
+inet 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ lookup reg 1 set set3 ]
+  [ immediate reg 0 accept ]
 
diff --git a/tests/py/inet/sets.t.payload.netdev b/tests/py/inet/sets.t.payload.netdev
index 9c94e38429fb7..82994eabf48b7 100644
--- a/tests/py/inet/sets.t.payload.netdev
+++ b/tests/py/inet/sets.t.payload.netdev
@@ -14,3 +14,15 @@ netdev test-netdev ingress
   [ lookup reg 1 set set2 0x1 ]
   [ immediate reg 0 accept ]
 
+# ip saddr . ip daddr . tcp dport @ set3 accept
+inet 
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ network header + 16 => reg 9 ]
+  [ payload load 2b @ transport header + 2 => reg 10 ]
+  [ lookup reg 1 set set3 ]
+  [ immediate reg 0 accept ]
+
-- 
2.25.1

