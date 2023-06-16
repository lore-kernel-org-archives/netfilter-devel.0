Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDC6DEB64D7
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Jun 2023 15:56:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbjFPP4Y (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Jun 2023 11:56:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjFPP4X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Jun 2023 11:56:23 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 240DD297E
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Jun 2023 08:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=bdKiYaZNHB5LW/KrCDMRV4ZsK7S/rvMHt9QR7Kgyp9Y=; b=pwz1PaT5QglImGYIQwDZOJaHMU
        5c42ce75zbduIsrg4kefX1RuvVG1jd9WeFD3hnlxCVtlSGGcS4LzwnkHTpuwqbgvJ6wJ34NcgWOLE
        4TdGvHiZN27JMa7YsogvU3usvhCHss1WjBhQ5FjytzXc4rj40UaQka0B6p63Yf3D9RM3aFWPNhDlK
        j/wwxKFPOn+a83aDMaAQ2vOPV4tDKhCRo+lpwaTnjq0MdDBlVEcvh6YRo0uQaO3GBpDITrm2wGd2g
        tdcgmV7nhd3LkI6RuKnsqpNP/LrMONDKFgRPgfnzYBJbo0ZKdTFG5zc6GoazC+vEFVbnvjUGidBtn
        BcbVCEAg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qABoC-0004IR-3Y; Fri, 16 Jun 2023 17:56:20 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf PATCH] netfilter: nf_tables: Fix for deleting base chains with payload
Date:   Fri, 16 Jun 2023 17:56:11 +0200
Message-Id: <20230616155611.2468-1-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When deleting a base chain, iptables-nft simply submits the whole chain
to the kernel, including the NFTA_CHAIN_HOOK attribute. The new code
added by fixed commit then turned this into a chain update, destroying
the hook but not the chain itself.

Detect the situation by checking if the chain's hook list becomes empty
after removing all submitted hooks from it. A base chain without hooks
is pointless, so revert back to deleting the chain.

Note the 'goto err_chain_del_hook', error path takes care of undoing the
hook_list modification and releasing the unused chain_hook.

Fixes: 7d937b107108f ("netfilter: nf_tables: support for deleting devices in an existing netdev chain")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 477c39358da7d..9666c8e891fa7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2699,6 +2699,11 @@ static int nft_delchain_hook(struct nft_ctx *ctx, struct nft_chain *chain,
 		list_move(&hook->list, &chain_del_list);
 	}
 
+	if (list_empty(&basechain->hook_list)) {
+		err = nft_delchain(ctx);
+		goto err_chain_del_hook;
+	}
+
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELCHAIN,
 				sizeof(struct nft_trans_chain));
 	if (!trans) {
-- 
2.40.0

