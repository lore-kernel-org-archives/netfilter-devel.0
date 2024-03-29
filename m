Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DBD13B2B2
	for <netfilter-devel@vger.kernel.org>; Fri, 29 Mar 2024 22:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.188.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711749723; cv=none; b=rcj/d+63Z1bnf5IibADfZ5+HOv6txz5icVf08yzcTUtBPnthuVe50E4Mxm1njPl5P97M5JqJ5oxUEc/a5BNHgTGajQ7aoOCOa0SbGmVTgzqCWsoEDfRGjtZvhxJhdz842HUSXfDVxTPK9/LoYTAUJb+pJK+TEt4MiEce1cUDvz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711749723; c=relaxed/simple;
	bh=bC0UELhpfg2KWeGw/h/+4PDsEupDpbCYHrvjA61QPzU=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=epLuJGuGx+z7BcHxvlJdbRhWMVvylEetFN302HskJexI8fThe+3i8BT33cI+MAd/tjVYKBmfK4lTD7O7h0XZSid+aqkQho56VCsMwTDhbIPcKFrDBHuVdNuRg6dxbNtdQBehcRK0BEvhi65qXx/sdMfUZxpZqorpg2nKvrgu5FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; arc=none smtp.client-ip=217.70.188.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Date: Fri, 29 Mar 2024 23:01:56 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: (re-send): Convert libnetfilter_queue to not need libnfnetlink]
Message-ID: <Zgc6U4dPcoBeiFJy@calendula>
References: <ZgXhoUdAqAHvXUj7@slk15.local.net>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZgXhoUdAqAHvXUj7@slk15.local.net>

Hi Duncan,

On Fri, Mar 29, 2024 at 08:31:13AM +1100, Duncan Roe wrote:
> Hi Pablo,
> 
> On Mon, Sep 11, 2023 at 09:51:07AM +0200, Pablo Neira Ayuso wrote:
> > On Mon, Sep 11, 2023 at 03:54:25PM +1000, Duncan Roe wrote:
> [SNIP]
> > > libnetfilter_queue effectively supports 2 ABIs, the older being based on
> > > libnfnetlink and the newer on libmnl.
> >
> > Yes, there are two APIs, same thing occurs in other existing
> > libnetfilter_* libraries, each of these APIs are based on libnfnetlink
> > and libmnl respectively.
> >
> [SNIP]
> >
> > libnfnetlink will go away sooner or later. We are steadily replacing
> > all client of this library for netfilter.org projects. Telling that
> > this is not deprecated without providing a compatible "old API" for
> > libmnl adds more confusion to this subject.
> >
> > If you want to explore providing a patch that makes the
> > libnfnetlink-based API work over libmnl, then go for it.
> 
> OK I went for it. But I posted the resultant patchset as a reply to an
> earlier email.
> 
> The Patchwork series is
> https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=399143
> ("Convert nfq_open() to use libmnl").
> 
> The series is "code only" - I kept back the documentation changes for
> spearate review. These documentation changes present the "old API" as
> merely an alternative to the mnl API: both use libmnl.

Thanks for explaining.

> Do you think you might find time to look at it before too long? I know you
> are very busy but I would appreciate some feedback.

This update is large it comes with its own risks and I see chances
that existing applications might break with this "transparent"
approach (where user is not aware that libnfnetlink is not used
anymore).

So far main complains with the new API is that it is too low level
(some users do not want to know about netlink details). The old API is
popular because it provides an easy way for users to receive packets
from the nfnetlink subsystem without dealing with netlink details.

My suggestion is to extend the new API with more functions to make it
ressemble more like the old API. Then, document how to migrate from
the old API to the new API, such documentation would be good to
include a list of items with things that have changed between old and
new APIs.

Would you consider feasible to follow up in this direction? If so,
probably you can make new API proposal that can be discussed.

I hope this does not feel discouraging to you, I think all this work
that you have done will be useful in this new approach and likely you
can recover ideas from this patchset.

Thanks for your patience.
