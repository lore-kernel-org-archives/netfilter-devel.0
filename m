Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5985DEB64DC
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Jun 2023 10:18:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjFUKST (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Jun 2023 06:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbjFUKRx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Jun 2023 06:17:53 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 978B0268C;
        Wed, 21 Jun 2023 03:17:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 06/14] netfilter: nf_tables: fix underflow in object reference counter
Date:   Wed, 21 Jun 2023 12:07:23 +0200
Message-Id: <20230621100731.68068-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230621100731.68068-1-pablo@netfilter.org>
References: <20230621100731.68068-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since ("netfilter: nf_tables: drop map element references from
preparation phase"), integration with commit protocol is better,
therefore drop the workaround that b91d90368837 ("netfilter: nf_tables:
fix leaking object reference count") provides.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index e2493f83c48e..cf10b3bd5c0f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6668,19 +6668,19 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (flags)
 		*nft_set_ext_flags(ext) = flags;
 
+	if (obj) {
+		*nft_set_ext_obj(ext) = obj;
+		obj->use++;
+	}
 	if (ulen > 0) {
 		if (nft_set_ext_check(&tmpl, NFT_SET_EXT_USERDATA, ulen) < 0) {
 			err = -EINVAL;
-			goto err_elem_userdata;
+			goto err_elem_free;
 		}
 		udata = nft_set_ext_userdata(ext);
 		udata->len = ulen - 1;
 		nla_memcpy(&udata->data, nla[NFTA_SET_ELEM_USERDATA], ulen);
 	}
-	if (obj) {
-		*nft_set_ext_obj(ext) = obj;
-		obj->use++;
-	}
 	err = nft_set_elem_expr_setup(ctx, &tmpl, ext, expr_array, num_exprs);
 	if (err < 0)
 		goto err_elem_free;
@@ -6735,9 +6735,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_element_clash:
 	kfree(trans);
 err_elem_free:
-	if (obj)
-		obj->use--;
-err_elem_userdata:
 	nft_set_elem_destroy(set, elem.priv, true);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-- 
2.30.2

