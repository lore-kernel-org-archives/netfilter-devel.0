From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH nf-next 0/1] payload mangling support
Date: Mon, 9 Nov 2015 16:00:07 +0000
Message-ID: <20151109160007.GL8098@macbook.localdomain>
References: <1447078234-21628-1-git-send-email-kaber@trash.net>
 <20151109153029.GA7759@breakpoint.cc>
 <20151109154127.GK8098@macbook.localdomain>
 <20151109155014.GB7759@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 161-169.trash.net ([213.144.137.169]:49253 "EHLO
	stinky.trash.net" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751825AbbKIQAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Nov 2015 11:00:11 -0500
Content-Disposition: inline
In-Reply-To: <20151109155014.GB7759@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 09.11, Florian Westphal wrote:
> Patrick McHardy <kaber@trash.net> wrote:
> > On 09.11, Florian Westphal wrote:
> > > Patrick McHardy <kaber@trash.net> wrote:
> > > > So the main questions is basically, do we want to support stateless NAT?
> > > > The downside is that we have to add protocol specific checksumming functions.
> > > 
> > > For now i'm only be interested in mangling MAC addresses for nft bridge
> > > to provide ebtables snat/dnat/redirect equivalents.
> > 
> > I have not tested that, it probably needs some minor adjustments to skip
> > checksum updates for NFT_PAYLOAD_LL_HEADER, but other than that, this will
> > obviously work.
> 
> For redirect we also need to alter skb->pkttype to PACKET_HOST.
> 
> I can take care of this later if needed, I'd just need advice on
> how to add this (meta statement?).

Good point. I guess that would be the proper solution, I don't think we want to
try to figure out whether an address is local in the payload module.

