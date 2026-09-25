Received: from mail-pj2-f43.google.com (mail-pj2-f43.google.com [74.125.227.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19F32470124
	for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 07:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790322701; cv=none; b=avB5Tk2/mMJI+PpWnGj3Axw5gppcDOYO1gzZ5L2BuNsoH2mZA3hjR0Tal9AZ9gu14Qsj4npmUWCW1R2FgxFu+conjAM32s9qMKAmSVAaUblCV9FYgUjiEE/ZiVpFkSoSoGL+6E4sR3KILjKKGJF3YCROoESwi4QaWr/VtNDToas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790322701; c=relaxed/simple;
	bh=VL8NMVy/yR+nitYVFDljmzupJKiFTnehRUl/zIn2UZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYEiRwJ+ohHWvgId+uK/CVIkvvwIp+FfpHJMHFakrUewQH3JoR0vxcukYwmFBbVgJA+aBUPzQ+AgyGUi6FVMXoynIDysDKrkFRDT9au/IWKRGGeR4Y7w8qPRhwcUZ5fyUbzY7kwMtv6zinmN4rVpD27+WvBBpuIuo+2JJ152VXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CVwld5Q5; arc=none smtp.client-ip=74.125.227.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CVwld5Q5"
Received: by mail-pj2-f43.google.com with SMTP id d9443c01a7336-2dd89b59dccso516975ad.2
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2026 00:51:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790322695; x=1790927495; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9jCIbsFu71/twhzfGBTA3MdwkVdh8EDAdzjS1dGA6o8=;
        b=CVwld5Q5QU0Pt4V7u1UrbAKwH46Eg+ig6hSE8SzNaNixkyujGhxkMEREUIA8Qp0gHI
         K5zSmxIpq6s00CfblbJABqwCWb7ebzCEUyC5n4vRJIqVj7Q5UhHiY0/ZniO4KEKGZNZM
         TMGl5CX8Fn6MIpPe2IqzQErDC/Rfw/C7wzvzl6y70PNQ4VqDfe2L2IHA8DM0Qu3Vtu76
         24/3buqhZdNpaQDaRdlRRIxQT6WWcAIfPhnjXfwPZ6riEka0lJPBz4To2EjBZeXNkx3d
         pswvmZlzBkY26GyaWGviM4IQsGaMUWXuAk4qbMQ7tAs7at74u+sBlbLjputmQRbOKSoL
         +4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790322695; x=1790927495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9jCIbsFu71/twhzfGBTA3MdwkVdh8EDAdzjS1dGA6o8=;
        b=pgcXKNfV8xmrmxy03f3e0qgVLeZ1PuA+SoHjpb05WR+rXdvosq73ZeTBwdeFJ9TnxO
         s9SMaps8uxfeF7tIZqZA/UsjNsqhh3dUzLAv8lnpOypq3aVmbTkP05P6Z2cmcjQP8FiO
         qse+AwlIou4P4g0bjz+JQlm+4F/kLU0h+/GakkG6S1YKgAM2AqNP3yogbG+tJh41bP7p
         R0RqsjThnx/LBY+4CRC5wOT1pPXNMS1wUuDDXZQXTxvBGEipwyPBnh+P2rbtBWm7Qcr+
         Ly6FuLFAo72N7PhzPNbTGY9yuPJXMKodBj1hGeGTBKeoNVUirwejL5NbIdhstkt1R1MJ
         xWQQ==
X-Forwarded-Encrypted: i=1; AKwUvBzO1b8CfB1yPlly5EFznCUSLhcImkeY3OCw5UIyvHYbHZj+ifa+XLvVe3eWBzzCF8aYqM9PTyG7j5ldtpAuJBM=@vger.kernel.org
X-Gm-Message-State: AFuF++myGor06WBr5P4nOwCdVPjlGN4sZ2JDcbEWKry7JONx6zbmjXaD
	XjhCcePygZECX/+Z8yfesT3VBs/JcLPxuajxVmZzpHbtgAweGuiPblYq
X-Gm-Gg: AYBFou0X8Ecr7ZMB2e5JklOijyMbEifFzi+dDCKP94KfTkyOBkIfAH2eXKSB43yLMPl
	yYIKf/q5kRlMS0tyrboDILXZkuV1JdVJa3BTboYZy+NifEhVLa8U3jNgKtBlGgVIywHj/06ayw+
	kdRFlByayxLKBmtKLNp8veS4TCRoT3VMwey0BEADXT3CHljwxTixahbf5qDHdL/SYzimxjHDShR
	NUeyPyYR3q3DH/xQYzUPjUtaYritCmjtcBnryxBPRyDbF9b9d0jLJLVzceZx+8XKlv0JXo6ha/e
	3HUcW1IWJ0mvjTTX0HhUr3EbawFpjqFO5FAVqCk2XnO7g8v4g30dheKXx+MVMuCdsAiFBIKhlL6
	atMT0jtHBgTM6epxvTtGV1s2eDyHC0bfKXrAEwSFGzlpxrTWzJKV7g55ij6oNmwFa7OBGiI3gwY
	qegp3nfOcfpSo0OLxFwBNUJ6/prVLFxVbqJt6M9gtdrWNeNTHKdRQ/xGDBSd4EcR7bzojljAOib
	isSO84F5DA=
X-Received: by 2002:a05:6a20:93a1:b0:3db:15f0:c034 with SMTP id adf61e73a8af0-3de2271cbd7mr2880392637.0.1790322695027;
        Fri, 25 Sep 2026 00:51:35 -0700 (PDT)
Received: from localhost.localdomain ([175.159.181.20])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc790c80e62sm255962a12.28.2026.09.25.00.51.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 00:51:34 -0700 (PDT)
From: Yu Junzhe <junzheyu1@gmail.com>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: [PATCH 6.12 1/2] netfilter: nf_tables: Tolerate chains with no remaining hooks
Date: Fri, 25 Sep 2026 07:51:25 +0000
Message-ID: <20260925075128.646-2-junzheyu1@gmail.com>
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
index f4b59915a..923b2c0d6 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1238,8 +1238,6 @@ static inline bool nft_is_base_chain(const struct nft_chain *chain)
 	return chain->flags & NFT_CHAIN_BASE;
 }
 
-int __nft_release_basechain(struct nft_ctx *ctx);
-
 unsigned int nft_do_chain(struct nft_pktinfo *pkt, void *priv);
 
 static inline bool nft_use_inc(u32 *use)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 2613ebfdc..af9df95dd 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -11362,47 +11362,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
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
index 7010541fc..543f258b7 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -322,34 +322,19 @@ static void nft_netdev_event(unsigned long event, struct net_device *dev,
 			     struct nft_ctx *ctx)
 {
 	struct nft_base_chain *basechain = nft_base_chain(ctx->chain);
-	struct nft_hook *hook, *found = NULL;
-	int n = 0;
+	struct nft_hook *hook;
 
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

