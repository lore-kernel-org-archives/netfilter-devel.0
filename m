From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 2/2] src/rule: Changed parser support for having
 consistent with the new print support
Date: Tue, 11 Mar 2014 21:16:32 +0100
Message-ID: <CAOkSjBgLvyAxsnqx4CAuZziQaOj4ximZ2YAqd542HuEi-J9BCQ@mail.gmail.com>
References: <20140309125959.23270.43422.stgit@Ph0enix> <20140309130005.23270.28970.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63166 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaCKUQx convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:16:53 -0400
Received: by mail-lb0-f182.google.com with SMTP id n15so6038278lbi.13
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2014 13:16:52 -0700 (PDT)
In-Reply-To: <20140309130005.23270.28970.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alvaro,

a few coments below about this patch.

On 9 March 2014 14:00, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>
> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> ---
>  src/rule.c |   77 +++++++++++++++++++++++++++++++-------------------=
----------
>  1 file changed, 40 insertions(+), 37 deletions(-)
>

I would suggest to describe this parser change.

> diff --git a/src/rule.c b/src/rule.c
> index f0cafd3..e7335f8 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -540,28 +540,36 @@ int nft_jansson_parse_rule(struct nft_rule *r, =
json_t *tree,
>         if (root =3D=3D NULL)
>                 return -1;
>
> -       if (nft_jansson_parse_family(root, &family, err) !=3D 0)
> -               goto err;
> +       if (nft_jansson_node_exist(root, "family")) {
> +               if (nft_jansson_parse_family(root, &family, err) !=3D=
 0)
> +                       goto err;
>
>         nft_rule_attr_set_u32(r, NFT_RULE_ATTR_FAMILY, family);
> +       }
>

=46ix indentation. The nft_rule_attr_set_u32() is now inside the if sta=
tement.


> -       if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U64, &uval=
64,
> -                                 err) < 0)
> -               goto err;
> +       if (nft_jansson_node_exist(root, "handle")) {
> +               if (nft_jansson_parse_val(root, "handle", NFT_TYPE_U6=
4, &uval64,
> +                                         err) < 0)

Mixed tab/spaces indentation before 'err) < 0)'


> @@ -640,39 +648,34 @@ int nft_mxml_rule_parse(mxml_node_t *tree, stru=
ct nft_rule *r,
>
>         family =3D nft_mxml_family_parse(tree, "family", MXML_DESCEND=
_FIRST,
>                                        NFT_XML_MAND, err);
> -       if (family < 0)
> -               return -1;
> -
> -       r->family =3D family;
> -       r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
> +       if (family >=3D 0) {
> +               r->family =3D family;
> +               r->flags |=3D (1 << NFT_RULE_ATTR_FAMILY);
> +       }
>

I would suggest to, while at it, switch to nft_rule_attr_set_xx() funct=
ions.
IMHO, we will save some LOCs, among other benefits.

> -       r->table =3D strdup(table);
> -       r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
> +               r->table =3D strdup(table);
> +               r->flags |=3D (1 << NFT_RULE_ATTR_TABLE);
> +       }

Just for completeness:
remember that for string attributes, the strdup() is done internally,
inside nft_rule_attr_set_str().

>         if (nft_mxml_num_parse(tree, "handle", MXML_DESCEND_FIRST, BA=
SE_DEC,
> -                              &r->handle, NFT_TYPE_U64, NFT_XML_MAND=
, err) !=3D 0)
> -               return -1;
> -
> -       r->flags |=3D (1 << NFT_RULE_ATTR_HANDLE);
> +                              &r->handle, NFT_TYPE_U64, NFT_XML_MAND=
, err) >=3D 0)

The line above is 82 characters long.

regards!
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
