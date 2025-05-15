Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFE725B66D
	for <netfilter-devel@vger.kernel.org>; Thu, 15 May 2025 18:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747332506; cv=none; b=GDal11DfCNml+h/qedUnoeksdyOBzXkgCJ25CdZy3+p2PA8xnsSSljL5hbQ+KI8EeZOsqwJJzAiKrJz83irXCZ5FTh0j2oDb1qv9Q3iYzNZLUod6+rLBgRD+TqJTj91zSssKbH/9eeL3gJIB4KLDJkYptoTEBKR3rKKGW4KRZug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747332506; c=relaxed/simple;
	bh=5TMX27h5rmCGdg+VESheVswmBoUmsDOksOLj7Q+h82I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cz5sFkofwAIsVydukzZHYk0CO//XR/5oC099YXXpmnVQ7wnmSVUK+TGeRE8E4iAL10SCdrxTHHo3xgbXRhxH7mw0xlgJsjlOQhE6xaDCahglZhvdfvOksxOpRtky81GLVNDuSJOQWPUA5X4SGIW4W+4zSaKvxVU8rHs33Gnzd2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=Chamillionaire.breakpoint.cc
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id E4A9B60033; Thu, 15 May 2025 20:08:22 +0200 (CEST)
From: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Cc: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 3/5] netfilter: nf_tables: nft_fib_ipv6: fix VRF ipv4/ipv6 result discrepancy
Date: Thu, 15 May 2025 20:06:50 +0200
Message-ID: <20250515180657.4037-4-fw@strlen.de>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250515180657.4037-1-fw@strlen.de>
References: <20250515180657.4037-1-fw@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With a VRF, ipv4 and ipv6 FIB expression behave differently.

   fib daddr . iif oif

Will return the input interface name for ipv4, but the real device
for ipv6.  Example:

If VRF device name is tvrf and real (incoming) device is veth0.
First round is ok, both ipv4 and ipv6 will yield 'veth0'.

But in the second round (incoming device will be set to "tvrf"), ipv4
will yield "tvrf" whereas ipv6 returns "veth0" for the second round too.

This makes ipv6 behave like ipv4.

A followup patch will add a test case for this, without this change
it will fail with:
  get element inet t fibif6iif { tvrf . dead:1::99 . tvrf }
  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  FAIL: did not find tvrf . dead:1::99 . tvrf in fibif6iif

Alternatively we could either not do anything at all or change
ipv4 to also return the lower/real device, however, nft (userspace)
doc says "iif: if fib lookup provides a route then check its output
interface is identical to the packets input interface." which is what
the nft fib ipv4 behaviour is.

Fixes: f6d0cbcf09c5 ("netfilter: nf_tables: add fib expression")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv6/netfilter/nft_fib_ipv6.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
index 7fd9d7b21cd4..f1f5640da672 100644
--- a/net/ipv6/netfilter/nft_fib_ipv6.c
+++ b/net/ipv6/netfilter/nft_fib_ipv6.c
@@ -158,6 +158,7 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 {
 	const struct nft_fib *priv = nft_expr_priv(expr);
 	int noff = skb_network_offset(pkt->skb);
+	const struct net_device *found = NULL;
 	const struct net_device *oif = NULL;
 	u32 *dest = &regs->data[priv->dreg];
 	struct ipv6hdr *iph, _iph;
@@ -203,11 +204,15 @@ void nft_fib6_eval(const struct nft_expr *expr, struct nft_regs *regs,
 	if (rt->rt6i_flags & (RTF_REJECT | RTF_ANYCAST | RTF_LOCAL))
 		goto put_rt_err;
 
-	if (oif && oif != rt->rt6i_idev->dev &&
-	    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) != oif->ifindex)
-		goto put_rt_err;
+	if (!oif) {
+		found = rt->rt6i_idev->dev;
+	} else {
+		if (oif == rt->rt6i_idev->dev ||
+		    l3mdev_master_ifindex_rcu(rt->rt6i_idev->dev) == oif->ifindex)
+			found = oif;
+	}
 
-	nft_fib_store_result(dest, priv, rt->rt6i_idev->dev);
+	nft_fib_store_result(dest, priv, found);
  put_rt_err:
 	ip6_rt_put(rt);
 }
-- 
2.49.0

