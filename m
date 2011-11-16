From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] possible unaligned packet header caused by
 ip_route_me_harder()->pskb_expand_head()
Date: Wed, 16 Nov 2011 17:54:38 +0100
Message-ID: <20111116165438.GA16014@1984>
References: <4EB9449D.8020701@tilera.com>
 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBA48F3.8040906@tilera.com>
 <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <4EBB7E3C.9030402@tilera.com>
 <20111113170233.GA16851@1984>
 <4EC0D254.7060503@tilera.com>
 <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Paul Guo <ggang@tilera.com>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38408 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753113Ab1KPQym (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:54:42 -0500
Content-Disposition: inline
In-Reply-To: <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

On Mon, Nov 14, 2011 at 10:46:40AM +0100, Eric Dumazet wrote:
> Le lundi 14 novembre 2011 =E0 16:33 +0800, Paul Guo a =E9crit :
> > > git://1984.lsi.us.es/net/.git
> >=20
> > OK. Here is the patch based on above git tree.
> >=20
> >=20
> > Signed-off-by: Paul Guo <ggang@tilera.com>
> > ---
> >  net/ipv4/netfilter.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> >=20
> > diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
> > index 929b27b..0dcb0fa 100644
> > --- a/net/ipv4/netfilter.c
> > +++ b/net/ipv4/netfilter.c
> > @@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, unsig=
ned addr_type)
> >  	/* Change in oif may mean change in hh_len. */
> >  	hh_len =3D skb_dst(skb)->dev->hard_header_len;
> >  	if (skb_headroom(skb) < hh_len &&
> > -	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_ATOM=
IC))
> > +	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(skb=
)),
> > +	    		     0, GFP_ATOMIC))
> >  		return -1;
> > =20
> >  	return 0;
>=20
> OK, but could you please add a changelog as well ?
>=20
> Your initial message contained a lot of useful information that could
> help future bug hunting ;)

BTW, did you acked this patch?

Let me know, to include it in the changelog.

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
