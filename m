From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] expr: add ct_set expression
Date: Thu, 2 Jan 2014 10:52:32 +0100
Message-ID: <CAOkSjBg5C6eCQ-AA-E5Wr9wExo8hZsEk3Bz2G5BPpqAVHBtoGA@mail.gmail.com>
References: <1388653976-30802-1-git-send-email-eric@regit.org> <1388654079-31459-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:55581 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaABJwy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 04:52:54 -0500
Received: by mail-lb0-f179.google.com with SMTP id w7so7126265lbi.38
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jan 2014 01:52:53 -0800 (PST)
In-Reply-To: <1388654079-31459-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 January 2014 10:14, Eric Leblond <eric@regit.org> wrote:
> This patch adds support for 'ct_set' expression which is a port
> of iptables CT target.
>
> Signed-off-by: Eric Leblond <eric@regit.org>

Hi Eric, this patch looks good. Some comments below:

> +static const void *
> +nft_rule_expr_ct_set_get(const struct nft_rule_expr *e, uint16_t typ=
e,
> +                     uint32_t *data_len)
> +{
> +       struct nft_expr_ct_set *ct_set =3D nft_expr_data(e);
> +
> +       switch(type) {
> +       case NFT_EXPR_CT_SET_FLAGS:
> +               *data_len =3D sizeof(ct_set->flags);
> +               return &ct_set->flags;
> +       case NFT_EXPR_CT_SET_PROTO:
> +               *data_len =3D sizeof(ct_set->proto);
> +               return &ct_set->proto;
> +       case NFT_EXPR_CT_SET_ZONEID:
> +               *data_len =3D sizeof(ct_set->zoneid);
> +               return &ct_set->zoneid;
> +       case NFT_EXPR_CT_SET_CTEVENTS:
> +               *data_len =3D sizeof(ct_set->ct_events);
> +               return &ct_set->ct_events;
> +       case NFT_EXPR_CT_SET_EXPEVENTS:
> +               *data_len =3D sizeof(ct_set->exp_events);
> +               return &ct_set->exp_events;
> +       case NFT_EXPR_CT_SET_HELPER:
> +               *data_len =3D strlen(ct_set->helper)+1;
> +               return ct_set->helper;
> +       case NFT_EXPR_CT_SET_TIMEOUT:
> +               *data_len =3D strlen(ct_set->timeout)+1;

Why +1 here?
Others expressions, like 'log' or 'lookup' simply sets data_len with st=
rlen().

I guess either this or the others aren't good, don't you?

> +
> +static int nft_rule_expr_ct_set_xml_parse(struct nft_rule_expr *e, m=
xml_node_t *tree)
> +{
> +#ifdef XML_PARSING
> +       struct nft_expr_ct_set *ct_set =3D nft_expr_data(e);
> +       const char *uvalstr;
> +
> +       if (nft_mxml_num_parse(tree, "flags", MXML_DESCEND_FIRST, BAS=
E_DEC,
> +                              &ct_set->flags, NFT_TYPE_U16, NFT_XML_=
MAND) !=3D 0)
> +               return -1;

I see now that errno is not set anywhere in the error path of XML/JSON
expression parsing code.

I will patch nft_mxml_expr_parse() and nft_jansson_expr_parse().

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
