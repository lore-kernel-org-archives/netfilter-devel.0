Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F943BB48
	for <netfilter-devel@vger.kernel.org>; Tue, 19 May 2026 14:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779200145; cv=none; b=G5rmEzJ4ZspxQpGH1C0GOAGRzNoiwi+t+C5+1z+5R5r/iMIUn8Tm5+0pammD81m5/JLoOnNelQv78TvsZSGeyjP5HMkinlx3buELWfzxxhAgwjLlOQu9qIdXQr4QkUYCCnaf3yrTqVWhWkgvCYdPBGoxVpfS/L97B3qf2DypP0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779200145; c=relaxed/simple;
	bh=RdV+XJLLeVMN/mxEYBZKFLvBwmfuCG1dzSOE+dP4Q7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bbTyZ25D68/aBY3DJ1MRMMGJilFgZ2oJ1HVbcMmZXbnjjcaTJyqeFjb8ubuf/NVoySSfRRoTI/+VJecRwZTkCi2B4aETfyOvRYL4zji05rvU8p5Svt/LIIWD4o2gWReoOLtTDKxTWJemyxwJo+BiAfsN02YHnPwtf0Nc319Z3Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=IcPiYkAw; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="IcPiYkAw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=r0mkP9PvouE2dAISbp1au3jKiynBYAXaNQK1LCVaFWY=; b=IcPiYkAwtBkFyGdXwjDN0IqLNt
	nSf9X8fh+xhEF95h6j4XIbEJylUJNbMPZim2HIqZBBOWs/W3vXG7xUY6rJ6xICfuQkTPrRetu8KKF
	JWnsMI9S4kthvZrTMQK9PcE6wrPaDt58oVdo+i4A2L4Gjg8Dz9m+kVRijn1eBXgRzl7v8N89AD8W/
	DBSjpEQ/W8/HFbeD83q0TB7GWOi8VcSN77a3Av5AQm2luZOzchcQnnpVTT5YoaZFf5ypQ89ZMkN4b
	BQSyWuuapD1hAI9A1y+t3b10iJ2pgXqPMJYJeJcXXOmlOZ9SFt1K8O0YT4kPq/iwElL4ilX/GKpRJ
	WbS0nwgA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wPLES-000000001l0-0z6J;
	Tue, 19 May 2026 16:15:40 +0200
Date: Tue, 19 May 2026 16:15:40 +0200
From: Phil Sutter <phil@nwl.cc>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org, fw@strlen.de,
	coreteam@netfilter.org
Subject: Re: [PATCH nf 1/2] netfilter: nft_fib_ipv6: handle routes via
 external nexthop
Message-ID: <agxwjNJ2PJg25kVF@orbyte.nwl.cc>
References: <20260519041431.396218-1-jiayuan.chen@linux.dev>
 <agw2kQHigTsMoJKt@orbyte.nwl.cc>
 <7da4fc46-0432-4f3d-b1bb-1691a2464df0@linux.dev>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7da4fc46-0432-4f3d-b1bb-1691a2464df0@linux.dev>

On Tue, May 19, 2026 at 06:50:55PM +0800, Jiayuan Chen wrote:
[...]
> On 5/19/26 6:08 PM, Phil Sutter wrote:
> > Hi,
> >
> > On Tue, May 19, 2026 at 12:14:30PM +0800, Jiayuan Chen wrote:
> >> fib6_info has a union:
> >>
> >>      union {
> >>          struct list_head fib6_siblings;
> >>          struct list_head nh_list;
> >>      };
> >>
> >> Old-style multipath (ip -6 route add ... nexthop ... nexthop ...) uses
> >> fib6_siblings.  External nexthop (ip -6 route add ... nhid N) uses
> >> nh_list, linked into &nh->f6i_list.
> >>
> >> nft_fib6_info_nh_uses_dev() blindly walks &rt->fib6_siblings, causing
> >> an OOB read past the struct nexthop slab when rt->nh is set:
> >>
> >>    ==================================================================
> >>    BUG: KASAN: slab-out-of-bounds in nft_fib6_eval+0x1362/0x16c0
> >>    Read of size 8 at addr ffff888103a099d0 by task ping/386
> >>
> >>    CPU: 2 UID: 0 PID: 386 Comm: ping Not tainted 7.1.0-rc3+ #251 PREEMPT
> >>    Call Trace:
> >>     <IRQ>
> >>     dump_stack_lvl+0x76/0xa0
> >>     print_report+0xd1/0x5f0
> >>     kasan_report+0xe7/0x130
> >>     __asan_report_load8_noabort+0x14/0x30
> >>     nft_fib6_eval+0x1362/0x16c0
> >>     nft_do_chain+0x279/0x18c0
> >>     nft_do_chain_ipv6+0x1a8/0x230
> >>     nf_hook_slow+0xad/0x200
> >>     ipv6_rcv+0x152/0x380
> >>     __netif_receive_skb_one_core+0x118/0x1c0
> >>    ==================================================================
> >>
> >> Branch by route shape: when rt->nh is set, walk via
> >> nexthop_for_each_fib6_nh() (also covers nh groups, which the original
> >> code missed); otherwise walk fib6_siblings, guarded by fib6_nsiblings.
> >>
> >> Fixes: 1c32b24c234b ("netfilter: nft_fib_ipv6: switch to fib6_lookup")
> >> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> >> ---
> >>   net/ipv6/netfilter/nft_fib_ipv6.c | 16 ++++++++++++++++
> >>   1 file changed, 16 insertions(+)
> >>
> >> diff --git a/net/ipv6/netfilter/nft_fib_ipv6.c b/net/ipv6/netfilter/nft_fib_ipv6.c
> >> index 8b2dba88ee96..a44919f46de9 100644
> >> --- a/net/ipv6/netfilter/nft_fib_ipv6.c
> >> +++ b/net/ipv6/netfilter/nft_fib_ipv6.c
> >> @@ -160,16 +160,32 @@ static bool nft_fib6_info_nh_dev_match(const struct net_device *nh_dev,
> >>   	       l3mdev_master_ifindex_rcu(nh_dev) == dev->ifindex;
> >>   }
> >>   
> >> +static int nft_fib6_nh_match_dev_cb(struct fib6_nh *nh, void *arg)
> >> +{
> >> +	const struct net_device *dev = arg;
> >> +
> >> +	return nft_fib6_info_nh_dev_match(nh->fib_nh_dev, dev) ? 1 : 0;
> > Why the ternary here? The function returns bool, but the iterator merely
> > checks the value for 0 and caller returns the value as bool as well.
> >
> >> +}
> >> +
> >>   static bool nft_fib6_info_nh_uses_dev(struct fib6_info *rt,
> >>   				      const struct net_device *dev)
> >>   {
> >>   	const struct net_device *nh_dev;
> >>   	struct fib6_info *iter;
> >>   
> >> +	/* External nexthop: fib6_siblings slot aliases nh_list, walk via nh. */
> >> +	if (rt->nh)
> >> +		return nexthop_for_each_fib6_nh(rt->nh,
> >> +						nft_fib6_nh_match_dev_cb,
> >> +						(void *)dev) != 0;
> 
> 
> All make sense !
> 
> 
> >> +
> >>   	nh_dev = fib6_info_nh_dev(rt);
> >>   	if (nft_fib6_info_nh_dev_match(nh_dev, dev))
> >>   		return true;
> >>   
> >> +	if (!rt->fib6_nsiblings)
> > Should this access using READ_ONCE() as per commit 31d7d67ba127 ("ipv6:
> > annotate data-races around rt->fib6_nsiblings")?
> 
> 
> You are right, we need READ_ONCE since fib6_add_rt2node will modify 
> @fib6_nsiblings .
> 
> 
> >> +		return false;
> >> +
> >>   	list_for_each_entry(iter, &rt->fib6_siblings, fib6_siblings) {
> 
> 
> Now I think we should also change list_for_each_entry  into 
> list_for_each_entry_rcu for the same reason.

Seems legit! I missed that one because most examples in net/ipv6/route.c
use a non-RCU variant, I guess because exclusive access is ensured via
other means.

> But I'm not sure whether it is appropriate or not since this patch 
> target to commit in Fiexes tag.
> 
> May be a followup patch is necessary.

I'd submit the _rcu fix in an initial patch of the series, so the one
introducing the fib6_nsiblings check extends correct code (using _rcu)
with a correct pattern (READ_ONCE).

Thanks, Phil
