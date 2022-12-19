Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F5AC4332F
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Dec 2022 19:29:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232599AbiLST3W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Dec 2022 14:29:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232757AbiLST2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2022 14:28:51 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2647F1581F
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2022 11:28:50 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de
Subject: [PATCH nf,v2 3/4] netfilter: nf_tables: perform type checking for existing sets
Date:   Mon, 19 Dec 2022 20:28:43 +0100
Message-Id: <20221219192844.212253-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221219192844.212253-1-pablo@netfilter.org>
References: <20221219192844.212253-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If a ruleset declares a set name that matches an existing set in the
kernel, then validate that this declaration really refers to the same
set, otherwise bail out with EEXIST.

Currently, the kernel reports success when adding a set that already
exists in the kernel. This usually results in EINVAL errors at a later
stage, when the user adds elements to the set, if the set declaration
mismatches the existing set representation in the kernel.

Add a new function to check that the set declaration really refers to
the same existing set in the kernel.

Fixes: 96518518cc41 ("netfilter: add nftables")
Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - rebased on top new initial preparation patches
    - perform more type checks

 net/netfilter/nf_tables_api.c | 36 ++++++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67ce89695afb..b8cbfd3bf472 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4442,6 +4442,34 @@ static int nft_set_expr_alloc(struct nft_ctx *ctx, struct nft_set *set,
 	return err;
 }
 
+static bool nft_set_is_same(const struct nft_set *set,
+			    const struct nft_set_desc *desc,
+			    struct nft_expr *exprs[], u32 num_exprs, u32 flags)
+{
+	int i;
+
+	if (set->ktype != desc->ktype ||
+	    set->dtype != desc->dtype ||
+	    set->flags != flags ||
+	    set->klen != desc->klen ||
+	    set->dlen != desc->dlen ||
+	    set->field_count != desc->field_count ||
+	    set->num_exprs != num_exprs)
+		return false;
+
+	for (i = 0; i < desc->field_count; i++) {
+		if (set->field_len[i] != desc->field_len[i])
+			return false;
+	}
+
+	for (i = 0; i < num_exprs; i++) {
+		if (set->exprs[i]->ops != exprs[i]->ops)
+			return false;
+	}
+
+	return true;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -4596,10 +4624,16 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		err = 0;
+		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
+			err = -EEXIST;
+		}
+
 		for (i = 0; i < num_exprs; i++)
 			nft_expr_destroy(&ctx, exprs[i]);
 
-		return 0;
+		return err;
 	}
 
 	if (!(info->nlh->nlmsg_flags & NLM_F_CREATE))
-- 
2.30.2

