Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B8406279
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 12:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782736396; cv=none; b=EhjWFyWvSI+i7cZmWOX0HqOkkby4jrN9hjXEaI4V0vj94Zq76050+tqr4Zy6cWxR2nriFpYvhezJUNjFaM/CVdOAG9XRyyZYclHFdhbol0QYpgvAmhoWxve73EuT7ZG4j/uXf0956c7g4iMLxvAHnEIu1M7tqM4NhkmVVYwwaO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782736396; c=relaxed/simple;
	bh=WcFkxaVMJf7ZgRBObx+1aS9zIXt/5dWF7LgNn09k1r4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qROUA3yHeZaMwLuBSzRnq90Pe1NguqZf9R4GeD76LhOyCUOqmWMa/8vC2tvri9/Cin7LG4Kt/Wln1m7O68J3XvcUCsdABEUxy3nIN3WTQo8vunIMzE7ELc5feV8kKcPoEVcd05YQ7RGFe9klxmndaUb4swGeUWz6ELHgCE3r5FA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFNZcE5i; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFNZcE5i"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c1274bedebfso67295466b.2
        for <netfilter-devel@vger.kernel.org>; Mon, 29 Jun 2026 05:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782736394; x=1783341194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0NF38joMTzvz8Moy3DTutVlP+ZtXdrf3nZbhlmDRZw=;
        b=LFNZcE5izfqMwP9UWHRSIat3Cbn2YaD+6d6vqfgbE0FV9FJc/ck4Z/UilidKKUydeC
         K9EY1uFU6rPHos43+kGu3T85U19xY2VQGyr9Fzm8RgyWXsTm7MQMWARZFK7BlokL+nHJ
         PCO9iC6PMx+o+kulIb2oyGrI/FTNDHzoVGJnCOYiXrRlCLcNQzOfUIYsddvG85Uvf4SG
         ysj8zWL587z+ufFkZ/qHT5op2IclvYkpQzF0sfzDfhVnewzyuKkL8BurpO14Irf9b8xe
         +MNGijSxknxD4c0atgc/AXvoLGSsmdl3/n5V7g2pBNDhKMa6yzURdU7LWfjTVbm913qY
         gM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782736394; x=1783341194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=l0NF38joMTzvz8Moy3DTutVlP+ZtXdrf3nZbhlmDRZw=;
        b=PGzuYU+S7/sBSvV0V38SF42IXkm4+zfEE8HsP53BGPO11UIILeo2OwIVPsyPzFBxNQ
         v96nZ9RBF6LUSzVisU0zMPsyBIVLJ3hW+VTvS2p2QJ6PeqdT7fYN/+woZTGJnkuHp9RB
         0z1uyVW+c8WOTPIMti/+4lvrGXmAn+hGo8w+4BnJziq+4bx/hYj/jy1qu6mw3g39xPz7
         g4euhrDF8JOV3mIJRroqztgMMc4T3rJUAnoz1mn9ie8GPABhG0YnHypYbuLqKB+p7dNK
         GI3uclU9yMeq9QmpXe/ns2QlkY5UOxmeYbl5A9hxmxKrDR+OkfrU/FLecFX1la6I8WmQ
         fL4g==
X-Gm-Message-State: AOJu0YxXg258kZFHsQ3C36Mclb6qHFty7pXg2msFX5ex/3I5HGLe8RIl
	pe1FENH5tM6jMPP+ySSCTzYnWkZizC5XNhJGA7J8kDpEgVPbPGKM1wwN6W+cN+A1
X-Gm-Gg: AfdE7clPMjO9hPEE0orH8xcc3ra+e+FRgOrUXbYQqASs69som5nnoMmsEj9sj/YdDJx
	IMoQsSg9T9JCQwuPcONbIFG5ZJRYoUwWKiwbvum+s/ASlGIEBldVuPoss6KKHRLjvtTpy8pwPZ5
	y8g9AbuFwNV1TIN2Pc+dBVD0QQt9Ml1pTAHipQwPJWqXGM/3ipzDGURMJeh5h8b3NU96VesitMp
	KB7esp7+3/sWsdI/OwwgtSWCb2Fk4ta3l9cDJUIyUVIWJV5rqXjcZ9SQolMp8j44UZ75WkSkOU0
	xtUbRZ1fc1Ic89OrNIQaebrlOkiejFO39IP/aocUw7A13VryBD9si+hqslAEjPhyq4SOL/RejJz
	L32qrDIzsDw0KYn8NAdAvGFWUpk8WoOlUQhKf0k+LH3+l/7O/uR41/jBmfsiHKXK7WF4yYlte0L
	X86jd8AeE=
X-Received: by 2002:a17:906:fd86:b0:c12:717a:1d79 with SMTP id a640c23a62f3a-c12813744d6mr19854666b.5.1782736393241;
        Mon, 29 Jun 2026 05:33:13 -0700 (PDT)
Received: from fedora ([46.205.218.111])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c11fbe05c22sm773866566b.39.2026.06.29.05.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jun 2026 05:33:10 -0700 (PDT)
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
Date: Mon, 29 Jun 2026 14:32:49 +0200
Message-ID: <20260629123253.1912621-2-pawlik.dan@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629123253.1912621-1-pawlik.dan@gmail.com>
References: <20260629123253.1912621-1-pawlik.dan@gmail.com>
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

