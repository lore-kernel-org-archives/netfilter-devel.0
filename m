Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4E57F726
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Sep 2026 22:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790202130; cv=none; b=k0G+EqYsnEiHCqjGS3K28OGqXLZAMEw1iSD/kIDBPQoGp5mT8IhQPDrjVoEzVo/b/iNP70PIsYKnjuNs2rpyH+Pgkld/B+0+j9niffDbgD5Ufbc9VSpBqjqQfhq1xsGVJzVTfibwzuFJQKKPa6+yf4XNemrvGBGkHN6Myjfv9/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790202130; c=relaxed/simple;
	bh=6RlFtEPGFBf6D5KYM++jS6O1bF7vHSrg7feGW7nbnOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MkhWTtpJcIlZ8F1+PTiF/5ZmJbzZBlkqngIZfyUCbToZMCTdp6o9ycrOTjbQom+yvqI26gdEpef9VV8VFgiNTdJptIURCSsFwVvcYtdVeyBCF3++R/lonIT/9RspQDttLJpuVGP0Q1YIVQIJZiLxlCy5YOaX/tEOvM86jcTNMs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=GcEceRJD; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="GcEceRJD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790202125;
	bh=f2pC+PGMeB0AmfOPeld1oZ6/MH0mYTo377ET5VSf+3E=;
	h=From:To:Cc:Subject:Date:From;
	b=GcEceRJD3Vo4Bz/ibm4KbyceMoJNK6Bgui4ZFwd47Hom9LE3SHYbOHc/NMWSpSoJM
	 /S5/7BAj8guzxnUKZYVKJd5K4e0S6HrIb5XCRINA93piFuz+kfUktx4/GDqxD+PvKF
	 auGWzDXSYdPowFsquo25eS0C4Yj0S27FqE0bWN5GTQRD5XBvJPxRclokTuFc+7KJue
	 JJKkDphEGNJWHS7CXvgmhJ9wMPX836c/vXuATiE5kChRGL9rZcv4iz/zSJ4by1U243
	 SUCIxPbhOtPxSd91RTXLi6Hc71LKn+VUHTvi9PDe/18etrDjkC/nJgdh0mcoIrqVN6
	 nZF1+dvgpNOaA==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id DE4EC6008C;
	Thu, 24 Sep 2026 00:22:04 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: hauke@hauke-m.de
Subject: [PATCH nf,v2] netfilter: flowtable: restore wireless forward path
Date: Thu, 24 Sep 2026 00:22:00 +0200
Message-ID: <20260923222200.72932-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before commit 871df5007eda ("netfilter: flowtable: bail out if forward
path cannot be discovered"), there was a fallback to set up a forward
path in case .ndo_fill_forward_path fails or DEV_PATH_MTK_WDMA was used.
Such fallback was used by commit d787a3e38f01 ("mac80211: add support
for .ndo_fill_forward_path").

One possibility is to handle DEV_PATH_MTK_WDMA from the flowtable
forward path discovery. However, this is only used internally by drivers
to retrieve mtk_wdma information to set up hardware offload. Felix
decided to use the .fill_forward_path interface for this purpose due to
the lack of a better interface at that time.

Add a new DEV_PATH_IEEE80211 path which is offered if the new ieee80211
flag is set on in the struct net_device_path_ctx to restore the
flowtable with a ieee80211 netdevice. Handle this new DEV_PATH_IEEE80211
path just like DEV_PATH_ETHERNET and DEV_PATH_DSA, ie. this is the last
netdevice in the stack.

This new flag ieee80211 flag is implicitly unset for mtk_ppe and airoha
which call dev_fill_forward_path() to retrieve a DEV_PATH_MTK_WDMA path.

Fixes: 871df5007eda ("netfilter: flowtable: bail out if forward path cannot be discovered")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: use ctx->ieee80211, not path->ieee80211.

 include/linux/netdevice.h          | 3 +++
 net/mac80211/iface.c               | 7 +++++++
 net/netfilter/nf_flow_table_path.c | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87cafc932e9e..3cff2174dc03 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,6 +887,7 @@ enum net_device_path_type {
 	DEV_PATH_DSA,
 	DEV_PATH_MTK_WDMA,
 	DEV_PATH_TUN,
+	DEV_PATH_IEEE80211,
 };
 
 struct net_device_path {
@@ -953,6 +954,8 @@ struct net_device_path_ctx {
 		u16		id;
 		__be16		proto;
 	} vlan[NET_DEVICE_PATH_VLAN_MAX];
+
+	bool			ieee80211;
 };
 
 enum tc_setup_type {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 889c32fd8de1..c5584435fde9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1023,6 +1023,13 @@ static int ieee80211_netdev_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
+	if (ctx->ieee80211) {
+		path->type = DEV_PATH_IEEE80211;
+		path->dev = ctx->dev;
+		ctx->dev = NULL;
+		return 0;
+	}
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(ctx->dev);
 	local = sdata->local;
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..d90013685bf1 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -53,6 +53,7 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 	struct net_device_path_ctx ctx = {
 		.dev = dev,
 		.ether_type = ether_type,
+		.ieee80211 = true,
 	};
 	struct neighbour *n;
 	u8 nud_state;
@@ -114,6 +115,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 		path = &stack->path[i];
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
+		case DEV_PATH_IEEE80211:
 		case DEV_PATH_DSA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
@@ -123,6 +125,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
 			if (path->type == DEV_PATH_ETHERNET ||
+			    path->type == DEV_PATH_IEEE80211 ||
 			    path->type == DEV_PATH_DSA)
 				break;
 
-- 
2.47.3

