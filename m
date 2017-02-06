From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 0/3] Boolean comparison and exthdr existence match
 support
Date: Mon, 6 Feb 2017 15:26:20 +0100
Message-ID: <20170206142619.GD8343@orbyte.nwl.cc>
References: <20170117221007.14951-1-phil@nwl.cc>
 <20170123125747.GA2017@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:37881 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751948AbdBFO00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 09:26:26 -0500
Content-Disposition: inline
In-Reply-To: <20170123125747.GA2017@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Jan 23, 2017 at 01:57:47PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 17, 2017 at 11:10:04PM +0100, Phil Sutter wrote:
> > The following series adds two distinct features to nftables, though
> > since the second one depends on presence of the first one this is
> > submitted as a series.
> > 
> > Patch 1 adds support for a boolean variant of relational expression.
> > It's OP is strictly implicit and determined by RHS being a boolean
> > expression. It depends on a related kernel patch adding support for
> > NFT_CMP_BOOL to nft_cmp.c.
> 
> If the problem is that we lack of context from the delinearize path,
> then I would prefer if you scratch one bit from the fib flags to
> indicate that we want a true (1)/false (0) return value. Just like we
> plan to do with exthdr. This should require a small kernel patch for
> nft_fib I think.
> 
> Thus, we can skip this ad hoc update for nft_cmp which seems to me
> that it's only there to help us get the context that we lack from the
> delinearize step.

This is not ad hoc updating nft_cmp but instead support for a new
operation. Did you maybe reply having the first approach from my RFC in
mind? Because I scratched that and went with the second one since it's
more complete.

> Then, from the delinearize path, if this fib/exthdr flag is set, we
> attach the corresponding datatype to the expression based on this new
> flag.

The point in NFT_CMP_BOOL is that it's LHS expression agnostic. Whatever
provides a value there can be checked for being eq/neq zero using the
boolean operation.

The context use in delinearize path is implicit (LHS defines RHS dtype)
and for convenience only: It merely allows printing different "flavors"
of boolean keywords depending on LHS and could easily be dropped.

Cheers, Phil
