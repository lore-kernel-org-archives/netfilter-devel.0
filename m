Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF585C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 20 Feb 2022 11:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235101AbiBTLTW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 20 Feb 2022 06:19:22 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiBTLTW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 20 Feb 2022 06:19:22 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243145AF5
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Feb 2022 03:19:00 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nLkF0-0002Z4-B7; Sun, 20 Feb 2022 12:18:58 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH v2 nf] netfilter: nf_tables: fix memory leak during stateful obj update
Date:   Sun, 20 Feb 2022 12:18:50 +0100
Message-Id: <20220220111850.87378-1-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

stateful objects can be updated from the control plane.
The transaction logic allocates a temporary object for this purpose.

This object has to be released via nft_obj_destroy, not kfree, since
the ->init function was called and it can have side effects beyond
memory allocation.

Unlike normal NEWOBJ path, the objects module refcount isn't
incremented, so add nft_newobj_destroy and use that.

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v2: can't use nft_obj_destroy, module refcount is not incremented.

 net/netfilter/nf_tables_api.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5fa16990da95..56208e778982 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6909,6 +6909,15 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
+/* nf_tables_updobj does not increment module refcount */
+static void nft_newobj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
+{
+	if (obj->ops->destroy)
+		obj->ops->destroy(ctx, obj);
+
+	kfree(obj);
+}
+
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
 {
 	if (obj->ops->destroy)
@@ -8185,7 +8194,7 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	if (obj->ops->update)
 		obj->ops->update(obj, newobj);
 
-	kfree(newobj);
+	nft_newobj_destroy(&trans->ctx, newobj);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
@@ -8976,7 +8985,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				kfree(nft_trans_obj_newobj(trans));
+				nft_newobj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;
-- 
2.35.1

