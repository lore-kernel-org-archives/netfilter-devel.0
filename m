Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37274CA0FE1
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 Sep 2023 12:08:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbjIAMId (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 Sep 2023 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349339AbjIAMId (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 Sep 2023 08:08:33 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37C7FCFE
        for <netfilter-devel@vger.kernel.org>; Fri,  1 Sep 2023 05:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8a957dLhudpVPVFwE8vA+yNGjq5+CtW7MsUeJHSSnyw=; b=O1U68SJAZOrRzsB11IyeM2kNWP
        d6vk2WhGkdtqEGTZujFWpgthf0fyFOLmpNfUSka144i5rXbw2e6I5yFnxnzvTIBDhNJSVHopAFfCI
        +9KwE65cPSKV+Sm+lV6NRY6egu/WV08PD5wpM3cea+l8qgSYXGXDu1uDgM61uWNbUnSb2shQ0Gqmk
        h7h6Gb7ifkBZ/q1IDg3/Sq3OpLcbKKg6qjlKWCOy7p4xFYxhXugPAVFP6/wHx2i2SQEjip8u2sLCs
        WuxPyJOScqyNwYVaZSIbybNZ8MroYWfeyIgbx6uarZidyCR+eGy4hHio4+GOyAaQNEgRW/kEF5zFo
        KHtrujzg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qc2ws-00011t-JE; Fri, 01 Sep 2023 14:08:26 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf-next PATCH] netfilter: nf_tables: Utilize NLA_POLICY_NESTED_ARRAY
Date:   Fri,  1 Sep 2023 14:16:15 +0200
Message-ID: <20230901121615.30432-1-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mark attributes which are supposed to be arrays of nested attributes
with known content as such. Originally suggested for
NFTA_RULE_EXPRESSIONS only, but does apply to others as well.

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 41b826dff6f5c..1e21acb295098 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3309,7 +3309,7 @@ static const struct nla_policy nft_rule_policy[NFTA_RULE_MAX + 1] = {
 	[NFTA_RULE_CHAIN]	= { .type = NLA_STRING,
 				    .len = NFT_CHAIN_MAXNAMELEN - 1 },
 	[NFTA_RULE_HANDLE]	= { .type = NLA_U64 },
-	[NFTA_RULE_EXPRESSIONS]	= { .type = NLA_NESTED },
+	[NFTA_RULE_EXPRESSIONS]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
 	[NFTA_RULE_COMPAT]	= { .type = NLA_NESTED },
 	[NFTA_RULE_POSITION]	= { .type = NLA_U64 },
 	[NFTA_RULE_USERDATA]	= { .type = NLA_BINARY,
@@ -4219,12 +4219,16 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
-	[NFTA_SET_EXPRESSIONS]		= { .type = NLA_NESTED },
+	[NFTA_SET_EXPRESSIONS]	= NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
+};
+
+static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
+	[NFTA_SET_FIELD_LEN]	= { .type = NLA_U32 },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
 	[NFTA_SET_DESC_SIZE]		= { .type = NLA_U32 },
-	[NFTA_SET_DESC_CONCAT]		= { .type = NLA_NESTED },
+	[NFTA_SET_DESC_CONCAT]	= NLA_POLICY_NESTED_ARRAY(nft_concat_policy),
 };
 
 static struct nft_set *nft_set_lookup(const struct nft_table *table,
@@ -4678,10 +4682,6 @@ static int nf_tables_getset(struct sk_buff *skb, const struct nfnl_info *info,
 	return err;
 }
 
-static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1] = {
-	[NFTA_SET_FIELD_LEN]	= { .type = NLA_U32 },
-};
-
 static int nft_set_desc_concat_parse(const struct nlattr *attr,
 				     struct nft_set_desc *desc)
 {
@@ -5463,7 +5463,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
 					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
-	[NFTA_SET_ELEM_EXPRESSIONS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_EXPRESSIONS] = NLA_POLICY_NESTED_ARRAY(nft_expr_policy),
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -5471,7 +5471,8 @@ static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX +
 					    .len = NFT_TABLE_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_LIST_SET]	= { .type = NLA_STRING,
 					    .len = NFT_SET_MAXNAMELEN - 1 },
-	[NFTA_SET_ELEM_LIST_ELEMENTS]	= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_LIST_ELEMENTS] =
+		NLA_POLICY_NESTED_ARRAY(nft_set_elem_policy),
 	[NFTA_SET_ELEM_LIST_SET_ID]	= { .type = NLA_U32 },
 };
 
-- 
2.41.0

