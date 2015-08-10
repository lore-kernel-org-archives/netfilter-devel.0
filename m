From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Mon, 10 Aug 2015 09:56:46 +0200
Message-ID: <20150810075646.GA20899@acer.localdomain>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
 <20150804092905.GA7944@salvia>
 <20150804102635.GC6033@acer.localdomain>
 <20150804170447.GA3355@salvia>
 <20150805090915.GD13187@acer.localdomain>
 <20150806102043.GA18683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44643 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbbHJH4u (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 03:56:50 -0400
Content-Disposition: inline
In-Reply-To: <20150806102043.GA18683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.08, Pablo Neira Ayuso wrote:
> On Wed, Aug 05, 2015 at 11:09:16AM +0200, Patrick McHardy wrote:
> > > > > We shouldn't check if the object is active from the lookup function if
> > > > > we're in the middle of a transaction, since we hold the lock there is
> > > > > no way we can see inactive objects in the list. There's only one
> > > > > transaction at the same time.
> > > > 
> > > > That's not entirely correct. Dump continuations happen asynchronously to
> > > > netlink modifications and commit operations, so the genid may bump in the
> > > > middle. We can get an inconsistent view if we have:
> > > > 
> > > > 			dump set elements from set x table y
> > > > delete table y
> > > > create table y
> > > > create set x
> > > > begin commit
> > > > 			continue dump from new set
> > > 
> > > We catch this from the nfnlhdr->res_id field in the nfnetlink message,
> > > but see below.
> > > 
> > > > commit, send NEWGEN
> > > > 
> > > > Sure, we will get a NEWGEN message, but at that time we might already have
> > > > sent a full message for the new table/set since that message is only send
> > > > after the commit is completed.
> > > 
> > > I agree in that an event message at the beginning of the commit phase
> > > to announce the beginning new generation and another one to indicate
> > > of this transaction.
> > > 
> > > - preparation phase -
> > > delete table y
> > > create table y
> > > create set x
> > > - commit phase -
> > > send NEWGEN, attribute type: begin
> > > delete table y
> > > create table y
> > > create set x
> > > send NEWGEN, attribute type: end
> > > 
> > > Thanks for your feedback!
> > 
> > That might work if the message ordering is then guaranteed. However I think
> > we can fix this case without changing NEWGEN. Let me think about that a bit,
> > for now just taking care of the genid checks correctly seems like a good
> > step forward.
> 
> But we can catch this problem through ->res_id, OK?

I guess we could with a unique res_id per object, but how would this work
with multiple object types? Any change bumps res_id, so we'd invalidate
the full dump for any change.
