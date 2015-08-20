From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: update gitignore list
Date: Thu, 20 Aug 2015 13:46:39 +0200
Message-ID: <CAOkSjBgdJbigrwanoFOSfUzCt8gGLvyWHp0RoAqv9=YkWSq7Gg@mail.gmail.com>
References: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:35239 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbbHTLrA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 07:47:00 -0400
Received: by lahi9 with SMTP id i9so20728898lah.2
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Aug 2015 04:46:59 -0700 (PDT)
In-Reply-To: <1440069182-21380-1-git-send-email-vapier@gentoo.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 August 2015 at 13:13, Mike Frysinger <vapier@gentoo.org> wrote:
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  include/linux/netfilter_ipv4/ip_tables.h | 2 +-
>  iptables/.gitignore                      | 3 +++
>  libiptc/libiptc.c                        | 4 +++-
>  3 files changed, 7 insertions(+), 2 deletions(-)
>

Perhaps this change doesn't belong to this patch:

> diff --git a/include/linux/netfilter_ipv4/ip_tables.h b/include/linux=
/netfilter_ipv4/ip_tables.h
> index 38542b4..6c73f34 100644
> --- a/include/linux/netfilter_ipv4/ip_tables.h
> +++ b/include/linux/netfilter_ipv4/ip_tables.h
> @@ -212,7 +212,7 @@ struct ipt_get_entries {
>
>         /* The entries. */
>         struct ipt_entry entrytable[0];
> -};
> +} __attribute__((packed));
>
>  /* Helper functions */
>  static __inline__ struct xt_entry_target *


same here:

> diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
> index 9c07bb4..e8091eb 100644
> --- a/libiptc/libiptc.c
> +++ b/libiptc/libiptc.c
> @@ -1302,7 +1302,8 @@ struct xtc_handle *
>  TC_INIT(const char *tablename)
>  {
>         struct xtc_handle *h;
> -       STRUCT_GETINFO info;
> +       __attribute__((packed))
> +STRUCT_GETINFO info;
>         unsigned int tmp;
>         socklen_t s;
>         int sockfd;
> @@ -1350,6 +1351,7 @@ retry:
>
>         tmp =3D sizeof(STRUCT_GET_ENTRIES) + h->info.size;
>
> +printf("getsockopt(, %i)\n", tmp);
>         if (getsockopt(h->sockfd, TC_IPPROTO, SO_GET_ENTRIES, h->entr=
ies,
>                        &tmp) < 0)
>                 goto error;


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
