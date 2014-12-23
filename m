From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH] netfilter: nf_tables: fix port natting in little endian
 archs
Date: Tue, 23 Dec 2014 15:24:30 +0100
Message-ID: <54997B1E.7010706@c-s.fr>
References: <1419253182-3590-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:30615 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbaLWOYc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:24:32 -0500
In-Reply-To: <1419253182-3590-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Le 22/12/2014 13:59, Pablo Neira Ayuso a =E9crit :
> From: leroy christophe <christophe.leroy@c-s.fr>
>
> Make sure this fetches 16-bits port data from the register.
> Remove casting to make sparse happy, not needed anymore.
>
> Signed-off-by: leroy christophe <christophe.leroy@c-s.fr>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> @Christophe: I have also mangled other spots where this problems will=
 show up
> and remove casting (not required anymore to make sparse happy). Pleas=
e, test
> and will submit this to mainstream. I have included you as author, I =
wanted
> to speed up the submission process. Thanks.

It works OK, both for NAT and REDIRECT. Tested on ipv4, not tested with=
=20
ipv6.

Christophe

>
>   net/ipv4/netfilter/nft_redir_ipv4.c |    8 ++++----
>   net/ipv6/netfilter/nft_redir_ipv6.c |    8 ++++----
>   net/netfilter/nft_nat.c             |    8 ++++----
>   3 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/net/ipv4/netfilter/nft_redir_ipv4.c b/net/ipv4/netfilter=
/nft_redir_ipv4.c
> index ff2d23d..6ecfce6 100644
> --- a/net/ipv4/netfilter/nft_redir_ipv4.c
> +++ b/net/ipv4/netfilter/nft_redir_ipv4.c
> @@ -27,10 +27,10 @@ static void nft_redir_ipv4_eval(const struct nft_=
expr *expr,
>  =20
>   	memset(&mr, 0, sizeof(mr));
>   	if (priv->sreg_proto_min) {
> -		mr.range[0].min.all =3D (__force __be16)
> -					data[priv->sreg_proto_min].data[0];
> -		mr.range[0].max.all =3D (__force __be16)
> -					data[priv->sreg_proto_max].data[0];
> +		mr.range[0].min.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_min].data[0];
> +		mr.range[0].max.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_max].data[0];
>   		mr.range[0].flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
>   	}
>  =20
> diff --git a/net/ipv6/netfilter/nft_redir_ipv6.c b/net/ipv6/netfilter=
/nft_redir_ipv6.c
> index 2433a6b..11820b6 100644
> --- a/net/ipv6/netfilter/nft_redir_ipv6.c
> +++ b/net/ipv6/netfilter/nft_redir_ipv6.c
> @@ -27,10 +27,10 @@ static void nft_redir_ipv6_eval(const struct nft_=
expr *expr,
>  =20
>   	memset(&range, 0, sizeof(range));
>   	if (priv->sreg_proto_min) {
> -		range.min_proto.all =3D (__force __be16)
> -					data[priv->sreg_proto_min].data[0];
> -		range.max_proto.all =3D (__force __be16)
> -					data[priv->sreg_proto_max].data[0];
> +		range.min_proto.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_min].data[0];
> +		range.max_proto.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_max].data[0];
>   		range.flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
>   	}
>  =20
> diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
> index afe2b0b..aff54fb1 100644
> --- a/net/netfilter/nft_nat.c
> +++ b/net/netfilter/nft_nat.c
> @@ -65,10 +65,10 @@ static void nft_nat_eval(const struct nft_expr *e=
xpr,
>   	}
>  =20
>   	if (priv->sreg_proto_min) {
> -		range.min_proto.all =3D (__force __be16)
> -					data[priv->sreg_proto_min].data[0];
> -		range.max_proto.all =3D (__force __be16)
> -					data[priv->sreg_proto_max].data[0];
> +		range.min_proto.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_min].data[0];
> +		range.max_proto.all =3D
> +			*(__be16 *)&data[priv->sreg_proto_max].data[0];
>   		range.flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
>   	}
>  =20

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
