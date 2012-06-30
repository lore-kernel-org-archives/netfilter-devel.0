From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] netfilter: nf_conntrack: generalize nf_ct_l4proto_net
Date: Sat, 30 Jun 2012 20:29:06 +0800
Message-ID: <4FEEF112.1080004@cn.fujitsu.com>
References: <1340983405-32118-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:1279 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754249Ab2F3M2n convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jun 2012 08:28:43 -0400
In-Reply-To: <1340983405-32118-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=E4=BA=8E 2012=E5=B9=B406=E6=9C=8829=E6=97=A5 23:23, pablo@netfilter.or=
g =E5=86=99=E9=81=93:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> This patch generalizes nf_ct_l4proto_net by splitting it into chunks =
and
> moving the corresponding protocol part to where it really belongs to.
>=20
> To clarify, note that we follow two different approaches to support p=
er-net
> depending if it's built-in or run-time loadable protocol tracker.
>=20
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  include/net/netfilter/nf_conntrack_l4proto.h   |    3 +++
>  net/ipv4/netfilter/nf_conntrack_proto_icmp.c   |    6 ++++++
>  net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c |    6 ++++++
>  net/netfilter/nf_conntrack_proto.c             |   22 ++++++--------=
--------
>  net/netfilter/nf_conntrack_proto_generic.c     |    6 ++++++
>  net/netfilter/nf_conntrack_proto_tcp.c         |    7 +++++++
>  net/netfilter/nf_conntrack_proto_udp.c         |    7 +++++++
>  7 files changed, 41 insertions(+), 16 deletions(-)

Yes,It looks better,thanks!

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

>=20
> diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/n=
et/netfilter/nf_conntrack_l4proto.h
> index 08bb571..c3be4ae 100644
> --- a/include/net/netfilter/nf_conntrack_l4proto.h
> +++ b/include/net/netfilter/nf_conntrack_l4proto.h
> @@ -99,6 +99,9 @@ struct nf_conntrack_l4proto {
>  	/* Init l4proto pernet data */
>  	int (*init_net)(struct net *net, u_int16_t proto);
> =20
> +	/* Return the per-net protocol part. */
> +	struct nf_proto_net *(*get_net_proto)(struct net *net);
> +
>  	/* Protocol name */
>  	const char *name;
> =20
> diff --git a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c b/net/ipv4/=
netfilter/nf_conntrack_proto_icmp.c
> index 9c2095c..5241d99 100644
> --- a/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> +++ b/net/ipv4/netfilter/nf_conntrack_proto_icmp.c
> @@ -388,6 +388,11 @@ static int icmp_init_net(struct net *net, u_int1=
6_t proto)
>  	return ret;
>  }
> =20
> +static struct nf_proto_net *icmp_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.icmp.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_icmp __read_mostly =
=3D
>  {
>  	.l3proto		=3D PF_INET,
> @@ -418,4 +423,5 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_=
icmp __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D icmp_init_net,
> +	.get_net_proto		=3D icmp_get_net_proto,
>  };
> diff --git a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c b/net/ipv=
6/netfilter/nf_conntrack_proto_icmpv6.c
> index 9fc5cf5..2d54b20 100644
> --- a/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> +++ b/net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c
> @@ -358,6 +358,11 @@ static int icmpv6_init_net(struct net *net, u_in=
t16_t proto)
>  	return icmpv6_kmemdup_sysctl_table(pn, in);
>  }
> =20
> +static struct nf_proto_net *icmpv6_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.icmpv6.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_icmpv6 __read_mostl=
y =3D
>  {
>  	.l3proto		=3D PF_INET6,
> @@ -386,4 +391,5 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_=
icmpv6 __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D icmpv6_init_net,
> +	.get_net_proto		=3D icmpv6_get_net_proto,
>  };
> diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_co=
nntrack_proto.c
> index 21b850c..0dc6385 100644
> --- a/net/netfilter/nf_conntrack_proto.c
> +++ b/net/netfilter/nf_conntrack_proto.c
> @@ -303,22 +303,12 @@ EXPORT_SYMBOL_GPL(nf_conntrack_l3proto_unregist=
er);
>  static struct nf_proto_net *nf_ct_l4proto_net(struct net *net,
>  					      struct nf_conntrack_l4proto *l4proto)
>  {
> -	switch (l4proto->l4proto) {
> -	case IPPROTO_TCP:
> -		return (struct nf_proto_net *)&net->ct.nf_ct_proto.tcp;
> -	case IPPROTO_UDP:
> -		return (struct nf_proto_net *)&net->ct.nf_ct_proto.udp;
> -	case IPPROTO_ICMP:
> -		return (struct nf_proto_net *)&net->ct.nf_ct_proto.icmp;
> -	case IPPROTO_ICMPV6:
> -		return (struct nf_proto_net *)&net->ct.nf_ct_proto.icmpv6;
> -	case 255: /* l4proto_generic */
> -		return (struct nf_proto_net *)&net->ct.nf_ct_proto.generic;
> -	default:
> -		if (l4proto->net_id)
> -			return net_generic(net, *l4proto->net_id);
> -		else
> -			return NULL;
> +	if (l4proto->get_net_proto) {
> +		/* statically built-in protocols use static per-net */
> +		return l4proto->get_net_proto(net);
> +	} else if (l4proto->net_id) {
> +		/* ... and loadable protocols use dynamic per-net */
> +		return net_generic(net, *l4proto->net_id);
>  	}
>  	return NULL;
>  }
> diff --git a/net/netfilter/nf_conntrack_proto_generic.c b/net/netfilt=
er/nf_conntrack_proto_generic.c
> index 7c11c54..d25f293 100644
> --- a/net/netfilter/nf_conntrack_proto_generic.c
> +++ b/net/netfilter/nf_conntrack_proto_generic.c
> @@ -186,6 +186,11 @@ static int generic_init_net(struct net *net, u_i=
nt16_t proto)
>  	return ret;
>  }
> =20
> +static struct nf_proto_net *generic_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.generic.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_generic __read_most=
ly =3D
>  {
>  	.l3proto		=3D PF_UNSPEC,
> @@ -207,4 +212,5 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_=
generic __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D generic_init_net,
> +	.get_net_proto		=3D generic_get_net_proto,
>  };
> diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/n=
f_conntrack_proto_tcp.c
> index 44f0da8..07e56ea 100644
> --- a/net/netfilter/nf_conntrack_proto_tcp.c
> +++ b/net/netfilter/nf_conntrack_proto_tcp.c
> @@ -1623,6 +1623,11 @@ static int tcp_init_net(struct net *net, u_int=
16_t proto)
>  	return ret;
>  }
> =20
> +static struct nf_proto_net *tcp_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.tcp.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_tcp4 __read_mostly =
=3D
>  {
>  	.l3proto		=3D PF_INET,
> @@ -1656,6 +1661,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4prot=
o_tcp4 __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D tcp_init_net,
> +	.get_net_proto		=3D tcp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp4);
> =20
> @@ -1692,5 +1698,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4prot=
o_tcp6 __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D tcp_init_net,
> +	.get_net_proto		=3D tcp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_tcp6);
> diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/n=
f_conntrack_proto_udp.c
> index e7e0434..59623cc 100644
> --- a/net/netfilter/nf_conntrack_proto_udp.c
> +++ b/net/netfilter/nf_conntrack_proto_udp.c
> @@ -297,6 +297,11 @@ static int udp_init_net(struct net *net, u_int16=
_t proto)
>  	return ret;
>  }
> =20
> +static struct nf_proto_net *udp_get_net_proto(struct net *net)
> +{
> +	return &net->ct.nf_ct_proto.udp.pn;
> +}
> +
>  struct nf_conntrack_l4proto nf_conntrack_l4proto_udp4 __read_mostly =
=3D
>  {
>  	.l3proto		=3D PF_INET,
> @@ -325,6 +330,7 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_=
udp4 __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D udp_init_net,
> +	.get_net_proto		=3D udp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp4);
> =20
> @@ -356,5 +362,6 @@ struct nf_conntrack_l4proto nf_conntrack_l4proto_=
udp6 __read_mostly =3D
>  	},
>  #endif /* CONFIG_NF_CT_NETLINK_TIMEOUT */
>  	.init_net		=3D udp_init_net,
> +	.get_net_proto		=3D udp_get_net_proto,
>  };
>  EXPORT_SYMBOL_GPL(nf_conntrack_l4proto_udp6);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
