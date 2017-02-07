From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 0/3] Boolean comparison and exthdr existence match
 support
Date: Tue, 7 Feb 2017 03:28:19 +0100
Message-ID: <20170207022415.4B21165A93@mail.nwl.cc>
References: <20170117221007.14951-1-phil@nwl.cc>
 <20170123125747.GA2017@salvia>
 <20170206142619.GD8343@orbyte.nwl.cc>
 <20170206171601.GA18164@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43511 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751164AbdBGCYR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 21:24:17 -0500
Content-Disposition: inline
In-Reply-To: <20170206171601.GA18164@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 06, 2017 at 06:16:01PM +0100, Pablo Neira Ayuso wrote:
> On Mon, Feb 06, 2017 at 03:26:20PM +0100, Phil Sutter wrote:
> [...]
> > On Mon, Jan 23, 2017 at 01:57:47PM +0100, Pablo Neira Ayuso wrote:
> > > On Tue, Jan 17, 2017 at 11:10:04PM +0100, Phil Sutter wrote:
> > > > The following series adds two distinct features to nftables, though
> > > > since the second one depends on presence of the first one this is
> > > > submitted as a series.
> > > > 
> > > > Patch 1 adds support for a boolean variant of relational expression.
> > > > It's OP is strictly implicit and determined by RHS being a boolean
> > > > expression. It depends on a related kernel patch adding support for
> > > > NFT_CMP_BOOL to nft_cmp.c.
> > > 
> > > If the problem is that we lack of context from the delinearize path,
> > > then I would prefer if you scratch one bit from the fib flags to
> > > indicate that we want a true (1)/false (0) return value. Just like we
> > > plan to do with exthdr. This should require a small kernel patch for
> > > nft_fib I think.
> > > 
> > > Thus, we can skip this ad hoc update for nft_cmp which seems to me
> > > that it's only there to help us get the context that we lack from the
> > > delinearize step.
> > 
> > This is not ad hoc updating nft_cmp but instead support for a new
> > operation. Did you maybe reply having the first approach from my RFC in
> > mind? Because I scratched that and went with the second one since it's
> > more complete.
> 
> I think nft_cmp kernel doesn't need the specific boolean operation,
> this is something that belongs to userspace. The existing kernel code
> already allows us to match 0 and 1 which is sufficient for what we
> need.

Did you intentionally write "match [...] 1" or did you really mean
"match != 1"? I'm asking because the former would require for LHS to
normalize the result while the latter is more generic. But OTOH, if
suitable LHS expressions have to be touched anyway (as per your
suggestions below), this won't become an expression type independent
operation anymore anyway.

> > > Then, from the delinearize path, if this fib/exthdr flag is set, we
> > > attach the corresponding datatype to the expression based on this new
> > > flag.
> > 
> > The point in NFT_CMP_BOOL is that it's LHS expression agnostic. Whatever
> > provides a value there can be checked for being eq/neq zero using the
> > boolean operation.
> > 
> > The context use in delinearize path is implicit (LHS defines RHS dtype)
> > and for convenience only: It merely allows printing different "flavors"
> > of boolean keywords depending on LHS and could easily be dropped.
> 
> I think we already have the context depending on the delinearize path
> we follow, ie. netlink_delinearize_fib() may attach flavour A of
> boolean, while netlink_delinearize_exthdr() attaches flavour B. BTW, I
> would actually prefer to avoid flavouring at this stage, isn't it
> found / not found enough for the usecase we have so far?

Sure, for now just implementing exists/missing keywords is enough.

I don't really like what this is heading towards to be honest:

Assuming that I will use relational_expr to implement boolean operation,
expr_evaluate_relational() will have to do the necessary stitching to
set the "want boolean output" flag to LHS expression and it should
decide whether it is fit for that at all.

Another alternative would be to implement an independent statement, but
that feels like unnecessary code duplication.

In retrospective, I would have preferred if this discussion took place
after I sent those two alternative implementations as RFC. This way it
just feels like I wasted quite some effort for something that's not
appreciated anyway. You seem to have a much clearer idea of how this
boolean comparison should look like, and by giving more precise
instructions you could prevent quite some frustration trying to fulfill
them.

Cheers, Phil
