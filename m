Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18D2D4A3414
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 10:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779185700; cv=none; b=EkA3gmybd46QZFT4eXHlRpDQ4rOsuFZV1nGSDht5a6QJKrEU98SwcrHbcjOuWcYP7HV/W9r4mYGBjxgq2gt6pjn6d2TznzO8GX11VySl+Vj4QdhNJVJPtal2uRT2qETFEudlwrOJpwIKzRNVrMUfa7S+9/qgc6aXsbbwb7EEFC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779185700; c=relaxed/simple;
	bh=+Ulq5kotu4YjPQa+cSDp9INvJptf/8PpJUT534dOXMQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nDBasqIH4xIiZdD8/ylTSGs1hYCbgZLSY16KXqTRN9EX2kQrvdKjIuAPtjdqQXUzYeOydhO/ui3BWRP6CUCu952ov5AdXqdYxhYkh5zU+XfX0rNXNC6UB2aln7Fz61e75ku5yabBn8FnxSIWpVyozY6TagVSGmBkM3/3urIySdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=aWvumt3X; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="aWvumt3X"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QbeBcQxaGVT+gaUw55LHC+dBRXk8/G3rbnzGHqZONe0=; b=aWvumt3Xgbd03S5DuMAFlQM3fG
	iwcNS3/5fa0IkOWGLA2yrrih1HkPCNojSKfDwHEnoR9xYDRIIJ5A4GHhcBiKQ9ZjzVuRMhPcTdi2c
	gOusvNjjUT+6FseKQ5rBbt1PqGE+Jfjf7cQNOAv6JZ5oeXa5iGo6Z2ryiPk8icU8e54DYDlpiVtVI
	AkE0jlq76GdP8h2RFGliG+xu4+nDtcPEMwnh2lHZdf+MdhSvDMBmDQA+KrfRD+qmP7CuwaUvVMHby
	9GB1QBHhH3Q0lHCEGZuQelqDmP4iQj7AAXcUQjYhbJGygCm0SxVrZp1ESvJlIvFgeaPLZR0UDe15e
	3WwnFh0w==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wPHN4-000000005WH-00Al;
	Tue, 19 May 2026 12:08:18 +0200
Date: Tue, 19 May 2026 12:08:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
Message-ID: <agw2kQHigTsMoJKt@orbyte.nwl.cc>
References: <20260519041431.396218-1-jiayuan.chen@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260519041431.396218-1-jiayuan.chen@linux.dev>

Hi,

On Tue, May 19, 2026 at 12:14:30PM +0800, Jiayuan Chen wrote:
> fib6_info has a union:
> 
>     union {
>         struct list_head fib6_siblings;
>         struct list_head nh_list;
>     };
> 
> Old-style multipath (ip -6 route add ... nexthop ... nexthop ...) uses
> fib6_siblings.  External nexthop (ip -6 route add ... nhid N) uses
> nh_list, linked into &nh->f6i_list.
> 
> nft_fib6_info_nh_uses_dev() blindly walks &rt->fib6_siblings, causing
> an OOB read past the struct nexthop slab when rt->nh is set:
> 
>   ==================================================================
>   BUG: KASAN: slab-out-of-bounds in nft_fib6_eval+0x1362/0x16c0
>   Read of size 8 at addr ffff888103a099d0 by task ping/386
> 
>   CPU: 2 UID: 0 PID: 386 Comm: ping Not tainted 7.1.0-rc3+ #251 PREEMPT
>   Call Trace:
>    <IRQ>
>    dump_stack_lvl+0x76/0xa0
>    print_report+0xd1/0x5f0
>    kasan_report+0xe7/0x130
>    __asan_report_load8_noabort+0x14/0x30
>    nft_fib6_eval+0x1362/0x16c0
>    nft_do_chain+0x279/0x18c0
>    nft_do_chain_ipv6+0x1a8/0x230
>    nf_hook_slow+0xad/0x200
>    ipv6_rcv+0x152/0x380
>    __netif_receive_skb_one_core+0x118/0x1c0
>   ==================================================================
> 
> Branch by route shape: when rt->nh is set, walk via
> nexthop_for_each_fib6_nh() (also covers nh groups, which the original
> code missed); otherwise walk fib6_siblings, guarded by fib6_nsiblings.
> 
> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> ---
>  net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> index 8b2dba88ee96..a44919f46de9 100644
> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> @@ -160,16 +160,32 @@ static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
>  	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
>  }
>  
> +static int nft_fib6_nh_match_dev_cb(struct fib6_nh *nh, void *arg)
> +{
> +	const struct net_device *dev = arg;
> +
> +	return nft_fib6_info_nh_dev_match(nh->fib_nh_dev, dev) ? 1 : 0;

Why the ternary here? The function returns bool, but the iterator merely
checks the value for 0 and caller returns the value as bool as well.

> +}
> +
>  static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
>  				      const struct net_device *dev)
>  {
>  	const struct net_device *nh_dev;
>  	struct fib6_info *iter;
>  
> +	/* External nexthop: fib6_siblings slot aliases nh_list, walk via nh. */
> +	if (rt->nh)
> +		return nexthop_for_each_fib6_nh(rt->nh,
> +						nft_fib6_nh_match_dev_cb,
> +						(void *)dev) != 0;

As above, the '!= 0' is not needed, is it?

> +
>  	nh_dev = fib6_info_nh_dev(rt);
>  	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
>  		return true;
>  
> +	if (!rt->fib6_nsiblings)

Should this access using READ_ONCE() as per commit 31d7d67ba127 ("ipv6:
annotate data-races around rt->fib6_nsiblings")?

> +		return false;
> +
>  	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
>  		nh_dev = fib6_info_nh_dev(iter);

I thought about open-coding this to void the need for the callback
wrapper, but it's not worth it.

Cheers, Phil
