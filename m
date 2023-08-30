Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E045C83F1D
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Aug 2023 18:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238753AbjH3SjI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243678AbjH3L04 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Aug 2023 07:26:56 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3E3DB132
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Aug 2023 04:26:51 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 1/2] src: use internal_location for unspecified location at allocation time
Date:   Wed, 30 Aug 2023 13:26:46 +0200
Message-Id: <20230830112647.286054-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Set location to internal_location instead of NULL to ensure this is
always set.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/parser_bison.y |  8 ++++----
 src/rule.c         | 21 ++++++++++++++-------
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/src/parser_bison.y b/src/parser_bison.y
index 14aab1933d15..a248b335b01d 100644
--- a/src/parser_bison.y
+++ b/src/parser_bison.y
@@ -2134,7 +2134,7 @@ typeof_expr		:	primary_expr
 
 set_block_alloc		:	/* empty */
 			{
-				$$ = set_alloc(NULL);
+				$$ = set_alloc(&internal_location);
 			}
 			;
 
@@ -2214,7 +2214,7 @@ set_flag		:	CONSTANT	{ $$ = NFT_SET_CONSTANT; }
 
 map_block_alloc		:	/* empty */
 			{
-				$$ = set_alloc(NULL);
+				$$ = set_alloc(&internal_location);
 			}
 			;
 
@@ -2329,7 +2329,7 @@ set_policy_spec		:	PERFORMANCE	{ $$ = NFT_SET_POL_PERFORMANCE; }
 
 flowtable_block_alloc	:	/* empty */
 			{
-				$$ = flowtable_alloc(NULL);
+				$$ = flowtable_alloc(&internal_location);
 			}
 			;
 
@@ -2448,7 +2448,7 @@ data_type_expr		:	data_type_atom_expr
 
 obj_block_alloc		:       /* empty */
 			{
-				$$ = obj_alloc(NULL);
+				$$ = obj_alloc(&internal_location);
 			}
 			;
 
diff --git a/src/rule.c b/src/rule.c
index bbea05d5b288..07b95a993275 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -148,11 +148,12 @@ struct set *set_alloc(const struct location *loc)
 {
 	struct set *set;
 
+	assert(loc);
+
 	set = xzalloc(sizeof(*set));
 	set->refcnt = 1;
 	set->handle.set_id = ++set_id;
-	if (loc != NULL)
-		set->location = *loc;
+	set->location = *loc;
 
 	init_list_head(&set->stmt_list);
 
@@ -163,7 +164,7 @@ struct set *set_clone(const struct set *set)
 {
 	struct set *new_set;
 
-	new_set			= set_alloc(NULL);
+	new_set			= set_alloc(&internal_location);
 	handle_merge(&new_set->handle, &set->handle);
 	new_set->flags		= set->flags;
 	new_set->gc_int		= set->gc_int;
@@ -455,6 +456,8 @@ struct rule *rule_alloc(const struct location *loc, const struct handle *h)
 {
 	struct rule *rule;
 
+	assert(loc);
+
 	rule = xzalloc(sizeof(*rule));
 	rule->location = *loc;
 	init_list_head(&rule->list);
@@ -1300,6 +1303,8 @@ struct cmd *cmd_alloc(enum cmd_ops op, enum cmd_obj obj,
 {
 	struct cmd *cmd;
 
+	assert(loc);
+
 	cmd = xzalloc(sizeof(*cmd));
 	init_list_head(&cmd->list);
 	cmd->op       = op;
@@ -1614,9 +1619,10 @@ struct obj *obj_alloc(const struct location *loc)
 {
 	struct obj *obj;
 
+	assert(loc);
+
 	obj = xzalloc(sizeof(*obj));
-	if (loc != NULL)
-		obj->location = *loc;
+	obj->location = *loc;
 
 	obj->refcnt = 1;
 	return obj;
@@ -2025,9 +2031,10 @@ struct flowtable *flowtable_alloc(const struct location *loc)
 {
 	struct flowtable *flowtable;
 
+	assert(loc);
+
 	flowtable = xzalloc(sizeof(*flowtable));
-	if (loc != NULL)
-		flowtable->location = *loc;
+	flowtable->location = *loc;
 
 	flowtable->refcnt = 1;
 	return flowtable;
-- 
2.30.2

