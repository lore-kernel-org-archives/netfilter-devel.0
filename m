From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [PATCH] dtype: remove unnecessary icmp* parse/print functions
Date: Thu, 11 Dec 2014 00:48:10 +0100
Message-ID: <5488DBBA.40002@gmail.com>
References: <1418249676-22300-1-git-send-email-kaber@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54882 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbaLJXrm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:47:42 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so12893290wiv.17
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Dec 2014 15:47:41 -0800 (PST)
In-Reply-To: <1418249676-22300-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 10/12/14 a las 23:14, Patrick McHardy escribi=F3:
> Just setting the .sym_tbl correctly is all we need.

Looks good to me and so smart. I didn't know that if we set up the=20
=2Esym_tbl, we don't need the parse and print functions. Thanks Patrick=
=2E

>
> Signed-off-by: Patrick McHardy <kaber@trash.net>
> ---
>   src/datatype.c | 42 +++---------------------------------------
>   1 file changed, 3 insertions(+), 39 deletions(-)
>
> diff --git a/src/datatype.c b/src/datatype.c
> index 729e63b..db3fb06 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -709,17 +709,6 @@ static const struct symbol_table icmp_code_tbl =3D=
 {
>   	},
>   };
>
> -static void icmp_code_type_print(const struct expr *expr)
> -{
> -	return symbolic_constant_print(&icmp_code_tbl, expr);
> -}
> -
> -static struct error_record *icmp_code_type_parse(const struct expr *=
sym,
> -						 struct expr **res)
> -{
> -	return symbolic_constant_parse(sym, &icmp_code_tbl, res);
> -}
> -
>   const struct datatype icmp_code_type =3D {
>   	.type		=3D TYPE_ICMP_CODE,
>   	.name		=3D "icmp_code",
> @@ -727,8 +716,7 @@ const struct datatype icmp_code_type =3D {
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
>   	.basetype	=3D &integer_type,
> -	.print		=3D icmp_code_type_print,
> -	.parse		=3D icmp_code_type_parse,
> +	.sym_tbl	=3D &icmp_code_tbl,
>   };
>
>   static const struct symbol_table icmpv6_code_tbl =3D {
> @@ -741,17 +729,6 @@ static const struct symbol_table icmpv6_code_tbl=
 =3D {
>   	},
>   };
>
> -static void icmpv6_code_type_print(const struct expr *expr)
> -{
> -	return symbolic_constant_print(&icmpv6_code_tbl, expr);
> -}
> -
> -static struct error_record *icmpv6_code_type_parse(const struct expr=
 *sym,
> -						   struct expr **res)
> -{
> -	return symbolic_constant_parse(sym, &icmpv6_code_tbl, res);
> -}
> -
>   const struct datatype icmpv6_code_type =3D {
>   	.type		=3D TYPE_ICMPV6_CODE,
>   	.name		=3D "icmpv6_code",
> @@ -759,8 +736,7 @@ const struct datatype icmpv6_code_type =3D {
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
>   	.basetype	=3D &integer_type,
> -	.print		=3D icmpv6_code_type_print,
> -	.parse		=3D icmpv6_code_type_parse,
> +	.sym_tbl	=3D &icmpv6_code_tbl,
>   };
>
>   static const struct symbol_table icmpx_code_tbl =3D {
> @@ -773,17 +749,6 @@ static const struct symbol_table icmpx_code_tbl =
=3D {
>   	},
>   };
>
> -static void icmpx_code_type_print(const struct expr *expr)
> -{
> -	return symbolic_constant_print(&icmpx_code_tbl, expr);
> -}
> -
> -static struct error_record *icmpx_code_type_parse(const struct expr =
*sym,
> -						  struct expr **res)
> -{
> -	return symbolic_constant_parse(sym, &icmpx_code_tbl, res);
> -}
> -
>   const struct datatype icmpx_code_type =3D {
>   	.type		=3D TYPE_ICMPX_CODE,
>   	.name		=3D "icmpx_code",
> @@ -791,8 +756,7 @@ const struct datatype icmpx_code_type =3D {
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
>   	.basetype	=3D &integer_type,
> -	.print		=3D icmpx_code_type_print,
> -	.parse		=3D icmpx_code_type_parse,
> +	.sym_tbl	=3D &icmpx_code_tbl,
>   };
>
>   static void time_type_print(const struct expr *expr)
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
