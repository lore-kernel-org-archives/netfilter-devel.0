Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB2A47143D
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322707; cv=none; b=meUzdR0tu0DC6LEXN0GFMVTNcyqmLY0w1i7cQotuSvATN+SiGWgpeMkMx5JO/QDZJbyPTLK9PZ3FzHTup+zjZTgLYH2C4iSNm24EvMoValnnBuo0ETXAKpY/7x+VP6Kx+onYjkUXovXsp/0nMzf9G4ard6AKboaknRXE6VNFNPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322707; c=relaxed/simple;
	bh=AE4ed5EuDDeiXAv98L0Il17NDPiv4a4pOR4ytnHlC3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Exlaldg1aqsWqm/AW3muJm1HJsKPk0sPOSMQwdZ0e/ZkE5y9kOOrqZ54fjXt3f5C9nN2Ik/BHAlQHOhcgGpCqixASHIG3HOe/+KipR9nsl36sEmZsI3ZvM8gqFpJ6RZgz7IjkA2x0slTq1eMONOTnGhoL6qEFDd7Ym6NxF6mYZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0DLxqxQ; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0DLxqxQ"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39dfedbf80fso97495a91.3
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 00:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790322700; x=1790927500; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jpLrGCv4J+0iubueWZJcqGPb4zZNzwy+TJzfy9q1TYY=;
        b=B0DLxqxQW2omh+ROsatbozyyWtf+1Ih8WB836ltJos2L7V9pDOfCLnxSaHfGJ7OJym
         37TSok09qRuRXWVQV3vkTChbV5W1J8hC+cDj+8nKFw37rei7zu0S1v4L4r0IPNyZD6i4
         TIbGYe1zDoMij30SrVhcZDB6MBDQ2Q1i+MSyCatKQ72Y5W657ETi5XoAEjPNJpmOF6+m
         MhLnVbfuC+Jqjjo4pMcM/oWDqfaw6L2CCduhelP1hnRdU4MfYeuO3DFHsFuAuu+85gTx
         Llua8Ni9sGq0Da7TkU7UZAUGhbRL3EJ+qGX6fYnKMFjtY8loj8XyfB3V22zl5gvzp9/q
         8B/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790322700; x=1790927500;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jpLrGCv4J+0iubueWZJcqGPb4zZNzwy+TJzfy9q1TYY=;
        b=JEb4S/IVfZqVLF/1QZ+1tfHrIsVsV6kpx4Nyn3mEC0SEisxt5OOslxIs6Nwho/ZXae
         8P+nIQ7/rzbqbKoojLlSDJdtIW43UeiYwkuNaneC96rHoXrKLLwOmB2rZ5TdngGkStCJ
         mS/A+sBfuzrFv0x1oDc6vlB5qzLF6ZFbYBdkc498kuSyEAX9j2CSFbG5/5IUZIkHPwTt
         2GJpMRa3D+1hHueNqBofySu4r+KaelSRQziqN4sU5ZynbA2jG3u2k9WoPXL7fRKRyAmm
         a2DF63rxGaq/42ytUI38qs+DWQn92gczEtnhNpNvAJFF/Gv6Jj3w0JajvTHjY81M9iU1
         Y0VQ==
X-Forwarded-Encrypted: i=1; AKwUvBzEAYhANLYtYWGp1q4565QPYTKFPhURGsfCl6of5/dt9PNDz2KuguE1aZ2Gl5s++upEJEv3L434ri8OULK9HyY=@vger.kernel.org
X-Gm-Message-State: AFuF++kWWrHxXicPVwTEZXkleUHQcB7QiSLcS2Onh0I2v2/TcdImzHni
	Fujit2tS3g7phMmUS0RGd7zavdDec/3eWq5vnU/1qPfxHVaptpMkEf5ae33Mvg==
X-Gm-Gg: AYBFou3Z0RVB2HkqUZ6vY6eskxhZI6gBfi6wh2qee1hPERCKPDJAF2f6UhHCUAfzZWR
	vHDM63qwUVy+Np6/bI+A2aBkm5LsuUIYI6MaN3hcdQ2gyvvnzR4iGfwxa0qMFJxsm0JSysLxa1Z
	RtycKRcJK6CjHde82qR6+vH/iVpagX8SP7iZY4ZbpHTBF2DgwCC/0xEv5DTDrlX0Ro4ltRTGSBO
	IzXNXwtUS28HzpME+SfU6IXamRv/RSHvKO5TW7fTzSkI0tz5deWxeVylj4V7FhtbU9E9jjwmK+K
	YpmG91tO/SwUO6ZHsWuONOM9p1sfyctmtkb+hWT53XIiEsNkXsLIH3WI8FaIY5dq0S+X0kiNS3+
	Zv7xlz40QWWyH7MW8ml7BeWCi2MwNHCAS2QH73Zs3y+E6BIb/J3dlV0s/p/TZdWMcEEbea4qm8x
	MaEzFl5cGuD42CCY6RG1fNeMtyGwHDx9q4yzrLDhmsuy4p7ReDRYdIWALB+ZNoa+ocuzCB/mkyb
	Or9dgHzaOk=
X-Received: by 2002:a17:90b:4c51:b0:39e:261:4e13 with SMTP id 98e67ed59e1d1-3a098cf9d1bmr7398945a91.3.1790322699628;
        Fri, 25 Sep 2026 00:51:39 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm255962a12.28.2026.09.25.00.51.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:51:39 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 6.6 6.1 1/2] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Fri, 25 Sep 2026 07:51:27 +0000
Message-ID: <20260925075128.646-4-junzheyu1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260925075128.646-1-junzheyu1@gmail.com>
References: <20260925020025.616-1-junzheyu1@gmail.com> <2026092558-grime-yahoo-6b34@gregkh>
 <20260925075128.646-1-junzheyu1@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Phil Sutter <phil@nwl.cc>

commit fc0133428e7ad65aa6b7c8e65ccfe86e469e4512 upstream.

Do not drop a netdev-family chain if the last interface it is registered
for vanishes. Users dumping and storing the ruleset upon shutdown to
restore it upon next boot may otherwise lose the chain and all contained
rules. They will still lose the list of devices, a later patch will fix
that. For now, this aligns the event handler's behaviour with that for
flowtables.
The controversal situation at netns exit should be no problem here:
event handler will unregister the hooks, core nftables cleanup code will
drop the chain itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Yu Junzhe <junzheyu1@gmail.com>
---
 include/net/netfilter/nf_tables.h |  2 --
 net/netfilter/nf_tables_api.c     | 41 -------------------------------
 net/netfilter/nft_chain_filter.c  | 29 ++++++----------------
 3 files changed, 7 insertions(+), 65 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 4056d2272..515031702 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1233,8 +1233,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a9053667e..81d67a4ae 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11267,47 +11267,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static void __nft_release_basechain_now(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule, *nr;
-
-	list_for_each_entry_safe(rule, nr, &ctx->chain->rules, list) {
-		list_del(&rule->list);
-		nf_tables_rule_release(ctx, rule);
-	}
-	nf_tables_chain_destroy(ctx->chain);
-}
-
-int __nft_release_basechain(struct nft_ctx *ctx)
-{
-	struct nft_rule *rule;
-
-	if (WARN_ON_ONCE(!nft_is_base_chain(ctx->chain)))
-		return 0;
-
-	nf_tables_unregister_hook(ctx->net, ctx->chain->table, ctx->chain);
-	list_for_each_entry(rule, &ctx->chain->rules, list)
-		nft_use_dec(&ctx->chain->use);
-
-	nft_chain_del(ctx->chain);
-	nft_use_dec(&ctx->table->use);
-
-	if (!maybe_get_net(ctx->net)) {
-		__nft_release_basechain_now(ctx);
-		return 0;
-	}
-
-	/* wait for ruleset dumps to complete.  Owning chain is no longer in
-	 * lists, so new dumps can't find any of these rules anymore.
-	 */
-	synchronize_rcu();
-
-	__nft_release_basechain_now(ctx);
-	put_net(ctx->net);
-	return 0;
-}
-EXPORT_SYMBOL_GPL(__nft_release_basechain);
-
 static void __nft_release_hook(struct net *net, struct nft_table *table)
 {
 	struct nft_flowtable *flowtable;
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index d170758a1..e48de5a2b 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -322,37 +322,22 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-	struct nft_hook *hook, *found = NULL;
-	int n = 0;
+	struct nft_hook *hook;
 
 	if (event != NETDEV_UNREGISTER)
 		return;
 
 	list_for_each_entry(hook, &basechain->hook_list, list) {
-		if (hook->ops.dev == dev)
-			found = hook;
-
-		n++;
-	}
-	if (!found)
-		return;
+		if (hook->ops.dev != dev)
+			continue;
 
-	if (n > 1) {
 		if (!(ctx->chain->table->flags & NFT_TABLE_F_DORMANT))
-			nf_unregister_net_hook(ctx->net, &found->ops);
+			nf_unregister_net_hook(ctx->net, &hook->ops);
 
-		list_del_rcu(&found->list);
-		kfree_rcu(found, rcu);
-		return;
+		list_del_rcu(&hook->list);
+		kfree_rcu(hook, rcu);
+		break;
 	}
-
-	/* UNREGISTER events are also happening on netns exit.
-	 *
-	 * Although nf_tables core releases all tables/chains, only this event
-	 * handler provides guarantee that hook->ops.dev is still accessible,
-	 * so we cannot skip exiting net namespaces.
-	 */
-	__nft_release_basechain(ctx);
 }
 
 static int nf_tables_netdev_event(struct notifier_block *this,
-- 
2.53.0

