From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/4] Revert: add new libnetfilter_queue API for libmnl
Date: Fri, 26 Apr 2013 03:36:01 +0200
Message-ID: <20130426013601.GA4510@localhost>
References: <1366886611-21666-1-git-send-email-fw@strlen.de>
 <1366886611-21666-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34558 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759315Ab3DZBgG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Apr 2013 21:36:06 -0400
Content-Disposition: inline
In-Reply-To: <1366886611-21666-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Thu, Apr 25, 2013 at 12:43:28PM +0200, Florian Westphal wrote:
> This is a partial revert of a0c885ae5a79457aa592cb70c27a7dee619762a4
> 
> Specifically, it removes the header linux/netfilter/nfnetlink_queue.h
> added in that commit.

The idea for caching that file header is to make sure
libnetfilter_queue compiles out of the box, without external linux
kernel headers installed in the system. The idea is to make sure the
libraries compilation does not break in case there's an old library
header installed in the system.

> 1), there is already a /usr/include/linux/netfilter/nfnetlink_queue.h,
>     which is part of the linux kernel API

As said, that file may not be available or may be stale.

> 2), we already have
>     include/libnetfilter_queue/linux_nfnetlink_queue.h

That was added initially for the old libnetfilter_queue API, I'd like
to get rid of it. It's currently being installed and it results in
(very likely) two duplicated headers in the system (the one from the
linux kernel headers and this one from libnetfilter_queue).

Once the old API is deprecated (we should do that anytime soon), we
can get finally rid of linux_nfnetlink_queue.h

> which contains the same definitions/structures/macros, so it makes
> little sense to have two headers in libnetfilter_queue that share
> almost their entire content.
> 
> [ worse, the nfnetlink_queue.h header reverted here actually is
> incompatible with mainline kernels, since a few defines have the
> wrong value ... ]

Then, please refresh it.
