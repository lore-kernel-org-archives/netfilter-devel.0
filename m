From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Tue, 7 Jan 2014 18:13:16 +0100
Message-ID: <CAOkSjBi=hT2wVcNTXJ3G4r0hXJBv=-68MJNHX+n2+KiM0cOG-A@mail.gmail.com>
References: <1389107738-24320-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:34315 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbaAGRNi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:13:38 -0500
Received: by mail-lb0-f176.google.com with SMTP id l4so479812lbv.21
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 09:13:36 -0800 (PST)
In-Reply-To: <1389107738-24320-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 7 January 2014 16:15, Kristian Evensen <kristian.evensen@gmail.com> =
wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
>

Hi Kristian,

some minor comments below.

> This patch adds userspace support for setting properties of tracked c=
onnections.
> Currently, the connection mark is supported. This can be used to impl=
emented the
> same functionality as iptables -j CONNMARK --save-mark.
>
> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index 46e3cef..a509216 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -24,7 +24,10 @@
>
>  struct nft_expr_ct {
>         enum nft_ct_keys        key;
> -       uint32_t                dreg;   /* enum nft_registers */
> +       union{

note the missing space after union definition.

> @@ -235,11 +257,17 @@ static int nft_rule_expr_ct_xml_parse(struct nf=
t_rule_expr *e, mxml_node_t *tree
>         uint8_t dir;
>
>         reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
> -       if (reg < 0)
> -               return -1;
> +       if (reg >=3D 0) {
> +               ct->dreg =3D reg;
> +               e->flags |=3D (1 << NFT_EXPR_CT_DREG);
> +       } else {
> +               reg =3D nft_mxml_reg_parse(tree, "sreg", MXML_DESCEND=
_FIRST);
> +               if (reg < 0)
> +                       return -1;
>
> -       ct->dreg =3D reg;
> -       e->flags |=3D (1 << NFT_EXPR_CT_DREG);
> +               ct->sreg =3D reg;
> +               e->flags |=3D (1 << NFT_EXPR_CT_SREG);
> +       }

Looking at this, I think we should fail if neither dreg nor sreg are
present. I guess we need at least one of two and if not, the
expression is invalid. Also in JSON parsing.

A similar improvement is required in src/expr/meta.c

regards

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
