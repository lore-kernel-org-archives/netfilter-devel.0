Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25AD4C77B7F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 13:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233619AbjEPNYh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 09:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233612AbjEPNYg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 09:24:36 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AE0F40D9
        for <netfilter-devel@vger.kernel.org>; Tue, 16 May 2023 06:24:23 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pyuf6-0001vB-7K; Tue, 16 May 2023 15:24:20 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: nf_tables: disable delset and delsetelem on anonymous sets
Date:   Tue, 16 May 2023 15:24:14 +0200
Message-Id: <20230516132414.16245-1-fw@strlen.de>
X-Mailer: git-send-email 2.39.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables doesn't need this because anonymous sets are always released
implicitly when the owning rule is deleted.

nftables will also never remove elements from anonymous sets.

We've had bad interaction of anon sets with the rule deletion, e.g.
ability to schedule element removal from an anon set after rule deletion
already deleted that set.

Disable support for this until a use-case shows up, this should
not result in any user-visible breakage even though this removes
an existing feature.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables-nft and nftables test cases pass with this applied.

 net/netfilter/nf_tables_api.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0396fd8f4e71..02c3f912db88 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4996,6 +4996,11 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 		set = nft_set_lookup(table, attr, genmask);
 	}
 
+	if (set->flags & NFT_SET_ANONYMOUS) {
+		NL_SET_BAD_ATTR(extack, attr);
+		return -EBUSY;
+	}
+
 	if (IS_ERR(set)) {
 		if (PTR_ERR(set) == -ENOENT &&
 		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSET)
@@ -6888,6 +6893,12 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 	set = nft_set_lookup(table, nla[NFTA_SET_ELEM_LIST_SET], genmask);
 	if (IS_ERR(set))
 		return PTR_ERR(set);
+
+	if (set->flags & NFT_SET_ANONYMOUS) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_SET_ELEM_LIST_SET]);
+		return -EROFS;
+	}
+
 	if (!list_empty(&set->bindings) && set->flags & NFT_SET_CONSTANT)
 		return -EBUSY;
 
-- 
2.39.3

