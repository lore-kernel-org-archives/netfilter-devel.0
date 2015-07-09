From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_nat: Fix possible null dereference
Date: Fri, 10 Jul 2015 00:24:56 +0200
Message-ID: <20150709222456.GA4111@salvia>
References: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: subashab@codeaurora.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43058 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046AbbGIWTY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 18:19:24 -0400
Content-Disposition: inline
In-Reply-To: <fea9df65d6768053838fb1eca1846ef7.squirrel@www.codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jul 09, 2015 at 01:23:58AM -0000, subashab@codeaurora.org wrote:
> Fix an issue where __nf_ct_ext_find() could return null to nat in
> nf_nat_masquerade_ipv4() and could be dereferenced.
> 
> This was detected by static analysis software.
> 
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
> ---
>  net/ipv4/netfilter/nf_nat_masquerade_ipv4.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> index c6eb421..4be5d70 100644
> --- a/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> +++ b/net/ipv4/netfilter/nf_nat_masquerade_ipv4.c
> @@ -38,6 +38,8 @@ nf_nat_masquerade_ipv4(struct sk_buff *skb, unsigned int
> hooknum,
> 
>  	ct = nf_ct_get(skb, &ctinfo);
>  	nat = nfct_nat(ct);
> +	if (!nat)
> +		return NF_DROP;

This function is called from nf_nat_ipv4_fn(), see do_chain().

And we're accepting the packet with no NAT mangling if we fail to add
the extension:

        nat = nf_ct_nat_ext_add(ct);
        if (nat == NULL)
                return NF_ACCEPT;

Can you provide more information on what your static analysis software
reports? Thanks.
