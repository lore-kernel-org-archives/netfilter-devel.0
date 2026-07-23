Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25276396B6F
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jul 2026 17:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784829004; cv=none; b=nLNKC+zegUzX8L086z0AyNq1g/WRJjNaY1uu/bsQZq/Uw3bEEJ6Qn1esfeDglMVHibC5TEVVpz640UJgxvaFpnXthZZw4Xa/5F5sK10JW9moNdLgH7+dTLwTpxXjfp47lkxQMPtCOIsKRfffV/Bw4TbPMqtvYHGrSGabb1s2Y44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784829004; c=relaxed/simple;
	bh=BQruaFUm5Z5L9JCKpPw6qmDnoMedv2/Ya3jm75ltPcU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eRTecCkn2S8n6jHMezK2LFc1kfgo98jJ++uJM4c5hnOI58H6X0trDrBXFwkgSE9NIqv4cf5PObY1jea+tSh23I5qadvhacVwJMK0zXC5SP2p1DZCs2xRzCk2XKV+0LAvyVCNbCnTOSdnQAwZ3xjJ/XhY1tn1m+ttjCHeMZQ3WtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=XCsELZu2; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="XCsELZu2"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 03F986019E;
	Thu, 23 Jul 2026 19:49:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1784829000;
	bh=9OtzmecMEuiCQl3+s02sP92xIayUfNwl4P5rgYqT++0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCsELZu2tbEmc2VkZYkiyq9jLTEt3u6Xm/RH/BC972nvV0nY3rwaQK5JMDGoJJ06a
	 e3j3sRn7rLAtzl0MHbl0L4TKDE/yeECHF8um4dLuzB9qoKPIdbIzTVydqNv8HrBwaB
	 bcp2DP+aFr0jwl10QeVa+awOfM4e0b7AW2VrqK6VGdzfoBWdOMc0C86DXs/24jeXkv
	 PB3PPgTHCmNDvJ2A3ItKbETIaTn1J2DpDExqRU5BWHzmZZlPmYinNqPhTGpm50MSMF
	 6PMXy9s7EipQLDRDr6WbYnDJggL9dnXtlWXVWWM5M57NsfoXYPnjd1GTEizScXtzpg
	 nMor6HG9kBVVA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next 3/4] net: pass dst via net_device_path in dev_fill_forward_path()
Date: Thu, 23 Jul 2026 19:49:51 +0200
Message-ID: <20260723174952.329650-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260723174952.329650-1-pablo@netfilter.org>
References: <20260723174952.329650-1-pablo@netfilter.org>
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

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h |  1 +
 net/core/dev.c            | 45 +++++++++++++++++++++++++++++++--------
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8db25b79573e..30dc78b4f1a3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -902,6 +902,7 @@ struct net_device_path {
 			};
 
 			u8	l3_proto;
+			struct dst_entry *dst;
 		} tun;
 		struct {
 			enum {
diff --git a/net/core/dev.c b/net/core/dev.c
index c1c1be1a6962..fed101f54a8a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,6 +750,23 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
+static void dev_fill_forward_path_release(struct net_device_path_stack *stack)
+{
+	struct net_device_path *path;
+	int k;
+
+	for (k = stack->num_paths; k >= 0; k--) {
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
+
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack)
 {
@@ -765,28 +782,38 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 	while (ctx.dev && ctx.dev->netdev_ops->ndo_fill_forward_path) {
 		last_dev = ctx.dev;
 		path = dev_fwd_path(stack);
-		if (!path)
-			return -1;
+		if (!path) {
+			ret = -1;
+			goto err_out;
+		}
 
 		memset(path, 0, sizeof(struct net_device_path));
 		ret = ctx.dev->netdev_ops->ndo_fill_forward_path(&ctx, path);
 		if (ret < 0)
-			return -1;
+			goto err_out;
 
-		if (WARN_ON_ONCE(last_dev == ctx.dev))
-			return -1;
+		if (WARN_ON_ONCE(last_dev == ctx.dev)) {
+			ret = -1;
+			goto err_out;
+		}
 	}
 
 	if (!ctx.dev)
-		return ret;
+		goto err_out;
 
 	path = dev_fwd_path(stack);
-	if (!path)
-		return -1;
+	if (!path) {
+		ret = -1;
+		goto err_out;
+	}
 	path->type = DEV_PATH_ETHERNET;
 	path->dev = ctx.dev;
 
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

