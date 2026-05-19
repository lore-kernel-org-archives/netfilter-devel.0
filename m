Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5013E928C
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779226718; cv=none; b=tTc9Ug85vly/QnyBEnWMzJOgY4K/a4HngEQkxQZTJHsBoPnN6cFPl/OYuW4oFJHZ0plSMXW1tRgTVeP5B4iEw4T6+gg1wWR+n85pNcgfSf0IlXw0Rl0SxuMROzFygD/E28jdxRMe0KjYDEYYDvFm7cwDf7jSgxnKNhHgYgJjRCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779226718; c=relaxed/simple;
	bh=E7v0V71AnYOeT5t9ftRqlKCSSAmhBXoxTWG6tebx7wY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YYCw8gG6DtyjMXff3X6ItjqjitoMT0czHfY7xtS3diXF4uQeI2HzPkmxnmb1+s5Jw1ux0oHg/5VFdUaf+/tkkA6knUg8Liu6NMKrKmpdETbjXidr6wlP8stOdewX/3PiCO1QGIQRh9vbVRN4ARBtKdBbEgy1sAKTJIABseAwp1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=j40aSIcC; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="j40aSIcC"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id AD49B6028D
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 23:38:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1779226715;
	bh=218NYYzLKxauq7CZbCEjgpgdslhYI+kY/k/FpaomHo8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=j40aSIcCFQBRc5yDB+4CUrtTAd0acCyBeKU2AcCfwCMssxOcXnEvbd+HdOb1I6TsM
	 ipeTKGDX79tP8hIVTavPAj7LXj9RX2MAzQoUaU8nq2RJs8RO37IfXpkRU38B8ENW8S
	 77f8xNd6QxvGb+mBABOPLocsejm0+a91SxdG1niQghB4huhiIS1RaaI0G7KwG8nC90
	 lSUUO+4/n5+g+1PnpFSbCZWzYNjhCToO5tyfW5hOpwFBaG4VA2ruWhXte0LLFYgbXf
	 zRCrf6bN9t2yGfBSnX9K5Ytui/TBjd83BJOFLjtzenc1OB2ryPr3yIf1fKkLY+Qd4x
	 U/KE3glvHiddg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 6/7] netfilter: nf_conntrack_timeout: use nf_ct_iterate_destroy() to cleanup timeout going away
Date: Tue, 19 May 2026 23:38:25 +0200
Message-ID: <20260519213826.1181661-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260519213826.1181661-1-pablo@netfilter.org>
References: <20260519213826.1181661-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nf_ct_iterate_cleanup_net() is not sufficient, this is just a subset of
nf_ct_iterate_destroy_net(), which deals with flushing skb with
unconfirmed conntrack entries sitting in nfqueue, and it also
invalidates the timeout extension.

Fixes: 34158151d2aa ("netfilter: cttimeout: use nf_ct_iterate_cleanup_net to unlink timeout objs")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_conntrack_timeout.c | 7 +------
 net/netfilter/nft_ct.c               | 1 -
 2 files changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/netfilter/nf_conntrack_timeout.c b/net/netfilter/nf_conntrack_timeout.c
index 0cc584d3dbb1..006e8bcf129b 100644
--- a/net/netfilter/nf_conntrack_timeout.c
+++ b/net/netfilter/nf_conntrack_timeout.c
@@ -44,12 +44,7 @@ static int untimeout(struct nf_conn *ct, void *timeout)
 
 void nf_ct_untimeout(struct net *net, struct nf_ct_timeout *timeout)
 {
-	struct nf_ct_iter_data iter_data = {
-		.net	= net,
-		.data	= timeout,
-	};
-
-	nf_ct_iterate_cleanup_net(untimeout, &iter_data);
+	nf_ct_iterate_destroy_net(net, untimeout, timeout);
 }
 EXPORT_SYMBOL_GPL(nf_ct_untimeout);
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index fa2cc556331c..3fdee729149b 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -971,7 +971,6 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	struct nft_ct_timeout_obj *priv = nft_obj_data(obj);
 	struct nf_ct_timeout *timeout = priv->timeout;
 
-	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
 	kfree_rcu(priv->timeout, rcu);
-- 
2.47.3

