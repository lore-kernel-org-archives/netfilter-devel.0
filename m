Return-Path: <SRS0=mmGa=IG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79723C43381
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BB846512B
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Mar 2021 14:15:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbhCHOOe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Mar 2021 09:14:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbhCHOO3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Mar 2021 09:14:29 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1D58C06174A
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Mar 2021 06:14:29 -0800 (PST)
Received: from localhost ([::1]:53510 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lJGeS-0003UN-65; Mon, 08 Mar 2021 15:14:28 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] tests/py: Adjust payloads for fixed nat statement dumps
Date:   Mon,  8 Mar 2021 15:14:19 +0100
Message-Id: <20210308141419.19428-1-phil@nwl.cc>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Libnftnl no longer dumps unused regs, so drop those.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/py/inet/dnat.t.payload          | 12 ++++++------
 tests/py/inet/snat.t.payload          |  6 +++---
 tests/py/ip/dnat.t.payload.ip         | 16 ++++++++--------
 tests/py/ip/hash.t.payload            |  2 +-
 tests/py/ip/masquerade.t.payload      |  2 +-
 tests/py/ip/numgen.t.payload          |  4 ++--
 tests/py/ip/snat.t.payload            | 12 ++++++------
 tests/py/ip6/dnat.t.payload.ip6       |  4 ++--
 tests/py/ip6/masquerade.t.payload.ip6 |  2 +-
 tests/py/ip6/snat.t.payload.ip6       |  2 +-
 10 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/tests/py/inet/dnat.t.payload b/tests/py/inet/dnat.t.payload
index a741b9cbdb8d7..ca3ff6316682e 100644
--- a/tests/py/inet/dnat.t.payload
+++ b/tests/py/inet/dnat.t.payload
@@ -18,7 +18,7 @@ inet test-inet prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x0000bb01 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 443 dnat ip6 to [dead::beef]:4443
 inet test-inet prerouting
@@ -30,7 +30,7 @@ inet test-inet prerouting
   [ cmp eq reg 1 0x0000bb01 ]
   [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
   [ immediate reg 2 0x00005b11 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip6 addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat ip to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-inet b size 1
@@ -39,7 +39,7 @@ __map%d test-inet 0
 inet test-inet prerouting
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # dnat ip to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
 __map%d test-inet b size 1
@@ -51,7 +51,7 @@ inet test-inet prerouting
   [ ct load mark => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # meta l4proto { tcp, udp } dnat ip to 1.1.1.1:80
 __set%d test-inet 3
@@ -62,7 +62,7 @@ inet
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x01010101 ]
   [ immediate reg 2 0x00005000 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # ip protocol { tcp, udp } dnat ip to 1.1.1.1:80
 __set%d test-inet 3
@@ -75,5 +75,5 @@ inet
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x01010101 ]
   [ immediate reg 2 0x00005000 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
diff --git a/tests/py/inet/snat.t.payload b/tests/py/inet/snat.t.payload
index 00bb937fd8430..50519c6b6bb6f 100644
--- a/tests/py/inet/snat.t.payload
+++ b/tests/py/inet/snat.t.payload
@@ -7,7 +7,7 @@ inet test-inet postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005100 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 ip saddr 10.1.1.1 snat to 192.168.3.2
 inet test-inet postrouting
@@ -22,7 +22,7 @@ inet test-inet postrouting
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ cmp eq reg 1 0x0101010a ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 snat ip6 to dead::beef
 inet test-inet postrouting
@@ -33,7 +33,7 @@ inet test-inet postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ cmp eq reg 1 0x00005100 ]
   [ immediate reg 1 0x0000adde 0x00000000 0x00000000 0xefbe0000 ]
-  [ nat snat ip6 addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip6 addr_min reg 1 ]
 
 # iifname "foo" masquerade random
 inet test-inet postrouting
diff --git a/tests/py/ip/dnat.t.payload.ip b/tests/py/ip/dnat.t.payload.ip
index 0acbefb6c2ab5..dd18dae2a1be4 100644
--- a/tests/py/ip/dnat.t.payload.ip
+++ b/tests/py/ip/dnat.t.payload.ip
@@ -8,7 +8,7 @@ ip test-ip4 prerouting
   [ cmp gte reg 1 0x00005000 ]
   [ cmp lte reg 1 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 80-90 dnat to 192.168.3.2
 ip test-ip4 prerouting
@@ -19,7 +19,7 @@ ip test-ip4 prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} dnat to 192.168.3.2
 __set%d test-ip4 3
@@ -33,7 +33,7 @@ ip test-ip4 prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != {80, 90, 23} dnat to 192.168.3.2
 __set%d test-ip4 3
@@ -47,7 +47,7 @@ ip test-ip4 prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 23-34 dnat to 192.168.3.2
 ip test-ip4 prerouting
@@ -58,7 +58,7 @@ ip test-ip4 prerouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002200 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport 81 dnat to 192.168.3.2:8080
 ip test-ip4 prerouting
@@ -70,7 +70,7 @@ ip test-ip4 prerouting
   [ cmp eq reg 1 0x00005100 ]
   [ immediate reg 1 0x0203a8c0 ]
   [ immediate reg 2 0x0000901f ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat to ct mark map { 0x00000014 : 1.2.3.4}
 __map%d test-ip4 b
@@ -79,7 +79,7 @@ __map%d test-ip4 0
 ip test-ip4 prerouting
   [ ct load mark => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # dnat to ct mark . ip daddr map { 0x00000014 . 1.1.1.1 : 1.2.3.4}
 __map%d test-ip4 b
@@ -89,5 +89,5 @@ ip test-ip4 output
   [ ct load mark => reg 1 ]
   [ payload load 4b @ network header + 16 => reg 9 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
diff --git a/tests/py/ip/hash.t.payload b/tests/py/ip/hash.t.payload
index 71ab06522a730..fefe492d8cbef 100644
--- a/tests/py/ip/hash.t.payload
+++ b/tests/py/ip/hash.t.payload
@@ -41,7 +41,7 @@ ip test-ip4 pre
   [ payload load 4b @ network header + 12 => reg 2 ]
   [ hash reg 1 = jhash(reg 2, 4, 0xdeadbeef) % mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # ct mark set symhash mod 2 offset 100
 ip test-ip4 pre
diff --git a/tests/py/ip/masquerade.t.payload b/tests/py/ip/masquerade.t.payload
index d5157d7139d4d..c4870ab8ae43b 100644
--- a/tests/py/ip/masquerade.t.payload
+++ b/tests/py/ip/masquerade.t.payload
@@ -130,7 +130,7 @@ ip test-ip4 postrouting
   [ payload load 1b @ network header + 9 => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
-  [ masq proto_min reg 1 proto_max reg 0 flags 0x2 ]
+  [ masq proto_min reg 1 flags 0x2 ]
 
 # ip protocol 6 masquerade to :1024-2048
 ip test-ip4 postrouting
diff --git a/tests/py/ip/numgen.t.payload b/tests/py/ip/numgen.t.payload
index 04088b7562f37..3349c68b1d313 100644
--- a/tests/py/ip/numgen.t.payload
+++ b/tests/py/ip/numgen.t.payload
@@ -10,7 +10,7 @@ __map%d x 0
 ip test-ip4 pre 
   [ numgen reg 1 = inc mod 2 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # dnat to numgen inc mod 10 map { 0-5 : 192.168.10.100, 6-9 : 192.168.20.200}
 __map%d test-ip4 f
@@ -20,7 +20,7 @@ ip test-ip4 pre
   [ numgen reg 1 = inc mod 10 ]
   [ byteorder reg 1 = hton(reg 1, 4, 4) ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat dnat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat dnat ip addr_min reg 1 ]
 
 # ct mark set numgen inc mod 2 offset 100
 ip test-ip4 pre
diff --git a/tests/py/ip/snat.t.payload b/tests/py/ip/snat.t.payload
index 22befe155dded..ef4c1ce9f150b 100644
--- a/tests/py/ip/snat.t.payload
+++ b/tests/py/ip/snat.t.payload
@@ -8,7 +8,7 @@ ip test-ip4 postrouting
   [ cmp gte reg 1 0x00005000 ]
   [ cmp lte reg 1 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 80-90 snat to 192.168.3.2
 ip test-ip4 postrouting
@@ -19,7 +19,7 @@ ip test-ip4 postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00005000 0x00005a00 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport {80, 90, 23} snat to 192.168.3.2
 __set%d test-ip4 3
@@ -33,7 +33,7 @@ ip test-ip4 postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != {80, 90, 23} snat to 192.168.3.2
 __set%d test-ip4 3
@@ -47,7 +47,7 @@ ip test-ip4 postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ lookup reg 1 set __set%d 0x1 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # iifname "eth0" tcp dport != 23-34 snat to 192.168.3.2
 ip test-ip4 postrouting
@@ -58,7 +58,7 @@ ip test-ip4 postrouting
   [ payload load 2b @ transport header + 2 => reg 1 ]
   [ range neq reg 1 0x00001700 0x00002200 ]
   [ immediate reg 1 0x0203a8c0 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 ]
+  [ nat snat ip addr_min reg 1 ]
 
 # snat ip addr . port to ip saddr map { 10.141.11.4 : 192.168.2.3 . 80 }
 __map%d test-ip4 b size 1
@@ -67,7 +67,7 @@ __map%d test-ip4 0
 ip 
   [ payload load 4b @ network header + 12 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 1 ]
-  [ nat snat ip addr_min reg 1 addr_max reg 0 proto_min reg 9 proto_max reg 0 ]
+  [ nat snat ip addr_min reg 1 proto_min reg 9 ]
 
 # snat ip interval to ip saddr map { 10.141.11.4 : 192.168.2.2-192.168.2.4 }
 __map%d test-ip4 b size 1
diff --git a/tests/py/ip6/dnat.t.payload.ip6 b/tests/py/ip6/dnat.t.payload.ip6
index 5906e0f8c97cc..004ffdeb3171b 100644
--- a/tests/py/ip6/dnat.t.payload.ip6
+++ b/tests/py/ip6/dnat.t.payload.ip6
@@ -21,7 +21,7 @@ ip6 test-ip6 prerouting
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 flags 0x2 ]
 
 # tcp dport 80-90 dnat to [2001:838:35f:1::]:80
 ip6 test-ip6 prerouting
@@ -32,7 +32,7 @@ ip6 test-ip6 prerouting
   [ cmp lte reg 1 0x00005a00 ]
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x00005000 ]
-  [ nat dnat ip6 addr_min reg 1 addr_max reg 0 proto_min reg 2 proto_max reg 0 flags 0x2 ]
+  [ nat dnat ip6 addr_min reg 1 proto_min reg 2 flags 0x2 ]
 
 # dnat to [2001:838:35f:1::]/64
 ip6 test-ip6 prerouting
diff --git a/tests/py/ip6/masquerade.t.payload.ip6 b/tests/py/ip6/masquerade.t.payload.ip6
index 06b79d8ecd678..d6410b2cf2db3 100644
--- a/tests/py/ip6/masquerade.t.payload.ip6
+++ b/tests/py/ip6/masquerade.t.payload.ip6
@@ -130,7 +130,7 @@ ip6 test-ip6 postrouting
   [ meta load l4proto => reg 1 ]
   [ cmp eq reg 1 0x00000006 ]
   [ immediate reg 1 0x00000004 ]
-  [ masq proto_min reg 1 proto_max reg 0 flags 0x2 ]
+  [ masq proto_min reg 1 flags 0x2 ]
 
 # meta l4proto 6 masquerade to :1024-2048
 ip6 test-ip6 postrouting
diff --git a/tests/py/ip6/snat.t.payload.ip6 b/tests/py/ip6/snat.t.payload.ip6
index e7fd8ff8ca405..66a29672c61b0 100644
--- a/tests/py/ip6/snat.t.payload.ip6
+++ b/tests/py/ip6/snat.t.payload.ip6
@@ -21,5 +21,5 @@ ip6 test-ip6 postrouting
   [ immediate reg 1 0x38080120 0x01005f03 0x00000000 0x00000000 ]
   [ immediate reg 2 0x38080120 0x02005f03 0x00000000 0x00000000 ]
   [ immediate reg 3 0x00006400 ]
-  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 proto_max reg 0 flags 0x2 ]
+  [ nat snat ip6 addr_min reg 1 addr_max reg 2 proto_min reg 3 flags 0x2 ]
 
-- 
2.30.1

