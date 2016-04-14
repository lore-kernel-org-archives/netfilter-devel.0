From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set
 support
Date: Thu, 14 Apr 2016 14:35:47 +0200
Message-ID: <20160414123547.GB11700@salvia>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <1460477666-17823-5-git-send-email-fw@strlen.de>
 <20160414094835.GA2119@salvia>
 <20160414100527.GB3192@breakpoint.cc>
 <20160414100837.GA2748@salvia>
 <20160414112652.GD3192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39370 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755443AbcDNMfw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 08:35:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EAA46E6650
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:35:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DD6B99D0EA
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:35:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9A1779D0EE
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 14:35:48 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414112652.GD3192@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 01:26:52PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Apr 14, 2016 at 12:05:27PM +0200, Florian Westphal wrote:
> > > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > On Tue, Apr 12, 2016 at 06:14:26PM +0200, Florian Westphal wrote:
> > > > > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > > > > index 25998fa..4ec1cea 100644
> > > > > --- a/net/netfilter/nft_ct.c
> > > > > +++ b/net/netfilter/nft_ct.c
> > > > > @@ -29,6 +29,11 @@ struct nft_ct {
> > > > >  		enum nft_registers	dreg:8;
> > > > >  		enum nft_registers	sreg:8;
> > > > >  	};
> > > > > +	union {
> > > > > +		u8		set_bit;
> > > > > +	} imm;
> > 
> > BTW, do you really need this set_bit? I think we can just take the
> > data from the nft_data structure.
> 
> An earlier patch did that (did not submit it); I found it ugly
> (set_bit("ntohl(priv->data.data[0])").
> 
>  I can cahnge it back if you want.
> 
> > > > > +	unsigned int		imm_len:8;
> > 
> > This length, you will not need anymore with select_ops(), right=
> 
> Hmm, I followed nft_cmp_fast implementation.
> We expect a 32bit data type for the "label" key.
> 
> The alternative to storing length is to have a hard-coded size dispatch
> based on the key (e.g. use sizeof(u32) for labels).
>
> But this might not work for all future cases.

No problem, we can revisit this. If you believe this is the right
structure layout I'm ok with it, so just focus on the reworking this
to use select_ops().

> I found saving the length from the desc struct to be much simpler
> (because dump function is shorter and doesn't have to guess the right
>  size when dumping).

Dumping is not performance critical path, so I wouldn't bother on
this.

> > I'd suggest "struct nft_ct_reg" and "struct nft_ct_imm", so we can
> > reuse the immediate from the get part if we can get rid of the imm_len
> > and set_bit fields.
> 
> Oh.  I did not expect use of IMM for get operations.

Right.

> Do we need a distinct attribute (IMM_GET vs IMM_SET)?
>
> At the moment the assumption is that presence of IMM requests
> a set operation (presence of both IMM and sreg is an error).

If you use select_ops(), we can just reject whenever the register
attribute is set via -EINVAL.
