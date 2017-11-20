From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH] libnftables: Fix for multiple context instances
Date: Mon, 20 Nov 2017 13:54:18 +0100
Message-ID: <20171120125418.GU32305@orbyte.nwl.cc>
References: <20171116191024.18908-1-phil@nwl.cc>
 <20171120123726.GA17459@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:42396 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751073AbdKTMyT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 07:54:19 -0500
Content-Disposition: inline
In-Reply-To: <20171120123726.GA17459@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:37:26PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Nov 16, 2017 at 08:10:24PM +0100, Phil Sutter wrote:
> > If a second context is created, the second call to nft_ctx_free() leads
> > to freeing invalid pointers in nft_exit(). Fix this by introducing a
> > reference counter so that neither nft_init() nor nft_exit() run more
> > than once in a row.
> > 
> > This reference counter has to be protected from parallel access. Do this
> > using a mutex in a way that once nft_init() returns, the first call to
> > that function running in parallel is guaranteed to be finished -
> > otherwise it could happen that things being initialized in one thread
> > are already accessed in another one.
> 
> I would prefer this table is placed into the context object, so they
> are not global anymore. So I would prefer we fix this the right way(tm).
> 
> Let me know your thoughts, thanks!

I don't think that's feasible: Looking at 'mark_tbl' for instance, this is
accessed from callbacks in 'mark_type', so we would have to make nft_ctx
accessible by all functions dealing with datatypes.

Cheers, Phil
