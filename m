Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8756F3A1E7F;
	Fri,  1 May 2026 12:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777638175; cv=none; b=f86s9bncWY4Dv+r7/Fju8L1BDJGXpSScXglahy78eJGY/DjoDR4+IZ4m9m+rMabMPZaPlrZylcPMEdvuylgeYD12J8iCNUpp6MmcHxtmLWbF85p8TKIftZuDCfuGoU42tvlnfNfVfefgNddR+Y2pBGgsy+i9GOIowEPZbZAw178=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777638175; c=relaxed/simple;
	bh=7cVhC4mHuC0X7QDUWV7jjfBUkCP2haTgkhRBZrub6cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/UEEzPE237nvXdGbYY+0FTalrJO5Wol+K89pxSkAIHthor/WWy3yoR0KrGLynt7Y0EBcJ3nLzDmqtJ/iDBvTniTjP4E6Gg2RTq9LfPwonp8PUFsAwEOBSvcI1M9Sy6DsMdHdKuEnjx36uf8aS0XZElNYX7J7XF45pA5vSBupnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=sio3TbyT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="sio3TbyT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 80FF560254;
	Fri,  1 May 2026 14:22:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1777638172;
	bh=hnkzbGd5HMf6I7DzRoyho73vMYVHs0QfInsJSnj6z3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sio3TbyTUgXjXc5emWPBiHbcpzv3yWrhCuWvoh8wQ7e/SShb8scmSznYqv8gEgllj
	 mMSozqBrN8paP80qY1afGuzthca8t2IARTIc4ZrsG2E8M7o5WSp+IxRlJe2yxPP9RU
	 /jOsqZOqjo1Pdq2XGzwmEV2YsFwHOubmwsYupgDVzflZdmSbxjO46SC4iCuflu89zU
	 Zp93itxBVyEyo/jVkoibCwn2+zae0EH9rzDGFUIrWPA9Mlcgj1gfPPMhBxjKD1T4eh
	 llrvwKr8af5/PIBm9gEb24muQsF5WPdCT04x2/YDnNU9O++4LE0Yt11GOoJpWUjzjN
	 NvFOWdqh4xxfw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 07/14] netfilter: nf_tables: fix netdev hook allocation memleak with dormant tables
Date: Fri,  1 May 2026 14:22:30 +0200
Message-ID: <20260501122237.296262-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501122237.296262-1-pablo@netfilter.org>
References: <20260501122237.296262-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

sashiko says:
 could the related code in __nf_tables_abort() leak the struct nft_hook objects when the table is dormant?

 In __nf_tables_abort(), when rolling back a NEWCHAIN transaction that
 updates hooks, the code conditionally unregisters and frees the hooks only
 if the table is not dormant [..]
            if (!(table->flags & NFT_TABLE_F_DORMANT)) {
                nft_netdev_unregister_hooks(net,
                                            &nft_trans_chain_hooks(trans),
                                            true);
            }
            ...
            nft_trans_destroy(trans);

Unfortunately netdev family mixes hook registration and allocation.
Push table struct down and only check for the flag to unregister.

Fixes: 216e7bf7402c ("netfilter: nf_tables: skip netdev hook unregistration if table is dormant")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 38e33c66c618..87387adbca65 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -407,6 +407,7 @@ static void nft_netdev_unregister_trans_hook(struct net *net,
 }
 
 static void nft_netdev_unregister_hooks(struct net *net,
+					const struct nft_table *table,
 					struct list_head *hook_list,
 					bool release_netdev)
 {
@@ -414,8 +415,10 @@ static void nft_netdev_unregister_hooks(struct net *net,
 	struct nf_hook_ops *ops;
 
 	list_for_each_entry_safe(hook, next, hook_list, list) {
-		list_for_each_entry(ops, &hook->ops_list, list)
-			nf_unregister_net_hook(net, ops);
+		if (!(table->flags & NFT_TABLE_F_DORMANT)) {
+			list_for_each_entry(ops, &hook->ops_list, list)
+				nf_unregister_net_hook(net, ops);
+		}
 		if (release_netdev)
 			nft_netdev_hook_unlink_free_rcu(hook);
 	}
@@ -452,20 +455,25 @@ static void __nf_tables_unregister_hook(struct net *net,
 	struct nft_base_chain *basechain;
 	const struct nf_hook_ops *ops;
 
-	if (table->flags & NFT_TABLE_F_DORMANT ||
-	    !nft_is_base_chain(chain))
+	if (!nft_is_base_chain(chain))
 		return;
 	basechain = nft_base_chain(chain);
 	ops = &basechain->ops;
 
+	/* must also be called for dormant tables */
+	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum)) {
+		nft_netdev_unregister_hooks(net, table, &basechain->hook_list,
+					    release_netdev);
+		return;
+	}
+
+	if (table->flags & NFT_TABLE_F_DORMANT)
+		return;
+
 	if (basechain->type->ops_unregister)
 		return basechain->type->ops_unregister(net, ops);
 
-	if (nft_base_chain_netdev(table->family, basechain->ops.hooknum))
-		nft_netdev_unregister_hooks(net, &basechain->hook_list,
-					    release_netdev);
-	else
-		nf_unregister_net_hook(net, &basechain->ops);
+	nf_unregister_net_hook(net, &basechain->ops);
 }
 
 static void nf_tables_unregister_hook(struct net *net,
@@ -11282,11 +11290,9 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_NEWCHAIN:
 			if (nft_trans_chain_update(trans)) {
-				if (!(table->flags & NFT_TABLE_F_DORMANT)) {
-					nft_netdev_unregister_hooks(net,
-								    &nft_trans_chain_hooks(trans),
-								    true);
-				}
+				nft_netdev_unregister_hooks(net, table,
+							    &nft_trans_chain_hooks(trans),
+							    true);
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
-- 
2.47.3

