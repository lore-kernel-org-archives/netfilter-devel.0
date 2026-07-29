Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F3D47A0B8
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 11:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785325799; cv=none; b=d78aC4MU09OMOsdAyA/07/cCSMK4H44bPA9BSA0aIR6vZcJJfplF0Qx7vt4M/xLl209MwZpc/etO2+HrRUR1RoolEq906UI8SR/C0BrQhrSoeCfiThaoipxvcwhWMEUacVUo7byTDqJjx0ZFJWUCg7P7YhEj5VkvZ5s7fuwsZc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785325799; c=relaxed/simple;
	bh=izTvX/Q/gqeKVnj1vp/hOVVm/GzcgP3yjWI3qO+JOtk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lBOzu/PkKVOFRKiYvIkcqCNitE2pfSoaiCiQ2vEbe8HAdxy8ie0g12DIWgK3CigyLG8MO5R+IqgiGkovSMTcvejp+czTEi361Ca+ohn8JPm/3o7A3QjthdnHoMMcwSUhFMIfqyoo6vsw8/p+0zy6PhowqA97yBdWwi+VInxnV6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=K1xNeNcP; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="K1xNeNcP"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id BF89A60192
	for <netfilter-devel@vger.kernel.org>; Wed, 29 Jul 2026 13:49:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785325796;
	bh=iAt1xTFReeYwRJiAl6dISk6Vx+8wSgTYFn91DaBebUg=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=K1xNeNcPhbPk2jmgsuPbFcEVLO+WKoms3cnTYkXJhwrb23bFXTzh6ynNVu5Fd+Otp
	 Rb27xdun9GwhHE4/o8rYKJwAYOV7LGVNN7K5IN9QyubbAM/oUkpr0e7KiJRbrUDAyp
	 cqF+mKzhCbnN6Yk4/cQRUcxWxxyheus2HTOEBB0Bxs7nhQThbgYFta8MDZc8L3thWa
	 qBU6LtwBgzw+I8kitRYxhq+5uwVPfeUexVlx+AObZ1VzoEt1y2Nk//ooeocNwjSGfp
	 muneBjbfwnro5AOHEtRdeOO772CxYOPTjDdunmbBWMNmXdZnZKmBv71Wmp9BqvksNF
	 oddG31DDeXR+g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v5 5/6] net: pass dst via net_device_path in dev_fill_forward_path()
Date: Wed, 29 Jul 2026 13:49:46 +0200
Message-ID: <20260729114947.403782-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729114947.403782-1-pablo@netfilter.org>
References: <20260729114947.403782-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add dst_entry to tunnel device path, this will allow us to remove
a duplicated route lookup.

This is a preparation patch to retrieve the tunnel route directly
from the .fill_forward_path. This new dst_entry in the tunnel will be
used by a follow up patch.

Since dst_release() works fine on NULL interface, this is still
noop until the flowtable starts using this.

Add a new dev_fill_forward_path_release() function to drop the refcount
on the tunnel device route and use it in case of error out. Export it so
to drop the refcount on the tunnel route at a later stage.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v5: call dev_fill_forward_path_release() for safety, but no dst should
    be ever seen in this path.

 drivers/net/ethernet/airoha/airoha_ppe.c      | 10 ++++--
 .../net/ethernet/mediatek/mtk_ppe_offload.c   | 10 ++++--
 include/linux/netdevice.h                     |  2 ++
 net/core/dev.c                                | 36 ++++++++++++++++---
 4 files changed, 47 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index e4c3644dd6ec..8599f22b762f 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -293,14 +293,18 @@ static int airoha_ppe_get_wdma_info(struct net_device *dev, const u8 *addr,
 		return err;
 
 	path = &stack.path[stack.num_paths - 1];
-	if (path->type != DEV_PATH_MTK_WDMA)
-		return -EINVAL;
+	if (path->type != DEV_PATH_MTK_WDMA) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	info->idx = path->mtk_wdma.wdma_idx;
 	info->bss = path->mtk_wdma.bss;
 	info->wcid = path->mtk_wdma.wcid;
+err_out:
+	dev_fill_forward_path_release(&stack);
 
-	return 0;
+	return err;
 }
 
 static int airoha_get_dsa_port(struct net_device **dev)
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
index cc8c4ef8038f..771d9118f94a 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe_offload.c
@@ -108,16 +108,20 @@ mtk_flow_get_wdma_info(struct net_device *dev, const u8 *addr, struct mtk_wdma_i
 		return err;
 
 	path = &stack.path[stack.num_paths - 1];
-	if (path->type != DEV_PATH_MTK_WDMA)
-		return -1;
+	if (path->type != DEV_PATH_MTK_WDMA) {
+		err = -EINVAL;
+		goto err_out;
+	}
 
 	info->wdma_idx = path->mtk_wdma.wdma_idx;
 	info->queue = path->mtk_wdma.queue;
 	info->bss = path->mtk_wdma.bss;
 	info->wcid = path->mtk_wdma.wcid;
 	info->amsdu = path->mtk_wdma.amsdu;
+err_out:
+	dev_fill_forward_path_release(&stack);
 
-	return 0;
+	return err;
 }
 
 
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8db25b79573e..62cfad7e6b79 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -892,6 +892,7 @@ struct net_device_path {
 			u8		h_dest[ETH_ALEN];
 		} encap;
 		struct {
+			struct dst_entry *dst;
 			union {
 				struct in_addr	src_v4;
 				struct in6_addr	src_v6;
@@ -3427,6 +3428,7 @@ int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
+void dev_fill_forward_path_release(struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 429a55fff667..e50ed677de72 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -748,6 +748,27 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[stack->num_paths];
 }
 
+void dev_fill_forward_path_release(struct net_device_path_stack *stack)
+{
+	struct net_device_path *path;
+	int k;
+
+	if (stack->num_paths == 0)
+		return;
+
+	for (k = stack->num_paths - 1; k >= 0; k--) {
+		path = &stack->path[k];
+		switch (path->type) {
+		case DEV_PATH_TUN:
+			dst_release(path->tun.dst);
+			break;
+		default:
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL_GPL(dev_fill_forward_path_release);
+
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack)
 {
@@ -764,16 +785,16 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 		last_dev = ctx.dev;
 		path = dev_fwd_path(stack);
 		if (!path)
-			return -1;
+			goto err_out;
 
 		memset(path, 0, sizeof(struct net_device_path));
 		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
 		if (ret < 0)
-			return -1;
+			goto err_out;
 
 		stack->num_paths++;
 		if (WARN_ON_ONCE(last_dev == ctx.dev))
-			return -1;
+			goto err_out;
 	}
 
 	if (!ctx.dev)
@@ -781,12 +802,17 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 
 	path = dev_fwd_path(stack);
 	if (!path)
-		return -1;
+		goto err_out;
+
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
 	stack->num_paths++;
 
-	return ret;
+	return 0;
+err_out:
+	dev_fill_forward_path_release(stack);
+
+	return -1;
 }
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
-- 
2.47.3

