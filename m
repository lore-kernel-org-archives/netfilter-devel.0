From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 3/3] netfilter: ctnetlink: allow userspace to set labels
Date: Fri, 30 Nov 2012 22:36:31 +0100
Message-ID: <20121130213631.GE31969@breakpoint.cc>
References: <1352994915-3859-4-git-send-email-fw@strlen.de>
 <20121127111838.GA28064@1984>
 <20121127115000.GA14156@breakpoint.cc>
 <20121127123149.GA2351@1984>
 <20121127130904.GB14156@breakpoint.cc>
 <20121127141317.GB9089@1984>
 <20121127142433.GE14156@breakpoint.cc>
 <20121130135806.GA7955@1984>
 <20121130140254.GB31969@breakpoint.cc>
 <20121130183450.GA27138@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35570 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751167Ab2K3Vgd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:36:33 -0500
Content-Disposition: inline
In-Reply-To: <20121130183450.GA27138@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 30, 2012 at 03:02:54PM +0100, Florian Westphal wrote:
[..]
> > Unfortunately, no -- the interface is too rudimentary.
> > Example: You want to set bis 0, 2, 6; but leave all other
> > bit that are set intact.
> > 
> > So you first need to make a dump to fetch the current labels set.
> > Then, you set bits 0, 2, 6 and send the new state to the kernel.
> > 
> > But between the dump and the set operation, a new bit might
> > have been set.  So even when using xchg it will be un-set again...
> 
> what about cmpxchg inside a loop? I think we can assume that the
> probability of interference while updating a word is low.

I'll try to give an example.

Userspace tool wants to set bit 0 on all labels, and remove all
others.  Except label 1<<31, which should be left alone.

With the proposed interface, you would do something like

dump_conntracks();

for_each_ct_object(..) {
	u32 word = get_ct_labels(ct);

	word &= 0x80000000; /* clear all but bit 31 */
	word |= 1;	    /* set bit 0 */
	send_change_to_kernel(ct); /* tell kernel */
}

No matter what xchg tricks you do in the kernel: if 1<<31 was set
after the dump completed, it will be un-set again via
send_change_to_kernel(), i.e. we clear bit 1<<31, even though we didn't
want to.  I don't see how this can be solved; kernel has no idea that
userspace doesn't wish to alter 1<<31.

We would have to add explicit support for setting/clearing single bits
to make this work, then userspace could say 'set bit 0'. 'clear bit 1',
etc.

HOWEVER, i've failed to come up with a plausible usage scenario where
such an interface would be useful/required. 8-}

So, I'd propose to leave things as they are, i.e. userspace commits
the entire connlabel bitvector. The ruleset would presumably
re-set required labels anyway on the next packet.

If someone can come up with a usage scenario where this
isn't sufficient, we could always add such a 'clear/set bit' command
later.

What do you think?

Cheers,
Florian
