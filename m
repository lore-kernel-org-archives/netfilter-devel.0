From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 14:31:37 +0100
Message-ID: <20140213133137.GA9181@localhost>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
 <20140213115112.GA30397@macbook.localnet>
 <20140213130102.GB4223@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57336 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098AbaBMNb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:31:57 -0500
Content-Disposition: inline
In-Reply-To: <20140213130102.GB4223@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 01:01:03PM +0000, Patrick McHardy wrote:
> On Thu, Feb 13, 2014 at 11:51:12AM +0000, Patrick McHardy wrote:
> > On Thu, Feb 13, 2014 at 12:41:12PM +0100, Pablo Neira Ayuso wrote:
> > > hexstring:hexstring
> > > hexstring:
> > > :hexstring
> > > ---
> > > The spaces to separate the key and the action in dictionaries is very
> > > important, otherwise (with this patch) the scanner misinterprets this.
> > > 
> > >  # nft add filter input tcp dport vmap { 25:drop }
> > >  <cmdline>:1:41-43: Error: syntax error, unexpected string, expecting comma or '}'
> > >  add rule filter input tcp dport vmap { 25:drop }
> > >                                         ^^^
> > > I think we can just document this, I don't see any better solution for this
> > > at this moment.
> > 
> > Let me try if I can come up with something ...
> 
> I think we might be able to do something with flex "trailing contexts",
> though I didn't manage to figure it out yet.
> 
> Generally it seems like using a ':' in maps might not be the best idea
> after all, its used for too many other things already. This might be
> the reason why I initially used =>, not sure anymore.
> 
> Is there a reasonable alternative to ':' with a single character?

Everything seems pretty overloaded, and I still like that python uses
this for dictionaries.

I think even bash and gcc provide bad error reporting if one space is
missing in a for/while statement or a missing bracket is left out.

Let's check if that trailing context can help us to fix it, if not,
just document it.

We can revisit the scanner/parser at some point. I checked antlr but I
don't think their C library API is very stable / ready for third party
project. But not now, we already have quite a lot of work in many
other fronts :)
