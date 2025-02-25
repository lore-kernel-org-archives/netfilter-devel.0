Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9027921325B;
	Tue, 25 Feb 2025 20:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740514596; cv=none; b=kIYEqZvuHR3o5Hj3/ezK0PsCxniGovbTbU8V7WhJiRuiK5kzEPU4G+plVvFWYO5ZKroHVyqUhpUsHKbKe16R2eKWw6/slLguSiK6mU1zBekyubEsTuDKXUUqsTqvUoYAZhNHa/wzVg2NRtamzjboZkg5zZeMcQPpXXibW4V7uMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740514596; c=relaxed/simple;
	bh=QIhn2y3kyisjmJYCyWM38qUrYkbqfd1KGtAA3NxVqc0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PI2/8yKz5TYPHKMTAawmsnYA1c6Jc9vP4c61vkTBX13R4kYDDGjHqBF2YpCwNvAhUnFeVwVP/Et0/B117vE9Pc14u6Kr2ufUak6NcXddEZX6pNrMFQXyAIdVJmRLkpQD6LTc+WD016rM2W4B+7JH7mRT6a/0YiMF/IvrzTooQIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U8HQmIQX; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U8HQmIQX"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-abec925a135so231014266b.0;
        Tue, 25 Feb 2025 12:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740514593; x=1741119393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vgvvO4mRAt67HclOcho5/or4Z9zLgPRzxsVdNZtTjYg=;
        b=U8HQmIQXVQAPKJLfHM9Y7V3rqufBDBNcUlA9ecqcC6bwGEvvQjB+TDbrME/xqbG61o
         HqY4waeRJSDnSU2Zr2/clvmpn+uiILSAMmwd5HGHA8+DijM8fOqs/i4mVgZddXmwvL/p
         CTv25fXzLsBh//Nyw1qGTnbomOdEYJS0ldN8G+HfC7PcHWzi2DXSv596JJPV/q0tmWDp
         r5p1FRFMXN8rxJbqOliR0wz3Nbib3pC80tWS3PnevH2S8HySNThmup1yP2lO1RiT3z7D
         fsWeFAuarmoIMH4pYR4mjNEKcqTIvIwpF593VHn3kpfAVOo1qXApN7fdQxRMqvZWoP+M
         1HFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740514593; x=1741119393;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vgvvO4mRAt67HclOcho5/or4Z9zLgPRzxsVdNZtTjYg=;
        b=vpun+HKi/3DydUK3tRqaeA/xMw7gTa84hmm4YtWEWssIMwD2bx83FRdePw9pUmfM1d
         1GXDvFXqxAWcA3LpNlPZcfq4hfKOifE6ZcnF3+mrONy4h4V43/rVusT0ejzUSDhwmsqh
         PvCa+E3WNTGiYUmHEawRH7a7RGXmZ/gzu55t2csz4lmkTqWKsx1KidHsuXvMNqBF9afL
         NI8KA0jP3Ge0F4atwb6sgoeeoVTzXueKGNx2+YmPl8qXvzJ/cURRqMW6T5PVGgf42ddX
         pQP7y/YcS5vnxr/m89UWKTdM43IQ4tC5+eToZpAgvQqgC6wU9jbDOTX/8frag+02B+HZ
         ELUw==
X-Forwarded-Encrypted: i=1; AJvYcCUQGzJyYeQXeEltfdPP8N98hWOJqMSgyhgwRi8P2YP1ypFnpaePFUCg0cD60uNrZ2xHi0jpFWLr7uP0ll8=@vger.kernel.org, AJvYcCUqvJlt6SF4e3J4P7F4KnBziWRerjZOfqrQ5pjfmJhaPIJ0u2m02xAro+/1YzV/nCDPaeYjl0uQsFbxH/wrfVoU@vger.kernel.org
X-Gm-Message-State: AOJu0YyqIWlUaAGGtLUoVGYQksVsbI8mtM8ZrI/hyL+ooE6kf0TVTDq0
	tYfhYoCIkdoa0Kr57yKBJxPX6WP6bO7r1SrMEj87z4+XIeexsE8K
X-Gm-Gg: ASbGnctHSD2/jLVpw3VBwVBWbM/YgAwiw5BGBdYK803UZvRi3OVvHQRK/gi6Hb6Kj4A
	DaZgkabG9MuJAuJnJjd7hZ0zCS6STSg7QNBUK6/EtGcNYzJamHvzvsHSemUK3UI0bkI02TTQayY
	ADRrS9x4KWcw/NbQvywUPKVMI8RfTAMFhSvr/dUIEsX2cnTIR7J4He4v0uk6jaoOeoI9ZFJ/azO
	VxvWzixL2pjs7qA1C3vU2F1F1G3ecKW6iwHX7HT6O5+9EnsFpoNW/ltwPn0gIbkVLqRHKSZuvB5
	PfX1NkmdC69dVqmJKr68qbrgKhlATz+ChMPX3EtuBE+63dYvfz2zLVkhYtBXpT58Q1h33porp+N
	w9d7FNVEgA3DXm/2S6NnbP2bIelSDl/LgUGiAo3/fxLE=
X-Google-Smtp-Source: AGHT+IHYa/rnJMcG6bw4DaLIqU4PpMQ2X1tUCpndBeXitg+IOobUcH2l24ISv9vbXMdXY/Di07mP4g==
X-Received: by 2002:a17:906:31d1:b0:abb:e95e:f2c3 with SMTP id a640c23a62f3a-abeeef4216amr55910166b.41.1740514592646;
        Tue, 25 Feb 2025 12:16:32 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abed201218fsm194319666b.104.2025.02.25.12.16.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 12:16:32 -0800 (PST)
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
Subject: [PATCH v7 net-next 06/14] net: core: dev: Add dev_fill_bridge_path()
Date: Tue, 25 Feb 2025 21:16:08 +0100
Message-ID: <20250225201616.21114-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250225201616.21114-1-ericwouds@gmail.com>
References: <20250225201616.21114-1-ericwouds@gmail.com>
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
index 9a387d456592..695445927598 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3289,6 +3289,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index 18064be6cf3e..d5f4fae840a2 100644
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

