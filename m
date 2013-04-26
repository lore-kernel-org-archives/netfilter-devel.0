From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 09:32:39 +0200
Message-ID: <20130426073239.GD32324@breakpoint.cc>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
 <20130426013601.GA4510@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:48427 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757683Ab3DZHck (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 03:32:40 -0400
Content-Disposition: inline
In-Reply-To: <20130426013601.GA4510@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 25, 2013 at 12:43:28PM +0200, Florian Westphal wrote:
> > This is a partial revert of a0c885ae5a79457aa592cb70c27a7dee619762a4
> > 
> > Specifically, it removes the header linux/netfilter/nfnetlink_queue.h
> > added in that commit.
> 
> The idea for caching that file header is to make sure
> libnetfilter_queue compiles out of the box, without external linux
> kernel headers installed in the system. The idea is to make sure the
> libraries compilation does not break in case there's an old library
> header installed in the system.
> 
> > 1), there is already a /usr/include/linux/netfilter/nfnetlink_queue.h,
> >     which is part of the linux kernel API
> 
> As said, that file may not be available or may be stale.

Yes, but at this time the system-wide header is used, and not this copy.
Compile of libnetfilter_queue breaks with the other patches applied
because the new attribute is missing from the system header.

> > 2), we already have
> >     include/libnetfilter_queue/linux_nfnetlink_queue.h
> 
> That was added initially for the old libnetfilter_queue API, I'd like
> to get rid of it. It's currently being installed and it results in
> (very likely) two duplicated headers in the system (the one from the
> linux kernel headers and this one from libnetfilter_queue).

Hrm, yes.  I thought that was intentional.
Or are you saying that you basically just want to rename
linux_nfnetlink_queue.h and carry a copy of nfnetlink_queue.h instead?

> Once the old API is deprecated (we should do that anytime soon), we
> can get finally rid of linux_nfnetlink_queue.h

I guess what confused me is that there is nothing related to the old
api in that header, so we might as well keep it?

> > which contains the same definitions/structures/macros, so it makes
> > little sense to have two headers in libnetfilter_queue that share
> > almost their entire content.
> > 
> > [ worse, the nfnetlink_queue.h header reverted here actually is
> > incompatible with mainline kernels, since a few defines have the
> > wrong value ... ]
> 
> Then, please refresh it.

Alright, but its not enough; the build system would require
additional treatment to give precedence to that header when compiling
the library.
