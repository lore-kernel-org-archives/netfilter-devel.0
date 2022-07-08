Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 578B2C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 10:06:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiGHKGi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 06:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiGHKGi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 06:06:38 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 643F883F27
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 03:06:37 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 1/2] netfilter: nf_tables: release element key when parser fails
Date:   Fri,  8 Jul 2022 12:06:32 +0200
Message-Id: <20220708100633.18896-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nft_data_release() to release the element keys otherwise this
might leak chain reference counter.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Fixes: ba0e4d9917b4 ("netfilter: nf_tables: get set elements via netlink")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: coalesce two similar patches:
    https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220708084453.11066-1-pablo@netfilter.org/
    https://patchwork.ozlabs.org/project/netfilter-devel/patch/20220708085805.12310-1-pablo@netfilter.org/

 net/netfilter/nf_tables_api.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d6b59beab3a9..9b6711e2f193 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5306,17 +5306,17 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto err_parse_key;
 	}
 
 	err = nft_setelem_get(ctx, set, &elem, flags);
 	if (err < 0)
-		return err;
+		goto err_parse_key_end;
 
 	err = -ENOMEM;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (skb == NULL)
-		return err;
+		goto err_parse_key_end;
 
 	err = nf_tables_fill_setelem_info(skb, ctx, ctx->seq, ctx->portid,
 					  NFT_MSG_NEWSETELEM, 0, set, &elem);
@@ -5327,6 +5327,11 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 err_fill_setelem:
 	kfree_skb(skb);
+err_parse_key:
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
+err_parse_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
+
 	return err;
 }
 
@@ -6272,7 +6277,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto fail_elem;
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
 	}
@@ -6281,8 +6286,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
 				      elem.key_end.val.data, NULL, 0, 0,
 				      GFP_KERNEL_ACCOUNT);
-	if (elem.priv == NULL)
-		goto fail_elem;
+	if (elem.priv == NULL) {
+		err = PTR_ERR(elem.priv);
+		goto fail_elem_key_end;
+	}
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -6306,8 +6313,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(trans);
 fail_trans:
 	kfree(elem.priv);
+fail_elem_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
 fail_elem:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
+
 	return err;
 }
 
-- 
2.30.2

