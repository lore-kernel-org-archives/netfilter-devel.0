From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH conntrackd] conntrackd: Disable systemd support by default
Date: Wed, 17 Feb 2016 08:50:26 +0100
Message-ID: <CAOkSjBgUyOd65kZZqg1JZDS1VbDk7mfixLghvMjdDofDsbHTuw@mail.gmail.com>
References: <1455649785-10958-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33356 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbcBQHur convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Feb 2016 02:50:47 -0500
Received: by mail-wm0-f41.google.com with SMTP id g62so224863376wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Feb 2016 23:50:46 -0800 (PST)
In-Reply-To: <1455649785-10958-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 February 2016 at 20:09, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> By default, conntrackd is compiled with no built-in systemd support.
> This patch updates the default runtime behaviour to be consistent
> with what ./configure provides by default.
>
> Thus, users should explicitly indicate "Systemd On" in their configur=
ation
> file to enable this.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
>  conntrackd.conf.5                | 4 ++--
>  doc/stats/conntrackd.conf        | 4 ++--
>  doc/sync/alarm/conntrackd.conf   | 4 ++--
>  doc/sync/ftfw/conntrackd.conf    | 4 ++--
>  doc/sync/notrack/conntrackd.conf | 4 ++--
>  src/read_config_yy.y             | 4 ++--
>  6 files changed, 12 insertions(+), 12 deletions(-)
>
[...]
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 58ad2d0..6052390 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -1864,8 +1864,8 @@ init_config(char *filename)
>         CONFIG(stats).syslog_facility =3D -1;
>         CONFIG(netlink).subsys_id =3D -1;
>
> -       /* enable systemd by default */
> -       CONFIG(systemd) =3D 1;
> +       /* disable systemd by default */
> +       CONFIG(systemd) =3D 0;
>
>         /* Initialize list of user-space helpers */
>         INIT_LIST_HEAD(&CONFIG(cthelper).list);

If we change this logic, there are a parser rules that need changes as =
well.

[...]
systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
systemd: T_SYSTEMD T_OFF
{
     conf.systemd =3D 0;
};
[...]

I agree with the patch, so

Acked-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
