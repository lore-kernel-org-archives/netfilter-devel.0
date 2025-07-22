Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBD128C2A6
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Jul 2025 13:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753191834; cv=none; b=tCVk4aoEZyiCJuKB3twoZ2bmwj40uwQXiqpTT0ETc5EfKY9lTqrJUDstHMTCDGldFksGClIMAt5pSDNezwdzRiLH+cUA99N2DBuYarr9H3Eyurek9StOQkJKzsiDV9IwFhnO5AQQ2zb6heO1Qnns6HMceWWuNkjJgK7I9aJ0IE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753191834; c=relaxed/simple;
	bh=Mgj7PhA0rDuWq7PercHi811EF4C3s6Pib3XYx/wq+Kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F0ikSRiMVGo2DLFBih4Qwc+3d6SyRC/c1pM8WXTijWhH5YF3zhbODlFUl+/9EODEEILz+HlD+J2LtIjYH08SgEMcWOJcy0aLt6QXb8/95SJypaDAzV+FFF5qfED2VPG9FcOLKSaQJWhDeAMSL2awWqVdioBzwM322ekfw27TIic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=hiQTlU+2; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="hiQTlU+2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5ClBC5/MFrbpYaPnqjD8MkYFVC7NekmfqdtkC2HYheA=; b=hiQTlU+2u9KJRpDjI8rN0oe5oC
	2mQLINIcjHPnVwzNhn5p2GhrCCVnbEEV9zw9l/TzMTFySbIasppmyKvNS5lg4rsyVpDNeTvR3bth2
	RrFyELe+ZUVU+B5hhd0WuIkXFH21kyWYr1gRdkCkCu5Xbiu0Wl5qS+zU/N5q7IQKr3s3WZMu59Qh4
	bMI8xtKYPRIoMGimuZquUK9j8EW7fjfjKb6JaAlCk2hJ3pQ0tA8oQtm58QTYxDptFH6uK12Idn/9N
	RUVx7ZTY7kMoJvHGxcea7ykVhCHjObdh0wHs+dfhLzBSzLejgDMGQC6KEB/qId49XE5nczDW4dIQ+
	PKqAOU/g==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1ueDHZ-000000003Lb-1r4Q;
	Tue, 22 Jul 2025 15:43:49 +0200
Date: Tue, 22 Jul 2025 15:43:49 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH] utils: Add helpers for interface name wildcards
Message-ID: <aH-VlSW8TxjMNrHN@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20250716132209.20372-1-phil@nwl.cc>
 <aH77oyMqwmO3x3V9@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aH77oyMqwmO3x3V9@calendula>

On Tue, Jul 22, 2025 at 04:46:59AM +0200, Pablo Neira Ayuso wrote:
> Hi Phil,
> 
> On Wed, Jul 16, 2025 at 03:22:06PM +0200, Phil Sutter wrote:
> > Support simple (suffix) wildcards in NFTNL_CHAIN_DEV(ICES) and
> > NFTA_FLOWTABLE_HOOK_DEVS identified by non-NUL-terminated strings. Add
> > helpers converting to and from the human-readable asterisk-suffix
> > notation.
> 
> We spent some time discussing scenarios where host and container could
> use different userspace versions (older vs. newer).
> 
> In this case, newer version will send a string without the trailing
> null character to the kernel. Then, the older version will just
> _crash_ when parsing the netlink message from the kernel because it
> expects a string that is nul-terminated (and we cannot fix an old
> libnftnl library... it is not possible to fix the past, but it is
> better if you can just deal with it).

Yes, this sucks. In a quick test, my host's nft would display "foo" for
a device spec of "foo*", but I believe this largely depends upon string
lengths, alignment and function-local buffer initial contents.

> I suggest you maybe pass the * at the end of the string to the kernel
> so nft_netdev_hook_alloc() can just handle this special case and we
> always have a nul-terminated string? There is ifnamelen which does in
> the kernel what you need to compare the strings, while ifname can
> still contain the *.

We can't distinguish this from real device names ending with asterisk,
though (Yes, no sane person would create those but since it's possible
there must be at least one doing it).

We could use a forbidden character to signal the wildcard instead.
Looking at dev_valid_name(), we may choose between '/', ':' and any of
the characters recognized by isspace(). I'd suggest to use something
fancy like '\v' (vertical tab) to lower the risk of hiding a user space
bug appending something the user may have inserted.

> Worth a fix? Not much time ahead, but we are still in -rc7.

Fine with me if we find a solution that works!

Cheers, Phil
