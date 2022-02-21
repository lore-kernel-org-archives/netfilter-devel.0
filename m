Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67493C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 12:31:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358001AbiBUMcU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 07:32:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357974AbiBUMcT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 07:32:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28308DFCE
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 04:31:56 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nM7r7-0000f2-MR; Mon, 21 Feb 2022 13:31:53 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH v3] netfilter: nf_tables: fix memory leak during stateful obj update
Date:   Mon, 21 Feb 2022 13:31:49 +0100
Message-Id: <20220221123149.11519-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

stateful objects can be updated from the control plane.
The transaction logic allocates a temporary object for this purpose.

The ->init function was called for this object, so plain kfree() leaks
resources. We must call ->destroy function of the object.

nft_obj_destroy does this, but it also decrements the module refcount,
but the update path doesn't increment it.

To avoid special-casing the update object release, do module_get for
the update case too and release it via nft_obj_destroy().

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 v3: increment module refcount -> no need for special release function.

 net/netfilter/nf_tables_api.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3081c4399f10..49060f281342 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6553,10 +6553,13 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 	struct nft_trans *trans;
 	int err;
 
+	if (!try_module_get(type->owner))
+		return -ENOENT;
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
 				sizeof(struct nft_trans_obj));
 	if (!trans)
-		return -ENOMEM;
+		goto err_trans;
 
 	newobj = nft_obj_init(ctx, type, attr);
 	if (IS_ERR(newobj)) {
@@ -6573,6 +6576,8 @@ static int nf_tables_updobj(const struct nft_ctx *ctx,
 
 err_free_trans:
 	kfree(trans);
+err_trans:
+	module_put(type->owner);
 	return err;
 }
 
@@ -8185,7 +8190,7 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	if (obj->ops->update)
 		obj->ops->update(obj, newobj);
 
-	kfree(newobj);
+	nft_obj_destroy(&trans->ctx, newobj);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
@@ -8976,7 +8981,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				kfree(nft_trans_obj_newobj(trans));
+				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans));
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;
-- 
2.34.1

