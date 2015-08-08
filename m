From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Sat, 8 Aug 2015 17:53:13 +0200
Message-ID: <20150808155313.GB29362@acer.localdomain>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
 <20150804092905.GA7944@salvia>
 <20150804102635.GC6033@acer.localdomain>
 <20150804170447.GA3355@salvia>
 <20150805090915.GD13187@acer.localdomain>
 <20150806102043.GA18683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60060 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964799AbbHHPxW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Aug 2015 11:53:22 -0400
Content-Disposition: inline
In-Reply-To: <20150806102043.GA18683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 06.08, Pablo Neira Ayuso wrote:
> > That might work if the message ordering is then guaranteed. However I think
> > we can fix this case without changing NEWGEN. Let me think about that a bit,
> > for now just taking care of the genid checks correctly seems like a good
> > step forward.
> 
> But we can catch this problem through ->res_id, OK?

Have to look at it in detail. Currently sitting at the airport, will
take me a bit.

> > BTW, we also need to adjust loop detection to only take into account
> > active rules, active chains, active sets etc.
> 
> Indeed, thanks Patrick.
> 
> Will you take care of this? It would be great to have a fix for these
> in this merge window. On top of that, I have a patchset here to add

Sure. I already have this in my patches, however I'll wait for your new
patchset so I can test on top of it.

> named expressions as you suggested as a generic way to implement named
> counters (or any other stateful expression) and I need that this is
> fixed first so I don't need to add another ugly _INACTIVE flag to the
> nft_nexpr object.
> 
> Let me know, thanks!

I agree, the _INACTIVE flags need to go.
