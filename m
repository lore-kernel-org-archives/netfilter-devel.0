Received: from orbyte.nwl.cc (orbyte.nwl.cc [151.80.46.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C956136658
	for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2024 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=151.80.46.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723625589; cv=none; b=GXBcgSbp5omDefy7AInYdeUlLu8VsJfxMNU1Ulz/weINyOP7UqT+yVxMfbNOu30Rq5CpiBq+Jxp65QcfG3vu6EePQllxPUKxoAvySgyNibO18t/egk9B2U7VXveZizF0YF0GVEM+HzQIrYtAjOcMJCshRYefITrZbvzr19kIK+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723625589; c=relaxed/simple;
	bh=G1VoQR6bI0sb3K+7z6/eVWr336TrfaPcED0QLeu/lHM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pK9534krLGh18V1PZSJLNyMO4PpD9Rfm0bO4vUO8JHMTqcHQ8FhumQWH42w4QqZgi+cMEVjUZrIBHMY5061RYmj8gZpLynx9NHQnLC52x72P0Yj6Mce4v8p/maZ2JEipQCrMRjUW1WBKyJ84PxlG4GMXlpZYeGFMRufimtyHcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc; spf=pass smtp.mailfrom=nwl.cc; dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b=bk+T1idA; arc=none smtp.client-ip=151.80.46.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nwl.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nwl.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nwl.cc header.i=@nwl.cc header.b="bk+T1idA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
	s=mail2022; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IAhZDgaVXS4K/6MZvDjusg39yJinWABWgX052wqBEHQ=; b=bk+T1idAYh2V7/eJhxOn2XKu1S
	4DTGGhoN6th2gJsAbYIhWJYOelwRtLNfzefRI455bgEs/DhwYNhigoxrropMkiFzQO/Zgw0PCYJyZ
	fdIklVKV0wbI7Vu22+Q/nibrfdNLMkOjWXQtlZQ2Lt+pmwySpaphp7c4rZ6/UEFaRiFVNxE5wGQCK
	D4kidv0Qn0U0KLZq9VwOKNBJHLWrIyM99I+GcAcbXfxFXS2aIeVhFQcv4KwtNGL4H+syS8KEO8O6Z
	j0hmZmkh4rZYILxY/bmOKULQBFjVvFSKVwNJN94c3VRl2gI6X23ao0MhT1HTeSqshUZqc2+rOuird
	AC8zAmwg==;
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.97.1)
	(envelope-from <phil@nwl.cc>)
	id 1se9kd-000000006Ap-38os;
	Wed, 14 Aug 2024 10:53:03 +0200
Date: Wed, 14 Aug 2024 10:53:03 +0200
From: Phil Sutter <phil@nwl.cc>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 7/8] netfilter: nf_tables: add never expires
 marker to elements
Message-ID: <Zrxwb9O2z_kKPk1I@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
References: <20240807142357.90493-1-pablo@netfilter.org>
 <20240807142357.90493-8-pablo@netfilter.org>
 <ZruiAlR9UGRJTW8o@orbyte.nwl.cc>
 <ZrvFgG8yHDjGv3-K@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZrvFgG8yHDjGv3-K@calendula>

On Tue, Aug 13, 2024 at 10:43:44PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 13, 2024 at 08:12:18PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Wed, Aug 07, 2024 at 04:23:56PM +0200, Pablo Neira Ayuso wrote:
> > > This patch adds a timeout marker for those elements that never expire
> > > when the element are created, so timeout updates are possible.
> > > 
> > > Note that maximum supported timeout in milliseconds which is conveyed
> > > within a netlink attribute is 0x10c6f7a0b5ec which translates to
> > > 0xffffffffffe85300 jiffies64, higher milliseconds values result in an
> > > ERANGE error. Use U64_MAX as an internal marker to be stored in the set
> > > element timeout field for permanent elements.
> > > 
> > > If userspace provides no timeout for an element, then the default set
> > > timeout applies. However, if no default set timeout is specified and
> > > timeout flag is set on, then such new element gets the never expires
> > > marker.
> > > 
> > > Note that, in older kernels, it is already possible to define elements
> > > that never expire by declaring a set with the set timeout flag set on
> > > and no global set timeout, in this case, new element with no explicit
> > > timeout never expire do not allocate the timeout extension, hence, they
> > > never expire. This approach makes it complicated to accomodate element
> > > timeout update, because element extensions do not support reallocations.
> > > Therefore, allocate the timeout extension and use the new marker for
> > > this case, but do not expose it to userspace to retain backward
> > > compatibility in the set listing.
> > 
> > I fail to miss the point why this marker is needed at all:
> 
> Long story short: I did my best to support this without this marker
> but I could not find a design that works without it.
> 
> > Right now, new set elements receive EXT_TIMEOUT upon creation if either
> > NFTA_SET_ELEM_TIMEOUT is present (i.e., user specified per-element
> > timeout) or set->timeout is non-zero (i.e., set has a default timeout).
> 
> There is one exception though:
> 
>  table inet x {
>         set y {
>                 typeof ip saddr
>                 flags timeout
>         }
>  }
> 
> in this case, there is no default set timeout. Older kernels already
> allow to add elements with no EXT_TIMEOUT that never expire with this
> approach, however, this is not practical for element updates, because
> set element extension reallocation is not supported.
> 
> > Why not change this logic and add EXT_TIMEOUT to all elements which will
> > timeout and initialize it either to the user-defined value or the set's
> > default? Then, only elements which don't timeout remain without
> > EXT_TIMEOUT. Which is not a problem, because their expiration value does
> > not need to be reset and thus they don't need space for one.
> 
> No EXT_TIMEOUT means users cannot update the timeout policy for such
> element. I assume users can update from "timeout never" to "timeout 1h"
> as a valid usecase.

Ah, that's the missing piece: I somehow assumed this should only support
resetting elements' timeouts, i.e. update only those elements which will
timeout already.

AFAICT, using UINT64_MAX as never-timeout marker is sane but can't one
use 0 instead? Set elems expire if EXT_TIMEOUT is present and 'timeout
!= 0'. This should simplify the code a bit, too because one may default
to set->timeout without checking the actual value.

Thanks, Phil
