From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: ipv6: nf_defrag: Always pass on
 packets to stack
Date: Fri, 12 Jan 2018 07:35:52 +0100
Message-ID: <20180112063552.GA27085@breakpoint.cc>
References: <1515737073-32344-1-git-send-email-subashab@codeaurora.org>
 <1515737073-32344-2-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60208 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751958AbeALGiQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 01:38:16 -0500
Content-Disposition: inline
In-Reply-To: <1515737073-32344-2-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
> diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
> index 977d890..a44c8b2 100644
> --- a/net/ipv6/netfilter/nf_conntrack_reasm.c
> +++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
> @@ -574,17 +574,26 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
>  	struct ipv6hdr *hdr;
>  	u8 prevhdr;
>  
> +	skb = skb_clone(skb, GFP_ATOMIC);
> +	if (!skb)
> +		return -ENOMEM;
> +
>  	/* Jumbo payload inhibits frag. header */
>  	if (ipv6_hdr(skb)->payload_len == 0) {
>  		pr_debug("payload len = 0\n");
> +		kfree(skb);

kfree_skb ?
