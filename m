From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set
 support
Date: Thu, 14 Apr 2016 12:05:27 +0200
Message-ID: <20160414100527.GB3192@breakpoint.cc>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <1460477666-17823-5-git-send-email-fw@strlen.de>
 <20160414094835.GA2119@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41651 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753003AbcDNKFa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 06:05:30 -0400
Content-Disposition: inline
In-Reply-To: <20160414094835.GA2119@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Apr 12, 2016 at 06:14:26PM +0200, Florian Westphal wrote:
> > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > index 25998fa..4ec1cea 100644
> > --- a/net/netfilter/nft_ct.c
> > +++ b/net/netfilter/nft_ct.c
> > @@ -29,6 +29,11 @@ struct nft_ct {
> >  		enum nft_registers	dreg:8;
> >  		enum nft_registers	sreg:8;
> >  	};
> > +	union {
> > +		u8		set_bit;
> > +	} imm;
> > +	unsigned int		imm_len:8;
> > +	struct nft_data		immediate;
> 
> Could you use select_ops() so we don't increase the size of nft_ct for
> other users?

Sure.

I'd split this into nft_ct (sreg/dreg)
and nft_ct_set_imm (set from immediate).

Does that sound okay?
