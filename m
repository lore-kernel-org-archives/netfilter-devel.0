From: Phil Sutter <phil@nwl.cc>
Subject: Re: libnftables, next steps
Date: Mon, 16 Oct 2017 17:45:59 +0200
Message-ID: <20171016154559.GQ11332@orbyte.nwl.cc>
References: <20171004225152.GD32278@orbyte.nwl.cc>
 <20171016101904.GA32102@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@regit.org>,
        Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:35722 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751720AbdJPPqC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Oct 2017 11:46:02 -0400
Content-Disposition: inline
In-Reply-To: <20171016101904.GA32102@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Oct 16, 2017 at 12:19:51PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Oct 05, 2017 at 12:51:52AM +0200, Phil Sutter wrote:
[...]
> > * Create src/nftables_common.c and include/nftables_common.h to hold
> >   nft_run() and nft_netlink().
> 
> Why not just place this in src/libnftables.c?

Sounds reasonable. I was merely wondering why Eric chose to distribute
things this way.

[..]
> > Some additional thoughts:
> > 
> > * Should we support different output streams for debug and/or error
> >   messages?
> 
> What usecase you have in mind for this?

This was just me speculating about advanced API features. Assuming that
in future, applications would be able to replicate nft_run_cmd_from_*()
functions in their own code, it might be useful for them to configure
different streams for debug/error messages to treat them differently
from "regular" output. But I guess we best just ignore that until
someone actually provides a use-case for it.

> > * Should we reuse src/erec.c for regular output as well? (This probably
> >   needs a 'print immediately' switch for monitor mode, though.)
> 
> Again, same question.

This was just an idea as well, no actual use-case in mind. The nice
thing about error records is that they may be typed (erec->type) and
separate messages stay separate. Right now, applications get everything
in a single buffer and using erec would allow them to distinguish
between different messages without parsing for newlines or the like. But
yeah, maybe just keep in mind for later.

> > Feedback highly appreciated, of course! Should I start with moving the
> > library stuff into libnftables.{c,h} so we get an impression of what the
> > API will look like?
> 
> I think Eric doesn't have time at this stage, so if you can take his
> patches, revamp and resubmit, that would be great.

Will do, thanks for your feedback!

Cheers, Phil
