Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348D41F4C96;
	Fri, 28 Nov 2025 00:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764289443; cv=none; b=CPhALzqYlFhkThO72m245jQi4Yw5WBAUOHnR299n3Zaq9QYrMA3LbBR4jFqBmHmDyWj+TJl5gs15pkERNi1c6iHRoCMCqEeQ/UdTJvUEhh+O/iIB4yUvMfLhF/YjgjmPGESPvK2Rro7uxzEXU5mvcDK2swi6HVwU6CkJ0O0lCTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764289443; c=relaxed/simple;
	bh=92s+iXFcCRAFZDaZsvxh61yayZkthT2yOKS5yVqhcFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FT3WtRu709mNCYXY5BDfIZ9UUQFchbU7GKUYpW+FzYt8Ee3m6LEL97Ap6hlhpW3aX1Qvj5FJR5t1LWM+2zU2lRAnZ0xCu36A29ohd0eCJvaCHFyHMztVM3SXETWu6WKGdTMxrEqgRifg3YXHHRFYeDe1olufsTUnoO8SfCGSPY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=c9oFsPKo; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="c9oFsPKo"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id A97E260276;
	Fri, 28 Nov 2025 01:23:54 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1764289435;
	bh=9TqhxNroRLoWX51mCgmxkrZNacy60dIGDus9+CKmAsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c9oFsPKoMGJ9/rqtPEAgijckvfFKOs0NWZDs4tVHyEyuu7gHFWhZZ8+9DkcxgH8A1
	 KGdp/+T1upyLmkj3FNnxnMjJR4CtzBiSKs6lSWN3W9RiB2ezrv6w2/6XAtSfHAMCRr
	 qnKqNg9AsL3svEjMCZieq9niwOLMCdyjRfQNVHu3HJnJyWtVV5MaD0uy/bkLwQtfcY
	 v0565J0bXdzq+gOXhKirf1AvNFcoCLIwnwiHwIgGS8e2LXWt8n1Lc/Jp9hc3Rmwxfh
	 GDb73WXAfjfBLTjMOF/ZmsgVjg0BR3TktRz4Wa/lfLYVQJSfKDRH8KDdOn5FE2mbnm
	 rrnK/ZDOu3h0g==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net-next 04/17] netfilter: flowtable: inline vlan encapsulation in xmit path
Date: Fri, 28 Nov 2025 00:23:31 +0000
Message-ID: <20251128002345.29378-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251128002345.29378-1-pablo@netfilter.org>
References: <20251128002345.29378-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Push the vlan header from the flowtable xmit path, instead of passing
the packet to the vlan device.

This is based on a patch originally written by wenxu.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c   | 25 +++++++++++++++++++++++++
 net/netfilter/nf_flow_table_path.c |  7 ++++---
 2 files changed, 29 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index eb4f6a11e779..aef799edca9f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -413,6 +413,25 @@ static int nf_flow_offload_forward(struct nf_flowtable_ctx *ctx,
 	return 1;
 }
 
+static int nf_flow_encap_push(struct sk_buff *skb,
+			      struct flow_offload_tuple *tuple)
+{
+	int i;
+
+	for (i = 0; i < tuple->encap_num; i++) {
+		switch (tuple->encap[i].proto) {
+		case htons(ETH_P_8021Q):
+		case htons(ETH_P_8021AD):
+			if (skb_vlan_push(skb, tuple->encap[i].proto,
+					  tuple->encap[i].id) < 0)
+				return -1;
+			break;
+		}
+	}
+
+	return 0;
+}
+
 unsigned int
 nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 			const struct nf_hook_state *state)
@@ -450,6 +469,9 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+		return NF_DROP;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rtable(tuplehash->tuple.dst_cache);
@@ -754,6 +776,9 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
 
+	if (nf_flow_encap_push(skb, &flow->tuplehash[!dir].tuple) < 0)
+		return NF_DROP;
+
 	switch (tuplehash->tuple.xmit_type) {
 	case FLOW_OFFLOAD_XMIT_NEIGH:
 		rt = dst_rt6_info(tuplehash->tuple.dst_cache);
diff --git a/net/netfilter/nf_flow_table_path.c b/net/netfilter/nf_flow_table_path.c
index e0c69fea2e0c..38ebda1afdce 100644
--- a/net/netfilter/nf_flow_table_path.c
+++ b/net/netfilter/nf_flow_table_path.c
@@ -119,13 +119,14 @@ static void nft_dev_path_info(const struct net_device_path_stack *stack,
 				info->indev = NULL;
 				break;
 			}
-			if (!info->outdev)
-				info->outdev = path->dev;
 			info->encap[info->num_encaps].id = path->encap.id;
 			info->encap[info->num_encaps].proto = path->encap.proto;
 			info->num_encaps++;
-			if (path->type == DEV_PATH_PPPOE)
+			if (path->type == DEV_PATH_PPPOE) {
+				if (!info->outdev)
+					info->outdev = path->dev;
 				memcpy(info->h_dest, path->encap.h_dest, ETH_ALEN);
+			}
 			break;
 		case DEV_PATH_BRIDGE:
 			if (is_zero_ether_addr(info->h_source))
-- 
2.47.3

