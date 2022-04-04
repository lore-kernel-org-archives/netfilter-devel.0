Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3406DC433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:28:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345277AbiDDMao (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344614AbiDDMaj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:39 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808BFEF
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dGANMoLUiBoDR4tUxANRQxbmRZe+tWeuRphxWaYUy40=; b=uN22rsTs1ZLf99jJlBuoT85uCT
        N8sOmdIKeYhd2wzO4kB996R8bq1zcJvAcsNDZFV29F/aWmOM9ftQnINKs6nlk/ceO/yWV3GAC9jaZ
        VyI5dknORMlL8tKpvfqll4aNTOXWBVMZ2eYsyVypAIxfhvBG/YrRU/ZfLE8Wv4isnlzBx0BTxfGUj
        t+Z0tYjS/GEWDLBW+6JC5Xvn34Kc116YIJixGGN3IwfUEVRakTmLJshXMZNTYqK4uBg6EeFxSxxEY
        xTMq+liaCTFTLfnN9cRZ8b95pm9QBaeQ/LfiKuhef2N7pAPgfpWqo0eo4GRv8hsp5/mWlcMTdaIfT
        N4KSavZg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbK-007FTC-4n; Mon, 04 Apr 2022 13:14:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 17/32] tests: py: add test-cases for ct and packet mark payload expressions
Date:   Mon,  4 Apr 2022 13:13:55 +0100
Message-Id: <20220404121410.188509-18-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220404121410.188509-1-jeremy@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add new test-cases to verify that defining a rule that sets the ct or
packet mark to a value derived from a payload works correctly.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/ip/ct.t            |  2 ++
 tests/py/ip/ct.t.json       | 58 ++++++++++++++++++++++++++++++++++++
 tests/py/ip/ct.t.payload    | 18 +++++++++++
 tests/py/ip/meta.t          |  3 ++
 tests/py/ip/meta.t.json     | 59 +++++++++++++++++++++++++++++++++++++
 tests/py/ip/meta.t.payload  | 18 +++++++++++
 tests/py/ip6/ct.t           |  6 ++++
 tests/py/ip6/ct.t.json      | 58 ++++++++++++++++++++++++++++++++++++
 tests/py/ip6/ct.t.payload   | 17 +++++++++++
 tests/py/ip6/meta.t         |  3 ++
 tests/py/ip6/meta.t.json    | 58 ++++++++++++++++++++++++++++++++++++
 tests/py/ip6/meta.t.payload | 18 +++++++++++
 12 files changed, 318 insertions(+)
 create mode 100644 tests/py/ip6/ct.t
 create mode 100644 tests/py/ip6/ct.t.json
 create mode 100644 tests/py/ip6/ct.t.payload

diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index a387863e0d8e..cfd9859c26b3 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -28,3 +28,5 @@ meta mark set ct original saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x00000
 meta mark set ct original ip saddr . meta mark map { 1.1.1.1 . 0x00000014 : 0x0000001e };ok
 ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
 ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
+ct mark set ip dscp lshift 2 or 0x10;ok;ct mark set ip dscp << 2 | 16
+ct mark set ip dscp lshift 26 or 0x10;ok;ct mark set ip dscp << 26 | 16
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index 3288413f8f3f..d0df36f1d060 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -325,3 +325,61 @@
         }
     }
 ]
+
+# ct mark set ip dscp lshift 2 or 0x10
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
+# ct mark set ip dscp lshift 26 or 0x10
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
index 49f06a8401f5..b2aed170833e 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -84,3 +84,21 @@ ip
   [ ct load src_ip => reg 1 , dir original ]
   [ meta load mark => reg 9 ]
   [ lookup reg 1 set __set%d ]
+
+# ct mark set ip dscp lshift 2 or 0x10
+ip test-ip4 output
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip dscp lshift 26 or 0x10
+ip
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
diff --git a/tests/py/ip/meta.t b/tests/py/ip/meta.t
index 5a05923a1ce1..3b6d82a0bc28 100644
--- a/tests/py/ip/meta.t
+++ b/tests/py/ip/meta.t
@@ -15,3 +15,6 @@ meta obrname "br0";fail
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
+
+meta mark set ip dscp lshift 2 or 0x10;ok;meta mark set ip dscp << 2 | 16
+meta mark set ip dscp lshift 26 or 0x10;ok;meta mark set ip dscp << 26 | 16
diff --git a/tests/py/ip/meta.t.json b/tests/py/ip/meta.t.json
index 3df31ce381fc..b82388dd31a8 100644
--- a/tests/py/ip/meta.t.json
+++ b/tests/py/ip/meta.t.json
@@ -156,3 +156,62 @@
         }
     }
 ]
+
+# meta mark set ip dscp lshift 2 or 0x10
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
+# meta mark set ip dscp lshift 26 or 0x10
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
index afde5cc13ac5..49d8330272f6 100644
--- a/tests/py/ip/meta.t.payload
+++ b/tests/py/ip/meta.t.payload
@@ -51,3 +51,21 @@ ip test-ip4 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta mark set ip dscp lshift 2 or 0x10
+ip test-ip4 input
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000ef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip dscp lshift 26 or 0x10
+ip
+  [ payload load 1b @ network header + 1 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
diff --git a/tests/py/ip6/ct.t b/tests/py/ip6/ct.t
new file mode 100644
index 000000000000..0a141ffaf961
--- /dev/null
+++ b/tests/py/ip6/ct.t
@@ -0,0 +1,6 @@
+:output;type filter hook output priority 0
+
+*ip6;test-ip6;output
+
+ct mark set ip6 dscp lshift 2 or 0x10;ok;ct mark set ip6 dscp << 2 | 16
+ct mark set ip6 dscp lshift 26 or 0x10;ok;ct mark set ip6 dscp << 26 | 16
diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
new file mode 100644
index 000000000000..7739e131343e
--- /dev/null
+++ b/tests/py/ip6/ct.t.json
@@ -0,0 +1,58 @@
+# ct mark set ip6 dscp lshift 2 or 0x10
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
+# ct mark set ip6 dscp lshift 26 or 0x10
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
+
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
new file mode 100644
index 000000000000..580c8d8d5712
--- /dev/null
+++ b/tests/py/ip6/ct.t.payload
@@ -0,0 +1,17 @@
+# ct mark set ip6 dscp lshift 2 or 0x10
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ip6 dscp lshift 26 or 0x10
+ip6 test-ip6 output
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ ct set mark with reg 1 ]
diff --git a/tests/py/ip6/meta.t b/tests/py/ip6/meta.t
index 471e14811975..90d588580a43 100644
--- a/tests/py/ip6/meta.t
+++ b/tests/py/ip6/meta.t
@@ -14,3 +14,6 @@ meta protocol ip6 udp dport 67;ok;udp dport 67
 
 meta sdif "lo" accept;ok
 meta sdifname != "vrf1" accept;ok
+
+meta mark set ip6 dscp lshift 2 or 0x10;ok;meta mark set ip6 dscp << 2 | 16
+meta mark set ip6 dscp lshift 26 or 0x10;ok;meta mark set ip6 dscp << 26 | 16
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
index 0e3db6ba07f9..49d7b42b0179 100644
--- a/tests/py/ip6/meta.t.payload
+++ b/tests/py/ip6/meta.t.payload
@@ -60,3 +60,21 @@ ip6 test-ip6 input
   [ cmp eq reg 1 0x00000011 ]
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00004300 ]
+
+# meta mark set ip6 dscp lshift 2 or 0x10
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
+
+# meta mark set ip6 dscp lshift 26 or 0x10
+ip6 test-ip6 input
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
+  [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
+  [ meta set mark with reg 1 ]
-- 
2.35.1

