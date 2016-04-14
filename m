From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v5 nf-next 4/4] netfilter: nftables: add connlabel set
 support
Date: Thu, 14 Apr 2016 12:08:37 +0200
Message-ID: <20160414100837.GA2748@salvia>
References: <1460477666-17823-1-git-send-email-fw@strlen.de>
 <1460477666-17823-5-git-send-email-fw@strlen.de>
 <20160414094835.GA2119@salvia>
 <20160414100527.GB3192@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37079 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbcDNKIp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 06:08:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1AC2613C0E4
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:08:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0E0CE9D0E3
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:08:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ECF239D0EA
	for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2016 12:08:37 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160414100527.GB3192@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2016 at 12:05:27PM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Apr 12, 2016 at 06:14:26PM +0200, Florian Westphal wrote:
> > > diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
> > > index 25998fa..4ec1cea 100644
> > > --- a/net/netfilter/nft_ct.c
> > > +++ b/net/netfilter/nft_ct.c
> > > @@ -29,6 +29,11 @@ struct nft_ct {
> > >  		enum nft_registers	dreg:8;
> > >  		enum nft_registers	sreg:8;
> > >  	};
> > > +	union {
> > > +		u8		set_bit;
> > > +	} imm;

BTW, do you really need this set_bit? I think we can just take the
data from the nft_data structure.

> > > +	unsigned int		imm_len:8;

This length, you will not need anymore with select_ops(), right=

> > > +	struct nft_data		immediate;
> > 
> > Could you use select_ops() so we don't increase the size of nft_ct for
> > other users?
> 
> Sure.
> 
> I'd split this into nft_ct (sreg/dreg)
> and nft_ct_set_imm (set from immediate).

I'd suggest "struct nft_ct_reg" and "struct nft_ct_imm", so we can
reuse the immediate from the get part if we can get rid of the imm_len
and set_bit fields.

Thanks.
