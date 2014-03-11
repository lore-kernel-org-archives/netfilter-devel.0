From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 1/2] src/rule: Removed mandatory attribute
 printing in rules
Date: Tue, 11 Mar 2014 20:59:56 +0100
Message-ID: <CAOkSjBhB8x0wWaP0RYn5ytuJ8Hs1HL7=6rRK-AOKqUe=hpsOrA@mail.gmail.com>
References: <20140309125959.23270.43422.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:55869 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755552AbaCKUAU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2014 16:00:20 -0400
Received: by mail-lb0-f181.google.com with SMTP id c11so6037495lbj.12
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Mar 2014 13:00:19 -0700 (PDT)
In-Reply-To: <20140309125959.23270.43422.stgit@Ph0enix>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Alvaro,

I found a small issue in your patch, see below.

Except for this, the patch looks good to me.

On 9 March 2014 13:59, Alvaro Neira Ayuso <alvaroneay@gmail.com> wrote:
> @@ -865,15 +904,42 @@ static int nft_rule_snprintf_xml(char *buf, siz=
e_t size, struct nft_rule *r,
>         return offset;
>  }
>
> -static int nft_rule_snprintf_default(char *buf, size_t size, struct =
nft_rule *r,
> +static int nft_rule_snprintf_default(char *buf, size_t size, struct =
nft_rule *r,
>                                      uint32_t type, uint32_t flags)
>  {
>         struct nft_rule_expr *expr;
>         int ret, len =3D size, offset =3D 0, i;
>
> -       ret =3D snprintf(buf, len, "%s %s %s %"PRIu64" %"PRIu64"\n",
> -                       nft_family2str(r->family), r->table, r->chain=
,
> -                       r->handle, r->position);
> +       if (r->flags & (1 << NFT_RULE_ATTR_FAMILY)) {
> +               ret =3D snprintf(buf+offset, len, "%s ",
> +                              nft_family2str(r->family));
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +
> +       if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
> +               ret =3D snprintf(buf+offset, len, "%s ",
> +                              r->table);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +
> +       if (r->flags & (1 << NFT_RULE_ATTR_CHAIN)) {
> +               ret =3D snprintf(buf+offset, len, "%s ",
> +                              r->chain);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }
> +       if (r->flags & (1 << NFT_RULE_ATTR_TABLE)) {
> +               ret =3D snprintf(buf+offset, len, "%llu ",
> +                              (unsigned long long)r->handle);
> +               SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       }

Here you check the table attr but print handle.

Regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
