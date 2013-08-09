From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 11/13] expr: payload: add nft_str2base function
Date: Fri, 9 Aug 2013 13:31:35 +0200
Message-ID: <CAOkSjBhD94HpSmHmNLtpbeKrjygKu9zg5eeQHnWZ=LPrMBF=ZQ@mail.gmail.com>
References: <20130809111148.29819.95689.stgit@Ph0enix> <20130809111415.29819.19869.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Alvaro Neira <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:52805 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754606Ab3HILb5 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:31:57 -0400
Received: by mail-la0-f46.google.com with SMTP id eh20so2908315lab.5
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Aug 2013 04:31:56 -0700 (PDT)
In-Reply-To: <20130809111415.29819.19869.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 9 August 2013 13:14, Alvaro Neira <alvaroneay@gmail.com> wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>
> Add function that will be use in the JSON parser
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/expr/payload.c |   32 ++++++++++++++++++++------------
>  1 file changed, 20 insertions(+), 12 deletions(-)
>
> diff --git a/src/expr/payload.c b/src/expr/payload.c
> index 34aee90..e32ae1b 100644
> --- a/src/expr/payload.c
> +++ b/src/expr/payload.c
> @@ -13,6 +13,7 @@
>
>  #include <stdio.h>
>  #include <stdint.h>
> +#include <string.h>
>  #include <limits.h>
>  #include <arpa/inet.h>
>  #include <errno.h>
> @@ -178,13 +179,27 @@ nft_rule_expr_payload_snprintf_json(char *buf, =
size_t len, uint32_t flags,
>         return offset;
>  }
>
> +static inline int nft_str2base(const char *base)
> +{
> +       if (strcmp(base, "link") =3D=3D 0)
> +               return NFT_PAYLOAD_LL_HEADER;
> +       else if (strcmp(base, "network") =3D=3D 0)
> +               return NFT_PAYLOAD_NETWORK_HEADER;
> +       else if (strcmp(base, "transport") =3D=3D 0)
> +               return NFT_PAYLOAD_TRANSPORT_HEADER;
> +       else {
> +               errno =3D EINVAL;
> +               return -1;
> +       }
> +}
> +
>  static int
>  nft_rule_expr_payload_xml_parse(struct nft_rule_expr *e, mxml_node_t=
 *tree)
>  {
>  #ifdef XML_PARSING
>         struct nft_expr_payload *payload =3D nft_expr_data(e);
>         const char *base_str;
> -       int32_t reg;
> +       int32_t reg, base;
>
>         reg =3D nft_mxml_reg_parse(tree, "dreg", MXML_DESCEND_FIRST);
>         if (reg < 0)
> @@ -197,14 +212,10 @@ nft_rule_expr_payload_xml_parse(struct nft_rule=
_expr *e, mxml_node_t *tree)
>         if (base_str =3D=3D NULL)
>                 return -1;
>
> -       if (strcmp(base_str, "link") =3D=3D 0)
> -               payload->base =3D NFT_PAYLOAD_LL_HEADER;
> -       else if (strcmp(base_str, "network") =3D=3D 0)
> -               payload->base =3D NFT_PAYLOAD_NETWORK_HEADER;
> -       else if (strcmp(base_str, "transport") =3D=3D 0)
> -               payload->base =3D NFT_PAYLOAD_TRANSPORT_HEADER;
> -       else
> -               goto err;
> +       base =3D nft_str2base(base_str);
> +
> +       if (base < 0)
> +               return -1;

I think we need this:

payload->base =3D base;

Also, maybe goto err in case of base < 0

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
