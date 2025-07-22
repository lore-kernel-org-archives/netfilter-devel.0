Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE64815530C
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 23:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753227230; cv=none; b=a8nVzgai1shI7FE0jGVXUB5MUY1OxaDEMjaHeO4F/s8Kun8DmGUwIIy2010mwuJRXLjdm9/0FlVKqIaCGgxnAwwdkF5bAumZdYFJJCJrils1xWSXs9KjxHkmpGiFvUlqwkisQLVBkeZ+3Qq3YAb9Sp4NqF8IaTGCGtqjUCGCwIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753227230; c=relaxed/simple;
	bh=iZAtw+TJpcrs04z5v/cMUwAFVbeFYG4CgRq4bCNNDk8=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L3UCZ+mKjhb/tw25wpQyTJykcgyco0Th+XvAcepLZ79WUd+F0mDoupJWlHbdea21ieB27wI4B8cUhB1nE3ukKQI9LtEdIe4qdBAdt5IbU5TVMCaN+hR6EtjnhOovJ7KpOqdWGvRFy2kE2ARNXGRxCS7C8LPm3qyP9DZDqE5LJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=ptAREn9Z; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=giy/XCjL; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="ptAREn9Z";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="giy/XCjL"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id 938D86029B; Wed, 23 Jul 2025 01:33:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753227224;
	bh=exwCD1oe/N9EmDZ9AAUvrdORptHDew/sGCZaykynFxg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=ptAREn9ZmFdRLhjxp9dNb66cwPBOybHN5gckDv8KZmbBq1pYigXR4KL+cBqZ1FePl
	 AblKT3z9Kwr5mLqYUgf5lfz9pzSgJ4oYqXvAnpKMSzv208xQ5F2ZdFkH4Hc1pdcfvK
	 iZWd33bTiOtIRY68KHhFGvpi+0d9xwd4gVedMfjSfaiYD6d3CRcl8Oky4LWzDHZUjT
	 /f/GryF9PCkTQLX/+2m5pvUwMM1BE5rSmVjZ3nc/SG/k2bg7UMNcJYP+BXQGxfi9B/
	 eLMcIWILzI22Mr9d1WK83BQtdvJbxeQvIWOVTezVvdyGyZpEi3QJ5eAG+GpZn5gKDs
	 XEpTIk5Q5W4Kw==
X-Spam-Level: 
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id 6584F60296;
	Wed, 23 Jul 2025 01:33:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1753227223;
	bh=exwCD1oe/N9EmDZ9AAUvrdORptHDew/sGCZaykynFxg=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=giy/XCjLVJIsdfjY98qZ1Paa724fxLBz6VYaRIV48RxlVCWAdeX4PgAwhdTDYxhJ7
	 dutEFpOKDQ6TEwV2MXTWdz7FfA7xd+8KEvQrtHhBKxsFYe4u8UVFQdjF++ksjeAU6h
	 BY9lieKaaQDlECVfZpi4u1+OcaYEx4+P6iUsdGgVNg5QnPhcbD+gp1QQkWJDKk6XSe
	 JuY++3LEx9A9oSyLiJ5+daFRnCD2MjcqiLYBfzGXRXfcEr41QWiytgHKpyFNXGrU/r
	 0tEsmVs56Yzv3nVxhwVEMdrSj0l1gxTbSdGqLHuc3ea596IGyFUx3UotqFqqfqRxba
	 EBjuTLDDqsNig==
Date: Wed, 23 Jul 2025 01:33:40 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Message-ID: <aIAfwFczsAt-fhoU@calendula>
References: <20250716132209.20372-1-phil@nwl.cc>
 <aH77oyMqwmO3x3V9@calendula>
 <aH-VlSW8TxjMNrHN@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aH-VlSW8TxjMNrHN@orbyte.nwl.cc>

Hi Phil,

On Tue, Jul 22, 2025 at 03:43:49PM +0200, Phil Sutter wrote:
> On Tue, Jul 22, 2025 at 04:46:59AM +0200, Pablo Neira Ayuso wrote:
> > Hi Phil,
> > 
> > On Wed, Jul 16, 2025 at 03:22:06PM +0200, Phil Sutter wrote:
> > > Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
> > > NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
> > > helpers converting to and from the human-readable asterisk-suffix
> > > notation.
> > 
> > We spent some time discussing scenarios where host and container could
> > use different userspace versions (older vs. newer).
> > 
> > In this case, newer version will send a string without the trailing
> > null character to the kernel. Then, the older version will just
> > _crash_ when parsing the netlink message from the kernel because it
> > expects a string that is nul-terminated (and we cannot fix an old
> > libnftnl library... it is not possible to fix the past, but it is
> > better if you can just deal with it).
> 
> Yes, this sucks. In a quick test, my host's nft would display "foo" for
> a device spec of "foo*", but I believe this largely depends upon string
> lengths, alignment and function-local buffer initial contents.

I see.

> > I suggest you maybe pass the * at the end of the string to the kernel
> > so nft_netdev_hook_alloc() can just handle this special case and we
> > always have a nul-terminated string? There is ifnamelen which does in
> > the kernel what you need to compare the strings, while ifname can
> > still contain the *.
> 
> We can't distinguish this from real device names ending with asterisk,
> though (Yes, no sane person would create those but since it's possible
> there must be at least one doing it).

This is hard by looking only at the Value of the TLV.

> We could use a forbidden character to signal the wildcard instead.
> Looking at dev_valid_name(), we may choose between '/', ':' and any of
> the characters recognized by isspace(). I'd suggest to use something
> fancy like '\v' (vertical tab) to lower the risk of hiding a user space
> bug appending something the user may have inserted.

Let's look at this problem from a different side.

I'd suggest you add new netlink attribute NFTA_DEVICE_WILDCARD to
address this, ie.

enum nft_devices_attributes {
        NFTA_DEVICE_UNSPEC,
        NFTA_DEVICE_NAME,
+       NFTA_DEVICE_WILDCARD,
        __NFTA_DEVICE_MAX
};

And use this new attribute for wildcard interface matching.

> > Worth a fix? Not much time ahead, but we are still in -rc7.
> 
> Fine with me if we find a solution that works!

This approach allows for newer nftables version to fail with old
kernels, ie. user requests to match on wildcard device and kernel does
not support it. I think it is convenient to bail out if user requests
an unsupported kernel feature.

As for matching on an interface whose name is really eth*, nftables
userspace already allows for ifname eth\* to represent this, ie.

        iifname eth*   <-- wildcard matching (99% use-case)
        iifname eth\*  <-- to match on exotic (still valid) device name (1% use-case)

See special for '\\' in expr_evaluate_string() for handling this
special case.

It would be good if evaluate_device_expr() already provides an easy
way for the mnl backend to distinguish between wildcard matching or
exact device name matching.
