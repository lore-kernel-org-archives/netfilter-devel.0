Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3FD31326F
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Jun 2026 23:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.216.245.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780616219; cv=none; b=qrhom9I3VFxT1cl7OU1lh3kUUxkHtB7/6WIiScYPfoq493GOZNhIpc/thYAMpyjywlFrI9pjWHDuZ935JApR1lNuobvMLOYU2joz68UgNSXluT74LR2iwfzzosvgN1mMC4etT7j+ufXMzqGsvf4XCUs5/SIpYUALuEcMLgImuw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780616219; c=relaxed/simple;
	bh=ZtxXTJJhb0vluUrG6/+eUYkCzR/8D4p1g41FBC7D92A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o6e0lH0V4cIfBCryVruEzGPcgWsNs7FtmBeyPFR3L9X7sFLbD0gOAKceKabyDuawIexTqjrcqL54qgVPoT0aZD2ykGPOmUbvANkF3ur904b22tMtPD8PV9wk09mf0D8OmZfa3Hhf92JJjkNFtG9wNPlmQAVKJrIyXTohw8E5hMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de; spf=pass smtp.mailfrom=strlen.de; arc=none smtp.client-ip=91.216.245.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id D5CB46021A; Fri, 05 Jun 2026 01:36:48 +0200 (CEST)
Date: Fri, 5 Jun 2026 01:36:43 +0200
From: Florian Westphal <fw@strlen.de>
To: Ren Wei <n05ec@lzu.edu.cn>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, phil@nwl.cc,
	yuantan098@gmail.com, yifanwucs@gmail.com, tomapufckgml@gmail.com,
	bird@lzu.edu.cn, royenheart@gmail.com
Subject: Re: [PATCH nf v3 1/1] bridge: br_netfilter: pin bridge device while
 NFQUEUE holds fake dst
Message-ID: <aiIMC2RP7pB2mFDk@strlen.de>
References: <fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe4fc3d462679ba10bf85e574921ecf861000d66.1780590147.git.royenheart@gmail.com>

Ren Wei <n05ec@lzu.edu.cn> wrote:
> The bridge netfilter fake rtable is embedded in struct net_bridge and is
> attached to bridged packets with skb_dst_set_noref(). If such a packet is
> queued to NFQUEUE, __nf_queue() upgrades that fake dst with
> skb_dst_force().

Ok, I think I understand why this mess exists. Ideally we could rip out
the fake rtable and alloc it as separate object with distinct lifetime,
this FAKE_RTABLE crap needs to die...  But I understand its more
intrusive / harder to fix it that way (performance considerations don't
matter however, br_netfilter can be pessimized).

> +#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
> +static struct net_device *nf_queue_bridge_dev(const struct sk_buff *skb,
> +					      const struct nf_hook_state *state)
> +{
> +	struct dst_entry *dst = skb_dst(skb);
> +	struct net_device *dev;
> +
> +	if (state->pf != NFPROTO_BRIDGE || !nf_bridge_info_exists(skb))
> +		return NULL;
> +

I guess what you are saying is that if br_netfilter hack is on,
skb->dst can be fake rtable while packet is sent to nfnetlink_queue
from a *bridge* family hook where in/outdev are the physical ports
yet skb->dev isn't the bridge device either.  The forced ref on the
dst is useless in that case, because netdevice_removal frees the
net_device regardless of the fake rtable dst entries refcounts.

If thats correct, could you please streamline this patch slightly?

Something like this (totally untested and misses dev_put part); and
that comment might be a bit more verbose.

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -84,6 +84,8 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
        const struct sk_buff *skb = entry->skb;
+       struct dst_entry *dst = skb_dst(skb);
+       struct net_device *dev = NULL;
 
        if (nf_bridge_info_exists(skb)) {
                entry->physin = nf_bridge_get_physindev(skb, entry->state.net);
@@ -92,6 +94,17 @@ static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
                entry->physin = NULL;
                entry->physout = NULL;
        }
+
+       if (dst && (dst->flags & DST_FAKE_RTABLE)) {
+               dev = dst_dev_rcu(dst);
+               if (dev == blackhole_netdev) [ Q: Is that really needed? I don't think so ]
+                       dev = NULL;
+       }
+
+       /* Must hold reference on the bridge device: the fake rtable
+        * is embedded within, dst_hold() is not sufficient.
+        */
+       entry->br_dev = dev;
 #endif
 }
 
@@ -108,6 +121,7 @@ bool nf_queue_entry_get_refs(struct nf_queue_entry *entry)
        dev_hold(state->out);
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+       dev_hold(entry->br_dev);
        dev_hold(entry->physin);
        dev_hold(entry->physout);
 #endif

Thanks!
