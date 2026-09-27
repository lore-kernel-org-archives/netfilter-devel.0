Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CAD3CBE8B;
	Sun, 27 Sep 2026 22:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546909; cv=none; b=mQWvx+0GIL7Fo6n6+znZeRb1vdO5TjO/7tu1Q4iMiMhrFIOdJISUcopxLGvKjkt5SOQ4lqUpICa4GEzWcq5QmL7mBIDMfXbAyHVAwM4YkqrGgbs+dPMkrr+UsKVaIauqJHSzphlhuRxBY2T2GIFL00cpp2CJoLJ6Z0u9ZEtWkMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546909; c=relaxed/simple;
	bh=IJ2lSkgAoqrtEVHGx1wKh9WVagoB22Pw/fZ07JuijQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WljXRMgy8O5GN1XAbPF/mqZBr2em2/l7N+tJ0t5hb8oDa4VIh4OzS6yXekUCADe3Jz+dA+/jWfdXssCw9MvuEUfzcHxkvbpDgKYXY8Intd1mjD5KIJMwUsPDPd1sEILbfH9oumXs3u/KMYFd5d0ean7M7svTh3XK82bLBqBUh8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=QltHXQOn; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="QltHXQOn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546905;
	bh=7HpG4ukDMle9PPbYZM0ZKGZcUZGDj7vCkJZ77axIiKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QltHXQOnKott0jO3FEM72V3u83vwykogjMMeDDpiMEwH2daCzvFT0MMBQGO8fKZMU
	 GgATPZoKNfOsx/b4AS+E8Dxz+G0P+0nw/94uU1y5gvWEH5l4+3WjCuBl95kor7KGGf
	 heU48efkGVquNMH/PoP2chyO+vntpCctSMQffslXYghTAp6l1FFkkTIlZZW2xSXXG+
	 yEBz03EwS7K9fsa6Zfo01X0tvBGWfFHIlcBcKTTu+94X4m1wUgGRMcNOJp5eEpifN4
	 ZwP0fF9ATIPQ3cy3WJdK9VZDp53zh7RiBsaBn4pD86VMsr5RIiPIgOAw1hnzdmpOLd
	 zHvxpFYbHAxTA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 65F85603DF;
	Mon, 28 Sep 2026 00:08:25 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 03/11] netfilter: nft_flow_offload: drop flowtable reference on init error path
Date: Mon, 28 Sep 2026 00:08:08 +0200
Message-ID: <20260927220816.268206-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aohan Mei <henrymei@tencent.com>

nft_flow_offload_init() bumps the flowtable use count with
nft_use_inc() before calling nf_ct_netns_get().  When the latter
fails, the error is returned as-is and the reference is leaked.

The upper layers do not balance it either: nf_tables_newexpr()
clears expr->ops when the expression init callback fails, so the
nft_expr_more() iteration in nft_rule_expr_deactivate() and
nf_tables_rule_destroy() stops right before the failed expression
and its ->destroy callback, which would drop the reference, never
runs.

Each failed rule addition therefore leaks one flowtable reference
and the flowtable can no longer be removed: NFT_MSG_DELFLOWTABLE
keeps reporting -EBUSY even though no rule references it.

Save the nf_ct_netns_get() return value and undo the nft_use_inc()
when it fails, restoring the inc/dec pairing within
nft_flow_offload_init() itself.

Fixes: a3c90f7a2323 ("netfilter: nf_tables: flow offload expression")
Reported-by: TencentOS Corvus AI <corvus@tencent.com>
Cc: stable@vger.kernel.org
Assisted-by: CodeBuddy:Kimi-K3
Signed-off-by: Aohan Mei <henrymei@tencent.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_flow_offload.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 32b4281038dd..d3c5651dd699 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -160,6 +160,7 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_flowtable *flowtable;
+	int err;
 
 	if (!tb[NFTA_FLOW_TABLE_NAME])
 		return -EINVAL;
@@ -174,7 +175,11 @@ static int nft_flow_offload_init(const struct nft_ctx *ctx,
 
 	priv->flowtable = flowtable;
 
-	return nf_ct_netns_get(ctx->net, ctx->family);
+	err = nf_ct_netns_get(ctx->net, ctx->family);
+	if (err < 0)
+		nft_use_dec(&flowtable->use);
+
+	return err;
 }
 
 static void nft_flow_offload_deactivate(const struct nft_ctx *ctx,
-- 
2.47.3

