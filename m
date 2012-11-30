From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] Handle routing changes for the MASQUERADE target
Date: Fri, 30 Nov 2012 22:11:47 +0100
Message-ID: <20121130211147.GD31969@breakpoint.cc>
References: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:35536 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031669Ab2K3VLs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Nov 2012 16:11:48 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211302149050.16257@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:

Hi Jozsef,

> index bd8eea7..fc8f1b8 100644
> --- a/include/net/netfilter/nf_nat.h
> +++ b/include/net/netfilter/nf_nat.h
> @@ -68,4 +68,22 @@ static inline struct nf_conn_nat *nfct_nat(const struct nf_conn *ct)
>  
> +static inline bool nf_nat_oif_changed(const struct sk_buff *skb,
> +				      unsigned int hooknum,
[..]
> +{

If you put the #if IS_ENABLED here, it would no longer be necessary
in the .c files.  nf_nat_oif_changed() would always return false
in the 'no MASQERADE' case.

> +	if (nat->masq_index && hooknum == NF_INET_POST_ROUTING &&
> +	    CTINFO2DIR(ctinfo) == IP_CT_DIR_ORIGINAL &&
> +	    nat->masq_index != out->ifindex) {
> +		/* Outgoing interface changed, destroy conntrack. */
> +		nf_ct_kill_acct(cf, ctinfo, skb);
> +		nf_ct_put(ct);

Hmm. Is the nf_ct_put() correct?
nf_ct_kill invokes death_by_timeout(), which also puts ct.

> diff --git a/net/ipv4/netfilter/iptable_nat.c b/net/ipv4/netfilter/iptable_nat.c
> index ac635a7..4ed34ab 100644
> --- a/net/ipv4/netfilter/iptable_nat.c
> +++ b/net/ipv4/netfilter/iptable_nat.c
> @@ -134,6 +134,10 @@ nf_nat_ipv4_fn(unsigned int hooknum,
>  		/* ESTABLISHED */
>  		NF_CT_ASSERT(ctinfo == IP_CT_ESTABLISHED ||
>  			     ctinfo == IP_CT_ESTABLISHED_REPLY);
> +#if IS_ENABLED(CONFIG_IP_NF_TARGET_MASQUERADE)
> +		if (nf_nat_oif_changed(skb, hooknum, ct, ctinfo, nat, out))
> +			return NF_DROP;
> +#endif
>  	}

I wonder if this:

	if (nf_nat_oif_changed(skb, hooknum, ctinfo, nat, out)) {
		nf_ct_kill_acct(ct, ctinfo, skb);
		return NF_DROP;
	}

Would be clearer (the name 'nf_nat_oif_changed' sounds like it only
performs a test).

Cheers,
Florian
