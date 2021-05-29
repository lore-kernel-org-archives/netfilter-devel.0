Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8576CC47090
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 22:28:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4929C610FA
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 May 2021 22:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhE2W3x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 May 2021 18:29:53 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50354 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhE2W3x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 May 2021 18:29:53 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 799C96441F
        for <netfilter-devel@vger.kernel.org>; Sun, 30 May 2021 00:27:11 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/3] netfilter: nf_tables: remove nft_ctx_init_from_setattr()
Date:   Sun, 30 May 2021 00:28:07 +0200
Message-Id: <20210529222807.8415-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210529222807.8415-1-pablo@netfilter.org>
References: <20210529222807.8415-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Replace nft_ctx_init_from_setattr() by nft_table_lookup().

This patch also disentangles nf_tables_delset() where NFTA_SET_TABLE is
required while nft_ctx_init_from_setattr() allows it to be optional.

From the nf_tables_delset() path, this also allows to set up the context
structure when it is needed.

Removing this helper function saves us 14 LoC, so it is not helping to
consolidate code.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 64 ++++++++++++++---------------------
 1 file changed, 25 insertions(+), 39 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 33a9222471c6..3e37bec54eb7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3638,30 +3638,6 @@ static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_CONCAT]		= { .type = NLA_NESTED },
 };
 
-static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *net,
-				     const struct sk_buff *skb,
-				     const struct nlmsghdr *nlh,
-				     const struct nlattr * const nla[],
-				     struct netlink_ext_ack *extack,
-				     u8 genmask, u32 nlpid)
-{
-	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
-	int family = nfmsg->nfgen_family;
-	struct nft_table *table = NULL;
-
-	if (nla[NFTA_SET_TABLE] != NULL) {
-		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
-					 genmask, nlpid);
-		if (IS_ERR(table)) {
-			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
-			return PTR_ERR(table);
-		}
-	}
-
-	nft_ctx_init(ctx, net, skb, nlh, family, table, NULL, nla);
-	return 0;
-}
-
 static struct nft_set *nft_set_lookup(const struct nft_table *table,
 				      const struct nlattr *nla, u8 genmask)
 {
@@ -4043,17 +4019,24 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
+	int family = info->nfmsg->nfgen_family;
+	struct nft_table *table = NULL;
 	struct net *net = info->net;
 	const struct nft_set *set;
 	struct sk_buff *skb2;
 	struct nft_ctx ctx;
 	int err;
 
-	/* Verify existence before starting dump */
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
-					genmask, 0);
-	if (err < 0)
-		return err;
+	if (nla[NFTA_SET_TABLE]) {
+		table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
+					 genmask, 0);
+		if (IS_ERR(table)) {
+			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
+			return PTR_ERR(table);
+		}
+	}
+
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -4073,7 +4056,7 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (!nla[NFTA_SET_TABLE])
 		return -EINVAL;
 
-	set = nft_set_lookup(ctx.table, nla[NFTA_SET_NAME], genmask);
+	set = nft_set_lookup(table, nla[NFTA_SET_NAME], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
 
@@ -4466,28 +4449,29 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_next(info->net);
+	int family = info->nfmsg->nfgen_family;
 	struct net *net = info->net;
 	const struct nlattr *attr;
+	struct nft_table *table;
 	struct nft_set *set;
 	struct nft_ctx ctx;
-	int err;
 
 	if (info->nfmsg->nfgen_family == NFPROTO_UNSPEC)
 		return -EAFNOSUPPORT;
-	if (nla[NFTA_SET_TABLE] == NULL)
-		return -EINVAL;
 
-	err = nft_ctx_init_from_setattr(&ctx, net, skb, info->nlh, nla, extack,
-					genmask, NETLINK_CB(skb).portid);
-	if (err < 0)
-		return err;
+	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family,
+				 genmask, NETLINK_CB(skb).portid);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_TABLE]);
+		return PTR_ERR(table);
+	}
 
 	if (nla[NFTA_SET_HANDLE]) {
 		attr = nla[NFTA_SET_HANDLE];
-		set = nft_set_lookup_byhandle(ctx.table, attr, genmask);
+		set = nft_set_lookup_byhandle(table, attr, genmask);
 	} else {
 		attr = nla[NFTA_SET_NAME];
-		set = nft_set_lookup(ctx.table, attr, genmask);
+		set = nft_set_lookup(table, attr, genmask);
 	}
 
 	if (IS_ERR(set)) {
@@ -4501,6 +4485,8 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 		return -EBUSY;
 	}
 
+	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
+
 	return nft_delset(&ctx, set);
 }
 
-- 
2.30.2

