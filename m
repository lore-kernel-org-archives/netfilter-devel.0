Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D813955C1
	for <netfilter-devel@vger.kernel.org>; Tue, 30 Jun 2026 06:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782802681; cv=none; b=PHdY+tKjQEisDQ4Iuz0rblf66JtU5NhPaE5xdiAOf9uLcaRFaVbvKirCVGMYQdeSFPO4n2thxPzuu6Uj8pqm0uSwUghDz7jGmLcroem/tvyNXHADlMDtbo+ek1mZJRF2xILez9oQl+MJtMhyVmx+PWfoZzlRve0/DU1vLMo/z7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782802681; c=relaxed/simple;
	bh=WcFkxaVMJf7ZgRBObx+1aS9zIXt/5dWF7LgNn09k1r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oUnzQ/JQGB71olcJYa21S1X0Lw1Gx1WscSp9eMOEIU/Z4CQujHSF/hH0i3EipfNnTQgjnuofSOgObb5V94XBk8bcsI3X6Jhw2qr7nTjv+UkoX24IZIIR+yfpn1EOJDyKYvMtyO1mAU/xtwA1Crb7V77gUDjSeV/RtbSG5fsIEAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ew0SOnNa; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ew0SOnNa"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-47488efcf30so837623f8f.3
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 23:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782802678; x=1783407478; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0NF38joMTzvz8Moy3DTutVlP+ZtXdrf3nZbhlmDRZw=;
        b=ew0SOnNarxE9arhuOeOHtZyaQarGhsUqp0iU8JIXqyPCtwXd8a9JsZgpI6breOHEc6
         l6kA6PcB1yTxly5//vfuBz+XPU+ifFHuGu+NldH/irFL0OCrRbcef6/VVaBU8Kd+4TyH
         joisyPqvMChmxwqU4P7yLVIugNcDlRepCgCCCNtdyHHYuqkq5HZZ0C+gYkBef5B2TGEQ
         64qnBhtSkxnbw2iWQEGtKcn9zyqn/Oh5lFoo7udDQQ8cwmrtNJK7v7xMJpmlvvr43HbU
         3fFgmGT05C00JDSLKrx5hwZxVYv91kYElFLPVuCgiWiLboiXqMWVGSPe5Je8zkKmfebm
         Zv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782802678; x=1783407478;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l0NF38joMTzvz8Moy3DTutVlP+ZtXdrf3nZbhlmDRZw=;
        b=VYFem6nf5WUh1cEfoUjG3DAV6QDW6W39qNwsmu1Z7cwnnHxbgiCNdl71TlSCI15Hv/
         RZF49yuW9slzLbQKg2Jall8b1SrF6JxWvp+fscXxNmQqD/XHMNODQwoNL8yCPgIBn/xi
         WGdafAkUrRDHtf92sm3HeXh45k3jEj9kBZPBr/cQMuueBdeRQjpIWQktKviJs50l9bYu
         LiQI6z8B8gFPWWqanH8EBXe1HhhF4lQBFCwAUYyBnoHxOinmvn2CuQrZND3PkzgPSCP8
         9CWldigC4HhJb3aWJZ1dpNvjmC86CLVBvO+jtpYQ9GoHA8wmqYpeF9Owpnrl+z3Oc8Ar
         HRsA==
X-Gm-Message-State: AOJu0YwLHkjws4md6ttBKD18l+Hcv0WThcaNFRil4Enk+4yrwKTaCuI1
	uNk95VYZFfnGRSjrmPuc+Po2M15R2ith6exNvgsGsL8ee/qm9IkFZSO5zbqJP3Is
X-Gm-Gg: AfdE7clAC3W+L9O5nJnbT+d+ypNM7SUTyMcv9849sUQIcSOxlrmBodxIxwwYN/H9fpj
	hYBFb1vTUh651Hgvck1zQSM67CuYUGdE2zgzxv2j/ya+Ct6oIvfgHkITbinxBn8z2t+ri+Th3O9
	URgX2+qA+iIQ09RHWoPryiGPVKKAtFFWCZRARp74dwyU1OS64ntuY7IbZrLe/LiBXA+dBEMC9/C
	JRggy5nekLQQyaGno3COILflYn/+EysumEaqckRqC40f8FPPQ/GFZrmGJk5VIjuYvaKdjrVf2SM
	N59nGaIXlNW/bvp4ENNjuqIayXkIlqikpfbgTm2NSKQ2Ed1UxIO24K7mulE7CmYtCAUHBRjcVpk
	nsCHkoP8Os00/0xqXXd5x/XbiDAHSipJDXuVHyZGwn1jumi4fDgLdw0ek8RQmafz5prmxk3R3Vg
	X6oPU8H6E=
X-Received: by 2002:a05:600c:c4a8:b0:492:6efc:7c60 with SMTP id 5b1f17b1804b1-493b82b556emr34781705e9.28.1782802678147;
        Mon, 29 Jun 2026 23:57:58 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf26sm4570949f8f.19.2026.06.29.23.57.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 23:57:57 -0700 (PDT)
From: Daniel Pawlik <pawlik.dan@gmail.com>
To: netfilter-devel@vger.kernel.org,
	netdev@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	horms@kernel.org,
	andrew+netdev@lunn.ch,
	razor@blackwall.org,
	idosch@nvidia.com,
	matthias.bgg@gmail.com,
	angelogioacchino.delregno@collabora.com,
	bridge@lists.linux.dev,
	coreteam@netfilter.org,
	linux-mediatek@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	rchen14b@gmail.com,
	lorenzo@kernel.org,
	Daniel Pawlik <pawlik.dan@gmail.com>
Subject: [PATCH 1/5] net: export __dev_fill_forward_path
Date: Tue, 30 Jun 2026 08:57:31 +0200
Message-ID: <20260630065735.3341614-2-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630065735.3341614-1-pawlik.dan@gmail.com>
References: <20260630065735.3341614-1-pawlik.dan@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ryan Chen <rchen14b@gmail.com>

Export __dev_fill_forward_path() which accepts a caller-supplied
net_device_path_ctx, allowing callers to pre-populate context (e.g.
VLAN state) before the forward path walk. The existing
dev_fill_forward_path() is refactored to call it.

This is a prerequisite for nft_flow_offload bridge offload, which needs
to supply a pre-populated ctx for bridge port devices.

Signed-off-by: Ryan Chen <rchen14b@gmail.com>
Signed-off-by: Daniel Pawlik <pawlik.dan@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 32 ++++++++++++++++++++------------
 2 files changed, 22 insertions(+), 12 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 9981d637f8b5..c1d0b897de95 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3422,6 +3422,8 @@ int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
+int __dev_fill_forward_path(struct net_device_path_ctx *ctx, const u8 *daddr,
+			    struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
 struct net_device *dev_get_by_name_rcu(struct net *net, const char *name);
 struct net_device *__dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4b3d5cfdf6e0..62f1d0b64c76 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,44 +750,52 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
-			  struct net_device_path_stack *stack)
+int __dev_fill_forward_path(struct net_device_path_ctx *ctx, const u8 *daddr,
+			    struct net_device_path_stack *stack)
 {
 	const struct net_device *last_dev;
-	struct net_device_path_ctx ctx = {
-		.dev	= dev,
-	};
 	struct net_device_path *path;
 	int ret = 0;
 
-	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
+	memcpy(ctx->daddr, daddr, sizeof(ctx->daddr));
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
+EXPORT_SYMBOL_GPL(__dev_fill_forward_path);
+
+int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+			  struct net_device_path_stack *stack)
+{
+	struct net_device_path_ctx ctx = {
+		.dev	= dev,
+	};
+
+	return __dev_fill_forward_path(&ctx, daddr, stack);
+}
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
 /* must be called under rcu_read_lock(), as we dont take a reference */
-- 
2.54.0

