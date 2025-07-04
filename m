Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DCF2D8771
	for <netfilter-devel@vger.kernel.org>; Fri,  4 Jul 2025 12:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751632873; cv=none; b=anjZm/J7cKyolwzR9A99Uv/iTfUHlwuJqpDB3RGIq7Bv1yYgjqKZF9Yh1wPTUp8UXd0lUn4es8T8MXBmcnROe4BT7aJImYTjgvW7D8nWCqA75O/wq0b5F4mgJO/qQYVm02nqez865HdTBWN2NLrf3UA6hA+l6faUS02whVurv4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751632873; c=relaxed/simple;
	bh=uK7P7juDd7LvJWxHImGhjOBiNEQ9BnjI6L7udtaC45Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aUtSjkFV3fJFqENxGh/phVNk6m0DSjkpjTRK9lEHn1sV/EZDV6CsjRmxJRlUTDdF45S1Zq/YkuBKqlC57HrfYPflHF9gMMYwms67Cs/o/KLn1SYdhRSyjz+rZDHuoKaf01eJyD8/wrm4+ogLzmdcPE1UHnToAvcADsrJN+HFb4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=b32+zC9G; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="b32+zC9G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uScZcVYpKC8nSswniTYilvGd6DFfR064Xg33zGcY2SA=; b=b32+zC9GPeMLiq6FP7vV3QcIRv
	jwQkkqgN9El8dYvFHl/QvAslZG/vyJOt47+YnNTBo727rLcfKJ1iYaLHlGkF2dD09t5716LY5jgjs
	uNM3G04Y/wV13rxBjztBuw0LgaRQaR5nHo+pzi+QG2e25+UIY9TaNxiOhM/gfKWmpDv8SSQry1KSO
	oniALQy65RzWB5C7JYppV4Kg8MNgZH0XaWdB0oq/S+Fp6o23MESBovoASSBziwQ7GW5qliJqPHVRs
	pGpQM4bTx5T8vOf7pnXdGL8IC/ti1NSBpijCoBCC0bvW4SItEpdPmPqjaJ/XRjsvM65dsQTA3+cWq
	c4aT/W3Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1uXfiw-000000001Fh-05gA;
	Fri, 04 Jul 2025 14:41:02 +0200
Date: Fri, 4 Jul 2025 14:41:01 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGfL3Q2huYeiOH1O@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
 <aGbu5ugsBY8Bu3Ad@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGbu5ugsBY8Bu3Ad@calendula>

Hi Pablo,

On Thu, Jul 03, 2025 at 11:32:26PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Jul 03, 2025 at 04:33:49PM +0200, Phil Sutter wrote:
> [...]
> > > > Pablo, WDYT? Feasible alternative to the feature flag?
> 
> That is more simple, it puts a bit more pressure on netlink_dump().
> Worst case fully duplicates the information, I think we discussed this
> already.
> 
> If my code reading is correct, maximum size of the area to add netlink
> messages in the dump path is SKB_WITH_OVERHEAD(32768) according to
> netlink_recvmsg(), there is a fallback to NLMSG_GOODSIZE when 3-order
> allocation fails.
> 
> In the event path, memory budget is already used up since
> NLMSG_GOODSIZE (4096) even before this proposal because
> 
> 256 devices * IFNAMSIZ = 4096
> 
> This is beyond the limit.
> 
> This can be fixed by splitting the report in two events of NEWCHAIN,
> but if there is another large attribute reaching the worst case, the
> splitting will get more complicated.
> 
> With your new attribute, worst case scenario means duplicating _DEVS
> with the same devices.
> 
> There is a memory budget for the netlink message, and the ADDCHAIN
> netlink message with the netdev family is already pushing it to the
> limit when *I rised* the maximum to 256 devices per request of a user.
> I can post a patch to reduce it to 128 devices now that your device
> wildcard feature is available.

While 128 should suffice for all practical cases (I hope), we could also
count hooks (empty ones twice) in _fill routines and omit the
HOOKLESS_DEVS attribute if the number exceeds 256.

> I regret _DEVS attribute only includes DEV_NAME, it should have been
> possible to add a flag and provide a more efficient representation
> than your proposal.

Yes, these kinds of short-cuts tend to kill the flexibility of the netlink
format. We could introduce _HOOK_DEVS_NEW but just like with _HOOK_DEV,
we can't get rid of _HOOK_DEVS in exchange.

> A possible fugly hack would be to stuffed this information after \0 in
> DEV_NAME, but that would feel like the iptables revision
> infrastructure, better not to go that way.

ACK.

> Maybe all this is not worth to worry and we can assume in 2025 that
> when 3-order allocation fails netlink dump will simply fail? Probably
> this already is right for other existing netlink subsystems.
> 
> And this effort is to provide a way for the user to know that the
> device that has been specified has actually registered a hook so the
> chain will see traffic.

Please keep in mind we already have 'nft list hooks' which provides
hints in that direction. It does not show which flowtable/chain actually
binds to a given device, though.

> So far we only have events via NEWDEV to report new hooks. Maybe
> GETDEV to consult the hooks that are attached to what chains is
> needed? That would solve this usability issue.
> 
> But that is _a lot more work_, stuffing more information into the
> ADDCHAIN netlink message is easier. GETDEV means more netlink boiler
> plate code to avoid this simple extra attribute you propose.
> 
> GETDEV would be paired with NEWDEV events to determine which device
> the base chain is hooked to.

Yes, it is definitely more work than the HOOKLESS_DEVS extra attribute,
but both user and kernel space would reuse code from NEWDEV event
support for the new request.

OTOH using it instead of HOOKLESS_DEVS means one more round-trip for
each flowtable and netdev chain being cached in user space.

> Maybe it is not for users to know that that dummy* is matching
> _something_ but also they want to know what device is matching such
> pattern for debugging purpose.

There is^Wwill be also 'nft monitor' helping with that.

> It boils down to "should we care to provide facility to allow for more
> instrospection in this box"?
> 
> If the answer is "no, what we have is sufficient" then let's not worry
> about mistypes. GETDEV facility would be rarely used, then skip.
> 
> If you want to complete this picture, then add GETDEV, because NEWDEV
> events without GETDEV command looks incomplete.

So you're suggesting to either implement GETDEV now or maybe later but
not the HOOKLESS_DEVS attribute for it being redundant wrt. GETDEV?

> > > If my understanding is correct, I think this approach will break new
> > > nft binary with old kernel.
> > 
> > If not present (old kernel), new nft would assume all device specs
> > matched an interface. I would implement this as comment, something like:
> > "# not bound: ethX, wlan*" which would be missing with old kernels.
> 
> If after all this, you decide to go for this approach with the new
> attribute into ADDCHAIN, maybe a more compact representation,
> add ? notation:
> 
> table ip x {
>         chain y {
>                 type filter hook ingress devices = { "eth*"?, "vlan0"?, "wan1" } priority 0;
>         }
> }
> 
> This notation can be removed if -s/--stateless is used and ignored if
> ruleset is loaded and it is more compact.
> 
> It feels like we are trying to stuff too much information in the
> existing output, and my ? notation is just trying to find a "smart"
> way to make thing not look bloated. Then, GETDEV comes again and this
> silly notation is really not needed if a more complete view is
> provided.

I prefer the comment format simply because it is easier on the parsers:
The one in nft is already quite convoluted, anyone trying to parse nft
output (yes, there's JSON for that but anyway) will likely expect
comments already.

On top of that, we don't break syntax for older binaries.

> BTW, note there is one inconsistency that need to be addressed in the
> listing, currently 'devices' does not enclose the names in quotes
> while 'device' does it.
> 
> I mean, with device:
> 
> table netdev x {
>         chain y {
>                 type filter hook ingress device "dummy0" priority filter; policy accept;
>         }
> }
> 
> with devices:
> 
> table netdev x {
>         chain y {
>                 type filter hook ingress devices = { dummy0, dummy1 } priority filter; policy accept;
>         }
> }
> 
> It would be great to fix this.

We could start by accepting quoted strings there. To not cause too much
fuss, quotes could be limited to wildcard interface names on output (at
least for now).

> P.S: This still leaves room to discuss if comments are the best way to
> go to display handle and set count, but we can start a new thread to
> discuss this.

My maxim would be to use comments for data which is output only, i.e.
useless on input.

Cheers, Phil
