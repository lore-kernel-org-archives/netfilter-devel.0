From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 2/5] src: set: Do not print unset values in xml
Date: Wed, 11 Jun 2014 18:14:40 +0200
Message-ID: <CAOkSjBjU6X1nZ1QY7TK08Ft22pZdSEQHmrrVxPWYCbUQuC+qrg@mail.gmail.com>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com> <1402501851-22208-4-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f180.google.com ([209.85.217.180]:39808 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755744AbaFKQPC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 12:15:02 -0400
Received: by mail-lb0-f180.google.com with SMTP id p9so4830655lbv.25
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 09:15:00 -0700 (PDT)
In-Reply-To: <1402501851-22208-4-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Ana,

a small thing below,

On 11 June 2014 17:50, Ana Rey <anarey@gmail.com> wrote:
[...]
> @@ -563,17 +560,26 @@ static int nft_set_elem_snprintf_xml(char *buf,=
 size_t size,
>  {
>         int ret, len =3D size, offset =3D 0, type =3D DATA_NONE;
>
> -       ret =3D snprintf(buf, size, "<set_elem>"
> -                               "<flags>%u</flags><key>",
> -                               e->set_elem_flags);
> +       ret =3D snprintf(buf, size, "<set_elem>");
>         SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
>
> -       ret =3D nft_data_reg_snprintf(buf+offset, len, &e->key,
> -                                   NFT_OUTPUT_XML, flags, DATA_VALUE=
);
> -       SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> +       if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS)) {
> +               ret =3D snprintf(buf, size, "<flags>%u</flags>",
> +                              e->set_elem_flags);

I think this snprintf call may overwrite the buffer, so you should use
snprintf(buf+offset, len, ...)

Maybe we need more testfiles, to cover all combinations of optionals
node-elements.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
