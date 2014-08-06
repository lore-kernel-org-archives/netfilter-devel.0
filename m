From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] netfilter: nf_tables: add pkttype support to meta
 expression
Date: Wed, 6 Aug 2014 10:52:33 +0200
Message-ID: <20140806085233.GA4765@salvia>
References: <1402643720-6915-1-git-send-email-anarey@gmail.com>
 <1407263242-4282-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org,
	=?iso-8859-1?Q?=C1lvaro?= Neira Ayuso <alvaroneay@gmail.com>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52665 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaHFIwM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 6 Aug 2014 04:52:12 -0400
Content-Disposition: inline
In-Reply-To: <1407263242-4282-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 05, 2014 at 08:27:22PM +0200, Ana Rey wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> Add pkttype support for all families of tables.

Please, include in the description something like:

This allows you to fetch the meta packet type based on the link layer
information. The loopback traffic is a special case, the packet type
is guessed from the network layer header.

No special handling for bridge and arp since we're not going to see
such traffic in the loopback interface.

> diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
> index 852b178..c46d9ac 100644
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
> @@ -124,6 +127,36 @@ void nft_meta_get_eval(const struct nft_expr *ex=
pr,
>  		dest->data[0] =3D skb->secmark;
>  		break;
>  #endif
> +	case NFT_META_PKTTYPE:
> +		if (skb->pkt_type !=3D PACKET_LOOPBACK) {
> +			dest->data[0] =3D skb->pkt_type;
> +			break;
> +		}
> +
> +		switch (pkt->ops->pf) {
> +		case NFPROTO_IPV4:
> +			if (ipv4_is_multicast(ip_hdr(skb)->daddr))
> +				dest->data[0] =3D PACKET_MULTICAST;
> +			else
> +				dest->data[0] =3D PACKET_HOST;

Please, replace the PACKET_HOST by PACKET_BROADCAST so this looks
exactly like xt_pkttype.

> +			break;
> +		case NFPROTO_IPV6:
> +			if (ipv6_hdr(skb)->daddr.s6_addr[0] =3D=3D 0xFF)
> +				dest->data[0] =3D PACKET_MULTICAST;
> +			else
> +				dest->data[0] =3D PACKET_HOST;
> +			break;
> +		case NFPROTO_INET:
> +			if (ipv6_hdr(skb)->daddr.s6_addr[0] =3D=3D 0xFF ||
> +			    ipv4_is_multicast(ip_hdr(skb)->daddr))
> +				dest->data[0] =3D PACKET_MULTICAST;
> +			else
> +				dest->data[0] =3D PACKET_HOST;
> +			break;

We're almost there. You have to remove NFPROTO_INET, the pkt->ops->pf
is already allowing you to indentify the family. So the NFPROTO_INET
part seems dead code to me, remove it.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
