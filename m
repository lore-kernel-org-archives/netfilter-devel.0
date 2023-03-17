Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5934C761A6
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 09:58:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjCQJ6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 05:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCQJ6n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 05:58:43 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 023E0193F3
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 02:58:42 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 7/9] tests: py: add test-cases for ct and packet mark payload expressions
Date:   Fri, 17 Mar 2023 10:58:31 +0100
Message-Id: <20230317095833.1225401-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230317095833.1225401-1-pablo@netfilter.org>
References: <20230317095833.1225401-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new test-cases to verify that defining a rule that sets the ct or
packet mark to a value derived from a payload works correctly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ct.t            |  2 ++
 tests/py/ip/ct.t.json       | 58 +++++++++++++++++++++++++++++++++++++
 tests/py/ip/ct.t.payload    | 18 ++++++++++++
 tests/py/ip/meta.t          |  3 ++
 tests/py/ip/meta.t.json     | 58 +++++++++++++++++++++++++++++++++++++
 tests/py/ip/meta.t.payload  | 17 +++++++++++
 tests/py/ip6/ct.t           |  6 ++++
 tests/py/ip6/ct.t.payload   | 19 ++++++++++++
 tests/py/ip6/meta.t         |  3 ++
 tests/py/ip6/meta.t.json    | 58 +++++++++++++++++++++++++++++++++++++
 tests/py/ip6/meta.t.payload | 20 +++++++++++++
 11 files changed, 262 insertions(+)
 create mode 100644 tests/py/ip6/ct.t
 create mode 100644 tests/py/ip6/ct.t.payload

diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index a387863e0d8e..eea9fd4e0562 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -28,3 +28,5 @@ meta mark set ct original saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x00000
 meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e };ok
 ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
 ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
+ct mark set ip dscp << 2 | 0x10;ok
+ct mark set ip dscp << 26 | 0x10;ok
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index 3288413f8f3f..e739b5f65bfe 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -325,3 +325,61 @@
         }
     }
 ]
+
+# ct mark set ip dscp << 2 | 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip"
+                                }
+                            },
+                            2
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip dscp << 26 | 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip"
+                                }
+                            },
+                            26
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 49f06a8401f5..45dba3390940 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -84,3 +84,21 @@ ip
   [ ct load src_ip => reg 1 , dir original ]
   [ meta load mark => reg 9 ]
   [ lookup reg 1 set __set%d ]
+
+# ct mark set ip dscp << 2 | 0x10
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp << 26 | 0x10
+ip
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 85eaf54ce723..a88a6145559d 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -17,3 +17,6 @@ meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
 
 meta mark set ip dscp;ok
+
+meta mark set ip dscp << 2 | 0x10;ok
+meta mark set ip dscp << 26 | 0x10;ok
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index a93d7e781ce1..25936dba98b9 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -176,3 +176,61 @@
     }
 ]
 
+# meta mark set ip dscp << 2 | 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip"
+                                }
+                            },
+                            2
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
+
+
+# meta mark set ip dscp << 26 | 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip"
+                                }
+                            },
+                            26
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/meta.t.payload b/tests/py/ip/meta.t.payload
index 1aa8d003b1d4..880ac5d6c707 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -59,3 +59,20 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ meta set mark with reg 1 ]
 
+# meta mark set ip dscp << 2 | 0x10
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip dscp << 26 | 0x10
+ip
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
diff --git a/tests/py/ip6/ct.t b/tests/py/ip6/ct.t
new file mode 100644
index 000000000000..da69b7a910e4
--- /dev/null
+++ b/tests/py/ip6/ct.t
@@ -0,0 +1,6 @@
+:output;type filter hook output priority 0
+
+*ip6;test-ip6;output
+
+ct mark set ip6 dscp << 2 | 0x10;ok
+ct mark set ip6 dscp << 26 | 0x10;ok
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
new file mode 100644
index 000000000000..00768dae79f1
--- /dev/null
+++ b/tests/py/ip6/ct.t.payload
@@ -0,0 +1,19 @@
+# ct mark set ip6 dscp << 2 | 0x10
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip6 dscp << 26 | 0x10
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
index 471e14811975..c177b0815176 100644
--- a/tests/py/ip6/meta.t
+++ b/tests/py/ip6/meta.t
@@ -14,3 +14,6 @@ meta protocol ip6 udp dport 67;ok;udp dport 67
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
+
+meta mark set ip6 dscp << 2 | 0x10;ok
+meta mark set ip6 dscp << 26 | 0x10;ok
diff --git a/tests/py/ip6/meta.t.json b/tests/py/ip6/meta.t.json
index 351320d70f7c..5bd8b07bbc90 100644
--- a/tests/py/ip6/meta.t.json
+++ b/tests/py/ip6/meta.t.json
@@ -194,3 +194,61 @@
         }
     }
 ]
+
+# meta mark set ip6 dscp lshift 2 or 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip6"
+                                }
+                            },
+                            2
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
+
+# meta mark set ip6 dscp lshift 26 or 0x10
+[
+    {
+        "mangle": {
+            "key": {
+                "meta": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "|": [
+                    {
+                        "<<": [
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip6"
+                                }
+                            },
+                            26
+                        ]
+                    },
+                    16
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/meta.t.payload b/tests/py/ip6/meta.t.payload
index 0e3db6ba07f9..f0507dc47073 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -60,3 +60,23 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta mark set ip6 dscp << 2 | 0x10
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp << 26 | 0x10
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
-- 
2.30.2

