Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1EEC6FD1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Mar 2023 21:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjCVVxY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Mar 2023 17:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbjCVVxX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2023 17:53:23 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC1542B29A
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2023 14:53:17 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft,v2 7/8] tests: shell: rename and move bitwise test-cases
Date:   Wed, 22 Mar 2023 22:53:02 +0100
Message-Id: <20230322215303.239763-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230322215303.239763-1-pablo@netfilter.org>
References: <20230322215303.239763-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

The `0040mark_shift_?` tests are testing not just shifts, but binops
more generally, so name them accordingly.

Move them to a new folder specifically for bitwise operations.

Change the priorities of the chains to match the type.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 .../{chains/0040mark_shift_0 => bitwise/0040mark_binop_0}       | 2 +-
 .../{chains/0040mark_shift_1 => bitwise/0040mark_binop_1}       | 2 +-
 .../0040mark_shift_0.nft => bitwise/dumps/0040mark_binop_0.nft} | 2 +-
 .../0040mark_shift_1.nft => bitwise/dumps/0040mark_binop_1.nft} | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)
 rename tests/shell/testcases/{chains/0040mark_shift_0 => bitwise/0040mark_binop_0} (68%)
 rename tests/shell/testcases/{chains/0040mark_shift_1 => bitwise/0040mark_binop_1} (70%)
 rename tests/shell/testcases/{chains/dumps/0040mark_shift_0.nft => bitwise/dumps/0040mark_binop_0.nft} (58%)
 rename tests/shell/testcases/{chains/dumps/0040mark_shift_1.nft => bitwise/dumps/0040mark_binop_1.nft} (64%)

diff --git a/tests/shell/testcases/chains/0040mark_shift_0 b/tests/shell/testcases/bitwise/0040mark_binop_0
similarity index 68%
rename from tests/shell/testcases/chains/0040mark_shift_0
rename to tests/shell/testcases/bitwise/0040mark_binop_0
index ef3dccfa049a..4280e33ac45a 100755
--- a/tests/shell/testcases/chains/0040mark_shift_0
+++ b/tests/shell/testcases/bitwise/0040mark_binop_0
@@ -4,7 +4,7 @@ set -e
 
 RULESET="
   add table t
-  add chain t c { type filter hook output priority mangle; }
+  add chain t c { type filter hook output priority filter; }
   add rule t c oif lo ct mark set (meta mark | 0x10) << 8
 "
 
diff --git a/tests/shell/testcases/chains/0040mark_shift_1 b/tests/shell/testcases/bitwise/0040mark_binop_1
similarity index 70%
rename from tests/shell/testcases/chains/0040mark_shift_1
rename to tests/shell/testcases/bitwise/0040mark_binop_1
index b609f5ef10ad..7e71f3eb43a8 100755
--- a/tests/shell/testcases/chains/0040mark_shift_1
+++ b/tests/shell/testcases/bitwise/0040mark_binop_1
@@ -4,7 +4,7 @@ set -e
 
 RULESET="
   add table t
-  add chain t c { type filter hook input priority mangle; }
+  add chain t c { type filter hook input priority filter; }
   add rule t c iif lo ct mark & 0xff 0x10 meta mark set ct mark >> 8
 "
 
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.nft
similarity index 58%
rename from tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
rename to tests/shell/testcases/bitwise/dumps/0040mark_binop_0.nft
index 52d59d2c6da4..fc0a600a4dbe 100644
--- a/tests/shell/testcases/chains/dumps/0040mark_shift_0.nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_0.nft
@@ -1,6 +1,6 @@
 table ip t {
 	chain c {
-		type filter hook output priority mangle; policy accept;
+		type filter hook output priority filter; policy accept;
 		oif "lo" ct mark set (meta mark | 0x00000010) << 8
 	}
 }
diff --git a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft b/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.nft
similarity index 64%
rename from tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
rename to tests/shell/testcases/bitwise/dumps/0040mark_binop_1.nft
index 56ec8dc766ca..dbaacefb93c7 100644
--- a/tests/shell/testcases/chains/dumps/0040mark_shift_1.nft
+++ b/tests/shell/testcases/bitwise/dumps/0040mark_binop_1.nft
@@ -1,6 +1,6 @@
 table ip t {
 	chain c {
-		type filter hook input priority mangle; policy accept;
+		type filter hook input priority filter; policy accept;
 		iif "lo" ct mark & 0x000000ff == 0x00000010 meta mark set ct mark >> 8
 	}
 }
-- 
2.30.2

