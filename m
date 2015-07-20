From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] tests: validate generated netlink instructions
Date: Mon, 20 Jul 2015 17:27:43 +0200
Message-ID: <20150720152743.GA3372@salvia>
References: <1437096699-8832-1-git-send-email-fw@strlen.de>
 <20150720125004.GA7402@salvia>
 <20150720151046.GD11985@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46738 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756571AbbGTPV7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 11:21:59 -0400
Content-Disposition: inline
In-Reply-To: <20150720151046.GD11985@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 20, 2015 at 05:10:46PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, Jul 17, 2015 at 03:31:39AM +0200, Florian Westphal wrote:
> > > Don't apply -- this patch is intentionally incomplete;
> > > I don't want to spam this list with 350k patch.
> > > 
> > > If you think this is worthwile to have in nft I'll push the full
> > > changeset (this patch + 64 test files with recorded netlink debug output).
> > 
> > I like the idea of having more regression tests.
> > 
> > We can probably kill the old .t files and move the 'regression' to
> > 'tests'.
> 
> Do you mean:
> rm tests/*; mv tests/regression/* tests/ ?
> 
> Otherwise I'm inclined to just push what I have and let you wrangle
> things further if needed :-)

Sure, no problem :)
