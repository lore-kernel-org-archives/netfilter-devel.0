Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64F08C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 May 2022 17:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241170AbiE3RCe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 May 2022 13:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235187AbiE3RCe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 May 2022 13:02:34 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5566E5EBC7
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2022 10:02:33 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft] intervals: fix compilation --with-mini-gmp
Date:   Mon, 30 May 2022 19:02:30 +0200
Message-Id: <20220530170230.183230-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use pr_gmp_debug() instead to compile with minigmp.

intervals.c: In function ‘set_delete’:
intervals.c:489:25: warning: implicit declaration of function ‘gmp_printf’; did you mean ‘gmp_vfprintf’? [-Wimplicit-function-declaration]
  489 |                         gmp_printf("remove: [%Zx-%Zx]\n",
      |                         ^~~~~~~~~~
      |                         gmp_vfprintf

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/intervals.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/src/intervals.c b/src/intervals.c
index e61adc769c41..bc414d6c8797 100644
--- a/src/intervals.c
+++ b/src/intervals.c
@@ -486,14 +486,14 @@ int set_delete(struct list_head *msgs, struct cmd *cmd, struct set *set,
 
 	if (debug_mask & NFT_DEBUG_SEGTREE) {
 		list_for_each_entry(i, &init->expressions, list)
-			gmp_printf("remove: [%Zx-%Zx]\n",
-				   i->key->left->value, i->key->right->value);
+			pr_gmp_debug("remove: [%Zx-%Zx]\n",
+				     i->key->left->value, i->key->right->value);
 		list_for_each_entry(i, &add->expressions, list)
-			gmp_printf("add: [%Zx-%Zx]\n",
-				   i->key->left->value, i->key->right->value);
+			pr_gmp_debug("add: [%Zx-%Zx]\n",
+				     i->key->left->value, i->key->right->value);
 		list_for_each_entry(i, &existing_set->init->expressions, list)
-			gmp_printf("existing: [%Zx-%Zx]\n",
-				   i->key->left->value, i->key->right->value);
+			pr_gmp_debug("existing: [%Zx-%Zx]\n",
+				     i->key->left->value, i->key->right->value);
 	}
 
 	if (list_empty(&add->expressions)) {
-- 
2.30.2

