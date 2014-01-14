From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] expression: fix output of verdict maps
Date: Tue, 14 Jan 2014 12:29:51 +0100
Message-ID: <20140114112951.GA6270@localhost>
References: <1389616756-8326-1-git-send-email-pablo@netfilter.org>
 <20140113124202.GA17951@macbook.localnet>
 <20140114090009.GB23920@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>, f@localhost
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51721 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaANLaE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:30:04 -0500
Content-Disposition: inline
In-Reply-To: <20140114090009.GB23920@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 14, 2014 at 09:00:09AM +0000, Patrick McHardy wrote:
> On Mon, Jan 13, 2014 at 12:42:03PM +0000, Patrick McHardy wrote:
> > On Mon, Jan 13, 2014 at 01:39:16PM +0100, Pablo Neira Ayuso wrote:
> > > % nft list table filter
> > > table ip filter {
> > > 	...
> > > 	chain output {
> > > 		...
> > > 		ip saddr map { 1.1.1.1 => accept}
> > > 	}
> > > }
> > > 
> > > It displays 'map' instead of 'vmap'. Fix it by checking the mapping
> > > type in map_expr_print().
> > 
> > The fix is fine of course, but even better would be to get rid of the
> > vmap keyword IMO. IIRC it only exists because I couldn't manage to get
> > a conflict free grammar together, but it would be worth another try.
> 
> Actually this works fine. Is there agreement on removing the VMAP keyword?
> If so we should do it before the 0.099 release.

Sure, go ahead. I like it :) and it's consistent with other data maps.
