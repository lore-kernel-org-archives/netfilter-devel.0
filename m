From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Tue, 14 Jan 2014 12:33:41 +0000
Message-ID: <20140114123332.GA31204@macbook.localnet>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
 <20140113124202.GA17951@macbook.localnet>
 <20140114090009.GB23920@macbook.localnet>
 <20140114112951.GA6270@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33997 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaANMdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 07:33:45 -0500
Content-Disposition: inline
In-Reply-To: <20140114112951.GA6270@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 12:29:51PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Jan 14, 2014 at 09:00:09AM +0000, Patrick McHardy wrote:
> > On Mon, Jan 13, 2014 at 12:42:03PM +0000, Patrick McHardy wrote:
> > > On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> > > > % nft list table filter
> > > > table ip filter {
> > > > 	...
> > > > 	chain output {
> > > > 		...
> > > > 		ip saddr map { 1.1.1.1 => accept}
> > > > 	}
> > > > }
> > > > 
> > > > It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> > > > type in map_expr_print().
> > > 
> > > The fix is fine of course, but even better would be to get rid of the
> > > vmap keyword IMO. IIRC it only exists because I couldn't manage to get
> > > a conflict free grammar together, but it would be worth another try.
> > 
> > Actually this works fine. Is there agreement on removing the VMAP keyword?
> > If so we should do it before the 0.099 release.
> 
> Sure, go ahead. I like it :) and it's consistent with other data maps.

Crap, I missed that it actually does introduce conflicts. Will try to solve
them or revert that patch.
