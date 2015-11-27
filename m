From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next 2/3] netfilter: nf_tables: extend tracing
 infrastructure
Date: Fri, 27 Nov 2015 10:23:10 +0100
Message-ID: <20151127092310.GA15392@breakpoint.cc>
References: <1448560779-28989-1-git-send-email-fw@strlen.de>
 <1448560779-28989-3-git-send-email-fw@strlen.de>
 <20151127084718.GD4263@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38555 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752393AbbK0JXM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 04:23:12 -0500
Content-Disposition: inline
In-Reply-To: <20151127084718.GD4263@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 26.11, Florian Westphal wrote:
> > +++ b/net/netfilter/nf_tables_trace.c
> > @@ -0,0 +1,253 @@
> > +static int trace_fill_header(struct sk_buff *nlskb, u16 type,
> > +			     const struct sk_buff *skb,
> > +			     int off, unsigned int len)
> > +{
> > +	struct nlattr *nla;
> > +
> > +	if (len == 0)
> > +		return 0;
> > +
> > +	if (skb_tailroom(nlskb) < nla_total_size(len))
> > +		return -1;
> > +
> > +	nla = (struct nlattr *)skb_put(nlskb, nla_total_size(len));
> > +	nla->nla_type = type;
> > +	nla->nla_len = nla_attr_size(len);
> 
> nla_reserve()? That will also take care of zeroing the padding.

Fixed, thanks.

> > +static int nf_trace_fill_ll_header(struct sk_buff *nlskb,
> > +				   const struct sk_buff *skb)
> > +{
> > +	struct vlan_ethhdr veth;
> > +	unsigned int len, off;
> > +
> > +	off = skb_mac_header(skb) - skb->data;
> 
> off is negative or zero, it should use a signed int I think.

Right, fixed.

> > +
> > +	if (skb_copy_bits(skb, off, &veth, ETH_HLEN))
> > +		return -1;
> > +
> > +	veth.h_vlan_proto = skb->vlan_proto;
> > +	veth.h_vlan_TCI = htons(skb_vlan_tag_get(skb));
> > +	veth.h_vlan_encapsulated_proto = skb->protocol;
> > +
> > +	len = min_t(unsigned int,
> > +		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
> 
> min_t(unsigned int, -off, NFT_TRACETYPE_LL_HSIZE) ?

[..]

> Why the min_t at all if we fail on != ETH_HLEN? I'd simply check that
> it is exactly ETH_HLEN before even starting copying.

Good point, I removed min test completely and changed it to:

    int off;

    BUILD_BUG_ON(NFT_TRACETYPE_LL_HSIZE < ETH_HLEN);

    off = skb_mac_header(skb) - skb->data;
    if (len != -ETH_HLEN)
            return -1;
    ...
> > +
> > +	len = sizeof(veth);
> > +	if (skb_tailroom(nlskb) < nla_total_size(len))
> > +		return -1;
> > +
> > +	return nla_put(nlskb, NFTA_TRACE_LL_HEADER, len, &veth);
> 
> nla_put() already checks the tailroom.

Right, my bad.  Removed.

> > +	len = min_t(unsigned int,
> > +		    skb->data - skb_mac_header(skb), NFT_TRACETYPE_LL_HSIZE);
> > +	off = skb_mac_header(skb) - skb->data;
> 
> Could again avoid the double calculation by using -off in min_t().

Fixed.

> > +static int nf_trace_fill_chain_info(struct sk_buff *nlskb,
> > +				    const struct nft_chain *chain)
> > +{
> > +	if (nla_put_string(nlskb, NFTA_TRACE_TABLE, chain->table->name))
> > +		return -1;
> > +
> > +	return nla_put_string(nlskb, NFTA_TRACE_CHAIN, chain->name);
> 
> I would not move simple stuff that is only used once like this to another
> function. Easier to read if you don't have to jump around in the code.

Ok, open-coded this instead.

Thanks for the review, I'll send a v3 soon.
