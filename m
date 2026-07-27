Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C48F3FD147
	for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2026 11:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785153592; cv=none; b=OW0sIxtsjzgw0t6bR9vMFg+due5Wsin14RL9K+O+HfF1AhP+8rndi5dZmdmPdBhTfLM6gf+gJmqCogTksyN4447XPS8lFBDlF/AzQIqXrvbr4/zfVElCbEL99IcC4ZQNd/t5ChrrweWbI5XZUveK3/kek/UkNb0VIfDZDF5Qegw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785153592; c=relaxed/simple;
	bh=zDcSjzHAHs1gHDKRxRSSNtnrsNgVheEqaelrgn3g008=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJYgicox9MkFS5zKki6bcTGuLdSr029RsDYnPAauVjVxwdfadhk5t+FqOLwEF265yydS06o3W1PLBghLfHn7uDgQ6U3wiHLmeieJ/eLj15bvzii2Klo5BtEvTW+ZlVQWFD/jYeYNpTyNXSh/jZNLTuXkmXjL9CuDbk8zEiYYkX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=f43Uj21J; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="f43Uj21J"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C7D2B601A5;
	Mon, 27 Jul 2026 13:59:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1785153583;
	bh=RxNAIXHJyHEa1ODbUnSfLn41a6K+AzheEQkdQSdGxKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f43Uj21JWwdta8kNYTpLgq2ZrSI980Ydd5pKcvvigcayjuSAzsWhJ070xhHpksJ3w
	 gWlQTeSizox8kNl7URq3g4V4iBMkR2MrjSXkG+xPCdtJ/rczFkLhJWrb9SlvPHoJG7
	 znJJQTZWELL20LKBi+1q2MEslvnMIt3CPfWEC2yamO3a77COWhi2sXh1ANHtQ6eMFG
	 m9VYrv9/YkYW89FsVKQeMlFTZt06ZV7nblzBFqrh6j6A1bvvBc2jo7W6sNcYf3FwQz
	 a7b0CwmaJZa6NWfoN3HXni11x00UeVh+jCX2lFpnSJ8LQN1y6M69mASJU2rw/sc7+1
	 DLda/zqXXrkmw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: lorenzo@kernel.org
Subject: [PATCH nf-next,v2 4/5] net: pass dst via net_device_path in dev_fill_forward_path()
Date: Mon, 27 Jul 2026 13:59:31 +0200
Message-ID: <20260727115932.88335-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260727115932.88335-1-pablo@netfilter.org>
References: <20260727115932.88335-1-pablo@netfilter.org>
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
on the tunnel device route, in case of error out. Export it so it can be
use in case of error out, to drop the refcount on the tunnel route at a
later stage.

Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: - move dst field in net_device_path at the beginning of tun field per Lorenzo
    - fix dev_fill_forward_path_release() initial index value
    - remove useless ret assignment per Lorenzo

 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 36 +++++++++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 5 deletions(-)

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
index ca65d1dcd604..b6e3700b674f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,6 +750,27 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
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
@@ -766,16 +787,16 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
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
@@ -783,12 +804,17 @@ int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 
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

