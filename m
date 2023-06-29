Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17045C001B1
	for <netfilter-devel@archiver.kernel.org>; Thu, 29 Jun 2023 19:02:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233144AbjF2TCP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 29 Jun 2023 15:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbjF2TBa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 29 Jun 2023 15:01:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95901359C;
        Thu, 29 Jun 2023 12:01:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ABB5615D8;
        Thu, 29 Jun 2023 19:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599A2C43391;
        Thu, 29 Jun 2023 19:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688065286;
        bh=eTtWHXgR4AnHVEzXQX7p9ra2/DOZ1yEDcQZ1L4ry2H4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QyKCW/Oog7pZTvJUDhvVV8Rdjt7RnnGAGOQG4sFDkkRwP5Y5Yn6jnFbUADaLfNYyw
         6gCsurUivqi4gVNQ6r7Ki05d5InGrkFDa9NZTMv6r26k5FE7Q7fQL7XnkSRjvzMmxo
         N9OoQEq61x2Lo/Nmn2m48anzIf6K/vLG3mSytJ3kCHReEU14B+XeodOQQxnHKp8p5i
         uocV7aiTbLGUVSWEwmusSGRHRNdroWKfNDw1iPF2K77zL0HdSA0KElfNA+O4MO/VTO
         WLrSWTTnZxPQH5HY75QQIzVMeTOwi4wcz/tW2D+qm1F4Bon3KL3iNmRZK2W893yvx3
         a8sMPvuxQDuzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>, kadlec@netfilter.org,
        fw@strlen.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.3 14/17] netfilter: nf_tables: drop module reference after updating chain
Date:   Thu, 29 Jun 2023 15:00:43 -0400
Message-Id: <20230629190049.907558-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230629190049.907558-1-sashal@kernel.org>
References: <20230629190049.907558-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.3.9
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 043d2acf57227db1fdaaa620b2a420acfaa56d6e ]

Otherwise the module reference counter is leaked.

Fixes b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 26ab687ac9ab0..9ff16b710eb66 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2525,6 +2525,8 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	nft_trans_basechain(trans) = basechain;
 	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
 	list_splice(&hook.list, &nft_trans_chain_hooks(trans));
+	if (nla[NFTA_CHAIN_HOOK])
+		module_put(hook.type->owner);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
-- 
2.39.2

