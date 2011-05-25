From: Lutz Jaenicke <ljaenicke@innominate.com>
Subject: Re: [PATCH] Provide family and protocol to make getaddrinfo happy
Date: Wed, 25 May 2011 15:26:29 +0200
Message-ID: <20110525132629.GA17366@lutz.bln.innominate.local>
References: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com>
 <1306325786-16849-2-git-send-email-ljaenicke@innominate.com>
 <alpine.LNX.2.01.1105251423280.22697@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.innominate.com ([77.245.32.75]:46221 "EHLO
	home.innominate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366Ab1EYN0b (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:26:31 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1105251423280.22697@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 25, 2011 at 02:31:05PM +0200, Jan Engelhardt wrote:
> On Wednesday 2011-05-25 14:16, Lutz Jaenicke wrote:
>=20
> >getaddrinfo() will fail for numeric port numbers if neither
> >the socket type (stream/datagram) nor the protocol is
> >provided.
> >Since matches on ports only make sense if the protocol is known
> >we "just" have to derive the protocol number from the information
> >already collected.
>=20
> Not quite; ports are also possible with -m ipvs and -m conntrack, whi=
ch=20
> do not require -p tcp/udp.
>
>=20
> If someone speicifies a numeric port to getaddrinfo, I just want the=20
> thing encoded in struct sockaddr_XX.sXX_port - it does not need to kn=
ow=20
> the particular L4 proto, or the service's text-based name to do that =
-=20
> which is most likely why glibc allows it.

Manual pages may not be the ultimate reference about the reasoning
on why something is implemented which way. Nevertheless let's see:

       Given node and service, which identify an Internet host and a  s=
ervice,
       getaddrinfo()  returns  one  or more addrinfo structures, each o=
f which
       contains an Internet address that can be specified in a call to =
bind(2)
       or  connect(2).

Taking this information "as is" actually means that using getaddrinfo()
the way it is done is at least stretching the functionality...

As I wrote in my introduction for the patch (which has not yet made it =
to the
mailing list), other C libraries behave like uClibc:
* http://gitorious.org/0xdroid/bionic/blobs/9ab75d4cc803e91b7f1b656ffbe=
2ad32c52a86f9/libc/netbsd/net/getaddrinfo.c                            =
                   =20
  -> look for "ANDROID-SPECIFIC CHANGE TO MATCH GLIBC" :-)
* http://www.freebsd.org/cgi/query-pr.cgi?pr=3D51827
* Especially I like
  http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/lib/libc/net/get=
addrinfo.c?rev=3D1.72;content-type=3Dtext%2Fplain
  which in the text says=20
	/*
	 * check for special cases.  (1) numeric servname is disallowed if
	 * socktype/protocol are left unspecified. (2) servname is disallowed
	 * for raw and other inet{,6} sockets.
	 */
  (and I took this as a reference until now) but later in get_portmatch=
():
  	case SOCK_DGRAM:
	case SOCK_STREAM:
	case ANY:
		allownumeric =3D 1;

> I would like to have an opinion on that from =B5clibc preferably..

Seems uClibc is outdated wrt adjusting the behavior with other C librar=
ies...

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
