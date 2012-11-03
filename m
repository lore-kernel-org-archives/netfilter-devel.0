From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 3/4] Add configure flag to disable NFLOG build
Date: Sat, 03 Nov 2012 17:02:00 +0100
Message-ID: <1351958520.11805.2.camel@tourtet>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
	 <1351942382-24791-4-git-send-email-eric@regit.org>
	 <alpine.LNX.2.01.1211031541140.14935@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50511 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330Ab2KCQCI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:02:08 -0400
In-Reply-To: <alpine.LNX.2.01.1211031541140.14935@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Le samedi 03 novembre 2012 =C3=A0 15:41 +0100, Jan Engelhardt a =C3=A9c=
rit :
>=20
> On Saturday 2012-11-03 12:33, Eric Leblond wrote:
> >=20
> >+if BUILD_NFLOG
> > pkglib_LTLIBRARIES =3D ulogd_inppkt_NFLOG.la ulogd_inppkt_ULOG.la \
> >                        ulogd_inppkt_UNIXSOCK.la
> >=20
> > ulogd_inppkt_NFLOG_la_SOURCES =3D ulogd_inppkt_NFLOG.c
> > ulogd_inppkt_NFLOG_la_LDFLAGS =3D -avoid-version -module $(LIBNETFI=
LTER_LOG_LIBS)
> > ulogd_inppkt_NFLOG_la_CFLAGS =3D $(AM_CFLAGS) $(LIBNETFILTER_LOG_CF=
LAGS)
> >+else
> >+pkglib_LTLIBRARIES =3D ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.l=
a
> >+endif
>=20
> You can use
>=20
>   pkglib_LTLIBRARIES =3D ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.l=
a
>   if BUILD_NFLOG
>   pkglib_LTLIBRARIES +=3D ulogd_inppkt_NFLOG.la
>   ...
>   endif
>=20
> So that ulogd_inppkt_ULOG.la ulogd_inppkt_UNIXSOCK.la
> does not have to be listed twice.

You're right that's a better construction.

BR,
--
Eric


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
