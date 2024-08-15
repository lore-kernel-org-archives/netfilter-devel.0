Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92547DA86
	for <netfilter-devel@vger.kernel.org>; Thu, 15 Aug 2024 11:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723720820; cv=none; b=fS1/IIX/jZjKgnF2WMVWCzxA4/FQrE/0OBjHuqsfx11uCfDSzCXS26fjTywyRWHwOSRDEADF09EDM66YyWMMPYamY8Ka8xOtBUfkKsrR3vVbRFjmCd1DUp7QmJCQtmi21ra2ILkg5HN2pcmj8QuZ06CcmioyN2g4fT/Ku3cEvus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723720820; c=relaxed/simple;
	bh=GDZeGyyqAo2ZXd8h6LJl/9e+KhSOyV4Wgi1PUtYzbSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V2otxABxNWicSeFeh9oCMCfQEhVgjcWk8T4jPNvGKwMNdJMNW4yKlnQ9I936nzgE6P2Iy+9IufgAWZqZdNcSA7ujj20amUb9w1ytCtCaZfN3XHU2IxSstpE3dkm8yzMQ5dhuyqCxcjaF8wLqkkce8DHezHVvyMymVDqwPFGFQGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=GB0BAhEv; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="GB0BAhEv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=EokNQBxFdARuab1+MxQro9ZqKMyxunwXnsba/jje06c=; b=GB0BAhEvhrnWwujrxS+npwbT6A
	tc+v1PfMEdYEq4cz+ztdKUQZXGH2o3OA4sQu1Rl9KBAqLFGTySeXrEak8BC1hTqkXaL9dWbKOSAKR
	0Eecer3NLS41jxsdy54I6SWGJq1BuJwRM9U7fM4+++xEt5BrcZPYS/T9dfVOKX2kSyHSPbDqd34ue
	Fo/ddNn3O97eDOnlhqbn9d6D1+F8w0hhyCRPnl+D3qLu5uFm8zDj++2pKJh0zPBTKmOVuQekXMarz
	pIgPuImXMMGWf0Zp+PYtJzasZj5OrRacrIZsToYQRREsUjMbPtLA6ot3jzGlCu73z3m0Ka8jVeM6o
	N0bpU52Q==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1seYWb-000000008Ry-2reZ;
	Thu, 15 Aug 2024 13:20:13 +0200
Date: Thu, 15 Aug 2024 13:20:13 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <Zr3kbZv4h1sBmVpb@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-8-pablo@netfilter.org>
 <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
 <ZrvFgG8yHDjGv3-K@calendula>
 <Zrxwb9O2z_kKPk1I@orbyte.nwl.cc>
 <Zr0XO5zNXtcPVZ4L@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zr0XO5zNXtcPVZ4L@calendula>

On Wed, Aug 14, 2024 at 10:44:43PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Aug 14, 2024 at 10:53:03AM +0200, Phil Sutter wrote:
> > On Tue, Aug 13, 2024 at 10:43:44PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Aug 13, 2024 at 08:12:18PM +0200, Phil Sutter wrote:
> > > > Hi Pablo,
> > > > 
> > > > On Wed, Aug 07, 2024 at 04:23:56PM +0200, Pablo Neira Ayuso wrote:
> > > > > This patch adds a timeout marker for those elements that never expire
> > > > > when the element are created, so timeout updates are possible.
> > > > > 
> > > > > Note that maximum supported timeout in milliseconds which is conveyed
> > > > > within a netlink attribute is 0x10c6f7a0b5ec which translates to
> > > > > 0xffffffffffe85300 jiffies64, higher milliseconds values result in an
> > > > > ERANGE error. Use U64_MAX as an internal marker to be stored in the set
> > > > > element timeout field for permanent elements.
> > > > > 
> > > > > If userspace provides no timeout for an element, then the default set
> > > > > timeout applies. However, if no default set timeout is specified and
> > > > > timeout flag is set on, then such new element gets the never expires
> > > > > marker.
> > > > > 
> > > > > Note that, in older kernels, it is already possible to define elements
> > > > > that never expire by declaring a set with the set timeout flag set on
> > > > > and no global set timeout, in this case, new element with no explicit
> > > > > timeout never expire do not allocate the timeout extension, hence, they
> > > > > never expire. This approach makes it complicated to accomodate element
> > > > > timeout update, because element extensions do not support reallocations.
> > > > > Therefore, allocate the timeout extension and use the new marker for
> > > > > this case, but do not expose it to userspace to retain backward
> > > > > compatibility in the set listing.
> > > > 
> > > > I fail to miss the point why this marker is needed at all:
> > > 
> > > Long story short: I did my best to support this without this marker
> > > but I could not find a design that works without it.
> > > 
> > > > Right now, new set elements receive EXT_TIMEOUT upon creation if either
> > > > NFTA_SET_ELEM_TIMEOUT is present (i.e., user specified per-element
> > > > timeout) or set->timeout is non-zero (i.e., set has a default timeout).
> > > 
> > > There is one exception though:
> > > 
> > >  table inet x {
> > >         set y {
> > >                 typeof ip saddr
> > >                 flags timeout
> > >         }
> > >  }
> > > 
> > > in this case, there is no default set timeout. Older kernels already
> > > allow to add elements with no EXT_TIMEOUT that never expire with this
> > > approach, however, this is not practical for element updates, because
> > > set element extension reallocation is not supported.
> > > 
> > > > Why not change this logic and add EXT_TIMEOUT to all elements which will
> > > > timeout and initialize it either to the user-defined value or the set's
> > > > default? Then, only elements which don't timeout remain without
> > > > EXT_TIMEOUT. Which is not a problem, because their expiration value does
> > > > not need to be reset and thus they don't need space for one.
> > > 
> > > No EXT_TIMEOUT means users cannot update the timeout policy for such
> > > element. I assume users can update from "timeout never" to "timeout 1h"
> > > as a valid usecase.
> > 
> > Ah, that's the missing piece: I somehow assumed this should only support
> > resetting elements' timeouts, i.e. update only those elements which will
> > timeout already.
> > 
> > AFAICT, using UINT64_MAX as never-timeout marker is sane but can't one
> > use 0 instead? Set elems expire if EXT_TIMEOUT is present and 'timeout
> > != 0'. This should simplify the code a bit, too because one may default
> > to set->timeout without checking the actual value.
> 
> UINT64_MAX marker always reports ERANGE in older kernels so user knows
> this is not supported, assuming new nft and old kernel, then in old
> kernels:
> 
> - if "flags timeout" is used, that means "never expires" in sets which
>   is correct.
> 
> - BUT if "timeout 1h" is used, then timeout 0 means use default set timeout
>   which is makes behaviour different in old and new kernels for this.

When adding an element to a set with default timeout, there are three
cases:

1) use set's default timeout
2) provide per-element timeout
3) add persistent element

I'd suggest to implement these like so:

1) Do not add NFTA_SET_ELEM_TIMEOUT attribute
2) Provide NFTA_SET_ELEM_TIMEOUT attribute with custom value
3) Provide NFTA_SET_ELEM_TIMEOUT attribute with zero value

This should work with current kernel code already, right?

Updating an element's timeout value does not work without kernel
changes, of course. In current kernel code, any changes to EXT_TIMEOUT
(including removal) are ignored. Using UINT64_MAX as value for (3) will
provoke failure, but that only covers for making an existent element
persistent. Changing timeout value is still ignored, right?

> I can explore using 0 as marker as you suggest if you think that
> informing the user that this is not supported is not so important.

Looking at tests/shell/features/*.sh, there are other features we may
detect only by inspecting the resulting ruleset as well. I guess proper
detection would use a separate command requesting kernel nftables
"capabilities" (probably flags which identify distinct functionality).

> Note, though, that timeout updates are completely ignored in new
> kernels, I don't have a way to report timeout updates are not
> implemented. Older kernels follow a lazy approach.

Ah, that summarizes my remarks above. :)
I didn't look at older kernels.

Cheers, Phil
