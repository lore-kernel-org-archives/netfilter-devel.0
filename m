From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 11:37:08 +0200
Message-ID: <20130426093708.GA3757@localhost>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
 <20130426013601.GA4510@localhost>
 <20130426073239.GD32324@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50287 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab3DZJhN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Apr 2013 05:37:13 -0400
Content-Disposition: inline
In-Reply-To: <20130426073239.GD32324@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 26, 2013 at 09:32:39AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Apr 25, 2013 at 12:43:28PM +0200, Florian Westphal wrote:
> > > This is a partial revert of a0c885ae5a79457aa592cb70c27a7dee619762a4
> > > 
> > > Specifically, it removes the header linux/netfilter/nfnetlink_queue.h
> > > added in that commit.
> > 
> > The idea for caching that file header is to make sure
> > libnetfilter_queue compiles out of the box, without external linux
> > kernel headers installed in the system. The idea is to make sure the
> > libraries compilation does not break in case there's an old library
> > header installed in the system.
> > 
> > > 1), there is already a /usr/include/linux/netfilter/nfnetlink_queue.h,
> > >     which is part of the linux kernel API
> > 
> > As said, that file may not be available or may be stale.
> 
> Yes, but at this time the system-wide header is used, and not this copy.
> Compile of libnetfilter_queue breaks with the other patches applied
> because the new attribute is missing from the system header.

Hm, it's using the local cache copy here.

I tested it by adding some new (random) attribute definition
(NFQA_XYZ) to the locally cached header file, and using it from some
of the source files (e.g. nlmsg.c).

> > > 2), we already have
> > >     include/libnetfilter_queue/linux_nfnetlink_queue.h
> > 
> > That was added initially for the old libnetfilter_queue API, I'd like
> > to get rid of it. It's currently being installed and it results in
> > (very likely) two duplicated headers in the system (the one from the
> > linux kernel headers and this one from libnetfilter_queue).
> 
> Hrm, yes.  I thought that was intentional.
> Or are you saying that you basically just want to rename
> linux_nfnetlink_queue.h and carry a copy of nfnetlink_queue.h instead?

We cannot rename that header. Some people are including it into it
into their source code and that will break their compilation.

We can add some #warning in that file to say that people should use
cache some fresh kernel header in their source code tree, or simply
tell them to use the system kernel headers.

Regards.
