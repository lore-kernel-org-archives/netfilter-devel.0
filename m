From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf,v2] netfilter: nf_queue: don't re-enter same hook on
 packet reinjection
Date: Tue, 18 Oct 2016 17:45:10 +0200
Message-ID: <20161018154510.GD29405@breakpoint.cc>
References: <1476441446-19611-1-git-send-email-pablo@netfilter.org>
 <f7tzim3j8yy.fsf@redhat.com>
 <20161017170320.GA5538@salvia>
 <f7th98aixk8.fsf@redhat.com>
 <20161018153456.GA2739@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Aaron Conole <aconole@bytheb.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:53352 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S935263AbcJRPqQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Oct 2016 11:46:16 -0400
Content-Disposition: inline
In-Reply-To: <20161018153456.GA2739@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Oct 17, 2016 at 03:29:27PM -0400, Aaron Conole wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> writes:
> [...]
> > > From c1a731c68791bcd504a7fe5d28f5f0fd59d66118 Mon Sep 17 00:00:00 2001
> > > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > > Date: Thu, 13 Oct 2016 08:14:03 +0200
> > > Subject: [PATCH nf,v3] netfilter: nf_queue: don't re-enter same hook on packet
> > >  reinjection
> > >
> > > If the packet is accepted, we have to skip the current hook from where
> > > the packet was enqueued. Thus, we can emulate the previous
> > > list_for_each_entry_continue() behaviour happening from nf_reinject(),
> > > otherwise the packets gets enqueued over and over again.
> > >
> > > Fixes: e3b37f11e6e4 ("netfilter: replace list_head with single linked list")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > >  net/netfilter/nf_queue.c | 6 ++++--
> > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
> > > index 96964a0070e1..0b5ac3c9c2bc 100644
> > > --- a/net/netfilter/nf_queue.c
> > > +++ b/net/netfilter/nf_queue.c
> > > @@ -187,8 +187,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
> > >  	entry->state.thresh = INT_MIN;
> > >  
> > >  	if (verdict == NF_ACCEPT) {
> > > -	next_hook:
> > > -		verdict = nf_iterate(skb, &entry->state, &hook_entry);
> > > +		hook_entry = rcu_dereference(hook_entry->next);
> > > +		if (hook_entry)
> > > +next_hook:
> > 
> > Should the above two lines be transposed to this?
> > 
> >  next_hook:
> >  		if (hook_entry)
> > 
> > Sorry if I'm misunderstanding it.  Too many special cases for my tiny
> > brain...
> 
> Right, my patch is still not correct.
> 
> I think this should be it:
> 
>         if (verdict == NF_ACCEPT) {
> next_hook:
>                 hook_entry = rcu_dereference(hook_entry->next);
>                 if (hook_entry)
>                         verdict = nf_iterate(skb, &entry->state, &hook_entry);
> 
> So we jump to "next_hook" in case of NF_QUEUE verdict with bypass flag
> set on.  In that case, we need to continue just after the current hook
> entry to emulate the behaviour that we previously have via
> list_for_each_entry_continue().
> 
> This NF_QUEUE handling is also broken from nf_hook_slow() path, right?

Yes.  As you already indicate, list_for_each_entry_continue() resumes
after the current elem, this isn't true anymore.

So for nf_queue we need to move to hook_entry->next in ACCEPT case,
and, for nf_hook_slow, we need to do the same when hitting

(verdict & NF_VERDICT_FLAG_QUEUE_BYPASS))
     goto next_hook;

branch.
