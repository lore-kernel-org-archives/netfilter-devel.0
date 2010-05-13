From: Zerouali Mehdi <mehdi.zerouali@insa-lyon.fr>
Subject: Re: Problem compiling libipq example
Date: Thu, 13 May 2010 11:43:52 +0200
Message-ID: <8fc7f30248c316fb6d5feebc35d127e7@mail.insa-lyon.fr>
References: <79f8595aaa42b469ae2e273b8a1a27f2@mail.insa-lyon.fr> <alpine.LSU.2.01.1005130957260.6609@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Mailing list <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from criges14.insa-lyon.fr ([134.214.76.242]:59103 "EHLO
	smtp.insa-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab0EMJny (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 05:43:54 -0400
In-Reply-To: <alpine.LSU.2.01.1005130957260.6609@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 May 2010 09:58:02 +0200 (CEST), Jan Engelhardt
<jengelh@medozas.de> wrote:
> On Wednesday 2010-05-12 23:16, Zerouali Mehdi wrote:
>>
>>I am using this mailing list as the last chance to get a solution to =
my
>>problem. I hope my simple question is not going to bother you too muc=
h.
>>
>>I am trying to compile and run the simpliest program that uses libipq=
,
the
>>man example program.
>>
>>When I try to compile it, I get the following error code:
>>
>>In file included from example.c:2:
>>/usr/include/linux/netfilter.h:55: error: field =E2=80=98in=E2=80=99 =
has incomplete type
>>/usr/include/linux/netfilter.h:56: error: field =E2=80=98in6=E2=80=99=
has incomplete type
>>
>>It looks like there is a problem with the netfilter header, that is n=
ot
>>able to load the in.h and in6.h librairies.
>=20
> in and in6 are not libraries, they are struct members, and you
> need #include <netinet/in.h> to get at their definition beforehand.

Thank you for your answer, this actually fixes my problem, I am now abl=
e
to compile the program successfuly !

Cheers ^^ !

> --
> To unsubscribe from this list: send the line "unsubscribe
netfilter-devel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=20
Mehdi Zerouali
INSA Lyon Student
KTH Stockholm Student
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
