From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 1/6] netfilter: nf_tables: extend tracing
 infrastructure
Date: Wed, 25 Nov 2015 09:39:07 +0100
Message-ID: <20151125083907.GF23215@breakpoint.cc>
References: <1448359331-12692-1-git-send-email-fw@strlen.de>
 <1448359331-12692-2-git-send-email-fw@strlen.de>
 <20151125005523.GB27315@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60958 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753390AbbKYIjK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 03:39:10 -0500
Content-Disposition: inline
In-Reply-To: <20151125005523.GB27315@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> > diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
> > index d8c8a7c..88bcd00 100644
> > --- a/include/uapi/linux/netfilter/nf_tables.h
> > +++ b/include/uapi/linux/netfilter/nf_tables.h
> > @@ -970,4 +972,34 @@ enum nft_gen_attributes {
> >  };
> >  #define NFTA_GEN_MAX		(__NFTA_GEN_MAX - 1)
> >  
> > +enum nft_trace_attibutes {
> > +	NFTA_TRACE_UNSPEC,
> > +	NFTA_TRACE_CHAIN,
> > +	NFTA_TRACE_DEV_TYPE,
> > +	NFTA_TRACE_ID,
> > +	NFTA_TRACE_IIF,
> > +	NFTA_TRACE_OIF,
> > +	NFTA_TRACE_LL_HEADER,
> > +	NFTA_TRACE_MARK,
> > +	NFTA_TRACE_NETWORK_HEADER,
> > +	NFTA_TRACE_TABLE,
> > +	NFTA_TRACE_TRANSPORT_HEADER,
> > +	NFTA_TRACE_TRANSPORT_PROTO,
> > +	NFTA_TRACE_TYPE,
> > +	NFTA_TRACE_RULE_HANDLE,
> > +	NFTA_TRACE_VERDICT,
> > +	NFTA_TRACE_VLAN_TAG,
> > +	__NFTA_TRACE_MAX
> > +};
> > +#define NFTA_TRACE_MAX (__NFTA_TRACE_MAX - 1)
> 
> The ordering appears to be a bit random (or I'm missing something), I'd
> expect basic information like TABLE/CHAIN/RULE_HANDLE to be at the beginning
> (in that order), similar for TYPE, VERDICT etc.

NFTA_TRACE_UNSPEC,
NFTA_TRACE_TABLE,
NFTA_TRACE_CHAIN,
NFTA_TRACE_RULE_HANDLE,
NFTA_TRACE_TYPE,
NFTA_TRACE_VERDICT,
NFTA_TRACE_DEV_TYPE,
NFTA_TRACE_ID,
NFTA_TRACE_LL_HEADER,
NFTA_TRACE_NETWORK_HEADER,
NFTA_TRACE_TRANSPORT_HEADER,
NFTA_TRACE_TRANSPORT_PROTO,
NFTA_TRACE_IIF,
NFTA_TRACE_OIF,
NFTA_TRACE_MARK,
NFTA_TRACE_VLAN_TAG,

better?  If not, please just tell me what ordering you'd prefer and
thats what I'll use.

> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 93cc473..25d8168 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -21,6 +23,10 @@
> >  #include <net/net_namespace.h>
> >  #include <net/sock.h>
> >  
> > +#define NFT_TRACETYPE_LL_HSIZE		20
> > +#define NFT_TRACETYPE_NETWORK_HSIZE	32
> > +#define NFT_TRACETYPE_TRANSPORT_HSIZE	 4
> 
> 4 seems to be too small for some header types like GRE. If the key is present
> it seems like information we'd want to log.
> 
> Also since people probably want to use this to determine why or why not rules
> match, I think it would be good to have the entire transport header present.
> 
> > +static bool
> > +trace_notify_put_packet(struct sk_buff *nlskb, const struct nft_pktinfo *pkt)
> > +{
> > +	const struct sk_buff *skb = pkt->skb;
> > +	unsigned int plen = min_t(unsigned int,
> > +				  pkt->xt.thoff - skb_network_offset(skb),
> > +				  NFT_TRACETYPE_NETWORK_HSIZE);
> > +	int mac_off;
> > +
> > +	if (plen >= 20u && /* minimum iphdr size */
> > +	    !trace_notify_put_data(nlskb, NFTA_TRACE_NETWORK_HEADER,
> > +				   skb, skb_network_offset(skb), plen))
> > +		return false;
> 
> Does that check for 20u have any deeper meaning? It seems this will always
> be true for all currently supported protocols and if we were to add support
> for one that has a smaller size it won't work.

OK, I'll change all checks to 'len &&'.

> > +     if (nla_put_be32(skb, NFTA_TRACE_ID, htonl(hash32_ptr(pkt->skb)))) 

> This could lead to duplicate IDs quite quickly. I can't think of any other
> values where we know for sure they will stay constant while the skb is within
> netfilter. How about combining this with a per CPU counter or something
> similar?

I would not mind, it would result in ID change though for nfqueue case.
If thats ok I'll use a pcpu counter that gets incremented when nft_meta
sets skb->nftrace=1 and use __this_cpu_read(trace_id) instead (if we
have pcpu id counter, is there any point in also using skb address...?)

> > +	if (chain) {
> > +		if (nla_put_string(skb, NFTA_TRACE_TABLE, chain->table->name))
> > +			goto nla_put_failure;
> > +		if (nla_put_string(skb, NFTA_TRACE_CHAIN, chain->name))
> > +			goto nla_put_failure;
> > +	}
> > +
> > +	if (rule && nla_put_be64(skb, NFTA_TRACE_RULE_HANDLE,
> > +				 cpu_to_be64(rule->handle)))
> 
> Minor nitpick: below you use
> 
> 	if (condition &&
> 	    nla_put_...
> 
> which I think is more readable.

ok.  I only used the former if line would go over 80, but i can convert
this too of course.

> > +	if (pkt->in &&
> > +	    nla_put_be32(skb, NFTA_TRACE_IIF, htonl(pkt->in->ifindex)))
> > +		goto nla_put_failure;
> > +	if (pkt->out &&
> > +	    nla_put_be32(skb, NFTA_TRACE_OIF, htonl(pkt->out->ifindex)))
> > +		goto nla_put_failure;
> > +	if (pkt->skb->mark &&
> > +	    nla_put_be32(skb, NFTA_TRACE_MARK, htonl(pkt->skb->mark)))
> > +		goto nla_put_failure;
> > +
> > +	switch (type) {
> > +	case NFT_TRACETYPE_POLICY:
> > +	case NFT_TRACETYPE_RETURN:
> > +	case NFT_TRACETYPE_RULE:
> > +		if (nla_put_be32(skb, NFTA_TRACE_VERDICT, htonl(verdict)))
> > +			goto nla_put_failure;
> 
> It would be nice to have the full verdict available, IOW also the jump target.
> 
> You could simply pass struct nft_verdict to this function and adapt
> nft_verdict_dump() to take the attribute value as parameter.

Will add NFTA_TRACE_JUMP/NFTA_TRACE_GOTO for that, ok?
