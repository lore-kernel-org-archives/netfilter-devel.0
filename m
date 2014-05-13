From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH] utils: fix buffer reallocation of nft_fprinft()
Date: Tue, 13 May 2014 11:11:24 +0200
Message-ID: <CAOkSjBjpMa4uipdXx8wzgLEDf8PcH_nXXZUNRJrjBkzSJQD-MQ@mail.gmail.com>
References: <20140509164547.7057.94412.stgit@nfdev.cica.es> <20140512155457.GB12698@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55417 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759460AbaEMJLq convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 05:11:46 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so39969lbi.23
        for <netfilter-devel@vger.kernel.org>; Tue, 13 May 2014 02:11:44 -0700 (PDT)
In-Reply-To: <20140512155457.GB12698@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 May 2014 17:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> You can use malloc instead. Just make sure that the string is always
> nul-terminated before printing, something like:
>
>                 bufsiz =3D ret + 1;
>                 buf =3D malloc(1, bufsiz);
>                 if (buf =3D=3D NULL)
>                         return -1;
>
>                 ret =3D snprintf(...
>                 if (ret < 0)
>                         ...
>         }
>
>         buf[ret] =3D '\0';
>         ... =3D fprintf(...
>

=46rom my man pages, I understand that snprintf() null-terminate the
string. This seems a bit redundant.
I think it's safe to don't include calloc() neither buf[ret] =3D '\0'.

I'm resending this patch with this assumption and your other request.

regards.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
