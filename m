From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] expr: do not suppress OP_EQ when RHS is bitmask type
Date: Fri, 4 Apr 2014 17:39:17 +0200
Message-ID: <20140404153917.GF6769@breakpoint.cc>
References: <1395094118-32580-1-git-send-email-fw@strlen.de>
 <20140404081723.GA3574@localhost>
 <20140404083328.GE6769@breakpoint.cc>
 <20140404094433.GA4275@localhost>
 <20140404120946.GD27267@macbook.localnet>
 <20140404140430.GB28581@localhost>
 <20140404142333.GA28798@macbook.localnet>
 <20140404152307.GA3278@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39490 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753270AbaDDPjS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Apr 2014 11:39:18 -0400
Content-Disposition: inline
In-Reply-To: <20140404152307.GA3278@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Apr 04, 2014 at 04:24:40PM +0200, Patrick McHardy wrote:
> > > > If an equality relation is explicitly specified by the user, it also needs
> > > > to be printed. Florian's change is all we need from what I can tell.
> > > 
> > > Then we have to document that in some cases key == value and key
> > > value are equivalent, and when it comes to flags it is not, which is
> > > still rare to me.
> > 
> > Sure. I think I already have it in my documentation. Its basically simply
> > documenting what the implicit op means in which context.
> 
> OK, please go ahead push it, thanks.

done.
