Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73E49C7EE22
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:31:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbjEEPbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjEEPbu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:31:50 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECDF818FD6
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:35 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 01/12] netfilter: nf_tables: add nft_expr_info_setup() helper function
Date:   Fri,  5 May 2023 17:31:19 +0200
Message-Id: <20230505153130.2385-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add helper function to allocate and set up nft_expr_info structure,
which contains the expression array.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 90 ++++++++++++++++++++++++-----------
 1 file changed, 61 insertions(+), 29 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 09542951656c..bbdf22646745 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -386,6 +386,60 @@ static void nft_rule_expr_deactivate(const struct nft_ctx *ctx,
 	}
 }
 
+struct nft_expr_info {
+	const struct nft_expr_ops	*ops;
+	const struct nlattr		*attr;
+	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
+};
+
+static int nf_tables_expr_parse(const struct nft_ctx *ctx,
+				const struct nlattr *nla,
+				struct nft_expr_info *info);
+
+#define NFT_RULE_MAXEXPRS	128
+
+static struct nft_expr_info *
+nft_expr_info_setup(struct nft_ctx *ctx, const struct nlattr *nla,
+		    unsigned int *psize, unsigned int *pnum,
+		    struct netlink_ext_ack *extack)
+{
+	struct nft_expr_info *expr_info;
+	unsigned int n = 0, size = 0;
+	struct nlattr *tmp;
+	int err, rem;
+
+	expr_info = kvmalloc_array(NFT_RULE_MAXEXPRS,
+				   sizeof(struct nft_expr_info), GFP_KERNEL);
+	if (!expr_info)
+		return ERR_PTR(-ENOMEM);
+
+	nla_for_each_nested(tmp, nla, rem) {
+		err = -EINVAL;
+		if (nla_type(tmp) != NFTA_LIST_ELEM)
+			goto err_release_expr;
+
+		if (n == NFT_RULE_MAXEXPRS)
+			goto err_release_expr;
+
+		err = nf_tables_expr_parse(ctx, tmp, &expr_info[n]);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, tmp);
+			goto err_release_expr;
+		}
+		size += expr_info[n].ops->size;
+		n++;
+	}
+	*psize = size;
+	*pnum = n;
+
+	return expr_info;
+
+err_release_expr:
+	kvfree(expr_info);
+
+	return ERR_PTR(err);
+}
+
 static int
 nf_tables_delrule_deactivate(struct nft_ctx *ctx, struct nft_rule *rule)
 {
@@ -2932,12 +2986,6 @@ int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 	return -1;
 }
 
-struct nft_expr_info {
-	const struct nft_expr_ops	*ops;
-	const struct nlattr		*attr;
-	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
-};
-
 static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 				const struct nlattr *nla,
 				struct nft_expr_info *info)
@@ -3624,8 +3672,6 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nft_chain *chain,
 					     const struct nlattr *nla);
 
-#define NFT_RULE_MAXEXPRS	128
-
 static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 			     const struct nlattr * const nla[])
 {
@@ -3645,8 +3691,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	u64 handle, pos_handle;
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
-	struct nlattr *tmp;
-	int err, rem;
+	int err;
 
 	lockdep_assert_held(&nft_net->commit_mutex);
 
@@ -3723,25 +3768,12 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	n = 0;
 	size = 0;
 	if (nla[NFTA_RULE_EXPRESSIONS]) {
-		expr_info = kvmalloc_array(NFT_RULE_MAXEXPRS,
-					   sizeof(struct nft_expr_info),
-					   GFP_KERNEL);
-		if (!expr_info)
-			return -ENOMEM;
-
-		nla_for_each_nested(tmp, nla[NFTA_RULE_EXPRESSIONS], rem) {
-			err = -EINVAL;
-			if (nla_type(tmp) != NFTA_LIST_ELEM)
-				goto err_release_expr;
-			if (n == NFT_RULE_MAXEXPRS)
-				goto err_release_expr;
-			err = nf_tables_expr_parse(&ctx, tmp, &expr_info[n]);
-			if (err < 0) {
-				NL_SET_BAD_ATTR(extack, tmp);
-				goto err_release_expr;
-			}
-			size += expr_info[n].ops->size;
-			n++;
+		expr_info = nft_expr_info_setup(&ctx,
+						nla[NFTA_RULE_EXPRESSIONS],
+						&size, &n, extack);
+		if (IS_ERR(expr_info)) {
+			err = PTR_ERR(expr_info);
+			goto err_release_expr;
 		}
 	}
 	/* Check for overflow of dlen field */
-- 
2.30.2

