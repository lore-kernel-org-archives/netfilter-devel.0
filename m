Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF84C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BE0A6120F
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Nov 2021 21:40:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhKDVnF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Nov 2021 17:43:05 -0400
Received: from mail.netfilter.org ([217.70.188.207]:38512 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhKDVnF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Nov 2021 17:43:05 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 6485560831
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Nov 2021 22:38:30 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] tests: py: remove verdict from closing end interval
Date:   Thu,  4 Nov 2021 22:40:20 +0100
Message-Id: <20211104214021.366663-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Kernel does not allow for NFT_SET_ELEM_INTERVAL_END flag and
NFTA_SET_ELEM_DATA. The closing end interval represents a mismatch,
therefore, no verdict can be applied. The existing payload files show
the drop verdict when this is unset (because NF_DROP=0).

This update is required to fix payload warnings in tests/py after
libnftnl's ("set: use NFTNL_SET_ELEM_VERDICT to print verdict").

Fixes: 6671d9d137f6 ("mnl: Set NFTNL_SET_DATA_TYPE before dumping set elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/py/ip/ip.t.payload           | 2 +-
 tests/py/ip/ip.t.payload.bridge    | 2 +-
 tests/py/ip/ip.t.payload.inet      | 2 +-
 tests/py/ip/ip.t.payload.netdev    | 2 +-
 tests/py/ip6/vmap.t.payload.inet   | 2 +-
 tests/py/ip6/vmap.t.payload.ip6    | 2 +-
 tests/py/ip6/vmap.t.payload.netdev | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tests/py/ip/ip.t.payload b/tests/py/ip/ip.t.payload
index 49d1a0fb03e8..b9fcb5158e9d 100644
--- a/tests/py/ip/ip.t.payload
+++ b/tests/py/ip/ip.t.payload
@@ -430,7 +430,7 @@ ip test-ip4 input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-ip4 f size 4
 __map%d test-ip4 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
 ip test-ip4 input 
   [ payload load 1b @ network header + 0 => reg 1 ]
   [ bitwise reg 1 = ( reg 1 & 0x0000000f ) ^ 0x00000000 ]
diff --git a/tests/py/ip/ip.t.payload.bridge b/tests/py/ip/ip.t.payload.bridge
index dac8654395f4..c6f8d4e5575b 100644
--- a/tests/py/ip/ip.t.payload.bridge
+++ b/tests/py/ip/ip.t.payload.bridge
@@ -566,7 +566,7 @@ bridge test-bridge input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-bridge f size 4
 __map%d test-bridge 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
 bridge test-bridge input 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/ip/ip.t.payload.inet b/tests/py/ip/ip.t.payload.inet
index 64371650480f..e26d0dac47be 100644
--- a/tests/py/ip/ip.t.payload.inet
+++ b/tests/py/ip/ip.t.payload.inet
@@ -566,7 +566,7 @@ inet test-inet input
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-inet f size 4
 __map%d test-inet 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
 inet test-inet input 
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x00000002 ]
diff --git a/tests/py/ip/ip.t.payload.netdev b/tests/py/ip/ip.t.payload.netdev
index 65f8c96a9470..de990f5bba12 100644
--- a/tests/py/ip/ip.t.payload.netdev
+++ b/tests/py/ip/ip.t.payload.netdev
@@ -465,7 +465,7 @@ netdev test-netdev ingress
 # ip hdrlength vmap { 0-4 : drop, 5 : accept, 6 : continue } counter
 __map%d test-netdev f size 4
 __map%d test-netdev 0
-	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : drop 1 [end]
+	element 00000000  : drop 0 [end]	element 00000005  : accept 0 [end]	element 00000006  : continue 0 [end]	element 00000007  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x00000008 ]
diff --git a/tests/py/ip6/vmap.t.payload.inet b/tests/py/ip6/vmap.t.payload.inet
index 522564a31044..931cc6bd75a7 100644
--- a/tests/py/ip6/vmap.t.payload.inet
+++ b/tests/py/ip6/vmap.t.payload.inet
@@ -371,7 +371,7 @@ inet test-inet input
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-inet f
 __map%d test-inet 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 inet test-inet input
   [ meta load nfproto => reg 1 ]
   [ cmp eq reg 1 0x0000000a ]
diff --git a/tests/py/ip6/vmap.t.payload.ip6 b/tests/py/ip6/vmap.t.payload.ip6
index 3850a7c58fd1..6e077b27a5f0 100644
--- a/tests/py/ip6/vmap.t.payload.ip6
+++ b/tests/py/ip6/vmap.t.payload.ip6
@@ -297,7 +297,7 @@ ip6 test-ip6 input
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-ip6 f
 __map%d test-ip6 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 ip6 test-ip6 input
   [ payload load 16b @ network header + 8 => reg 1 ]
   [ lookup reg 1 set __map%d dreg 0 ]
diff --git a/tests/py/ip6/vmap.t.payload.netdev b/tests/py/ip6/vmap.t.payload.netdev
index d9cbad5877ae..45f2c0b01e9c 100644
--- a/tests/py/ip6/vmap.t.payload.netdev
+++ b/tests/py/ip6/vmap.t.payload.netdev
@@ -371,7 +371,7 @@ netdev test-netdev ingress
 # ip6 saddr vmap { ::/64 : accept}
 __map%d test-netdev f
 __map%d test-netdev 0
-	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : drop 1 [end]
+	element 00000000 00000000 00000000 00000000  : accept 0 [end]	element 00000000 01000000 00000000 00000000  : 1 [end]
 netdev test-netdev ingress 
   [ meta load protocol => reg 1 ]
   [ cmp eq reg 1 0x0000dd86 ]
-- 
2.30.2

