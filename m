From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: icmp: Enhance the return value check of
 nf_nat_icmp(v6)_reply_translation
Date: Sat, 19 Sep 2015 19:36:08 +0200
Message-ID: <20150919173608.GA3472@salvia>
References: <BAY403-EAS201184FFD171DD8A4B68C5E95580@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39378 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755200AbbISR33 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Sep 2015 13:29:29 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS201184FFD171DD8A4B68C5E95580@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Sep 19, 2015 at 10:59:19PM +0800, Feng Gao wrote:
> It could enhance the codes readability and save one extra instruction than
> before

Gao, I'm still having patch mangling problems, most likely your MUA.
See below.

Note that patchwork doesn't catch up this either:

http://patchwork.ozlabs.org/project/netfilter-devel/list/

> Signed-off-by: Feng Gao <gfree.wind@gmail.com>
> 
> ---
> 
> net/ipv4/netfilter/nf_nat_l3proto_ipv4.c |    6 +++---
> 
> net/ipv6/netfilter/nf_nat_l3proto_ipv6.c |    6 +++---
> 
> 2 files changed, 6 insertions(+), 6 deletions(-)
> 
>  
> 
> diff --git a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> 
> index 22f4579..f5c0754 100644
> 
> --- a/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> 
> +++ b/net/ipv4/netfilter/nf_nat_l3proto_ipv4.c
> 
> @@ -294,11 +294,11 @@ nf_nat_ipv4_fn(const struct nf_hook_ops *ops, struct
> sk_buff *skb,
> 
>        case IP_CT_RELATED:
> 
>        case IP_CT_RELATED_REPLY:
> 
>                 if (ip_hdr(skb)->protocol == IPPROTO_ICMP) {
> 
> -                           if (!nf_nat_icmp_reply_translation(skb, ct,
> ctinfo,
> 
> +                          if (nf_nat_icmp_reply_translation(skb, ct,
> ctinfo,
> 
>  
> ops->hooknum))
> 
> -                                    return NF_DROP;
> 
> -                           else
> 
>                                    return NF_ACCEPT;
> 
> +                          else
> 
> +                                   return NF_DROP;
> 
>                 }
> 
>                 /* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
> 
>        case IP_CT_NEW:
> 
> diff --git a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> 
> index 70fbaed..40c0a49 100644
> 
> --- a/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> 
> +++ b/net/ipv6/netfilter/nf_nat_l3proto_ipv6.c
> 
> @@ -302,12 +302,12 @@ nf_nat_ipv6_fn(const struct nf_hook_ops *ops, struct
> sk_buff *skb,
> 
>                                               &nexthdr, &frag_off);
> 
>                  if (hdrlen >= 0 && nexthdr == IPPROTO_ICMPV6) {
> 
> -                           if (!nf_nat_icmpv6_reply_translation(skb, ct,
> ctinfo,
> 
> +                          if (nf_nat_icmpv6_reply_translation(skb, ct,
> ctinfo,
> 
>  
> ops->hooknum,
> 
>                                                                     hdrlen))
> 
> -                                    return NF_DROP;
> 
> -                           else
> 
>                                    return NF_ACCEPT;
> 
> +                          else
> 
> +                                   return NF_DROP;
> 
>                 }
> 
>                 /* Fall thru... (Only ICMPs can be IP_CT_IS_REPLY) */
> 
>        case IP_CT_NEW:
> 
