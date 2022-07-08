Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA5BCCA47B
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 08:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbiGHI6N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 04:58:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiGHI6K (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 04:58:10 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DE87C83F12
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 01:58:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf] netfilter: nf_tables: release key_end if element deletion fails
Date:   Fri,  8 Jul 2022 10:58:05 +0200
Message-Id: <20220708085805.12310-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Call nft_data_release() to release the element keys otherwise this
might leak chain reference counter.

Fixes: 7b225d0b5c6d ("netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 04dc6a349759..769e0b60434d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6344,7 +6344,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
 					    nla[NFTA_SET_ELEM_KEY_END]);
 		if (err < 0)
-			return err;
+			goto fail_elem;
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
 	}
@@ -6354,7 +6354,7 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 				      GFP_KERNEL_ACCOUNT);
 	if (IS_ERR(elem.priv)) {
 		err = PTR_ERR(elem.priv);
-		goto fail_elem;
+		goto fail_elem_key_end;
 	}
 
 	ext = nft_set_elem_ext(set, elem.priv);
@@ -6379,8 +6379,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
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

