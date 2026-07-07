Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E713D53C
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jul 2026 09:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783415480; cv=none; b=dgfwzZtijwyQZLnalmebW9XcLp5H7xhXioaVuLbGcyi59ydguAJn9Vcz6bf4mdPSk43QqxvEWfd5iY2YwcEmH+c54kCvHBOF1DHONT7X1VPZCjBJ3Gs1xaDV/guynGEApZiytIJJCEBN1RbCpV6/gtJ7yrBpRhPrHSkQPKL2cWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783415480; c=relaxed/simple;
	bh=cnD7jahdq7G1Q9SmXEmCD9A2fyUANXgV/XLl0q/cPCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IHa3yHTQB+IrjTJh4PDpvCkk1euMdv/pC7Kmw0nhCHdM4zbwgaGEZNqSJiCHthRQV6f+3c5rlXVR07aiFXdRHX/5d4fXm4GDuyIj2nSRCzZ3kRiVZyYOhW7p1oSv/pGMy4LFAW/vKEqCewk4i2WSuMANkUvv/7MVZ2+jG81Tqrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m2OrCBrq; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m2OrCBrq"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-698aa7ba320so980560a12.1
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jul 2026 02:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783415477; x=1784020277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLtHBP+kPSWoPuhJNrOLFVJEuA0mq3S8UYf0yZ/z0ro=;
        b=m2OrCBrqcnVgTtCgITXb+wzDxf04VQkO8F8lADADzAGoSbcmwGQ4X5Wf7Q31mmP0Kl
         /Z1iashLXZwYf67yyfORUI414VSsjWm9E0p4S7FWql28Q5iT4nwrT4XIbEeWVEX/lIGs
         FzVVs86ud45yGOWsc84ZLF65UHqwZSdlOQNRElFhwOFM2MYbgUqcLABwzz2mmYELWvq+
         9Lv/t7hfULDsSdQnTKuOgkup8n5ctxeVC9CPSOyn2Kef/3k2FyGrM7QcJkPkcQOvPFdv
         IiLaqLszsi/k3mvPR1IN6C7KS8E9BDvjT1ZZeeJs2k4FnrNNlSzEOy4XPkPedsy0I0ty
         57ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783415477; x=1784020277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VLtHBP+kPSWoPuhJNrOLFVJEuA0mq3S8UYf0yZ/z0ro=;
        b=tRDXjZnBqRTrUue6Aq8Jm8SMs1r9iAe+MGUb+mY+xE0fRUyxLe4WN/f5XsLK5TyJB8
         Itv6rffjRX7o9JJnC7mv5lnHfJsafeqr204kLrExCLcMc8HXrYBI/RvuEw1CMsjzwwam
         IrRBT7RlCEi36Ue8AvIRXUWnhwCNJYvTfDwQLA6I8K7Gc2CWwPGY69ZQ8vGwOMH9hfN8
         /WPoP+wKF4Q5O09VsOF8fPeiK3jJWz9zuKZfAekbm7lGGgJ88hrwnAet9AuvXd1RROrQ
         yMC+JblhKqXyXqFil4V8KMfgV+C+ckzn0GEoPnURrjVp635Yl7aWM6aQ5tjZXQwi0KCd
         eZpg==
X-Forwarded-Encrypted: i=1; AHgh+RrPuFAntjSsIRW/c15NaO6qG1EaASycuksz3gpX88VvALUF59RpppWMnFUv7X6dVFBL8bmOiMtiA01plzYGx5c=@vger.kernel.org
X-Gm-Message-State: AOJu0YxWxBBvG6qXmhqGoHLufFcEQe4WVA41N7f7XzfSdIIm16fUw8vr
	AV7JSDnJPALaN8qdcQx+uZcM8OEOApsViDgfVr22FKh2GLaca4ELMxXg
X-Gm-Gg: AfdE7clm6qXYojbeiR7umiyezm6VGVkwXWrzQSLinJqCblJow7Mp3S7XXmbICUQz8IR
	JZZiYnrqZR2PuCSgXfGnkBe30jB0CJcDLfDhQJhqUxJF8i/yn4E83tOnSxHz4cQQnAuCK470hFz
	jDDy0xNJwEeENdzcTaZYv3+eKR6RZvhJBKSHZzZSK2jvcbFPW3d8PzZrDgbA6Zs/f+Usd9IEBKD
	z8Whltvkj1u/jliPbYO1ZvbYZwAQ8+g4IWX9wLsefK5446uoVXIyX1o0V10rPeHRsKyROe2BwqF
	3rH2LcSvOkZ2Ztcd6gb//qtrHlkQrmj/JaZs5rlHWIZIE7ha6ibYB7gHwU0Puno8TNUhpkI9EIo
	yoAnPpJ2egG5jncQOwxoG7iSUJfOWJ2z+TIrfypkfhXIHVYsunAbwcABSGv0pcA8klNKuDA4f6l
	rxDKhuxIEqNjZEC0NybvppMPF+m1V674oGXD7Pqr9KFejKDs5RxSpUZlBT2IQ36rqV9cjqn17hd
	acmXPkJp7vjpfupHcpOrnyDe5F06Jqea2Y91YLNIqTb
X-Received: by 2002:a05:6402:180b:b0:69a:8e43:ec95 with SMTP id 4fb4d7f45d1cf-69a910bd402mr675661a12.7.1783415477014;
        Tue, 07 Jul 2026 02:11:17 -0700 (PDT)
Received: from eric (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69a19cd87d6sm5297152a12.6.2026.07.07.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 02:11:16 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stanislav Fomichev <sdf.kernel@gmail.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Krishna Kumar <krikku@gmail.com>,
	Martin Karsten <mkarsten@uwaterloo.ca>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v12 nf-next 2/7] net: core: dev: Add dev_fill_bridge_path()
Date: Tue,  7 Jul 2026 11:10:40 +0200
Message-ID: <20260707091045.967678-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707091045.967678-1-ericwouds@gmail.com>
References: <20260707091045.967678-1-ericwouds@gmail.com>
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
index 982b6e65a4be4..69b499ddefda0 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3421,6 +3421,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 4b3d5cfdf6e00..f6685c1e47860 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,44 +750,84 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
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
2.53.0

