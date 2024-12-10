Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56FE8223E7B;
	Tue, 10 Dec 2024 09:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733823983; cv=none; b=Y7dj5LDU9Ai1WuXeNzen1hElVx5WuYtCKeKLOjJ9GL0gM//2efBFltR0BtfKEWqeU6h6+qZracgcShjLFpk+5Gv3q6FnNlkJObvnY/rMWvNJwhZiymVbDJl3PEQnlbgUu/FR2YsNo1f2LVTQnYNA6X1Fxi222ChpOMd6hBK4Y2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733823983; c=relaxed/simple;
	bh=jNdmUtmmLWwn9rk4yVMKaaPoDxyz2/GusjoWrAJe5NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aOMEWAFp53SWg8LGLGD1M34MhWWKbbB74FuPJ01oWqeCCB0irI2YbJGD8Kf1B0XTynYoPWNsLS+WfSIuH+XkIM0PS+EONv2zfSoWazRMKybSoo5Eabi7gG5Ty4L17MNreKsgSPXP8BAZUmbowiiIQ8+yYCLV2NNapG+4kJtIGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L8HLweZs; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L8HLweZs"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5d3d14336f0so6017442a12.3;
        Tue, 10 Dec 2024 01:46:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733823979; x=1734428779; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sgr56AJOAsne10L7JfWzoylFaIhH9l45zqgX/3P/NmA=;
        b=L8HLweZsFoUucWX5DQUGUBG9XXY2x+z4eNGUZCjMnEw86mSbjmEePeU0uyOj8yiH+d
         DOwEdB/254RjjAKXwxTIzmU0eCNX/5qMWR2/6EtF6bcJtYrGGkjrYnX3KNkaFJZCGADg
         FSWXqGCCrZju2rSW9AydsrilYZeZkV8jxZ5czu9Z0biGT+136qZhQUyL1EYO4drJ3WoN
         uUuzTcXuup62k9ixjz3Og01BMsOIb/yOF6sOEWoZi++XVW/pvgQtIuXKHUVTFJs34v1J
         G0jmRCx//gX2oq37tvf/xmCXujaubi66hOJQXQSrDWJgdtZbGYNQ1waM1V6QOYSoGoL2
         HtFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733823979; x=1734428779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sgr56AJOAsne10L7JfWzoylFaIhH9l45zqgX/3P/NmA=;
        b=NI1ARqIIFPg4YIvbSCYS7MDPa/IeEKDRtP9Cuu6ethk4OgUhPJu48FS8nvg1ZKfAXS
         ab/yyD+MP0XtsAzkrffcWGg822gb8FfkZx54j1GtrhXkY60fbagH5ld8xgYClFHdf2uU
         kLeMvSN1O/345MKBU04tv4IIEXH+lw8PiIVLz7Qfhh/PfJB4BLwGRt0DCLwNLcOFjI+H
         NeqJ1Mdm7w+kmn+gXssoteWL0KXlqX87Xqn+FFiTZpkahVlUVgrMOY2nUD5rGKNathLV
         XcZNm37Eo+bMUFHxV2EtIvaNC0iDI5g7DAlG5bcfumeSjqB3GT2KQ0Nt0KtIQvV+Gibl
         uKfg==
X-Forwarded-Encrypted: i=1; AJvYcCU1GxwtRUO+xLXaR2cALQlSkanjUT95JNdPw2CMhrgCkGliVDy/KvCRwPg9eLwrieowTaZ6yqN2f9Eid58=@vger.kernel.org, AJvYcCXoo3IpGP5JVFQRE6nKk5qGTheTz0nUgy+AGqFZAm1EHFgULpR2PnotghipjNYofsI3f4C5DVtEgK8FptxnlPv7@vger.kernel.org
X-Gm-Message-State: AOJu0YwiHpgyZMS42zRpNuebgeG4ruVeMtYWyUPjHdHRDbmzAaJPp1Xw
	UJbqyfAYgurjoZGRWTFDhdIgwV0Zk/EorFfReZGHnyV2YLIeHIpP
X-Gm-Gg: ASbGncs2negClnEcsnkf1vKlmX4zaWMI2ifAZotKA/DU9bUfZo44v6lF4z0/mIRhBtx
	/kMuRRYlSu+nJapAJBbp4ikau6sb3PLad0kTb6aa4cAj7Ppn0hpYKcqlKwFCrCIh3eH2u2cxjP/
	eEEsYBSCu/Sqie3c1ug0AWnD8zfCyaIVG/srh5mkT+5zczzIKdFFisDE/n84DeVU3+P5T/r4YvZ
	tFUgUp3xj4rUAFT3SJl6//PrsuVnvNJoR2GoK76pBy+9pJMynzuzWJGsHu7clMZ+QGeckg5S7OI
	A742xMbAyx0zMHMIYGRQn6ek4paOVylfHG6IAQZABABN86ITHNNkx3jy2OnxW6fcE7wnUzI=
X-Google-Smtp-Source: AGHT+IGZmVUxUDExEwI2I/Wt1QDwE1SDwE0IGYTeBPK1ELBKPlastjt+1dn458EDLOHgXMoYKOhzNA==
X-Received: by 2002:a05:6402:3484:b0:5d1:2440:9b05 with SMTP id 4fb4d7f45d1cf-5d41862e405mr4691296a12.28.1733823979183;
        Tue, 10 Dec 2024 01:46:19 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b609e56sm7313936a12.40.2024.12.10.01.46.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2024 01:46:18 -0800 (PST)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Ivan Vecera <ivecera@redhat.com>,
	Roopa Prabhu <roopa@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	David Ahern <dsahern@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <jdamato@fastly.com>,
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
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH RFC v3 net-next 05/13] net: core: dev: Add dev_fill_bridge_path()
Date: Tue, 10 Dec 2024 10:44:53 +0100
Message-ID: <20241210094501.3069-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241210094501.3069-1-ericwouds@gmail.com>
References: <20241210094501.3069-1-ericwouds@gmail.com>
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
 include/linux/netdevice.h |  2 ++
 net/core/dev.c            | 66 +++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 13 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 135105441681..6dbc442f9706 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3183,6 +3183,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index c7f3dea3e0eb..01dc51abe7e8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -713,44 +713,84 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
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
 
 /**
-- 
2.47.1

