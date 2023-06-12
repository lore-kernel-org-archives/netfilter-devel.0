Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E707DC7EE37
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Jun 2023 13:14:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjFLNOT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Jun 2023 09:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjFLNOR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2023 09:14:17 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CDDC3DB
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Jun 2023 06:14:15 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 5/7] netfilter: nf_tables: disallow updates of anonymous sets
Date:   Mon, 12 Jun 2023 15:14:07 +0200
Message-Id: <20230612131409.63157-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230612131409.63157-1-pablo@netfilter.org>
References: <20230612131409.63157-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Disallow updates of set timeout and garbage collection parameters for
anonymous sets.

Fixes: 123b99619cca ("netfilter: nf_tables: honor set timeout and garbage collection updates")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a4f1a9f3d6d4..e8865a85b7d6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4890,6 +4890,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (info->nlh->nlmsg_flags & NLM_F_REPLACE)
 			return -EOPNOTSUPP;
 
+		if (nft_set_is_anonymous(set))
+			return -EOPNOTSUPP;
+
 		err = nft_set_expr_alloc(&ctx, set, nla, exprs, &num_exprs, flags);
 		if (err < 0)
 			return err;
-- 
2.30.2

