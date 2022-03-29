Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 139D3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Mar 2022 11:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiC2MAo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Mar 2022 08:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236157AbiC2MAi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Mar 2022 08:00:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7E083DE8A
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 04:58:49 -0700 (PDT)
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id E35926302B
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2022 13:55:36 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] tests: py: add inet/vmap tests
Date:   Tue, 29 Mar 2022 13:58:44 +0200
Message-Id: <20220329115844.1163197-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add a few tests with concatenations including raw and integer type
expressions.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/inet/vmap.t                |  10 ++
 tests/py/inet/vmap.t.json           | 144 ++++++++++++++++++++++++++++
 tests/py/inet/vmap.t.payload        |  34 +++++++
 tests/py/inet/vmap.t.payload.netdev |  34 +++++++
 4 files changed, 222 insertions(+)
 create mode 100644 tests/py/inet/vmap.t
 create mode 100644 tests/py/inet/vmap.t.json
 create mode 100644 tests/py/inet/vmap.t.payload
 create mode 100644 tests/py/inet/vmap.t.payload.netdev

diff --git a/tests/py/inet/vmap.t b/tests/py/inet/vmap.t
new file mode 100644
index 000000000000..0ac6e561b554
--- /dev/null
+++ b/tests/py/inet/vmap.t
@@ -0,0 +1,10 @@
+:input;type filter hook input priority 0
+:ingress;type filter hook ingress device lo priority 0
+:egress;type filter hook egress device lo priority 0
+
+*inet;test-inet;input
+*netdev;test-netdev;ingress,egress
+
+iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop };ok;iifname . ip protocol . th dport vmap { "eth0" . 6 . 22 : accept, "eth1" . 17 . 67 : drop }
+ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e };ok
+udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept };ok
diff --git a/tests/py/inet/vmap.t.json b/tests/py/inet/vmap.t.json
new file mode 100644
index 000000000000..37472cc629fd
--- /dev/null
+++ b/tests/py/inet/vmap.t.json
@@ -0,0 +1,144 @@
+# iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        {
+                            "concat": [
+                                "eth0",
+                                6,
+                                22
+                            ]
+                        },
+                        {
+                            "accept": null
+                        }
+                    ],
+                    [
+                        {
+                            "concat": [
+                                "eth1",
+                                17,
+                                67
+                            ]
+                        },
+                        {
+                            "drop": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "concat": [
+                    {
+                        "meta": {
+                            "key": "iifname"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "protocol",
+                            "protocol": "ip"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "th"
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
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
+                            "base": "ih",
+                            "len": 32,
+                            "offset": 32
+                        }
+                    }
+                ]
+            },
+            "op": "==",
+            "right": {
+                "set": [
+                    {
+                        "concat": [
+                            "1.1.1.1",
+                            20
+                        ]
+                    },
+                    {
+                        "concat": [
+                            "2.2.2.2",
+                            30
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
+# udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
+[
+    {
+        "vmap": {
+            "data": {
+                "set": [
+                    [
+                        {
+                            "concat": [
+                                {
+                                    "range": [
+                                        47,
+                                        63
+                                    ]
+                                },
+                                "0xe373135363130333131303735353203"
+                            ]
+                        },
+                        {
+                            "accept": null
+                        }
+                    ]
+                ]
+            },
+            "key": {
+                "concat": [
+                    {
+                        "payload": {
+                            "field": "length",
+                            "protocol": "udp"
+                        }
+                    },
+                    {
+                        "payload": {
+                            "base": "th",
+                            "len": 128,
+                            "offset": 160
+                        }
+                    }
+                ]
+            }
+        }
+    }
+]
+
diff --git a/tests/py/inet/vmap.t.payload b/tests/py/inet/vmap.t.payload
new file mode 100644
index 000000000000..29ec846deb2e
--- /dev/null
+++ b/tests/py/inet/vmap.t.payload
@@ -0,0 +1,34 @@
+# iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
+__map%d test-inet b size 2
+__map%d test-inet 0
+	element 30687465 00000000 00000000 00000000 00000006 00001600  : accept 0 [end]	element 31687465 00000000 00000000 00000000 00000011 00004300  : drop 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ meta load iifname => reg 1 ]
+  [ payload load 1b @ network header + 9 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 13 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
+__set%d test-inet 3 size 2
+__set%d test-inet 0
+        element 01010101 14000000  : 0 [end]    element 02020202 1e000000  : 0 [end]
+inet test-inet input
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ inner header + 4 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
+# udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
+__map%d x 8f size 1
+__map%d x 0
+	element 00002f00 3531370e 33303136 37303131 03323535  - 00003f00 3531370e 33303136 37303131 03323535  : accept 0 [end]
+inet x y
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ payload load 16b @ transport header + 20 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
diff --git a/tests/py/inet/vmap.t.payload.netdev b/tests/py/inet/vmap.t.payload.netdev
new file mode 100644
index 000000000000..3f51bb33054a
--- /dev/null
+++ b/tests/py/inet/vmap.t.payload.netdev
@@ -0,0 +1,34 @@
+# iifname . ip protocol . th dport vmap { "eth0" . tcp . 22 : accept, "eth1" . udp . 67 : drop }
+__map%d test-netdev b size 2
+__map%d test-netdev 0
+	element 30687465 00000000 00000000 00000000 00000006 00001600  : accept 0 [end]	element 31687465 00000000 00000000 00000000 00000011 00004300  : drop 0 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ meta load iifname => reg 1 ]
+  [ payload load 1b @ network header + 9 => reg 2 ]
+  [ payload load 2b @ transport header + 2 => reg 13 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
+# ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
+__set%d test-netdev 3 size 2
+__set%d test-netdev 0
+	element 01010101 14000000  : 0 [end]	element 02020202 1e000000  : 0 [end]
+netdev test-netdev ingress
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 4b @ network header + 12 => reg 1 ]
+  [ payload load 4b @ inner header + 4 => reg 9 ]
+  [ lookup reg 1 set __set%d ]
+
+# udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
+__map%d test-netdev 8f size 1
+__map%d test-netdev 0
+	element 00002f00 3531370e 33303136 37303131 03323535  - 00003f00 3531370e 33303136 37303131 03323535  : accept 0 [end]
+netdev test-netdev ingress
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000011 ]
+  [ payload load 2b @ transport header + 4 => reg 1 ]
+  [ payload load 16b @ transport header + 20 => reg 9 ]
+  [ lookup reg 1 set __map%d dreg 0 ]
+
-- 
2.30.2

