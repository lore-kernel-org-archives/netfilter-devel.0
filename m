Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1490CEB64DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 09:36:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbjFTJgC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 05:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232383AbjFTJfy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 05:35:54 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFA5110E4;
        Tue, 20 Jun 2023 02:35:53 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 05/14] netfilter: nft_set_pipapo: .walk does not deal with generations
Date:   Tue, 20 Jun 2023 11:35:33 +0200
Message-Id: <20230620093542.69232-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230620093542.69232-1-pablo@netfilter.org>
References: <20230620093542.69232-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The .walk callback iterates over the current active set, but it might be
useful to iterate over the next generation set. Use the generation mask
to determine what set view (either current or next generation) is use
for the walk iteration.

Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_set_pipapo.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c867b5b772e8..0452ee586c1c 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1974,12 +1974,16 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			    struct nft_set_iter *iter)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
+	struct net *net = read_pnet(&set->net);
 	struct nft_pipapo_match *m;
 	struct nft_pipapo_field *f;
 	int i, r;
 
 	rcu_read_lock();
-	m = rcu_dereference(priv->match);
+	if (iter->genmask == nft_genmask_cur(net))
+		m = rcu_dereference(priv->match);
+	else
+		m = priv->clone;
 
 	if (unlikely(!m))
 		goto out;
-- 
2.30.2

