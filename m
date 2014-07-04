From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nftables PATCH] Fix segmentation fault in batch operation
Date: Fri, 4 Jul 2014 14:08:12 +0200
Message-ID: <CAOkSjBg8a27Qb+1fCb3pC=Bai8uOhd=ELewdzsVL6oh1QLLOww@mail.gmail.com>
References: <1404475150-18224-1-git-send-email-ycnian@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Yanchuan Nian <ycnian@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:40812 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbaGDMIe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2014 08:08:34 -0400
Received: by mail-lb0-f181.google.com with SMTP id p9so1119241lbv.12
        for <netfilter-devel@vger.kernel.org>; Fri, 04 Jul 2014 05:08:32 -0700 (PDT)
In-Reply-To: <1404475150-18224-1-git-send-email-ycnian@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 4 July 2014 13:59, Yanchuan Nian <ycnian@gmail.com> wrote:
[...]
> diff --git a/src/mnl.c b/src/mnl.c
> index a816106..c934e57 100644
> --- a/src/mnl.c
> +++ b/src/mnl.c
> @@ -89,7 +89,7 @@ static struct mnl_nlmsg_batch *mnl_batch_alloc(void=
)
>         static char *buf;
>
>         /* libmnl needs higher buffer to handle batch overflows */
> -       buf =3D xmalloc(BATCH_PAGE_SIZE + getpagesize());
> +       buf =3D xzalloc(BATCH_PAGE_SIZE + getpagesize());
>         return mnl_nlmsg_batch_start(buf, BATCH_PAGE_SIZE);
>  }
>

Good one Yanchuan. Thanks.

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
