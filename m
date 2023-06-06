Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CE1C7EE43
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Jun 2023 22:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240151AbjFFW7F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Jun 2023 18:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240138AbjFFW7D (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2023 18:59:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B8441731;
        Tue,  6 Jun 2023 15:58:58 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 2/5] netfilter: nft_bitwise: fix register tracking
Date:   Wed,  7 Jun 2023 00:58:48 +0200
Message-Id: <20230606225851.67394-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230606225851.67394-1-pablo@netfilter.org>
References: <20230606225851.67394-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jeremy Sowden <jeremy@azazel.net>

At the end of `nft_bitwise_reduce`, there is a loop which is intended to
update the bitwise expression associated with each tracked destination
register.  However, currently, it just updates the first register
repeatedly.  Fix it.

Fixes: 34cc9e52884a ("netfilter: nf_tables: cancel tracking for clobbered destination registers")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_bitwise.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index 84eae7cabc67..2527a01486ef 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -323,7 +323,7 @@ static bool nft_bitwise_reduce(struct nft_regs_track *track,
 	dreg = priv->dreg;
 	regcount = DIV_ROUND_UP(priv->len, NFT_REG32_SIZE);
 	for (i = 0; i < regcount; i++, dreg++)
-		track->regs[priv->dreg].bitwise = expr;
+		track->regs[dreg].bitwise = expr;
 
 	return false;
 }
-- 
2.30.2

