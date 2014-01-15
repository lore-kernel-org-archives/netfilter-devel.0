From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] ct: fix key and dir requirements
Date: Wed, 15 Jan 2014 18:34:48 +0100
Message-ID: <CAOkSjBiBwKyWYiOTUoUj6DwsrJN=PFiejcCwAmXWNHaPEoC1xA@mail.gmail.com>
References: <20140115172743.18560.66057.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47962 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAORfL convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 12:35:11 -0500
Received: by mail-lb0-f169.google.com with SMTP id q8so1025124lbi.14
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 09:35:09 -0800 (PST)
In-Reply-To: <20140115172743.18560.66057.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2014 18:27, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Follow linux/net/netfilter/nft_ct.c to adjust key and dir attributes.
>
> The dir attribute is needed only when using certaing keys, and prohib=
ited with
> others.
>
> Key is always mandatory.
>
> Previous to this patch, using XML/JSON to manage this expr led to som=
e
> undefined and erroneous behaviours.
>
> While at it, update tests files in order to pass nft-parsing-test.
>
> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com=
>
> ---
>  src/expr/ct.c                   |   96 +++++++++++++++++++++++++++--=
----------
>  tests/xmlfiles/24-rule-ct.xml   |    2 -
>  tests/xmlfiles/37-rule-real.xml |    2 -
>  tests/xmlfiles/39-rule-real.xml |    2 -
>  tests/xmlfiles/50-rule-real.xml |    2 -
>  tests/xmlfiles/51-rule-real.xml |    2 -
>  tests/xmlfiles/52-rule-real.xml |    2 -
>  tests/xmlfiles/53-rule-real.xml |    2 -
>  tests/xmlfiles/54-rule-real.xml |    2 -
>  tests/xmlfiles/55-rule-real.xml |    2 -
>  tests/xmlfiles/56-rule-real.xml |    2 -
>  tests/xmlfiles/57-rule-real.xml |    2 -
>  12 files changed, 77 insertions(+), 41 deletions(-)
>
> diff --git a/src/expr/ct.c b/src/expr/ct.c
> index 97f9dcc..9ef0ef2 100644
> --- a/src/expr/ct.c
> +++ b/src/expr/ct.c
> @@ -178,6 +178,27 @@ static inline int str2ctkey(const char *ctkey)
>         return -1;
>  }
>
> +static bool ctkey_req_dir(int ctkey)
> +{
> +       switch (ctkey) {
> +       case NFT_CT_STATE:
> +       case NFT_CT_DIRECTION:
> +       case NFT_CT_STATUS:
> +       case NFT_CT_MARK:
> +       case NFT_CT_SECMARK:
> +       case NFT_CT_EXPIRATION:
> +       case NFT_CT_HELPER:
> +               return false;
> +       case NFT_CT_PROTOCOL:
> +       case NFT_CT_SRC:
> +       case NFT_CT_DST:
> +       case NFT_CT_PROTO_SRC:
> +       case NFT_CT_PROTO_DST:
> +       default:
> +               return true;
> +       }
> +}
> +
>  static int nft_rule_expr_ct_json_parse(struct nft_rule_expr *e, json=
_t *root,
>                                        struct nft_parse_err *err)
>  {
> @@ -192,22 +213,19 @@ static int nft_rule_expr_ct_json_parse(struct n=
ft_rule_expr *e, json_t *root,
>
>         nft_rule_expr_set_u32(e, NFT_EXPR_CT_DREG, reg);
>
> -       if (nft_jansson_node_exist(root, "key")) {
> -               key_str =3D nft_jansson_parse_str(root, "key", err);
> -               if (key_str =3D=3D NULL)
> -                       return -1;
> -
> -               key =3D str2ctkey(key_str);
> -               if (key < 0)
> -                       goto err;
> +       key_str =3D nft_jansson_parse_str(root, "key", err);
> +       if (key_str =3D=3D NULL)
> +               return -1;
>
> -               nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
> +       key =3D str2ctkey(key_str);
> +       if (key < 0)
> +               goto err;
>
> -       }
> +       nft_rule_expr_set_u32(e, NFT_EXPR_CT_KEY, key);
>
> -       if (nft_jansson_node_exist(root, "dir")) {
> -               if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8, &=
dir,
> -                                         err) < 0)
> +       if (ctkey_req_dir(key)) {
> +               if (nft_jansson_parse_val(root, "dir", NFT_TYPE_U8,
> +                                         &dir, err) < 0)
>                         return -1;
>
>                 if (dir !=3D IP_CT_DIR_ORIGINAL && dir !=3D IP_CT_DIR=
_REPLY)
> @@ -256,15 +274,18 @@ static int nft_rule_expr_ct_xml_parse(struct nf=
t_rule_expr *e, mxml_node_t *tree
>         ct->key =3D key;
>         e->flags |=3D (1 << NFT_EXPR_CT_KEY);
>
> -       if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRST, BASE_=
DEC,
> -                              &dir, NFT_TYPE_U8, NFT_XML_MAND, err) =
!=3D 0)
> -               return -1;
> +       if (ctkey_req_dir(key)) {
> +               if (nft_mxml_num_parse(tree, "dir", MXML_DESCEND_FIRS=
T,
> +                                      BASE_DEC, &dir, NFT_TYPE_U8,
> +                                      NFT_XML_MAND, err) =3D=3D 0) {

Wrong logic here.

Please ignore the patch. I'm sending v2.

Thanks.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
