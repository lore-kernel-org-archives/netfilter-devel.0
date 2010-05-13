From: Zerouali Mehdi <mehdi.zerouali@insa-lyon.fr>
Subject: Re: Problem compiling libipq example
Date: Thu, 13 May 2010 09:49:20 +0200
Message-ID: <0a43c269444f41c15ca8923190f433ca@mail.insa-lyon.fr>
References: <79f8595aaa42b469ae2e273b8a1a27f2@mail.insa-lyon.fr> <AANLkTimepNQyRqTryraxJuAPV6_zgt3CkC0beCd86O-z@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Mistick Levi <gmistick@gmail.com>,
	Netfilter Mailing list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from criges14.insa-lyon.fr ([134.214.76.242]:47274 "EHLO
	smtp.insa-lyon.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab0EMHtW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 May 2010 03:49:22 -0400
In-Reply-To: <AANLkTimepNQyRqTryraxJuAPV6_zgt3CkC0beCd86O-z@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 May 2010 01:42:30 +0300, Mistick Levi <gmistick@gmail.com>
wrote:
> Hi,
> You are missing the package: iptables-dev
> (http://packages.ubuntu.com/karmic/iptables-dev), and you need it for
> libipq development.
> For information about NF_QUEUE(ip_queue successor) Check this link:
> http://www.nufw.org/doc/libnetfilter_queue/modules.html - great
> documentation.
Thanks for your answer, but I already installed the package iptables-de=
v !
This is reallyt=3D weird, since I think that I installed all the requir=
ed
components for libipq development.
I really don't know what to do now


> Cheers,
> Yechiel Levi
>=20
> also, you are missing one important package:
> iptables-dev
>=20
> On Thu, May 13, 2010 at 12:16 AM, Zerouali Mehdi
> <mehdi.zerouali@insa-lyon.fr> wrote:
>> Hello all,
>>
>> I am using this mailing list as the last chance to get a solution to=
 my
>> problem. I hope my simple question is not going to bother you too mu=
ch.
>>
>> I am trying to compile and run the simpliest program that uses libip=
q,
>> the
>> man example program.
>>
>> When I try to compile it, I get the following error code:
>>
>> In file included from example.c:2:
>> /usr/include/linux/netfilter.h:55: error: field =E2=80=98in=E2=80=99=
 has incomplete
type
>> /usr/include/linux/netfilter.h:56: error: field =E2=80=98in6=E2=80=99=
has incomplete
type
>>
>> It looks like there is a problem with the netfilter header, that is =
not
>> able to load the in.h and in6.h librairies.
>>
>> I installed all the necessary tools:
>> iptables 1.4.7
>> libnetfilter_queue 0.0.17 (the actual successor of ip_queue)
>> libnfnetlink 1.0.0
>>
>> I am using Ubuntu 9.10, with the 2.6.31-14 kernel.
>>
>> I of course searched for any solutions, and found that this problem =
has
>> been encountered in the past. However, I didn't get any relevant
>> information. Thanks in advance for your precious advices.
>>
>> Cheers,
>>
>> --
>> Mehdi Zerouali
>> INSA Lyon Student
>> KTH Stockholm Student
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> netfilter-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>

Thank you for your precious time
--=20
Mehdi Zerouali
INSA Lyon Student
KTH Stockholm Student
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
