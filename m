Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D896F1C8FA6
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723668307; cv=none; b=btJV+q95Xn1NeXw4y6G+6ZqxykmMsxw5FbKfVcsxagDY6m5mutM3Y7ZJVGsLvIDvDAnimhgrB9CK2/gI/5JLXmWFlJsLwhTyq45WMC8WzJrYZ3/vdKv5lZl2DyQ3nvrJJi1rtqJNbkGUAROst7Dvyr1PPfOs9icbCC3pKuwF/FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723668307; c=relaxed/simple;
	bh=vWW1z5zQNtVkSvV8N3zJtS56AjQL2vO5zGLPkldtt0U=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KMHLI0nSuaTvp5tlFOWmYeNY3FFIC4wSkt/AJ3YGjz4qzMmQ06biLyWP/5MsdqI3x+c9V5Y6IV26VhHDmrYKcaczTcj/XpiPpKGq9F6uDBqGbZXLbK8Xka1uzpZSvq7FfO78p2026/zzTwvd9Hm85IkztN1gHgnXwU7xcPJwQw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=47534 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1seKrM-00G7ql-Iz; Wed, 14 Aug 2024 22:44:46 +0200
Date: Wed, 14 Aug 2024 22:44:43 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <Zr0XO5zNXtcPVZ4L@calendula>
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-8-pablo@netfilter.org>
 <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
 <ZrvFgG8yHDjGv3-K@calendula>
 <Zrxwb9O2z_kKPk1I@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zrxwb9O2z_kKPk1I@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Wed, Aug 14, 2024 at 10:53:03AM +0200, Phil Sutter wrote:
> On Tue, Aug 13, 2024 at 10:43:44PM +0200, Pablo Neira Ayuso wrote:
> > On Tue, Aug 13, 2024 at 08:12:18PM +0200, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Wed, Aug 07, 2024 at 04:23:56PM +0200, Pablo Neira Ayuso wrote:
> > > > This patch adds a timeout marker for those elements that never expire
> > > > when the element are created, so timeout updates are possible.
> > > > 
> > > > Note that maximum supported timeout in milliseconds which is conveyed
> > > > within a netlink attribute is 0x10c6f7a0b5ec which translates to
> > > > 0xffffffffffe85300 jiffies64, higher milliseconds values result in an
> > > > ERANGE error. Use U64_MAX as an internal marker to be stored in the set
> > > > element timeout field for permanent elements.
> > > > 
> > > > If userspace provides no timeout for an element, then the default set
> > > > timeout applies. However, if no default set timeout is specified and
> > > > timeout flag is set on, then such new element gets the never expires
> > > > marker.
> > > > 
> > > > Note that, in older kernels, it is already possible to define elements
> > > > that never expire by declaring a set with the set timeout flag set on
> > > > and no global set timeout, in this case, new element with no explicit
> > > > timeout never expire do not allocate the timeout extension, hence, they
> > > > never expire. This approach makes it complicated to accomodate element
> > > > timeout update, because element extensions do not support reallocations.
> > > > Therefore, allocate the timeout extension and use the new marker for
> > > > this case, but do not expose it to userspace to retain backward
> > > > compatibility in the set listing.
> > > 
> > > I fail to miss the point why this marker is needed at all:
> > 
> > Long story short: I did my best to support this without this marker
> > but I could not find a design that works without it.
> > 
> > > Right now, new set elements receive EXT_TIMEOUT upon creation if either
> > > NFTA_SET_ELEM_TIMEOUT is present (i.e., user specified per-element
> > > timeout) or set->timeout is non-zero (i.e., set has a default timeout).
> > 
> > There is one exception though:
> > 
> >  table inet x {
> >         set y {
> >                 typeof ip saddr
> >                 flags timeout
> >         }
> >  }
> > 
> > in this case, there is no default set timeout. Older kernels already
> > allow to add elements with no EXT_TIMEOUT that never expire with this
> > approach, however, this is not practical for element updates, because
> > set element extension reallocation is not supported.
> > 
> > > Why not change this logic and add EXT_TIMEOUT to all elements which will
> > > timeout and initialize it either to the user-defined value or the set's
> > > default? Then, only elements which don't timeout remain without
> > > EXT_TIMEOUT. Which is not a problem, because their expiration value does
> > > not need to be reset and thus they don't need space for one.
> > 
> > No EXT_TIMEOUT means users cannot update the timeout policy for such
> > element. I assume users can update from "timeout never" to "timeout 1h"
> > as a valid usecase.
> 
> Ah, that's the missing piece: I somehow assumed this should only support
> resetting elements' timeouts, i.e. update only those elements which will
> timeout already.
> 
> AFAICT, using UINT64_MAX as never-timeout marker is sane but can't one
> use 0 instead? Set elems expire if EXT_TIMEOUT is present and 'timeout
> != 0'. This should simplify the code a bit, too because one may default
> to set->timeout without checking the actual value.

UINT64_MAX marker always reports ERANGE in older kernels so user knows
this is not supported, assuming new nft and old kernel, then in old
kernels:

- if "flags timeout" is used, that means "never expires" in sets which
  is correct.

- BUT if "timeout 1h" is used, then timeout 0 means use default set timeout
  which is makes behaviour different in old and new kernels for this.

I can explore using 0 as marker as you suggest if you think that
informing the user that this is not supported is not so important.

Note, though, that timeout updates are completely ignored in new
kernels, I don't have a way to report timeout updates are not
implemented. Older kernels follow a lazy approach.
