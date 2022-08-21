Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC7CAC28D13
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Aug 2022 15:54:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiHUPyJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Aug 2022 11:54:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbiHUPyJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Aug 2022 11:54:09 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BB80314D3F
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Aug 2022 08:54:08 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 3/3] netfilter: nft_tunnel: restrict it to netdev family
Date:   Sun, 21 Aug 2022 17:54:01 +0200
Message-Id: <20220821155401.197971-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220821155401.197971-1-pablo@netfilter.org>
References: <20220821155401.197971-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Only allow to use this expression from NFPROTO_NETDEV family.

Fixes: af308b94a2a4 ("netfilter: nf_tables: add tunnel support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nft_tunnel.c b/net/netfilter/nft_tunnel.c
index 5edaaded706d..983ade4be3b3 100644
--- a/net/netfilter/nft_tunnel.c
+++ b/net/netfilter/nft_tunnel.c
@@ -161,6 +161,7 @@ static const struct nft_expr_ops nft_tunnel_get_ops = {
 
 static struct nft_expr_type nft_tunnel_type __read_mostly = {
 	.name		= "tunnel",
+	.family		= NFPROTO_NETDEV,
 	.ops		= &nft_tunnel_get_ops,
 	.policy		= nft_tunnel_policy,
 	.maxattr	= NFTA_TUNNEL_MAX,
-- 
2.30.2

