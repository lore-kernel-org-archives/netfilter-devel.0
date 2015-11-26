From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft 1/2] src: add dscp support
Date: Thu, 26 Nov 2015 10:42:49 +0000
Message-ID: <20151126104249.GA16828@macbook.localdomain>
References: <1448480362-12411-1-git-send-email-pablo@netfilter.org>
 <20151125200124.GH30712@macbook.localdomain>
 <20151125202201.GA11893@salvia>
 <20151125204512.GA20093@macbook.localdomain>
 <20151125220528.GA1028@salvia>
 <20151125232323.GD20093@macbook.localdomain>
 <20151126094511.GA1442@salvia>
 <20151126095444.GK20093@macbook.localdomain>
 <20151126102833.GA2237@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:34369 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751848AbbKZKm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Nov 2015 05:42:58 -0500
Content-Disposition: inline
In-Reply-To: <20151126102833.GA2237@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26.11, Pablo Neira Ayuso wrote:
> On Thu, Nov 26, 2015 at 09:54:45AM +0000, Patrick McHardy wrote:
> > On 26.11, Pablo Neira Ayuso wrote:
> > > > > ToS breaks useful things like ECN, and the more I keep reading docs on
> > > > > the Internet, the more problem I have to see how the user can benefit
> > > > > from this.
> > > > 
> > > > We *match* on ToS, that cannot possibly break anything. Also I'm unsure how
> > > > this could break ECN even otherwise, ToS does not even use the ECN bits.
> > > 
> > > ToS bits overlap with ECN bits, from that original ToS 8 bit-field now
> > > we use 6 bit for DSCP and 2 bits for ECN.
> > 
> > Sure, but our ToS definition is wrong anyway, the ToS-bits are actually
> > 3 + 3 + 2 unused bits (ECN).
> 
> That's right according to the original ToS definition, but looking a
> bit further on the RFCs, someone outthere extended this, so I found
> this:
> 
> See 22. Historical Definitions for the IPv4 TOS Octet from
> https://tools.ietf.org/html/rfc3168.
> 
> It refers to https://tools.ietf.org/html/rfc1349 that defines
> Minimize Monetary Cost TOS Value and it extends it to one extra bit
> (from 3 to 4, scratching one from the unused bits).
> 
> Bottom line says "Because of this unstable history, the definition of
> the ECN field in this document cannot be guaranteed to be backwards
> compatible with all past uses of these two bits."
> 
> Anyway, looking at the Linux header definitions, we have the
> 
> #define IPTOS_MINCOST           0x02
> 
> The mincost thing is there.
> 
> #define IPTOS_TOS_MASK          0x1E
> #define IPTOS_TOS(tos)          ((tos)&IPTOS_TOS_MASK)
> 
> So it seems our headers are considering ToS is 4 bits too.

Hmm Ok its really a mess. Let's get rid of it for now and we might reconsider
if a user turns up that can make a valid case.
