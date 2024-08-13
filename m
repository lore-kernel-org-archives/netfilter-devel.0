Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A501A7041
	for <netfilter-devel@vger.kernel.org>; Tue, 13 Aug 2024 20:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723581839; cv=none; b=HNw6M4F5UPn51mqEnYhS1ePxEzKB21YsDAKr9bG/Sa9RNysAGO1ImJQV6594IyTtur0cnlRBRtn0iVB2s7PwSeklRWn94yIbmp+X3sKQFXDwX8r08qpX+kibSnoQWVRd0dwhWfEsbbvvRyx+/56Mz/UjFTQG3QdsJPNtYT+pDhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723581839; c=relaxed/simple;
	bh=PfLpJe7SWeKgNlK1fOSpmcVTnX1RE94jWKTyjFCwEtU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rFBTmeGCsIP9VbCC1/+d6lQTJd0Fchs9LhNZB8pajeIvsYY3x5T6lk/6cozdR1RA0na3fw8XSwt4PBgVLC48rAoNvmDt/buBxECDR4Si20/HoQVQ0IK7ZBp69t6Z/mvHNk8jA9H0jzluwnzlwUZmGzg4wAocMSE+4lo3cddBiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=36826 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sdyMq-00EfPP-TS; Tue, 13 Aug 2024 22:43:47 +0200
Date: Tue, 13 Aug 2024 22:43:44 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <ZrvFgG8yHDjGv3-K@calendula>
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-8-pablo@netfilter.org>
 <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
X-Spam-Score: -1.9 (-)

On Tue, Aug 13, 2024 at 08:12:18PM +0200, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Aug 07, 2024 at 04:23:56PM +0200, Pablo Neira Ayuso wrote:
> > This patch adds a timeout marker for those elements that never expire
> > when the element are created, so timeout updates are possible.
> > 
> > Note that maximum supported timeout in milliseconds which is conveyed
> > within a netlink attribute is 0x10c6f7a0b5ec which translates to
> > 0xffffffffffe85300 jiffies64, higher milliseconds values result in an
> > ERANGE error. Use U64_MAX as an internal marker to be stored in the set
> > element timeout field for permanent elements.
> > 
> > If userspace provides no timeout for an element, then the default set
> > timeout applies. However, if no default set timeout is specified and
> > timeout flag is set on, then such new element gets the never expires
> > marker.
> > 
> > Note that, in older kernels, it is already possible to define elements
> > that never expire by declaring a set with the set timeout flag set on
> > and no global set timeout, in this case, new element with no explicit
> > timeout never expire do not allocate the timeout extension, hence, they
> > never expire. This approach makes it complicated to accomodate element
> > timeout update, because element extensions do not support reallocations.
> > Therefore, allocate the timeout extension and use the new marker for
> > this case, but do not expose it to userspace to retain backward
> > compatibility in the set listing.
> 
> I fail to miss the point why this marker is needed at all:

Long story short: I did my best to support this without this marker
but I could not find a design that works without it.

> Right now, new set elements receive EXT_TIMEOUT upon creation if either
> NFTA_SET_ELEM_TIMEOUT is present (i.e., user specified per-element
> timeout) or set->timeout is non-zero (i.e., set has a default timeout).

There is one exception though:

 table inet x {
        set y {
                typeof ip saddr
                flags timeout
        }
 }

in this case, there is no default set timeout. Older kernels already
allow to add elements with no EXT_TIMEOUT that never expire with this
approach, however, this is not practical for element updates, because
set element extension reallocation is not supported.

> Why not change this logic and add EXT_TIMEOUT to all elements which will
> timeout and initialize it either to the user-defined value or the set's
> default? Then, only elements which don't timeout remain without
> EXT_TIMEOUT. Which is not a problem, because their expiration value does
> not need to be reset and thus they don't need space for one.

No EXT_TIMEOUT means users cannot update the timeout policy for such
element. I assume users can update from "timeout never" to "timeout 1h"
as a valid usecase.

> The only downside is that elements which stick to the set's default
> timeout increase in size (for the copied set->timeout value), but this
> patch series merges EXT_EXPIRATION and EXT_TIMEOUT anyway so their size
> increases already. OTOH, non-expiring set elements won't need a spurious
> EXT_TIMEOUT holding never expires marker.
