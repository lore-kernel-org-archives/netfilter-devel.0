Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9FC14E2F2
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Aug 2025 00:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755045545; cv=none; b=oMPQPdIVy0EyTU6RbLMvM5ATgK2mOb/v9Vdc52lPr629PYzB/JpI+mRhUqb7HxLtKextx2Aa+zyb/sd7CFo1fxpnCgUUjq+oIlLSpT/dZu2x05b0djgi6myxMJUNCaTrtmBlrAI6R0wep4s5Fdzoa0FWyKpCvsQEYB4Kd4N1+oI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755045545; c=relaxed/simple;
	bh=OT4He51kLmnVAGjDRfGuWLOCwhNKtYnOQp+LqP8UEmE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MmabzAs/GMMKt8AWfJ+g8jLPVTZx3MXMBfCJNWU4EqR7mvgtmIK4Ut++IdtQJ73ZGesOs91SrRlJoo+kyCAh25SWcwUxIIu4DUOKnpUXqmQNojdjeM6qWGvKyx7nWf6rP72sYIP6rb6sFauHaC85DhDC+Sv4WeRMHU7vE0fLpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dgO7ALiz; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=YO9m70T+; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dgO7ALiz";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="YO9m70T+"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 4778E6074A; Wed, 13 Aug 2025 02:38:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755045535;
	bh=YhyaWYy+LafZ60sDFWxPIYBV+qLQHO7rKNgbCkBdTkc=;
	h=From:To:Cc:Subject:Date:From;
	b=dgO7ALiz7pEEip54fdE5PjIYPt8sAPr0UblhVtUeaX4O+mNa4ogQFSubTw19rP6H8
	 uQxBeeXnJ3gO8fRUvHzXn96syiWjaAqxep5fqL65nLGgH/250LsCx0lkZNy7t8LCLi
	 jv7Z41RYJ/iziEg+uexXlVj61TLcASLmBOzIxK4P6Au6BNBmIGorHGOL9Ac1+KutpN
	 qVMWghjbI6ESovR2ZCdCxNodgWC5V/BcnHDgQlqZqmZo2cBREvN0ranKBBF2RKwSCV
	 aN4VSGHY0rPzEisBVtcwNY9taS6pnt5mN7pFjnbcfCDyrnx4Oj8yXqFYKNjJqeIoix
	 LTisawTx7idew==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5F77D6074A;
	Wed, 13 Aug 2025 02:38:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1755045534;
	bh=YhyaWYy+LafZ60sDFWxPIYBV+qLQHO7rKNgbCkBdTkc=;
	h=From:To:Cc:Subject:Date:From;
	b=YO9m70T+IjtWWz72HBH3jETOHoL38tRwz90oyjbOFz7r+4ljIgJRVHfXqr6cIWBFf
	 3cH2uz+hyI52q80n+1yoOB7TrIESZuhrkIMsu/Lz630NNcbxJiHW1yaRzlAbNv/rhZ
	 s/Re8sxW7iU0Xh5pGyVUKn+2uRxc5aHBH5PpJhF9dVl/WbrNT+Dha+m4eGatnYPJXm
	 BLrlXGayjXLPcPz/anpCw9gntIlzaPMHg36+gqyMeBVAlDUQxWcuvm8nQliLBXztLK
	 pW2JS/9/6s6A6QmdkZ24/QwomXUjepFlvXnTIVlN7DGs9jmRJkcfP3xLmyQG4lRSPE
	 VwTl8oANemChw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: fw@strlen.de
Subject: [PATCH nf] netfilter: nf_tables: reject duplicate device on updates
Date: Wed, 13 Aug 2025 02:38:50 +0200
Message-Id: <20250813003850.1360-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 net/netfilter/nf_tables_api.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13d0ed9d1895..58c5425d61c2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2803,6 +2803,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_chain *chain = ctx->chain;
 	struct nft_chain_hook hook = {};
 	struct nft_stats __percpu *stats = NULL;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *h, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -2845,6 +2846,20 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 				if (nft_hook_list_find(&basechain->hook_list, h)) {
 					list_del(&h->list);
 					nft_netdev_hook_free(h);
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
@@ -9060,6 +9075,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nf_hook_ops *ops;
 	struct nft_trans *trans;
@@ -9076,6 +9092,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			nft_netdev_hook_free(hook);
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
2.30.2

