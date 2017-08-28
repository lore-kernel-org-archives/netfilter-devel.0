From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nft PATCH 1/2] nft.8: Fix and enhance synopsis section
Date: Mon, 28 Aug 2017 23:25:11 +0200
Message-ID: <20170828212511.GF19224@orbyte.nwl.cc>
References: <20170817133900.21946-1-phil@nwl.cc>
 <20170817133900.21946-2-phil@nwl.cc>
 <20170828165853.GB21786@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60373 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751218AbdH1VZM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Aug 2017 17:25:12 -0400
Content-Disposition: inline
In-Reply-To: <20170828165853.GB21786@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Mon, Aug 28, 2017 at 06:58:53PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Aug 17, 2017 at 03:38:59PM +0200, Phil Sutter wrote:
> > This patch addresses shortcomings in the main synopsis section
> > illustrating possible invocations of nft command:
> > 
> > - Fix font styles to correctly put options into bold font and meta
> >   characters (brackets, pipes) into normal font.
> > 
> > - Add missing options to synopsis line.
> > 
> > - Use curly braces where either one of the alternatives is required.
> > 
> > - Remove choice="opt" attribute since that is the default anyway.
> > 
> > - Note that --includepath option is allowed to be given multiple times.
> 
> I'm going to apply this.

Thanks!

> I'm undecided with 2/2,

>From my side, this is according to (the hidden) plan. :)

> I don't remember to have seen such indirections in other manpages?

>From iproute2 (as said, I'm biased), I'm used to stuff like this:
	
| nft [ OPTIONS ] ...
|
| OPTIONS := [ OPTIONS ] OPTION
| OPTION := [ -a | -e | -n ]

Maybe for others it's more of an obstacle to parse this recursive style,
it really seems intuitive to me at least. And it's a quite efficient way
to define the syntax in a very precise manner.

Of course it's nice to have some layer of abstraction to allow for
formatting into other markups, like HTML for example. So I'll have a
look at alternatives which will keep that flexibility yet allow for the
style I prefer (unless you consider it not much more readable than what
docbook offers).

Thanks, Phil

