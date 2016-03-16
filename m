From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Wed, 16 Mar 2016 14:35:19 +0100
Message-ID: <20160316133519.GA30252@salvia>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
 <20160315170813.GA25284@salvia>
 <20160315230921.GD8185@breakpoint.cc>
 <20160316093933.GA16938@breakpoint.cc>
 <20160316131754.GA28195@salvia>
 <20160316133142.GA30305@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33598 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966410AbcCPNf2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 09:35:28 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 8416B1BFA88
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:35:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 721E9DA399
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:35:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A464EDA38C
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:35:24 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160316133142.GA30305@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 02:31:42PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > I was thinking on simplifying the codebase one we get more immediates,
> > we will at least get one more to handle ct helper assignment.
> > 
> > So from the code we can just check:
> > 
> >         if (nla[NFTA_CT_IMM]) {
> >                 err = nla_parse_nested(tb, NFTA_CT_IMM, nla, nft_ct_imm_policy);
> >                 if (err < 0)
> >                         return err;
> > 
> >                 switch (key) {
> >                 case NFT_CT_LABEL:
> >                         if (!tb[NFTA_CT_IMM_LABEL])
> >                                 return -EINVAL;
> 
> Right, something like this.
> 
> 
> > BTW, probably we should consider using some generic way to represent
> > the immediates through enum nft_data_attributes. So we have core code
> > that that every expression can reuse to handle immediates.  I think
> > the concern here is data length validation, eg. labels are 4 bytes and
> > helpers are strings limited to 16 bytes. From the libnftnl side, so
> > far we represent these as _DATA attributes:
> > 
> > enum {
> >         NFTNL_EXPR_CMP_SREG     = NFTNL_EXPR_BASE,
> >         NFTNL_EXPR_CMP_OP,
> >         NFTNL_EXPR_CMP_DATA,
> > };
> > 
> > Otherwise, we'll start seeing code in every expression handling
> > immediates in their own way (ie. in a not consolidated way).
> 
> Yes, thats a valid concern.
> 
> I guess it depends on wheter we want to support multi-action, or if
> we will just put several actions after one another.
> 
> set label bla set helper ftp

I would say not to this at this stage.

> If thats two nft_ct invocations, then generic representation
> (NTA_IMM_DATA_U32, NFTA_IMM_DATA_STRING, ...) that can be used by any
> expressions that need to carry their own immediate values is definitely
> much better.
> 
> I'll go with using generic IMM_U32 for now, inside a CT_IMM nested
> attr.

OK, give it a shot. Thanks Florian.
