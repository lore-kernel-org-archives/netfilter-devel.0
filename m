Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B38232E49B8
	for <netfilter-devel@vger.kernel.org>; Wed, 23 Jul 2025 11:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753271361; cv=none; b=eg6Eh7+dXXFK8QcNOy6wdjA2qfhKuYnKQ8YqF+xNPp1q5JhL9IcaTPYpA8Kf5da0YJhRZiEwb/qEyOLsOFtnfGCmzsPmjuUIyTVyzVxs0+T86Ni6bTHeHMvU2UIDpSAoX9T+oixmUIJBcQNTti49O58uP0EBAplX9zCznubUwUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753271361; c=relaxed/simple;
	bh=OBXmaEWJj3IhPV47dWcVHMvaFd0Hds1TQZMQpwvaws0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I9waxlG/eBvB7AhZ+LBeUh3fRir+QHq4rqXyC6xyzVDwSP/2YXfj/QplYlcNuNqrRMUrqFX0PWMU7TbX0/bTXgf9NCIMbuJuzs5xyuG9nZg/RPiHmWd/82IU4GswJxYmRD5KrAN6FwcmW79EFFh8npzflxasAohGCQNNxK0RcvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=pp96duXf; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="pp96duXf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=bPwYeD3hgnICV/0YiJtNM6rl+mU133OI4OOvYKlcN5I=; b=pp96duXfUFgDW4UgG2+bY9tILx
	YYzV9Z2Cat6XtJHSYlyyqKmVnW8BGI47ypDCR0ld2ww8nN+M38YR5Q+FVhU1pC5jYHsBrAkuyAZuD
	zocs7Ne2pSutGs2N8d0oaGdBhI322RLUimuTElTKkFtgL/wdMmRSssP6ngLE1j7EOTrZoDwDbjy4+
	osF2i5kgS72RXj1YklaAhi+XJnN0AY0z725JXK0ObUMHrddlq1SbjjFziaJDM8+csPaV7it8QzuPJ
	qDq44Qz5Ja6jsTxhPrw+vJfMXPRkzP/akqbMnggmU+R+iF8pZywWEoBgvKzSyPczrj41Ud2r5NnLw
	fC7C0Sfw==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueXyH-000000006YS-0L7o;
	Wed, 23 Jul 2025 13:49:17 +0200
Date: Wed, 23 Jul 2025 13:49:17 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Message-ID: <aIDMPZjkdFLnZnDu@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250716132209.20372-1-phil@nwl.cc>
 <aH77oyMqwmO3x3V9@calendula>
 <aH-VlSW8TxjMNrHN@orbyte.nwl.cc>
 <aIAfwFczsAt-fhoU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIAfwFczsAt-fhoU@calendula>

On Wed, Jul 23, 2025 at 01:33:40AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Tue, Jul 22, 2025 at 03:43:49PM +0200, Phil Sutter wrote:
> > On Tue, Jul 22, 2025 at 04:46:59AM +0200, Pablo Neira Ayuso wrote:
> > > Hi Phil,
> > > 
> > > On Wed, Jul 16, 2025 at 03:22:06PM +0200, Phil Sutter wrote:
> > > > Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
> > > > NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
> > > > helpers converting to and from the human-readable asterisk-suffix
> > > > notation.
> > > 
> > > We spent some time discussing scenarios where host and container could
> > > use different userspace versions (older vs. newer).
> > > 
> > > In this case, newer version will send a string without the trailing
> > > null character to the kernel. Then, the older version will just
> > > _crash_ when parsing the netlink message from the kernel because it
> > > expects a string that is nul-terminated (and we cannot fix an old
> > > libnftnl library... it is not possible to fix the past, but it is
> > > better if you can just deal with it).
> > 
> > Yes, this sucks. In a quick test, my host's nft would display "foo" for
> > a device spec of "foo*", but I believe this largely depends upon string
> > lengths, alignment and function-local buffer initial contents.
> 
> I see.
> 
> > > I suggest you maybe pass the * at the end of the string to the kernel
> > > so nft_netdev_hook_alloc() can just handle this special case and we
> > > always have a nul-terminated string? There is ifnamelen which does in
> > > the kernel what you need to compare the strings, while ifname can
> > > still contain the *.
> > 
> > We can't distinguish this from real device names ending with asterisk,
> > though (Yes, no sane person would create those but since it's possible
> > there must be at least one doing it).
> 
> This is hard by looking only at the Value of the TLV.
> 
> > We could use a forbidden character to signal the wildcard instead.
> > Looking at dev_valid_name(), we may choose between '/', ':' and any of
> > the characters recognized by isspace(). I'd suggest to use something
> > fancy like '\v' (vertical tab) to lower the risk of hiding a user space
> > bug appending something the user may have inserted.
> 
> Let's look at this problem from a different side.
> 
> I'd suggest you add new netlink attribute NFTA_DEVICE_WILDCARD to
> address this, ie.
> 
> enum nft_devices_attributes {
>         NFTA_DEVICE_UNSPEC,
>         NFTA_DEVICE_NAME,
> +       NFTA_DEVICE_WILDCARD,
>         __NFTA_DEVICE_MAX
> };
> 
> And use this new attribute for wildcard interface matching.
> 
> > > Worth a fix? Not much time ahead, but we are still in -rc7.
> > 
> > Fine with me if we find a solution that works!
> 
> This approach allows for newer nftables version to fail with old
> kernels, ie. user requests to match on wildcard device and kernel does
> not support it. I think it is convenient to bail out if user requests
> an unsupported kernel feature.

Yes, this seems reasonable. Right now old kernels would search for the
prefix as full interface name which is sane but may lead to unexpected
results: E.g. on a system with eth1, eth10 and eth11, the kernel would
find a device matching "eth1*" and users had to check 'list hooks' to
see what really happened.

> As for matching on an interface whose name is really eth*, nftables
> userspace already allows for ifname eth\* to represent this, ie.
> 
>         iifname eth*   <-- wildcard matching (99% use-case)
>         iifname eth\*  <-- to match on exotic (still valid) device name (1% use-case)
> 
> See special for '\\' in expr_evaluate_string() for handling this
> special case.
> 
> It would be good if evaluate_device_expr() already provides an easy
> way for the mnl backend to distinguish between wildcard matching or
> exact device name matching.

Looks like I opened a new can by mentioning interfaces named "eth*", as
my proposed user space implementation doesn't support them it seems.

Changing my code to use a new attribute NFTA_DEVICE_WILDCARD should be
easy, but I'll look into proper evaluate integration.

Thanks, Phil
