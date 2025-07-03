Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19819239086
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 12:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751546274; cv=none; b=s450EsBDtFp3PNczrRX+JKMAJCq7GsZ7XluVKY8P68F0U3qW3/jqTJJJbjUijTRhF+SkgnYqI/wbeo8O9Zl0P6M4lfIPhkHsmbi42vYIBjCd+xep2Y3dp4219b5lxchD913uaXd3EPF/ISKwfegj7dcOa0idiSVt+L6/Gq8Bneo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751546274; c=relaxed/simple;
	bh=ki9vis1nIp2N1CpH69fzgp73PLenVaFW+BaQmjgEf0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JGR2MCEsQEc5vHEHYzc9u1O6/muk9Cq2Izl/s1ZCCVGNsYhYPuezN53fBzCmg2ZkH3MYKMy3/ZViziQpk5CMWB4J4Q+lIr/6cOFUxUQhTb0ozHR6kzA4apgu1x7RlGwJYdugjLSxGIbdRpKHZt3NEQekdm/fmwJxXEO1NZfLrqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=DdGs3A4Z; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="DdGs3A4Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1tQSV8SuLTMGeHFju4hAZlra3amjG8wc00WtB7WEhxI=; b=DdGs3A4ZjyF4PwNeejirjNg6T6
	8MNweSznIsLr0ap7kS9UrfTzNH6LqGGcUGoCH5UeNGGuNAcoDyez47WZDJUMBMcwSa1dkj1cIPwVy
	xfOBWR3bAwjwOOc2D64XaaCrzEB6PzdDzmmJwjyo5om9rcsRa6nSYY/eoDR4kUVEGRgI7uetkJpzd
	0K6lCMcz8m/JwJoNs7YAtYcuoFSWyCbIVz7u5bvGdqO3QbeCKRwrlkzkLmj0xtqRqtKJ3Un4tUXcK
	Z25atPRSQ2Wp5yFziww+t8mJTi3zlSfxGAohV76vUBUQUAFEnDOeyHG70118Ng7W3AZB3sZeEzsId
	9+RpObVA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXJCI-000000008F6-1Iqi;
	Thu, 03 Jul 2025 14:37:50 +0200
Date: Thu, 3 Jul 2025 14:37:50 +0200
From: Phil Sutter <phil@nwl.cc>
To: Florian Westphal <fw@strlen.de>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGZ5ni7lcPcz0T9K@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20250702174725.11371-1-phil@nwl.cc>
 <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZzAAnDT6a1rdh-@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGZzAAnDT6a1rdh-@strlen.de>

On Thu, Jul 03, 2025 at 02:09:36PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > Oh, right. So a decision whether this is feasible and if, how it should
> > > behave in detail, is urgent.
> > 
> > Downside is that this flag adds more complexity, since there will be
> > two paths to test (flag on/off).
> 
> Right.
> 
> > Another concern is having a lot of devices, this is now interating
> > linearly performing strcmp() to find matches from the control plane
> > (ie. maybe this slow down time to load ruleset?), IIRC you mentioned
> > this should not be an issue.
> 
> Can you suggest an alternative?
> 
> I see the following:
> 
> - revert to old behaviour (no search,
>   lookup-by-name), and introduce a new netlink attribute for the 'wildcard
>   name / full-search'.
>   Since thats a big change this requires a revert in nf.git and then a
>   followup change in nf-next to amend this.
> 
> - Only search if we have a wildcard.
>   It should be enough to check, from nft_netdev_hook_alloc, if hook->ifname
>   is null-terminated or not. If it is, lookup-by-name, else
>   for_each_netdev search.
> 
>   Thats assuming that the netlink attributes are encoded as
>   'eth\0' (4 bytes, no wildcard), vs 'eth' (3 bytes, wildcard).

Yes, that's how "wildcards" are implemented. (Hence why a simple
strncmp() is sufficient.)  When Pablo asked about it, I also realized I
could keep the lookup-by-name unless manual search was needed. I even
implemented it but surprisingly couldn't measure a difference. Quoting
myself from another mail here:

| > > Quick follow-up here: To test the above, I created many dummy NICs with
| > > same prefix and timed creation of a chain with matching wildcard hook
| > > spec. Failing to measure a significant delay, I increased the number of
| > > those NICs. Currently I have 10k matching and 10k non-matching NICs and
| > > still can't measure a slowdown creating that wildcard chain, even with
| > > 'nft monitor' running in another terminal which reports the added
| > > interfaces (that's code I haven't submitted yet).
| >
| > Are you sure you see no spike in perf record for nft_hook_alloc()?
| 
| I don't, flowtable creation is really fast (0.2s with 1k matching NICs),
| but deleting the same flowtable then takes about 60s. The perf report
| shows nf_flow_offload_xdp_setup() up high, I suspect the nested loops in
| nf_flowtable_by_dev_remove() to be the culprit.
| 
| Testing a netdev chain instead, both creation and deletion are almost
| instant (0.16s and 0.26s).

> > > Yes, that was the premise upon which I wrote the patch. I didn't intend
> > > to make the flag toggle between the old interface hooks and the new
> > > interface name hooks.
> > 
> > Mistyped name is another scenario this flag could help.
> 
> Regardless of this flag patch one could update nftables userspace to
> display hints like we do for sets with the new '# count 42' comment
> annotation.
> 
> Something that tells that the hook is subscribed for eth42 but currently
> not active.
> 
> Same with flowtables, something that tells which devices are configured
> (subscribed) and which devices are used (should likely still display
>  ppp* and not list 4000k ppp1234 :-) ).
> 
> Phil, whats your take here?

As suggested in my other reply, I could implement GETDEV request so
nftables may print either:

| flowtable f {
| 	hook ingress priority filter
| 	devices = { eth* (active: eth0, eth1), test1 (inactive) }
| }

or:

| flowtable f {
| 	hook ingress priority filter
| 	devices = { eth*, test1 } # active: eth0, eth1
| }

The NEWDEV/DELDEV notifications the kernel currently emits will be
printed by 'nft monitor'. This is still useful despite the above to
notify user space if a device is bound/unbound at run-time.

Cheers, Phil
