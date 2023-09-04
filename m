Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0312C83F3F
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Sep 2023 09:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjIDJHM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Sep 2023 05:07:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350634AbjIDJHL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2023 05:07:11 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FF218B
        for <netfilter-devel@vger.kernel.org>; Mon,  4 Sep 2023 02:07:07 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qd5Y2-0000F4-AR; Mon, 04 Sep 2023 11:07:06 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 3/5] tests: shell: typeof_integer/raw: prefer @nh for payload matching
Date:   Mon,  4 Sep 2023 11:06:32 +0200
Message-ID: <20230904090640.3015-4-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230904090640.3015-1-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

@ih fails on kernels where payload expression doesn't support the 'inner'
base offset.

This test isn't about inner headers, so just use @nh which is
universally available.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 tests/shell/testcases/maps/dumps/typeof_integer_0.nft | 4 ++--
 tests/shell/testcases/maps/dumps/typeof_raw_0.nft     | 4 ++--
 tests/shell/testcases/maps/typeof_integer_0           | 4 ++--
 tests/shell/testcases/maps/typeof_raw_0               | 4 ++--
 tests/shell/testcases/sets/dumps/typeof_raw_0.nft     | 4 ++--
 tests/shell/testcases/sets/typeof_raw_0               | 4 ++--
 6 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tests/shell/testcases/maps/dumps/typeof_integer_0.nft b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
index 330415574c95..19c24febffcc 100644
--- a/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_integer_0.nft
@@ -13,8 +13,8 @@ table inet t {
 	}
 
 	chain c {
-		udp length . @ih,32,32 vmap @m1
-		udp length . @ih,32,32 vmap @m2
+		udp length . @nh,32,32 vmap @m1
+		udp length . @nh,32,32 vmap @m2
 		udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
 	}
 }
diff --git a/tests/shell/testcases/maps/dumps/typeof_raw_0.nft b/tests/shell/testcases/maps/dumps/typeof_raw_0.nft
index e876425b2bc6..476169f2943b 100644
--- a/tests/shell/testcases/maps/dumps/typeof_raw_0.nft
+++ b/tests/shell/testcases/maps/dumps/typeof_raw_0.nft
@@ -7,7 +7,7 @@ table ip x {
 	}
 
 	chain y {
-		ip saddr . @ih,32,32 vmap @y
-		ip saddr . @ih,32,32 vmap { 4.4.4.4 . 0x34 : accept, 5.5.5.5 . 0x45 : drop }
+		ip saddr . @nh,32,32 vmap @y
+		ip saddr . @nh,32,32 vmap { 4.4.4.4 . 0x34 : accept, 5.5.5.5 . 0x45 : drop }
 	}
 }
diff --git a/tests/shell/testcases/maps/typeof_integer_0 b/tests/shell/testcases/maps/typeof_integer_0
index d51510af9073..0deff5eef67b 100755
--- a/tests/shell/testcases/maps/typeof_integer_0
+++ b/tests/shell/testcases/maps/typeof_integer_0
@@ -13,8 +13,8 @@ EXPECTED="table inet t {
 	}
 
 	chain c {
-		udp length . @ih,32,32 vmap @m1
-		udp length . @ih,32,32 vmap @m2
+		udp length . @nh,32,32 vmap @m1
+		udp length . @nh,32,32 vmap @m2
 		udp length . @th,160,128 vmap { 47-63 . 0xe373135363130333131303735353203 : accept }
 	}
 }"
diff --git a/tests/shell/testcases/maps/typeof_raw_0 b/tests/shell/testcases/maps/typeof_raw_0
index e3da7825cb7b..bcd2c6d8c502 100755
--- a/tests/shell/testcases/maps/typeof_raw_0
+++ b/tests/shell/testcases/maps/typeof_raw_0
@@ -7,8 +7,8 @@ EXPECTED="table ip x {
 	}
 
 	chain y {
-		ip saddr . @ih,32,32 vmap @y
-		ip saddr . @ih,32,32 vmap { 4.4.4.4 . 0x34 : accept, 5.5.5.5 . 0x45 : drop}
+		ip saddr . @nh,32,32 vmap @y
+		ip saddr . @nh,32,32 vmap { 4.4.4.4 . 0x34 : accept, 5.5.5.5 . 0x45 : drop}
 	}
 }"
 
diff --git a/tests/shell/testcases/sets/dumps/typeof_raw_0.nft b/tests/shell/testcases/sets/dumps/typeof_raw_0.nft
index 499ff167f51d..4d6abaaa151b 100644
--- a/tests/shell/testcases/sets/dumps/typeof_raw_0.nft
+++ b/tests/shell/testcases/sets/dumps/typeof_raw_0.nft
@@ -6,7 +6,7 @@ table inet t {
 	}
 
 	chain y {
-		ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
-		ip daddr . @ih,32,32 @y
+		ip saddr . @nh,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
+		ip daddr . @nh,32,32 @y
 	}
 }
diff --git a/tests/shell/testcases/sets/typeof_raw_0 b/tests/shell/testcases/sets/typeof_raw_0
index 36396b5c2e1d..66042eb4085a 100755
--- a/tests/shell/testcases/sets/typeof_raw_0
+++ b/tests/shell/testcases/sets/typeof_raw_0
@@ -7,8 +7,8 @@ EXPECTED="table inet t {
 	}
 
 	chain y {
-		ip saddr . @ih,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
-		ip daddr . @ih,32,32 @y
+		ip saddr . @nh,32,32 { 1.1.1.1 . 0x14, 2.2.2.2 . 0x1e }
+		ip daddr . @nh,32,32 @y
 	}
 }"
 
-- 
2.41.0

