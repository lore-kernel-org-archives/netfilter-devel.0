Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FCD2C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Apr 2022 12:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344628AbiDDMaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344642AbiDDMat (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 08:30:49 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FF5D82
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Apr 2022 05:28:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3N114/BhhUZXkgyVIl8LcnmmmBNMl9M5KyDMbXB3E2A=; b=pnEEddSmlo6SSWFlhHjOJba1ei
        1BbHF8ArVAxPBlCmD9+6EK7FjUUFdtF8+TRcyKyZb/Q65grShXs5XIZdlI6L3n7VQErwE8rcVzy44
        XFLtNCVZlN3FWHP/lZAqyJK8UAK6KAZMIKDXovCH+U2PffxC5aBtjjiffeOd7eKVQxtRnit6pkC57
        SY/HthtQ8ipV8BwJZP4OAF08l31u2U+SdMzaogsxsYVkRg0nXcbsd8XhFhpaq+nuJiFnbkb/ThPlC
        V01kIT/U6ouEB826e5H7wxsnhJTFVc36J80dFgcx8e5YjhZsVcqJlq57lj/dVDUyddyVN54Zz3rpB
        pmt4WWOQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nbLbL-007FTC-Ia; Mon, 04 Apr 2022 13:14:31 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [nft PATCH v4 32/32] tests: py: add tests for binops with variable RHS operands
Date:   Mon,  4 Apr 2022 13:14:10 +0100
Message-Id: <20220404121410.188509-33-jeremy@azazel.net>
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

Add some tests to validate setting marks with statement arguments that include
binops with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t               |  1 +
 tests/py/any/ct.t.json          | 37 ++++++++++++++++
 tests/py/any/ct.t.payload       |  9 ++++
 tests/py/inet/meta.t            |  1 +
 tests/py/inet/meta.t.json       | 37 ++++++++++++++++
 tests/py/inet/meta.t.payload    |  9 ++++
 tests/py/ip/ct.t                |  1 +
 tests/py/ip/ct.t.json           | 36 +++++++++++++++
 tests/py/ip/ct.t.payload        | 11 +++++
 tests/py/ip/ip.t                |  2 +
 tests/py/ip/ip.t.json           | 77 ++++++++++++++++++++++++++++++++-
 tests/py/ip/ip.t.payload        | 28 ++++++++++++
 tests/py/ip/ip.t.payload.bridge | 32 ++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 32 ++++++++++++++
 tests/py/ip/ip.t.payload.netdev | 32 ++++++++++++++
 tests/py/ip6/ct.t               |  1 +
 tests/py/ip6/ct.t.json          | 35 +++++++++++++++
 tests/py/ip6/ct.t.payload       | 12 +++++
 tests/py/ip6/ip6.t              |  2 +
 tests/py/ip6/ip6.t.json         | 76 ++++++++++++++++++++++++++++++++
 tests/py/ip6/ip6.t.payload.inet | 34 +++++++++++++++
 tests/py/ip6/ip6.t.payload.ip6  | 30 +++++++++++++
 22 files changed, 534 insertions(+), 1 deletion(-)

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
index 423cc5f32cba..a389a3ee5123 100644
--- a/tests/py/inet/meta.t
+++ b/tests/py/inet/meta.t
@@ -21,3 +21,4 @@ meta secpath missing;ok;meta ipsec missing
 meta ibrname "br0";fail
 meta obrname "br0";fail
 meta mark set ct mark >> 8;ok
+meta mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;meta mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
diff --git a/tests/py/inet/meta.t.json b/tests/py/inet/meta.t.json
index 723a36f74946..9e0484388adf 100644
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
index fd0545490b78..737878294d1e 100644
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
index cfd9859c26b3..b13c58d2df72 100644
--- a/tests/py/ip/ct.t
+++ b/tests/py/ip/ct.t
@@ -30,3 +30,4 @@ ct original saddr . meta mark { 1.1.1.1 . 0x00000014 };fail
 ct original ip saddr . meta mark { 1.1.1.1 . 0x00000014 };ok
 ct mark set ip dscp lshift 2 or 0x10;ok;ct mark set ip dscp << 2 | 16
 ct mark set ip dscp lshift 26 or 0x10;ok;ct mark set ip dscp << 26 | 16
+ct mark set ct mark or ip dscp or 0x200 counter;ok;ct mark set ct mark | ip dscp | 0x00000200 counter
diff --git a/tests/py/ip/ct.t.json b/tests/py/ip/ct.t.json
index d0df36f1d060..6abaa4c19e04 100644
--- a/tests/py/ip/ct.t.json
+++ b/tests/py/ip/ct.t.json
@@ -383,3 +383,39 @@
         }
     }
 ]
+
+# ct mark set ct mark or ip dscp or 0x200 counter
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
index b2aed170833e..c2340b2e5fc6 100644
--- a/tests/py/ip/ct.t.payload
+++ b/tests/py/ip/ct.t.payload
@@ -102,3 +102,14 @@ ip
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark or ip dscp or 0x200 counter
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
index 0a141ffaf961..782353666d0f 100644
--- a/tests/py/ip6/ct.t
+++ b/tests/py/ip6/ct.t
@@ -4,3 +4,4 @@
 
 ct mark set ip6 dscp lshift 2 or 0x10;ok;ct mark set ip6 dscp << 2 | 16
 ct mark set ip6 dscp lshift 26 or 0x10;ok;ct mark set ip6 dscp << 26 | 16
+ct mark set ct mark or ip6 dscp or 0x200 counter;ok;ct mark set ct mark | ip6 dscp | 0x00000200 counter
diff --git a/tests/py/ip6/ct.t.json b/tests/py/ip6/ct.t.json
index 7739e131343e..d1753b5d2a17 100644
--- a/tests/py/ip6/ct.t.json
+++ b/tests/py/ip6/ct.t.json
@@ -56,3 +56,38 @@
     }
 ]
 
+# ct mark set ct mark or ip6 dscp or 0x200 counter
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
index a0565d14e15e..861e330f2df2 100644
--- a/tests/py/ip6/ct.t.payload
+++ b/tests/py/ip6/ct.t.payload
@@ -17,3 +17,15 @@ ip6 test-ip6 output
   [ bitwise reg 1 = ( reg 1 << 0x0000001a ) ]
   [ bitwise reg 1 = ( reg 1 & 0xffffffef ) ^ 0x00000010 ]
   [ ct set mark with reg 1 ]
+
+# ct mark set ct mark or ip6 dscp or 0x200 counter
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
index 2ffe318e1e6d..6222ffb7d885 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -141,6 +141,8 @@ iif "lo" ip6 daddr set ::1;ok
 iif "lo" ip6 hoplimit set 1;ok
 iif "lo" ip6 dscp set af42;ok
 iif "lo" ip6 dscp set 63;ok;iif "lo" ip6 dscp set 0x3f
+iif "lo" ip6 dscp set (ct mark & 0xfc000000) >> 26;ok
+iif "lo" ip6 dscp set ip6 dscp & 0xc;ok;iif "lo" ip6 dscp set ip6 dscp & af12
 iif "lo" ip6 ecn set ect0;ok
 iif "lo" ip6 ecn set ce;ok
 
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index cf802175b792..b9658274968a 100644
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
+                    "af12"
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
index 20dfe5497367..83a95861bc06 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -589,6 +589,40 @@ inet test-inet input
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
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
 # iif "lo" ip6 ecn set ect0
 inet test-inet input
   [ meta load iif => reg 1 ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index f8e3ca3cb622..240dfd2d8d35 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -439,6 +439,36 @@ ip6 test-ip6 input
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
+  [ bitwise reg 2 = ( reg 2 & 0x0000000c ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000006 ) ]
+  [ byteorder reg 2 = hton(reg 2, 2, 1) ]
+  [ bitwise reg 1 = ( reg 1 ^ reg 2 ) ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 0 csum_off 0 csum_flags 0x0 ]
+
 # iif "lo" ip6 ecn set ect0
 ip6 test-ip6 input
   [ meta load iif => reg 1 ]
-- 
2.35.1

