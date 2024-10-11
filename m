Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F385256
	for <netfilter-devel@vger.kernel.org>; Fri, 11 Oct 2024 01:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608949; cv=none; b=mP0n4T7/Cq6AttTBJXMF/ElsGiXHF9dXLH20EhgmskNJ2AOf/bIqcpfiZFUh9qFf/M0+S6cKNgnrofKnfQg7Nm/I0sJvhR6Lnsb6ROgXqUKTXBFK/da4hi0+wtHLYd34VhSxlf3g005IsNydhsQ/z2w/FmZjpofsy/X3C7NZYMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608949; c=relaxed/simple;
	bh=y6Rxiqg2R8MosyZreR4CoWQrQYD/JMRjgiJx21QKLnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=heu4P3iZug6Cc2lg3erHWi4PhudQ6zji742vk4vVUPNP9crQaplmG0i0Cj5ZyyjEA0vmvvUtjgZpb57twWjr7t6WAsX3epAH2CQpE5Y7xqEbYTDo8VVrYPpNhHBTU3/M8dHlVrgKl2IVdUsRTavaEFRhkNqGBuVkU+lvgD/SxHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breakpoint.cc
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@breakpoint.cc>)
	id 1sz49S-0006x0-0m; Fri, 11 Oct 2024 03:09:06 +0200
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next v2 1/5] netfilter: nf_tables: prefer nft_trans_elem_alloc helper
Date: Fri, 11 Oct 2024 02:32:59 +0200
Message-ID: <20241011003315.5017-2-fw@strlen.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241011003315.5017-1-fw@strlen.de>
References: <20241011003315.5017-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Reduce references to sizeof(struct nft_trans_elem).
Preparation patch to move this to a flexiable array to store
elem references.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_tables_api.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a24fe62650a7..2f85f4a10c50 100644
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
2.45.2

