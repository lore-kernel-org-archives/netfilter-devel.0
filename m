From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v2] netfilter: nft_nth: match every n packets
Date: Thu, 28 Jul 2016 09:42:53 +0200
Message-ID: <20160728074252.GA28885@sonyv>
References: <20160727220053.GA26643@sonyv>
 <20160727230105.GC2565@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35540 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbcG1Hm6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 28 Jul 2016 03:42:58 -0400
Received: by mail-wm0-f67.google.com with SMTP id i5so9828413wmg.2
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Jul 2016 00:42:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160727230105.GC2565@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 28, 2016 at 01:01:05AM +0200, Florian Westphal wrote:
> Laura Garcia Liebana <nevola@gmail.com> wrote:
> > +struct nft_nth {
> > +	enum nft_registers      dreg:8;
> > +	u32			every;
> > +	atomic_t		counter;
> > +};
> > +
> > +static void nft_nth_eval(const struct nft_expr *expr,
> > +			 struct nft_regs *regs,
> > +			 const struct nft_pktinfo *pkt)
> > +{
> > +	struct nft_nth *nth = nft_expr_priv(expr);
> > +	u32 nval, oval;
> > +
> > +	do {
> > +		oval = atomic_read(&nth->counter);
> > +		nval = (oval+1 < nth->every) ? oval+1 : 0;
> > +	} while (atomic_cmpxchg(&nth->counter, oval, nval) != oval);
> > +
> > +	memcpy(&regs->data[nth->dreg], &nth->counter, sizeof(u32));
> 
> So this places current counter value in the dreg.
> 
> How exactly is this used by nftables?
> 
> AFAIU usespace will check if ->dreg is 0 or not, but does that make
> sense?
> 
> Seems to me it would be more straightforward to not use a dreg at all
> and just NFT_BREAK if nval != 0?
> 

The main idea is to provide a round robin like scheduling method, for
example:

ip daddr <ipsaddr> dnat nth 3 map {
        0: <ipdaddrA>,
        1: <ipdaddrB>,
        2: <ipdaddrC>
}

It's a port of the nth mode in the iptables statistic extension module:
http://ipset.netfilter.org/iptables-extensions.man.html#lbCD


> > +static int nft_nth_init(const struct nft_ctx *ctx,
> > +			const struct nft_expr *expr,
> > +			const struct nlattr * const tb[])
> > +{
> > +	struct nft_nth *nth = nft_expr_priv(expr);
> > +
> > +	nth->every = ntohl(nla_get_be32(tb[NFTA_NTH_EVERY]));
> 
> I think you have to check if tb[NFTA_NTH_EVERY] is not NULL first.
> 
> > +	nth->dreg = nft_parse_register(tb[NFTA_NTH_DREG]);
> 
> same here.
> 

It's checked below.

> > +static const struct nft_expr_ops *
> > +nft_nth_select_ops(const struct nft_ctx *ctx,
> > +		   const struct nlattr * const tb[])
> > +{
> > +	if (!tb[NFTA_NTH_DREG] ||
> > +	    !tb[NFTA_NTH_EVERY])
> > +		return ERR_PTR(-EINVAL);
> > +
> > +	return &nft_nth_ops;
> > +}
> 
> Oh, I see -- its already checked here.
> But why does nth implement a select_ops in the first place?
> 

In the future we can include a sreg to set a counter initialization,
but currently there is only one ops structure.

> Otherwise this looks good to me, except that I think we should consider
> putting this in nft_meta.c instead of a new module.

AFAIK meta is more to set or get metainformation from a certain
packet. I consider this expression is closer to counter, but with a
resetting value.

Thank you.
