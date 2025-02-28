Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A56227C14D;
	Fri, 28 Feb 2025 20:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740773790; cv=none; b=W7T6WrbncbOR4W1mxqCkGl3xvqo3I/6ppzClFpeFnXCRdSLjkXH+kk1s1fnmIw360sHRpUYXloVB8e8W+4q+StIXJxMbZzo8CIlmH4bJBrvd8Q8oQrTXUIKN7AZYI2k8VKBXvtzNXec67E1NRu9oTK0DHQxNEf2ljsgkKficmhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740773790; c=relaxed/simple;
	bh=/pRWkqhj7p134n2hqX1gCn1werSIKKUl61ZTrfk84RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmPh6XKTKEdX5HhX0bgw96GJwtdp3UqwLSBbGnj/QFGG5bDBeGE2s2U2T7o4Q1qhMHf35lUT3IVm92Vw7JAYJW0lHZtbLZ0CL3h+JOnLHRWDyFJi6lGAThaG2Lrhn5YsniECpVbo8xTpSaMqEmsHflop15ANFGprZyf6YqJAC3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhSXnLJ8; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhSXnLJ8"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abee50621ecso339214266b.0;
        Fri, 28 Feb 2025 12:16:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740773787; x=1741378587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ADjft9sIJBXUW7LiNylDurA6RPlyGDF8xbXsxbaW9C4=;
        b=hhSXnLJ8s1v1mOOdR5icmPY1rLB+EpKyYtd9/Ir9fsqXb79lGa7ql+PJdLBpzCLUPE
         7UkBO6IFs64w3zPjGzoK1KlBz3BjPRzmT+/zqCIYkBQN41S2jUYTSFfqRo6rXFJXnWbG
         vshN+ycmfF7IGgfDOAh4BQEZZLEzL5+JUR+svznCahhvhzE8QjGM4kpaATlCnJlgPtXb
         qpZzl2aGzJ7IQLgLYXfYH+MgaaALcNQvBVr28JailR5g6UDbr9hSvS3PNn59PeH3/WM9
         /kIajCB21D8HCzuvxmoNSEbEITGySRtzMG5wQjtk3oagy20Aeyr9ooVRzGJ8gKMY8LTq
         xANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740773787; x=1741378587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ADjft9sIJBXUW7LiNylDurA6RPlyGDF8xbXsxbaW9C4=;
        b=LBO37kDfvtmc1T5KmWwxohdV1/5J9irYE4VixyCuAKoqJfE36JWJT+n2PEr9CranZ4
         G/Ay+VBmPJCHpm93AM2jaUxmklUGnBGwiy+n9SpN9M07lOUN+0HYDsQ6D8iYXsomAGDC
         h2Ymrm8U+d4dRIeY+k0V9F+ujJ+zv97wAe34LxlirjeCBiXnIQgIYkS48NJRDV/QAAbf
         kquBI6CYusA7Xy6uJtKrSiI7cTm6HlakVPO9BoBuu9qQ4Nfj6gL1L9Sk96PxjE6QlK8E
         VP6ivdje9CYdzrne/n+PD2luR7qYu8TwXPEso03zyAeUTtJetpszJn7TOexDoyLgKq45
         fYqw==
X-Forwarded-Encrypted: i=1; AJvYcCU+RVhfS2wIQdE+KixC9nOCjyS2fNspmaF/6FaiIavlW+CfLvMoWI7Ub5T4USeV7ZVRacSB1Nn8mYhS4n+E@vger.kernel.org, AJvYcCUTpzJAEAloEL3IZ06wGkoiRJyNQt1pUnwPwmU98gSzepOrpveswjaqdmdku0gfhmXSL5LEJPmsK00zpEFDcR8=@vger.kernel.org, AJvYcCVD4W1tRcF5fCrFYa46OULLHiQLwDiN4Q51I8CAuXlN4QdOfmVu3U1m3f6We8KU0REHreehRoih50Jps2oM+Xpo@vger.kernel.org
X-Gm-Message-State: AOJu0YxPPYYwUBev/hRZ/HzGoszwt/fZDofUNZ6/mYbkzpKAmeD0e2rW
	I2kU+w4HPFIVRGimXSKEDq4tHzM0Wpgw0vXnnjLHqFidwRbfe6jm
X-Gm-Gg: ASbGnctNJ/0/OH476nF0M7Y1E2+tBAZxZIQHw8wuZIdRy+uGt23icsa28uSAo1yB1BF
	/x6RK+69UjHhDfTJ1oAuMsxz4cMqJvmDk/Jl89aCcw1AWirySIehUCLeEugohbLcTJRTtJtyBzT
	qLusIHmuehIaBH7P427kLjIc69yZVtjHcwRz4H4sBgrSsBGgltOjQl9LSZssp8fZQlc+XpmL+q9
	d5QDLVw4zubozpFswU6FttOtDLrjofguEECNthk86NIs+DJT6njmYIhAW/qnrTtTDO7aj5IcSW7
	L7LP8Hh4rR1rD7FcGoyPdADtiW3axk3o2Sq/GOyC3q1/GSULpZecQlkFmmNm40jOCZLPZSJZme3
	7qgU2BHGGyIlDPx5+vO4eeL9tAuT5swK3yYjVq+d/e8o=
X-Google-Smtp-Source: AGHT+IHZr8MBH5e/es5RLH+VA5k1rbbZb9+gMcTnsziiL+DoKdJyx6FLpgBr4j4inN9U+45blgw9TQ==
X-Received: by 2002:a17:907:3e8b:b0:abf:1386:fcad with SMTP id a640c23a62f3a-abf261fba23mr582057466b.10.1740773786500;
        Fri, 28 Feb 2025 12:16:26 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf0c755c66sm340812666b.136.2025.02.28.12.16.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 12:16:25 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: Michal Ostrowski <mostrows@earthlink.net>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
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
Subject: [PATCH v8 net-next 07/15] net: core: dev: Add dev_fill_bridge_path()
Date: Fri, 28 Feb 2025 21:15:25 +0100
Message-ID: <20250228201533.23836-8-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250228201533.23836-1-ericwouds@gmail.com>
References: <20250228201533.23836-1-ericwouds@gmail.com>
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
index 26a0c4e4d963..2ee53478d9f0 100644
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
index d6d68a2d2355..467f98f6ba51 100644
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

