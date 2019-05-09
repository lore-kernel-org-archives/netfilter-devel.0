Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59BDEC04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2954820989
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 11:36:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfEILgY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 07:36:24 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:35062 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726084AbfEILgX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 07:36:23 -0400
Received: from localhost ([::1]:48152 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hOhLZ-0000dw-Iy; Thu, 09 May 2019 13:36:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH 7/9] tests/py: Fix for ip dscp symbol "le"
Date:   Thu,  9 May 2019 13:35:43 +0200
Message-Id: <20190509113545.4017-8-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509113545.4017-1-phil@nwl.cc>
References: <20190509113545.4017-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

In scanner.l, that name is defined as alternative to "<=" symbol. To
avoid the clash, it must be quoted on input.

Fixes: 55715486efba4 ("proto: support for draft-ietf-tsvwg-le-phb-10.txt")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Note that nft still produces invalid output since it doesn't quote
symbol table values.
---
 tests/py/ip/ip.t                | 2 +-
 tests/py/ip/ip.t.json           | 2 +-
 tests/py/ip/ip.t.payload        | 4 ++--
 tests/py/ip6/ip6.t              | 2 +-
 tests/py/ip6/ip6.t.json         | 2 +-
 tests/py/ip6/ip6.t.payload.inet | 4 ++--
 tests/py/ip6/ip6.t.payload.ip6  | 4 ++--
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tests/py/ip/ip.t b/tests/py/ip/ip.t
index dc6b173def36d..f224e1d21033c 100644
--- a/tests/py/ip/ip.t
+++ b/tests/py/ip/ip.t
@@ -28,7 +28,7 @@ ip dscp cs1;ok
 ip dscp != cs1;ok
 ip dscp 0x38;ok;ip dscp cs7
 ip dscp != 0x20;ok;ip dscp != cs4
-ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+ip dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 - ip dscp {0x08, 0x10, 0x18, 0x20, 0x28, 0x30, 0x38, 0x00, 0x0a, 0x0c, 0x0e, 0x12, 0x14, 0x16, 0x1a, 0x1c, 0x1e, 0x22, 0x24, 0x26, 0x2e};ok
 ip dscp != {cs0, cs3};ok
 ip dscp vmap { cs1 : continue , cs4 : accept } counter;ok
diff --git a/tests/py/ip/ip.t.json b/tests/py/ip/ip.t.json
index 69e8d02540b87..51bc15e71cd2f 100644
--- a/tests/py/ip/ip.t.json
+++ b/tests/py/ip/ip.t.json
@@ -62,7 +62,7 @@
     }
 ]
 
-# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 [
     {
         "match": {
diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 37d4ef85a8e97..f62ce823586d1 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -22,10 +22,10 @@ ip test-ip4 input
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000080 ]
 
-# ip dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip4 3
 __set%d test-ip4 0
-        element 00000020  : 0 [end]     element 00000040  : 0 [end]     element 00000060  : 0 [end]     element 00000080  : 0 [end]    element 000000a0  : 0 [end]      element 000000c0  : 0 [end]     element 000000e0  : 0 [end]     element 00000000  : 0 [end]     element 00000028  : 0 [end]     element 00000030  : 0 [end]     element 00000038  : 0 [end]     element 00000048  : 0 [end]     element 00000050  : 0 [end]     element 00000058  : 0 [end]     element 00000068  : 0 [end]     element 00000070  : 0 [end]     element 00000078  : 0 [end]     element 00000088  : 0 [end]     element 00000090  : 0 [end]     element 00000098  : 0 [end]     element 000000b8  : 0 [end]
+	element 00000000  : 0 [end]	element 00000004  : 0 [end]	element 00000020  : 0 [end]	element 00000040  : 0 [end]	element 00000060  : 0 [end]	element 00000080  : 0 [end]	element 000000a0  : 0 [end]	element 000000c0  : 0 [end]	element 000000e0  : 0 [end]	element 00000028  : 0 [end]	element 00000030  : 0 [end]	element 00000038  : 0 [end]	element 00000048  : 0 [end]	element 00000050  : 0 [end]	element 00000058  : 0 [end]	element 00000068  : 0 [end]	element 00000070  : 0 [end]	element 00000078  : 0 [end]	element 00000088  : 0 [end]	element 00000090  : 0 [end]	element 00000098  : 0 [end]	element 000000b8  : 0 [end]
 ip test-ip4 input
   [ payload load 1b @ network header + 1 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x000000fc ) ^ 0x00000000 ]
diff --git a/tests/py/ip6/ip6.t b/tests/py/ip6/ip6.t
index a266fddfb5783..985c21625691e 100644
--- a/tests/py/ip6/ip6.t
+++ b/tests/py/ip6/ip6.t
@@ -14,7 +14,7 @@ ip6 dscp cs1;ok
 ip6 dscp != cs1;ok
 ip6 dscp 0x38;ok;ip6 dscp cs7
 ip6 dscp != 0x20;ok;ip6 dscp != cs4
-ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
+ip6 dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef};ok
 ip6 dscp vmap { 0x04 : accept, 0x3f : continue } counter;ok
 
 ip6 flowlabel 22;ok
diff --git a/tests/py/ip6/ip6.t.json b/tests/py/ip6/ip6.t.json
index a46c2b1f50553..943f5411a9cc7 100644
--- a/tests/py/ip6/ip6.t.json
+++ b/tests/py/ip6/ip6.t.json
@@ -62,7 +62,7 @@
     }
 ]
 
-# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 [
     {
         "match": {
diff --git a/tests/py/ip6/ip6.t.payload.inet b/tests/py/ip6/ip6.t.payload.inet
index ada1c5f020511..aafb027fdc424 100644
--- a/tests/py/ip6/ip6.t.payload.inet
+++ b/tests/py/ip6/ip6.t.payload.inet
@@ -30,10 +30,10 @@ inet test-inet input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
-# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-inet 3
 __set%d test-inet 0
-        element 00000000  : 0 [end]     element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]    element 00000008  : 0 [end]      element 0000000a  : 0 [end]     element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+	element 00000000  : 0 [end]	element 00004000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00008002  : 0 [end]	element 00000003  : 0 [end]	element 00008003  : 0 [end]	element 00008004  : 0 [end]	element 00000005  : 0 [end]	element 00008005  : 0 [end]	element 00008006  : 0 [end]	element 00000007  : 0 [end]	element 00008007  : 0 [end]	element 00008008  : 0 [end]	element 00000009  : 0 [end]	element 00008009  : 0 [end]	element 0000800b  : 0 [end]
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip6/ip6.t.payload.ip6 b/tests/py/ip6/ip6.t.payload.ip6
index efab25565d09b..632b222e1b43a 100644
--- a/tests/py/ip6/ip6.t.payload.ip6
+++ b/tests/py/ip6/ip6.t.payload.ip6
@@ -22,10 +22,10 @@ ip6 test-ip6 input
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
   [ cmp neq reg 1 0x00000008 ]
 
-# ip6 dscp {cs0, le, cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
+# ip6 dscp {cs0, "le", cs1, cs2, cs3, cs4, cs5, cs6, cs7, af11, af12, af13, af21, af22, af23, af31, af32, af33, af41, af42, af43, ef}
 __set%d test-ip6 3
 __set%d test-ip6 0
-        element 00000002  : 0 [end]     element 00000004  : 0 [end]     element 00000006  : 0 [end]     element 00000008  : 0 [end]    element 0000000a  : 0 [end]      element 0000000c  : 0 [end]     element 0000000e  : 0 [end]     element 00000000  : 0 [end]     element 00008002  : 0 [end]     element 00000003  : 0 [end]     element 00008003  : 0 [end]     element 00008004  : 0 [end]     element 00000005  : 0 [end]     element 00008005  : 0 [end]     element 00008006  : 0 [end]     element 00000007  : 0 [end]     element 00008007  : 0 [end]     element 00008008  : 0 [end]     element 00000009  : 0 [end]     element 00008009  : 0 [end]     element 0000800b  : 0 [end]
+	element 00000000  : 0 [end]	element 00004000  : 0 [end]	element 00000002  : 0 [end]	element 00000004  : 0 [end]	element 00000006  : 0 [end]	element 00000008  : 0 [end]	element 0000000a  : 0 [end]	element 0000000c  : 0 [end]	element 0000000e  : 0 [end]	element 00008002  : 0 [end]	element 00000003  : 0 [end]	element 00008003  : 0 [end]	element 00008004  : 0 [end]	element 00000005  : 0 [end]	element 00008005  : 0 [end]	element 00008006  : 0 [end]	element 00000007  : 0 [end]	element 00008007  : 0 [end]	element 00008008  : 0 [end]	element 00000009  : 0 [end]	element 00008009  : 0 [end]	element 0000800b  : 0 [end]
 ip6 test-ip6 input
   [ payload load 2b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = (reg=1 & 0x0000c00f ) ^ 0x00000000 ]
-- 
2.21.0

