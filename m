From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH v2 1/4] libnftables: Move library stuff out of main.c
Date: Tue, 24 Oct 2017 18:42:31 +0200
Message-ID: <20171024164231.GQ32305@orbyte.nwl.cc>
References: <20171023153319.13415-1-phil@nwl.cc>
 <20171023153319.13415-2-phil@nwl.cc>
 <20171024154800.GA11705@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Leblond <eric@regit.org>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35608 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751759AbdJXQmd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 24 Oct 2017 12:42:33 -0400
Content-Disposition: inline
In-Reply-To: <20171024154800.GA11705@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Tue, Oct 24, 2017 at 05:48:00PM +0200, Pablo Neira Ayuso wrote:
> On Mon, Oct 23, 2017 at 05:33:16PM +0200, Phil Sutter wrote:
[...]
> > +/**
> > + * Exit codes returned by nft_run_cmd_from_*()
> > + */
> > +enum nftables_exit_codes {
> > +	NFT_EXIT_SUCCESS	= 0,
> > +	NFT_EXIT_FAILURE	= 1,
> > +	NFT_EXIT_NOMEM		= 2,
> > +	NFT_EXIT_NONL		= 3,
> > +};
> 
> I think library is currently aborting in case of no-netlink and
> no-memory, so these two error codes are not useful.
> 
> We would need to change codebase to propagate errors up to the
> callers.

Ah yes, indeed. I guess for a library, calling exit() is a no-go. :)

> Regarding error code, I would go for -1 in case of error instead and 0
> in case of success. If failure happens, then set errno with reason, so
> we can get rid of these exit codes in a follow up patch?

Sounds good, I'll send a follow-up.

Thanks, Phil


