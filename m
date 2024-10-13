Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B24C15534E;
	Sun, 13 Oct 2024 18:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728845744; cv=none; b=JjaDn117bib/UMQlrbcZ81kUZu1h5KRtQWewUnWogzP4ZqNWUPEtbHJ/VEAqr6G1ur57X3INyXhAh3ayVET+xpB9IWu7DLZVoiitpwNzhXb3ZPwXApDpJO8JkvpMmKUJvt17AUES5KFWfXLYzfekHjQzUQa/RtN4Uxjpmxr+ugo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728845744; c=relaxed/simple;
	bh=WuTg7EbZQgLU7QfOLGbl/dJybrJXkDyf3BW1ppxV3/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvA0a1ulBNHNAIRmfN0HiTHtjJ7CvIypzIeJsKIfItxDykxshxFpqs2QCP2+MFxTnmRMArc8dX7NBNBGS314hZpuEVgMGsxZtUV1vqF6LFL8mTYLvG2BUaKpyW/v++zj6/XJ8BgKt0DGsLrdj63JVqnnZh1C7Zr7hGdVPhbF9pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NJVAPmFD; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NJVAPmFD"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-a9a0ec0a94fso37351966b.1;
        Sun, 13 Oct 2024 11:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728845740; x=1729450540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/jTDX+7O0s0C1nzOWVEkFl+nOrYzHK0gi2J/aQ3w10=;
        b=NJVAPmFD0WhtuMenBkbRaCt/0Mv2RvxRkpyAmiiepMMvUv6taTC5gMwaOAoIeibvE9
         dLgyeqqR2goxUhySJ2bNoeGMkM3P5Hz8fTWdCb0jNsxH8MoRVN1myKDhaYQMVK5W/PVt
         kYfVqcDGvNEbRe2LWwmPNABna6fz4JNZvp+9Z3cASKARVUZu6I/TKlfjw+M47nY5zCok
         2UCD23FBQvBQ7iond5DXpD/cXRhgPjkpmfAFic7aqu4jMZeyw7nMi/NcZ06Pyp42jZas
         swxncGUBzxR49ao9rRVpVO2d5BkmP/fkwocY3zbCR77GLOt6h3cJ60lVBtMrDvzphgod
         NGcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728845740; x=1729450540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/jTDX+7O0s0C1nzOWVEkFl+nOrYzHK0gi2J/aQ3w10=;
        b=nH/Qo7EzdQQva8Z0FKVY34pbSShmsKKWcGcHJentckZAcHTJ0fiK3MZ3TZcCD623an
         0JQaXn9dGMgH1v5YzO09O+TitkNHMb3YE4zdxRmUJJ8YrwIsO4BqphNTLJr3c+XHUIRe
         Fze/OKBAHMDMAKd77+M1D20qFAyNQJdjtAoFE/zfUeD02iYtzCR4rolH1zp0lNLG85ao
         6VfLPtexnZU/ABS9k8VsXyaUBZcCbTFUkOQsrLT+4V4757ZpU6VWEyZ1v9762AfVWKiU
         DQuNfCEr8eisYwkfg5g2EDwvKeWfsJ13LDRxVSWJJW/+vOtOBQP2FrQPy+z3HuanE1jT
         COxA==
X-Forwarded-Encrypted: i=1; AJvYcCUYir2GF5AWopmxUKdZHcK1JIgsYC6CCuwLL1y97xHpi1bVAwPpVx6GFCPxkOVfWKa60wl/tn6+cz2rslo=@vger.kernel.org, AJvYcCUptnw5A22vsCrb2zclMkjPs35G0dv0g9gyxOkvGl4FVwsIIJLuX/jSXibwi7avyYD+aC5T9P7nZNq31k0WyoEQ@vger.kernel.org
X-Gm-Message-State: AOJu0YyTZPpGpbCLpKItJ8TY92ml31h252KPyBK+zJhpkOvW+IPiOQg7
	LaZiei8+zCAlbwtvQJvPndqvb3YKLYaOdtUYon/UZl9mFONFBr3m
X-Google-Smtp-Source: AGHT+IF5ckEcH2Maqlc37cAezXjDdy5PfJSuqGGD7BCfFPOKEOulLZNTMAaU6eD/aTsuVoJCroKnXA==
X-Received: by 2002:a17:907:7b9e:b0:a9a:11cf:2a73 with SMTP id a640c23a62f3a-a9a11cf3a9fmr36014066b.64.1728845740471;
        Sun, 13 Oct 2024 11:55:40 -0700 (PDT)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a12d384b9sm13500866b.172.2024.10.13.11.55.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 11:55:39 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>,
	Eric Woudstra <ericwouds@gmail.com>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org
Subject: [PATCH RFC v1 net-next 06/12] net: core: dev: Add dev_fill_bridge_path()
Date: Sun, 13 Oct 2024 20:55:02 +0200
Message-ID: <20241013185509.4430-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241013185509.4430-1-ericwouds@gmail.com>
References: <20241013185509.4430-1-ericwouds@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

New function dev_fill_bridge_path(), similar to dev_fill_forward_path().
It handles starting from a bridge port instead of the bridge master.
The structures ctx and nft_forward_info need to be already filled in with
the (vlan) encaps.

Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h |  2 +
 net/core/dev.c            | 77 ++++++++++++++++++++++++++++++++-------
 2 files changed, 66 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e87b5e488325..9d80f650345e 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3069,6 +3069,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index cd479f5f22f6..49959c4904fc 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -713,44 +713,95 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 	return &stack->path[k];
 }
 
-int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
-			  struct net_device_path_stack *stack)
+static int dev_fill_forward_path_common(struct net_device_path_ctx *ctx,
+					struct net_device_path_stack *stack)
 {
 	const struct net_device *last_dev;
-	struct net_device_path_ctx ctx = {
-		.dev	= dev,
-	};
 	struct net_device_path *path;
 	int ret = 0;
 
-	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
-	stack->num_paths = 0;
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
+
+	return ret;
+}
+
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack)
+{
+	const struct net_device *last_dev, *br_dev;
+	struct net_device_path *path;
+	int ret = 0;
+
+	stack->num_paths = 0;
+
+	if (!ctx->dev || !netif_is_bridge_port(ctx->dev))
+		return -1;
+
+	br_dev = netdev_master_upper_dev_get_rcu((struct net_device *)ctx->dev);
+	if (!br_dev || !br_dev->netdev_ops->ndo_fill_forward_path)
+		return -1;
+
+	last_dev = ctx->dev;
+	path = dev_fwd_path(stack);
+	if (!path)
+		return -1;
+
+	memset(path, 0, sizeof(struct net_device_path));
+	ret = br_dev->netdev_ops->ndo_fill_forward_path(ctx, path);
+	if (ret < 0)
+		return -1;
+
+	if (!ctx->dev || WARN_ON_ONCE(last_dev == ctx->dev))
+		return -1;
+
+	if (!netif_is_bridge_master(ctx->dev))
+		return dev_fill_forward_path_common(ctx, stack);
+
+	path = dev_fwd_path(stack);
+	if (!path)
+		return -1;
+	path->type = DEV_PATH_ETHERNET;
+	path->dev = ctx->dev;
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(dev_fill_bridge_path);
+
+int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
+			  struct net_device_path_stack *stack)
+{
+	struct net_device_path_ctx ctx = {
+		.dev	= dev,
+	};
+
+	memcpy(ctx.daddr, daddr, sizeof(ctx.daddr));
+
+	stack->num_paths = 0;
+
+	return dev_fill_forward_path_common(&ctx, stack);
+}
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
 /**
-- 
2.45.2

