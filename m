Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12DD4341AD6
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 18:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776795427; cv=none; b=RbHKFRlAZGVv5/eGNyscRfqEsWttEsNSB7nVXU2BAT8DTr5M72MOxAHmzAlpLQgUAdEftDXZPuWSaYnWAZ1zkusLcUDCxnNRa6XLYfqDWqotUfSmMtjxPHjV/GIgF/9dUx4GlrFV66VGkATNNPoWoVeOp69wKcFi1TOdWZXpVP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776795427; c=relaxed/simple;
	bh=/YUh5XHOtUIgcUqDAwMhUMmnophTt7Um0NN0XI197WE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=logxlKjhw+CO8uFrmjyc59jHSCbKJJXeUu0tnMD7IZfTutq4GuJ5Wwc4wGJwxH9cqb4146XLuGGZFRUKsHPZKY5EZQL1SpoU1/DV2AxetxGfcbu5BeCbcBNDVekVOfKvg29ZfbshqcQkYq8dYKj6j615pAD3GxatNf/Z0USS4vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=v9i+cYKl; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="v9i+cYKl"
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 5867760181
	for <netfilter-devel@vger.kernel.org>; Tue, 21 Apr 2026 20:16:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1776795418;
	bh=/8lu3xgNOu26KIqyIV/ovhUuuonLToSPSq6JAw3raF0=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=v9i+cYKl66E7dfJYIWstt+YtqnbjnS9ekc712dR2knHESTr5xRRm6h28Flzy7diN4
	 51rDK2yAXl9RmTXy5oGvX1IjbJcOtr8Bq1FZLqQGKi8PAbDRRZIfqekmnIaEq3m2He
	 R5q2jWEWwGCtV3hqPkEUB7i3x3hUgt0L6kcjpQS3z6Q/JfcgR/KIYXqA1BOXmnM84q
	 7SU800tf9rNbBdKo5SFVt1cSoVD+/9CYWTZmF0m3TT4XPYYpBjSPC/jatP1IPssGq0
	 yLin5obx48xk1Jl9Cz/JqsdOZ/Hokjp2XciZWL5VuLt4VpKVl17mLVrkGsz5ahibj0
	 QAZ5UNedWHyoQ==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf 3/3] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Tue, 21 Apr 2026 20:16:52 +0200
Message-ID: <20260421181652.161719-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260421181652.161719-1-pablo@netfilter.org>
References: <20260421181652.161719-1-pablo@netfilter.org>
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
index e348fb90b8dc..3b0a70e154cd 100644
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
index 8b6394660d1b..1feb2aa43191 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -151,6 +151,11 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL) {
 		verdict = NF_DROP;
@@ -159,7 +164,9 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 
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

