Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF433254B5;
	Mon, 17 Nov 2025 21:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763414964; cv=none; b=NZXeGDojYt+MOhdlfZ1aTK41ZjnZDq3I6jj2W8fiUOLxsMGQ0afMKBZ++cTL8SJh+706RXCNd1M2RIrZBAytD+neGNgaZBJuV5TDSVsk30w4Dati4FjnBiS7K2l9ZQ9m4M1CQxOVLUKa1P1ZTbrsEUsmviIlc6lhhqlS+xeu3lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763414964; c=relaxed/simple;
	bh=2+T27aDuwNTkX5qB8Im7w4S4d/5uY9QMLQze6q+Hi9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOjcBEkFpJ3OLDh/FLuGI0oUjS+m+TRVojB79XsDfv9p8TWR09AuTWg3XHTUTkZS6+qMd4wBw0u3C4JIYjj8DtFp9Jv+EM7u2lJKKR5pDwkH/2DUfAznGO4d131XkxlZRAnBM5n1eLc00pzt34qvMPJNDdDMDUVNNxhgGJQEJ4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=CcXBXDuS; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="CcXBXDuS"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3110560311;
	Mon, 17 Nov 2025 22:29:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763414955;
	bh=h8IzNR8V6ST5Gv/mNfPwWtwt6SCfaJ9B229bN2sdSDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CcXBXDuSmG8NrZwPbBAPrI2Ldy8YupfQbX3essscVpuej7D7hV3uQ57PSc80r00i1
	 uTUwhlTOEByfOseXmXjo6ZfWk9VTdsQtiYylKCqBw09+Mv5uRB2SnNahMK4ajXlhp+
	 C9P0VAuII5glq6H55tGBOGQZXbP5iBH4Vdz2YEVEbZHPhV2BfYn2lr7VCt7dMNAdOR
	 5VZqZwzMKqncWXCoc2j6l++Ri9KZSzyVAQNI4yj76MKmIXQ1J8+VwXh8/rgntiVgW8
	 Y0VLkoMjpFZJD8xEkti7xXuHV+t2cGuzDjE1ahAoHyyTTnuojvug6oruBbGtOZ7ekX
	 4kv6pqlUfhE8Q==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.12 2/2] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 21:28:59 +0000
Message-ID: <20251117212859.858321-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117212859.858321-1-pablo@netfilter.org>
References: <20251117212859.858321-1-pablo@netfilter.org>
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
index 2f3684dcbef8..e1c617b48888 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2642,6 +2642,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2682,6 +2683,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
 					kfree(h);
+					continue;
+				}
+
+				nft_net = nft_pernet(ctx->net);
+				list_for_each_entry(trans, &nft_net->commit_list, list) {
+					if (trans->msg_type != NFT_MSG_NEWCHAIN ||
+					    trans->table != ctx->table ||
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
@@ -8686,6 +8701,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8701,6 +8717,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = nft_pernet(ctx->net);
+		list_for_each_entry(trans, &nft_net->commit_list, list) {
+			if (trans->msg_type != NFT_MSG_NEWFLOWTABLE ||
+			    trans->table != ctx->table ||
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

