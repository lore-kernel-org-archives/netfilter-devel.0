Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D50320AF87;
	Wed,  5 Mar 2025 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741170616; cv=none; b=TKCXCPGv+U+vH6Yx2K0xr+vYx6r0ebmnNDy7ZDFCHiMtbjOhpIaGk+zHxZ6U2P3MnPeO2dQK7sF3HzQ3xgnyLhcTutATSrl0MlPJiTNqszNpzir1FbpEJ3aE8fjcyUky6VcC7AjNm6B6ad2a5xuNqFeqkZ0M3qxW8600CEAGcZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741170616; c=relaxed/simple;
	bh=PBHyuPBG/ButhJ6qRcnSF9I0EBwamgj3VpeiHQaqfac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rk3K1aXGgShwNNbm+4JE2J50FDghVYhLMy55mN+jg5ZzazrYkh88EJC1Mfih768YmBpJDstjLYMdRLag5fqCkP0a+Nosgk89JbHauAH4RiGhdG8LRkRSpvXd0Ce/PnlHmK8sAfBuU5QjGnYjh4+0GzRFs7uP9odjEh2Y8oalOj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Du2d5fxw; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Du2d5fxw"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5e0373c7f55so10236736a12.0;
        Wed, 05 Mar 2025 02:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741170612; x=1741775412; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XruRHgHNa4U+aD5EhN/5bdzeM8wMLCsm+ZTeJKtfedw=;
        b=Du2d5fxw+sTHbEt7g5v1AsnLtViJivvBK6O9L9fqZT5iYJRPXf0pjW4IYDiTSUmYLJ
         mzMuOEyvx57mY5B7yjVya2jZ/OJ9svshc+G46X0ed59LdFAiOCC7BpD/DtgD2tlosnYc
         Ug6ANPXr6QdymFScnM8J/umWDVsA4AOQnitkBGXd+VEyWfy7kkCiMh0QFvTu0L70+U52
         AD9J7LPECRDaqkRGK6FGGaq+3Im1BXwKpQKh/94sw2oM0UNHgVxwojsftbFK0zBoCaAn
         Qy2ELqw1ysL9bkCBqGAGRVqpWqiE7cb21v4u7Kmj1q4WO8oSG7i5ro6DPfncjifSmiHS
         y0Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741170612; x=1741775412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XruRHgHNa4U+aD5EhN/5bdzeM8wMLCsm+ZTeJKtfedw=;
        b=fY/UygnKD45qeHvvSoHNnyWUxuYKzS5FdLZaShGJ5zfy+mryRCtW4VlWnhI9DGytEo
         FkaziFr+XGfyvl25n6OnIGL3FgFyZ0PR/DhSsIbjEj8iaKdewoYmRx/yFGcVw33w0DPH
         3uLJjpmcjtwfF6QglJ24sDbcehHFWGifHZwwuWUm6foifY26Ih5RmBxUaQT7cJ26gowf
         vzBeTI8IrfcEW4LOpNZC+wF8KduNrxQ7ILmX9ila1VW6+HypGbnVcpc4PEwKyBVTH7Tj
         chngO33edXsrz8KOk65aRUU43u5yVA4Ks5NDrC0JNlY9arRFCAEpBkMx5mLBYkNaaYI3
         n6Kw==
X-Forwarded-Encrypted: i=1; AJvYcCVQVaJ900svBn1Eh57OsAu2xNn8TugYmYOuiIkkn2mbFIOiVu65H48UEEq6o/iU6+bTbRe+X8mekTNq3MfbpAM/@vger.kernel.org, AJvYcCVZktf8g5fiyamIT6Bek8skbJcnaH/2+CToyr33mBpCBVQepiOv+lszOdJx4q4j71GBUq8pMr4ANs0lLD5m@vger.kernel.org, AJvYcCXY4mA6XcUwEOXMoDOoMzgiMO5r24QqUowMTpQaSlsLJ7gR4zfp0pLjugK22jaAw/qv8Tak4B6eY3YKQ2IPaYI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyk8wvQomwMRc/y4gsHzjyoXqS8M2Y1Gr1FMWOPt4M3UST+9Rkg
	PFNDebj/xO6zIOdkAlgoy2EbWVcIGswjifzryPLpEbCxSmFiUZO+
X-Gm-Gg: ASbGncvkrvAyg11e1lITiaXnfm3YEbtAhlvWJ/FAOvKLWPNZkuXR0oZmXVisoiGGZSZ
	CJPvvqMvSd/A5UWFahWiXAWQjasLpH7FRIZ/27QOkf1liXmZ72oKl2yyEkogOun4PSRVatkqBun
	kY9haGqobn148AsfPkeW1uqqqaUbqqD47N6RxfuRpeljEh0XwpftuE95P6yVcy4RctdieUcyxxa
	FepZZYtaNLpaXu49415sD4Xr5Mgra91z32zP/rEFwfxBclXO0EhTp5HQeslP/h7wgfiQqakxuOJ
	8fki4AlpsyBWgUJn72he1v4LpAFP04BF7jX1A2jZ09eGZAnvItxe5HWpn/MJIXN/PXixTFOOem/
	1WipS4Dfs3uetPSNE04uh8iH7jDIeXLg9PKhc5/lWJOFbmqripVy6gvgetTDVYg==
X-Google-Smtp-Source: AGHT+IGWn08A2DSO8MVNqGyk+bS/v/k3a0mXwDhZkKNPGgmv7Ei/GzcOqONoOScVVDEII0Mp72AZ4Q==
X-Received: by 2002:a17:907:1c84:b0:ac2:473:7f35 with SMTP id a640c23a62f3a-ac20e03dcc8mr267370466b.55.1741170612157;
        Wed, 05 Mar 2025 02:30:12 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1f7161a4esm247154266b.161.2025.03.05.02.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Mar 2025 02:30:11 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"Frank Wunderlich" <frank-w@public-files.de>,
	Daniel Golle <daniel@makrotopia.org>
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	bridge@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v9 nf 07/15] net: core: dev: Add dev_fill_bridge_path()
Date: Wed,  5 Mar 2025 11:29:41 +0100
Message-ID: <20250305102949.16370-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250305102949.16370-1-ericwouds@gmail.com>
References: <20250305102949.16370-1-ericwouds@gmail.com>
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

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
---
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 66 +++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 7ab86ec228b7..81cdad85d9f1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3318,6 +3318,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index 2dc705604509..d0810f052d3a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -714,44 +714,84 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
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
 
 	return ret;
 }
+
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack)
+{
+	const struct net_device *last_dev, *br_dev;
+	struct net_device_path *path;
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
+	if (br_dev->netdev_ops->ndo_fill_forward_path(ctx, path) < 0)
+		return -1;
+
+	if (!ctx->dev || WARN_ON_ONCE(last_dev == ctx->dev))
+		return -1;
+
+	return dev_fill_forward_path_common(ctx, stack);
+}
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
 
 /* must be called under rcu_read_lock(), as we dont take a reference */
-- 
2.47.1

