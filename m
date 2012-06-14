From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] netfilter: xt_TEE:  IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 19:52:23 +0200
Message-ID: <20120614175223.GA10633@1984>
References: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Hans Schillstrom <hans@schillstrom.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33021 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752154Ab2FNRw2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:52:28 -0400
Content-Disposition: inline
In-Reply-To: <rvd97lb.cb16bfe930b2100854041c0a3d714500@obelix.schillstrom.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 14, 2012 at 08:17:35AM +0200, Hans Schillstrom wrote:
> Hello,
> 
> I  think it is wrong to always force the DF bit in IPv4, it's better
> to have an option If an application don't set the DF bit, usually it
> doesn't expect to get an icmp back either.  The result is that the
> packet will be dropped...
> 
> To retain backwards compatibility I suggest adding a new option like
> 
> --ipv4-df-copy  Do not force "Don't Fragment" on the copied packet
> just copy the bit.
> 
> In IPv6 we don't have that option, so nothing has to be done there.
> 
> 
> diff --git a/include/linux/netfilter/xt_TEE.h b/include/linux/netfilter/xt_TEE.h
> index 5c21d5c..e5fca8a 100644
> --- a/include/linux/netfilter/xt_TEE.h
> +++ b/include/linux/netfilter/xt_TEE.h
> @@ -4,6 +4,7 @@
>  struct xt_tee_tginfo {
>         union nf_inet_addr gw;
>         char oif[16];
> +       int df_copy;

This breaks backward compatibility. If you some new field, you usually
have to add a new target revision.

Moreover, something like "flags" would be better, in case we need to add
anything else in the future without modifying the binary layout of the
target info.

>         /* used internally by the kernel */
>         struct xt_tee_priv *priv __attribute__((aligned(8)));
> diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
> index ee2e5bc..e9a1ca7 100644
> --- a/net/netfilter/xt_TEE.c
> +++ b/net/netfilter/xt_TEE.c
> @@ -117,7 +117,8 @@ tee_tg4(struct sk_buff *skb, const struct xt_action_param *par)
>          * decreased MTU on the clone route. IPv6 does this too.
>          */
>         iph = ip_hdr(skb);
> -       iph->frag_off |= htons(IP_DF);
> +       if (!info->df_copy)
> +               iph->frag_off |= htons(IP_DF);
>         if (par->hooknum == NF_INET_PRE_ROUTING ||
>             par->hooknum == NF_INET_LOCAL_IN)
>                 --iph->ttl;
> 
> 
> --
> Regards 
> Hans Schillstrom
> +46 70 699 7150
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
