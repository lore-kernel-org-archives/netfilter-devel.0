Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89AD8C433B4
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:30:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F219610CC
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Apr 2021 19:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhDJTad (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Apr 2021 15:30:33 -0400
Received: from mail.netfilter.org ([217.70.188.207]:44996 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234439AbhDJTac (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Apr 2021 15:30:32 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id F1EDE62C0E;
        Sat, 10 Apr 2021 21:29:53 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     nevola@gmail.com
Subject: [PATCH nf,v3] netfilter: nftables: clone set element expression template
Date:   Sat, 10 Apr 2021 21:30:13 +0200
Message-Id: <20210410193013.18629-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

memcpy() breaks when using connlimit in set elements. Use
nft_expr_clone() to initialize the connlimit expression list, otherwise
connlimit garbage collector crashes when walking on the list head copy.

[  493.064656] Workqueue: events_power_efficient nft_rhash_gc [nf_tables]
[  493.064685] RIP: 0010:find_or_evict+0x5a/0x90 [nf_conncount]
[  493.064694] Code: 2b 43 40 83 f8 01 77 0d 48 c7 c0 f5 ff ff ff 44 39 63 3c 75 df 83 6d 18 01 48 8b 43 08 48 89 de 48 8b 13 48 8b 3d ee 2f 00 00 <48> 89 42 08 48 89 10 48 b8 00 01 00 00 00 00 ad de 48 89 03 48 83
[  493.064699] RSP: 0018:ffffc90000417dc0 EFLAGS: 00010297
[  493.064704] RAX: 0000000000000000 RBX: ffff888134f38410 RCX: 0000000000000000
[  493.064708] RDX: 0000000000000000 RSI: ffff888134f38410 RDI: ffff888100060cc0
[  493.064711] RBP: ffff88812ce594a8 R08: ffff888134f38438 R09: 00000000ebb9025c
[  493.064714] R10: ffffffff8219f838 R11: 0000000000000017 R12: 0000000000000001
[  493.064718] R13: ffffffff82146740 R14: ffff888134f38410 R15: 0000000000000000
[  493.064721] FS:  0000000000000000(0000) GS:ffff88840e440000(0000) knlGS:0000000000000000
[  493.064725] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  493.064729] CR2: 0000000000000008 CR3: 00000001330aa002 CR4: 00000000001706e0
[  493.064733] Call Trace:
[  493.064737]  nf_conncount_gc_list+0x8f/0x150 [nf_conncount]
[  493.064746]  nft_rhash_gc+0x106/0x390 [nf_tables]

Reported-by: Laura Garcia Liebana <nevola@gmail.com>
Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: fix expr_array[] leak in error path

 net/netfilter/nf_tables_api.c | 42 ++++++++++++++++++++++++++---------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f57f1a6ba96f..81da339b39a3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5295,16 +5295,35 @@ int nft_set_elem_expr_clone(const struct nft_ctx *ctx, struct nft_set *set,
 	return -ENOMEM;
 }
 
-static void nft_set_elem_expr_setup(const struct nft_set_ext *ext, int i,
-				    struct nft_expr *expr_array[])
+static int nft_set_elem_expr_setup(struct nft_ctx *ctx,
+				   const struct nft_set_ext *ext,
+				   struct nft_expr *expr_array[],
+				   u32 num_exprs)
 {
 	struct nft_set_elem_expr *elem_expr = nft_set_ext_expr(ext);
-	struct nft_expr *expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+	struct nft_expr *expr;
+	int i, err;
+
+	for (i = 0; i < num_exprs; i++) {
+		expr = nft_setelem_expr_at(elem_expr, elem_expr->size);
+		err = nft_expr_clone(expr, expr_array[i]);
+		if (err < 0)
+			goto err_elem_expr_setup;
+
+		elem_expr->size += expr_array[i]->ops->size;
+		nft_expr_destroy(ctx, expr_array[i]);
+		expr_array[i] = NULL;
+	}
+
+	return 0;
 
-	memcpy(expr, expr_array[i], expr_array[i]->ops->size);
-	elem_expr->size += expr_array[i]->ops->size;
-	kfree(expr_array[i]);
-	expr_array[i] = NULL;
+err_elem_expr_setup:
+	for (; i < num_exprs; i++) {
+		nft_expr_destroy(ctx, expr_array[i]);
+		expr_array[i] = NULL;
+	}
+
+	return -ENOMEM;
 }
 
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
@@ -5556,12 +5575,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	for (i = 0; i < num_exprs; i++)
-		nft_set_elem_expr_setup(ext, i, expr_array);
+	err = nft_set_elem_expr_setup(ctx, ext, expr_array, num_exprs);
+	if (err < 0)
+		goto err_elem_expr;
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
-		goto err_trans;
+		goto err_elem_expr;
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -5605,7 +5625,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	set->ops->remove(ctx->net, set, &elem);
 err_element_clash:
 	kfree(trans);
-err_trans:
+err_elem_expr:
 	if (obj)
 		obj->use--;
 
-- 
2.20.1

