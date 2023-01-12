Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE24FC61DB3
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Jan 2023 21:46:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240770AbjALVqQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Jan 2023 16:46:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240785AbjALVpg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Jan 2023 16:45:36 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 948215B163
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Jan 2023 13:37:57 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] intervals: restrict check missing elements fix to sets with no auto-merge
Date:   Thu, 12 Jan 2023 22:37:53 +0100
Message-Id: <20230112213753.212261-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If auto-merge is enabled, skip check for element mismatch introduced by
6d1ee9267e7e ("intervals: check for EXPR_F_REMOVE in case of element
mismatch"), which is only relevant to sets with no auto-merge.

The interval adjustment routine for auto-merge already checks for
unexisting intervals in that case.

Uncovered via ASAN:

0x60d00000014c is located 60 bytes inside of 144-byte region [0x60d000000110,0x60d0000001a0)
freed by thread T0 here:
    #0 0x7fbdb7eae507 in __interceptor_free ../../../../src/libsanitizer/asan/asan_malloc_linux.cpp:127
    #1 0x7fbdb741a01e in xfree /home/pablo/devel/scm/git-netfilter/nftables/src/utils.c:29
    #2 0x7fbdb7304473 in expr_free /home/pablo/devel/scm/git-netfilter/nftables/src/expression.c:98
    #3 0x7fbdb7391fdd in adjust_elem_left /home/pablo/devel/scm/git-netfilter/nftables/src/intervals.c:304
    #4 0x7fbdb73939e1 in setelem_adjust /home/pablo/devel/scm/git-netfilter/nftables/src/intervals.c:359

Fixes: 6d1ee9267e7e ("intervals: check for EXPR_F_REMOVE in case of element mismatch")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 13009ca1b888..95e25cf09662 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -416,11 +416,12 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 				list_del(&i->list);
 				expr_free(i);
 			}
-		} else if (set->automerge &&
-			   setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
-			expr_error(msgs, i, "element does not exist");
-			err = -1;
-			goto err;
+		} else if (set->automerge) {
+			if (setelem_adjust(set, purge, &prev_range, &range, prev, i) < 0) {
+				expr_error(msgs, i, "element does not exist");
+				err = -1;
+				goto err;
+			}
 		} else if (i->flags & EXPR_F_REMOVE) {
 			expr_error(msgs, i, "element does not exist");
 			err = -1;
-- 
2.30.2

