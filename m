From: =?windows-1252?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nft PATCH] datatype: fix name of icmp* code
Date: Wed, 03 Dec 2014 12:25:15 +0100
Message-ID: <547EF31B.9020709@gmail.com>
References: <1417561371-22624-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:38208 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaLCLYs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Dec 2014 06:24:48 -0500
Received: by mail-wi0-f177.google.com with SMTP id l15so24036925wiw.10
        for <netfilter-devel@vger.kernel.org>; Wed, 03 Dec 2014 03:24:47 -0800 (PST)
In-Reply-To: <1417561371-22624-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric

El 03/12/14 a las 00:02, Eric Leblond escribi=F3:
> The name of datatypes can be used in set definition so they should
> follow the same logic (and maybe not contain space to avoid problem
> with parsing).
>
> This patch adds an underscore to the name of the icmp* code
> datatype.
>
> Signed-off-by: Eric Leblond <eric@regit.org>

Looks good to me. Thanks, I have used a uncorrect name format :)

> ---
>   src/datatype.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/src/datatype.c b/src/datatype.c
> index 5f976aa..1948bfa 100644
> --- a/src/datatype.c
> +++ b/src/datatype.c
> @@ -717,7 +717,7 @@ static struct error_record *icmp_code_type_parse(=
const struct expr *sym,
>
>   const struct datatype icmp_code_type =3D {
>   	.type		=3D TYPE_ICMP_CODE,
> -	.name		=3D "icmp code",
> +	.name		=3D "icmp_code",
>   	.desc		=3D "icmp code",
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
> @@ -749,7 +749,7 @@ static struct error_record *icmpv6_code_type_pars=
e(const struct expr *sym,
>
>   const struct datatype icmpv6_code_type =3D {
>   	.type		=3D TYPE_ICMPV6_CODE,
> -	.name		=3D "icmpv6 code",
> +	.name		=3D "icmpv6_code",
>   	.desc		=3D "icmpv6 code",
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
> @@ -781,7 +781,7 @@ static struct error_record *icmpx_code_type_parse=
(const struct expr *sym,
>
>   const struct datatype icmpx_code_type =3D {
>   	.type		=3D TYPE_ICMPX_CODE,
> -	.name		=3D "icmpx code",
> +	.name		=3D "icmpx_code",
>   	.desc		=3D "icmpx code",
>   	.size		=3D BITS_PER_BYTE,
>   	.byteorder	=3D BYTEORDER_BIG_ENDIAN,
>

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
