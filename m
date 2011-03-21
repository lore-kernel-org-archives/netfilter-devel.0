From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH 2/3] netfilter: af_info: add 'strict' parameter to
 limit lookup to .oif
Date: Mon, 21 Mar 2011 23:42:59 +0100
Message-ID: <1300747379.2837.23.camel@edumazet-laptop>
References: <1300746341-18011-1-git-send-email-fw@strlen.de>
	 <1300746341-18011-2-git-send-email-fw@strlen.de>
	 <1300747149.2837.22.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57501 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab1CUWxo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Mar 2011 18:53:44 -0400
Received: by fxm17 with SMTP id 17so5939182fxm.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Mar 2011 15:53:42 -0700 (PDT)
In-Reply-To: <1300747149.2837.22.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le lundi 21 mars 2011 =C3=A0 23:39 +0100, Eric Dumazet a =C3=A9crit :
> Le lundi 21 mars 2011 =C3=A0 23:25 +0100, Florian Westphal a =C3=A9cr=
it :
> > ipv6 fib lookup can set RT6_LOOKUP_F_IFACE flag to restrict search
> > to an interface, but this flag cannot be set via struct flowi.
> >=20
> > Also, it cannot be set via ip6_route_output: this function uses the
> > passed sock struct to determine if this flag is required
> > (by testing for nonzero sk_bound_dev_if).
> >=20
> > Work around this by passing in an artificial struct sk in case
> > 'strict' argument is true.
> >=20
> > This is required to replace the rt6_lookup call in xt_addrtype.c wi=
th
> > nf_afinfo->route().
> >=20
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  Patrick,
> >=20
> >  the change in nf_ip6_route() is very ugly, but I found no
> >  other way to set RT6_LOOKUP_F_IFACE.
> >=20
> >  rt6_lookup() can't be used instead of ip6_route_output
> >  since it does not take a flowi argument...
> >=20
> >  include/linux/netfilter.h              |    2 +-
> >  net/ipv4/netfilter.c                   |    2 +-
> >  net/ipv6/netfilter.c                   |   14 ++++++++++++--
> >  net/netfilter/nf_conntrack_h323_main.c |    8 ++++----
> >  net/netfilter/xt_TCPMSS.c              |    2 +-
> >  5 files changed, 19 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
> > index 20ed452..7fa95df 100644
> > --- a/include/linux/netfilter.h
> > +++ b/include/linux/netfilter.h
> > @@ -271,7 +271,7 @@ struct nf_afinfo {
> >  					    unsigned int len,
> >  					    u_int8_t protocol);
> >  	int		(*route)(struct net *net, struct dst_entry **dst,
> > -				 struct flowi *fl);
> > +				 struct flowi *fl, bool strict);
> >  	void		(*saveroute)(const struct sk_buff *skb,
> >  				     struct nf_queue_entry *entry);
> >  	int		(*reroute)(struct sk_buff *skb,
> > diff --git a/net/ipv4/netfilter.c b/net/ipv4/netfilter.c
> > index 138e106..87f20e8 100644
> > --- a/net/ipv4/netfilter.c
> > +++ b/net/ipv4/netfilter.c
> > @@ -218,7 +218,7 @@ static __sum16 nf_ip_checksum_partial(struct sk=
_buff *skb, unsigned int hook,
> >  }
> > =20
> >  static int nf_ip_route(struct net *net, struct dst_entry **dst,
> > -		       struct flowi *fl)
> > +		       struct flowi *fl, bool strict __always_unused)
> >  {
> >  	return ip_route_output_key(net, (struct rtable **)dst, fl);
> >  }
> > diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> > index 9e1b3e4..f237d58 100644
> > --- a/net/ipv6/netfilter.c
> > +++ b/net/ipv6/netfilter.c
> > @@ -90,9 +90,19 @@ static int nf_ip6_reroute(struct sk_buff *skb,
> >  }
> > =20
> >  static int nf_ip6_route(struct net *net, struct dst_entry **dst,
> > -			struct flowi *fl)
> > +			struct flowi *fl, bool strict)
> >  {
> > -	*dst =3D ip6_route_output(net, NULL, fl);
> > +	static const struct ipv6_pinfo fake_pinfo;
> > +	static const struct inet_sock fake_sk =3D {
> > +		/* makes ip6_route_output set RT6_LOOKUP_F_IFACE: */
> > +		.sk.sk_bound_dev_if =3D 1,
> > +		.pinet6 =3D (struct ipv6_pinfo *) &fake_pinfo,
> > +	};
> > +	struct sock *sk =3D NULL;
> > +
> > +	if (strict)
> > +		sk =3D (struct sock *) &fake_sk;
> > +	*dst =3D ip6_route_output(net, sk, fl);
> >  	return (*dst)->error;
> >  }
> > =20
>=20
> Wow... I can tell you David will not accept this...
>=20
> This is about 800 bytes on stack, initted, so quite a huge cost for t=
his
> function.
>=20

Ah sorry, I missed the "static const". Maybe I should just sleep now ;)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
