From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -next] netfilter: conntrack: remove timer from ecache
 extension
Date: Fri, 28 Mar 2014 11:32:03 +0100
Message-ID: <20140328103203.GA12225@localhost>
References: <1395943238-29319-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60790 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaC1KcR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 06:32:17 -0400
Content-Disposition: inline
In-Reply-To: <1395943238-29319-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 27, 2014 at 07:00:38PM +0100, Florian Westphal wrote:
> This brings the (per-conntrack) ecache extension back to 24 bytes in size
> (was 152 byte on x86_64 with lockdep on).
> 
> When event delivery fails, re-delivery is attempted via work queue.
> As long as the work queue has events to deliver, and at least one
> delivery succeeded, it is rescheduled without delay,  if no
> pending event was delivered after 0.1 seconds to avoid hogging cpu.
> 
> As the dying list also contains entries that do not need event
> redelivery, a new status bit is added to identify these conntracks.
> 
> We cannot use !IPS_DYING_BIT, as entries whose event was already
> sent can be recycled at any time due to SLAB_DESTROY_BY_RCU.
> 
> When userspace is heavily backlogged/overloaded, redelivery attempts
> every 0.1 seconds are not enough.  To avoid this, the ecache work
> is scheduled for immediate execution iff we have pending conntracks
> and a conntrack expired successfully (i.e., userspace consumed the
> event and is thus likely to accept more messages).
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  This is not replacement for 'u16 len' patch submitted recently because this
>  is not stable material.
> 
>  Adding new status bit is not nice, but only alternative is
>  adding new 'ecache redelivery' list, which would mean we alter current
>  lifecycle (unconfirmed list -> hash list -> dying list).
> 
>  Would also need to add ability to dump new list via ctnetlink.
> 
>  I'm mainly interested if you think timer removal is worthwile,
>  it works well in practice from usability POV.

Thanks for looking again into this. We definitely have to get rid of
that timer.

Regarding the new flag, perhaps we can avoid exposing this to
userspace? I mean, we can define some mask of internal flags that we
don't include via dump_status in ctnetlink.
