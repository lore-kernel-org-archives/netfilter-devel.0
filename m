Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34B9744471A;
	Mon, 10 Aug 2026 19:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390841; cv=none; b=h0jgfpTsFNmmFSrUyTyfnR+t3SUOp87HCRg0XxWkm5KmO97XXECyMoGsYGF3ijpwfS4TAeYzGlucpizd7wOADjZiq+McL+fU23KL3HIlPO/MFJ/APmwzalIggLOGVl6B/F0uufEaYuYlfO82z3n9pg4VbjG/cdgeIhTpCvzjOyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390841; c=relaxed/simple;
	bh=KKPUvDkTrIvERz/QM1ypQpn3/aTzDkNbgTwF47ErCwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KP14RLfXroBs6Y4fYyk5Ytj+WTvqOf+6R3ylnMY8HOY9D0D8xPBsthibWcH1MMCORCiOv4WaB2tYmHwB9Nlug0CExId5g7m90VzLFQ8/t/3yEWEWbE6b/0fumdocGKWSGwX93ODqIRyn9XkRWuvg+xQufZS4LGTJy5Schm8s21k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hMG3x4xd; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hMG3x4xd"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3A24C601A5;
	Mon, 10 Aug 2026 21:40:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1786390826;
	bh=trQHJooCQ5lup/koR52V/MP2UjLFjPE/GOuAaH+/DQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMG3x4xdPCWBiwNHsXsDTbA1+rQ+RqGMvwryreayXJJ0FZKozQu85ILUU1EimYgFY
	 60RcDeeOv1EKcLPZV0RnHYtYTSn2RCVyWFN2jz8SKPURZuF8/thY6a+7K6qgtzrdDx
	 gfFnFMkId3HwIkN8AfbVlMrrJoYA8Q7mfcuoHjkwzqmuZpMjPLwJLmWS/cy+kYI1zY
	 Vu2+uEOJf1Ka7RZ2fsCREaV8PcYMFlMJjH5/G37gNotLnaWVVxUZANRyIYBc1VTTey
	 xfIVbIQ68520AbmVbj9D0tD+jPcJkH/nkWrf71t9vCeEPWgtMhCGSj4VxQnRDJXbp9
	 UcsmaC3Nn8k+A==
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
Subject: [PATCH net-next 02/12] net: pass net_device_path_ctx to dev_fill_forward_path()
Date: Mon, 10 Aug 2026 21:40:05 +0200
Message-ID: <20260810194015.932627-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260810194015.932627-1-pablo@netfilter.org>
References: <20260810194015.932627-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

Refactor dev_fill_forward_path() to take a struct net_device_path_ctx
pointer instead of a (dev, daddr) pair, so the caller can build and
populate the context up front and keep it after the forward path walk.

This allows additional fields (e.g. vlan and ether_type) to be carried
in the context and shared with ndo_fill_forward_path implementations,
instead of being reconstructed on the stack inside the core helper.

Update the mtk_ppe_offload, airoha_ppe and nf_flow_table_path callers to
allocate and fill the context before invoking dev_fill_forward_path().
The network topology resolution behaviour is unchanged.

This is a preliminary patch to enable HW flowtable offload for IPv4
over IPv6 tunnels.

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c       |  7 ++++++-
 .../net/ethernet/mediatek/mtk_ppe_offload.c    |  7 ++++++-
 include/linux/netdevice.h                      |  2 +-
 net/core/dev.c                                 | 18 +++++++-----------
 net/netfilter/nf_flow_table_path.c             |  7 ++++++-
 5 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index a03af9750573..92611802801e 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -283,14 +283,19 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 				    struct airoha_wdma_info *info)
 {
 	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct net_device_path *path;
 	int err;
 
 	if (!dev)
 		return -ENODEV;
 
+	ether_addr_copy(ctx.daddr, addr);
+
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(&ctx, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index 771d9118f94a..99b28aaa7cc4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -92,6 +92,9 @@ static int
 mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_info *info)
 {
 	struct net_device_path_stack stack;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct net_device_path *path;
 	int err;
 
@@ -101,8 +104,10 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 	if (!IS_ENABLED(CONFIG_NET_MEDIATEK_SOC_WED))
 		return -1;
 
+	ether_addr_copy(ctx.daddr, addr);
+
 	rcu_read_lock();
-	err = dev_fill_forward_path(dev, addr, &stack);
+	err = dev_fill_forward_path(&ctx, &stack);
 	rcu_read_unlock();
 	if (err)
 		return err;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index db9dce7f0aa6..17d28adb029b 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3428,7 +3428,7 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack);
 void dev_fill_forward_path_release(struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index fd0b445f5d38..1755dd0b2a92 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -769,35 +769,31 @@ void dev_fill_forward_path_release(struct net_device_path_stack *stack)
 }
 EXPORT_SYMBOL_GPL(dev_fill_forward_path_release);
 
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
 			goto err_out;
 
 		memset(path, 0, sizeof(struct net_device_path));
-		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
+		ret = ctx->dev->netdev_ops->ndo_fill_forward_path(ctx, path);
 		if (ret < 0)
 			goto err_out;
 
 		stack->num_paths++;
-		if (WARN_ON_ONCE(last_dev == ctx.dev))
+		if (WARN_ON_ONCE(last_dev == ctx->dev))
 			goto err_out;
 	}
 
-	if (!ctx.dev)
+	if (!ctx->dev)
 		return ret;
 
 	path = dev_fwd_path(stack);
@@ -805,7 +801,7 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		goto err_out;
 
 	path->type = DEV_PATH_ETHERNET;
-	path->dev = ctx.dev;
+	path->dev = ctx->dev;
 	stack->num_paths++;
 
 	return 0;
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 56219b02e122..0cbde535b8ba 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -49,6 +49,9 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 {
 	const void *daddr = &ct->tuplehash[!dir].tuple.src.u3;
 	struct net_device *dev = dst_cache->dev;
+	struct net_device_path_ctx ctx = {
+		.dev = dev,
+	};
 	struct neighbour *n;
 	u8 nud_state;
 
@@ -71,7 +74,9 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 		return -1;
 
 out:
-	return dev_fill_forward_path(dev, ha, stack);
+	ether_addr_copy(ctx.daddr, ha);
+
+	return dev_fill_forward_path(&ctx, stack);
 }
 
 struct nft_forward_info {
-- 
2.47.3

