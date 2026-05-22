Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5CF3CC7E4;
	Fri, 22 May 2026 10:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779446620; cv=none; b=m5W/PqRcelh7Dkda+NWjcV/ecVQJvhfUFMoVbzmDmTwa45dTQlOGAIQse44jLQU+GCqOX4KGRlwiyISMJ7g4DZxEQi61jaHrT5zduFjUWe78xHk/9M8EePIA8CLyuEZ3mVkwhSOqIWsvsYy2bOAPEfdqLBLlSwKuw7OEUdF07ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779446620; c=relaxed/simple;
	bh=+D72mYd5njkuzri/pOFlhAK7f+Nqu5Dw8zEYLnxZZE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F3RjGvAxNP3TUygolrbhpUNVAqaeZiqOlZ7xViw+o87y3saaMZR+q1t5nvGUVxIcecRtW48M1a1Cds+ke7Sb+BxBAJCDRsJELy8ObkJxqgOHxb8N8ieDqNCt86pyxZWTBJz+213BLokLFtEdAyrdtYjYCyU+KvO1FXjxL7VP6Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id 00531605BD; Fri, 22 May 2026 12:43:37 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netdev@vger.kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	<netfilter-devel@vger.kernel.org>,
	pablo@netfilter.org
Subject: [PATCH net 08/10] netfilter: nft_fib_ipv6: handle routes via external nexthop
Date: Fri, 22 May 2026 12:42:55 +0200
Message-ID: <20260522104257.2008-9-fw@strlen.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260522104257.2008-1-fw@strlen.de>
References: <20260522104257.2008-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jiayuan Chen <jiayuan.chen@linux.dev>

fib6_info has a union:

    union {
        struct list_head fib6_siblings;
        struct list_head nh_list;
    };

Old-style multipath (ip -6 route add ... nexthop ... nexthop ...) uses
fib6_siblings.  External nexthop (ip -6 route add ... nhid N) uses
nh_list, linked into &nh->f6i_list.

nft_fib6_info_nh_uses_dev() blindly walks &rt->fib6_siblings, causing
an OOB read past the struct nexthop slab when rt->nh is set:

  ==================================================================
  BUG: KASAN: slab-out-of-bounds in nft_fib6_eval+0x1362/0x16c0
  Read of size 8 at addr ffff888103a099d0 by task ping/386

  CPU: 2 UID: 0 PID: 386 Comm: ping Not tainted 7.1.0-rc3+ #251 PREEMPT
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x76/0xa0
   print_report+0xd1/0x5f0
   kasan_report+0xe7/0x130
   __asan_report_load8_noabort+0x14/0x30
   nft_fib6_eval+0x1362/0x16c0
   nft_do_chain+0x279/0x18c0
   nft_do_chain_ipv6+0x1a8/0x230
   nf_hook_slow+0xad/0x200
   ipv6_rcv+0x152/0x380
   __netif_receive_skb_one_core+0x118/0x1c0
  ==================================================================

Branch by route shape: when rt->nh is set, walk via
nexthop_for_each_fib6_nh() (also covers nh groups, which the original
code missed); otherwise walk fib6_siblings, guarded by READ_ONCE() of
rt->fib6_nsiblings as required by commit 31d7d67ba127 ("ipv6: annotate
data-races around rt->fib6_nsiblings").

Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 5e192a446ec8..c0a0075e2590 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -160,16 +160,32 @@ static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
 	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
 }
 
+static int nft_fib6_nh_match_dev_cb(struct fib6_nh *nh, void *arg)
+{
+	const struct net_device *dev = arg;
+
+	return nft_fib6_info_nh_dev_match(nh->fib_nh_dev, dev);
+}
+
 static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
 				      const struct net_device *dev)
 {
 	const struct net_device *nh_dev;
 	struct fib6_info *iter;
 
+	/* External nexthop: fib6_siblings slot aliases nh_list, walk via nh. */
+	if (rt->nh)
+		return nexthop_for_each_fib6_nh(rt->nh,
+						nft_fib6_nh_match_dev_cb,
+						(void *)dev);
+
 	nh_dev = fib6_info_nh_dev(rt);
 	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
 		return true;
 
+	if (!READ_ONCE(rt->fib6_nsiblings))
+		return false;
+
 	list_for_each_entry_rcu(iter, &rt->fib6_siblings, fib6_siblings) {
 		nh_dev = fib6_info_nh_dev(iter);
 
-- 
2.53.0

