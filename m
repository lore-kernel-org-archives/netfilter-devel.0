Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B21F0C64990
	for <netfilter-devel@archiver.kernel.org>; Wed, 24 Aug 2022 22:03:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240790AbiHXWDv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 24 Aug 2022 18:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240793AbiHXWDs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 24 Aug 2022 18:03:48 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 863C976954;
        Wed, 24 Aug 2022 15:03:47 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 04/14] netfilter: nf_tables: disallow updates of implicit chain
Date:   Thu, 25 Aug 2022 00:03:20 +0200
Message-Id: <20220824220330.64283-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220824220330.64283-1-pablo@netfilter.org>
References: <20220824220330.64283-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Updates on existing implicit chain make no sense, disallow this.

Fixes: d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 62cfb0e31c40..dff2b5851bbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2574,6 +2574,9 @@ static int nf_tables_newchain(struct sk_buff *skb, const struct nfnl_info *info,
 	nft_ctx_init(&ctx, net, skb, info->nlh, family, table, chain, nla);
 
 	if (chain != NULL) {
+		if (chain->flags & NFT_CHAIN_BINDING)
+			return -EINVAL;
+
 		if (info->nlh->nlmsg_flags & NLM_F_EXCL) {
 			NL_SET_BAD_ATTR(extack, attr);
 			return -EEXIST;
-- 
2.30.2

