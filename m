Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CDEAC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 14:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232134AbiDMOxG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 10:53:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231720AbiDMOxF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 10:53:05 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4F0262BF4
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2022 07:50:44 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] intervals: remove check for EXPR_F_REMOVE in remove_element()
Date:   Wed, 13 Apr 2022 16:50:41 +0200
Message-Id: <20220413145041.623915-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

setelem_adjust() checks that EXPR_F_REMOVE is unset already for
the previous element.

Suggested-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index cdda9e38ca5e..3f2bb4bca527 100644
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
 
-- 
2.30.2

