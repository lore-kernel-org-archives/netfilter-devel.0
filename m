From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] libnftables: Fix for multiple context instances
Date: Mon, 20 Nov 2017 14:07:32 +0100
Message-ID: <20171120130732.GA20990@salvia>
References: <20171116191024.18908-1-phil@nwl.cc>
 <20171120123726.GA17459@salvia>
 <20171120125418.GU32305@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55508 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751071AbdKTNIk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2017 08:08:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 69392392E1F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 14:08:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 380C1A0AC0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2017 14:08:39 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20171120125418.GU32305@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:54:18PM +0100, Phil Sutter wrote:
> On Mon, Nov 20, 2017 at 01:37:26PM +0100, Pablo Neira Ayuso wrote:
> > On Thu, Nov 16, 2017 at 08:10:24PM +0100, Phil Sutter wrote:
> > > If a second context is created, the second call to nft_ctx_free() leads
> > > to freeing invalid pointers in nft_exit(). Fix this by introducing a
> > > reference counter so that neither nft_init() nor nft_exit() run more
> > > than once in a row.
> > > 
> > > This reference counter has to be protected from parallel access. Do this
> > > using a mutex in a way that once nft_init() returns, the first call to
> > > that function running in parallel is guaranteed to be finished -
> > > otherwise it could happen that things being initialized in one thread
> > > are already accessed in another one.
> > 
> > I would prefer this table is placed into the context object, so they
> > are not global anymore. So I would prefer we fix this the right way(tm).
> > 
> > Let me know your thoughts, thanks!
> 
> I don't think that's feasible: Looking at 'mark_tbl' for instance, this is
> accessed from callbacks in 'mark_type', so we would have to make nft_ctx
> accessible by all functions dealing with datatypes.

Probably some specific new context object that wrap access to these
tables, not necessarily nft_ctx.

It's just more code, it will not be a small patch, but I don't see any
reason this can't be done.
