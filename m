Return-Path: <SRS0=danl=U6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D7DC0650E
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:03:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6207F205F4
	for <netfilter-devel@archiver.kernel.org>; Mon,  1 Jul 2019 19:03:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbfGATDZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 1 Jul 2019 15:03:25 -0400
Received: from ja.ssi.bg ([178.16.129.10]:36568 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726076AbfGATDZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 1 Jul 2019 15:03:25 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x61J3D2O004532;
        Mon, 1 Jul 2019 22:03:13 +0300
Date:   Mon, 1 Jul 2019 22:03:13 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Vadim Fedorenko <vfedorenko@yandex-team.ru>
cc:     Simon Horman <horms@verge.net.au>,
        Konstantin Khlebnikov <khlebnikov@yandex-team.ru>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, lvs-devel@vger.kernel.org
Subject: Re: [PATCH v3] ipvs: allow tunneling with gre encapsulation
In-Reply-To: <1561999774-8125-1-git-send-email-vfedorenko@yandex-team.ru>
Message-ID: <alpine.LFD.2.21.1907012200110.3870@ja.home.ssi.bg>
References: <1561999774-8125-1-git-send-email-vfedorenko@yandex-team.ru>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


	Hello,

	Added CC to lvs-devel@vger.kernel.org

On Mon, 1 Jul 2019, Vadim Fedorenko wrote:

> windows real servers can handle gre tunnels, this patch allows
> gre encapsulation with the tunneling method, thereby letting ipvs
> be load balancer for windows-based services
> 
> Signed-off-by: Vadim Fedorenko <vfedorenko@yandex-team.ru>

	Looks good to me, thanks!

Acked-by: Julian Anastasov <ja@ssi.bg>

> ---
> v2: style fix
> v3: change dest->tun_type checks to else if statement
> ---
>  include/uapi/linux/ip_vs.h      |  1 +
>  net/netfilter/ipvs/ip_vs_ctl.c  |  1 +
>  net/netfilter/ipvs/ip_vs_xmit.c | 66 +++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 65 insertions(+), 3 deletions(-)
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
> index 71fc6d6..9c464d2 100644
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
> @@ -388,6 +389,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>  			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
>  			    skb->ip_summed == CHECKSUM_PARTIAL)
>  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
> +		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +			__be16 tflags = 0;
> +
> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +				tflags |= TUNNEL_CSUM;
> +			mtu -= gre_calc_hlen(tflags);
>  		}
>  		if (mtu < 68) {
>  			IP_VS_DBG_RL("%s(): mtu less than 68\n", __func__);
> @@ -548,6 +555,12 @@ static inline bool decrement_ttl(struct netns_ipvs *ipvs,
>  			     IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM) &&
>  			    skb->ip_summed == CHECKSUM_PARTIAL)
>  				mtu -= GUE_PLEN_REMCSUM + GUE_LEN_PRIV;
> +		} else if (dest->tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +			__be16 tflags = 0;
> +
> +			if (dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +				tflags |= TUNNEL_CSUM;
> +			mtu -= gre_calc_hlen(tflags);
>  		}
>  		if (mtu < IPV6_MIN_MTU) {
>  			IP_VS_DBG_RL("%s(): mtu less than %d\n", __func__,
> @@ -1079,6 +1092,24 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  	return 0;
>  }
>  
> +static void
> +ipvs_gre_encap(struct net *net, struct sk_buff *skb,
> +	       struct ip_vs_conn *cp, __u8 *next_protocol)
> +{
> +	__be16 proto = *next_protocol == IPPROTO_IPIP ?
> +				htons(ETH_P_IP) : htons(ETH_P_IPV6);
> +	__be16 tflags = 0;
> +	size_t hdrlen;
> +
> +	if (cp->dest->tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +		tflags |= TUNNEL_CSUM;
> +
> +	hdrlen = gre_calc_hlen(tflags);
> +	gre_build_header(skb, hdrlen, tflags, proto, 0, 0);
> +
> +	*next_protocol = IPPROTO_GRE;
> +}
> +
>  /*
>   *   IP Tunneling transmitter
>   *
> @@ -1151,6 +1182,15 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
>  
>  		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		size_t gre_hdrlen;
> +		__be16 tflags = 0;
> +
> +		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +			tflags |= TUNNEL_CSUM;
> +		gre_hdrlen = gre_calc_hlen(tflags);
> +
> +		max_headroom += gre_hdrlen;
>  	}
>  
>  	/* We only care about the df field if sysctl_pmtu_disc(ipvs) is set */
> @@ -1172,6 +1212,11 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  		    skb->ip_summed == CHECKSUM_PARTIAL) {
>  			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
>  		}
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +			gso_type |= SKB_GSO_GRE_CSUM;
> +		else
> +			gso_type |= SKB_GSO_GRE;
>  	}
>  
>  	if (iptunnel_handle_offloads(skb, gso_type))
> @@ -1192,8 +1237,8 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  			check = true;
>  
>  		udp_set_csum(!check, skb, saddr, cp->daddr.ip, skb->len);
> -	}
> -
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
> +		ipvs_gre_encap(net, skb, cp, &next_protocol);
>  
>  	skb_push(skb, sizeof(struct iphdr));
>  	skb_reset_network_header(skb);
> @@ -1287,6 +1332,15 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  		gue_hdrlen = sizeof(struct guehdr) + gue_optlen;
>  
>  		max_headroom += sizeof(struct udphdr) + gue_hdrlen;
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		size_t gre_hdrlen;
> +		__be16 tflags = 0;
> +
> +		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +			tflags |= TUNNEL_CSUM;
> +		gre_hdrlen = gre_calc_hlen(tflags);
> +
> +		max_headroom += gre_hdrlen;
>  	}
>  
>  	skb = ip_vs_prepare_tunneled_skb(skb, cp->af, max_headroom,
> @@ -1306,6 +1360,11 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  		    skb->ip_summed == CHECKSUM_PARTIAL) {
>  			gso_type |= SKB_GSO_TUNNEL_REMCSUM;
>  		}
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE) {
> +		if (tun_flags & IP_VS_TUNNEL_ENCAP_FLAG_CSUM)
> +			gso_type |= SKB_GSO_GRE_CSUM;
> +		else
> +			gso_type |= SKB_GSO_GRE;
>  	}
>  
>  	if (iptunnel_handle_offloads(skb, gso_type))
> @@ -1326,7 +1385,8 @@ static inline int __tun_gso_type_mask(int encaps_af, int orig_af)
>  			check = true;
>  
>  		udp6_set_csum(!check, skb, &saddr, &cp->daddr.in6, skb->len);
> -	}
> +	} else if (tun_type == IP_VS_CONN_F_TUNNEL_TYPE_GRE)
> +		ipvs_gre_encap(net, skb, cp, &next_protocol);
>  
>  	skb_push(skb, sizeof(struct ipv6hdr));
>  	skb_reset_network_header(skb);
> -- 
> 1.9.1

Regards

--
Julian Anastasov <ja@ssi.bg>
