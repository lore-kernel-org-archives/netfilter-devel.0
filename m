From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] netfilter: conntrack: remove timer from ecache
 extension
Date: Thu, 5 Jun 2014 16:56:40 +0200
Message-ID: <20140605145640.GC23367@breakpoint.cc>
References: <1400751788-7923-1-git-send-email-fw@strlen.de>
 <1400751788-7923-3-git-send-email-fw@strlen.de>
 <20140605142549.GA24216@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40525 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751757AbaFEO4l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:56:41 -0400
Content-Disposition: inline
In-Reply-To: <20140605142549.GA24216@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> First off, thanks a lot for looking into this. Some comments:
> 
> On Thu, May 22, 2014 at 11:43:08AM +0200, Florian Westphal wrote:
> > This brings the (per-conntrack) ecache extension back to 24 bytes in size
> > (was 152 byte on x86_64 with lockdep on).
> > 
> > When event delivery fails, re-delivery is attempted via work queue.
> > As long as the work queue has events to deliver, and at least one
> > delivery succeeded, it is rescheduled without delay,  if no
> > pending event was delivered after 0.1 seconds to avoid hogging cpu.
> > 
> > As the dying list also contains entries that do not need event
> > redelivery, a new status bit is added to identify these conntracks.
> > 
> > We cannot use !IPS_DYING_BIT, as entries whose event was already
> > sent can be recycled at any time due to SLAB_DESTROY_BY_RCU.
> 
> The IPS_DYING_BIT is set once the event is delivered, why isn't that
> enough to check when trying to retransmit the event. I mean, I'm
> questioning the need for the retransmission bit. I guess I'm missing
> some possible recycle scenario that I cannot see yet.

Yes, its recycling.
IPS_DYING_BIT unset would either mean:

a) 'This conntrack is dead and redelivery failed.  Resend event, then
destroy this conntrack'.
OR it can mean

b) 'This conntrack is being allocated/setup as new connection, the
flag field was already cleared'.

In the 2nd case, the conntrack_put would be fatal since the work queue
doesn't own the conntrack (plus the tuple is not dying after all...).

I've found no way to tell these two conditions apart except via new bit.

Alternative of course is to have extra redelivery list, that would
solve it as well.

If you have a 3rd alternative I'd be delighted to hear it :)

> > When userspace is heavily backlogged/overloaded, redelivery attempts
> > every 0.1 seconds are not enough.  To avoid this, the ecache work
> > is scheduled for immediate execution iff we have pending conntracks
> > and a conntrack expired successfully (i.e., userspace consumed the
> > event and is thus likely to accept more messages).
> > 
> > The nf_ct_release_dying_list() function is removed.
> > With this patch, ownership of the to-be-redelivered conntracks
> > (on-dying-list-with-REDELIVER-bit-set) is with the work queue,
> > which will release the references on its next wakeup.
> 
> I tried two different tests:
> 
> 2) Stress scenario. I have set a very small receive buffer size via
> NetlinkBufferSize and NetlinkBufferSizeMaxGrowth (I set it to 1024,
> which results in slightly more). The idea is that just very little
> events can be delivered at once and we don't leak events/entries.

Good thinking, i'll try this as well for my next testing round.

> In one test, I noticed around ~75 entries stuck in the dying list. In
> another test, I noticed conntrackd -i | wc -l showed one entry that
> got stuck in the cache, which was not in the dying list. I suspect
> some problem in the retransmission logic.

Thanks for testing this Pablo.

I'll look at the patches again, its also possible i introduced a new
bug when converting the previous version to the percpu lists.
