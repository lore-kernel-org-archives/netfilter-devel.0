From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 0/3] Boolean comparison and exthdr existence match
 support
Date: Mon, 6 Feb 2017 18:16:01 +0100
Message-ID: <20170206171601.GA18164@salvia>
References: <20170117221007.14951-1-phil@nwl.cc>
 <20170123125747.GA2017@salvia>
 <20170206142619.GD8343@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37864 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750950AbdBFRQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Feb 2017 12:16:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9764B1373A5
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:16:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85CEFDA85D
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:16:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2ADE7DA865
        for <netfilter-devel@vger.kernel.org>; Mon,  6 Feb 2017 18:16:02 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170206142619.GD8343@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 06, 2017 at 03:26:20PM +0100, Phil Sutter wrote:
[...]
> On Mon, Jan 23, 2017 at 01:57:47PM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Jan 17, 2017 at 11:10:04PM +0100, Phil Sutter wrote:
> > > The following series adds two distinct features to nftables, though
> > > since the second one depends on presence of the first one this is
> > > submitted as a series.
> > > 
> > > Patch 1 adds support for a boolean variant of relational expression.
> > > It's OP is strictly implicit and determined by RHS being a boolean
> > > expression. It depends on a related kernel patch adding support for
> > > NFT_CMP_BOOL to nft_cmp.c.
> > 
> > If the problem is that we lack of context from the delinearize path,
> > then I would prefer if you scratch one bit from the fib flags to
> > indicate that we want a true (1)/false (0) return value. Just like we
> > plan to do with exthdr. This should require a small kernel patch for
> > nft_fib I think.
> > 
> > Thus, we can skip this ad hoc update for nft_cmp which seems to me
> > that it's only there to help us get the context that we lack from the
> > delinearize step.
> 
> This is not ad hoc updating nft_cmp but instead support for a new
> operation. Did you maybe reply having the first approach from my RFC in
> mind? Because I scratched that and went with the second one since it's
> more complete.

I think nft_cmp kernel doesn't need the specific boolean operation,
this is something that belongs to userspace. The existing kernel code
already allows us to match 0 and 1 which is sufficient for what we
need.

> > Then, from the delinearize path, if this fib/exthdr flag is set, we
> > attach the corresponding datatype to the expression based on this new
> > flag.
> 
> The point in NFT_CMP_BOOL is that it's LHS expression agnostic. Whatever
> provides a value there can be checked for being eq/neq zero using the
> boolean operation.
> 
> The context use in delinearize path is implicit (LHS defines RHS dtype)
> and for convenience only: It merely allows printing different "flavors"
> of boolean keywords depending on LHS and could easily be dropped.

I think we already have the context depending on the delinearize path
we follow, ie. netlink_delinearize_fib() may attach flavour A of
boolean, while netlink_delinearize_exthdr() attaches flavour B. BTW, I
would actually prefer to avoid flavouring at this stage, isn't it
found / not found enough for the usecase we have so far?

Thanks.
