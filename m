From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Thu, 6 Aug 2015 12:20:43 +0200
Message-ID: <20150806102043.GA18683@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
 <20150804092905.GA7944@salvia>
 <20150804102635.GC6033@acer.localdomain>
 <20150804170447.GA3355@salvia>
 <20150805090915.GD13187@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58835 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbbHFKOk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Aug 2015 06:14:40 -0400
Content-Disposition: inline
In-Reply-To: <20150805090915.GD13187@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 05, 2015 at 11:09:16AM +0200, Patrick McHardy wrote:
> On 04.08, Pablo Neira Ayuso wrote:
[...]
> > Revisiting this scenario, this how this looks if we remove that check:
> > 
> > preparation starts:
> > 
> > add: table X (10), added to table list (now inactive)
> > del: table X (11), inactive next.
> >               ^
> >               gencursor
> > 
> > commit starts (update gencursor):
> > 
> > add: table X (01): clear past and report event, *NOTE*: the rule table is inactive.
> > add: table X (01): delete from list and report event.
> >                ^
> >                gencursor
> > 
> > So it seems it should be fine to remove it as it is defensive. I think
> > robots can generate this kind of command placing updates in a batch,
> > anyway that should come in a follow up patch IMO.
> 
> I don't follow. Why add an unnecessary check just to remove it again?
> As I said, the only thing that matters is the next generation, we should
> never even look at the current one when performing actions.

Yes, we can remove those checks to reject add+del in the same batch in
first place.

I remember I added this because I found some problematic scenario, but
given looking at the example above, I agree we can remove this first
place. I'm going to recheck for other objects too.

> > > > We shouldn't check if the object is active from the lookup function if
> > > > we're in the middle of a transaction, since we hold the lock there is
> > > > no way we can see inactive objects in the list. There's only one
> > > > transaction at the same time.
> > > 
> > > That's not entirely correct. Dump continuations happen asynchronously to
> > > netlink modifications and commit operations, so the genid may bump in the
> > > middle. We can get an inconsistent view if we have:
> > > 
> > > 			dump set elements from set x table y
> > > delete table y
> > > create table y
> > > create set x
> > > begin commit
> > > 			continue dump from new set
> > 
> > We catch this from the nfnlhdr->res_id field in the nfnetlink message,
> > but see below.
> > 
> > > commit, send NEWGEN
> > > 
> > > Sure, we will get a NEWGEN message, but at that time we might already have
> > > sent a full message for the new table/set since that message is only send
> > > after the commit is completed.
> > 
> > I agree in that an event message at the beginning of the commit phase
> > to announce the beginning new generation and another one to indicate
> > of this transaction.
> > 
> > - preparation phase -
> > delete table y
> > create table y
> > create set x
> > - commit phase -
> > send NEWGEN, attribute type: begin
> > delete table y
> > create table y
> > create set x
> > send NEWGEN, attribute type: end
> > 
> > Thanks for your feedback!
> 
> That might work if the message ordering is then guaranteed. However I think
> we can fix this case without changing NEWGEN. Let me think about that a bit,
> for now just taking care of the genid checks correctly seems like a good
> step forward.

But we can catch this problem through ->res_id, OK?

> BTW, we also need to adjust loop detection to only take into account
> active rules, active chains, active sets etc.

Indeed, thanks Patrick.

Will you take care of this? It would be great to have a fix for these
in this merge window. On top of that, I have a patchset here to add
named expressions as you suggested as a generic way to implement named
counters (or any other stateful expression) and I need that this is
fixed first so I don't need to add another ugly _INACTIVE flag to the
nft_nexpr object.

Let me know, thanks!
