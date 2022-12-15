Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A021C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Dec 2022 20:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiLOUnP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Dec 2022 15:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLOUnO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Dec 2022 15:43:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDB0511DF
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Dec 2022 12:43:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=BfY+KdNECXcaQSuE65h6S7dMxxmvZ892O0EPtCm4HBE=; b=EZvBzIsaTzsrUZTFVHINjvJWod
        PP1jTjKXNEB0nQByl1jvD8hEFzF3NumAhmGjjdqeFY2Hd2SU2yMwSoThiWQd0rFUbt9GMYNIDnKUD
        cWM+cT87p3UJJ+7+N8Fnv/icSdmu6FXOCvF/ujTNXy+o4AcQrtkfXEEpwmMcakk1CcGR1IfF1XpKP
        kXQp+VtnzyQh4u5Zflsiv0CbPsFQ9BHyA4wDKARjjsplJE4Htl0JmMqPE23m5SXxnWqaLzsqzaPHm
        OTg2lzWIooRNJW5z9yytR1HXzWFcS5Tr+5aEQ+mJOExXSs6udeAarnkr45frt1XelOoy1kFd9Jjp/
        P0OTi68g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p5v4R-0004TU-9I; Thu, 15 Dec 2022 21:43:11 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: nf_tables: Introduce NFTA_RULE_ALT_EXPRESSIONS
Date:   Thu, 15 Dec 2022 21:43:02 +0100
Message-Id: <20221215204302.8378-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

With identical content as NFTA_RULE_EXPRESSIONS, data in this attribute
is dumped in place of the live expressions, which in turn are dumped as
NFTA_RULE_ALT_EXPRESSIONS.

This allows for newer user space to provide a rule representation
understood by older user space while still able to verify the rule's
actual expressions applied to packets.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/net/netfilter/nf_tables.h        | 12 ++++++
 include/uapi/linux/netfilter/nf_tables.h |  3 ++
 net/netfilter/nf_tables_api.c            | 47 +++++++++++++++++++++---
 3 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index e69ce23566eab..b08e01d19e835 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -946,10 +946,21 @@ struct nft_expr_ops {
 	void				*data;
 };
 
+/**
+ *	struct nft_alt_expr - nft_tables rule alternate expressions
+ *	@dlen: length of @data
+ *	@data: blob used as payload of NFTA_RULE_EXPRESSIONS attribute
+ */
+struct nft_alt_expr {
+	int	dlen;
+	char	data[];
+};
+
 /**
  *	struct nft_rule - nf_tables rule
  *
  *	@list: used internally
+ *	@alt_expr: Expression blob to dump instead of live data
  *	@handle: rule handle
  *	@genmask: generation mask
  *	@dlen: length of expression data
@@ -958,6 +969,7 @@ struct nft_expr_ops {
  */
 struct nft_rule {
 	struct list_head		list;
+	struct nft_alt_expr		*alt_expr;
 	u64				handle:42,
 					genmask:2,
 					dlen:12,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index cfa844da1ce61..2dff92f527429 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -247,6 +247,8 @@ enum nft_chain_attributes {
  * @NFTA_RULE_USERDATA: user data (NLA_BINARY, NFT_USERDATA_MAXLEN)
  * @NFTA_RULE_ID: uniquely identifies a rule in a transaction (NLA_U32)
  * @NFTA_RULE_POSITION_ID: transaction unique identifier of the previous rule (NLA_U32)
+ * @NFTA_RULE_CHAIN_ID: add the rule to chain by ID, alternative to @NFTA_RULE_CHAIN (NLA_U32)
+ * @NFTA_RULE_ALT_EXPRESSIONS: expressions to swap with @NFTA_RULE_EXPRESSIONS for dumps (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_rule_attributes {
 	NFTA_RULE_UNSPEC,
@@ -261,6 +263,7 @@ enum nft_rule_attributes {
 	NFTA_RULE_ID,
 	NFTA_RULE_POSITION_ID,
 	NFTA_RULE_CHAIN_ID,
+	NFTA_RULE_ALT_EXPRESSIONS,
 	__NFTA_RULE_MAX
 };
 #define NFTA_RULE_MAX		(__NFTA_RULE_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6269b0d9977c6..d9b95a19bb028 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3064,14 +3064,33 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD)
 		nft_flow_rule_stats(chain, rule);
 
-	list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
-	if (list == NULL)
-		goto nla_put_failure;
-	nft_rule_for_each_expr(expr, next, rule) {
-		if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
+	if (rule->alt_expr) {
+		if (nla_put(skb, NFTA_RULE_EXPRESSIONS,
+			    rule->alt_expr->dlen, rule->alt_expr->data) < 0)
+			goto nla_put_failure;
+	} else {
+		list = nla_nest_start_noflag(skb, NFTA_RULE_EXPRESSIONS);
+		if (!list)
 			goto nla_put_failure;
+
+		nft_rule_for_each_expr(expr, next, rule) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, list);
+	}
+
+	if (rule->alt_expr) {
+		list = nla_nest_start_noflag(skb, NFTA_RULE_ALT_EXPRESSIONS);
+		if (!list)
+			goto nla_put_failure;
+
+		nft_rule_for_each_expr(expr, next, rule) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr, reset) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, list);
 	}
-	nla_nest_end(skb, list);
 
 	if (rule->udata) {
 		struct nft_userdata *udata = nft_userdata(rule);
@@ -3366,6 +3385,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 		nf_tables_expr_destroy(ctx, expr);
 		expr = next;
 	}
+	kfree(rule->alt_expr);
 	kfree(rule);
 }
 
@@ -3443,6 +3463,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	struct nft_rule *rule, *old_rule = NULL;
 	struct nft_expr_info *expr_info = NULL;
 	u8 family = info->nfmsg->nfgen_family;
+	struct nft_alt_expr *alt_expr = NULL;
 	struct nft_flow_rule *flow = NULL;
 	struct net *net = info->net;
 	struct nft_userdata *udata;
@@ -3556,6 +3577,19 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	if (size >= 1 << 12)
 		goto err_release_expr;
 
+	if (nla[NFTA_RULE_ALT_EXPRESSIONS]) {
+		int dlen = nla_len(nla[NFTA_RULE_ALT_EXPRESSIONS]);
+
+		alt_expr = kvmalloc(sizeof(*alt_expr) + dlen, GFP_KERNEL);
+		if (!alt_expr) {
+			err = -ENOMEM;
+			goto err_release_expr;
+		}
+		alt_expr->dlen = dlen;
+		nla_memcpy(alt_expr->data,
+			   nla[NFTA_RULE_ALT_EXPRESSIONS], dlen);
+	}
+
 	if (nla[NFTA_RULE_USERDATA]) {
 		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
 		if (ulen > 0)
@@ -3572,6 +3606,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 	rule->handle = handle;
 	rule->dlen   = size;
 	rule->udata  = ulen ? 1 : 0;
+	rule->alt_expr = alt_expr;
 
 	if (ulen) {
 		udata = nft_userdata(rule);
-- 
2.38.0

