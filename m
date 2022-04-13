Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C24B1C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Apr 2022 13:42:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235886AbiDMNo7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Apr 2022 09:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235890AbiDMNo4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Apr 2022 09:44:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 11BDC6006F
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Apr 2022 06:42:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     phil@nwl.cc
Subject: [PATCH nft] intervals: unset EXPR_F_KERNEL for adjusted elements
Date:   Wed, 13 Apr 2022 15:42:30 +0200
Message-Id: <20220413134230.488620-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This element is adjusted, hence it is new and it is purged from the
kernel.

The existing list of elements in the kernel is spliced to the elements
to be removed, then merge-sorted. EXPR_F_REMOVE flag specifies that this
element represents a deletion.

The EXPR_F_REMOVE and EXPR_F_KERNEL allows to track objects: whether
element is in the kernel (EXPR_F_KERNEL), element is new (no flag) or
element represents a removal (EXPR_F_REMOVE).

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index 451bc4dd4dd4..cdda9e38ca5e 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -279,7 +279,7 @@ static void remove_elem(struct expr *prev, struct set *set, struct expr *purge)
 static void __adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 			       struct expr *add)
 {
-	prev->flags &= EXPR_F_KERNEL;
+	prev->flags &= ~EXPR_F_KERNEL;
 	expr_free(prev->key->left);
 	prev->key->left = expr_get(i->key->right);
 	mpz_add_ui(prev->key->left->value, prev->key->left->value, 1);
@@ -304,7 +304,7 @@ static void adjust_elem_left(struct set *set, struct expr *prev, struct expr *i,
 static void __adjust_elem_right(struct set *set, struct expr *prev, struct expr *i,
 				struct expr *add)
 {
-	prev->flags &= EXPR_F_KERNEL;
+	prev->flags &= ~EXPR_F_KERNEL;
 	expr_free(prev->key->right);
 	prev->key->right = expr_get(i->key->left);
 	mpz_sub_ui(prev->key->right->value, prev->key->right->value, 1);
@@ -334,7 +334,7 @@ static void split_range(struct set *set, struct expr *prev, struct expr *i,
 	clone = expr_clone(prev);
 	list_move_tail(&clone->list, &purge->expressions);
 
-	prev->flags &= EXPR_F_KERNEL;
+	prev->flags &= ~EXPR_F_KERNEL;
 	clone = expr_clone(prev);
 	expr_free(clone->key->left);
 	clone->key->left = expr_get(i->key->right);
-- 
2.30.2

