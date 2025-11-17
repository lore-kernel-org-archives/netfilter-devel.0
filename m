Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B81316905;
	Mon, 17 Nov 2025 21:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415571; cv=none; b=rIBi2Sx3hU1aojNFoa9/dmhs0qgyWY1wRz6kWUb+mYpe8QhW8PCzuuUlxEacz4WNzGfcboldFbFGf3ZTbUjFbabFSc6faGwRDaz0WVVzSviHWgyP448ylS9gRAtRzTTeeFhkv/TCErZTp4zddwbjjWMNRjwCpp9aZraEP8yJcsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415571; c=relaxed/simple;
	bh=w1QPMqLqnP6TKemeZdCEJz1eZiCdW5wb2RTLwrSnpw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0XLgMhVeauQL2nir7OYUKKRZ0BhfRa7Yx17QtnSK5SlGC4i7B3ngMutUcYarENW29n26sPH51gQ3Ti9+tt68O738ldQq9AlKZfStrlveEj0PNuzIb2GtIZdCn6SO8pCfbSb1eg5Usbp1Uh3Epa84v91aSA9suVLtuMxt2GICsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=OSHo9SDf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="OSHo9SDf"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 4B46960265;
	Mon, 17 Nov 2025 22:39:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415567;
	bh=71M/gLxK0rBgj6YjjpYtMvQLp8iEVODgkFw8eKMkcOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OSHo9SDfjw88h9Ipq5VGkIz1BCqvJFi3LUO1pIdEWq2t0wnNg/hvd4Id7XywQOcW8
	 FZWwrXlE53ra1AtJDsL0Cx4aeGrqHC5TO+KibFAqvR7ZMxOYFaLI9Be0g5qEX67FR2
	 Way1TBtfc6U1Fs0R+OVJOkxj2EU6kat7bFPhRhlt+IWIuZe5n3L9/XzyNBsgkevTKb
	 f5tvkKUFwxdXzIaxLXCJojdC5gItRkEr3zvVXA2jn8f3T26c6GsI3oejOK9oaLprcS
	 Xq1Tmn1e3dnfdeM/N9rjy2ZPuRUy/IcKXlGvBJtHpb7oUvb+v4+p6upXNKzLjma2ib
	 95383eZlyUnhg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.6 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 21:39:21 +0000
Message-ID: <20251117213921.858836-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117213921.858836-1-pablo@netfilter.org>
References: <20251117213921.858836-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit cf5fb87fcdaaaafec55dcc0dc5a9e15ead343973 upstream.

A chain/flowtable update with duplicated devices in the same batch is
possible. Unfortunately, netdev event path only removes the first
device that is found, leaving unregistered the hook of the duplicated
device.

Check if a duplicated device exists in the transaction batch, bail out
with EEXIST in such case.

WARNING is hit when unregistering the hook:

 [49042.221275] WARNING: CPU: 4 PID: 8425 at net/netfilter/core.c:340 nf_hook_entry_head+0xaa/0x150
 [49042.221375] CPU: 4 UID: 0 PID: 8425 Comm: nft Tainted: G S                  6.16.0+ #170 PREEMPT(full)
 [...]
 [49042.221382] RIP: 0010:nf_hook_entry_head+0xaa/0x150

Fixes: 78d9f48f7f44 ("netfilter: nf_tables: add devices to existing flowtable")
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 5ca1d775e976..80443b4eaeff 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2576,6 +2576,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2616,6 +2617,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
 					kfree(h);
+					continue;
+				}
+
+				nft_net = nft_pernet(ctx->net);
+				list_for_each_entry(trans, &nft_net->commit_list, list) {
+					if (trans->msg_type != NFT_MSG_NEWCHAIN ||
+					    trans->ctx.table != ctx->table ||
+					    !nft_trans_chain_update(trans))
+						continue;
+
+					if (nft_hook_list_find(&nft_trans_chain_hooks(trans), h)) {
+						nft_chain_release_hook(&hook);
+						return -EEXIST;
+					}
 				}
 			}
 		} else {
@@ -8493,6 +8508,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8508,6 +8524,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = nft_pernet(ctx->net);
+		list_for_each_entry(trans, &nft_net->commit_list, list) {
+			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
+			    trans->ctx.table != ctx->table ||
+			    !nft_trans_flowtable_update(trans))
+				continue;
+
+			if (nft_hook_list_find(&nft_trans_flowtable_hooks(trans), hook)) {
+				err = -EEXIST;
+				goto err_flowtable_update_hook;
+			}
 		}
 	}
 
-- 
2.47.3

