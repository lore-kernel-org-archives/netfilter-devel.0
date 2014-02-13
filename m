From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 13:01:03 +0000
Message-ID: <20140213130102.GB4223@macbook.localnet>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
 <20140213115112.GA30397@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39377 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaBMNBH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:01:07 -0500
Content-Disposition: inline
In-Reply-To: <20140213115112.GA30397@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 11:51:12AM +0000, Patrick McHardy wrote:
> On Thu, Feb 13, 2014 at 12:41:12PM +0100, Pablo Neira Ayuso wrote:
> > hexstring:hexstring
> > hexstring:
> > :hexstring
> > ---
> > The spaces to separate the key and the action in dictionaries is very
> > important, otherwise (with this patch) the scanner misinterprets this.
> > 
> >  # nft add filter input tcp dport vmap { 25:drop }
> >  <cmdline>:1:41-43: Error: syntax error, unexpected string, expecting comma or '}'
> >  add rule filter input tcp dport vmap { 25:drop }
> >                                         ^^^
> > I think we can just document this, I don't see any better solution for this
> > at this moment.
> 
> Let me try if I can come up with something ...

I think we might be able to do something with flex "trailing contexts",
though I didn't manage to figure it out yet.

Generally it seems like using a ':' in maps might not be the best idea
after all, its used for too many other things already. This might be
the reason why I initially used =>, not sure anymore.

Is there a reasonable alternative to ':' with a single character?
