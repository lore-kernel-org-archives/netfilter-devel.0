Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D472C4338F
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 10:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3F25660F9D
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Jul 2021 10:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhG1KPs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Jul 2021 06:15:48 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38268 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhG1KPs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Jul 2021 06:15:48 -0400
Received: from salvia.lan (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1B4E0642BE
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Jul 2021 12:15:16 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: check more flag match transformations to compact syntax
Date:   Wed, 28 Jul 2021 12:15:37 +0200
Message-Id: <20210728101540.2020-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a few more tests to extend coverage.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/tcp.t         |   6 ++
 tests/py/inet/tcp.t.json    | 139 ++++++++++++++++++++++++++++++++++++
 tests/py/inet/tcp.t.payload |  48 +++++++++++++
 3 files changed, 193 insertions(+)

diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index dece9eaa89f8..afa70d85d6b4 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -70,11 +70,17 @@ tcp flags == syn;ok
 tcp flags fin,syn / fin,syn;ok
 tcp flags != syn / fin,syn;ok
 tcp flags & syn != 0;ok;tcp flags syn
+tcp flags & syn == 0;ok;tcp flags ! syn
+tcp flags & (syn | ack) != 0;ok;tcp flags syn,ack
+tcp flags & (syn | ack) == 0;ok;tcp flags ! syn,ack
 # it should be possible to transform this to: tcp flags syn
 tcp flags & syn == syn;ok
 tcp flags & (fin | syn | rst | ack) syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) == syn;ok;tcp flags syn / fin,syn,rst,ack
 tcp flags & (fin | syn | rst | ack) != syn;ok;tcp flags != syn / fin,syn,rst,ack
+tcp flags & (fin | syn | rst | ack) == (syn | ack);ok;tcp flags syn,ack / fin,syn,rst,ack
+tcp flags & (fin | syn | rst | ack) != (syn | ack);ok;tcp flags != syn,ack / fin,syn,rst,ack
+tcp flags & (syn | ack) == (syn | ack);ok;tcp flags syn,ack / syn,ack
 tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr;ok;tcp flags == 0xff
 tcp flags { syn, syn | ack };ok
 tcp flags & (fin | syn | rst | psh | ack | urg) == { fin, ack, psh | ack, fin | psh | ack };ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index 23244eaa2339..615bc68f881f 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1521,6 +1521,22 @@
     }
 ]
 
+# tcp flags & syn == 0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "!",
+            "right": "syn"
+        }
+    }
+]
+
 # tcp flags & syn != 0
 [
     {
@@ -1537,6 +1553,44 @@
     }
 ]
 
+# tcp flags & (syn | ack) != 0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "in",
+            "right": [
+                "syn",
+                "ack"
+            ]
+        }
+    }
+]
+
+# tcp flags & (syn | ack) == 0
+[
+    {
+        "match": {
+            "left": {
+                "payload": {
+                    "field": "flags",
+                    "protocol": "tcp"
+                }
+            },
+            "op": "!",
+            "right": [
+                "syn",
+                "ack"
+            ]
+        }
+    }
+]
+
 # tcp flags & syn == syn
 [
     {
@@ -1637,3 +1691,88 @@
     }
 ]
 
+# tcp flags & (fin | syn | rst | ack) == (syn | ack)
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    [
+                        "fin",
+                        "syn",
+                        "rst",
+                        "ack"
+                    ]
+                ]
+            },
+            "op": "==",
+            "right": [
+                "syn",
+                "ack"
+            ]
+        }
+    }
+]
+
+# tcp flags & (fin | syn | rst | ack) != (syn | ack)
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    [
+                        "fin",
+                        "syn",
+                        "rst",
+                        "ack"
+                    ]
+                ]
+            },
+            "op": "!=",
+            "right": [
+                "syn",
+                "ack"
+            ]
+        }
+    }
+]
+
+# tcp flags & (syn | ack) == (syn | ack)
+[
+    {
+        "match": {
+            "left": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "flags",
+                            "protocol": "tcp"
+                        }
+                    },
+                    [
+                        "syn",
+                        "ack"
+                    ]
+                ]
+            },
+            "op": "==",
+            "right": [
+                "syn",
+                "ack"
+            ]
+        }
+    }
+]
+
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 4e795aa931ac..8aeeaee39aea 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -378,6 +378,30 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000000 ]
 
+# tcp flags & syn == 0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000002 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
+# tcp flags & (syn | ack) != 0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000000 ]
+
+# tcp flags & (syn | ack) == 0
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000000 ]
+
 # tcp flags & syn == syn
 inet test-inet input
   [ meta load l4proto => reg 1 ]
@@ -410,6 +434,30 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000002 ]
 
+# tcp flags & (fin | syn | rst | ack) == (syn | ack)
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000012 ]
+
+# tcp flags & (fin | syn | rst | ack) != (syn | ack)
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000017 ) ^ 0x00000000 ]
+  [ cmp neq reg 1 0x00000012 ]
+
+# tcp flags & (syn | ack) == (syn | ack)
+inet test-inet input
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 1b @ transport header + 13 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000012 ) ^ 0x00000000 ]
+  [ cmp eq reg 1 0x00000012 ]
+
 # tcp flags & (fin | syn | rst | psh | ack | urg | ecn | cwr) == fin | syn | rst | psh | ack | urg | ecn | cwr
 inet test-inet input
   [ meta load l4proto => reg 1 ]
-- 
2.20.1

