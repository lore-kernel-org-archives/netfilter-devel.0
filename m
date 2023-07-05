Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B150EB64DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jul 2023 16:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjGEQyq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jul 2023 12:54:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231660AbjGEQyl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jul 2023 12:54:41 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2B9F1198A;
        Wed,  5 Jul 2023 09:54:34 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     sashal@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 02/10] netfilter: nftables: add helper function to set the base sequence number
Date:   Wed,  5 Jul 2023 18:54:15 +0200
Message-Id: <20230705165423.50054-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230705165423.50054-1-pablo@netfilter.org>
References: <20230705165423.50054-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ 802b805162a1b7d8391c40ac8a878e9e63287aff ]

This patch adds a helper function to calculate the base sequence number
field that is stored in the nfnetlink header. Use the helper function
whenever possible.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index dfa1820ed032..323537fb869e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -588,6 +588,11 @@ nf_tables_chain_type_lookup(struct net *net, const struct nlattr *nla,
 	return ERR_PTR(-ENOENT);
 }
 
+static __be16 nft_base_seq(const struct net *net)
+{
+	return htons(net->nft.base_seq & 0xffff);
+}
+
 static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
 	[NFTA_TABLE_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_TABLE_MAXNAMELEN - 1 },
@@ -610,7 +615,7 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_TABLE_NAME, table->name) ||
 	    nla_put_be32(skb, NFTA_TABLE_FLAGS, htonl(table->flags)) ||
@@ -1274,7 +1279,7 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_CHAIN_TABLE, table->name))
 		goto nla_put_failure;
@@ -2366,7 +2371,7 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_RULE_TABLE, table->name))
 		goto nla_put_failure;
@@ -3325,7 +3330,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -4180,7 +4185,7 @@ static int nf_tables_dump_set(struct sk_buff *skb, struct netlink_callback *cb)
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family = table->family;
 	nfmsg->version      = NFNETLINK_V0;
-	nfmsg->res_id	    = htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id	    = nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_SET_ELEM_LIST_TABLE, table->name))
 		goto nla_put_failure;
@@ -4252,7 +4257,7 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= ctx->family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(ctx->net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(ctx->net);
 
 	if (nla_put_string(skb, NFTA_SET_TABLE, ctx->table->name))
 		goto nla_put_failure;
@@ -5383,7 +5388,7 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_OBJ_TABLE, table->name) ||
 	    nla_put_string(skb, NFTA_OBJ_NAME, obj->key.name) ||
@@ -6059,7 +6064,7 @@ static int nf_tables_fill_flowtable_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= family;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_string(skb, NFTA_FLOWTABLE_TABLE, flowtable->table->name) ||
 	    nla_put_string(skb, NFTA_FLOWTABLE_NAME, flowtable->name) ||
@@ -6297,7 +6302,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	nfmsg = nlmsg_data(nlh);
 	nfmsg->nfgen_family	= AF_UNSPEC;
 	nfmsg->version		= NFNETLINK_V0;
-	nfmsg->res_id		= htons(net->nft.base_seq & 0xffff);
+	nfmsg->res_id		= nft_base_seq(net);
 
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(net->nft.base_seq)) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
-- 
2.30.2

