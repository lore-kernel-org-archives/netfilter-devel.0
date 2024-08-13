Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C71525624
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 18:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723572744; cv=none; b=WoVtiigdsc6u04XmSEn/QVIPkfdI2AAN5Ve+GPPi5QzPD14hL942ZtBv12X950slyRf207wtrRsTHoZHh8SsIJzqFuclMy9IIvI0u5T5EM/IYrttMXkJe968hxtKEbK3w0qHMPIqiNnlK0Hk6HdeLZi8h6zf4q/CYWg3jAgBL1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723572744; c=relaxed/simple;
	bh=gQdZyPd1lDj8vdHACLuDdZZkI8W024kAiP1y/VKxB50=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXcUVrntKid7CRJXtmJDwtycxVETKErFHnrQMSlEug8soBZG9j7qu5kT1EZkUP62TuQTVvWQXYV74kyYwRqBBZU7cORHA5+VwLXlerxYuDZzVtL2lG8qWo1dzzmd7m8Ru1iaLh2b+DmtHYY5jOo52N07SxMCsee2t35iJkcCJP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=f3sKJZ+5; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="f3sKJZ+5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vJhpb63JUZMd14X4gqMC1rTAnpzcG29UsIIEouaOX9s=; b=f3sKJZ+5628VjuuoUQZvOm4DD0
	xmXVCC8RKFR+I4C2c9XzlzfJAxdT/2IzyJU4z28wQXbudBeNEhjLjYSOrtTECjhWSGhIQTlGTXLcc
	lOZPh6WvZkkdn35XzM4xddUpG146CdhLjZcG4Da+p/gaZXz0AnoSXyeNqjy8H/iXWkq9JepbnSCvn
	NG/Cxw29TgM1oWSV10m0GF5eifK5cCG3ckwqlNK94cxpacSFbgi6UwKV3LBd6uIlpZKlvzL8P4u3R
	3+Dnjc5QbWy8HQSrtRP98VbT4u2PfuE6qmYyw+zcdvCXH5jo8BbefQ2QgC/CZccUoEiF80gey89JI
	fcUArnOA==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1sdw0I-000000004u0-3jnI;
	Tue, 13 Aug 2024 20:12:18 +0200
Date: Tue, 13 Aug 2024 20:12:18 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-8-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240807142357.90493-8-pablo@netfilter.org>

Hi Pablo,

On Wed, Aug 07, 2024 at 04:23:56PM +0200, Pablo Neira Ayuso wrote:
> This patch adds a timeout marker for those elements that never expire
> when the element are created, so timeout updates are possible.
> 
> Note that maximum supported timeout in milliseconds which is conveyed
> within a netlink attribute is 0x10c6f7a0b5ec which translates to
> 0xffffffffffe85300 jiffies64, higher milliseconds values result in an
> ERANGE error. Use U64_MAX as an internal marker to be stored in the set
> element timeout field for permanent elements.
> 
> If userspace provides no timeout for an element, then the default set
> timeout applies. However, if no default set timeout is specified and
> timeout flag is set on, then such new element gets the never expires
> marker.
> 
> Note that, in older kernels, it is already possible to define elements
> that never expire by declaring a set with the set timeout flag set on
> and no global set timeout, in this case, new element with no explicit
> timeout never expire do not allocate the timeout extension, hence, they
> never expire. This approach makes it complicated to accomodate element
> timeout update, because element extensions do not support reallocations.
> Therefore, allocate the timeout extension and use the new marker for
> this case, but do not expose it to userspace to retain backward
> compatibility in the set listing.

I fail to miss the point why this marker is needed at all:

Right now, new set elements receive EXT_TIMEOUT upon creation if either
NFTA_SET_ELEM_TIMEOUT is present (i.e., user specified per-element
timeout) or set->timeout is non-zero (i.e., set has a default timeout).

Why not change this logic and add EXT_TIMEOUT to all elements which will
timeout and initialize it either to the user-defined value or the set's
default? Then, only elements which don't timeout remain without
EXT_TIMEOUT. Which is not a problem, because their expiration value does
not need to be reset and thus they don't need space for one.

The only downside is that elements which stick to the set's default
timeout increase in size (for the copied set->timeout value), but this
patch series merges EXT_EXPIRATION and EXT_TIMEOUT anyway so their size
increases already. OTOH, non-expiring set elements won't need a spurious
EXT_TIMEOUT holding never expires marker.

Cheers, Phil
