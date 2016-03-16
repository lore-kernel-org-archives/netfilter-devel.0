From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nftables: add connlabel set
 support
Date: Wed, 16 Mar 2016 14:17:54 +0100
Message-ID: <20160316131754.GA28195@salvia>
References: <1458058211-11147-1-git-send-email-fw@strlen.de>
 <1458058211-11147-2-git-send-email-fw@strlen.de>
 <20160315170813.GA25284@salvia>
 <20160315230921.GD8185@breakpoint.cc>
 <20160316093933.GA16938@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56231 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965649AbcCPNSE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Mar 2016 09:18:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2F2E38434
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:18:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1EE47DA8FB
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:18:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id ACF74DA386
	for <netfilter-devel@vger.kernel.org>; Wed, 16 Mar 2016 14:17:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160316093933.GA16938@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 16, 2016 at 10:39:33AM +0100, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > > @@ -777,6 +778,7 @@ enum nft_ct_attributes {
> > > >  	NFTA_CT_KEY,
> > > >  	NFTA_CT_DIRECTION,
> > > >  	NFTA_CT_SREG,
> > > > +	NFTA_CT_LABEL,
> > > 
> > > We can probably add:
> > > 
> > >         NFTA_CT_IMM
> > 
> > Right, we can derive the exact type based on the key.
> > 
> > > This would be a nested attribute, then inside there we can define the:
> > > 
> > >         NFTA_CT_LABEL
> > 
> > Hmm, why a nested attribute?
> > What do we gain from that?
> > 
> > Do you want the nested attr so that we can define policies
> > for the "immediate subtypes"...?
> > 
> > If its the latter, then ok.
> > 
> > I'd then suggest adding a new enum, for instance:
> > 
> > NFTA_CT_IMM_LABEL
> > 
> > That appear as nested attrs inside the NFTA_CT_IMM one.
> 
> i.e., this:
> 
>   * @NFTA_CT_SREG: source register (NLA_U32)
> + * @NFTA_CT_IMM: immediate value (NLA_NESTED)
>   */
>  enum nft_ct_attributes {
>         NFTA_CT_UNSPEC,
> @@ -783,6 +783,17 @@ enum nft_ct_attributes {
>  };
>  #define NFTA_CT_MAX            (__NFTA_CT_MAX - 1)
>  
> +/*
> + * enum nft_ct_imm_attributes - nf_tables ct expression immediate attributes
> + *
> + * @NFTA_CT_IMM_LABEL: label bit (NLA_U32)
> + */
> +enum nft_ct_imm_attributes {
> +       NFT_CT_IMM_LABEL,
> +       __NFT_IMM_MAX
> +};
> +#define NFT_CT_IMM_MAX (__NFT_IMM_MAX - 1)
> 
> I still don't see the advantage of using a nested attribute for
> this since we cannot have mutliple IMM keys at once.
>
> Or was that something that you were interested in?

I'm trying to visualize here how the code will look in the end.

I was thinking on simplifying the codebase one we get more immediates,
we will at least get one more to handle ct helper assignment.

So from the code we can just check:

        if (nla[NFTA_CT_IMM]) {
                err = nla_parse_nested(tb, NFTA_CT_IMM, nla, nft_ct_imm_policy);
                if (err < 0)
                        return err;

                switch (key) {
                case NFT_CT_LABEL:
                        if (!tb[NFTA_CT_IMM_LABEL])
                                return -EINVAL;

                        /* ... set internal structure value */
                        break:
                case NFT_CT_HELPER:
                        if (!tb[NFTA_CT_IMM_HELPER])
                                return -EINVAL;

                        /* ... set internal structure value */
                        break;
                }
        }

With a plain linear attribute representation, I think this would look like:

        if (tb[NFTA_CT_IMM_LABEL]) {
                /* ... */
        } else if (tb[NFTA_CT_IMM_HELPER]) {
                /* ... */
        }

BTW, probably we should consider using some generic way to represent
the immediates through enum nft_data_attributes. So we have core code
that that every expression can reuse to handle immediates.  I think
the concern here is data length validation, eg. labels are 4 bytes and
helpers are strings limited to 16 bytes. From the libnftnl side, so
far we represent these as _DATA attributes:

enum {
        NFTNL_EXPR_CMP_SREG     = NFTNL_EXPR_BASE,
        NFTNL_EXPR_CMP_OP,
        NFTNL_EXPR_CMP_DATA,
};

Otherwise, we'll start seeing code in every expression handling
immediates in their own way (ie. in a not consolidated way).
