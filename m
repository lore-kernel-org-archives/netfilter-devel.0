From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] bridge: netfilter: orphan skb before invoking ip
 netfilter hooks
Date: Thu, 24 Oct 2013 13:14:10 -0700
Message-ID: <1382645650.7572.68.camel@edumazet-glaptop.roam.corp.google.com>
References: <1382643162-20009-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:37820 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab3JXUOO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Oct 2013 16:14:14 -0400
Received: by mail-wi0-f178.google.com with SMTP id hn9so105286wib.5
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Oct 2013 13:14:13 -0700 (PDT)
In-Reply-To: <1382643162-20009-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2013-10-24 at 21:32 +0200, Florian Westphal wrote:
> Pekka Pietik=C3=A4inen reports xt_socket behavioural change after com=
mit

behavioral maybe ? ;)

> 00028aa37098o (netfilter: xt_socket: use IP early demux).
>=20
> Reason is xt_socket now no longer does an unconditional sk lookup -
> it re-uses existing skb->sk if possible, assuming ->sk was set by
> tcp early demux.

s/tcp/ip/ since it also can work for UDP sockets in net-next

>=20
> However, when netfilter is invoked via bridge, this can cause 'bogus'
> sockets to be examined by the match, e.g. a 'tun' device socket.
>=20
> bridge netfilter should orphan the skb just like the routing path
> before invoking ipv4/ipv6 netfilter hooks to avoid this.
>=20
> Reported-and-tested-by: Pekka Pietik=C3=A4inen <pp@ee.oulu.fi>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 878f008..80cad2c 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -559,6 +559,8 @@ static struct net_device *setup_pre_routing(struc=
t sk_buff *skb)
>  	else if (skb->protocol =3D=3D htons(ETH_P_PPP_SES))
>  		nf_bridge->mask |=3D BRNF_PPPoE;
> =20
> +	/* Must drop socket now because of tproxy. */
> +	skb_orphan(skb);
>  	return skb->dev;
>  }
> =20

This was a nice one, thanks Florian !

Acked-by: Eric Dumazet <edumazet@google.com>



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
