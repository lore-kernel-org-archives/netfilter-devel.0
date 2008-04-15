From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Something like a bug
Date: Tue, 15 Apr 2008 19:21:51 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804151921170.13202@fbirervta.pbzchgretzou.qr>
References: <dbdd0cc00804140027y54a00ca7pdef3b091dde33bf6@mail.gmail.com>  <4804CE07.3060507@netfilter.org> <dbdd0cc00804150900r64924253g14e0d52a5d14ff1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Rick Xu <rickxbx@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40584 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756545AbYDORVw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Apr 2008 13:21:52 -0400
In-Reply-To: <dbdd0cc00804150900r64924253g14e0d52a5d14ff1c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-04-15 18:00, Rick Xu wrote:
>> Index: configure.in
>>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>>  --- configure.in        (revisi=C3=B3n: 7400)
>>  +++ configure.in        (copia de trabajo)
>>  @@ -4,7 +4,7 @@
>>
>>   AC_CANONICAL_SYSTEM
>>
>>  -AM_INIT_AUTOMAKE(libnfnetlink, 0.0.33)
>>  +AM_INIT_AUTOMAKE(libnfnetlink, 0.0.34)
>>
>>   AC_PROG_CC
>>   AC_EXEEXT

Just btw because I noticed it. AM_INIT_AUTOMAKE usually
takes 0 arguments, as per `info automake`:

     The second, deprecated, form of `AM_INIT_AUTOMAKE' has two require=
d
     arguments: the package and the version number.  This form is
     obsolete because the PACKAGE and VERSION can be obtained from
     Autoconf's `AC_INIT' macro (which itself has an old and a new
     form).

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
