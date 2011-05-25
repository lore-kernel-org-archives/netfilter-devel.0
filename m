From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Provide family and protocol to make getaddrinfo happy
Date: Wed, 25 May 2011 15:41:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105251538090.17415@frira.zrqbmnf.qr>
References: <1306325786-16849-1-git-send-email-ljaenicke@innominate.com> <1306325786-16849-2-git-send-email-ljaenicke@innominate.com> <alpine.LNX.2.01.1105251423280.22697@frira.zrqbmnf.qr> <20110525132629.GA17366@lutz.bln.innominate.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59468 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab1EYNlS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2011 09:41:18 -0400
In-Reply-To: <20110525132629.GA17366@lutz.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-05-25 15:26, Lutz Jaenicke wrote:
>On Wed, May 25, 2011 at 02:31:05PM +0200, Jan Engelhardt wrote:
>>=20
>> >getaddrinfo() will fail for numeric port numbers if neither
>> >the socket type (stream/datagram) nor the protocol is
>> >provided. [in uclibc]
>
>As I wrote in my introduction for the patch (which has not yet made it=
 to the
>mailing list), other C libraries behave like uClibc:
>* http://gitorious.org/0xdroid/bionic/blobs/9ab75d4cc803e91b7f1b656ffb=
e2ad32c52a86f9/libc/netbsd/net/getaddrinfo.c                           =
                    =20
>  -> look for "ANDROID-SPECIFIC CHANGE TO MATCH GLIBC" :-)
>* http://www.freebsd.org/cgi/query-pr.cgi?pr=3D51827
>* Especially I like
>  http://www.openbsd.org/cgi-bin/cvsweb/~checkout~/src/lib/libc/net/ge=
taddrinfo.c?rev=3D1.72;content-type=3Dtext%2Fplain
>  which in the text says=20
>	/*
>	 * check for special cases.  (1) numeric servname is disallowed if
>	 * socktype/protocol are left unspecified. (2) servname is disallowed
>	 * for raw and other inet{,6} sockets.
>	 */
>  (and I took this as a reference until now) but later in get_portmatc=
h():
>  	case SOCK_DGRAM:
>	case SOCK_STREAM:
>	case ANY:
>		allownumeric =3D 1;

So in other words, four libraries allow it, and one - =C2=B5clibc - has=
 a bug that
should be fixed.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
