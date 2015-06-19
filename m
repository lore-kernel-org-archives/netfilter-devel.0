From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:41:29 +0200
Message-ID: <20150619134129.GK22946@acer.localdomain>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org>
 <20150619125724.GG22946@acer.localdomain>
 <20150619133726.GA11813@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56652 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbbFSNle (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:41:34 -0400
Content-Disposition: inline
In-Reply-To: <20150619133726.GA11813@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19.06, Pablo Neira Ayuso wrote:
> On Fri, Jun 19, 2015 at 02:57:24PM +0200, Patrick McHardy wrote:
> > On 19.06, Pablo Neira Ayuso wrote:
> > > This allows you to clone packets to some destination, eg.
> > > 
> > > ... tee gateway 172.20.0.2
> > > ... tee oifname tap0 gateway ip saddr map { 192.168.0.2 : 172.20.0.2, ... }
> > 
> > Is tee a name we want to use for userspace syntax? It's not particulary
> > descriptive for people who don't know what "tee" is, which I guess are
> > quite a few. Alternative suggestion of the top of my head would be "dup"
> > or "duplicate".
> 
> I can do so, yes. Do you want to me rename the kernel part to
> nft_dup.c as well? The core name can be net/netfilter/nf_dup.c instead
> of net/netfilter/nf_tee.c

Would be fine with me, however I don't have as strong an opinion about
that as for the userspace syntax.

> > > +struct tee_stmt {
> > > +	struct expr		*gw;
> > > +	const char		*oifname;
> > 
> > I'd suggest to use an expr as well to allow use of symbolic variables.
> > BTW, have you considered using an ifindex? I mean, we do it for matches
> > as well, and in case of tee its rather unlikely to be used with a
> > dynamic network device.
> 
> Note sure about this, we now have tapX in place in VM environments
> that can go up and down.

Good point.

> However, when implementing tee (now dup) for the new netdev and bridge
> family we'll indicate the physical device to duplicate packets, it
> should be good to allow the use ifindef if we want maps in place
> there.
> 
> I think we can change to ifindex, if someone needs with ifname, we can
> add it later on, OK?

Yeah, that sound good to me. Perhaps we even have something that can take
care of all the ifindices until then.

> > > +	reg1 = netlink_parse_register(nle, NFT_EXPR_TEE_SREG_GW);
> > > +	if (reg1) {
> > > +		addr = netlink_get_register(ctx, loc, reg1);
> > > +		if (addr == NULL)
> > > +			return netlink_error(ctx, loc,
> > > +					     "TEE statement has no address "
> > > +					     "expression");
> > > +
> > > +		if (ctx->table->handle.family == NFPROTO_IPV4)
> > > +			expr_set_type(addr, &ipaddr_type, BYTEORDER_BIG_ENDIAN);
> > > +		else
> > > +			expr_set_type(addr, &ip6addr_type,
> > > +				      BYTEORDER_BIG_ENDIAN);
> > > +		stmt->tee.gw = addr;
> > > +	}
> > > +
> > > +	if (nft_rule_expr_is_set(nle, NFT_EXPR_TEE_OIFNAME)) {
> > > +		stmt->tee.oifname =
> > > +			strdup(nft_rule_expr_get_str(nle, NFT_EXPR_TEE_OIFNAME));
> > 
> > Please use consistent braces, IOW none for single statements.
> 
> I'll do it, but I think it's unclear wrt. kernel netdev coding style,
> since the line split can be considered as two lines.

For the kernel the coding style states to now use them for single statements.
This is what we also have in most places in nft.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
