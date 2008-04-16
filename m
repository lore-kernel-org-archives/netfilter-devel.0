From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Something like a bug
Date: Wed, 16 Apr 2008 15:47:56 +0200
Message-ID: <4806038C.6090502@netfilter.org>
References: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>  <4804CE07.3060507@netfilter.org> <dbdd0cc00804150900r64924253g14e0d52a5d14ff1c@mail.gmail.com> <alpine.LNX.1.10.0804151921170.13202@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Rick Xu <rickxbx@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40737 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751333AbYDPNsN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2008 09:48:13 -0400
In-Reply-To: <alpine.LNX.1.10.0804151921170.13202@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Tuesday 2008-04-15 18:00, Rick Xu wrote:
>>> Index: configure.in
>>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>>  --- configure.in        (revisi=C3=B3n: 7400)
>>>  +++ configure.in        (copia de trabajo)
>>>  @@ -4,7 +4,7 @@
>>>
>>>   AC_CANONICAL_SYSTEM
>>>
>>>  -AM_INIT_AUTOMAKE(libnfnetlink, 0.0.33)
>>>  +AM_INIT_AUTOMAKE(libnfnetlink, 0.0.34)
>>>
>>>   AC_PROG_CC
>>>   AC_EXEEXT
>=20
> Just btw because I noticed it. AM_INIT_AUTOMAKE usually
> takes 0 arguments, as per `info automake`:
>=20
>      The second, deprecated, form of `AM_INIT_AUTOMAKE' has two requi=
red
>      arguments: the package and the version number.  This form is
>      obsolete because the PACKAGE and VERSION can be obtained from
>      Autoconf's `AC_INIT' macro (which itself has an old and a new
>      form).

You seem to be more familiar with autostuff than me. I'd appreciate a
patch for this. Thanks.

--=20
"Los honestos son inadaptados sociales" -- Les Luthiers
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
