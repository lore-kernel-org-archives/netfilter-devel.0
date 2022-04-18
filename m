Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C53C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Apr 2022 14:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiDROmn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Apr 2022 10:42:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236155AbiDROm3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Apr 2022 10:42:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78633C33
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Apr 2022 06:26:40 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] intervals: set on EXPR_F_KERNEL flag for new elements in set cache
Date:   Mon, 18 Apr 2022 15:26:36 +0200
Message-Id: <20220418132636.982994-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

So follow up command in this batch that update the set assume this
element is already in the kernel.

Fixes: 3da9643fb9ff ("intervals: add support to automerge with kernel elements")
Fixes: 3ed9fadaab95 ("intervals: build list of elements to be added from cache")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/intervals.c b/src/intervals.c
index 584c69d5189b..a74238525d8d 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -244,6 +244,7 @@ int set_automerge(struct list_head *msgs, struct cmd *cmd, struct set *set,
 					     i->key->left->value, i->key->right->value);
 			}
 			clone = expr_clone(i);
+			clone->flags |= EXPR_F_KERNEL;
 			list_add_tail(&clone->list, &existing_set->init->expressions);
 		}
 	}
@@ -481,6 +482,7 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 		if (!(i->flags & EXPR_F_KERNEL)) {
 			clone = expr_clone(i);
 			list_add_tail(&clone->list, &add->expressions);
+			i->flags |= EXPR_F_KERNEL;
 		}
 	}
 
@@ -609,6 +611,7 @@ int set_overlap(struct list_head *msgs, struct set *set, struct expr *init)
 			list_move_tail(&i->list, &existing_set->init->expressions);
 		else if (existing_set) {
 			clone = expr_clone(i);
+			clone->flags |= EXPR_F_KERNEL;
 			list_add_tail(&clone->list, &existing_set->init->expressions);
 		}
 	}
-- 
2.30.2

