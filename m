Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A13236EA8D
	for <netfilter-devel@vger.kernel.org>; Wed, 26 Aug 2026 19:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787771220; cv=none; b=U1wAhNu+3NdO4Wwc/WQDvwMKLlocxXWaxjnPAtEbv5Z7Vz+AsA+y8KQab3HyQxsi5TIwl18PHagZvfNfuONpGdbW4Ty+Z3TpSY1JMVdF1n4JsBe0lUULluH7KQnCmC606TfOYrFXC27sqdROSy5x2hnC+0S5V6AW9YpJkc5fwRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787771220; c=relaxed/simple;
	bh=A5k7BWCOZgIQsoSZO3DMvAmXbgs10x4TTaDl4ZH1KEM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Eu7h+qRM9g4bfdlArY+MzDSZuRB28rR8L6BbpUIwXd7QxuvsUBArTM9AC40QZuLKnALp0dg3NGLbhh8vQEKl1UC33UT4PDXpyq/kw7qXh9fujIA9//xql9Soq/Hx7UUPPxQU1LJ24ODnGq4FaYz+SEsMCFowQ4MmTv2X6olLH+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=C+8uVBJo; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="C+8uVBJo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=xN7H7fpIIYC9JcxJWNeIETsFzH6jOGGvF4ccX5MTnZc=; b=C+8uVBJoOC5UX279kDNMNnIUgJ
	O6HmLwWVOPbVtZpWL5bFqzoiPbE2oI+FMoBttDL/t8pYMknCV/qGOfr5MSEBCsiLqRKwXaaoYoeZG
	giCl68oM0tZDdJ+zua4biByU+PlvJj7K3LH4tAB7bfGcA6wM6cewJWDJ/1QU2AdFB1e0wwwCjtHZC
	9shnXdOfS/Wsdt2WMrrgCSTlCu+a2m8PuVUgNEQvPcr//aeffdV0MBonwUBgZxSMgx5wrs8wMC5Zu
	wxdt+tFwexF2Z1QKQzuIY5E2vpztqI4q2NhBA2ocZDfOA6OMGaSpWLYLVPmH9oeqmxLjxTaTpcE3f
	mUNCKH4g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.98.2)
	(envelope-from <phil@nwl.cc>)
	id 1wzIxU-000000001oW-2Vis;
	Wed, 26 Aug 2026 21:06:48 +0200
Date: Wed, 26 Aug 2026 21:06:48 +0200
From: Phil Sutter <phil@nwl.cc>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	pablo@netfilter.org, fw@strlen.de, Wei Fang <void0red@gmail.com>
Subject: Re: [PATCH nf v3] netfilter: nf_tables: fix device name and prefix
 match in hook lookup
Message-ID: <ao85SJiRW5JlieJs@orbyte.nwl.cc>
References: <20260826133208.4550-1-fmancera@suse.de>
 <ao8SujdfOcqEJLUD@orbyte.nwl.cc>
 <ddea4e10-2aa9-4063-ab17-5c86d5ec7125@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ddea4e10-2aa9-4063-ab17-5c86d5ec7125@suse.de>

On Wed, Aug 26, 2026 at 06:47:57PM +0200, Fernando Fernandez Mancera wrote:
> On 8/26/26 6:22 PM, Phil Sutter wrote:
> > On Wed, Aug 26, 2026 at 03:32:08PM +0200, Fernando Fernandez Mancera wrote:
> >> Currently, a netdev chain or flowtable hooked to a device prefix can be
> >> unintentionally deleted by a control-plane request targeting an exact
> >> device name or even a shorter one due to the usage of min() to calculate
> >> the length to match.
> >>
> >> Fix this by making sure an exact device match never matches a prefix and
> >> that both the target and the candidate have the same length during
> >> delete operation. The add and update paths retain the existing overlap
> >> matching to prevent a single device from matching multiple hooks.
> >>
> >> Reported-by: Wei Fang <void0red@gmail.com>
> >> Closes: https://lore.kernel.org/netfilter-devel/CANE+tVrDeNCHQVmsqkV2ozeBqyE3GtRDMhZgsg1bhw10yGNTRQ@mail.gmail.com/
> >> Fixes: 6d07a289504a ("netfilter: nf_tables: Support wildcard netdev hook specs")
> >> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
> >> ---
> >>   net/netfilter/nf_tables_api.c | 24 ++++++++++++++----------
> >>   1 file changed, 14 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> >> index c112ecc4fca3..9ef12feec1ac 100644
> >> --- a/net/netfilter/nf_tables_api.c
> >> +++ b/net/netfilter/nf_tables_api.c
> >> @@ -1978,7 +1978,7 @@ static int nft_dump_stats(struct sk_buff *skb, struct nft_stats __percpu *stats)
> >>   	return -ENOSPC;
> >>   }
> >>   
> >> -static bool hook_is_prefix(struct nft_hook *hook)
> >> +static bool hook_is_prefix(const struct nft_hook *hook)
> > 
> > This is an unrelated change now.
> > 
> 
> Oops, yes sorry.
> 
> >>   {
> >>   	return strlen(hook->ifname) >= hook->ifnamelen;
> >>   }
> >> @@ -2440,11 +2440,14 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
> >>   }
> >>   
> >>   static struct nft_hook *nft_hook_list_find(struct list_head *hook_list,
> >> -					   const struct nft_hook *this)
> >> +					   const struct nft_hook *this,
> >> +					   bool strict)
> >>   {
> >>   	struct nft_hook *hook;
> >>   
> >>   	list_for_each_entry(hook, hook_list, list) {
> >> +		if (strict && hook->ifnamelen != this->ifnamelen)
> >> +			continue;
> >>   		if (!strncmp(hook->ifname, this->ifname,
> >>   			     min(hook->ifnamelen, this->ifnamelen))) {
> >>   			if (hook->flags & NFT_HOOK_REMOVE)
> >> @@ -2486,7 +2489,7 @@ static int nf_tables_parse_netdev_hooks(struct net *net,
> >>   			err = PTR_ERR(hook);
> >>   			goto err_hook;
> >>   		}
> >> -		if (nft_hook_list_find(hook_list, hook)) {
> >> +		if (nft_hook_list_find(hook_list, hook, false)) {
> >>   			NL_SET_BAD_ATTR(extack, tmp);
> >>   			nft_netdev_hook_free(hook);
> >>   			err = -EEXIST;
> >> @@ -2943,7 +2946,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
> >>   					ops->hook	= basechain->ops.hook;
> >>   				}
> >>   
> >> -				if (nft_hook_list_find(&basechain->hook_list, h)) {
> >> +				if (nft_hook_list_find(&basechain->hook_list, h, false)) {
> > 
> > I think this should be a strict match. It fixes a problem you didn't
> > intend to fix (I feel like an LLM-reviewer now), when updating a chain
> > with a partially matching wildcard:
> > 
> > | add table netdev t
> > | add chain netdev t c '{ type filter hook ingress priority 0; devices = { eth* }; }'
> > | add chain netdev t c '{ type filter hook ingress priority 0; devices = { et* }; }'
> > 
> > The last command should return EEXIST instead of being accepted and
> > treated as a NOP.
> 
> Hm. I am not so sure about it. Wouldn't that allow for overlapping 
> devices with prefixes?

You're right! I tested my concern with a flowtable, which behaves as I
expected (so the strict lookup suggested below works as it should). With
chains however, there is no duplicate hook check as for flowtables in
nft_register_flowtable_net_hooks.

I think the policy was to allow multiple netdev chains on the same
interface but not multiple flowtables. And IIRC, it wasn't clear whether
this restriction is really needed (e.g. for hw offloading) or kept "just
in case".

Either way, the duplicate hook check for flowtables just coincidentally
happens to do what we need, namely reject non-strict matching hooks in
the same flowtable/chain. This deserves a distinct lookup loop for both
flowtables and chains IMO.

I'll look into that tomorrow and once I have something I'll also submit
the test cases I wrote.

> Given this is not straightforward and we need to think a bit about it, 
> Pablo leave this out of the next PR to netdev. I am going to do a bit 
> more testing.

Sorry for putting obstacles in your way. :(

Cheers, Phil
