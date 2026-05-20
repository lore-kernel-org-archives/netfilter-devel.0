Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D50302767
	for <netfilter-devel@vger.kernel.org>; Wed, 20 May 2026 02:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779244470; cv=none; b=uoncQz38b74U72j8K61ZrjaXjW48WlKX3pUHUVzOV1kEPO2/8SEPNglvn8c5VDzjgGHGfyIPrivIaMtDIlbJnV8HWXwdcNmEvAweyRNkeGxXkBFUNGBC83tKmQYK9XtMDRuD/6r2ZIvkqQ51CAcjiqYtoTolLZqoq85lhgoH73I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779244470; c=relaxed/simple;
	bh=PF3702ltByiVjVvAWe4VUNrzgChyhh34C/oQjBk3VZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FSSHis93ciTNuQ1LvXDcuCD10Xk/OcSNl7DATCDIpi+DHPWnKlYRdsTi1rmbZMpFpSfoLsnXOXD7ZpiYeq6ayQ4syyQAFd36wbA+rixoxW5Ds/xknxkkWLvpSWKDXggRzOxHko0JH5YJWT6ZpIUzfiGwX7SjkPIFtvXwRRcqOVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mexVZnbE; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mexVZnbE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779244467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o6h8qat8VnORKzVOQjkn86NdOXo/20Wf4TS0ESthjn4=;
	b=mexVZnbElFqOR1LGOx+B0x5SGx1mfEknsVOEQ5g4hi4PmDWiqIPXK6ZNqVQyzjagR3oOYU
	WuJiM2PIL8zuQGK5hhcVVUein3s32uQqIBs4gGpEil1eMMFcV+1ndG1huvr+R64J3JnKCb
	UZ17YLUYplSHOWt4DHb+zeopXlKlVBU=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: netfilter-devel@vger.kernel.org
Cc: pablo@netfilter.org,
	fw@strlen.de,
	phil@nwl.cc,
	coreteam@netfilter.org
Subject: [PATCH nf v2 2/3] netfilter: nft_fib_ipv6: handle routes via external nexthop
Date: Wed, 20 May 2026 10:34:10 +0800
Message-ID: <20260520023411.391233-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260520023411.391233-1-jiayuan.chen@linux.dev>
References: <20260520023411.391233-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

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
2.43.0

