Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202A540B6D9
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503192; cv=none; b=lltCkuQeojUbfP9eI8VB39Rr6vE8HGZV+k0g6qNxX34fBUwbbJkRAuDfArHLTae50nc1+0H/Md79uWDhj9MU4bzy17bNFGf7tYREQwQEWnEe3CAS/gZAsGjmqlVd7NMxbjA9sFSx/6mj5xO1BU1cAbDXQQjvB89sEdYAE0eROuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503192; c=relaxed/simple;
	bh=/9n6elf9/QQyUIYk6CFJr+wuZ0dhotKnak9tKLwKfGw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQN2wF+cC1f3nY5xQXCW2vrGbmDwTM5S1/iWWXh3pmVysQ3UyK/uOQRJ5Pj1/isbF3W1fSaeBpn4eP2QoGMxr+OpEzWG2NJMXOvndkJPlCLM8TdvUR0Xt45KUNs5fdhVPQQsP2Q/3QNypNLPWRVA8WZjZoqEbGH5oXSD0JCF2ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=berYGJRj; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="berYGJRj"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 8E82B6057E
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 11:32:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783503177;
	bh=4m0Pf/sAFsxmsWuLaEObSKxzqCHTbZXeK3abW83sgd4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=berYGJRjNw65HYjlbLlY+NozsLVbV1JNUx4qSa3xR0AiV308+gJPEw8r1IYCV8Uj5
	 JLKV/lH7eLHUTFjLsJunP98qR9Yfto1yzZ5vJclIAmBWvanflGv9apX85E28ziNnMf
	 2vUFj++eXDt4KYFhXASCjbVdoHXTZY6ehLxU1abFaTko6lvKzr9MyKqsqofT4XOnSi
	 qv7QuKZSqme7dAdlbGIzAqCVs/72JLYY+gxoDQhldQ0t4bw5kPfFJgKO3tDBTq+PTp
	 8MR1IU4hcjL0guvTbyCy9E177gtAnTLE8L2eAeoI/g89/dzYxlki5zLbXtsxVhcgT7
	 JeOEXeA3uo0gg==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 2/4] net: pass net_device_path_ctx struct to dev_fill_forward_path()
Date: Wed,  8 Jul 2026 11:32:48 +0200
Message-ID: <20260708093250.1187068-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708093250.1187068-1-pablo@netfilter.org>
References: <20260708093250.1187068-1-pablo@netfilter.org>
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
v1: A different approach compared to Eric Woudstra's proposal to
    add another function to the net core for the bridge case.
    I am leaning towards making a simple generalization and keep
    the bridge vlan filtering path discovery special case under
    the flowtable at this stage.

 include/linux/netdevice.h          |  2 +-
 net/core/dev.c                     | 18 +++++++-----------
 net/netfilter/nf_flow_table_path.c | 12 +++++++++++-
 3 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 07bf265d0295..41cd092b032c 100644
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
index 4b3d5cfdf6e0..9a065c286d92 100644
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
index 98c03b487f52..007e9781902a 100644
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
 
@@ -71,8 +80,9 @@ static int nft_dev_fill_forward_path(const struct nf_flow_route *route,
 	if (!(nud_state & NUD_VALID))
 		return -1;
 
+	nft_dev_fill_forward_path_init(&ctx, dev, ha);
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	return dev_fill_forward_path(&ctx, stack);
 }
 
 struct nft_forward_info {
-- 
2.47.3

