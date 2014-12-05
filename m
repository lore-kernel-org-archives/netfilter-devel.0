From: leroy christophe <christophe.leroy@c-s.fr>
Subject: Re: [PATCH nft v2] payload: fix endianess issue in payload_expr_pctx_update()
Date: Fri, 05 Dec 2014 07:39:23 +0100
Message-ID: <5481531B.9090105@c-s.fr>
References: <1417700189-11337-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:40704 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740AbaLEGje (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Dec 2014 01:39:34 -0500
In-Reply-To: <1417700189-11337-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Tested-by: Christophe Leroy <christophe.leroy@c-s.fr>

Le 04/12/2014 14:36, Pablo Neira Ayuso a =E9crit :
> Use constant_data_ptr() to point to the right memory position on
> big endian when exporting data that is stored in a larger variable.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: this also fixes the printing of 1 byte fields that are converted =
to
>      symbolic constant.
>
>   src/datatype.c |    4 ++--
>   src/payload.c  |    4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/src/datatype.c b/src/datatype.c
> index fd3573e..729e63b 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -158,8 +158,8 @@ void symbolic_constant_print(const struct symbol_=
table *tbl,
>  =20
>   	/* Export the data in the correct byteorder for comparison */
>   	assert(expr->len / BITS_PER_BYTE <=3D sizeof(val));
> -	mpz_export_data(&val, expr->value, expr->byteorder,
> -			expr->len / BITS_PER_BYTE);
> +	mpz_export_data(constant_data_ptr(val, expr->len), expr->value,
> +			expr->byteorder, expr->len / BITS_PER_BYTE);
>  =20
>   	for (s =3D tbl->symbols; s->identifier !=3D NULL; s++) {
>   		if (val =3D=3D s->value)
> diff --git a/src/payload.c b/src/payload.c
> index ebf8079..83742fb 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -79,8 +79,8 @@ static void payload_expr_pctx_update(struct proto_c=
tx *ctx,
>  =20
>   	/* Export the data in the correct byte order */
>   	assert(right->len / BITS_PER_BYTE <=3D sizeof(proto));
> -	mpz_export_data(&proto, right->value, right->byteorder,
> -			right->len / BITS_PER_BYTE);
> +	mpz_export_data(constant_data_ptr(proto, right->len), right->value,
> +			right->byteorder, right->len / BITS_PER_BYTE);
>  =20
>   	base =3D ctx->protocol[left->payload.base].desc;
>   	desc =3D proto_find_upper(base, proto);

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
