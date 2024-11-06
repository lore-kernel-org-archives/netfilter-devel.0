Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70CD1E04AC;
	Wed,  6 Nov 2024 23:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730936804; cv=none; b=S8S4sO1zt6pu1GKMIAiO0iranaPEZC7e+3HEr5wkAWZV06CxWq9X2IsTThqbXIL7nkvu93uUraFfmmHXBtuVtRNyUWwXqI2Y38GcgcsNhBQMA7KWy3sMok8ny/qJ5FAQvWKSOhZVTNCnGYpTGx+zCgo5BwuX7yVk58mahrfiOvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730936804; c=relaxed/simple;
	bh=AEaA0JJR/WksV/gnncrFfBOzBvc7oT8d74oY4m+0b44=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EFwXxXLnR5qTqgSKTW+kEIuQZgyxyhoR5SHvN0xi2nA7n69LtJrSShY3KV57YaE+Zu8PtAkfF81+Jc+f0x7sZFgWwAaGTvYUtf02gpOG0BUTta3lwcxvp2F4kHNAw+700Iu0jTLr/cSbPwLSisrebp+TkTX3NcbOT0UMQcpJMxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de
Subject: [PATCH net-next 04/11] netfilter: nf_tables: prefer nft_trans_elem_alloc helper
Date: Thu,  7 Nov 2024 00:46:18 +0100
Message-Id: <20241106234625.168468-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20241106234625.168468-1-pablo@netfilter.org>
References: <20241106234625.168468-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

Reduce references to sizeof(struct nft_trans_elem).
Preparation patch to move this to a flexiable array to store
elem references.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6552ec616745..30331688301e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6409,7 +6409,7 @@ static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
-static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
+static struct nft_trans *nft_trans_elem_alloc(const struct nft_ctx *ctx,
 					      int msg_type,
 					      struct nft_set *set)
 {
@@ -7471,13 +7471,11 @@ static int __nft_set_catchall_flush(const struct nft_ctx *ctx,
 {
 	struct nft_trans *trans;
 
-	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
-				    sizeof(struct nft_trans_elem), GFP_KERNEL);
+	trans = nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
 	if (!trans)
 		return -ENOMEM;
 
 	nft_setelem_data_deactivate(ctx->net, set, elem_priv);
-	nft_trans_elem_set(trans) = set;
 	nft_trans_elem_priv(trans) = elem_priv;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
-- 
2.30.2

