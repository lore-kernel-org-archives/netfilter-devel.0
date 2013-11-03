From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 3/3] acct: add input and output interface index
Date: Sun, 3 Nov 2013 21:59:15 +0100
Message-ID: <20131103205915.GA8264@localhost>
References: <20130926153150.280914229@eitzenberger.org>
 <20130926154005.592908761@eitzenberger.org>
 <20131017110630.GA11148@localhost>
 <20131017113345.GQ13405@imap.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org,
	Krzysztof Piotr Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39087 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3KCU7U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 15:59:20 -0500
Content-Disposition: inline
In-Reply-To: <20131017113345.GQ13405@imap.eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 17, 2013 at 01:33:45PM +0200, Holger Eitzenberger wrote:
> Hi Pablo,
> 
> > I like patches 1/3 and 2/3, they are nice cleanups.
> 
> thanks for looking into this.

I'm going to apply 1/3 and 2/3 with some small glitches, I would like
not to lose these cleanups.

> > If you only set indev/outdev once we can skip the conntrack extension
> > by passing the skb to nf_ct_deliver_cached_events and include this
> > information in the conntrack events. That would not allow to dump the
> > device from conntrack dumps though. I still have concerns with this
> > approach as this doesn't seem to cover the scenario in which the
> > in/outdev changes.
> 
> I know that doing it this simiple way is only "best effort", as e. g.
> with IP multipathing or 802.3ad this information is not % correct
> in all cases.
> 
> And the question we have to answer is whether this interface
> information *has* to be correct in every case, even the less commonly
> used cases.
> 
> For IPFIX I would answer this question with a 'no'.
> 
> And we can later extend this to update the interface information
> correctly in every case.  It's only a few patches away.

My suggestion is to rework patch 3/3 to pass the interface information
to nf_ct_deliver_cached_events via nf_ct_event struct, then include it
in the event message. Thus, we don't need to increase the size the
conntrack. The downside of this approach is that we cannot retrieve
the interface via dump operation, but I think it should be enough for
IPFIX. This feature should be disabled by default, so please add a
/proc switch to enable/disable it in runtime.

Thanks.
