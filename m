From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Mon, 3 Dec 2012 12:13:32 +0100
Message-ID: <20121203111332.GB11627@breakpoint.cc>
References: <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
 <20121130135806.GA7955@1984>
 <20121130140254.GB31969@breakpoint.cc>
 <20121130183450.GA27138@1984>
 <20121130213631.GE31969@breakpoint.cc>
 <20121203110417.GA22667@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40160 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751291Ab2LCLNd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 06:13:33 -0500
Content-Disposition: inline
In-Reply-To: <20121203110417.GA22667@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > No matter what xchg tricks you do in the kernel: if 1<<31 was set
> > after the dump completed, it will be un-set again via
> > send_change_to_kernel(), i.e. we clear bit 1<<31, even though we didn't
> > want to.  I don't see how this can be solved; kernel has no idea that
> > userspace doesn't wish to alter 1<<31.
> 
> We can return -EAGAIN to userspace with cmpxchg. From kernel-space:
> 
> old = word;
> word |= flags & mask; /* to set/unset a bunch of bits */
> if (xchgcmp(&word, new, old) != old)
>         return -EAGAIN;

Ah.  you're pulling a mask parameter out of your hat :-)

> I'm assuming we're fine if kernel just set some bit and later on
> we explicitly unset it.

Right.

> Note that I'm also assuming that we pass flags and mask as attribute
> as we do for nf_conntrack_tcp.c (see netlink attributes).

Yes, there is no such thing at the moment.
Userspace just sends a CTA_LABEL attribute, which is a bit-vector
(u32 array).

I can add CTA_LABEL_MASK, of course, and change the memcpy accordingly.

In fact, I think I'll do so to see how much additional code it would be.

Thanks for your hint,
Florian
