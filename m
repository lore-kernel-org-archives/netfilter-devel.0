Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8CA3A872E
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 10:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678058; cv=none; b=uBU+EuLwJpSqBq1p1oYZofRfRrOY7AA48As8Q4lULcvcqc0B7TqSnsb8lsVp2iVydchckidIk3oUsJi6teFDocR8QK2l2OTS/CQZL7HM8qpxi8b657K3JUXkl2W60fj4frInRSmfWlNg902uE8Bulyfji16eDjEy93kjaWUSMLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678058; c=relaxed/simple;
	bh=b8eAT8k6CLUr6GpU+MZ4ZxhNZVW4D9437c57rjiUOgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSwUToiO3wXwkkyUjn6tn+PGdDx9ProcMlNvO4AL0kQpwKUM87jxlLYOV2tliZNvLHz5haHF/wHgqOatQpa8hko6P51ZdG+t+AaPxihKEBInrcqALwkKP32ToEYAgYNuExc4yEoCGU7NxNTK/mdahRBg29s2Zz/epROeomHR5oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kD3oANjT; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kD3oANjT"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5C8126057D;
	Fri, 10 Jul 2026 12:07:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783678054;
	bh=bDAwd2KVaer05t6SimrJxe1tq5a2RptuvmtSasn1J70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kD3oANjTMtgxU1F8C+1h+qTotq62T3bUsODZNDhe9eB+IGDrwSwflI9ROTEoJzT0q
	 cL/e6CLy8+3pWTot3P7VG+i5iGupvMXqJ8PA8sM6QWCAQHcgAGdeNVXceJ5hMM36zP
	 wBROA1e7yZlST6nbKKd8MdbDY/+KuvjnDhd4vsb2DiIYXPEQfn+XHktzpduYlmmJ/0
	 U1d+kA6Cbjd5NQyGZ+OWwzfUaTp5/Z8a2R5sZetdMnCha7RNKDl1oeB+slMCeN30Fu
	 fGTgMR923TunB2aY+me4geXCC1XSrFl3jFtyq/O/8+VN/CRql0/7eWv0JUiUpJzBWG
	 aD6uej1Cx3Lpw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: razor@blackwall.org,
	ericwouds@gmail.com,
	fw@strlen.de
Subject: [PATCH nf-next,v2 1/3] net: pass net_device_path_ctx struct to dev_fill_forward_path()
Date: Fri, 10 Jul 2026 12:07:27 +0200
Message-ID: <20260710100729.1383580-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710100729.1383580-1-pablo@netfilter.org>
References: <20260710100729.1383580-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Generalize dev_fill_forward_path() so it can be used by the bridge
family to retrieve the bridge vlan filtering information from the
bridge port when discovering the bridge flowtable path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - move nft_dev_fill_forward_path_init() call after out: goto tag
      to fix a crash otherwise in the existing flowtable ip family.

 include/linux/netdevice.h          |  2 +-
 net/core/dev.c                     | 18 +++++++-----------
 net/netfilter/nf_flow_table_path.c | 14 ++++++++++++--
 3 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9981d637f8b5..db04b6d2e8d2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3420,7 +3420,7 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 714d05283500..24c384ef9e78 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,41 +750,37 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack)
 {
 	const struct net_device *last_dev;
-	struct net_device_path_ctx ctx = {
-		.dev	= dev,
-	};
 	struct net_device_path *path;
 	int ret = 0;
 
-	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
 	stack->num_paths = 0;
-	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
-		last_dev = ctx.dev;
+	while (ctx->dev && ctx->dev->netdev_ops->ndo_fill_forward_path) {
+		last_dev = ctx->dev;
 		path = dev_fwd_path(stack);
 		if (!path)
 			return -1;
 
 		memset(path, 0, sizeof(struct net_device_path));
-		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
+		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
 		if (ret < 0)
 			return -1;
 
-		if (WARN_ON_ONCE(last_dev == ctx.dev))
+		if (WARN_ON_ONCE(last_dev == ctx->dev))
 			return -1;
 	}
 
-	if (!ctx.dev)
+	if (!ctx->dev)
 		return ret;
 
 	path = dev_fwd_path(stack);
 	if (!path)
 		return -1;
 	path->type = DEV_PATH_ETHERNET;
-	path->dev = ctx.dev;
+	path->dev = ctx->dev;
 
 	return ret;
 }
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 98c03b487f52..5455149e5d9a 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -42,6 +42,14 @@ static bool nft_is_valid_ether_device(const struct net_device *dev)
 	return true;
 }
 
+static void nft_dev_fill_forward_path_init(struct net_device_path_ctx *ctx,
+					   const struct net_device *dev, const u8 *daddr)
+{
+	memset(ctx, 0, sizeof(*ctx));
+	ctx->dev	= dev;
+	memcpy(ctx->daddr, daddr, sizeof(ctx->daddr));
+}
+
 static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 				     const struct dst_entry *dst_cache,
 				     const struct nf_conn *ct,
@@ -50,6 +58,7 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
 	struct net_device *dev = dst_cache->dev;
+	struct net_device_path_ctx ctx;
 	struct neighbour *n;
 	u8 nud_state;
 
@@ -70,9 +79,10 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 
 	if (!(nud_state & NUD_VALID))
 		return -1;
-
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	nft_dev_fill_forward_path_init(&ctx, dev, ha);
+
+	return dev_fill_forward_path(&ctx, stack);
 }
 
 struct nft_forward_info {
-- 
2.47.3

