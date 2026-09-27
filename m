Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194013CF05E;
	Sun, 27 Sep 2026 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790546922; cv=none; b=rFYhy6mzq7iwwld07/Nr9B/G8HqS4ORgSPklSh+ORFgxBn4Vffze00nKz6wR/NsnVg4Phg22Dc2Q9EV6oWWpuf3W1wCZJa0DmkYhPqpYWw0n+8ot2Vq/iUm3wWK140nBR3rp977rQ+5Hj3ZRemlXGzfC90SL0ZmYD4KiZG4XJ2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790546922; c=relaxed/simple;
	bh=J4MJVI4cmv2QPDx/rEn6/wlLrDJcKtHzJVQOkHNm9TY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=My5D1q2d4CNyWOWUilwQoMu1POFAnI86L6x/ko8ZQuAijtnh9U2U0We0T0T1dIAAr3b8RmQB8B1F9dOZL4SUgoDNHXy0vGBWqKW8nTEe/xanyqeQRSEFMBK023ySR/uKKXRNWEqHrEh7C9a3yJcQZx5eJJMVHQ3WIiE98+0dBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=LZAqnG4q; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="LZAqnG4q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1790546915;
	bh=0w6DbEuY9JLsIBk9b7BselWCnUjNV7dsqVe8I+hW2Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LZAqnG4qeYgWyH3IJEwRSeoahqyEyE0GLBAOP7XzzOQ16a61MUhc1bRm1dRkYOez3
	 zkt4ZijJhH6+FQbD75pxp0vmHojOf+xI8z5wUvtaDPTVfOvCXBzRXfDpW6G9RLigWD
	 AkoWJzBjKJCjCt37Kpwfu0jJjI/fIMlPKwkxKqeZIU8BecISUPODpPOF77wOowyXij
	 547OWAMqrNsYhba6FhA1NYXtmkRCKgh1IlEAHKG9uyZ9wsPc8aRzSzzuPzevgcCSTW
	 7GJ1/APli+2NxnKMF/fXOlKndVsztgAfCXDNP0YaAL1AZOuczBtAWRXgmKPSHUqv1g
	 +TW8w57HL7OyQ==
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id E6FC6603DE;
	Mon, 28 Sep 2026 00:08:34 +0200 (CEST)
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	horms@kernel.org,
	fw@strlen.de,
	ja@ssi.bg
Subject: [PATCH net 11/11] netfilter: flowtable: restore ieee80211 forward path
Date: Mon, 28 Sep 2026 00:08:16 +0200
Message-ID: <20260927220816.268206-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260927220816.268206-1-pablo@netfilter.org>
References: <20260927220816.268206-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Before commit 871df5007eda ("netfilter: flowtable: bail out if forward
path cannot be discovered"), there was a fallback to set up a forward
path in case .ndo_fill_forward_path fails or DEV_PATH_MTK_WDMA was used.
Such fallback was used by commit d787a3e38f01 ("mac80211: add support
for .ndo_fill_forward_path").

One possibility is to handle DEV_PATH_MTK_WDMA from the flowtable
forward path discovery. However, this is only used internally by drivers
to retrieve mtk_wdma information to set up hardware offload. Felix
decided to use the .fill_forward_path interface for this purpose due to
the lack of a better interface at that time.

Add a new DEV_PATH_IEEE80211 path which is offered if the new ieee80211
flag is set on in the struct net_device_path_ctx to restore the
flowtable with a ieee80211 netdevice. Handle this new DEV_PATH_IEEE80211
path just like DEV_PATH_ETHERNET and DEV_PATH_DSA, ie. this is the last
netdevice in the stack.

This new ieee80211 flag is implicitly unset for mtk_ppe and airoha which
call dev_fill_forward_path() to retrieve a DEV_PATH_MTK_WDMA path.

Fixes: 871df5007eda ("netfilter: flowtable: bail out if forward path cannot be discovered")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h          | 3 +++
 net/mac80211/iface.c               | 7 +++++++
 net/netfilter/nf_flow_table_path.c | 3 +++
 3 files changed, 13 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 87cafc932e9e..3cff2174dc03 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -887,6 +887,7 @@ enum net_device_path_type {
 	DEV_PATH_DSA,
 	DEV_PATH_MTK_WDMA,
 	DEV_PATH_TUN,
+	DEV_PATH_IEEE80211,
 };
 
 struct net_device_path {
@@ -953,6 +954,8 @@ struct net_device_path_ctx {
 		u16		id;
 		__be16		proto;
 	} vlan[NET_DEVICE_PATH_VLAN_MAX];
+
+	bool			ieee80211;
 };
 
 enum tc_setup_type {
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 889c32fd8de1..c5584435fde9 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -1023,6 +1023,13 @@ static int ieee80211_netdev_fill_forward_path(struct net_device_path_ctx *ctx,
 	struct sta_info *sta;
 	int ret = -ENOENT;
 
+	if (ctx->ieee80211) {
+		path->type = DEV_PATH_IEEE80211;
+		path->dev = ctx->dev;
+		ctx->dev = NULL;
+		return 0;
+	}
+
 	sdata = IEEE80211_DEV_TO_SUB_IF(ctx->dev);
 	local = sdata->local;
 
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index 1e55644f2edb..d90013685bf1 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -53,6 +53,7 @@ static int nft_dev_fill_forward_path(const struct dst_entry *dst_cache,
 	struct net_device_path_ctx ctx = {
 		.dev = dev,
 		.ether_type = ether_type,
+		.ieee80211 = true,
 	};
 	struct neighbour *n;
 	u8 nud_state;
@@ -114,6 +115,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 		path = &stack->path[i];
 		switch (path->type) {
 		case DEV_PATH_ETHERNET:
+		case DEV_PATH_IEEE80211:
 		case DEV_PATH_DSA:
 		case DEV_PATH_VLAN:
 		case DEV_PATH_PPPOE:
@@ -123,6 +125,7 @@ static int nft_dev_path_info(struct net_device_path_stack *stack,
 				memcpy(info->h_source, path->dev->dev_addr, ETH_ALEN);
 
 			if (path->type == DEV_PATH_ETHERNET ||
+			    path->type == DEV_PATH_IEEE80211 ||
 			    path->type == DEV_PATH_DSA)
 				break;
 
-- 
2.47.3

