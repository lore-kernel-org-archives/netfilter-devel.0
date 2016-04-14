From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set
 support
Date: Thu, 14 Apr 2016 13:26:52 +0200
Message-ID: <20160414112652.GD3192@breakpoint.cc>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <1460477666-17823-5-git-send-email-fw@strlen.de>
 <20160414094835.GA2119@salvia>
 <20160414100527.GB3192@breakpoint.cc>
 <20160414100837.GA2748@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41761 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752097AbcDNL0y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 07:26:54 -0400
Content-Disposition: inline
In-Reply-To: <20160414100837.GA2748@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 14, 2016 at 12:05:27PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > On Tue, Apr 12, 2016 at 06:14:26PM +0200, Florian Westphal wrote:
> > > > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > > > index 25998fa..4ec1cea 100644
> > > > --- a/net/netfilter/nft_ct.c
> > > > +++ b/net/netfilter/nft_ct.c
> > > > @@ -29,6 +29,11 @@ struct nft_ct {
> > > >  		enum nft_registers	dreg:8;
> > > >  		enum nft_registers	sreg:8;
> > > >  	};
> > > > +	union {
> > > > +		u8		set_bit;
> > > > +	} imm;
> 
> BTW, do you really need this set_bit? I think we can just take the
> data from the nft_data structure.

An earlier patch did that (did not submit it); I found it ugly
(set_bit("ntohl(priv->data.data[0])").

 I can cahnge it back if you want.

> > > > +	unsigned int		imm_len:8;
> 
> This length, you will not need anymore with select_ops(), right=

Hmm, I followed nft_cmp_fast implementation.
We expect a 32bit data type for the "label" key.

The alternative to storing length is to have a hard-coded size dispatch
based on the key (e.g. use sizeof(u32) for labels).

But this might not work for all future cases.

I found saving the length from the desc struct to be much simpler
(because dump function is shorter and doesn't have to guess the right
 size when dumping).

> I'd suggest "struct nft_ct_reg" and "struct nft_ct_imm", so we can
> reuse the immediate from the get part if we can get rid of the imm_len
> and set_bit fields.

Oh.  I did not expect use of IMM for get operations.

Do we need a distinct attribute (IMM_GET vs IMM_SET)?

At the moment the assumption is that presence of IMM requests
a set operation (presence of both IMM and sreg is an error).
