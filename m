Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C81413D74
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783503194; cv=none; b=cQjY8Y27SbSQuC7WpikXp9HamemQraHDGb+H4UNkVenS8Eqf5kHcZlYHWhzCIzAWt8gaIGE9S+R+TgN3tENP4WXZnb/HfxNJfN4ohcbWxMLLm/hJUsGUeeSP2LvBuHtTslb+0Fn2TEjJ89qSIBfebteFWEK9Tjx/gacLwNo7ZH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783503194; c=relaxed/simple;
	bh=6uC1nHL/7YTknRaYsenhrTHl8CpaNBH8ausdajjuYvg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=umyX3rD9emrr6eqWsSZiuW4xBf/gpQk4TobCzru7PY/30L3kq1rpE73Wd+z2RwlGKfjeDwLvQxctnBSYLPr1a7pkxQ6xodCQbEW+Y/UObXd/YVC2IqsKLdA/Lol9DpXZb0FrVJtNh9C+hOgdSB7/BN0E5RCZ6RRO3GIberLf2W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ZLYQQTfo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ZLYQQTfo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 7BD6F6057F
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 11:32:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783503178;
	bh=oTlT3kT/EMeQA3/0aIlp/GganQ6oKpUuBUXZAQSQ480=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=ZLYQQTfo+pcDUrvL0+hR64nAZWLfFOoMUFi60BDt2FAZnYV11wops9vdZYoH9neb5
	 erMVeM8BKW+dhA2+Sct+a4zQa8f9K1+acd1w4FlvR7o3Lq2A91OjHs+C0xqyfHSrfE
	 geYHxVOwzTZJmwJabiYa0hP3mBOJI3tI/4kbsKYgTz0ZvP5bofq9p4U+4Qy16qqo3k
	 ZVvFtoVVajaOOHpnee4Nu2K1G2aBA1DNbFbzO8lhWbDU3GiP0WxuZ//NqS+117rL8r
	 ou6tZhIFW/UHot1VMLAYkzKfvoIMsS3wwwd7bMSWIb9a+COvwe5zswyi+dCRty+ykn
	 HAFsgN+CcGtUA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 3/4] net: expose dev_fwd_path() helper via static inline
Date: Wed,  8 Jul 2026 11:32:49 +0200
Message-ID: <20260708093250.1187068-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708093250.1187068-1-pablo@netfilter.org>
References: <20260708093250.1187068-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a preparation patch to be used by the bridge family to retrieve
the bridge vlan filtering information from the bridge port when
discovering the bridge flowtable path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v1: Just a preparation patch to allow to move the bridge vlan filtering
    path discovery code to the flowtable infrastructure.

 include/linux/netdevice.h | 11 +++++++++++
 net/core/dev.c            | 10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 41cd092b032c..9393d3088042 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3420,6 +3420,17 @@ void dev_remove_offload(struct packet_offload *po);
 
 int dev_get_iflink(const struct net_device *dev);
 int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb);
+
+static inline struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
+{
+	int k = stack->num_paths++;
+
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
+		return NULL;
+
+	return &stack->path[k];
+}
+
 int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack);
 struct net_device *dev_get_by_name(struct net *net, const char *name);
diff --git a/net/core/dev.c b/net/core/dev.c
index 9a065c286d92..6b0e83fe743f 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -740,16 +740,6 @@ int dev_fill_metadata_dst(struct net_device *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(dev_fill_metadata_dst);
 
-static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
-{
-	int k = stack->num_paths++;
-
-	if (k >= NET_DEVICE_PATH_STACK_MAX)
-		return NULL;
-
-	return &stack->path[k];
-}
-
 int dev_fill_forward_path(struct net_device_path_ctx *ctx,
 			  struct net_device_path_stack *stack)
 {
-- 
2.47.3

