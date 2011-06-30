From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 13:59:22 +0200
Message-ID: <4E0C651A.1000300@trash.net>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>	 <1309340843.2532.112.camel@edumazet-laptop>	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru> <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44473 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1F3L70 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 07:59:26 -0400
In-Reply-To: <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 30.06.2011 13:34, schrieb Eric Dumazet:
> Le jeudi 30 juin 2011 =C3=A0 11:36 +0400, Kuzin Andrey a =C3=A9crit :
>=20
>> Every day netfilter code become  more and more difficult to understa=
nd.=20
>> IPQ mechanism don't have
>> this problems, migration to NFQUEUE by simply modifications of funct=
ion=20
>> names in original program
>> code led to these problems. I think it very hard to find this error =
in=20
>> netfilter code and may be sometimes
>> NFQUEUE will be rewritten from scratch to NGQUEUE (next generation q=
ueue) ;)
>> I wrote this patch as simply as possible (one-hour solution) to solv=
e=20
>> the problem for the our paid services.
>> Early no one netfilter developer did not pay any attention to messag=
es=20
>> about this problem.
>>
>=20
> Wow wow wow...
>=20
> Maybe these netfilter guys you blame had some paid job to do at the t=
ime
> you sent your bug report ? Or only you have real paid services ?
>=20
> For the record, I also used NFQUEUE and never hit a single problem.
>=20
> Maybe I was just lucky, I dont know.
>=20
> Instead of trying to hide the bug, please be constructive and find a =
way
> to pinpoint the bug, so that we can fix it for good.

Thanks Eric, I agree. Give us data and we'll fix it if really is a bug.

The fact that the timeout patch apparently helps indicates that some
packets don't receive verdicts.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
