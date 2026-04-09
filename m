Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BAA288C81
	for <netfilter-devel@vger.kernel.org>; Thu,  9 Apr 2026 05:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775713119; cv=none; b=hvKW48Bf/R9yNL7uqx1CsfHFnsmcLzGaOfZKpm0XPVBeexy9Ak7ml1EK/bokr8UBEepUTiLeinzWvsRVFwf0b5qTHMOnrWJsGQm7Ohj9ZInJE4EII0zdJpc45W/HCnjfgGdhH+SC23s6zsTtGYaNrFMODUX2aRoxvQPLCeAS7rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775713119; c=relaxed/simple;
	bh=jSZqAPWmD5UeBY3lSP9uJxinqmVaSj4JkxvzKupoWFs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eWwdYXGrtMZWRTt/XSAA3wDaPwJFaXkTCzueCrabYkSIX/oelYY2JxOqOUktoJJHs1xU+tcw3QmMFYGAgfWjdHVauLJfVqJtwEUKeDhjZIZnCusoY++ke3tOdecfty9zGhjFSsjwgShhaPpWsoDF/dVPwuKJ/fj5c4x/QC/lqz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VxKuQp8K; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VxKuQp8K"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35c238f1063so430472a91.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Apr 2026 22:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775713118; x=1776317918; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ILbJrQUr91XnPo4IXS4Hz0fGhwl0HdfH9Des4pJSJPA=;
        b=VxKuQp8KU5Qh/TWF33nPzfh5les7E8yWE0Z+fTjDg7i31dwIfhAV23FHYhzUzcF++r
         PQHAolb7gq2lVlMq4LfXDqONX7A0M/lWBR2IMMB54rncwk1aIQHpmsP32ZozBMAInsIl
         h7fgpfbjeXm4G8Z74TfncG5CpKpRMh+Wk4pcYy13yRpVMXvKoL7bXDNHrduvjWE9S+S3
         l0XFM0OClmmaEB3Zolm6DDuuwoEx2GWoPSFo2QfnVd4I/hsRMjovHXJCQrwRRl4DwW0Y
         wJxF+CkSij4yRibcKJH9DlPRzN/zs68sdfxwq8kHlviasEhl4gLwUmfrmty9YwGuQy1W
         ASvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775713118; x=1776317918;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ILbJrQUr91XnPo4IXS4Hz0fGhwl0HdfH9Des4pJSJPA=;
        b=saIe7S3vsr8xKcEQvbwGZfB9xnQaE9MXzgviWARWqERB68MiHI84zdEePbxLS/izHI
         8c/t94QYTcl2lfcfsn2WmqBtsbJpSQok7dpaUXUV0QgjuUUZA06SEigQ9af6YMv7iGe5
         jI6yp6Qk7uX+OHfuCcGekt1dOuV0NiuLe3MeySHJVgXVyJRN6XdUacBhY2+iSvJpSnCA
         Tjk3WhXvskExWuaipq3zN1BKPpyJJAHLqDi4Ri2ZeNYpHHVJkk2bB5Rc4STh46TK2r78
         LYNbYTyfrYwqZHGwSN+TLqaYSlh4zlJTFsIUe7ym64VgoYWbJzn7RgXLZ7tu3E9USn/o
         TTQQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1jAERzrmpcdnNmRRVS7rgOKUGK6OrEX4US9r1urgZR4T4uCAURqfv+wEpj92WDXdCPiC8b3UkLPrqaJgtTuc=@vger.kernel.org
X-Gm-Message-State: AOJu0YzBZOhAp1t5bsmOclJgZ3Be7+pyFmDHYThgBLWFgvnvQxyP7+nf
	fxvm7YPxrETgSZPXMUdCpY0RzZaRaFEpv78ptOjlKsls9UoAlxPtvGMv
X-Gm-Gg: AeBDieumm7lgYGUX7hKEP2JD8QfJuUBB/Aj9GUJgxZJeYQ6YFUVUkR9gNX8QFPrFamc
	o2RjhlDnQ6ov1ERmbh1vescQdwJ8HEdAIt+KXWJ7yrYSAJTJ5I9YWuOD1zp/BcyWLkPWDzMm7IZ
	ZrKpFj/xr8huVsyf9SaDigk+v6FcbkTZOTCRtJxGdOVHD1/vBzVNiH2QvcqmH4fHRCFhe3lBdp0
	dgc4oTxF3vl4U3gZDrGRnOdhJqrPSmNpaaLu41PLy7snn1MQT2Kb+HnqXY57dHeq/caSJUKS5/0
	Wpj8U1NjmyOFzEESghXfm4nx9/9w/JzzvdsZzAw5zryi/alzPn9uo+uIDJQu8ajnxVyeVJyqHF5
	KAMbQIckhzeyW6xAaYX56xyS9AwygS2vZiBhmaLkiuVLJpmM0nK95Z70mbe5Sr3RPuKtb+r/TvT
	o0r9qclkgv1Qq2r5CUlPi06itu0xgQYLMz4FcNfp+vs4YwUtcRTAM+gWRMQopa9SM2iQkXrr5W8
	UNKmcv6LZVg
X-Received: by 2002:a17:90b:4b0b:b0:35b:e554:53a6 with SMTP id 98e67ed59e1d1-35e357e8828mr2303089a91.11.1775713117796;
        Wed, 08 Apr 2026 22:38:37 -0700 (PDT)
Received: from SLSGDTSWING002.tail0ac356.ts.net ([129.126.109.177])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35e34c459a3sm641380a91.3.2026.04.08.22.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 22:38:37 -0700 (PDT)
From: Weiming Shi <bestswngs@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: Phil Sutter <phil@nwl.cc>,
	Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org,
	netdev@vger.kernel.org,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>
Subject: [PATCH nf] netfilter: nft_fwd_netdev: use recursion counter in neigh egress path
Date: Thu,  9 Apr 2026 13:36:30 +0800
Message-ID: <20260409053629.698822-2-bestswngs@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nft_fwd_neigh_eval() can be attached to NF_NETDEV_EGRESS chains since
commit f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook").
When a forwarding rule targets the same device (or two devices forward
to each other), the evaluator calls neigh_xmit() which reaches
dev_queue_xmit(), re-entering nf_hook_egress() before the previous
invocation returns. This recurses until the kernel stack is exhausted.

The nf_dup_skb_recursion counter in nf_do_netdev_egress() was added by
commit fcd53c51d037 ("netfilter: nf_dup_netdev: add and use recursion
counter") to prevent exactly this class of bug, but nft_fwd_neigh_eval()
bypasses that helper entirely by calling neigh_xmit() directly.

 BUG: KASAN: slab-out-of-bounds in nft_do_chain (net/netfilter/nf_tables_core.c:287)
 Call Trace:
  nft_do_chain (net/netfilter/nf_tables_core.c:287)
  nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:289)
  nf_hook_slow (include/linux/netfilter.h:158)
  __dev_queue_xmit (net/core/dev.c:4807)
  neigh_resolve_output (include/linux/seqlock.h:392)
  neigh_xmit (net/core/neighbour.c:3230)
  nft_fwd_neigh_eval (net/netfilter/nft_fwd_netdev.c:150)
  nft_do_chain (net/netfilter/nf_tables_core.c:287)
  nft_do_chain_netdev (net/netfilter/nft_chain_filter.c:289)
  nf_hook_slow (include/linux/netfilter.h:158)
  __dev_queue_xmit (net/core/dev.c:4807)
  [repeats until stack exhaustion]

 Kernel panic - not syncing: Fatal exception in interrupt

Export the recursion counter helpers from nf_dup_netdev and use them
in nft_fwd_neigh_eval() to bound the recursion depth, matching the
protection already present in nf_do_netdev_egress().

Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
---
 include/net/netfilter/nf_dup_netdev.h |  4 ++++
 net/netfilter/nf_dup_netdev.c         | 18 ++++++++++++++++++
 net/netfilter/nft_fwd_netdev.c        |  7 +++++++
 3 files changed, 29 insertions(+)

diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
index b175d271aec9..17362f76d1d1 100644
--- a/include/net/netfilter/nf_dup_netdev.h
+++ b/include/net/netfilter/nf_dup_netdev.h
@@ -7,6 +7,10 @@
 void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
 
+bool nf_dup_netdev_has_recursed(void);
+void nf_dup_netdev_recursion_inc(void);
+void nf_dup_netdev_recursion_dec(void);
+
 struct nft_offload_ctx;
 struct nft_flow_rule;
 
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index fab8b9011098..e2fe8bb6fe0d 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -29,6 +29,24 @@ static u8 *nf_get_nf_dup_skb_recursion(void)
 
 #endif
 
+bool nf_dup_netdev_has_recursed(void)
+{
+	return *nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT;
+}
+EXPORT_SYMBOL_GPL(nf_dup_netdev_has_recursed);
+
+void nf_dup_netdev_recursion_inc(void)
+{
+	(*nf_get_nf_dup_skb_recursion())++;
+}
+EXPORT_SYMBOL_GPL(nf_dup_netdev_recursion_inc);
+
+void nf_dup_netdev_recursion_dec(void)
+{
+	(*nf_get_nf_dup_skb_recursion())--;
+}
+EXPORT_SYMBOL_GPL(nf_dup_netdev_recursion_dec);
+
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 152a9fb4d23a..d85f72af3589 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		goto out;
 	}
 
+	if (nf_dup_netdev_has_recursed()) {
+		verdict = NF_DROP;
+		goto out;
+	}
+
 	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
 	if (dev == NULL)
 		return;
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
+	nf_dup_netdev_recursion_inc();
 	neigh_xmit(neigh_table, dev, addr, skb);
+	nf_dup_netdev_recursion_dec();
 out:
 	regs->verdict.code = verdict;
 }
-- 
2.43.0

