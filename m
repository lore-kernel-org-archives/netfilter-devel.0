Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7086BB640;
	Thu, 16 Apr 2026 01:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776303072; cv=none; b=hPG2Q+7LINJyfbCPW1qSacfT1xVpS+EkyvqhOW/i3vWwIEbiwS/rvFzBajVz/xjYbA+H6wGUV5clizR5tOt8NQoiKgikqxR8piyghCymceh4LyTAZNIGRk8Qt2cALJ0nQTKmPRHDqjuOH91leAJmuEQMXvL9KHgRu/qWcFej2DA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776303072; c=relaxed/simple;
	bh=KtxfLt/oWykY8oTaPQo1JT9xA7ZSb744uumJEXYVKlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jtD53Ae77UvZ/Hov6IBAZdsTQjbrSXkynfyxPHVwcMcZZIc/0OSjSCcwpDkMZIYVZWcoGtxuV/rLvY71jsPuaBStjcZFGXfXVbqUYCssS9tTYacOba/I397DDq+bdZ1zkq102r3LB7uhfVSDQw01ygX2f3U0rDryWZI7VvdGylw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=kf/5jmVi; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="kf/5jmVi"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 3758D6017E;
	Thu, 16 Apr 2026 03:31:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776303068;
	bh=oByUcGpenIY1XZsmXVVFXXQyKtnUZiH40rAFcVIDGx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kf/5jmViOF8H2Bf/Dbl4bppaCb/hhbMzZ1uTEw83wBfnwVJkfdiNq9TPmZR1T9L/8
	 Bj+8Ed/V8HEbeA7sYMyr6aLiSKNNKnkzengOg6MuRcmEzOw8OX2GwUjwfN2IvdnJ1n
	 GxQfbDfiyYWQYaNz5N5soHQZkqgvNt0CHiGXH6O3d/xxfKtQBJbcC8E1+xND/NSbGp
	 W+6bKPAqX5hSsdWIjXo4pYPSjOBYHaPb/3cC7PWKFWpvTnMCkcqmxnSgTMoZfI3bB/
	 Lvc+Wxq9HP0VjenMLuZExNTvkArDCkxRRnW4wZwTS7HSK6zp0dwdwIpp9NBySzC1Y7
	 vSoqB0DevnOEA==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net,
	netdev@vger.kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	fw@strlen.de,
	horms@kernel.org
Subject: [PATCH net 01/14] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Thu, 16 Apr 2026 03:30:48 +0200
Message-ID: <20260416013101.221555-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260416013101.221555-1-pablo@netfilter.org>
References: <20260416013101.221555-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Weiming Shi <bestswngs@gmail.com>

nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
forwarding rule targets the same device or two devices forward to each
other, neigh_xmit() triggers dev_queue_xmit() which re-enters
nf_hook_egress(), causing infinite recursion and stack overflow.

Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
to the shared header nf_dup_netdev.h as a static inline, so that
nft_fwd_netdev can use the recursion counter directly without exported
function call overhead. Guard neigh_xmit() with the same recursion
limit already used in nf_do_netdev_egress().

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
 net/netfilter/nf_dup_netdev.c         | 16 ----------------
 net/netfilter/nft_fwd_netdev.c        |  7 +++++++
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index b175d271aec9..609bcf422a9b 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -3,10 +3,23 @@
 #define _NF_DUP_NETDEV_H_
 
 #include <net/netfilter/nf_tables.h>
+#include <linux/netdevice.h>
+#include <linux/sched.h>
 
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+#define NF_RECURSION_LIMIT	2
+
+static inline u8 *nf_get_nf_dup_skb_recursion(void)
+{
+#ifndef CONFIG_PREEMPT_RT
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+#else
+	return &current->net_xmit.nf_dup_skb_recursion;
+#endif
+}
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index fab8b9011098..a958a1b0c5be 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -13,22 +13,6 @@
 #include <net/netfilter/nf_tables_offload.h>
 #include <net/netfilter/nf_dup_netdev.h>
 
-#define NF_RECURSION_LIMIT	2
-
-#ifndef CONFIG_PREEMPT_RT
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
-}
-#else
-
-static u8 *nf_get_nf_dup_skb_recursion(void)
-{
-	return &current->net_xmit.nf_dup_skb_recursion;
-}
-
-#endif
-
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 152a9fb4d23a..492bb599a499 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	(*nf_get_nf_dup_skb_recursion())++;
 	neigh_xmit(neigh_table, dev, addr, skb);
+	(*nf_get_nf_dup_skb_recursion())--;
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.47.3

