Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8B0A30E0F2;
	Mon, 17 Nov 2025 21:40:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415656; cv=none; b=Sxx5Tt4yBx9TI0TzU8Rwjb93EUAGLbX5NIk2CCbow01aaztCnVZdoQR5Gg5tflFx67BQw5O+qIpIccXYBZmq8NKNJ8L8lheMsrKAjrE/vXaT8kC220RKFoKUXFyVfZdQQYuWXxcRr0MRNtyMyRY0WPCKfb/HXtdAl1+vWCau5FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415656; c=relaxed/simple;
	bh=bljsyx/L1tlDjjDCkpVM5zgc/UFupr3RAsVRgDX8RUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tokf+EyI+WFOmuUG6d1NnK2Vo3gqih3qLicAvm6fcpvcFyv0ljUbGhEK2UvLHMRg7qTzk33+cgYKt1FE2uW4Pg0ljhLcrXEp3Dz+pVaSFj4uWB/ykzA3inyuf1H80kHTJRLiEqlxkcUhqoH0Hie2FBZhgJQZAa7/tT/vFS7/YOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=psKpmeUq; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="psKpmeUq"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D5E356027C;
	Mon, 17 Nov 2025 22:40:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415653;
	bh=h8MXzFn3fLYKjqXJxBYRTuNnV61EH5nTt/rkse7Y/hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psKpmeUqWO5N/giL5n0nuMnulh6/xYYNvtWOQWA1646mk4uwV7kZIHAQmz75C+Wx8
	 nUBc0xozDqWmnxpbLifYUbvKq90IHZJAHkcVJGewPGkkUd3hayie5bHqh4bW1LoGXF
	 82oKYi9WD8W2Kz7dRIypEWImF1YIxInHkog4bALjJgeTUAxYiOACuGbe+9uc40N2Pk
	 /edK7JFgiTetlG7+XgQXauOzIR+/SqCNQiRzbT6KZtUCB01vHeGqUccV2YUE4Rm1QK
	 HCVc6K/36XK30ywXL2O+kpNSOUlqSh+43sJThr8fwesxUVz0u6JJR0izCG7MF2aF82
	 ARJcpp41kktDg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.10 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 21:40:46 +0000
Message-ID: <20251117214047.858985-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117214047.858985-1-pablo@netfilter.org>
References: <20251117214047.858985-1-pablo@netfilter.org>
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
index 8e799848cbcc..dcb35be8b2af 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7105,6 +7105,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -7120,6 +7121,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 		if (nft_hook_list_find(&flowtable->hook_list, hook)) {
 			list_del(&hook->list);
 			kfree(hook);
+			continue;
+		}
+
+		nft_net = net_generic(ctx->net, nf_tables_net_id);
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

