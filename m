Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A01FEC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 14 Apr 2022 11:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242730AbiDNLl6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 14 Apr 2022 07:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiDNLl4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 14 Apr 2022 07:41:56 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EF2E2E
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2022 04:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4go7r0RZt2OvTYC2xIesR5Et4o5zp/5MsGRLeVSyJJU=; b=XW5YmWh9xSwpnS6QEXViKRmUTV
        1Tt7Ue2yuIbvXqWk4vDtYAIHLM//5jL7sIxqK7UOTuNdCD8aMRXEOzC4Aj0LOqiUDb6vf/Huw9I4P
        I+hMUmr8deHyTftrarXt8r4mfrW7t7pYxj3K/LIJWo1UZv1teYxLYmoDBoETT2qcgjOnYYu+sXIuu
        HIz6R1bLA5CrWf7oifIm4nStlt4F0qTDzOsuZ42ruZaulE0NKzF+qvP3ZebNZicRVrVxeVbU9X9m5
        ZCIvaeE14l1KRXop+ulYhK67WZ4r1M1sIQUeTxvQKcQcUeERbsC7G1aEzq7Hn1BeLXiAiDr+ROU4i
        VKNizAGQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nexou-0004go-T7; Thu, 14 Apr 2022 13:39:28 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] intervals: Simplify element sanity checks
Date:   Thu, 14 Apr 2022 13:39:24 +0200
Message-Id: <20220414113924.15553-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since setelem_delete() assigns to 'prev' pointer only if it doesn't have
EXPR_F_REMOVE flag set, there is no need to check that flag in called
functions.

Fixes: 3e8d934e4f722 ("intervals: support to partial deletion with automerge")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/intervals.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 451bc4dd4dd45..c0077c06880ff 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -265,14 +265,12 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 {
 	struct expr *clone;
 
-	if (!(prev->flags & EXPR_F_REMOVE)) {
-		if (prev->flags & EXPR_F_KERNEL) {
-			clone = expr_clone(prev);
-			list_move_tail(&clone->list, &purge->expressions);
-		} else {
-			list_del(&prev->list);
-			expr_free(prev);
-		}
+	if (prev->flags & EXPR_F_KERNEL) {
+		clone = expr_clone(prev);
+		list_move_tail(&clone->list, &purge->expressions);
+	} else {
+		list_del(&prev->list);
+		expr_free(prev);
 	}
 }
 
@@ -360,18 +358,15 @@ static int setelem_adjust(struct set *set, struct expr *add, struct expr *purge,
 {
 	if (mpz_cmp(prev_range->low, range->low) == 0 &&
 	    mpz_cmp(prev_range->high, range->high) > 0) {
-		if (!(prev->flags & EXPR_F_REMOVE) &&
-		    i->flags & EXPR_F_REMOVE)
+		if (i->flags & EXPR_F_REMOVE)
 			adjust_elem_left(set, prev, i, add, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) == 0) {
-		if (!(prev->flags & EXPR_F_REMOVE) &&
-		    i->flags & EXPR_F_REMOVE)
+		if (i->flags & EXPR_F_REMOVE)
 			adjust_elem_right(set, prev, i, add, purge);
 	} else if (mpz_cmp(prev_range->low, range->low) < 0 &&
 		   mpz_cmp(prev_range->high, range->high) > 0) {
-		if (!(prev->flags & EXPR_F_REMOVE) &&
-		    i->flags & EXPR_F_REMOVE)
+		if (i->flags & EXPR_F_REMOVE)
 			split_range(set, prev, i, add, purge);
 	} else {
 		return -1;
@@ -417,8 +412,7 @@ static int setelem_delete(struct list_head *msgs, struct set *set,
 
 		if (mpz_cmp(prev_range.low, range.low) == 0 &&
 		    mpz_cmp(prev_range.high, range.high) == 0) {
-			if (!(prev->flags & EXPR_F_REMOVE) &&
-			    i->flags & EXPR_F_REMOVE) {
+			if (i->flags & EXPR_F_REMOVE) {
 				list_move_tail(&prev->list, &purge->expressions);
 				list_del(&i->list);
 				expr_free(i);
-- 
2.34.1

