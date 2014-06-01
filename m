From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nftables PATCH v2] payload: Relax assert in function
 payload_expr_pctx_update
Date: Sun, 1 Jun 2014 21:12:54 +0100
Message-ID: <20140601201254.GA19396@macbook.localnet>
References: <1401203097-26180-1-git-send-email-alvaroneay@gmail.com>
 <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55129 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaFAUNG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2014 16:13:06 -0400
Content-Disposition: inline
In-Reply-To: <1401270454-11669-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 28, 2014 at 11:47:34AM +0200, Alvaro Neira Ayuso wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>=20
> If we add this rule:
>=20
> sudo nft add rule ip test input ip protocol !=3D icmp
>=20
> and we try to list the rules in the table test, nftables
> show this error:
>=20
> nft: src/payload.c:76: payload_expr_pctx_update: Assertion `expr->op
> =3D=3D OP_EQ' failed.
>=20
> This patch relaxes this assert adding another clause like
> the expr operation can be non equal, not only equal.

The function is supposed to update the context based on equality
relations. This change is very wrong, for !=3D icmp it will update
the contect for upper protocol to be ICMP.

The correct fix would be to only invoke the function for equality
relations in payload_match_postprocess().


> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
> [changes in v2]
> * I have rewritten the title and the description of this patch
>=20
>  src/payload.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/src/payload.c b/src/payload.c
> index a1785a5..b9ad6f7 100644
> --- a/src/payload.c
> +++ b/src/payload.c
> @@ -73,7 +73,7 @@ static void payload_expr_pctx_update(struct proto_c=
tx *ctx,
>  	if (!(left->flags & EXPR_F_PROTOCOL))
>  		return;
> =20
> -	assert(expr->op =3D=3D OP_EQ);
> +	assert(expr->op =3D=3D OP_EQ || expr->op =3D=3D OP_NEQ);
>  	base =3D ctx->protocol[left->payload.base].desc;
>  	desc =3D proto_find_upper(base, mpz_get_uint32(right->value));
> =20
> --=20
> 1.7.10.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
