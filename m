From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 2/2] src: expr: log: Do not print unset values in xml.
Date: Thu, 29 May 2014 14:00:52 +0200
Message-ID: <CAOkSjBhs4q2KxebcVicg5U+f=T8=UA4JkUb6nHysPndgxwHHRg@mail.gmail.com>
References: <1401362800-30749-1-git-send-email-anarey@gmail.com> <1401362800-30749-3-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:38706 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757100AbaE2MBN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 May 2014 08:01:13 -0400
Received: by mail-la0-f51.google.com with SMTP id gf5so122299lab.38
        for <netfilter-devel@vger.kernel.org>; Thu, 29 May 2014 05:01:12 -0700 (PDT)
In-Reply-To: <1401362800-30749-3-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29 May 2014 13:26, Ana Rey <anarey@gmail.com> wrote:
> It changes the parse and the snprint functions to omit unset values.
>

Hi Ana,

I like your patches. A minor comment below.

> @@ -209,32 +209,25 @@ static int nft_rule_expr_log_xml_parse(struct n=
ft_rule_expr *e,
>
>         prefix =3D nft_mxml_str_parse(tree, "prefix", MXML_DESCEND_FI=
RST,
>                                     NFT_XML_MAND, err);
> -       if (prefix =3D=3D NULL)
> -               return -1;
> -
> -       log->prefix =3D strdup(prefix);
> -       e->flags |=3D (1 << NFT_EXPR_LOG_PREFIX);
> +       if (prefix !=3D NULL) {
> +               log->prefix =3D strdup(prefix);
> +               e->flags |=3D (1 << NFT_EXPR_LOG_PREFIX);
> +       }
>

I guess it's time to switch here to nft_expr_attr_set_*() functions.
It was my fault to not use the shortcuts.
I think shortcuts are less error prone and save some lines of code.

Like the JSON parsing code:

if (prefix !=3D NULL)
  nft_rule_expr_set_str(e, NFT_EXPR_LOG_PREFIX, prefix);

BTW, looking at how JSON does it [0], there the prefix element is
mandatory. I think we need to be consistent in both formats, so I
would recommend an additional patch to make prefix optional in the
JSON parser.

regards.

[0] http://git.netfilter.org/libnftnl/tree/src/expr/log.c#n171
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
