Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FFF1E47BC;
	Tue,  7 Jan 2025 09:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736240772; cv=none; b=JNyAQitixbq03Slr8VRNvlWFBQkzQfHcrLtIVZyfzpXCqW5mlHeoB+9cWIWEiPq42UuZZzL+bL647hT6oDDtgwMeca0Akcjz4VNcGIjGV4AB7j3nl1O9mSjeUZi/lTLDKVRyg5N4NkuyXpi1jARpxe4HdbnNOyW+ro5/IQ/NrXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736240772; c=relaxed/simple;
	bh=7XmbWDndSEvs88PZzlZNFxYNYD1e9bNkx2NqAzllkzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMHpmdx9O/qSxywtnWVsXCOu0byoTXfbPIqBkHJyoSeCSN/BQWNxN2Y39gTreoRxcA0odKp0HaPUN6q6b1A0CRpgvgMxXqTROqVRTIS9Wh7C5cBUYklSjWikyujlwKjtt5+SwIA1bv96DeizzGoFqMsOF2BZ3ci0XMnSewW548k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XtjNUfdl; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XtjNUfdl"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3f28881d6so22742677a12.1;
        Tue, 07 Jan 2025 01:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736240769; x=1736845569; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nrwgi24+JwpSHmI0m5MVBAM3u5qvCwn+TDjEgeV2UcI=;
        b=XtjNUfdlhXs/HwxeGVf7SmkP9IO3QRT9OnHuPeJzlZ6RLrO5Zff+yyzW/RfRkrgtHz
         9mTKWu4fcXT8wIe4YXEsZb45kL4lsPRqdNYjE0WQnK36J9itH+oU6iHihJH4orJwX1zO
         I/bdLGoSj2xMk2TBeZUqm6riK2jImndQD05esYa4O+M5LXRNOb6o5KFJU1rZq9lMXyOS
         yU8xoNQ38Dz+eOkkX7x/cSYzux5h4kmUdE9qgCw8VzAU7ZAC45LfGf6CbNQdFOnu1pMD
         aooXilDeetbbm6GIX6NmRDclPgCUW6zRJELYNC5PIQMzSDCbbSI2fg/RsAL5I2D3EUeG
         UHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736240769; x=1736845569;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Nrwgi24+JwpSHmI0m5MVBAM3u5qvCwn+TDjEgeV2UcI=;
        b=IMlLXARXh13Puo9vJyqw2EOLxh4sRoNps933Gq1p0lapZqxcqiYvyu9etgIPwcHgU6
         lKx1GPfWQWQD0bVWRgXf9k6N9fKEkXghEr4Gl0qQs4BwhBcKRiAIp9lVTk0VPqoY8kjP
         e5XcGYRB5CZNDwfcpvExm47i8GDGBc1zPY09OTqtsisu+tG2o7XenpZ2Z92wsC3c4Kg0
         C7M2ij9xEVG/wfmgbs3ZiRzGFt21J4Zq/XDJC+szCH7lAMQ9plFFsYYTgXXH+9gh6ONT
         wkoWehvO9te9czuOEDEvOukKymkAdDLqfTf88AqrR+qp3uoyNDIrxw0bZyd0sML+tL8J
         nv9g==
X-Forwarded-Encrypted: i=1; AJvYcCU7QEyGojgG8n/tKDyzCNk3EWAtgDH83oh2G9Yg1aKY2nQYWg0E0kcsZVX6R7RT5uloZsbinbDejtqRaT3O7wby@vger.kernel.org, AJvYcCWMT9CeDXfeuNYMs2ppRGnbaDZ3LTUavj6MKOl+spTrwPNhIa/tWwtasHO2nxVRa/OTxXXc6uv4Sei4qog=@vger.kernel.org
X-Gm-Message-State: AOJu0YzrZk8WXRcpptIrfg+8SVcXDw/rgnokGWpojNtlB/c7oN9DYAoo
	zcid9AyD/p0EQzJ5Lvv7nTWFeUafz3JpZLJ6AJzjuni1OhIySDWc
X-Gm-Gg: ASbGncss+13GtuALqmqvb7UfPsCVh917uhN3a4tNX716rgV0BdG/+tnybt/AMWJeXgF
	rwTlJL/A+nTip4ukHBFhMObC9yRfXpKvsi5S/lnS2L2HhtW1k9kiHH23u49sFKDTx0JSEVvQnSq
	6/z1XWTgE1RFEsPmkSw2hXhustO9Rczf3oe9P+omTni6ktAOZ25xyQLtd38C9jyuNtU6L/kdplr
	zWxMOJeSn02BSj72ektUw5LmERz/fSmRzTCmh+Mv+ENnORqhqwnNsf5kJp/Afn0vkLbZYu/U00N
	cnKmUVuh73KbKw6YPk1gsKZ9HDUUDbbJxsmSuN6s3P2sRm51aFi2G8ryz+KdvqlAcA/UjFIr1g=
	=
X-Google-Smtp-Source: AGHT+IGuixhYjL4SuyghMfzPKIs9WMN7N2be7FgjYC3LBKQ+ZlOzUPBDz9qqDNyF0KSv3KcGoiKbCA==
X-Received: by 2002:a05:6402:40c9:b0:5d1:1064:326a with SMTP id 4fb4d7f45d1cf-5d81ddbf672mr139428959a12.15.1736240768590;
        Tue, 07 Jan 2025 01:06:08 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d80676f3f9sm24005333a12.23.2025.01.07.01.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 01:06:07 -0800 (PST)
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
Subject: [PATCH v4 net-next 05/13] net: core: dev: Add dev_fill_bridge_path()
Date: Tue,  7 Jan 2025 10:05:22 +0100
Message-ID: <20250107090530.5035-6-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250107090530.5035-1-ericwouds@gmail.com>
References: <20250107090530.5035-1-ericwouds@gmail.com>
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
index 2593019ad5b1..7d66a73b880c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3187,6 +3187,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index e7223972b9aa..f41b159ee9c5 100644
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

