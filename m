From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH] Provide family and protocol to make getaddrinfo happy
Date: Wed, 25 May 2011 16:06:37 +0200
Message-ID: <20110525140636.GA21259@lutz.bln.innominate.local>
References: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com>
 <1306325786-16849-2-git-send-email-ljaenicke@innominate.com>
 <alpine.LNX.2.01.1105251423280.22697@frira.zrqbmnf.qr>
 <20110525132629.GA17366@lutz.bln.innominate.local>
 <alpine.LNX.2.01.1105251538090.17415@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host2.bln.innominate.com ([77.245.32.75]:35669 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157Ab1EYOGi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 10:06:38 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1105251538090.17415@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 25, 2011 at 03:41:17PM +0200, Jan Engelhardt wrote:
>=20
> On Wednesday 2011-05-25 15:26, Lutz Jaenicke wrote:
> >On Wed, May 25, 2011 at 02:31:05PM +0200, Jan Engelhardt wrote:
> >>=20
> >> >getaddrinfo() will fail for numeric port numbers if neither
> >> >the socket type (stream/datagram) nor the protocol is
> >> >provided. [in uclibc]
> >
> >As I wrote in my introduction for the patch (which has not yet made =
it to the
> >mailing list), other C libraries behave like uClibc:
> >* http://gitorious.org/0xdroid/bionic/blobs/9ab75d4cc803e91b7f1b656f=
fbe2ad32c52a86f9/libc/netbsd/net/getaddrinfo.c                         =
                      =20
> >  -> look for "ANDROID-SPECIFIC CHANGE TO MATCH GLIBC" :-)
> >* http://www.freebsd.org/cgi/query-pr.cgi?pr=3D51827
> >* Especially I like
> >  http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/lib/libc/net/=
getaddrinfo.c?rev=3D1.72;content-type=3Dtext%2Fplain
> >  which in the text says=20
> >	/*
> >	 * check for special cases.  (1) numeric servname is disallowed if
> >	 * socktype/protocol are left unspecified. (2) servname is disallow=
ed
> >	 * for raw and other inet{,6} sockets.
> >	 */
> >  (and I took this as a reference until now) but later in get_portma=
tch():
> >  	case SOCK_DGRAM:
> >	case SOCK_STREAM:
> >	case ANY:
> >		allownumeric =3D 1;
>=20
> So in other words, four libraries allow it, and one - =B5clibc - has =
a bug that
> should be fixed.

I am not sure it is actually a bug. RFC 3493 does not specify this way
or the other. It just seems that most other C libraries changed the
behavior from "not accepted" to "accepted" in 2009 such that these days
the consensus seems to be this way.

Best regards,
	Lutz
--=20
Dr.-Ing. Lutz J=E4nicke
CTO
Innominate Security Technologies AG  /protecting industrial networks/
tel: +49.30.921028-200
fax: +49.30.921028-020
Rudower Chaussee 13
D-12489 Berlin, Germany
www.innominate.com

Register Court: AG Charlottenburg, HR B 81603
Management Board: Dirk Seewald
Chairman of the Supervisory Board: Volker Bibelhausen
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
