From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH] xtables-multi: fix absence of xml translator in IPv6-only builds
Date: Mon, 6 Jun 2011 18:28:39 -0700
Message-ID: <BANLkTik89yERazGmWNKm-FAzzSYa2PVqFZGo7+0rpiN1cWWTZw@mail.gmail.com>
References: <1307410029-6104-1-git-send-email-zenczykowski@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33652 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218Ab1FGB2j convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 21:28:39 -0400
Received: by pzk9 with SMTP id 9so2223596pzk.19
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jun 2011 18:28:39 -0700 (PDT)
In-Reply-To: <1307410029-6104-1-git-send-email-zenczykowski@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

=46YI, forgot to CC you.

2011/6/6 Maciej =C5=BBenczykowski <zenczykowski@gmail.com>:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>
> Commit de791ff2d7ac85fa0a707bbd6d98457bb18c5cbb didn't actually
> build the iptables-xml code into the xtables-multi binary...
>
> Change-Id: Ib2701ae27ef10c2ce23b13b97b2abb52b520cd95
> Signed-off-by: Maciej Zenczykowski <maze@google.com>
> ---
> =C2=A0Makefile.am =C2=A0 =C2=A0 =C2=A0| =C2=A0 =C2=A04 ++--
> =C2=A0iptables-multi.h | =C2=A0 =C2=A01 -
> =C2=A0iptables-xml.c =C2=A0 | =C2=A0 =C2=A04 ++--
> =C2=A0xtables-multi.c =C2=A0| =C2=A0 =C2=A06 ++++--
> =C2=A0xtables-multi.h =C2=A0| =C2=A0 =C2=A06 ++++++
> =C2=A05 files changed, 14 insertions(+), 7 deletions(-)
> =C2=A0create mode 100644 xtables-multi.h
>
> diff --git a/Makefile.am b/Makefile.am
> index 60ea83b..48f01d8 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -38,7 +38,7 @@ libxtables_la_CFLAGS =C2=A0=3D ${AM_CFLAGS} -DNO_SH=
ARED_LIBS=3D1
> =C2=A0libxtables_la_LIBADD =C2=A0=3D
> =C2=A0endif
>
> -xtables_multi_SOURCES =C2=A0=3D xtables-multi.c
> +xtables_multi_SOURCES =C2=A0=3D xtables-multi.c iptables-xml.c
> =C2=A0xtables_multi_CFLAGS =C2=A0 =3D ${AM_CFLAGS} -DIPTABLES_MULTI
> =C2=A0xtables_multi_LDFLAGS =C2=A0=3D -rdynamic
> =C2=A0xtables_multi_LDADD =C2=A0 =C2=A0=3D extensions/libext.a
> @@ -46,7 +46,7 @@ if ENABLE_STATIC
> =C2=A0xtables_multi_CFLAGS =C2=A0+=3D -DALL_INCLUSIVE
> =C2=A0endif
> =C2=A0if ENABLE_IPV4
> -xtables_multi_SOURCES +=3D iptables-save.c iptables-restore.c iptabl=
es-xml.c \
> +xtables_multi_SOURCES +=3D iptables-save.c iptables-restore.c \
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0iptables-standalone.c iptables.c
> =C2=A0xtables_multi_CFLAGS =C2=A0+=3D -DENABLE_IPV4
> =C2=A0xtables_multi_LDADD =C2=A0 +=3D libiptc/libip4tc.la extensions/=
libext4.a
> diff --git a/iptables-multi.h b/iptables-multi.h
> index a9912b0..a2bb878 100644
> --- a/iptables-multi.h
> +++ b/iptables-multi.h
> @@ -4,6 +4,5 @@
> =C2=A0extern int iptables_main(int, char **);
> =C2=A0extern int iptables_save_main(int, char **);
> =C2=A0extern int iptables_restore_main(int, char **);
> -extern int iptables_xml_main(int, char **);
>
> =C2=A0#endif /* _IPTABLES_MULTI_H */
> diff --git a/iptables-xml.c b/iptables-xml.c
> index aa98f75..5aa638c 100644
> --- a/iptables-xml.c
> +++ b/iptables-xml.c
> @@ -1,6 +1,6 @@
> =C2=A0/* Code to convert iptables-save format to xml format,
> =C2=A0* (C) 2006 Ufo Mechanic <azez@ufomechanic.net>
> - * based on iptables-restor (C) 2000-2002 by Harald Welte <laforge@g=
numonks.org>
> + * based on iptables-restore (C) 2000-2002 by Harald Welte <laforge@=
gnumonks.org>
> =C2=A0* based on previous code from Rusty Russell <rusty@linuxcare.co=
m.au>
> =C2=A0*
> =C2=A0* This code is distributed under the terms of GNU GPL v2
> @@ -14,7 +14,7 @@
> =C2=A0#include <stdarg.h>
> =C2=A0#include "iptables.h"
> =C2=A0#include "libiptc/libiptc.h"
> -#include "iptables-multi.h"
> +#include "xtables-multi.h"
> =C2=A0#include <xtables.h>
>
> =C2=A0#ifdef DEBUG
> diff --git a/xtables-multi.c b/xtables-multi.c
> index f8d56ce..8014d5f 100644
> --- a/xtables-multi.c
> +++ b/xtables-multi.c
> @@ -3,6 +3,8 @@
> =C2=A0#include <string.h>
> =C2=A0#include "xshared.h"
>
> +#include "xtables-multi.h"
> +
> =C2=A0#ifdef ENABLE_IPV4
> =C2=A0#include "iptables-multi.h"
> =C2=A0#endif
> @@ -19,9 +21,9 @@ static const struct subcommand multi_subcommands[] =
=3D {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{"save4", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 iptables_save_main},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{"iptables-restore", =C2=A0 =C2=A0iptables=
_restore_main},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{"restore4", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0iptables_restore_main},
> - =C2=A0 =C2=A0 =C2=A0 {"iptables-xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0ip=
tables_xml_main},
> - =C2=A0 =C2=A0 =C2=A0 {"xml4", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0iptables_xml_main},
> =C2=A0#endif
> + =C2=A0 =C2=A0 =C2=A0 {"iptables-xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0ip=
tables_xml_main},
> + =C2=A0 =C2=A0 =C2=A0 {"xml", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 iptables_xml_main},
> =C2=A0#ifdef ENABLE_IPV6
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{"ip6tables", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 ip6tables_main},
> =C2=A0 =C2=A0 =C2=A0 =C2=A0{"main6", =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ip6tables_main},
> diff --git a/xtables-multi.h b/xtables-multi.h
> new file mode 100644
> index 0000000..615724b
> --- /dev/null
> +++ b/xtables-multi.h
> @@ -0,0 +1,6 @@
> +#ifndef _XTABLES_MULTI_H
> +#define _XTABLES_MULTI_H 1
> +
> +extern int iptables_xml_main(int, char **);
> +
> +#endif /* _XTABLES_MULTI_H */
> --
> 1.7.3.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
