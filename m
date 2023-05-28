Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E291C7EE23
	for <netfilter-devel@archiver.kernel.org>; Sun, 28 May 2023 14:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbjE1OBl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 28 May 2023 10:01:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjE1OBh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 28 May 2023 10:01:37 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D91D2
        for <netfilter-devel@vger.kernel.org>; Sun, 28 May 2023 07:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oGUzbso3ffeyjvDwqnniDOJJueWvCPEUxRk6dECgDmE=; b=KuVGVdKEt0J/I7BVAAqe0xtlLb
        zKapiOZypsitUcLef1P8AemWonNR2pSEe3Jpu+5V6wAzj1p56zXVNz7Y0TYe5QaWSArcgXT8KdG7Y
        Hcqn/PjT/1ey9UzncMVJwX855yrmPf8GNXtyyvJOOAWzkNZ6n/DA3uoe2xNCYFhQrJfmwB2rbo+8C
        oEzMFMgV7o2ABgr1ADB3IqJ7QkpAAqHGwztUMpvo672Lz9feRmA752CECZSHv2ygCUtYCe9GR0HDz
        z32rXnVazns559VR1uv8THOzsrmHsmM2XC/17etnlMYO4F79XyEpbfoP6zXtnWjfuhuJ87AaefBMx
        YRPPn0sQ==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=ulthar.dreamlands)
        by taras.nevrast.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1q3Gxe-008Xe1-IX; Sun, 28 May 2023 15:01:30 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH nft v5 8/8] tests: add tests for binops with variable RHS operands
Date:   Sun, 28 May 2023 15:00:58 +0100
Message-Id: <20230528140058.1218669-9-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230528140058.1218669-1-jeremy@azazel.net>
References: <20230528140058.1218669-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add tests to validate setting marks and payloads with statement
arguments that include binops with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t                             |  1 +
 tests/py/any/ct.t.json                        | 37 +++++++++
 tests/py/any/ct.t.payload                     |  9 +++
 tests/py/inet/meta.t                          |  2 +
 tests/py/inet/meta.t.json                     | 37 +++++++++
 tests/py/inet/meta.t.payload                  |  9 +++
 tests/py/ip/ct.t                              |  1 +
 tests/py/ip/ct.t.json                         | 36 +++++++++
 tests/py/ip/ct.t.payload                      | 11 +++
 tests/py/ip/ip.t                              |  2 +
 tests/py/ip/ip.t.json                         | 77 ++++++++++++++++++-
 tests/py/ip/ip.t.payload                      | 28 +++++++
 tests/py/ip/ip.t.payload.bridge               | 32 ++++++++
 tests/py/ip/ip.t.payload.inet                 | 32 ++++++++
 tests/py/ip/ip.t.payload.netdev               | 32 ++++++++
 tests/py/ip6/ct.t                             |  1 +
 tests/py/ip6/ct.t.json                        | 36 +++++++++
 tests/py/ip6/ct.t.payload                     | 12 +++
 tests/py/ip6/ip6.t                            |  2 +
 tests/py/ip6/ip6.t.json                       | 76 ++++++++++++++++++
 tests/py/ip6/ip6.t.payload.inet               | 36 +++++++++
 tests/py/ip6/ip6.t.payload.ip6                | 32 ++++++++
 .../shell/testcases/bitwise/0040mark_binop_10 | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_11 | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_12 | 11 +++
 .../shell/testcases/bitwise/0040mark_binop_13 | 11 +++
 .../testcases/bitwise/0044payload_binop_0     | 11 +++
 .../testcases/bitwise/0044payload_binop_1     | 11 +++
 .../testcases/bitwise/0044payload_binop_2     | 11 +++
 .../testcases/bitwise/0044payload_binop_3     | 11 +++
 .../testcases/bitwise/0044payload_binop_4     | 11 +++
 .../testcases/bitwise/0044payload_binop_5     | 11 +++
 .../bitwise/dumps/0040mark_binop_10.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_11.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_12.nft       |  6 ++
 .../bitwise/dumps/0040mark_binop_13.nft       |  6 ++
 .../bitwise/dumps/0044payload_binop_0.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_1.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_2.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_3.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_4.nft     |  6 ++
 .../bitwise/dumps/0044payload_binop_5.nft     |  6 ++
 42 files changed, 710 insertions(+), 1 deletion(-)
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_10
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_11
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_12
 create mode 100755 tests/shell/testcases/bitwise/0040mark_binop_13
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_0
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_1
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_2
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_3
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_4
 create mode 100755 tests/shell/testcases/bitwise/0044payload_binop_5
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_0.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_1.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_3.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_4.nft
 create mode 100644 tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index f73fa4e7aedb..3e0e473f55b7 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -61,6 +61,7 @@ ct mark set 0x11;ok;ct mark set 0x00000011
 ct mark set mark;ok;ct mark set meta mark
 ct mark set (meta mark | 0x10) << 8;ok;ct mark set (meta mark | 0x00000010) << 8
 ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set meta mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
+ct mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
 
 ct mark set {0x11333, 0x11};fail
 ct zone set {123, 127};fail
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index a2a06025992c..4d6043190201 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -817,6 +817,43 @@
     }
 ]
 
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
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
+                        "&": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            4294901760
+                        ]
+                    },
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            65535
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # ct expiration 30s
 [
     {
diff --git a/tests/py/any/ct.t.payload b/tests/py/any/ct.t.payload
index ed868e53277d..1523e54d1307 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -336,6 +336,15 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+ip
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ ct set mark with reg 1 ]
+
 # ct original bytes > 100000
 ip test-ip4 output
   [ ct load bytes => reg 1 , dir original ]
diff --git a/tests/py/inet/meta.t b/tests/py/inet/meta.t
index 374738a701d6..1e582161caa1 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -25,3 +25,5 @@ meta mark set ct mark >> 8;ok
 meta mark . tcp dport { 0x0000000a-0x00000014 . 80-90, 0x00100000-0x00100123 . 100-120 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 1.2.3.6-1.2.3.8 . 0x00000200-0x00000300 };ok
 ip saddr . meta mark { 1.2.3.4 . 0x00000100 , 5.6.7.8 . 0x00000200 };ok
+
+meta mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 92a1f9bff373..3b50efd646ad 100644
--- a/tests/py/inet/meta.t.json
+++ b/tests/py/inet/meta.t.json
@@ -236,6 +236,43 @@
     }
 ]
 
+# meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
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
+                        "&": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            4294901760
+                        ]
+                    },
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            65535
+                        ]
+                    }
+                ]
+            }
+        }
+    }
+]
+
 # meta protocol ip udp dport 67
 [
     {
diff --git a/tests/py/inet/meta.t.payload b/tests/py/inet/meta.t.payload
index ea54090727fa..8dc1a7e7d151 100644
--- a/tests/py/inet/meta.t.payload
+++ b/tests/py/inet/meta.t.payload
@@ -80,6 +80,15 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 >> 0x00000008 ) ]
   [ meta set mark with reg 1 ]
 
+# meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+inet test-inet input
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ meta set mark with reg 1 ]
+
 # meta protocol ip udp dport 67
 inet test-inet input
   [ meta load protocol => reg 1 ]
diff --git a/tests/py/ip/ct.t b/tests/py/ip/ct.t
index a0a222893dd0..8f62c00d134f 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -34,3 +34,4 @@ ct mark set ip dscp & 0x0f << 1;ok;ct mark set ip dscp & af33
 ct mark set ip dscp & 0x0f << 2;ok;ct mark set ip dscp & 0x3c
 ct mark set ip dscp | 0x04;ok
 ct mark set ip dscp | 1 << 20;ok;ct mark set ip dscp | 0x100000
+ct mark set ct mark | ip dscp | 0x200 counter;ok;ct mark set ct mark | ip dscp | 0x00000200 counter
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index 915632aef076..0287d2dc44b0 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -479,3 +479,39 @@
         }
     }
 ]
+
+# ct mark set ct mark | ip dscp | 0x200 counter
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
+                        "|": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip"
+                                }
+                            }
+                        ]
+                    },
+                    512
+                ]
+            }
+        }
+    },
+    {
+        "counter": null
+    }
+]
diff --git a/tests/py/ip/ct.t.payload b/tests/py/ip/ct.t.payload
index 692011d0f860..823de5974228 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -134,3 +134,14 @@ ip test-ip4 output
   [ bitwise reg 1 = ( reg 1 >> 0x00000002 ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffefffff ) ^ 0x00100000 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark | ip dscp | 0x200 counter
+ip test-ip4 output
+  [ ct load mark => reg 1 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
+  [ ct set mark with reg 1 ]
+  [ counter pkts 0 bytes 0 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index d5a4d8a5e46e..6ef1be3a8ddb 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -124,6 +124,8 @@ iif "lo" ip protocol set 1;ok
 
 iif "lo" ip dscp set af23;ok
 iif "lo" ip dscp set cs0;ok
+iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26;ok
+iif "lo" ip dscp set ip dscp & 0xc;ok;iif "lo" ip dscp set ip dscp & af12
 
 ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 };ok
 ip saddr . ip daddr vmap { 192.168.5.1-192.168.5.128 . 192.168.6.1-192.168.6.128 : accept };ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index b1085035a000..1adbf9323b7a 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1596,6 +1596,82 @@
     }
 ]
 
+# iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            },
+            "value": {
+                ">>": [
+                    {
+                        "&": [
+                            {
+                                "meta": {
+                                    "key": "mark"
+                                }
+                            },
+                            4227858432
+                        ]
+                    },
+                    26
+                ]
+            }
+        }
+    }
+]
+
+# iif "lo" ip dscp set ip dscp & 0xc
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
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
+                    "af12"
+                ]
+            }
+        }
+    }
+]
+
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 [
     {
@@ -1684,4 +1760,3 @@
         }
     }
 ]
-
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index b9fcb5158e9d..7e955d07ebc9 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -490,6 +490,34 @@ ip test-ip4 input
   [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp & 0xc
+ip test-ip4 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
 # iif "lo" ip ttl set 23
 ip test-ip4 input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index c6f8d4e5575b..fd3603a68e9b 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -662,6 +662,38 @@ bridge test-bridge input
   [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26
+bridge test-bridge input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp & 0xc
+bridge test-bridge input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
 # ip saddr . ip daddr { 192.0.2.1 . 10.0.0.1-10.0.0.2 }
 __set%d test-bridge 87 size 1
 __set%d test-bridge 0
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index e26d0dac47be..7f92423ab051 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -642,6 +642,38 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp & 0xc
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
 # iif "lo" ip ttl set 23
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index de990f5bba12..74fc696f31fe 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -642,6 +642,38 @@ netdev test-netdev ingress
   [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip dscp set (meta mark & 0xfc000000) >> 26
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp & 0xc
+netdev test-netdev ingress
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
 # iif "lo" ip ttl set 23
 netdev test-netdev ingress
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/ct.t b/tests/py/ip6/ct.t
index c06fd6a0441d..1617c68b6da2 100644
--- a/tests/py/ip6/ct.t
+++ b/tests/py/ip6/ct.t
@@ -7,3 +7,4 @@ ct mark set ip6 dscp << 26 | 0x10;ok
 ct mark set ip6 dscp | 0x04;ok
 ct mark set ip6 dscp | 0xff000000;ok
 ct mark set ip6 dscp & 0x0f << 2;ok;ct mark set ip6 dscp & 0x3c
+ct mark set ct mark | ip6 dscp | 0x200 counter;ok;ct mark set ct mark | ip6 dscp | 0x00000200 counter
diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
index 7d8c88bb09cb..9fbcdc9f36e1 100644
--- a/tests/py/ip6/ct.t.json
+++ b/tests/py/ip6/ct.t.json
@@ -291,3 +291,39 @@
         }
     }
 ]
+
+# ct mark set ct mark | ip6 dscp | 0x200 counter
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
+                        "|": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            {
+                                "payload": {
+                                    "field": "dscp",
+                                    "protocol": "ip6"
+                                }
+                            }
+                        ]
+                    },
+                    512
+                ]
+            }
+        }
+    },
+    {
+        "counter": null
+    }
+]
diff --git a/tests/py/ip6/ct.t.payload b/tests/py/ip6/ct.t.payload
index 164149e93d17..fc54e5df0235 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -44,3 +44,15 @@ ip6 test-ip6 output
   [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
   [ bitwise reg 1 = ( reg 1 & 0x0000003c ) ^ 0x00000000 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark | ip6 dscp | 0x200 counter
+ip6 test-ip6 output
+  [ ct load mark => reg 1 ]
+  [ payload load 2b @ network header + 0 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 | reg 2 ) ]
+  [ bitwise reg 1 = ( reg 1 & 0xfffffdff ) ^ 0x00000200 ]
+  [ ct set mark with reg 1 ]
+  [ counter pkts 0 bytes 0 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 2ffe318e1e6d..bfa384ad1834 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -141,6 +141,8 @@ iif "lo" ip6 daddr set ::1;ok
 iif "lo" ip6 hoplimit set 1;ok
 iif "lo" ip6 dscp set af42;ok
 iif "lo" ip6 dscp set 63;ok;iif "lo" ip6 dscp set 0x3f
+iif "lo" ip6 dscp set (ct mark & 0xfc000000) >> 26;ok
+iif "lo" ip6 dscp set ip6 dscp & 0xc;ok;iif "lo" ip6 dscp set ip6 dscp & 0x0c
 iif "lo" ip6 ecn set ect0;ok
 iif "lo" ip6 ecn set ce;ok
 
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index cf802175b792..70faf735a37d 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -1437,6 +1437,82 @@
     }
 ]
 
+# iif "lo" ip6 dscp set (ct mark & 0xfc000000) >> 26
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip6"
+                }
+            },
+            "value": {
+                ">>": [
+                    {
+                        "&": [
+                            {
+                                "ct": {
+                                    "key": "mark"
+                                }
+                            },
+                            4227858432
+                        ]
+                    },
+                    26
+                ]
+            }
+        }
+    }
+]
+
+# iif "lo" ip6 dscp set ip6 dscp & 0xc
+[
+    {
+        "match": {
+            "left": {
+                "meta": {
+                    "key": "iif"
+                }
+            },
+            "op": "==",
+            "right": "lo"
+        }
+    },
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip6"
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
+                    12
+                ]
+            }
+        }
+    }
+]
+
 # iif "lo" ip6 ecn set ect0
 [
     {
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index 20dfe5497367..41fc81ace7fa 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -589,6 +589,42 @@ inet test-inet input
   [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
+# iif "lo" ip6 dscp set (ct mark & 0xfc000000) >> 26
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000000 ]
+  [ ct load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
+# iif "lo" ip6 dscp set ip6 dscp & 0xc
+inet test-inet input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x0000000a ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000000 ]
+  [ payload load 2b @ network header + 0 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 & 0x00000c00 ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
 # iif "lo" ip6 ecn set ect0
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index f8e3ca3cb622..b7d2ab5aa4bb 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -439,6 +439,38 @@ ip6 test-ip6 input
   [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x0000c00f ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
 
+# iif "lo" ip6 dscp set (ct mark & 0xfc000000) >> 26
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000000 ]
+  [ ct load mark => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0xfc000000 ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x0000001a ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 4, 4) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
+# iif "lo" ip6 dscp set ip6 dscp & 0xc
+ip6 test-ip6 input
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = ( reg 1 & 0x00003ff0 ) ^ 0x00000000 ]
+  [ payload load 2b @ network header + 0 => reg 2 ]
+  [ bitwise reg 2 = ( reg 2 & 0x0000c00f ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 & 0x00000c00 ) ^ 0x00000000 ]
+  [ byteorder reg 2 = ntoh(reg 2, 2, 1) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
 # iif "lo" ip6 ecn set ect0
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_10 b/tests/shell/testcases/bitwise/0040mark_binop_10
new file mode 100755
index 000000000000..8e9bc6ad4329
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_10
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_11 b/tests/shell/testcases/bitwise/0040mark_binop_11
new file mode 100755
index 000000000000..7825b0827851
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_11
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook input priority filter; }
+  add rule t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_12 b/tests/shell/testcases/bitwise/0040mark_binop_12
new file mode 100755
index 000000000000..aa27cdc5303c
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_12
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0040mark_binop_13 b/tests/shell/testcases/bitwise/0040mark_binop_13
new file mode 100755
index 000000000000..53a7e2ec6c6f
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0040mark_binop_13
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook input priority filter; }
+  add rule ip6 t c meta mark set ct mark and 0xffff0000 or meta mark and 0xffff
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_0 b/tests/shell/testcases/bitwise/0044payload_binop_0
new file mode 100755
index 000000000000..81b8cbaa961f
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_0
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ip dscp set (ct mark & 0xfc000000) >> 26
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_1 b/tests/shell/testcases/bitwise/0044payload_binop_1
new file mode 100755
index 000000000000..1d69b6f78654
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_1
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ip dscp set ip dscp and 0xc
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_2 b/tests/shell/testcases/bitwise/0044payload_binop_2
new file mode 100755
index 000000000000..2d09d24479d0
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_2
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table t
+  add chain t c { type filter hook output priority filter; }
+  add rule t c ct mark set ct mark | ip dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_3 b/tests/shell/testcases/bitwise/0044payload_binop_3
new file mode 100755
index 000000000000..7752af238409
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_3
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ip6 dscp set (ct mark & 0xfc000000) >> 26
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_4 b/tests/shell/testcases/bitwise/0044payload_binop_4
new file mode 100755
index 000000000000..2c7792e9f929
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_4
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ip6 dscp set ip6 dscp and 0xc
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/0044payload_binop_5 b/tests/shell/testcases/bitwise/0044payload_binop_5
new file mode 100755
index 000000000000..aa82cd1c299e
--- /dev/null
+++ b/tests/shell/testcases/bitwise/0044payload_binop_5
@@ -0,0 +1,11 @@
+#!/bin/bash
+
+set -e
+
+RULESET="
+  add table ip6 t
+  add chain ip6 t c { type filter hook output priority filter; }
+  add rule ip6 t c ct mark set ct mark | ip6 dscp | 0x200 counter
+"
+
+$NFT -f - <<< "$RULESET"
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
new file mode 100644
index 000000000000..5566f7298461
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_10.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
new file mode 100644
index 000000000000..719980d55341
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_11.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
new file mode 100644
index 000000000000..bd589fe549f7
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_12.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
new file mode 100644
index 000000000000..2b046b128fb2
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_13.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook input priority filter; policy accept;
+		meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_0.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_0.nft
new file mode 100644
index 000000000000..5aaf1353bdc8
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_0.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip dscp set (ct mark & 0xfc000000) >> 26
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_1.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_1.nft
new file mode 100644
index 000000000000..54f744b54a3a
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_1.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip dscp set ip dscp & af12
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
new file mode 100644
index 000000000000..ed347bb2788a
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_2.nft
@@ -0,0 +1,6 @@
+table ip t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_3.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_3.nft
new file mode 100644
index 000000000000..64da4a77cb5c
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_3.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip6 dscp set (ct mark & 0xfc000000) >> 26
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_4.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_4.nft
new file mode 100644
index 000000000000..f5bd9789ce2f
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_4.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ip6 dscp set ip6 dscp & 0x0c
+	}
+}
diff --git a/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft b/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft
new file mode 100644
index 000000000000..ccdb93d74a9a
--- /dev/null
+++ b/tests/shell/testcases/bitwise/dumps/0044payload_binop_5.nft
@@ -0,0 +1,6 @@
+table ip6 t {
+	chain c {
+		type filter hook output priority filter; policy accept;
+		ct mark set ct mark | ip6 dscp | 0x00000200 counter packets 0 bytes 0
+	}
+}
-- 
2.39.2

