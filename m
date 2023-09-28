Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB380E732DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 14:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbjI1Oto (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 10:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbjI1Otn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 10:49:43 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9866419E;
        Thu, 28 Sep 2023 07:49:41 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qlsKf-0005VN-5n; Thu, 28 Sep 2023 16:49:37 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH net-next 4/4] netfilter: nf_tables: Utilize NLA_POLICY_NESTED_ARRAY
Date:   Thu, 28 Sep 2023 16:49:01 +0200
Message-ID: <20230928144916.18339-5-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928144916.18339-1-fw@strlen.de>
References: <20230928144916.18339-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Phil Sutter <phil@nwl.cc>

Mark attributes which are supposed to be arrays of nested attributes
with known content as such. Originally suggested for
NFTA_RULE_EXPRESSIONS only, but does apply to others as well.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f993c237afd0..7e2e76086d25 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3316,7 +3316,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
-	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
+	[NFTA_RULE_EXPRESSIONS]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 	[NFTA_RULE_POSITION]	= { .type = NLA_U64 },
 	[NFTA_RULE_USERDATA]	= { .type = NLA_BINARY,
@@ -4254,12 +4254,16 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
-	[NFTA_SET_EXPRESSIONS]		= { .type = NLA_NESTED },
+	[NFTA_SET_EXPRESSIONS]		= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
+};
+
+static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
+	[NFTA_SET_FIELD_LEN]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_SIZE]		= { .type = NLA_U32 },
-	[NFTA_SET_DESC_CONCAT]		= { .type = NLA_NESTED },
+	[NFTA_SET_DESC_CONCAT]		= NLA_POLICY_NESTED_ARRAY(nft_concat_policy),
 };
 
 static struct nft_set *nft_set_lookup(const struct nft_table *table,
@@ -4715,10 +4719,6 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
-	[NFTA_SET_FIELD_LEN]	= { .type = NLA_U32 },
-};
-
 static int nft_set_desc_concat_parse(const struct nlattr *attr,
 				     struct nft_set_desc *desc)
 {
@@ -5500,7 +5500,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
 					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
-	[NFTA_SET_ELEM_EXPRESSIONS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_EXPRESSIONS]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -5508,7 +5508,7 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 					    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
 					    .len = NFT_SET_MAXNAMELEN - 1 },
-	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_LIST_ELEMENTS]	= NLA_POLICY_NESTED_ARRAY(nft_set_elem_policy),
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
 
-- 
2.41.0

