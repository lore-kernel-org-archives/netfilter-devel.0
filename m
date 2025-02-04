Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C5121B8F8;
	Tue,  4 Feb 2025 19:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698602; cv=none; b=CmtDmFY+n1vVnpzYgJPfOvOAP0qzM3ffH/aB6NAQ3W6UoAlrVciqoaPp1L1A66EtsW3jO845oafUoT5DYxFfoj0Pxy6MVPvZh6HZ+1GiSZ7UwnPSrryEQfaWk0/IrnXSLmp0bweAzyXRnxSrWErt1U9zpNkfVGTWL2fX2uMQAlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698602; c=relaxed/simple;
	bh=jJ2Iimr6BJxlql197Mio9R5mbZtVtZjj3TNAmttbndo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=No39b7eYtj2VoxJo8MQQe3BPD4dTcFvwi3wJzWXLZqbV0gS/5q7q97fV3Xah/zqPV5ucf4msitsqLcL0ZAGM6TroFH/ITF1f0EnSr8O7FBxio8+aSj6z6ukSkAwtpnGSQcF39QD+SzQZvlizFIAQuBDSVqST1yQzHu9LwTDjmFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CD6YS8aL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CD6YS8aL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7430e27b2so340558566b.3;
        Tue, 04 Feb 2025 11:50:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738698599; x=1739303399; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CaTNlLcx8N/VOWeG8N/sMwOA19H7daJ4VH5LDcsIDAY=;
        b=CD6YS8aLU6+CJIWel9tSisuwvcXYuOKAfMp/gVdTnG1PBTp/yKakAMT+hkA5AkHCMZ
         QmSiq0OGltw4WMaAgb3AofEqAgFjqQbuJrF78csOi3gGN/ZyB5lcAHFL9Zwui27HvGc0
         sNmY0DR05C+DJCJjQaRGzyMNvTqKLgZ4m5T3Yfdca/89OdqGDOj1EsMX9KxTwh2ZnZWi
         R57BMEiZ+KeorlyqmwaWfax0OJf41n7wB+WyFZRBO84UA+B3gi6kLcM+pidn9zhVoNCO
         L7b7L3SZAwVY092dri0GrFn+NzVMC/NDPkfbceO7ksrVNK7D106ExyeOtKZTQn05hz7g
         Te3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738698599; x=1739303399;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CaTNlLcx8N/VOWeG8N/sMwOA19H7daJ4VH5LDcsIDAY=;
        b=lTh+aVgXmiCT7n6/fc7ZdSDJQOebC12ctc/6JTUHD02qfHphJqg9BRJsT8LKRcwUO+
         3yAcvSnHxz+kxpzUXMjKE1/FBHfPmrC1xMIjMIsw+G+0+mMZ4I9FiQP3cOF9LCXkHDUE
         cYbpP0OQX65UDv3rfCfWyICqrUN6L6ME0XBXFrvC8nMYUGVveQ0Afi8YJPv6ei6j96vw
         frj+8aY6W3fX1AcozoZZIG904gr1BGenzc/+2DKh/3I8er6fJ85y47MjhfhzjYI9wXTA
         u8rntDWWaXejEasGV0GTbr6KqN5nW9ZVKgs3WuQNPJUx18aLkkWG6yopN9kltM2SAI28
         Jfkw==
X-Forwarded-Encrypted: i=1; AJvYcCU3ZlyrLMOSzKQakBLOSDDrJkPKJAFahuvVGBVjdtQLuSJ99Y6DGORUfa8ifmmugXuqQg1gKhSV+fzYzLE=@vger.kernel.org, AJvYcCVYsUi0jJvKjvPoHpDziXb+ITPm3r+gX3VpfC6WrJQadK8N8c89fvuRIS60bajGgl7ZICVkY4fWT6LDHyVlJX10@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7IVvsLC8VPa0s9Zk/kNkqqn/6oZ5Leii6z34ocC6t9QHkA768
	pA7PoLPXlGNQMG9ESvYCovq2JZN20/xZU9vEIJs4QpJniaq3c4dt
X-Gm-Gg: ASbGncvAFnwFzy+118e/Fc6ZZ9d2eMmE57k+JHujvtJAdNDm5Jg3P+vP0Q8GHcbkpzf
	0wfoTB3aDgvOn6K+xSVpCViWY+GaPZbXWuP/xhRd8UorifNRveBfSYAp9jb3XcXzk1NsSecrvOI
	nXbJf1Y18/xpqFHgjGG61XfCIRGo1LG9HkesF0l0dmwf+3iPR53jSTb0PJXqb+Ne51nbgdSdMY/
	zugaYsexVOD/CM18oOpf347r1AD7M4fzQLQ3LCPWtxVHQXOD+0eAZ3ai8CxB58HDmlqvueZoiD8
	pk2gnbmSANzZLajPpLaRrNU9Ot1VC5Dj+KAinYkCdfeXJpl/7YG8J+HhTscGwRvJ1h+473A5b1t
	/blEeS5iDzV0OX3s3bgQ2Zpu+bcTmETCN
X-Google-Smtp-Source: AGHT+IEn1JUbmSDDmV4FTAJZUTLPh7UPgcV8aDhV23EvUqrbyMWgBZiKGFEz4RZTiOX9pR12aKTGfQ==
X-Received: by 2002:a17:907:3f8f:b0:ab6:61cb:ced2 with SMTP id a640c23a62f3a-ab6cfcc6f27mr3006053266b.9.1738698598722;
        Tue, 04 Feb 2025 11:49:58 -0800 (PST)
Received: from corebook.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab6e4a5635bsm964684466b.164.2025.02.04.11.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Feb 2025 11:49:58 -0800 (PST)
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
Subject: [PATCH v5 net-next 06/14] net: core: dev: Add dev_fill_bridge_path()
Date: Tue,  4 Feb 2025 20:49:13 +0100
Message-ID: <20250204194921.46692-7-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250204194921.46692-1-ericwouds@gmail.com>
References: <20250204194921.46692-1-ericwouds@gmail.com>
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
index 2a59034a5fa2..872235e30629 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3280,6 +3280,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index c0021cbd28fc..179f738f80d2 100644
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
 
 /* must be called under rcu_read_lock(), as we dont take a reference */
-- 
2.47.1

