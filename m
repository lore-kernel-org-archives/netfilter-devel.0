From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v6 -next 2/4] netfilter: nftables: add connlabel set
 support
Date: Mon, 25 Apr 2016 23:03:17 +0100
Message-ID: <20160425220317.GC29318@macbook.localdomain>
References: <1461249284-12114-1-git-send-email-fw@strlen.de>
 <1461249284-12114-3-git-send-email-fw@strlen.de>
 <20160425103522.GB29560@macbook.localdomain>
 <20160425105909.GC28797@breakpoint.cc>
 <20160425111638.GB30849@macbook.localdomain>
 <20160425115622.GD28797@breakpoint.cc>
 <20160425170541.GC9987@macbook.localdomain>
 <20160425211937.GB17538@breakpoint.cc>
 <20160425213519.GA29318@macbook.localdomain>
 <20160425213816.GA2177@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58031 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965020AbcDYWDW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Apr 2016 18:03:22 -0400
Content-Disposition: inline
In-Reply-To: <20160425213816.GA2177@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25.04, Pablo Neira Ayuso wrote:
> On Mon, Apr 25, 2016 at 10:35:19PM +0100, Patrick McHardy wrote:
> > On 25.04, Florian Westphal wrote:
> > 
> > > If not, I see no choice other than resubmitting the original V1 kernel
> > > patch that simply copied the entire sreg into the label area, this way
> > > no userspace changes are needed.
> > 
> > I have to follow up on the previous discussion. Just wondering, what's wrong
> > with simply memcpy'ing and supplying the full set of labels?
> 
> How can you make this atomic with a 128 bit connlabel?

Good point. But then we already have a theoretical problem in the existing
NFT_CT_LABELS support, at least if we're looking at multiple bits at the
same time.

I'm fine either way, I just wand to understand the reason for the inconsistency
between get and set. If we need atomicity, we probably need to make sure
that get is either a bitop or we only allow to use a single bit of the result.
