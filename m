From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC nft] ct expr: make directional keys work
Date: Thu, 17 Dec 2015 12:13:34 +0100
Message-ID: <20151217111334.GA1694@salvia>
References: <20151217005533.GA24044@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35101 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbbLQLNo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Dec 2015 06:13:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9DE441324F5
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:13:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 79F18DA863
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:13:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B09B3DA865
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Dec 2015 12:13:37 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151217005533.GA24044@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 17, 2015 at 01:55:33AM +0100, Florian Westphal wrote:
> some ct expressions don't work at the moment since we never set the
> 'direction' attribute, but kernel mandates it.
> 
> The current approach i've been working splits ct keywords into
> two groups, one mandates a 'direction' argument (saddr, protocol),
> others do not (mark for example).
> 
> Would this syntax be acceptable?
> 
> ct saddr original 192.168.0.1

Did you try to fit this in the existing parser to see if it result in
shift/reduce conflicts?

I'm telling this because the relational expression expects a ct
expression on the left hand side, and a value on the right hand side.

So I think with such syntax the grammar would need to be upgraded to
something like:

ct_key                  :       SADDR   ORIGINAL        { $$ = ...; }
                        |       SADDR   REPLY           { $$ = ...; }

Where the $$ would need to encode both the key and direction.

Probably it's easier to fit this into it like this:

ct_expr                 :       CT      ct_key
                        {
                                $$ = ct_expr_alloc(&@$, $1, IP_CT_DIR_MAX);
                        }
                        |       CT      ct_direction       ct_directional_key
                        {
                                $$ = ct_expr_alloc(&@$, $2, $1);
                        }
                        ;

ct_direction            :       DIRECTION       STRING
                        {
                                int dir;

                                dir = ct_direction_lookup($2);
                                if (dir < 0)
                                        display error on wrong direction
                        }
                        ;

ct_directional_key      :       SADDR   { $$ = NFT_CT_SADDR; }
                        ...

> If not, I'd like suggestions on how this should look like instead.
> 
> Since the saddr (and a few other) arguments have unknown size
> (depends on the l3 tracker tuple sizes), its currently filled in
> later depending on NH base (i.e. in nft upstream).
> 
> This means that
> 
> ct proto-dst original ssh
> 
> will NOT work, but
> 
> ct protocol original tcp ct proto-dst original ssh
>
> would.  Is that ok?  I don't see how I could auto-add the dependency in
> such case.

I see, you're proposing to extract the dependency from the service,
but then if I specify 22 instead (numeric value) we cannot extract
anything from there.

> Moreover, while this is currently implemented as a dependency (type set to
> inet_service if PROTO_BASE_TRANSPORT_HDR present) the kernel does just
> fetch a 16 bit quantity from the tuple so there is no real dependency
> -- its just raw data.
> 
> So we could actually allow things like
> 
> ct proto-dst original 22
> 
> and it would match anything that has a 22 in the dst.tuple.all field...
> but -- does that make sense?

I would start simple, ie. bail out and ask the user that the layer 4
protocol needs to be explicitly specified in case the port is
specified, same thing with layer 3. Better to start being a bit more
restrictive and relax this than the other way around I'd say.

> Finally, I'm working on support for packets and byte counters.
> 
> Fetching original or reply directions would 'just work' after
> directional keys are supported, i.e.:
> 
> ct packets original > 100
> 
> But I'm not sure how we should handle the case where someone wants to test
> 'X bytes/packets in total'.

I'd suggest to add NFT_CT_CTR_BOTH, ie. we'll have
NFT_CT_CTR_ORIG, NFT_CT_CTR_REPL and NFT_CT_CTR_BOTH.

Adding a expression to sum things seems too much for this case I think.

> ct packets > 100:
> could be confusing, also not sure how difficult it is
> to allow ct keywords that have an optional direction

I think this should fit into the grammar that I'm proposing above with
no shift/reduce conflicts, ie.

ct packets VALUE
ct direction original packets VALUE
ct direction reply packets VALUE
