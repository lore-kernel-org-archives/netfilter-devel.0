Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70907C433DB
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:43:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08FEE64E42
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 01:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBIBn1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Feb 2021 20:43:27 -0500
Received: from correo.us.es ([193.147.175.20]:52354 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhBIBnS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Feb 2021 20:43:18 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12073D28C0
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 02:42:34 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2BC9DA704
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 02:42:33 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E7906DA72F; Tue,  9 Feb 2021 02:42:33 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B4EA6DA704
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 02:42:31 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 02:42:31 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id A07C6426CC84
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 02:42:31 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nftables: relax check for stateful expressions in set definition
Date:   Tue,  9 Feb 2021 02:42:28 +0100
Message-Id: <20210209014228.20903-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Restore the original behaviour where users are allowed to add an element
with any stateful expression if the set definition specifies no stateful
expressions. Make sure upper maximum number of stateful expressions of
NFT_SET_EXPR_MAX is not reached.

Fixes: 8cfd9b0f8515 ("netfilter: nftables: generalize set expressions support")
Fixes: 48b0ae046ee9 ("netfilter: nftables: netlink support for several set element expressions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: missing check for NFT_SET_EXPR_MAX in NFTA_SET_ELEM_EXPRESSIONS.

 net/netfilter/nf_tables_api.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 43fe80f10313..8ee9f40cc0ea 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5281,6 +5281,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_expr *expr_array[NFT_SET_EXPR_MAX] = {};
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	u8 genmask = nft_genmask_next(ctx->net);
+	u32 flags = 0, size = 0, num_exprs = 0;
 	struct nft_set_ext_tmpl tmpl;
 	struct nft_set_ext *ext, *ext2;
 	struct nft_set_elem elem;
@@ -5290,7 +5291,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
-	u32 flags = 0, size = 0;
 	u64 timeout;
 	u64 expiration;
 	int err, i;
@@ -5356,7 +5356,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_EXPR]) {
 		struct nft_expr *expr;
 
-		if (set->num_exprs != 1)
+		if (set->num_exprs && set->num_exprs != 1)
 			return -EOPNOTSUPP;
 
 		expr = nft_set_elem_expr_alloc(ctx, set,
@@ -5365,8 +5365,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return PTR_ERR(expr);
 
 		expr_array[0] = expr;
+		num_exprs = 1;
 
-		if (set->exprs[0] && set->exprs[0]->ops != expr->ops) {
+		if (set->num_exprs && set->exprs[0]->ops != expr->ops) {
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
@@ -5375,12 +5376,10 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		struct nlattr *tmp;
 		int left;
 
-		if (set->num_exprs == 0)
-			return -EOPNOTSUPP;
-
 		i = 0;
 		nla_for_each_nested(tmp, nla[NFTA_SET_ELEM_EXPRESSIONS], left) {
-			if (i == set->num_exprs) {
+			if (i == NFT_SET_EXPR_MAX ||
+			    (set->num_exprs && set->num_exprs == i)) {
 				err = -E2BIG;
 				goto err_set_elem_expr;
 			}
@@ -5394,14 +5393,15 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				goto err_set_elem_expr;
 			}
 			expr_array[i] = expr;
+			num_exprs++;
 
-			if (expr->ops != set->exprs[i]->ops) {
+			if (set->num_exprs && expr->ops != set->exprs[i]->ops) {
 				err = -EOPNOTSUPP;
 				goto err_set_elem_expr;
 			}
 			i++;
 		}
-		if (set->num_exprs != i) {
+		if (set->num_exprs && set->num_exprs != i) {
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
@@ -5409,6 +5409,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_set_elem_expr_clone(ctx, set, expr_array);
 		if (err < 0)
 			goto err_set_elem_expr_clone;
+
+		num_exprs = set->num_exprs;
 	}
 
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
@@ -5433,8 +5435,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
-	if (set->num_exprs) {
-		for (i = 0; i < set->num_exprs; i++)
+	if (num_exprs) {
+		for (i = 0; i < num_exprs; i++)
 			size += expr_array[i]->ops->size;
 
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
@@ -5522,7 +5524,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	for (i = 0; i < set->num_exprs; i++)
+	for (i = 0; i < num_exprs; i++)
 		nft_set_elem_expr_setup(ext, i, expr_array);
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
@@ -5584,7 +5586,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err_set_elem_expr:
-	for (i = 0; i < set->num_exprs && expr_array[i]; i++)
+	for (i = 0; i < num_exprs && expr_array[i]; i++)
 		nft_expr_destroy(ctx, expr_array[i]);
 err_set_elem_expr_clone:
 	return err;
-- 
2.20.1

