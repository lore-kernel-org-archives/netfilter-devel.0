From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:56:05 +0200
Message-ID: <20150619135605.GA19470@salvia>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
 <20150619125724.GG22946@acer.localdomain>
 <20150619133726.GA11813@salvia>
 <20150619134129.GK22946@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32832 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbbFSNut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:50:49 -0400
Content-Disposition: inline
In-Reply-To: <20150619134129.GK22946@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 19, 2015 at 03:41:29PM +0200, Patrick McHardy wrote:
> On 19.06, Pablo Neira Ayuso wrote:
> > On Fri, Jun 19, 2015 at 02:57:24PM +0200, Patrick McHardy wrote:
> > > On 19.06, Pablo Neira Ayuso wrote:
> > > > This allows you to clone packets to some destination, eg.
> > > > 
> > > > ... tee gateway 172.20.0.2
> > > > ... tee oifname tap0 gateway ip saddr map { 192.168.0.2 : 172.20.0.2, ... }
> > > 
> > > Is tee a name we want to use for userspace syntax? It's not particulary
> > > descriptive for people who don't know what "tee" is, which I guess are
> > > quite a few. Alternative suggestion of the top of my head would be "dup"
> > > or "duplicate".
> > 
> > I can do so, yes. Do you want to me rename the kernel part to
> > nft_dup.c as well? The core name can be net/netfilter/nf_dup.c instead
> > of net/netfilter/nf_tee.c
> 
> Would be fine with me, however I don't have as strong an opinion about
> that as for the userspace syntax.

I'll rename nft_tee.c to nft_dup.c for consistency.

> > > > +struct tee_stmt {
> > > > +	struct expr		*gw;
> > > > +	const char		*oifname;
> > > 
> > > I'd suggest to use an expr as well to allow use of symbolic variables.
> > > BTW, have you considered using an ifindex? I mean, we do it for matches
> > > as well, and in case of tee its rather unlikely to be used with a
> > > dynamic network device.
> > 
> > Note sure about this, we now have tapX in place in VM environments
> > that can go up and down.
> 
> Good point.
> 
> > However, when implementing tee (now dup) for the new netdev and bridge
> > family we'll indicate the physical device to duplicate packets, it
> > should be good to allow the use ifindef if we want maps in place
> > there.
> > 
> > I think we can change to ifindex, if someone needs with ifname, we can
> > add it later on, OK?
> 
> Yeah, that sound good to me. Perhaps we even have something that can take
> care of all the ifindices until then.

Will do so then.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
