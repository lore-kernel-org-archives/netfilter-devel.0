From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] netfilter: nf_tables: add pkttype support to meta
 expression
Date: Fri, 27 Jun 2014 13:09:03 +0200
Message-ID: <20140627110903.GA6412@localhost>
References: <1402643720-6915-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52265 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaF0LJK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:09:10 -0400
Content-Disposition: inline
In-Reply-To: <1402643720-6915-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jun 13, 2014 at 09:15:20AM +0200, Ana Rey wrote:
> Joint work with =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
> [Changes in v2:]
> Put "case NFT_META_PKTTYPE:" outside of the #ifdef CONFIG_NETWORK_SEC=
MARK.
> It was a mistake.
> Thanks to Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> for
> reporting this mistake.
>=20
>=20
>  include/uapi/linux/netfilter/nf_tables.h |  2 ++
>  net/netfilter/nft_meta.c                 | 17 +++++++++++++++++
>  2 files changed, 19 insertions(+)
>=20
> diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/=
linux/netfilter/nf_tables.h
> index 2a88f64..9eb5153 100644
> --- a/include/uapi/linux/netfilter/nf_tables.h
> +++ b/include/uapi/linux/netfilter/nf_tables.h
> @@ -571,6 +571,7 @@ enum nft_exthdr_attributes {
>   * @NFT_META_L4PROTO: layer 4 protocol number
>   * @NFT_META_BRI_IIFNAME: packet input bridge interface name
>   * @NFT_META_BRI_OIFNAME: packet output bridge interface name
> + * @NFT_META_PKTTYPE: Packet class
                                ^^^^^
type?

>   */
>  enum nft_meta_keys {
>  	NFT_META_LEN,
> @@ -592,6 +593,7 @@ enum nft_meta_keys {
>  	NFT_META_L4PROTO,
>  	NFT_META_BRI_IIFNAME,
>  	NFT_META_BRI_OIFNAME,
> +	NFT_META_PKTTYPE,
>  };
> =20
>  /**
> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 852b178..eb9882e 100644
> --- a/net/netfilter/nft_meta.c
> +++ b/net/netfilter/nft_meta.c
> @@ -14,6 +14,9 @@
>  #include <linux/netlink.h>
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
> +#include <linux/in.h>
> +#include <linux/ip.h>
> +#include <linux/ipv6.h>
>  #include <net/dst.h>
>  #include <net/sock.h>
>  #include <net/tcp_states.h> /* for TCP_TIME_WAIT */
> @@ -124,6 +127,19 @@ void nft_meta_get_eval(const struct nft_expr *ex=
pr,
>  		dest->data[0] =3D skb->secmark;
>  		break;
>  #endif
> +	case NFT_META_PKTTYPE:
> +		dest->data[0] =3D skb->pkt_type;
> +		if (skb->pkt_type !=3D PACKET_LOOPBACK)
> +			dest->data[0] =3D skb->pkt_type;
> +		else if (expr->ops->type->family =3D=3D NFPROTO_IPV4 &&
                         ^----------------------^

This has problems with NFPROTO_INET, NFPROTO_BRIDGE and NFPROTO_ARP
when handling the loopback case.

You have to add a nft_meta per family, something similar to:

05513e9 netfilter: nf_tables: add reject module for NFPROTO_INET

In NFPROTO_INET, you have to use:

        if (pkt->ops->pf =3D=3D NF_PROTO_IPV4)
                ...

In NFPROTO_BRIDGE, you have to use:

        if (eth_hdr(skb)->h_proto =3D=3D htons(ETH_P_IP)
                ...

In NFPROTO_ARP, you have to check the destination address:

        if (is_broadcast_ether_addr(ethhdr->h_dest)
                ...

> +			 ipv4_is_multicast(ip_hdr(skb)->daddr))
> +			dest->data[0] =3D PACKET_MULTICAST;
> +		else if (expr->ops->type->family =3D=3D NFPROTO_IPV6 &&
> +			 ipv6_hdr(skb)->daddr.s6_addr[0] =3D=3D 0xFF)
> +			dest->data[0] =3D PACKET_MULTICAST;
> +		else
> +			dest->data[0] =3D PACKET_BROADCAST;
> +		break;
>  	default:
>  		WARN_ON(1);
>  		goto err;
> @@ -195,6 +211,7 @@ int nft_meta_get_init(const struct nft_ctx *ctx,
>  #ifdef CONFIG_NETWORK_SECMARK
>  	case NFT_META_SECMARK:
>  #endif
> +	case NFT_META_PKTTYPE:
>  		break;
>  	default:
>  		return -EOPNOTSUPP;
> --=20
> 2.0.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
