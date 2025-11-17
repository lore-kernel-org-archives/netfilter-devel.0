Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C39727E1D5;
	Mon, 17 Nov 2025 21:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763415631; cv=none; b=eSzoNtAXmStgXbzj5ARrcfuRLMq2WShCL8CDxWt8T9O8GXc8/3RxM5tuRVHiW90+aVcgKtTdSYrLq8do3EoTI/Si1+kzYFppvlOCh02X43WpG/9r/Fc8LnI5HSMY1my8UL8Og2KhoLXsb1yQC/gYN2VRxRuAyfpbii7rGvyFTTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763415631; c=relaxed/simple;
	bh=LLVqdKBEvhjnJWOYwpgtA+deE5gioiHCVr7O3HSYnxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRiTjqlXEuXBMlM4TDOopTt8YK6LGUovp7thZa3TK8WhXfZ+7PQOSHOkxZYi5JpHSwL6Y2gC6ayO1kMqosrwmL3VYCHRMKdEL/tomykqYXgigaShgyYoa+BLfLywFm+p7eMyQQt1wYeaBG6s7aS9jRyn2u+eJ7rmaoMAb3d4gfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=otG2O1v3; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="otG2O1v3"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D46F660279;
	Mon, 17 Nov 2025 22:40:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1763415628;
	bh=hSq3ps0WQFEBUgUQ40CIGbPfTQVTUP7yBcN4bjrp3WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otG2O1v3L6I5AapqGDxQByjSAVquZ8AcgMNPsSVTV7AWTPyKPgPp55B0Vbr35EzU2
	 vWO8IKwwr2M6PRF+YAbZI9mriJZXTZ/0Ux/HHHGv/aNkey00ETaV8fqAb0V6APM6Dm
	 mp1UB2fv/oVd6v/yjfp6e9ngdKAlEcLii1SFZ6jSdZQdoxlzi+I3XxuI7jiuAE92vy
	 EGC/dqEyg6CPxBNmvIVoMA0YqaMh2hQ31qHpGuKLFEhaubgPHjmEI5XjMgPA+GkQy1
	 83dq26D6KlJUh5VQ7OwG5Rsv2HwpJ/q9BSwupAHTVehS2yR+QC29Exkah593EIMKBK
	 44fH8EEC7qpVQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	stable@vger.kernel.org
Subject: [PATCH -stable,5.15 1/1] netfilter: nf_tables: reject duplicate device on updates
Date: Mon, 17 Nov 2025 21:40:23 +0000
Message-ID: <20251117214023.858943-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117214023.858943-1-pablo@netfilter.org>
References: <20251117214023.858943-1-pablo@netfilter.org>
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
index 33d03340d9fc..91b012e476be 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7893,6 +7893,7 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	struct nftables_pernet *nft_net;
 	struct nft_hook *hook, *next;
 	struct nft_trans *trans;
 	bool unregister = false;
@@ -7908,6 +7909,20 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
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

