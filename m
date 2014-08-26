From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf_tables PATCH v2 1/5] netfilter: nf_tables: refactor rule
 deletion helper
Date: Tue, 26 Aug 2014 16:12:22 +0200
Message-ID: <20140826141152.3008.30259.stgit@nfdev.cica.es>
References: <20140826140908.3008.13225.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:48368 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758478AbaHZOMd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Aug 2014 10:12:33 -0400
In-Reply-To: <20140826140908.3008.13225.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This helper function always schedule the rule to be removed in the following
transaction.
In follow-up patches, it is interesting to handle separately the logic of rule
activation/disactivation from the transaction mechanism.

So, this patch simply splits the original nf_tables_delrule_one() in two
functions, allowing further control.

While at it, for the sake of homigeneize the function naming scheme, let's
rename nf_tables_delrule_one() to nft_delrule().

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: no changes, resending the series.

 net/netfilter/nf_tables_api.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index deeb95f..d1535d8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1868,12 +1868,10 @@ err1:
 }
 
 static int
-nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
+nf_tables_delrule_disactivate(struct nft_ctx *ctx, struct nft_rule *rule)
 {
 	/* You cannot delete the same rule twice */
 	if (nft_rule_is_active_next(ctx->net, rule)) {
-		if (nft_trans_rule_add(ctx, NFT_MSG_DELRULE, rule) == NULL)
-			return -ENOMEM;
 		nft_rule_disactivate_next(ctx->net, rule);
 		ctx->chain->use--;
 		return 0;
@@ -1881,13 +1879,31 @@ nf_tables_delrule_one(struct nft_ctx *ctx, struct nft_rule *rule)
 	return -ENOENT;
 }
 
+static int nft_delrule(struct nft_ctx *ctx, struct nft_rule *rule)
+{
+	struct nft_trans *trans;
+	int err;
+
+	trans = nft_trans_rule_add(ctx, NFT_MSG_DELRULE, rule);
+	if (trans == NULL)
+		return -ENOMEM;
+
+	err = nf_tables_delrule_disactivate(ctx, rule);
+	if (err < 0) {
+		nft_trans_destroy(trans);
+		return err;
+	}
+
+	return 0;
+}
+
 static int nf_table_delrule_by_chain(struct nft_ctx *ctx)
 {
 	struct nft_rule *rule;
 	int err;
 
 	list_for_each_entry(rule, &ctx->chain->rules, list) {
-		err = nf_tables_delrule_one(ctx, rule);
+		err = nft_delrule(ctx, rule);
 		if (err < 0)
 			return err;
 	}
@@ -1932,7 +1948,7 @@ static int nf_tables_delrule(struct sock *nlsk, struct sk_buff *skb,
 			if (IS_ERR(rule))
 				return PTR_ERR(rule);
 
-			err = nf_tables_delrule_one(&ctx, rule);
+			err = nft_delrule(&ctx, rule);
 		} else {
 			err = nf_table_delrule_by_chain(&ctx);
 		}

