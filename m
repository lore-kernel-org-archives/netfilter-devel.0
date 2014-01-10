From: Patrick McHardy <kaber@trash.net>
Subject: Re: datatype: fix crash if wrong integer type is passed
Date: Fri, 10 Jan 2014 11:13:13 +0000
Message-ID: <20140110111312.GA28513@macbook.localnet>
References: <20140110080425.GA3799@macbook.localnet>
 <20140110095247.GA4159@localhost>
 <20140110100245.GA26080@macbook.localnet>
 <20140110101504.GA4583@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: eric@regit.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58346 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903AbaAJLNR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:13:17 -0500
Content-Disposition: inline
In-Reply-To: <20140110101504.GA4583@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 11:15:04AM +0100, Pablo Neira Ayuso wrote:
> On Fri, Jan 10, 2014 at 10:02:46AM +0000, Patrick McHardy wrote:
> > On Fri, Jan 10, 2014 at 10:52:47AM +0100, Pablo Neira Ayuso wrote:
> [...]
> > > So integer_type_parse() returns NULL, note that **res is left
> > > uninitialized.
> > 
> > Right, but only if invoked from an upper layer datatype. This needs to
> > make sure we don't return NULL without an erec. This was actually a bug
> > in the meta expression that I just posted a fix for.
> >
> > > Going back to expr_evaluate_symbol(), since NULL is returned, it
> > > assumes that an expression has been allocated.
> > > 
> > > I guess this doesn't crash all the time as we're relying on an
> > > uninitialized memory area and we can argue that the fix may not be
> > > optimal, but I really think this is fixing something.
> > 
> > Well, the proper fix seems to be to initialize *res to NULL in meta
> > before invoking the integer type parsing function.
> 
> I guess you mean this patch: http://patchwork.ozlabs.org/patch/309211/

Correct.
