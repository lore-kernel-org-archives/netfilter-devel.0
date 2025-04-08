Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD5B2153EE;
	Tue,  8 Apr 2025 14:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744122504; cv=none; b=NV8hGMAbpOkfOcXo7rnUlxcbhQKX6akFGTDKNIMFxTrDAoY1gBhMNMLwQcWdI80z4FMr5pQI1ZqxR41w3HMdKmcgG2zMKWDcmbpeI6zNAy6dTTzAF3yoETbYCwKbSIKYZCwakC/EsrWOymgcn/XqIb2G5KtCbh/8lCFnjjtZb38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744122504; c=relaxed/simple;
	bh=WSZKz/K7UVWoWk6FUYdxDqC2g3rdJrKCTr4jqbfvyY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6NCFR3tzAakK8ncff4ASErnKIiG9wZI5qGBEiVKsv/CqR15Bj2nLh/ktkNqBzDkXl2pwFR5w7qbwyalu22md6wIQtgnM3LOxbrRF4hbY/Nt8G7F0Fd9atghalF+kJE1XSgpq8ThxHQqCh5dokHjcm2zRzXOkjnFv2R4Jro9Tss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l0BGJB1B; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l0BGJB1B"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e60cfef9cfso9279638a12.2;
        Tue, 08 Apr 2025 07:28:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744122501; x=1744727301; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wiK3xf56Z+UJiP7fuMR0BqouNVJG3LzaRWNpv+Rl2O0=;
        b=l0BGJB1BHUOSiNoj1eucznXyyWjLcVe6iwsYEyIshlsCuua9FXheJNPHE58dqW4E6I
         7hat51fBI+xhj9/+C7ZAF44BlfyGzvohTrCxQEmaarbEZmr24Ux5oFqsJBwi14ePXCY4
         eKdv2VMcBCqD3hIFxJVsPOFQEHIsp9Uj/SLLygs7WTwR3uN0x4TcSl/0vXtIYn/vGbfT
         bl+J0rf4+PmlFwSVTNMYdzzhrENjqbjlBcCWe97lW02cZYo8IYTHnksHxQffjoCgBHxC
         hTBjd7RwNgljKn2cJTDfDFLF1KKbsVcUemG/VG89ePYbkQ2DN78Aob6q9EcGWZ1+wpq7
         RZbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744122501; x=1744727301;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wiK3xf56Z+UJiP7fuMR0BqouNVJG3LzaRWNpv+Rl2O0=;
        b=nuwkgchNi6TaAagRcmiqZLjVzs5xDI25z9rNb6TGVXFJeu9uI3GbzvMhFUkHHSHQ+L
         HUg00X7JnyG+eRkHcDRuVQOxMMGThQdeDlSfU+Qh5e5mik+YSFVF20d0NkiXTNFWXkRr
         BdSWwVwh37XaGcflr0hR2hUlQyTMgoTTL9iQq7BchJl3A0wb2gQhEGs0XKz0NPyXJp/k
         OA3lD52wor1GubsHgvqx0VKcvYGgO7UtbgFZ615kuZ31kJMdQGbC9aksFJsS8BufrUDE
         KR/ARItl57+ELnY370SGrsPIBDsFaTHeftNYStgxz17nxiCEtw0m90a/6lowhbV/a+Ex
         L/bQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJ/xvh9rcHDTcDPWQxVNZAKQJYZV2Zvjy/I8bL8JnM5M7YHR5OK7IRfJNLWL709EDUEvzojo/ci3pFPuR8938=@vger.kernel.org
X-Gm-Message-State: AOJu0YwerhJZ0k65dus5VbM2KwHjNFgy/+XhFrsdMkrakZfq0EIJ4sQC
	r+ONNqCVLKkZ4iw40SbSpv1MSxdTve8X169P0oWIGxm8G+q76atE
X-Gm-Gg: ASbGncvThmCncjQRkGT3JaQBlK0T1bHEUya9ebSa61hxgClo6eUG790f+Lj7oHjPuMB
	r2Wz5omzk6cKYiB8cxxvsO6qv0O6rinpkqMxBi4V5vA28Wwez8tr/VN4GTunl164qvn9QHWl/FJ
	slIJGOiysqRGHupYzVo3wb5xsfMf02j/Q/9l07bTcFtVh3f1zSPCtIuyC8WUu0T6Qik21Q8tevx
	h70sfSWTZsYtARgXMBh4X8ZCsG7fSa1ysGC7UZD8gavlgPtBJmh9On/5W0/baG4SjhiC1zdrPzt
	LQ37WMfPUoWYQTydpT5on/2QZmfpMJCETuJQMkp3EH09aW9o/92jdFBaPAtqD0h8B7rkvnO4E6S
	4lqkadqfAG8nhaZPjOJRO3rhq6h/kWFYeoV64ikYtfWvQNXU8d5R2lNxQY1IKub8=
X-Google-Smtp-Source: AGHT+IEh1oD6QhBQpwHASU08pMMzkJ2QyGD37Ub4ebSI+AqhO2VlkmxqtJBlgYtboV/1HH1EjIWc4g==
X-Received: by 2002:a05:6402:1d4e:b0:5eb:9673:feb with SMTP id 4fb4d7f45d1cf-5f0db88a448mr9660131a12.25.1744122500632;
        Tue, 08 Apr 2025 07:28:20 -0700 (PDT)
Received: from localhost.localdomain (2001-1c00-020d-1300-1b1c-4449-176a-89ea.cable.dynamic.v6.ziggo.nl. [2001:1c00:20d:1300:1b1c:4449:176a:89ea])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f1549b3fd0sm2236164a12.35.2025.04.08.07.28.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Apr 2025 07:28:19 -0700 (PDT)
From: Eric Woudstra <ericwouds@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Ahmed Zaki <ahmed.zaki@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: netdev@vger.kernel.org,
	netfilter-devel@vger.kernel.org,
	bridge@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>
Subject: [PATCH v11 nf-next 2/6] net: core: dev: Add dev_fill_bridge_path()
Date: Tue,  8 Apr 2025 16:27:58 +0200
Message-ID: <20250408142802.96101-3-ericwouds@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250408142802.96101-1-ericwouds@gmail.com>
References: <20250408142802.96101-1-ericwouds@gmail.com>
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
index 4e8eaae8c441..cab2482a6967 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3323,6 +3323,8 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+int dev_fill_bridge_path(struct net_device_path_ctx *ctx,
+			 struct net_device_path_stack *stack);
 int dev_fill_forward_path(const struct net_device *dev, const u8 *daddr,
 			  struct net_device_path_stack *stack);
 struct net_device *__dev_get_by_flags(struct net *net, unsigned short flags,
diff --git a/net/core/dev.c b/net/core/dev.c
index 0608605cfc24..3c365e816107 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -729,44 +729,84 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
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

