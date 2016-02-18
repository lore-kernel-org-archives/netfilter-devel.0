From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] conntrackd: Disable runtime systemd support by default
Date: Thu, 18 Feb 2016 08:54:16 +0100
Message-ID: <CAOkSjBg1cr9tQD_SPhZxN2TBj9z6AfRJB6J5htR3vTdzvaJirg@mail.gmail.com>
References: <1455708361-3143-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:36688 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933509AbcBRHyh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2016 02:54:37 -0500
Received: by mail-wm0-f46.google.com with SMTP id g62so13401009wme.1
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Feb 2016 23:54:36 -0800 (PST)
In-Reply-To: <1455708361-3143-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17 February 2016 at 12:26, Pablo Neira Ayuso <pablo@netfilter.org> w=
rote:
> By default, conntrackd is compiled with no built-in systemd support.
> This patch updates the default runtime behaviour to be consistent
> with what ./configure provides by default.
>
> Thus, users should explicitly indicate "Systemd On" in their configur=
ation
> file to enable this. This shouldn't cause any problem to old users of
> conntrackd.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: updates grammar to handle "On" case accordingly.
>
>  conntrackd.conf.5                |  4 ++--
>  doc/stats/conntrackd.conf        |  4 ++--
>  doc/sync/alarm/conntrackd.conf   |  4 ++--
>  doc/sync/ftfw/conntrackd.conf    |  4 ++--
>  doc/sync/notrack/conntrackd.conf |  4 ++--
>  src/read_config_yy.y             | 10 ++--------
>  6 files changed, 12 insertions(+), 18 deletions(-)
>
[...]
> diff --git a/src/read_config_yy.y b/src/read_config_yy.y
> index 58ad2d0..cc0eb18 100644
> --- a/src/read_config_yy.y
> +++ b/src/read_config_yy.y
> @@ -1126,11 +1126,8 @@ general_line: hashsize
>             | systemd
>             ;
>
> -systemd: T_SYSTEMD T_ON { /* already enabled in init_config() */ };
> -systemd: T_SYSTEMD T_OFF
> -{
> -       conf.systemd =3D 0;
> -};
> +systemd: T_SYSTEMD T_ON                { conf.systemd =3D 1; };
> +systemd: T_SYSTEMD T_OFF       { conf.systemd =3D 0; };
>
>  netlink_buffer_size: T_BUFFER_SIZE T_NUMBER
>  {
> @@ -1864,9 +1861,6 @@ init_config(char *filename)
>         CONFIG(stats).syslog_facility =3D -1;
>         CONFIG(netlink).subsys_id =3D -1;
>
> -       /* enable systemd by default */
> -       CONFIG(systemd) =3D 1;
> -

In src/systemd.c we check several times if (CONFIG(systemd) =3D=3D 0), =
so
I think the value should be initialized to something.


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
