From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 13:36:38 +0000
Message-ID: <20140213133638.GB5467@macbook.localnet>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org>
 <1392291672-7885-2-git-send-email-pablo@netfilter.org>
 <20140213115112.GA30397@macbook.localnet>
 <20140213130102.GB4223@macbook.localnet>
 <20140213133137.GA9181@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39746 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbaBMNgm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:36:42 -0500
Content-Disposition: inline
In-Reply-To: <20140213133137.GA9181@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 13, 2014 at 02:31:37PM +0100, Pablo Neira Ayuso wrote:
> On Thu, Feb 13, 2014 at 01:01:03PM +0000, Patrick McHardy wrote:
> > On Thu, Feb 13, 2014 at 11:51:12AM +0000, Patrick McHardy wrote:
> > 
> > I think we might be able to do something with flex "trailing contexts",
> > though I didn't manage to figure it out yet.
> > 
> > Generally it seems like using a ':' in maps might not be the best idea
> > after all, its used for too many other things already. This might be
> > the reason why I initially used =>, not sure anymore.
> > 
> > Is there a reasonable alternative to ':' with a single character?
> 
> Everything seems pretty overloaded, and I still like that python uses
> this for dictionaries.

I also thing this would be the nicest way to express this.

> I think even bash and gcc provide bad error reporting if one space is
> missing in a for/while statement or a missing bracket is left out.
> 
> Let's check if that trailing context can help us to fix it, if not,
> just document it.

I think I almost got it using:

{priostring}/[ \t\n:]   {

Only thing missing is EOF handling, IOW when the priostring is the last
expression on the command line (not in files) it fails.

I also changed priostring to:

priostring      ({hexdigit}{1,4}:{hexdigit}{0,4})|({hexdigit}{0,4}:{hexdigit}{1,4})

since it otherwise also matches a single ':'. I'll try again later, have
to take care of other things first.

> We can revisit the scanner/parser at some point. I checked antlr but I
> don't think their C library API is very stable / ready for third party
> project. But not now, we already have quite a lot of work in many
> other fronts :)

Yeah, this is something for the future.
