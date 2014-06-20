From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 3/5] expr: byteorder: Do not print unset values
 in xml file
Date: Fri, 20 Jun 2014 09:12:45 +0200
Message-ID: <CAOkSjBgPk7w6kM4vrOxS0orim61pog3jkxHjv61Cuvho6f_t_g@mail.gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com> <1403190430-22173-4-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47347 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaFTHNH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:13:07 -0400
Received: by mail-lb0-f180.google.com with SMTP id w7so2067433lbi.39
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 00:13:05 -0700 (PDT)
In-Reply-To: <1403190430-22173-4-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 June 2014 17:07, Ana Rey <anarey@gmail.com> wrote:
> It changes the parse and snprintf functions to omit unset values.
>
> Signed-off-by: Ana Rey <anarey@gmail.com>
> ---
>  src/expr/byteorder.c | 71 ++++++++++++++++++++++++++++++------------=
----------
>  1 file changed, 41 insertions(+), 30 deletions(-)
>
> diff --git a/src/expr/byteorder.c b/src/expr/byteorder.c
> index 0b87eca..ad7721f 100644
> --- a/src/expr/byteorder.c
> +++ b/src/expr/byteorder.c
> @@ -249,36 +249,28 @@ nft_rule_expr_byteorder_xml_parse(struct nft_ru=
le_expr *e, mxml_node_t *tree,
>         uint32_t sreg, dreg, len, size;
>
>         if (nft_mxml_reg_parse(tree, "sreg", &sreg, MXML_DESCEND_FIRS=
T,
> -                              NFT_XML_MAND, err) < 0)
> -               return -1;
> -       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sreg);
> +                              NFT_XML_MAND, err) =3D=3D 0)
> +               nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SREG, sre=
g);
>
>         if (nft_mxml_reg_parse(tree, "dreg", &dreg, MXML_DESCEND, NFT=
_XML_MAND,
> -                              err) < 0)
> -               return -1;
> -       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dreg);
> +                              err) =3D=3D 0)
> +               nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_DREG, dre=
g);
>
>         op =3D nft_mxml_str_parse(tree, "op", MXML_DESCEND_FIRST, NFT=
_XML_MAND,
>                                 err);
> -       if (op =3D=3D NULL)
> -               return -1;
> -
> -       ntoh =3D nft_str2ntoh(op);
> -       if (ntoh < 0)
> -               return -1;
> -       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_OP, ntoh);
> +       if (op !=3D NULL) {
> +               ntoh =3D nft_str2ntoh(op);
> +               if (ntoh >=3D 0)
> +                       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_O=
P, ntoh);
> +       }
>
>         if (nft_mxml_num_parse(tree, "len", MXML_DESCEND_FIRST, BASE_=
DEC,
> -                              &len, NFT_TYPE_U32, NFT_XML_MAND,
> -                              err) < 0)
> -               return -1;
> -       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len);
> +                              &len, NFT_TYPE_U32, NFT_XML_MAND, err)=
 =3D=3D 0)
> +               nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_LEN, len)=
;
>
>         if (nft_mxml_num_parse(tree, "size", MXML_DESCEND_FIRST, BASE=
_DEC,
> -                              &size, NFT_TYPE_U32, NFT_XML_MAND,
> -                              err) !=3D 0)
> -               return -1;
> -       nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, size);
> +                              &size, NFT_TYPE_U32, NFT_XML_MAND, err=
) =3D=3D 0)
> +               nft_rule_expr_set_u32(e, NFT_EXPR_BYTEORDER_SIZE, siz=
e);
>
>         return 0;
>  #else
> @@ -312,15 +304,34 @@ static int nft_rule_expr_byteorder_snprintf_xml=
(char *buf, size_t size,
>         struct nft_expr_byteorder *byteorder =3D nft_expr_data(e);
>         int len =3D size, offset =3D 0, ret;
>
> -       ret =3D snprintf(buf, len, "<sreg>%u</sreg>"
> -                                "<dreg>%u</dreg>"
> -                                "<op>%s</op>"
> -                                "<len>%u</len>"
> -                                "<size>%u</size>",
> -                      byteorder->sreg, byteorder->dreg,
> -                      expr_byteorder_str[byteorder->op],
> -                      byteorder->len, byteorder->size);
> -       SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       if (e->flags & (1 << NFT_EXPR_BYTEORDER_SREG)) {
> +               ret =3D snprintf(buf + offset, len, "<sreg>%u</sreg>"=
,
> +                              byteorder->sreg);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +
> +       if (e->flags & (1 << NFT_EXPR_BYTEORDER_DREG)) {
> +               ret =3D snprintf(buf + offset, len, "<dreg>%u</dreg>"=
,
> +                              byteorder->dreg);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +
> +       if (e->flags & (1 << NFT_EXPR_BYTEORDER_OP)) {
> +               ret =3D snprintf(buf + offset, len, "<op>%s</op>",
> +                              expr_byteorder_str[byteorder->op]);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +
> +       if (e->flags & (1 << NFT_EXPR_BYTEORDER_LEN)) {
> +               ret =3D snprintf(buf + offset, len, "<len>%u</len>",
> +                              byteorder->len);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +       if (e->flags & (1 << NFT_EXPR_BYTEORDER_SIZE)) {
> +               ret =3D snprintf(buf + offset, len, "<size>%u</size>"=
,
> +                              byteorder->size);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
>

This is an absolutely minor thing about the style: Why not being
consistent with the blank line separations between these if
statements?

A minor thing :-) I guess no need to resend.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
