Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BCBD3FB7D5
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jul 2026 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783678058; cv=none; b=ictCkd5gvT5FWep3csClJ9/nNYk3YLX+wUbBvhn2wB+24ZhnqL9vEQMwWOOUsgYdxlP3o5h9Nu1ODgicoGXozg6EfJZd3s0fosOBsknc0aftVcTvCRS0Rx4UrEjTn2LW1ntd4fxsDY6Xrhry/er9v/Sdb9q19JXteMzVadR56Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783678058; c=relaxed/simple;
	bh=XPm0Cw0cr4GnuZEkAMMxZWZ9Lqe9bYuRBJ0J33En+c0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXX35WPoHXEsEqeck+y70nAJCdKbvdlDAB4BEnGDtJXvGuryU0sTx3d9G8PeMdOlexQgnHUckc3hLOTkerMwMa3VdfkMYekuEl4tf1wLRbzQJ3Ukf2g3oqB9q6A54v4UGq7m+Xb5nc8OSyjiSY5l+xFepsvkyQANSnk0PWE/0C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=Ks2py0XF; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="Ks2py0XF"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 984C86057E;
	Fri, 10 Jul 2026 12:07:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1783678056;
	bh=FIsABavW43nhgHqD3QEKHqGr7pFN0M4lhfA71loctfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks2py0XFo6/4GoyWgVTSdvKTT1sGHlJPHfYLYGWGx3umOrLJUvG4Ld2yei7xftrNQ
	 n46A9oQugJW3yfHPWfc329RHzxcASJDaYqXoUo2tiAnhBTj4lkk4EymGZxbNKwITMf
	 7pz7ajWKUbPtaL2wN3QUJ3q53r9YDlKQFabP2ORCt5KMg2mHFE+FGB78WqYNj43Gh0
	 b/2IyXYSQBoP4K7ag32vI1r0DaEZYp16o9Cu9EqDX5pCBasFnaoThC0/UfsOBXToxj
	 LNJAhL3mOCOHWroiBVnbhg37CphG7bCJ7ZMSr9x8+tcxQCA1m5IHdiwBpu1r11Wopm
	 xLi2x/QyVECEA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: razor@blackwall.org,
	ericwouds@gmail.com,
	fw@strlen.de
Subject: [PATCH nf-next,v2 2/3] net: expose dev_fwd_path() helper via static inline
Date: Fri, 10 Jul 2026 12:07:28 +0200
Message-ID: <20260710100729.1383580-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710100729.1383580-1-pablo@netfilter.org>
References: <20260710100729.1383580-1-pablo@netfilter.org>
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
v2: no changes

 include/linux/netdevice.h | 11 +++++++++++
 net/core/dev.c            | 10 ----------
 2 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index db04b6d2e8d2..3793a8c0b0be 100644
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
index 24c384ef9e78..48288a5dc870 100644
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

