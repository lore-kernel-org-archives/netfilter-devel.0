Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AEF326925;
	Mon, 17 Nov 2025 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415608; cv=none; b=sqdT1WEr+/9noJ2q+YPf8DJDwKfQZKklZHOL7DDPJXL631FpISNwNDvDYYV4IYcMv3ZYByrb1hGIJreP8FQdYsUx+TPnf2avEP9+clw/ZdPRwfgv1MNjL0TkaY0jLEOjZ0KrqVjIsNuGViF6BGrOilDWDCz6ewgpYYFpwHhHgo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415608; c=relaxed/simple;
	bh=cD85Q9vYqIhtsOoZTIVzbzyQq5XehJUPBe8LsIi6/T4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KciFNd3AcxkSG3/+wJTEmKyyVHwL72ExI2Ve7921l3kX+jFA4wlot/CcpTjJX+xeJl9XoBYUj9Kt7HNea41BYtzudHbeV4IvmwPJXPpGuFUzDpg62zvGCGTqt1TNA4V0ePNJq2jZr+Js5TKO1bCVtiS/bGFTDy2qmLqpWC/zx6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u4yi8ZKc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u4yi8ZKc"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8C2546026D;
	Mon, 17 Nov 2025 22:40:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415603;
	bh=05uG1VOxdU+Mbeu2MjgS1YhjTggth5iQdX+jVZPbL40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u4yi8ZKcujHk5zdK3rQ2kwrVcOzgNDDWZOIheAIk7kkb9Gp1CMyey+UPMBvB5x8GQ
	 sC3d6fKHq5kgQL7tBzN/QgJey72WkSpdJDvFoqvYsg8u+8tKLr+gYSU8QPtXIBaVKC
	 uk9CkfP0oO4+/lx0dxPSAm1qyPfkBTEJSYU9ewwkBMG3qR71zoL3A/N9b7JJdMES1d
	 +mngH7aIX6Fnn+tIrORoix27TzMj6LmyhlaQHXNrLueoDe51RM9k2e+w/Nme2MTWKt
	 aGSWHjysJO9eyA3GAg0hnWdx4NiNt2EML2wHvaNhQoMoQiI3PMf9YLPkc59O2QDzjT
	 +l7Z529jKLDgg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,6.1 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 21:39:58 +0000
Message-ID: <20251117213958.858900-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117213958.858900-1-pablo@netfilter.org>
References: <20251117213958.858900-1-pablo@netfilter.org>
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
 net/netfilter/nf_tables_api.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index df83224bef06..b278f493cc93 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8078,6 +8078,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -8093,6 +8094,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
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

