Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436E4C06510
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 15:29:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269A92146F
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 15:29:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfGAP3V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 11:29:21 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:38630 "EHLO
        kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729234AbfGAP3V (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 11:29:21 -0400
Received: from reginn.horms.nl (watermunt.horms.nl [80.127.179.77])
        by kirsty.vergenet.net (Postfix) with ESMTPA id 086C725B755;
        Tue,  2 Jul 2019 01:29:20 +1000 (AEST)
Received: by reginn.horms.nl (Postfix, from userid 7100)
        id 0F6DC94041B; Mon,  1 Jul 2019 17:29:17 +0200 (CEST)
Date:   Mon, 1 Jul 2019 17:29:17 +0200
From:   Simon Horman <horms@verge.net.au>
To:     Vadim Fedorenko <vfedorenko@yandex-team.ru>
Cc:     Julian Anastasov <ja@ssi.bg>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] ipvs: allow tunneling with gre encapsulation
Message-ID: <20190701152917.vdkzakj4vhvbl3lw@verge.net.au>
References: <1561933729-5333-1-git-send-email-vfedorenko@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1561933729-5333-1-git-send-email-vfedorenko@yandex-team.ru>
Organisation: Horms Solutions BV
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 01, 2019 at 01:28:49AM +0300, Vadim Fedorenko wrote:
> windows real servers can handle gre tunnels, this patch allows
> gre encapsulation with the tunneling method, thereby letting ipvs
> be load balancer for windows-based services
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>
> ---
>  include/uapi/linux/ip_vs.h      |  1 +
>  net/netfilter/ipvs/ip_vs_ctl.c  |  1 +
>  net/netfilter/ipvs/ip_vs_xmit.c | 76 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 78 insertions(+)
> 
> diff --git a/include/uapi/linux/ip_vs.h b/include/uapi/linux/ip_vs.h
> index e4f1806..4102ddc 100644
> --- a/include/uapi/linux/ip_vs.h
> +++ b/include/uapi/linux/ip_vs.h
> @@ -128,6 +128,7 @@
>  enum {
>  	IP_VS_CONN_F_TUNNEL_TYPE_IPIP = 0,	/* IPIP */
>  	IP_VS_CONN_F_TUNNEL_TYPE_GUE,		/* GUE */
> +	IP_VS_CONN_F_TUNNEL_TYPE_GRE,		/* GRE */
>  	IP_VS_CONN_F_TUNNEL_TYPE_MAX,
>  };
>  
> diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
> index 84384d8..998353b 100644
> --- a/net/netfilter/ipvs/ip_vs_ctl.c
> +++ b/net/netfilter/ipvs/ip_vs_ctl.c
> @@ -525,6 +525,7 @@ static void ip_vs_rs_hash(struct netns_ipvs *ipvs, struct ip_vs_dest *dest)
>  			port = dest->tun_port;
>  			break;
>  		case IP_VS_CONN_F_TUNNEL_TYPE_IPIP:
> +		case IP_VS_CONN_F_TUNNEL_TYPE_GRE:
>  			port = 0;
>  			break;
>  		default:
> diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
> index 71fc6d6..37cc674 100644
> --- a/net/netfilter/ipvs/ip_vs_xmit.c
> +++ b/net/netfilter/ipvs/ip_vs_xmit.c
> @@ -29,6 +29,7 @@
>  #include <linux/tcp.h>                  /* for tcphdr */
>  #include <net/ip.h>
>  #include <net/gue.h>
> +#include <net/gre.h>
>  #include <net/tcp.h>                    /* for csum_tcpudp_magic */
>  #include <net/udp.h>
>  #include <net/icmp.h>                   /* for icmp_send */
> @@ -389,6 +390,13 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>  			    skb->ip_summed == CHECKSUM_PARTIAL)
>  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
>  		}
> +		if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {

Hi Vadim,

The previous conditional also checks the value of dest->tun_type,
so I think that it would be nicer if this was changed to either else if or
to use a case statement. Likewise elsewhere in this patch.

> +			__be16 tflags = 0;
> +
> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +				tflags |= TUNNEL_CSUM;
> +			mtu -= gre_calc_hlen(tflags);
> +		}
>  		if (mtu < 68) {
>  			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
>  			goto err_put;

...
