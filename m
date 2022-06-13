Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8220DCCA47D
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 Jun 2022 18:39:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbiFMSjE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 Jun 2022 14:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343769AbiFMSiY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Jun 2022 14:38:24 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0A1E11A040
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jun 2022 08:37:10 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 2/2] intervals: do not report exact overlaps for new elements
Date:   Mon, 13 Jun 2022 17:37:05 +0200
Message-Id: <20220613153705.127156-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220613153705.127156-1-pablo@netfilter.org>
References: <20220613153705.127156-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Two new elements that represent an exact overlap should not trigger an error.

   add table t
   add set t s { type ipv4_addr; flags interval; }
   add element t s { 1.0.1.0/24 }
   ...
   add element t s { 1.0.1.0/24 }

result in a bogus error.

 # nft -f set.nft
 set.nft:1002:19-28: Error: conflicting intervals specified
 add element t s { 1.0.1.0/24 }
                   ^^^^^^^^^^

Fixes: 3da9643fb9ff ("intervals: add support to automerge with kernel elements")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c                            |  3 +--
 tests/shell/testcases/sets/exact_overlap_0 | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)
 create mode 100755 tests/shell/testcases/sets/exact_overlap_0

diff --git a/src/intervals.c b/src/intervals.c
index bc414d6c8797..89f5c33d7a6e 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -540,8 +540,7 @@ static int setelem_overlap(struct list_head *msgs, struct set *set,
 		}
 
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
-		    mpz_cmp(prev_range.high, range.high) == 0 &&
-		    (elem->flags & EXPR_F_KERNEL || prev->flags & EXPR_F_KERNEL))
+		    mpz_cmp(prev_range.high, range.high) == 0)
 			goto next;
 
 		if (mpz_cmp(prev_range.low, range.low) <= 0 &&
diff --git a/tests/shell/testcases/sets/exact_overlap_0 b/tests/shell/testcases/sets/exact_overlap_0
new file mode 100755
index 000000000000..1ce9304a7455
--- /dev/null
+++ b/tests/shell/testcases/sets/exact_overlap_0
@@ -0,0 +1,22 @@
+#!/bin/bash
+
+RULESET="add table t
+add set t s { type ipv4_addr; flags interval; }
+add element t s { 1.0.1.0/24 }
+add element t s { 1.0.2.0/23 }
+add element t s { 1.0.8.0/21 }
+add element t s { 1.0.32.0/19 }
+add element t s { 1.1.0.0/24 }
+add element t s { 1.1.2.0/23 }
+add element t s { 1.1.4.0/22 }
+add element t s { 1.1.8.0/24 }
+add element t s { 1.1.9.0/24 }
+add element t s { 1.1.10.0/23 }
+add element t s { 1.1.12.0/22 }
+add element t s { 1.1.16.0/20 }
+add element t s { 1.1.32.0/19 }
+add element t s { 1.0.1.0/24 }"
+
+$NFT -f - <<< $RULESET || exit 1
+
+$NFT add element t s { 1.0.1.0/24 }
-- 
2.30.2

