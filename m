Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038653A5E9D;
	Thu,  9 Apr 2026 11:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775733690; cv=none; b=tuFPe41xAI+TGV6sOk3PUoOxYALmT35vdrF2Jmi2P7+EW7YgdOu8Okhao/vvbmgFKOLvJ+UNVpAtb9FYtqIQM+J5rAJFj0zvQHYuMmjtBK71N/rBO+/VLi76rywOWdcK0I/4piBmhMXbIG9a3+EJ5jVq5dyuP1zXtjQ3Xc9FDXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775733690; c=relaxed/simple;
	bh=NGMroKs/p2DZlb2g6lLg1hb0RQfNUoYX7FW0BZLqLnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h0fGDBqAOPQVZKIr/4FkajRAiQ44ZmAtvpNmFcdqPr1QUH2a4NNcv+0JvM4D4pT9dOar/G30qhP+zDR3ZjEX3W/fxJE5IPQtF1ZMkJ/2Hq75p7+PoT/Cnzpq4qm14Ykg5LnjHK4PSvkWw4c9DCn5dnsNrWjV47gX9n4M/rQs4kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=DwVscG7o; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="DwVscG7o"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id C59196017D;
	Thu,  9 Apr 2026 13:21:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1775733686;
	bh=vO1SZlyg17Nlm20gzEKS1YEEuJac2pZ/3FgZ4TW4cX0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DwVscG7ooHrqu5iGPCAjWFEcRowFiYaKsi55UZx0weTQWXmNYu4HWR+xUJEG6Fwy5
	 lqKqIokc3VcxbtlglnFiKbGh1RKBrVBqfUyeWjgPadLEhDM6fVSuXYRruFxHmEXw6e
	 Z0wD6baQPRD/PND/81CoOdRCovsYlFkbrqSX2hGBExoroGuNmy1VQ5Aiv6iGBiHjDU
	 vSwuUkgfEgNFkLIr+VULpn/YbgJnfdz4Mp4lvyVkwuFXUpFRr7Zm2kSAkqyOeXTvYY
	 ou85BUybDQfR6Am52UdfoL0X6V6RBNo0+BLdJwwnLxm6Q8PQF3VF+IJpZCaYvzMb7P
	 HAXEVC654ukbQ==
Date: Thu, 9 Apr 2026 13:21:24 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Weiming Shi <bestswngs@gmail.com>
Cc: Florian Westphal <fw@strlen.de>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Phil Sutter <phil@nwl.cc>, Simon Horman <horms@kernel.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Xiang Mei <xmei5@asu.edu>
Subject: Re: [PATCH v2] netfilter: nft_fwd_netdev: use recursion counter in
 neigh egress path
Message-ID: <adeLtBMyR3KZInDW@chamomile>
References: <20260409104911.722698-2-bestswngs@gmail.com>
 <adeIF7ZsJsZsgwQy@chamomile>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <adeIF7ZsJsZsgwQy@chamomile>

On Thu, Apr 09, 2026 at 01:06:03PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 09, 2026 at 06:49:12PM +0800, Weiming Shi wrote:
> > nft_fwd_neigh can be used in egress chains (NF_NETDEV_EGRESS). When the
> > forwarding rule targets the same device or two devices forward to each
> > other, neigh_xmit() triggers dev_queue_xmit() which re-enters
> > nf_hook_egress(), causing infinite recursion and stack overflow.
> > 
> > Move the nf_get_nf_dup_skb_recursion() accessor and NF_RECURSION_LIMIT
> > to the shared header nf_dup_netdev.h as a static inline, so that
> > nft_fwd_netdev can use the recursion counter directly without exported
> > function call overhead. Guard neigh_xmit() with the same recursion
> > limit already used in nf_do_netdev_egress().
> > 
> > Fixes: f87b9464d152 ("netfilter: nft_fwd_netdev: Support egress hook")
> 
> I would just restrict this "feature", I don't see a point in allowing
> this from egress?

Hm, actually this can be combined with if0 device, fixing it makes sense.

> > Reported-by: Xiang Mei <xmei5@asu.edu>
> > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > ---
> >  include/net/netfilter/nf_dup_netdev.h | 13 +++++++++++++
> >  net/netfilter/nf_dup_netdev.c         | 16 ----------------
> >  net/netfilter/nft_fwd_netdev.c        |  7 +++++++
> >  3 files changed, 20 insertions(+), 16 deletions(-)
> > 
> > diff --git a/include/net/netfilter/nf_dup_netdev.h b/include/net/netfilter/nf_dup_netdev.h
> > index b175d271aec9..609bcf422a9b 100644
> > --- a/include/net/netfilter/nf_dup_netdev.h
> > +++ b/include/net/netfilter/nf_dup_netdev.h
> > @@ -3,10 +3,23 @@
> >  #define _NF_DUP_NETDEV_H_
> >  
> >  #include <net/netfilter/nf_tables.h>
> > +#include <linux/netdevice.h>
> > +#include <linux/sched.h>
> >  
> >  void nf_dup_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> >  void nf_fwd_netdev_egress(const struct nft_pktinfo *pkt, int oif);
> >  
> > +#define NF_RECURSION_LIMIT	2
> > +
> > +static inline u8 *nf_get_nf_dup_skb_recursion(void)
> > +{
> > +#ifndef CONFIG_PREEMPT_RT
> > +	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> > +#else
> > +	return &current->net_xmit.nf_dup_skb_recursion;
> > +#endif
> > +}
> > +
> >  struct nft_offload_ctx;
> >  struct nft_flow_rule;
> >  
> > diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
> > index fab8b9011098..a958a1b0c5be 100644
> > --- a/net/netfilter/nf_dup_netdev.c
> > +++ b/net/netfilter/nf_dup_netdev.c
> > @@ -13,22 +13,6 @@
> >  #include <net/netfilter/nf_tables_offload.h>
> >  #include <net/netfilter/nf_dup_netdev.h>
> >  
> > -#define NF_RECURSION_LIMIT	2
> > -
> > -#ifndef CONFIG_PREEMPT_RT
> > -static u8 *nf_get_nf_dup_skb_recursion(void)
> > -{
> > -	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
> > -}
> > -#else
> > -
> > -static u8 *nf_get_nf_dup_skb_recursion(void)
> > -{
> > -	return &current->net_xmit.nf_dup_skb_recursion;
> > -}
> > -
> > -#endif
> > -
> >  static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
> >  				enum nf_dev_hooks hook)
> >  {
> > diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
> > index 152a9fb4d23a..492bb599a499 100644
> > --- a/net/netfilter/nft_fwd_netdev.c
> > +++ b/net/netfilter/nft_fwd_netdev.c
> > @@ -141,13 +141,20 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
> >  		goto out;
> >  	}
> >  
> > +	if (*nf_get_nf_dup_skb_recursion() > NF_RECURSION_LIMIT) {
> > +		verdict = NF_DROP;
> > +		goto out;
> > +	}
> > +
> >  	dev = dev_get_by_index_rcu(nft_net(pkt), oif);
> >  	if (dev == NULL)
> >  		return;
> >  
> >  	skb->dev = dev;
> >  	skb_clear_tstamp(skb);
> > +	(*nf_get_nf_dup_skb_recursion())++;
> >  	neigh_xmit(neigh_table, dev, addr, skb);
> > +	(*nf_get_nf_dup_skb_recursion())--;
> >  out:
> >  	regs->verdict.code = verdict;
> >  }
> > -- 
> > 2.43.0
> > 
> > 
