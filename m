Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30D9BC07E8A
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Aug 2023 22:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240303AbjHOWaz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 18:30:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240301AbjHOWa0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 18:30:26 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AD81FEE;
        Tue, 15 Aug 2023 15:30:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1qW2YP-0004Zh-T9; Wed, 16 Aug 2023 00:30:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>
Subject: [PATCH net 1/9] netfilter: nf_tables: fix false-positive lockdep splat
Date:   Wed, 16 Aug 2023 00:29:51 +0200
Message-ID: <20230815223011.7019-2-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230815223011.7019-1-fw@strlen.de>
References: <20230815223011.7019-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

->abort invocation may cause splat on debug kernels:

WARNING: suspicious RCU usage
net/netfilter/nft_set_pipapo.c:1697 suspicious rcu_dereference_check() usage!
[..]
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/133554: [..] (nft_net->commit_mutex){+.+.}-{3:3}, at: nf_tables_valid_genid
[..]
 lockdep_rcu_suspicious+0x1ad/0x260
 nft_pipapo_abort+0x145/0x180
 __nf_tables_abort+0x5359/0x63d0
 nf_tables_abort+0x24/0x40
 nfnetlink_rcv+0x1a0a/0x22c0
 netlink_unicast+0x73c/0x900
 netlink_sendmsg+0x7f0/0xc20
 ____sys_sendmsg+0x48d/0x760

Transaction mutex is held, so parallel updates are not possible.
Switch to _protected and check mutex is held for lockdep enabled builds.

Fixes: 212ed75dc5fb ("netfilter: nf_tables: integrate pipapo into commit protocol")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_set_pipapo.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index a5b8301afe4a..5fa12cfc7b84 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1697,6 +1697,17 @@ static void nft_pipapo_commit(const struct nft_set *set)
 	priv->clone = new_clone;
 }
 
+static bool nft_pipapo_transaction_mutex_held(const struct nft_set *set)
+{
+#ifdef CONFIG_PROVE_LOCKING
+	const struct net *net = read_pnet(&set->net);
+
+	return lockdep_is_held(&nft_pernet(net)->commit_mutex);
+#else
+	return true;
+#endif
+}
+
 static void nft_pipapo_abort(const struct nft_set *set)
 {
 	struct nft_pipapo *priv = nft_set_priv(set);
@@ -1705,7 +1716,7 @@ static void nft_pipapo_abort(const struct nft_set *set)
 	if (!priv->dirty)
 		return;
 
-	m = rcu_dereference(priv->match);
+	m = rcu_dereference_protected(priv->match, nft_pipapo_transaction_mutex_held(set));
 
 	new_clone = pipapo_clone(m);
 	if (IS_ERR(new_clone))
-- 
2.41.0

