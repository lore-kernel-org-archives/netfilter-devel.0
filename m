Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF7CCCA47A
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Jun 2022 09:04:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiFPJEz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Jun 2022 05:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376480AbiFPJEx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Jun 2022 05:04:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16F1633EBD
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Jun 2022 02:04:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft 1/2] intervals: do not empty cache for maps
Date:   Thu, 16 Jun 2022 11:04:45 +0200
Message-Id: <20220616090446.275985-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Translate set element to range and sort in maps for the NFT_SET_MAP
case, which does not support for automerge yet.

Fixes: 81e36530fcac ("src: replace interval segment tree overlap and automerge")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 89f5c33d7a6e..e20341320da2 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -216,6 +216,12 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	struct cmd *purge_cmd;
 	struct handle h = {};
 
+	if (set->flags & NFT_SET_MAP) {
+		set_to_range(init);
+		list_expr_sort(&init->expressions);
+		return 0;
+	}
+
 	if (existing_set) {
 		if (existing_set->init) {
 			list_splice_init(&existing_set->init->expressions,
@@ -229,9 +235,6 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 	set_to_range(init);
 	list_expr_sort(&init->expressions);
 
-	if (set->flags & NFT_SET_MAP)
-		return 0;
-
 	ctx.purge = set_expr_alloc(&internal_location, set);
 
 	setelem_automerge(&ctx);
-- 
2.30.2

