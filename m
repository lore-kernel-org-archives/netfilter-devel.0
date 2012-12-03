From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] netfilter: nf_conntrack: improve nf_conn object
 traceability
Date: Mon, 3 Dec 2012 15:33:21 +0100
Message-ID: <20121203143321.GA5599@1984>
References: <1354197082-8431-1-git-send-email-pablo@netfilter.org>
 <1354197082-8431-2-git-send-email-pablo@netfilter.org>
 <20121203110610.GA11627@breakpoint.cc>
 <20121203125036.GA30523@1984>
 <20121203132853.GA985@1984>
 <20121203141722.GC11627@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57472 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778Ab2LCOdd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 09:33:33 -0500
Content-Disposition: inline
In-Reply-To: <20121203141722.GC11627@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 03, 2012 at 03:17:22PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > i.o.w., conntrack objects that were in hash table are now always moved
> > > > to the dying list.  Shouldn't nf_ct_release_dying_list() be adjusted,
> > > > too?  It still seems to assume that the dying list only contains
> > > > alive conntack objects whose events have not been delivered yet.
> > > 
> > > I see, you mean that nf_ct_release_dying_list should delete objects
> > > from the dying list. Yes, I'll fix that. Thanks for the spot.
> > 
> > destroy_conntrack will delete the object from the dying list, so I
> > think the code is fine.
> > 
> > Am I missing anything?
> 
> Nope, you're right.
> 
> I was wondering what happens when nf_ct_release_dying_list()
> nf_ct_kill()s entries which are currently going through destroy_conntrack()
> on another cpu (i was concerned that we're putting an entry that
> already has 0-refcnt).  However, since nf_ct_kill calls del_timer,
> it should just return without doing anything for those conntracks.
> 
> I think nf_ct_release_dying_list can be removed:
> 1 For those entries that are about to go through destroy_conntrack()
>   nothing happens (since ct->timeout is no longer pending)
> 2. For those entries that are waiting for event-redelivery,
>   nothing happens either :-) [ for the same reason -- ct->timeout
>   is not pending anymore ].
> 
> Those objects that sit on the dying list because they wait for event
> re-delivery, will expire normally via ecache->timeout:
> 
> nf_conntrack_cleanup_net() will schedule() until all ecache->timeout
> timers have fired.  This shouldn't take too long, and no re-arming
> of the ecache timer will happen since no listeners exist at that point.
> 
> Does that sound right, or am I missing anything?

Sounds right to me. The removal path of the module should call
ct->timeout.function and remove the ecache timer. I think this is a
different issue, I'll send a follow-up patch to address this.
