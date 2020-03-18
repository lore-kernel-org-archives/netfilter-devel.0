Return-Path: <SRS0=WbMd=5D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5AE5C10DCE
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 17:45:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7A6720752
	for <netfilter-devel@archiver.kernel.org>; Wed, 18 Mar 2020 17:45:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbgCRRpy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 18 Mar 2020 13:45:54 -0400
Received: from correo.us.es ([193.147.175.20]:40218 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbgCRRpy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Mar 2020 13:45:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EE524C2B05
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 18:45:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE9FBDA3C2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 18:45:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D4470DA8E6; Wed, 18 Mar 2020 18:45:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D380CDA3A4
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 18:45:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 18 Mar 2020 18:45:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BCD2A42EE38E
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2020 18:45:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_tables: add nft_set_elem_expr_destroy() and use it
Date:   Wed, 18 Mar 2020 18:45:44 +0100
Message-Id: <20200318174544.57973-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds nft_set_elem_expr_destroy() to destroy stateful
expressions in set elements.

This patch also updates the commit path to call this function to invoke
expr->ops->destroy_clone when required.

This is implicitly fixing up a module reference counter leak and
a memory leak in expressions that allocated internal state, e.g.
nft_counter.

Fixes: 409444522976 ("netfilter: nf_tables: add elements with stateful expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 29ad33e52dbb..c5332a313283 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4882,6 +4882,17 @@ void *nft_set_elem_init(const struct nft_set *set,
 	return elem;
 }
 
+static void nft_set_elem_expr_destroy(const struct nft_ctx *ctx,
+				      struct nft_expr *expr)
+{
+	if (expr->ops->destroy_clone) {
+		expr->ops->destroy_clone(ctx, expr);
+		module_put(expr->ops->type->owner);
+	} else {
+		nf_tables_expr_destroy(ctx, expr);
+	}
+}
+
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr)
 {
@@ -4894,16 +4905,9 @@ void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 	nft_data_release(nft_set_ext_key(ext), NFT_DATA_VALUE);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		nft_data_release(nft_set_ext_data(ext), set->dtype);
-	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR)) {
-		struct nft_expr *expr = nft_set_ext_expr(ext);
+	if (destroy_expr && nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
+		nft_set_elem_expr_destroy(&ctx, nft_set_ext_expr(ext));
 
-		if (expr->ops->destroy_clone) {
-			expr->ops->destroy_clone(&ctx, expr);
-			module_put(expr->ops->type->owner);
-		} else {
-			nf_tables_expr_destroy(&ctx, expr);
-		}
-	}
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF))
 		(*nft_set_ext_obj(ext))->use--;
 	kfree(elem);
@@ -4919,7 +4923,8 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem);
 
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
-		nf_tables_expr_destroy(ctx, nft_set_ext_expr(ext));
+		nft_set_elem_expr_destroy(ctx, nft_set_ext_expr(ext));
+
 	kfree(elem);
 }
 
@@ -5182,7 +5187,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_trans:
 	if (obj)
 		obj->use--;
-	kfree(elem.priv);
+
+	nf_tables_set_elem_destroy(ctx, set, elem.priv);
 err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&data, desc.type);
-- 
2.11.0

