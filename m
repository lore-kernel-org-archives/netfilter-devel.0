From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] possible unaligned packet header caused by
 ip_route_me_harder()->pskb_expand_head()
Date: Mon, 21 Nov 2011 11:30:31 +0100
Message-ID: <1321871431.2552.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <4EB9449D.8020701@tilera.com>
	 <1320771494.3444.8.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EBA48F3.8040906@tilera.com>
	 <1320832102.2315.10.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4EBB7E3C.9030402@tilera.com> <20111113170233.GA16851@1984>
	 <4EC0D254.7060503@tilera.com>
	 <1321264000.2272.0.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <20111116165438.GA16014@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Paul Guo <ggang@tilera.com>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57068 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab1KUKag (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Nov 2011 05:30:36 -0500
Received: by ghbz2 with SMTP id z2so2603520ghb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2011 02:30:36 -0800 (PST)
In-Reply-To: <20111116165438.GA16014@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le mercredi 16 novembre 2011 =C3=A0 17:54 +0100, Pablo Neira Ayuso a =C3=
=A9crit :
> Hi Eric,
>=20
> On Mon, Nov 14, 2011 at 10:46:40AM +0100, Eric Dumazet wrote:
> > Le lundi 14 novembre 2011 =C3=A0 16:33 +0800, Paul Guo a =C3=A9crit=
 :
> > > > git://1984.lsi.us.es/net/.git
> > >=20
> > > OK. Here is the patch based on above git tree.
> > >=20
> > >=20
> > > Signed-off-by: Paul Guo <ggang@tilera.com>
> > > ---
> > >  net/ipv4/netfilter.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > >=20
> > > diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
> > > index 929b27b..0dcb0fa 100644
> > > --- a/net/ipv4/netfilter.c
> > > +++ b/net/ipv4/netfilter.c
> > > @@ -63,7 +63,8 @@ int ip_route_me_harder(struct sk_buff *skb, uns=
igned addr_type)
> > >  	/* Change in oif may mean change in hh_len. */
> > >  	hh_len =3D skb_dst(skb)->dev->hard_header_len;
> > >  	if (skb_headroom(skb) < hh_len &&
> > > -	    pskb_expand_head(skb, hh_len - skb_headroom(skb), 0, GFP_AT=
OMIC))
> > > +	    pskb_expand_head(skb, HH_DATA_ALIGN(hh_len - skb_headroom(s=
kb)),
> > > +	    		     0, GFP_ATOMIC))
> > >  		return -1;
> > > =20
> > >  	return 0;
> >=20
> > OK, but could you please add a changelog as well ?
> >=20
> > Your initial message contained a lot of useful information that cou=
ld
> > help future bug hunting ;)
>=20
> BTW, did you acked this patch?
>=20
> Let me know, to include it in the changelog.

Sure, sorry I missed your mail

Acked-by: Eric Dumazet <eric.dumazet@gmail.com>


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
