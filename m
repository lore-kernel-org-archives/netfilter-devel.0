Return-Path: <SRS0=D+Hy=4U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD219C3F2C6
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6E965214DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Mar 2020 10:14:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="V44fo5iM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728515AbgCCKOc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Mar 2020 05:14:32 -0500
Received: from kadath.azazel.net ([81.187.231.250]:41954 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728502AbgCCKOb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Mar 2020 05:14:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nUFUYWhSbq0A1irrHms+T1OEju7dUsFiHwuReUmWZkY=; b=V44fo5iMMYa0YY7Nm8OOtDMe2U
        C6Id6zCuBYvmdS2hR00jJZILOMUnmYId8IprxNJMXmInziRRkZ/TO9mkWQCV3pifrzLa06rq1Wx2r
        DSgmMjHEOejpEu3GoojoWF/n8TsmcFjkM9Dp3lZZFMM3vxiOSKpSOWciKh2CLXTxCPJZaHqxNyeCL
        Gfd9LgP0bbvbYO0yrDNrGSOYORevGzXRjOdbxM7OWJirHicKjTQGZYuagow+RXJT1fJQUWIUSMwxC
        UN1AfJRqXOpY4+cCzMk0k9/C0O1o7zRQhB7nx8dalx3xdrakFx/CJ/nUWvpdkrbH0WGF1gTXJ/key
        r9gaOL5A==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtp (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j94AR-00081M-N0; Tue, 03 Mar 2020 09:48:47 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nft v3 18/18] tests: py: add variable binop RHS tests.
Date:   Tue,  3 Mar 2020 09:48:44 +0000
Message-Id: <20200303094844.26694-19-jeremy@azazel.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303094844.26694-1-jeremy@azazel.net>
References: <20200303094844.26694-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add some tests to validate setting payload fields and marks with
statement arguments that include binops with variable RHS operands.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 tests/py/any/ct.t               |  1 +
 tests/py/any/ct.t.json          | 37 ++++++++++++++++++
 tests/py/any/ct.t.payload       | 33 ++++++++++++++++
 tests/py/inet/tcp.t             |  2 +
 tests/py/inet/tcp.t.json        | 46 +++++++++++++++++++++-
 tests/py/inet/tcp.t.payload     | 68 +++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t                |  3 ++
 tests/py/ip/ip.t.json           | 66 ++++++++++++++++++++++++++++++++
 tests/py/ip/ip.t.payload        | 26 +++++++++++++
 tests/py/ip/ip.t.payload.bridge | 30 +++++++++++++++
 tests/py/ip/ip.t.payload.inet   | 30 +++++++++++++++
 tests/py/ip/ip.t.payload.netdev | 30 +++++++++++++++
 12 files changed, 371 insertions(+), 1 deletion(-)

diff --git a/tests/py/any/ct.t b/tests/py/any/ct.t
index f65d275987cd..0581c6a4fd8f 100644
--- a/tests/py/any/ct.t
+++ b/tests/py/any/ct.t
@@ -59,6 +59,7 @@ ct mark set 0x11;ok;ct mark set 0x00000011
 ct mark set mark;ok;ct mark set meta mark
 ct mark set (meta mark | 0x10) << 8;ok;ct mark set (meta mark | 0x00000010) << 8
 ct mark set mark map { 1 : 10, 2 : 20, 3 : 30 };ok;ct mark set meta mark map { 0x00000003 : 0x0000001e, 0x00000002 : 0x00000014, 0x00000001 : 0x0000000a}
+ct mark set ct mark and 0xffff0000 or meta mark and 0xffff;ok;ct mark set ct mark & 0xffff0000 | meta mark & 0x0000ffff
 
 ct mark set {0x11333, 0x11};fail
 ct zone set {123, 127};fail
diff --git a/tests/py/any/ct.t.json b/tests/py/any/ct.t.json
index 59ac27c3055c..aca7c3243cc0 100644
--- a/tests/py/any/ct.t.json
+++ b/tests/py/any/ct.t.json
@@ -779,6 +779,43 @@
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
index 661591257804..17a1c382ea65 100644
--- a/tests/py/any/ct.t.payload
+++ b/tests/py/any/ct.t.payload
@@ -359,6 +359,39 @@ ip test-ip4 output
   [ lookup reg 1 set __map%d dreg 1 ]
   [ ct set mark with reg 1 ]
 
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+ip
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x0000ffff ) ^ 0xffffffff ]
+  [ meta load mark => reg 3 ]
+  [ bitwise reg 3 = (reg=3 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = (reg=1 & reg 2 ) ^ reg 3 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+ip6
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x0000ffff ) ^ 0xffffffff ]
+  [ meta load mark => reg 3 ]
+  [ bitwise reg 3 = (reg=3 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = (reg=1 & reg 2 ) ^ reg 3 ]
+  [ ct set mark with reg 1 ]
+
+# ct mark set ct mark and 0xffff0000 or meta mark and 0xffff
+inet
+  [ ct load mark => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0xffff0000 ) ^ 0x00000000 ]
+  [ meta load mark => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x0000ffff ) ^ 0xffffffff ]
+  [ meta load mark => reg 3 ]
+  [ bitwise reg 3 = (reg=3 & 0x0000ffff ) ^ 0x00000000 ]
+  [ bitwise reg 1 = (reg=1 & reg 2 ) ^ reg 3 ]
+  [ ct set mark with reg 1 ]
+
 # ct original bytes > 100000
 ip test-ip4 output
   [ ct load bytes => reg 1 , dir original ]
diff --git a/tests/py/inet/tcp.t b/tests/py/inet/tcp.t
index e0a83e2b4152..081248643981 100644
--- a/tests/py/inet/tcp.t
+++ b/tests/py/inet/tcp.t
@@ -7,6 +7,8 @@
 *netdev;test-netdev;ingress
 
 tcp dport set {1, 2, 3};fail
+tcp dport set tcp dport;ok
+tcp dport set tcp dport lshift 1;ok;tcp dport set tcp dport << 1
 
 tcp dport 22;ok
 tcp dport != 233;ok
diff --git a/tests/py/inet/tcp.t.json b/tests/py/inet/tcp.t.json
index babe59208925..d8375fbe1e85 100644
--- a/tests/py/inet/tcp.t.json
+++ b/tests/py/inet/tcp.t.json
@@ -1,3 +1,48 @@
+# tcp dport set tcp dport
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "value": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            }
+        }
+    }
+]
+
+# tcp dport set tcp dport lshift 1
+[
+    {
+        "mangle": {
+            "key": {
+                "payload": {
+                    "field": "dport",
+                    "protocol": "tcp"
+                }
+            },
+            "value": {
+                "<<": [
+                    {
+                        "payload": {
+                            "field": "dport",
+                            "protocol": "tcp"
+                        }
+                    },
+                    1
+                ]
+            }
+        }
+    }
+]
+
 # tcp dport 22
 [
     {
@@ -1636,4 +1681,3 @@
         }
     }
 ]
-
diff --git a/tests/py/inet/tcp.t.payload b/tests/py/inet/tcp.t.payload
index 55f1bc2eff87..13de1ff80722 100644
--- a/tests/py/inet/tcp.t.payload
+++ b/tests/py/inet/tcp.t.payload
@@ -1,3 +1,71 @@
+# tcp dport set tcp dport
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport
+ip6
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport
+inet
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport
+netdev
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport lshift 1
+ip
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
+  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport lshift 1
+ip6
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
+  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport lshift 1
+inet
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
+  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
+# tcp dport set tcp dport lshift 1
+netdev
+  [ meta load l4proto => reg 1 ]
+  [ cmp eq reg 1 0x00000006 ]
+  [ payload load 2b @ transport header + 2 => reg 1 ]
+  [ byteorder reg 1 = ntoh(reg 1, 2, 2) ]
+  [ bitwise reg 1 = ( reg 1 << 0x00000001 ) ]
+  [ byteorder reg 1 = hton(reg 1, 2, 2) ]
+  [ payload write reg 1 => 2b @ transport header + 2 csum_type 1 csum_off 16 csum_flags 0x0 ]
+
 # tcp dport 22
 inet test-inet input
   [ meta load l4proto => reg 1 ]
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 0421d01bf6e4..1a5fb5c0efb3 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -135,3 +135,6 @@ iif "lo" ip protocol set 1;ok
 
 iif "lo" ip dscp set af23;ok
 iif "lo" ip dscp set cs0;ok
+
+iif "lo" ip dscp set ip dscp;ok
+iif "lo" ip dscp set ip dscp or 0x3;ok;iif "lo" ip dscp set ip dscp | 0x03
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 3131ab790c04..4e0cef9357c8 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -1836,3 +1836,69 @@
     }
 ]
 
+# iif "lo" ip dscp set ip dscp
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
+                "payload": {
+                    "field": "dscp",
+                    "protocol": "ip"
+                }
+            }
+        }
+    }
+]
+
+# iif "lo" ip dscp set ip dscp or 0x3
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
+                "|": [
+                    {
+                        "payload": {
+                            "field": "dscp",
+                            "protocol": "ip"
+                        }
+                    },
+                    3
+                ]
+            }
+        }
+    }
+]
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d627b22f2614..d6c5d14d52ac 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -614,3 +614,29 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# iif "lo" ip dscp set ip dscp
+ip
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp or 0x3
+ip
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index 91a4fde382e6..5a99142a9704 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -784,3 +784,33 @@ bridge test-bridge input
   [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
   [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
 
+# iif "lo" ip dscp set ip dscp
+bridge
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp or 0x3
+bridge
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index b9cb28a22e7a..5440ceeb33f9 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -796,3 +796,33 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# iif "lo" ip dscp set ip dscp
+inet
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp or 0x3
+inet
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load nfproto => reg 1 ]
+  [ cmp eq reg 1 0x00000002 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 588e5ca2a3e3..2e125158ee6e 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -896,3 +896,33 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000000ff ) ^ 0x00000100 ]
   [ payload write reg 1 => 2b @ network header + 8 csum_type 1 csum_off 10 csum_flags 0x1 ]
 
+# iif "lo" ip dscp set ip dscp
+netdev
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
+
+# iif "lo" ip dscp set ip dscp or 0x3
+netdev
+  [ meta load iif => reg 1 ]
+  [ cmp eq reg 1 0x00000001 ]
+  [ meta load protocol => reg 1 ]
+  [ cmp eq reg 1 0x00000008 ]
+  [ payload load 2b @ network header + 0 => reg 1 ]
+  [ bitwise reg 1 = (reg=1 & 0x000003ff ) ^ 0x00000000 ]
+  [ payload load 1b @ network header + 1 => reg 2 ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000000 ]
+  [ bitwise reg 2 = ( reg 2 >> 0x00000002 ) ]
+  [ bitwise reg 2 = (reg=2 & 0x000000fc ) ^ 0x00000003 ]
+  [ bitwise reg 2 = ( reg 2 << 0x00000002 ) ]
+  [ bitwise reg 1 = (reg=1 & 0x0000ffff ) ^ reg 2 ]
+  [ payload write reg 1 => 2b @ network header + 0 csum_type 1 csum_off 10 csum_flags 0x0 ]
-- 
2.25.1

