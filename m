From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: nftables transaction semantics
Date: Mon, 2 Mar 2015 13:39:32 +0100
Message-ID: <20150302123932.GA17356@salvia>
References: <20150302115141.GC6142@acer.localdomain>
 <20150302120835.GA16802@salvia>
 <20150302120805.GG6142@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48635 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbbCBMgA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2015 07:36:00 -0500
Content-Disposition: inline
In-Reply-To: <20150302120805.GG6142@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 02, 2015 at 12:08:05PM +0000, Patrick McHardy wrote:
> On 02.03, Pablo Neira Ayuso wrote:
> > On Mon, Mar 02, 2015 at 11:51:41AM +0000, Patrick McHardy wrote:
> > > I'm looking at the nftables transaction code and wondering about the
> > > semantics of GET operations intermixed with ADD/DEL operations:
> > > 
> > > AFAIK there are currently some inconsistencies:
> > > 
> > > - new sets get marked as inactive and invisible to GET until the
> > >   transaction is supported. So
> > > 
> > >   ADD set
> > >   GET set
> > > 
> > >   will return ENOENT.
> > 
> > These two follow different paths.
> > 
> > The ADD is included in the batch, the GET doesn't. So we won't see the
> > object until we have finish processing a full batch.
> 
> That's on the userspace side? I didn't notice anything in the kernel
> not handling GET inside a batch.

        [NFT_MSG_NEWRULE] = {
                .call_batch     = nf_tables_newrule,
        ...
        [NFT_MSG_GETRULE] = {
                .call           = nf_tables_getrule,

Add/del uses .call_batch, get uses .call.

> >     ADD set
> >     --------> batch OK, commit
> >     GET set
> > 
> > > - Rule GET operations OTOH don't care about the activeness of the rule
> > >   at all, so
> > > 
> > >   DEL rule
> > >   GET rule
> > > 
> > >   will return the rule even though it is actually deleted.
> > >
> > >   ADD rule
> > >   GET rule
> > >   transaction fail
> > > 
> > >   Will equally return the rule even though it will afterwards not be
> > >   present.
> > > 
> > > So the general question is how to properly handle this. GET operations
> > > should obviously take activeness into account and not return deleted
> > > objects.
> > 
> > You have DUMP_INTR if a get happens while updating any of the lists.
> 
> Yeah, I meant the case of non-dump GET operations.

I see, in this case I think we can signal the process so it knows it's
been fetching an object while an update it happening, but that code is
missing.

We can probably simplify the existing code by setting the INTR flag if
a commit is happening, both for dump and get.

> > > The next question would be how to handle failed transactions. We should
> > > obviously only return new objects if the transaction actually succeeds,
> > > so I guess this means handling GET requests in the commit path.
> > 
> > Userspace will notice the interference via the netlink flag and will
> > retry from scratch.
> 
> Only talking about non-dumps, but I guess it equally applies to dumps
> for the case that all objects fit into the first message.

For small dumps, the generation counter (exported via
nfgenmsg->res_id) should still catch the interference.
