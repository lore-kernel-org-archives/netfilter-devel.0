Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1992FC77B6F
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Mar 2023 16:59:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjCWQ7O (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 Mar 2023 12:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbjCWQ7L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Mar 2023 12:59:11 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 47973469B
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Mar 2023 09:59:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     jeremy@azazel.net, fw@strlen.de
Subject: [PATCH nft,v3 12/12] tests: py: extend test-cases for mark statements with bitwise expressions
Date:   Thu, 23 Mar 2023 17:58:55 +0100
Message-Id: <20230323165855.559837-13-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230323165855.559837-1-pablo@netfilter.org>
References: <20230323165855.559837-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add more tests to cover bitwise operation. Shift operations are used on
constant value which are reduced at evaluation time.

Shift takes precendence over AND and OR operations, otherwise use parens
to override this.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ct.t          |  4 ++
 tests/py/ip/ct.t.json     | 96 +++++++++++++++++++++++++++++++++++++++
 tests/py/ip/ct.t.payload  | 32 +++++++++++++
 tests/py/ip6/ct.t         |  3 ++
 tests/py/ip6/ct.t.json    | 72 +++++++++++++++++++++++++++++
 tests/py/ip6/ct.t.payload | 27 +++++++++++
 6 files changed, 234 insertions(+)

diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index eea9fd4e0562..a0a222893dd0 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -30,3 +30,7 @@ ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
 ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
 ct mark set ip dscp << 2 | 0x10;ok
 ct mark set ip dscp << 26 | 0x10;ok
+ct mark set ip dscp & 0x0f << 1;ok;ct mark set ip dscp & af33
+ct mark set ip dscp & 0x0f << 2;ok;ct mark set ip dscp & 0x3c
+ct mark set ip dscp | 0x04;ok
+ct mark set ip dscp | 1 << 20;ok;ct mark set ip dscp | 0x100000
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index e739b5f65bfe..915632aef076 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -383,3 +383,99 @@
         }
     }
 ]
+
+# ct mark set ip dscp & 0x0f << 1
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    "af33"
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip dscp & 0x0f << 2
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    60
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip dscp | 0x04
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
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip dscp | 1 << 20
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
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    1048576
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 45dba3390940..692011d0f860 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -102,3 +102,35 @@ ip
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp & 0x0f << 1
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000001e ) ^ 0x00000000 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp & 0x0f << 2
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp | 0x04
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp | 1 << 20
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffefffff ) ^ 0x00100000 ]
+  [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/ct.t b/tests/py/ip6/ct.t
index da69b7a910e4..c06fd6a0441d 100644
--- a/tests/py/ip6/ct.t
+++ b/tests/py/ip6/ct.t
@@ -4,3 +4,6 @@
 
 ct mark set ip6 dscp << 2 | 0x10;ok
 ct mark set ip6 dscp << 26 | 0x10;ok
+ct mark set ip6 dscp | 0x04;ok
+ct mark set ip6 dscp | 0xff000000;ok
+ct mark set ip6 dscp & 0x0f << 2;ok;ct mark set ip6 dscp & 0x3c
diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
index 7579a65ef791..7d8c88bb09cb 100644
--- a/tests/py/ip6/ct.t.json
+++ b/tests/py/ip6/ct.t.json
@@ -219,3 +219,75 @@
         }
     }
 ]
+
+# ct mark set ip6 dscp | 0x04
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
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    },
+                    4
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip6 dscp | 0xff000000
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
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    },
+                    4278190080
+                ]
+            }
+        }
+    }
+]
+
+# ct mark set ip6 dscp & 0x0f << 2
+[
+    {
+        "mangle": {
+            "key": {
+                "ct": {
+                    "key": "mark"
+                }
+            },
+            "value": {
+                "&": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip6"
+                        }
+                    },
+                    60
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 00768dae79f1..164149e93d17 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -17,3 +17,30 @@ ip6 test-ip6 output
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ip6 dscp | 0x04
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffffb ) ^ 0x00000004 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip6 dscp | 0xff000000
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 & 0x00ffffff ) ^ 0xff000000 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip6 dscp & 0x0f << 2
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
+  [ ct set mark with reg 1 ]
-- 
2.30.2

