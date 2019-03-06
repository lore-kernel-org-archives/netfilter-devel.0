Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30351C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 01:09:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0141720684
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 01:09:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfCFBJr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 5 Mar 2019 20:09:47 -0500
Received: from mail.us.es ([193.147.175.20]:54662 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727701AbfCFBJr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 5 Mar 2019 20:09:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 033FB508CE3
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 02:09:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E05CDDA86A
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 02:09:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D556FDA864; Wed,  6 Mar 2019 02:09:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EF73DA797;
        Wed,  6 Mar 2019 02:09:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Mar 2019 02:09:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D466B4265A2F;
        Wed,  6 Mar 2019 02:09:41 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, vaclav.zindulka@tlapnet.cz
Subject: [PATCH nft 1/2] segtree: remove dummy debug_octx
Date:   Wed,  6 Mar 2019 02:09:37 +0100
Message-Id: <20190306010938.23687-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixes a crash with --debug=segtree.

Fixes: 35f6cd327c2e ("src: Pass stateless, numeric, ip2name and handle variables as structure members.")
Reported-by: Václav Zindulka <vaclav.zindulka@tlapnet.cz>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/expression.h | 3 ++-
 src/rule.c           | 9 ++++++---
 src/segtree.c        | 6 ++----
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index b681b67f96f4..6d72f64c4fea 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -455,7 +455,8 @@ extern struct expr *set_expr_alloc(const struct location *loc,
 				   const struct set *set);
 extern int set_to_intervals(struct list_head *msgs, struct set *set,
 			    struct expr *init, bool add,
-			    unsigned int debug_mask, bool merge);
+			    unsigned int debug_mask, bool merge,
+			    struct output_ctx *octx);
 extern void interval_map_decompose(struct expr *set);
 
 extern struct expr *get_set_intervals(const struct set *set,
diff --git a/src/rule.c b/src/rule.c
index a3b2dbdb98a3..dc75c7cd5fb0 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -1445,7 +1445,8 @@ static int do_add_setelems(struct netlink_ctx *ctx, struct cmd *cmd,
 
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, init, true,
-			     ctx->nft->debug_mask, set->automerge) < 0)
+			     ctx->nft->debug_mask, set->automerge,
+			     &ctx->nft->output) < 0)
 		return -1;
 
 	return __do_add_setelems(ctx, set, init, flags);
@@ -1459,7 +1460,8 @@ static int do_add_set(struct netlink_ctx *ctx, const struct cmd *cmd,
 	if (set->init != NULL) {
 		if (set->flags & NFT_SET_INTERVAL &&
 		    set_to_intervals(ctx->msgs, set, set->init, true,
-				     ctx->nft->debug_mask, set->automerge) < 0)
+				     ctx->nft->debug_mask, set->automerge,
+				     &ctx->nft->output) < 0)
 			return -1;
 	}
 	if (mnl_nft_set_add(ctx, cmd, flags) < 0)
@@ -1556,7 +1558,8 @@ static int do_delete_setelems(struct netlink_ctx *ctx, struct cmd *cmd)
 
 	if (set->flags & NFT_SET_INTERVAL &&
 	    set_to_intervals(ctx->msgs, set, expr, false,
-			     ctx->nft->debug_mask, set->automerge) < 0)
+			     ctx->nft->debug_mask, set->automerge,
+			     &ctx->nft->output) < 0)
 		return -1;
 
 	if (mnl_nft_setelem_del(ctx, cmd) < 0)
diff --git a/src/segtree.c b/src/segtree.c
index e5dfd413ef83..ecf564e5fa07 100644
--- a/src/segtree.c
+++ b/src/segtree.c
@@ -67,8 +67,6 @@ struct elementary_interval {
 	struct expr			*expr;
 };
 
-static struct output_ctx debug_octx = {};
-
 static void seg_tree_init(struct seg_tree *tree, const struct set *set,
 			  struct expr *init, unsigned int debug_mask)
 {
@@ -567,7 +565,7 @@ static void set_insert_interval(struct expr *set, struct seg_tree *tree,
 
 int set_to_intervals(struct list_head *errs, struct set *set,
 		     struct expr *init, bool add, unsigned int debug_mask,
-		     bool merge)
+		     bool merge, struct output_ctx *octx)
 {
 	struct elementary_interval *ei, *next;
 	struct seg_tree tree;
@@ -590,7 +588,7 @@ int set_to_intervals(struct list_head *errs, struct set *set,
 	}
 
 	if (segtree_debug(tree.debug_mask)) {
-		expr_print(init, &debug_octx);
+		expr_print(init, octx);
 		pr_gmp_debug("\n");
 	}
 
-- 
2.11.0

