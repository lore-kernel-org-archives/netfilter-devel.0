From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Mon, 3 Dec 2012 13:58:44 +0100
Message-ID: <20121203125843.GB30523@1984>
References: <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
 <20121130135806.GA7955@1984>
 <20121130140254.GB31969@breakpoint.cc>
 <20121130183450.GA27138@1984>
 <20121130213631.GE31969@breakpoint.cc>
 <20121203110417.GA22667@1984>
 <20121203111332.GB11627@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60246 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753142Ab2LCM6v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 07:58:51 -0500
Content-Disposition: inline
In-Reply-To: <20121203111332.GB11627@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 03, 2012 at 12:13:32PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > No matter what xchg tricks you do in the kernel: if 1<<31 was set
> > > after the dump completed, it will be un-set again via
> > > send_change_to_kernel(), i.e. we clear bit 1<<31, even though we didn't
> > > want to.  I don't see how this can be solved; kernel has no idea that
> > > userspace doesn't wish to alter 1<<31.
> > 
> > We can return -EAGAIN to userspace with cmpxchg. From kernel-space:
> > 
> > old = word;
> > word |= flags & mask; /* to set/unset a bunch of bits */
> > if (xchgcmp(&word, new, old) != old)
> >         return -EAGAIN;
> 
> Ah.  you're pulling a mask parameter out of your hat :-)

I did :-)

BTW, -EAGAIN already has a meaning for nfnetlink, so some other error
should be returned for the approach above.

Not sure if you checked the other approach I mentioned:

do {
        old = word;
        word |= flags & mask;
} while (xchgcmp(&word, new, old) != old);

So ctnetlink would keep trying until no interference happen.
