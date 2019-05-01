Return-Path: <SRS0=QQeY=TB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60771C43219
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 13:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 286C221670
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 May 2019 13:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfEANXX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 May 2019 09:23:23 -0400
Received: from relay1-d.mail.gandi.net ([217.70.183.193]:41555 "EHLO
        relay1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfEANXX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 May 2019 09:23:23 -0400
X-Originating-IP: 41.136.242.37
Received: from logan-ThinkPad-X230-Tablet (unknown [41.136.242.37])
        (Authenticated sender: logan@cyberstorm.mu)
        by relay1-d.mail.gandi.net (Postfix) with ESMTPSA id 4F4B9240003
        for <netfilter-devel@vger.kernel.org>; Wed,  1 May 2019 13:23:18 +0000 (UTC)
Date:   Wed, 1 May 2019 17:23:15 +0400
From:   Loganaden Velvindron <logan@cyberstorm.mu>
To:     netfilter-devel@vger.kernel.org
Subject: [nftables,v2] proto: support for draft-ietf-tsvwg-le-phb-10.txt
Message-ID: <20190501132315.GA31318@logan-ThinkPad-X230-Tablet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Upcoming dscp codepoint for background traffic of low precendence
such as bulk data transfers with low priority in time, non time-critical
backups, larger software updates, web search engines while gathering
information from web servers and so on.  

Signed-off-by: Loganaden Velvindron <logan@cyberstorm.mu>
---
 src/proto.c                     | 1 +
 tests/py/ip/ip.t                | 2 +-
 tests/py/ip/ip.t.json           | 3 ++-
 tests/py/ip/ip.t.json.output    | 3 ++-
 tests/py/ip/ip.t.payload        | 2 +-
 tests/py/ip/ip.t.payload.bridge | 2 +-
 tests/py/ip/ip.t.payload.inet   | 2 +-
 tests/py/ip/ip.t.payload.netdev | 2 +-
 tests/py/ip6/ip6.t              | 2 +-
 tests/py/ip6/ip6.t.json         | 3 ++-
 tests/py/ip6/ip6.t.payload.inet | 2 +-
 tests/py/ip6/ip6.t.payload.ip6  | 2 +-
 12 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/src/proto.c b/src/proto.c
index f68fb68..9a7f77b 100644
--- a/src/proto.c
+++ b/src/proto.c
@@ -571,6 +571,7 @@ static const struct symbol_table dscp_type_tbl = {
 	.base		= BASE_HEXADECIMAL,
 	.symbols	= {
 		SYMBOL("cs0",	0x00),
+		SYMBOL("le",	0x01),
 		SYMBOL("cs1",	0x08),
 		SYMBOL("cs2",	0x10),
 		SYMBOL("cs3",	0x18),
diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index 0421d01..dc6b173 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -28,7 +28,7 @@ ip dscp cs1;ok
 ip dscp != cs1;ok
 ip dscp 0x38;ok;ip dscp cs7
 ip dscp != 0x20;ok;ip dscp != cs4
-ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 - ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
 ip dscp != {cs0, cs3};ok
 ip dscp vmap { cs1 : continue , cs4 : accept } counter;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 3131ab7..69e8d02 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -62,7 +62,7 @@
     }
 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 [
     {
         "match": {
@@ -76,6 +76,7 @@
             "right": {
                 "set": [
                     "cs0",
+                    "le",
                     "cs1",
                     "cs2",
                     "cs3",
diff --git a/tests/py/ip/ip.t.json.output b/tests/py/ip/ip.t.json.output
index b201cda..ae6e838 100644
--- a/tests/py/ip/ip.t.json.output
+++ b/tests/py/ip/ip.t.json.output
@@ -30,7 +30,7 @@
     }
 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 [
     {
         "match": {
@@ -44,6 +44,7 @@
             "right": {
                 "set": [
                     "cs0",
+                    "le",
                     "cs1",
                     "af11",
                     "af12",
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index d627b22..37d4ef8 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -22,7 +22,7 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip4 3
 __set%d test-ip4 0
         element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index ad1d0aa..40c98de 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -30,7 +30,7 @@ bridge test-bridge input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-bridge 3 size 21
 __set%d test-bridge 0
 	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index b9cb28a..9f1f451 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -30,7 +30,7 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-inet 3
 __set%d test-inet 0
         element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 588e5ca..ef87bad 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -775,7 +775,7 @@ netdev test-netdev ingress
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
-# ip dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-netdev 3
 __set%d test-netdev 0
 	element 00000000  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index 8210d22..a266fdd 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -14,7 +14,7 @@ ip6 dscp cs1;ok
 ip6 dscp != cs1;ok
 ip6 dscp 0x38;ok;ip6 dscp cs7
 ip6 dscp != 0x20;ok;ip6 dscp != cs4
-ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter;ok
 
 ip6 flowlabel 22;ok
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index f898240..a46c2b1 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -62,7 +62,7 @@
     }
 ]
 
-# ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 [
     {
         "match": {
@@ -76,6 +76,7 @@
             "right": {
                 "set": [
                     "cs0",
+                    "le",
                     "cs1",
                     "cs2",
                     "cs3",
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index d015c8e..ada1c5f 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -30,7 +30,7 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
-# ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-inet 3
 __set%d test-inet 0
         element 00000000  : 0 [end]     element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]    element 00000008  : 0 [end]      element 0000000a  : 0 [end]     element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index b2e8363..efab255 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -22,7 +22,7 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
-# ip6 dscp {cs0, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip6 3
 __set%d test-ip6 0
         element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]     element 00000008  : 0 [end]    element 0000000a  : 0 [end]      element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00000000  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
-- 
2.17.1

