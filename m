Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C14C433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Feb 2022 11:06:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiBULHS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Feb 2022 06:07:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355925AbiBULGH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Feb 2022 06:06:07 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AC3CB37031
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Feb 2022 02:34:06 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 61B266021B;
        Mon, 21 Feb 2022 11:33:08 +0100 (CET)
Date:   Mon, 21 Feb 2022 11:34:01 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: Re: [PATCH v2 nf] netfilter: nf_tables: fix memory leak during
 stateful obj update
Message-ID: <YhNqmSBAt2IRbYx6@salvia>
References: <20220220111850.87378-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pANdPOM7e9+z0cre"
Content-Disposition: inline
In-Reply-To: <20220220111850.87378-1-fw@strlen.de>
User-Agent: Alpine 2.23 (DEB 453 2020-06-18)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--pANdPOM7e9+z0cre
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Florian,

On Sun, Feb 20, 2022 at 12:18:50PM +0100, Florian Westphal wrote:
> stateful objects can be updated from the control plane.
> The transaction logic allocates a temporary object for this purpose.
> 
> This object has to be released via nft_obj_destroy, not kfree, since
> the ->init function was called and it can have side effects beyond
> memory allocation.
> 
> Unlike normal NEWOBJ path, the objects module refcount isn't
> incremented, so add nft_newobj_destroy and use that.

Probably this? .udata and .key is NULL for the update path so kfree
should be fine.

--pANdPOM7e9+z0cre
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment;
	filename="0001-netfilter-nf_tables-fix-memory-leak-during-stateful-.patch"

From 909c4c67deadbc674fcadd081c32c0781eb8e26f Mon Sep 17 00:00:00 2001
From: Florian Westphal <fw@strlen.de>
Date: Sun, 20 Feb 2022 12:18:50 +0100
Subject: [PATCH] netfilter: nf_tables: fix memory leak during stateful obj
 update

stateful objects can be updated from the control plane.
The transaction logic allocates a temporary object for this purpose.

This object has to be released via nft_obj_destroy, not kfree, since
the ->init function was called and it can have side effects beyond
memory allocation.

Unlike normal NEWOBJ path, the objects module refcount isn't
incremented, so extend nft_obj_destroy to specify if this is an update.

Fixes: d62d0ba97b58 ("netfilter: nf_tables: Introduce stateful object update operation")
Cc: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3081c4399f10..7982268d0001 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6909,12 +6909,16 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
+static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj,
+			    bool update)
 {
 	if (obj->ops->destroy)
 		obj->ops->destroy(ctx, obj);
 
-	module_put(obj->ops->type->owner);
+	/* nf_tables_updobj does not increment module refcount */
+	if (!update)
+		module_put(obj->ops->type->owner);
+
 	kfree(obj->key.name);
 	kfree(obj->udata);
 	kfree(obj);
@@ -8185,7 +8189,7 @@ static void nft_obj_commit_update(struct nft_trans *trans)
 	if (obj->ops->update)
 		obj->ops->update(obj, newobj);
 
-	kfree(newobj);
+	nft_obj_destroy(&trans->ctx, newobj, true);
 }
 
 static void nft_commit_release(struct nft_trans *trans)
@@ -8213,7 +8217,7 @@ static void nft_commit_release(struct nft_trans *trans)
 					   nft_trans_elem(trans).priv);
 		break;
 	case NFT_MSG_DELOBJ:
-		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
+		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans), false);
 		break;
 	case NFT_MSG_DELFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
@@ -8853,7 +8857,7 @@ static void nf_tables_abort_release(struct nft_trans *trans)
 				     nft_trans_elem(trans).priv, true);
 		break;
 	case NFT_MSG_NEWOBJ:
-		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans));
+		nft_obj_destroy(&trans->ctx, nft_trans_obj(trans), false);
 		break;
 	case NFT_MSG_NEWFLOWTABLE:
 		if (nft_trans_flowtable_update(trans))
@@ -8976,7 +8980,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWOBJ:
 			if (nft_trans_obj_update(trans)) {
-				kfree(nft_trans_obj_newobj(trans));
+				nft_obj_destroy(&trans->ctx, nft_trans_obj_newobj(trans), true);
 				nft_trans_destroy(trans);
 			} else {
 				trans->ctx.table->use--;
@@ -9693,7 +9697,7 @@ static void __nft_release_table(struct net *net, struct nft_table *table)
 	list_for_each_entry_safe(obj, ne, &table->objects, list) {
 		nft_obj_del(obj);
 		table->use--;
-		nft_obj_destroy(&ctx, obj);
+		nft_obj_destroy(&ctx, obj, false);
 	}
 	list_for_each_entry_safe(chain, nc, &table->chains, list) {
 		ctx.chain = chain;
-- 
2.30.2


--pANdPOM7e9+z0cre--
