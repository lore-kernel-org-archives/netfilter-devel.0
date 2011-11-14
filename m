From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] possible unaligned packet header caused by
 ip_route_me_harder()->pskb_expand_head()
Date: Mon, 14 Nov 2011 10:46:40 +0100
Message-ID: <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4EB9449D.8020701@tilera.com>
	 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EBA48F3.8040906@tilera.com>
	 <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EBB7E3C.9030402@tilera.com> <20111113170233.GA16851@1984>
	 <4EC0D254.7060503@tilera.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Paul Guo <ggang@tilera.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41971 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab1KNJqp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Nov 2011 04:46:45 -0500
Received: by fagn18 with SMTP id n18so2817929fag.19
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2011 01:46:43 -0800 (PST)
In-Reply-To: <4EC0D254.7060503@tilera.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 14 novembre 2011 =C3=A0 16:33 +0800, Paul Guo a =C3=A9crit :
> > git://1984.lsi.us.es/net/.git
>=20
> OK. Here is the patch based on above git tree.
>=20
>=20
> Signed-off-by: Paul Guo <ggang@tilera.com>
> ---
>  net/ipv4/netfilter.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>=20
> diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
> index 929b27b..0dcb0fa 100644
> --- a/net/ipv4/netfilter.c
> +++ b/net/ipv4/netfilter.c
> @@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsigne=
d addr_type)
>  	/* Change in oif may mean change in hh_len. */
>  	hh_len =3D skb_dst(skb)->dev->hard_header_len;
>  	if (skb_headroom(skb) < hh_len &&
> -	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOMIC=
))
> +	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb))=
,
> +	    		     0, GFP_ATOMIC))
>  		return -1;
> =20
>  	return 0;

OK, but could you please add a changelog as well ?

Your initial message contained a lot of useful information that could
help future bug hunting ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
