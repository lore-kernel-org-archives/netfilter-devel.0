From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nft] ct expr: make directional keys work
Date: Thu, 17 Dec 2015 14:03:44 +0100
Message-ID: <20151217130344.GA3198@breakpoint.cc>
References: <20151217005533.GA24044@strlen.de>
 <20151217111334.GA1694@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:36288 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753119AbbLQNDq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2015 08:03:46 -0500
Content-Disposition: inline
In-Reply-To: <20151217111334.GA1694@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Dec 17, 2015 at 01:55:33AM +0100, Florian Westphal wrote:
> > some ct expressions don't work at the moment since we never set the
> > 'direction' attribute, but kernel mandates it.
> > 
> > The current approach i've been working splits ct keywords into
> > two groups, one mandates a 'direction' argument (saddr, protocol),
> > others do not (mark for example).
> > 
> > Would this syntax be acceptable?
> > 
> > ct saddr original 192.168.0.1
> 
> Did you try to fit this in the existing parser to see if it result in
> shift/reduce conflicts?

Yes, no s/r conflicts.

I'll send what I have later today or tomorrow.

> So I think with such syntax the grammar would need to be upgraded to
> something like:
> 
> ct_key                  :       SADDR   ORIGINAL        { $$ = ...; }
>                         |       SADDR   REPLY           { $$ = ...; }

I could give that a try too, at the moments its basically

ct_expr                 :       CT      ct_key
                        {
                                $$ = ct_expr_alloc(&@$, $1, NULL);
                        }
                        |       CT      ct_direction       ct_directional_key
                        {
                                $$ = ct_expr_alloc(&@$, $1, $2);
                        }


> ct_direction            :       DIRECTION       STRING
>                         {

and no new keywords (reuses the symbolic type in src/ct.c)

> > If not, I'd like suggestions on how this should look like instead.
> > 
> > Since the saddr (and a few other) arguments have unknown size
> > (depends on the l3 tracker tuple sizes), its currently filled in
> > later depending on NH base (i.e. in nft upstream).
> > 
> > This means that
> > 
> > ct proto-dst original ssh
> > 
> > will NOT work, but
> > 
> > ct protocol original tcp ct proto-dst original ssh
> >
> > would.  Is that ok?  I don't see how I could auto-add the dependency in
> > such case.
> 
> I see, you're proposing to extract the dependency from the service,
> but then if I specify 22 instead (numeric value) we cannot extract
> anything from there.

Yes, thats right.  For consisteny it does make sense to require an
explicit L4 protocol, so I guess I'll keep it as-is for now.

We can improve it later to allow 'magic' derivation of the dependeny
if we really want to.

> I would start simple, ie. bail out and ask the user that the layer 4
> protocol needs to be explicitly specified in case the port is
> specified, same thing with layer 3. Better to start being a bit more
> restrictive and relax this than the other way around I'd say.

agree

> > Finally, I'm working on support for packets and byte counters.
> > 
> > Fetching original or reply directions would 'just work' after
> > directional keys are supported, i.e.:
> > 
> > ct packets original > 100
> > 
> > But I'm not sure how we should handle the case where someone wants to test
> > 'X bytes/packets in total'.
> 
> I'd suggest to add NFT_CT_CTR_BOTH, ie. we'll have
> NFT_CT_CTR_ORIG, NFT_CT_CTR_REPL and NFT_CT_CTR_BOTH.

Ok, I'll do the summing-up in nft_ct.c then.

> > ct packets > 100:
> > could be confusing, also not sure how difficult it is
> > to allow ct keywords that have an optional direction
> 
> I think this should fit into the grammar that I'm proposing above with
> no shift/reduce conflicts, ie.
> 
> ct packets VALUE
> ct direction original packets VALUE
> ct direction reply packets VALUE

I'll have to check.  I don't want to add any new keywords to the lexer
since that creates more problems for the grammar.

(where we choke because something that should be treated/parsed as a
 plain string is then cosidered a keyword...)

I think I'll have something presentable by tomorrow.

Thanks.
