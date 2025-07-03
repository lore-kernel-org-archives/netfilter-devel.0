Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65EB221ADB5
	for <netfilter-devel@vger.kernel.org>; Thu,  3 Jul 2025 21:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751578356; cv=none; b=gVjjjyftP0RQgYy9bPgqU/l40w9ixYVSnu30zhmhx2155P/O5Ov7hUrU6z2G3fA6uWPYdNxklMYn4tvQhUOxPdIrd6f+YoraCLhaQ5HRQQG7/rOkH8DxFXkiGi2i96GtShX8CYr55Ovq/OFEl/P83GJDkUT8xm3UAUgMDTrl76I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751578356; c=relaxed/simple;
	bh=KNRwE3WDNcplEkGRTyNJfcmCtiudU/NI/zJIIesQO2w=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SbtqTpFMvpKbl2V4PPEK8yTrXjLjFFsS8fJsCtWdkyEZ/t2vCGULcvJMLb3HnahNKm7039B6SaduVB+HaEbsb367kEScP8Gw0iEIDzlDOQAdi+G/qg5EnXh1toUmCtfOlIueKRKsSQSBQkTUbRcFvKF21oQJpUDgPHfiw4JmDl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=u3S/K2Hk; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=hsac5Fyf; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="u3S/K2Hk";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="hsac5Fyf"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 19104602D6; Thu,  3 Jul 2025 23:32:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751578350;
	bh=VjDl/77hxBx4IYmBjAhov002DqWOe3rwgA3HCsaTGNI=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=u3S/K2HkqiUQdHmwTyGn0TXUtCEjVvQV2qBeB1dZrxLkF5cj3D99GC3v787/cMGmx
	 WoJce9OHLLQynap2f83NkjdeNlP+bB3zczPFPzIdI8+RjMX3qKE/3dmWq33wGvDEbP
	 LwozaNUKqI1a/mPKcX8i43vP8J0bCr7B0LG8y5e4oi0GFmaVFw+YO0dRJj8QdBWSPN
	 n0Bd6eZQlAAFnPmLGDnwR0uVjGq5/vefJNWwKjP5JUNEtpDe9d+KTm6OY77ZZuc1xO
	 W06D96h4PEXhpiG/KEMC23ZUx5OBRTAIg/I21CFkufQyQbJupBx+c/etoio3E5cNY2
	 t08++KukFL3Jw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id C354E602D2;
	Thu,  3 Jul 2025 23:32:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1751578348;
	bh=VjDl/77hxBx4IYmBjAhov002DqWOe3rwgA3HCsaTGNI=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=hsac5FyftE7WcIY1ybRAZVZgRGKwzrE3i8dFQy2ZtRIEW8hDt5CN4xY9puRcAr2RV
	 GArRLn7l3jJH15+DgnaSxrbwJ1uckA262QSZzd/8sd76Ld4FXGFnDB068KccAdwmRR
	 wntSaxm8IBK4uz4UN7JW6Jzzmz6A2ciPUXQNi3fk4huBFJPpptIPzQTspBekaTCSCo
	 L1a/X9hOqLVY3UgMu9ZvVWz/0GYAEvpXMw6GzXVW0K9uxPu6kDnUS8WbV+7mv4Txa6
	 /uAkwPIuJmAFOnZ0GJQxdiExIXURqIYsOsEW1kORnltpAKXKCc+N/3XM2euPPwivX1
	 UDijLsbL7RnXw==
Date: Thu, 3 Jul 2025 23:32:26 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [nf-next RFC] netfilter: nf_tables: Feature ifname-based hook
 registration
Message-ID: <aGbu5ugsBY8Bu3Ad@calendula>
References: <aGW1JNPtUBb_DDAB@strlen.de>
 <aGZZnbgZTXMwo_MS@orbyte.nwl.cc>
 <aGZrD0paQ6IUdnx2@calendula>
 <aGZ21NE61B4wdlq8@orbyte.nwl.cc>
 <aGZ6E0k0AyYMiMvp@strlen.de>
 <aGZ75G4SVuwkNDb9@orbyte.nwl.cc>
 <aGZ9jNVIiq9NrUdi@strlen.de>
 <aGaC0vHnoIEz8sTc@orbyte.nwl.cc>
 <aGaRaHoawJ-DbNUl@calendula>
 <aGaUzVUf_-xbowvO@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aGaUzVUf_-xbowvO@orbyte.nwl.cc>

On Thu, Jul 03, 2025 at 04:33:49PM +0200, Phil Sutter wrote:
[...]
> > > Pablo, WDYT? Feasible alternative to the feature flag?

That is more simple, it puts a bit more pressure on netlink_dump().
Worst case fully duplicates the information, I think we discussed this
already.

If my code reading is correct, maximum size of the area to add netlink
messages in the dump path is SKB_WITH_OVERHEAD(32768) according to
netlink_recvmsg(), there is a fallback to NLMSG_GOODSIZE when 3-order
allocation fails.

In the event path, memory budget is already used up since
NLMSG_GOODSIZE (4096) even before this proposal because

256 devices * IFNAMSIZ = 4096

This is beyond the limit.

This can be fixed by splitting the report in two events of NEWCHAIN,
but if there is another large attribute reaching the worst case, the
splitting will get more complicated.

With your new attribute, worst case scenario means duplicating _DEVS
with the same devices.

There is a memory budget for the netlink message, and the ADDCHAIN
netlink message with the netdev family is already pushing it to the
limit when *I rised* the maximum to 256 devices per request of a user.
I can post a patch to reduce it to 128 devices now that your device
wildcard feature is available.

I regret _DEVS attribute only includes DEV_NAME, it should have been
possible to add a flag and provide a more efficient representation
than your proposal.

A possible fugly hack would be to stuffed this information after \0 in
DEV_NAME, but that would feel like the iptables revision
infrastructure, better not to go that way.

Maybe all this is not worth to worry and we can assume in 2025 that
when 3-order allocation fails netlink dump will simply fail? Probably
this already is right for other existing netlink subsystems.

And this effort is to provide a way for the user to know that the
device that has been specified has actually registered a hook so the
chain will see traffic.

So far we only have events via NEWDEV to report new hooks. Maybe
GETDEV to consult the hooks that are attached to what chains is
needed? That would solve this usability issue.

But that is _a lot more work_, stuffing more information into the
ADDCHAIN netlink message is easier. GETDEV means more netlink boiler
plate code to avoid this simple extra attribute you propose.

GETDEV would be paired with NEWDEV events to determine which device
the base chain is hooked to.

Maybe it is not for users to know that that dummy* is matching
_something_ but also they want to know what device is matching such
pattern for debugging purpose.

It boils down to "should we care to provide facility to allow for more
instrospection in this box"?

If the answer is "no, what we have is sufficient" then let's not worry
about mistypes. GETDEV facility would be rarely used, then skip.

If you want to complete this picture, then add GETDEV, because NEWDEV
events without GETDEV command looks incomplete.

> > If my understanding is correct, I think this approach will break new
> > nft binary with old kernel.
> 
> If not present (old kernel), new nft would assume all device specs
> matched an interface. I would implement this as comment, something like:
> "# not bound: ethX, wlan*" which would be missing with old kernels.

If after all this, you decide to go for this approach with the new
attribute into ADDCHAIN, maybe a more compact representation,
add ? notation:

table ip x {
        chain y {
                type filter hook ingress devices = { "eth*"?, "vlan0"?, "wan1" } priority 0;
        }
}

This notation can be removed if -s/--stateless is used and ignored if
ruleset is loaded and it is more compact.

It feels like we are trying to stuff too much information in the
existing output, and my ? notation is just trying to find a "smart"
way to make thing not look bloated. Then, GETDEV comes again and this
silly notation is really not needed if a more complete view is
provided.

BTW, note there is one inconsistency that need to be addressed in the
listing, currently 'devices' does not enclose the names in quotes
while 'device' does it.

I mean, with device:

table netdev x {
        chain y {
                type filter hook ingress device "dummy0" priority filter; policy accept;
        }
}

with devices:

table netdev x {
        chain y {
                type filter hook ingress devices = { dummy0, dummy1 } priority filter; policy accept;
        }
}

It would be great to fix this.

P.S: This still leaves room to discuss if comments are the best way to
go to display handle and set count, but we can start a new thread to
discuss this.
