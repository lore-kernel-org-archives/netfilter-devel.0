Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E34783C2D
	for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2026 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787852744; cv=none; b=iROkAOT2pYYwKK4szo670wQUjf8E/TCI4tKJIire8Aba0j2AV9IiuWYKqepMZBkNElq6w7m97fXLfzI/fyGBJ4sXi6ygQUN9tZbLpO8ua1DW6bvLQ6kRM+ah/3ut/ChLo3vcNxoilGkDjnQK6oC+kgn/ZIQLL3HCHNjSNNOZa0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787852744; c=relaxed/simple;
	bh=9xC83mFvUfdHhEn41N4ID5m6K4b8PuMT2tj5sRrBelw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oqj8wASPCfEHqwEFWJr0XF5+HRkbxkcKdzMKWmsgLGI0tiZvM+ZEHx2WulhG3Pr4uYYGKjB/BLNk2kamkWpOFTrv4XS7dB3USnbP+90DwYV2C/H/9dyiqzYt6Aego6ZL0f+uX2SP2GXK7I3PsiX3eELiqoZ1jJNJkZXrIrQJ/9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 973D96033B; Thu, 27 Aug 2026 19:45:33 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>,
	co+63bad23bb3b4cd85@bugs.sh
Subject: [PATCH nf] netfilter: bridge: verify device is a bridge port
Date: Thu, 27 Aug 2026 19:45:25 +0200
Message-ID: <20260827174525.16334-1-fw@strlen.de>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit ccb9fd4b8753 ("netfilter: revalidate bridge ports") closed an
rcu escape where a bridge port is removed from the bridge and then reassigned
to a different device.

Unfortunately there are gadgets other than nfqueue that allow such
escapes, one way is br_netfilter: skb will be queeud to defrag engine,
leave rcu protection, then, on reinject, stored device index may point
to a different device:

BUG: KASAN: slab-out-of-bounds in br_forward+0x304/0x370 [bridge]
[..]
Call Trace:
 br_forward+0x304/0x370 [bridge]
 nft_reject_bridge_eval+0x441/0x10c1 [nft_reject_bridge]
 nft_do_chain+0x21f/0x1610 [nf_tables]
 nft_do_chain_bridge+0x21b/0x1220 [nf_tables]
 nf_hook_slow+0xaa/0x1e0
 br_nf_hook_thresh+0x1f1/0x3b0 [br_netfilter]
 br_nf_pre_routing_finish+0x78f/0x14d0 [br_netfilter]
 br_nf_pre_routing+0xd96/0x1630 [br_netfilter]
 nf_hook_bridge_pre+0x290/0x4b0 [bridge]
 __netif_receive_skb_core.constprop.0+0x55b/0x2ba0

Revalidate unconditionally.  The fixes tag is intentionally wrong; that
change is a dependency and is also a required bug fix.

Fixes: 9874808878d9 ("netfilter: bridge: replace physindev with physinif in nf_bridge_info")
Reported-by: co+63bad23bb3b4cd85@bugs.sh
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/linux/netfilter_bridge.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7e9d..46cfebc587d8 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -55,12 +55,21 @@ static inline int nf_bridge_get_physoutif(const struct sk_buff *skb)
 	return nf_bridge->physoutdev ? nf_bridge->physoutdev->ifindex : 0;
 }
 
+static inline struct net_device *
+__nf_bridge_get_physport(struct net_device *dev)
+{
+	return dev && netif_is_bridge_port(dev) ? dev : NULL;
+}
+
 static inline struct net_device *
 nf_bridge_get_physindev(const struct sk_buff *skb, struct net *net)
 {
 	const struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
-	return nf_bridge ? dev_get_by_index_rcu(net, nf_bridge->physinif) : NULL;
+	if (!nf_bridge)
+		return NULL;
+
+	return __nf_bridge_get_physport(dev_get_by_index_rcu(net, nf_bridge->physinif));
 }
 
 static inline struct net_device *
@@ -68,7 +77,7 @@ nf_bridge_get_physoutdev(const struct sk_buff *skb)
 {
 	const struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
 
-	return nf_bridge ? nf_bridge->physoutdev : NULL;
+	return nf_bridge ? __nf_bridge_get_physport(nf_bridge->physoutdev) : NULL;
 }
 
 static inline bool nf_bridge_in_prerouting(const struct sk_buff *skb)
-- 
2.54.0

