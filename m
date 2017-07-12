From: Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH] monitor: fix printing of range elements in named sets
Date: Wed, 12 Jul 2017 14:13:43 +0200
Message-ID: <20170712121343.GT16375@orbyte.nwl.cc>
References: <149935174634.19966.16018870027671610502.stgit@nfdev2.cica.es>
 <20170711181104.GP16375@orbyte.nwl.cc>
 <CAOkSjBgWYqk1sd-Z2A8_DUUTK3pMW3b=W-8qiYAkQ5imc32TEA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47201 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750738AbdGLMNp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2017 08:13:45 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgWYqk1sd-Z2A8_DUUTK3pMW3b=W-8qiYAkQ5imc32TEA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, Jul 12, 2017 at 01:24:24PM +0200, Arturo Borrero Gonzalez wrote:
> On 11 July 2017 at 20:11, Phil Sutter <phil@nwl.cc> wrote:
> > Hi,
> >
> > On Thu, Jul 06, 2017 at 04:36:45PM +0200, Arturo Borrero Gonzalez wrote:
> >> If you add set elements to interval sets, the output is wrong.
> >> Fix this by caching first element of the range (first event),
> >> then wait for the second element of the range (second event) to
> >> print them both at the same time.
> >
> > As promised, I am preparing my own solution for side-by-side comparison.
> > Though I'm running into problems and want to use the occasion to discuss
> > them first:
> >
> > What I wasn't able to solve yet are half-open ranges, like so:
> >
> > | nft add set ip t portrange { type inet_service; flags interval; }
> > | nft add element ip t portrange { 1024-65535 }
> >
> > In this case there is only a single element with value 1024 which
> > doesn't have EXPR_F_INTERVAL_END set. Looking at
> > interval_map_decompose(), this is identified to be a range till the end
> > of the scope if it's the last element in the set.
> >
> > In monitor code though, I can't predict whether an interval end element
> > will come afterwards or not, so I end up caching the element and
> > everything turns into a mess. I'm pretty sure your solution has the same
> > problem, could you check that?
> >
> > Right now, I only see two ways to get this sorted:
> >
> > 1) Change kernel code to always include both start end end of a range in
> >    a single notification. This would eliminate the need for any caching
> >    in netlink_events_setelem_cb() altogether!
> >
> > 2) Change monitor code to cache all events until the final NFTA_GEN_ID
> >    message, then handle all messages at once.
> >
> > What do you think?
> >
> 
> We should avoid touching the kernel for this.

I found a userspace solution yesterday: I created a new callback for
NFT_MSG_NEWGEN, which will take care of the remaining cached element.
Patch follows later.

Thanks, Phil
