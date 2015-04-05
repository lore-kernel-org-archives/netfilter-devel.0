From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] parser: add kludges for "param-problem" and "redirect"
Date: Sun, 5 Apr 2015 13:32:14 +0200
Message-ID: <20150405113214.GA23433@acer.localdomain>
References: <551FC211.6000907@ahsoftware.de>
 <1428145986-15421-1-git-send-email-holler@ahsoftware.de>
 <20150404115550.GA5832@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexander Holler <holler@ahsoftware.de>,
	netfilter-devel@vger.kernel.org,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57341 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbDELcX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2015 07:32:23 -0400
Content-Disposition: inline
In-Reply-To: <20150404115550.GA5832@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.04, Pablo Neira Ayuso wrote:
> On Sat, Apr 04, 2015 at 01:13:06PM +0200, Alexander Holler wrote:
> > Context sensitive handling of "param-problem" and "redirect" is necessary
> > to allow usage of them as token or as string for icmp types.
> [...]
> 
> I think we need some evaluation step at scanner level. This new
> evaluation routine needs to understand the token semantics to set some
> context information.
> 
> "redirect"		{ return scanner_evaluate(ctx, REDIRECT); }
> 
> We have to catch up more use cases such as sets and concatenations. I
> started a patch here, a bit more generalized than this when you
> reported this problem (we actually already knew about it).
> 
> @Patrick, any better idea?

This won't work because the grammar currently allows both cases.

The proper solution IMO is to change the grammar so we know where such
keywords are keywords and where they are constants.

Basically this involves splitting the expression types into lhs (non-const)
and rhs (const) parts. Keywords on the RHS side can be caught using an
error statement and deferred to resolution during runtime.

The second benefit is that we can then use the grammar for tab completion.

I have patches for this, but as I'm currently trying to get the remaining
set and concat patches submitted, I won't be able to work on this until
after the merge window closes.
