From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 13:34:12 +0200
Message-ID: <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45200 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754919Ab1F3JeN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 05:34:13 -0400
Received: by wyg8 with SMTP id 8so1410425wyg.19
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 02:34:12 -0700 (PDT)
In-Reply-To: <4E0C278B.7010403@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 30 juin 2011 =C3=A0 11:36 +0400, Kuzin Andrey a =C3=A9crit :

> Every day netfilter code become  more and more difficult to understan=
d.=20
> IPQ mechanism don't have
> this problems, migration to NFQUEUE by simply modifications of functi=
on=20
> names in original program
> code led to these problems. I think it very hard to find this error i=
n=20
> netfilter code and may be sometimes
> NFQUEUE will be rewritten from scratch to NGQUEUE (next generation qu=
eue) ;)
> I wrote this patch as simply as possible (one-hour solution) to solve=
=20
> the problem for the our paid services.
> Early no one netfilter developer did not pay any attention to message=
s=20
> about this problem.
>=20

Wow wow wow...

Maybe these netfilter guys you blame had some paid job to do at the tim=
e
you sent your bug report ? Or only you have real paid services ?

=46or the record, I also used NFQUEUE and never hit a single problem.

Maybe I was just lucky, I dont know.

Instead of trying to hide the bug, please be constructive and find a wa=
y
to pinpoint the bug, so that we can fix it for good.

A timeout of 20 seconds, on a machine receiving 100.000 packets per
second would not help anyway...



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
