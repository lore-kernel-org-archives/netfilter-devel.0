Return-Path: <SRS0=fe67=44=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCF1DC3F2C6
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:30:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E370C204EC
	for <netfilter-devel@archiver.kernel.org>; Wed, 11 Mar 2020 14:30:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729824AbgCKOaY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 11 Mar 2020 10:30:24 -0400
Received: from correo.us.es ([193.147.175.20]:41052 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729309AbgCKOaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 11 Mar 2020 10:30:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6053C04A4
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 96DB4DA390
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:30:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8C91ADA3A9; Wed, 11 Mar 2020 15:30:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB1BADA3A1
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:29:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Mar 2020 15:29:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A90C442EF42B
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Mar 2020 15:29:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 1/5] netfilter: nf_tables: add nft_set_elem_expr_alloc()
Date:   Wed, 11 Mar 2020 15:30:12 +0100
Message-Id: <20200311143016.4414-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200311143016.4414-1-pablo@netfilter.org>
References: <20200311143016.4414-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to create stateful expression.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 30 ++++++++++++++++++++++++++++++
 net/netfilter/nft_dynset.c        | 15 ++-------------
 3 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4170c033d461..da2b8ff9f066 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -673,6 +673,10 @@ static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_OBJREF);
 }
 
+struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
+					 const struct nft_set *set,
+					 const struct nlattr *attr);
+
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end, const u32 *data,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 38c680f28f15..a9f4169c8610 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4801,6 +4801,36 @@ static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
 	return trans;
 }
 
+struct nft_expr *nft_set_elem_expr_alloc(const struct nft_ctx *ctx,
+					 const struct nft_set *set,
+					 const struct nlattr *attr)
+{
+	struct nft_expr *expr;
+	int err;
+
+	expr = nft_expr_init(ctx, attr);
+	if (IS_ERR(expr))
+		return expr;
+
+	err = -EOPNOTSUPP;
+	if (!(expr->ops->type->flags & NFT_EXPR_STATEFUL))
+		goto err_set_elem_expr;
+
+	if (expr->ops->type->flags & NFT_EXPR_GC) {
+		if (set->flags & NFT_SET_TIMEOUT)
+			goto err_set_elem_expr;
+		if (!set->ops->gc_init)
+			goto err_set_elem_expr;
+		set->ops->gc_init(set);
+	}
+
+	return expr;
+
+err_set_elem_expr:
+	nft_expr_destroy(ctx, expr);
+	return ERR_PTR(err);
+}
+
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
 			const u32 *key, const u32 *key_end,
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 683785225a3e..e106cf1c5b8b 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -206,21 +206,10 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (!(set->flags & NFT_SET_EVAL))
 			return -EINVAL;
 
-		priv->expr = nft_expr_init(ctx, tb[NFTA_DYNSET_EXPR]);
+		priv->expr = nft_set_elem_expr_alloc(ctx, set,
+						     tb[NFTA_DYNSET_EXPR]);
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
-
-		err = -EOPNOTSUPP;
-		if (!(priv->expr->ops->type->flags & NFT_EXPR_STATEFUL))
-			goto err1;
-
-		if (priv->expr->ops->type->flags & NFT_EXPR_GC) {
-			if (set->flags & NFT_SET_TIMEOUT)
-				goto err1;
-			if (!set->ops->gc_init)
-				goto err1;
-			set->ops->gc_init(set);
-		}
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
-- 
2.11.0

