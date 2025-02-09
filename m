Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D01B01B6CF1;
	Sun,  9 Feb 2025 11:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739099456; cv=none; b=le9KarTPKFQoJKuS1wSuP1YM0sDgSwnVnmxx/tHNbzbvzXWHuGQ+XD/UtrQ94da/AyPCj7I3UHxP2Fv77mOBV00ozC+SLBbcTUFq75aftpaxlBgRiU84bkN/VxcwzG0qp8aqL1YLvG+GYYn0aOJhZD6s5Ed8icy43VdQmnGT3O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739099456; c=relaxed/simple;
	bh=jL4m9THywe+Y+ySsb+WjfJWIbmxM5647af+Ndr34Ui4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSl3N0LfSwF7llqHGnu/FhH7lexkX4PAW3bvPPXVZN5gX+4vRT1Lukds7xKaRCYPxdwv6WLAfwKVOD3B/dYQQ34AS+Gjx9CX4CKKxR9Zjb495VYqwYoIfHmsrOj27phfjytHCgjUc9CiAO5xUsGxzfq5RZK3ue24HZFXZANBqkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCxQxQJ2; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCxQxQJ2"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5dccc90a52eso5947023a12.0;
        Sun, 09 Feb 2025 03:10:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739099453; x=1739704253; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fiV2XWtkfGXlde1QnvjR6tvTdGG2fr19IqREO8Jjig4=;
        b=hCxQxQJ2/VB3nnChEqUR/REd53InKr3Omtkl2NZpSRAkAJT1LiB8kzhuy/2Qhmmi+f
         9pOeEFak3R1tX+v+PnYrH6EUkts7yv++FVmBW5XkDotH7LQD0VBv+K/kdqUrLOj7tWgS
         RSBGT/t3u0i+/InOxVpQUg0Vq/JkyKqlzHtcQE/7AFR7t+Fmph+EvR0y0PEsEjGgr70a
         TV8Y9421fg84D2E5TC7Fko/sSuIs11ltVr3lsY/Mkxi10vZPJPJ/J/G6XCp7wLTwCsZq
         g0CpgoyPv4AnvdRsFM6OIhX8KbpihEfsXa/si05eHm9eOpkWaiIa34L8OrPZ3Ob5oPBq
         k9Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739099453; x=1739704253;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fiV2XWtkfGXlde1QnvjR6tvTdGG2fr19IqREO8Jjig4=;
        b=k9iVt23YP+J9lB9e8p/Gf202a0BDTKIOf11H7aJjpia/TWhjRgOdUx5KNMtkeDeCu+
         nnfSKEz2/Ie7OrfPfsKGohOW2XAydkdutRb/3G2Qxw7mjnX6T1J/9Qe91H23Ojl589MH
         BJumM/YmpKuClthLT39m9J3nMCAEHIoTrpZy2/2R8u80kh+p5EtVJs226jx3Oc8lidmP
         xeOkwkNrKt4viOJZXB+k70wa1dfOihfPinAm7jb0pigv9PvSLWalZ9gK6U88D61JBo+u
         gmH8czFPaND9kS00CeBmMbu0OTljpFYw0j6he5G2CQO8ujIDcwfhY/mOnUnOh9mUtk2U
         EWLA==
X-Forwarded-Encrypted: i=1; AJvYcCU+OVx6tTPiJwf/9n6+zTOpaptVhTfhQu/APgDgzFHf5mg9vYL+DDPObaY0iZZxZ/I+qVXGtKmx9InU8Q8=@vger.kernel.org, AJvYcCVKN289KQ9h5ijEPpLg3B37xwc5+X+VtULfKDHL9NQzs+DITnuo3+GM4Pz2fksOKSt05fRKUqJLgOt+D+9P08fI@vger.kernel.org
X-Gm-Message-State: AOJu0YzVV9n4zw9lqU9OKKjDr2CShl1/dEpTfDAzHV+vZ3Yqepn62Xkg
	eP8aLr6cy+vBHfDaIOtzCedqOLXSgfosVyyUP3aCLoFX9661POI/
X-Gm-Gg: ASbGncuHRwC/Z0fpYmR4TkZoVH7MS6404GvCLEhk6f6PqOUVT8odFP09HybkZrcVKeQ
	pq2+grmupliFjxXEK1i2ZO/mRKm8URinFUA5EMdGO1d9zRyFJpPogGe1jcrTNpKBFPciJlxhTCE
	4sGlbbiQd3Z03yC9LRm9TvxcSx08K1HGP00fqtQ6gu28r3AQTT90F7BwttXdEpVM2dY7EYFVi0r
	1BplBjKpOiNnE/Gb6uHAj0BfDxNP5OYBaT4sQxOXs0o1GRHTiiaDLKsoINkU/4f8Bgv+d30iAEj
	is5T+YJw5nsihqjXCxgNPZs7Mhs/Ggy2SPGvC8BSbv2YLouBNorsI3BZ0ayDeQ0qX+fhtNTm8uw
	h+ThWIorb8VSenZbgEDuUdV1NuVdWkvXQ
X-Google-Smtp-Source: AGHT+IEmLnqa0nGSLzn3hjiFdgZfX9hAmJ8z1fc9klOPfXuoZo6FdGrvL+huNkWGACzBiYRhNwKTyw==
X-Received: by 2002:a17:907:6d16:b0:ab7:3e27:ff04 with SMTP id a640c23a62f3a-ab789a9f58bmr979157866b.3.1739099452941;
        Sun, 09 Feb 2025 03:10:52 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab79afc7452sm357516366b.163.2025.02.09.03.10.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Feb 2025 03:10:52 -0800 (PST)
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
	Kuniyuki Iwashima <kuniyu@amazon.com>,
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
Subject: [PATCH v6 net-next 06/14] net: core: dev: Add dev_fill_bridge_path()
Date: Sun,  9 Feb 2025 12:10:26 +0100
Message-ID: <20250209111034.241571-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250209111034.241571-1-ericwouds@gmail.com>
References: <20250209111034.241571-1-ericwouds@gmail.com>
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
index 5429581f2299..9f925dc3d1d1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3281,6 +3281,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index d5ab9a4b318e..70d767cb8bc9 100644
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

