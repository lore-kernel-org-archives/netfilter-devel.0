From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: nat: remove incorrect debug assert
Date: Tue, 21 Feb 2017 15:09:09 +0100
Message-ID: <20170221140909.GA3286@salvia>
References: <20170208221429.3555-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59352 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752574AbdBUOJP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Feb 2017 09:09:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AEA9F1DA093
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 15:09:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FAB6DA816
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 15:09:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AC42DA816
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Feb 2017 15:09:10 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170208221429.3555-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 08, 2017 at 11:14:29PM +0100, Florian Westphal wrote:
> The comment is incorrect, this function does see fragments when
> IP_NODEFRAG is used.  Remove the wrong assertion.
> 
> As conntrack doesn't track fragments skb->nfct will be null
> and no nat is performed.

With IP_NODEFRAG, ipv4_conntrack_defrag() will just accept the packet.

So the first fragment will get into nf_conntrack_in(), and I think, if
enough information is there in place, it will get a ct object. Follow
up fragments with offset != 0 which doesn't contain headers will
definitely not get a ct object.

Shouldn't handle case this by attaching a template conntrack?
Currently this IP_NODEFRAG case is going through as invalid traffic.

My impression is that we're handling this case in a sloppy way, am I
missing anything?

> Reported-by: Andrey Konovalov <andreyknvl@google.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/netfilter/nf_nat_l3proto_ipv4.c | 5 -----
>  1 file changed, 5 deletions(-)
> 
> diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> index f8aad03d674b..6f5e8d01b876 100644
> --- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> +++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> @@ -255,11 +255,6 @@ nf_nat_ipv4_fn(void *priv, struct sk_buff *skb,
>  	/* maniptype == SRC for postrouting. */
>  	enum nf_nat_manip_type maniptype = HOOK2MANIP(state->hook);
>  
> -	/* We never see fragments: conntrack defrags on pre-routing
> -	 * and local-out, and nf_nat_out protects post-routing.
> -	 */
> -	NF_CT_ASSERT(!ip_is_fragment(ip_hdr(skb)));
> -
>  	ct = nf_ct_get(skb, &ctinfo);
>  	/* Can't track?  It's not due to stress, or conntrack would
>  	 * have dropped it.  Hence it's the user's responsibilty to
> -- 
> 2.10.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
