From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Thu, 26 Nov 2015 09:54:45 +0000
Message-ID: <20151126095444.GK20093@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <20151125200124.GH30712@macbook.localdomain>
 <20151125202201.GA11893@salvia>
 <20151125204512.GA20093@macbook.localdomain>
 <20151125220528.GA1028@salvia>
 <20151125232323.GD20093@macbook.localdomain>
 <20151126094511.GA1442@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:34012 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060AbbKZJyt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 04:54:49 -0500
Content-Disposition: inline
In-Reply-To: <20151126094511.GA1442@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> > > ToS breaks useful things like ECN, and the more I keep reading docs on
> > > the Internet, the more problem I have to see how the user can benefit
> > > from this.
> > 
> > We *match* on ToS, that cannot possibly break anything. Also I'm unsure how
> > this could break ECN even otherwise, ToS does not even use the ECN bits.
> 
> ToS bits overlap with ECN bits, from that original ToS 8 bit-field now
> we use 6 bit for DSCP and 2 bits for ECN.

Sure, but our ToS definition is wrong anyway, the ToS-bits are actually
3 + 3 + 2 unused bits (ECN).

> > Its quite simple, if the user has old devices that set ToS values, he will
> > be able to match on that without manually converting it to DSCP values.
> > Given that our current tos definition is also not to practical for that
> > since its too broad, I don't really care that much, although I think it
> > should rather be fixed than simply thrown out.
> 
> People that designed DSCP and ECN did not care about having some
> reasonable backward compatible behaviour wrt. ToS. They just changed
> the semantics of those bits long time ago.
> 
> I can explore keeping this backward if you like, we can probably
> accept ToS from the parser, then map it to DSCP, but that will no
> achieve what the user expected on the network. I'm usually reticent to
> break old stuff, but in this case I would skip.

My thought was more fixing our ToS field definition, at that point the user
can use whatever is actually used within his network. I mean, sure, you can
map them to DSCP, but if you're using old devices that only support the
ToS definitions its a lot easier to use the same values instead of mapping
them.

I don't know. I think it should be fairly easy to fix, so I'd prefer that
way I guess. Your choice.
