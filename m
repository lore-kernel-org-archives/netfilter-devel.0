Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DFC3A2579;
	Wed,  8 Apr 2026 16:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775666139; cv=none; b=FVdMHAxXfTeaxKKO4fpMOHu2Mq+5KetGRfbIFvvJK1Hk/KwPRiXOWYZJNJM+Hy3cSymxkzFC3YWwxuwg/pMu0x3UvPV3wNZl0LtcsOT7LP/5+iyHVgauX0NCjJi9uDvLQzDcaJGLMZG0oTCWRTMXBkaGbD4HoX0UEW2AWKDLr6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775666139; c=relaxed/simple;
	bh=5c50JljN0nyluFTWQSs1lEg6gg+uEZ2+0xi27FPAPNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJ1Fc/Vp9KiXP60GECNTJQVL/8LDwfrrJMKPQHSzo71jxMQBqeSNYhAfRigEduu2lo4q0owmSy2kour63OjnF91BTVIseUpwGzTRxiaEoUWaC3DWmgeUdLCQrYKwRrRsNcUBLR6vQGDNTaGnNGxictIsUoDVtYbIOysC/cDx0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 0786A60560; Wed, 08 Apr 2026 18:35:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 5/7] netfilter: nft_ct: fix use-after-free in timeout object destroy
Date: Wed,  8 Apr 2026 18:35:10 +0200
Message-ID: <20260408163512.30537-6-fw@strlen.de>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260408163512.30537-1-fw@strlen.de>
References: <20260408163512.30537-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tuan Do <tuan@calif.io>

nft_ct_timeout_obj_destroy() frees the timeout object with kfree()
immediately after nf_ct_untimeout(), without waiting for an RCU grace
period. Concurrent packet processing on other CPUs may still hold
RCU-protected references to the timeout object obtained via
rcu_dereference() in nf_ct_timeout_data().

Add an rcu_head to struct nf_ct_timeout and use kfree_rcu() to defer
freeing until after an RCU grace period, matching the approach already
used in nfnetlink_cttimeout.c.

KASAN report:
 BUG: KASAN: slab-use-after-free in nf_conntrack_tcp_packet+0x1381/0x29d0
 Read of size 4 at addr ffff8881035fe19c by task exploit/80

 Call Trace:
  nf_conntrack_tcp_packet+0x1381/0x29d0
  nf_conntrack_in+0x612/0x8b0
  nf_hook_slow+0x70/0x100
  __ip_local_out+0x1b2/0x210
  tcp_sendmsg_locked+0x722/0x1580
  __sys_sendto+0x2d8/0x320

 Allocated by task 75:
  nft_ct_timeout_obj_init+0xf6/0x290
  nft_obj_init+0x107/0x1b0
  nf_tables_newobj+0x680/0x9c0
  nfnetlink_rcv_batch+0xc29/0xe00

 Freed by task 26:
  nft_obj_destroy+0x3f/0xa0
  nf_tables_trans_destroy_work+0x51c/0x5c0
  process_one_work+0x2c4/0x5a0

Fixes: 7e0b2b57f01d ("netfilter: nft_ct: add ct timeout support")
Cc: stable@vger.kernel.org
Signed-off-by: Tuan Do <tuan@calif.io>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_conntrack_timeout.h | 1 +
 net/netfilter/nft_ct.c                       | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_conntrack_timeout.h b/include/net/netfilter/nf_conntrack_timeout.h
index 9fdaba911de6..3a66d4abb6d6 100644
--- a/include/net/netfilter/nf_conntrack_timeout.h
+++ b/include/net/netfilter/nf_conntrack_timeout.h
@@ -14,6 +14,7 @@
 struct nf_ct_timeout {
 	__u16			l3num;
 	const struct nf_conntrack_l4proto *l4proto;
+	struct rcu_head		rcu;
 	char			data[];
 };
 
diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 128ff8155b5d..04c74ccf9b84 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1020,7 +1020,7 @@ static void nft_ct_timeout_obj_destroy(const struct nft_ctx *ctx,
 	nf_queue_nf_hook_drop(ctx->net);
 	nf_ct_untimeout(ctx->net, timeout);
 	nf_ct_netns_put(ctx->net, ctx->family);
-	kfree(priv->timeout);
+	kfree_rcu(priv->timeout, rcu);
 }
 
 static int nft_ct_timeout_obj_dump(struct sk_buff *skb,
-- 
2.52.0

