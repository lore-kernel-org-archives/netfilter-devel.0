From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: netfilter queue throughput slowdown
Date: Thu, 30 Jun 2011 19:45:19 +0200
Message-ID: <1309455919.2515.3.camel@edumazet-laptop>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>
	 <1309340843.2532.112.camel@edumazet-laptop>
	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>
	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>
	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>
	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C651A.1000300@trash.net>
	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
	 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>
	 <1309453730.5846.31.camel@tiger.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, sclark46@earthlink.net,
	Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:36989 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917Ab1F3RpX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jun 2011 13:45:23 -0400
Received: by wwg11 with SMTP id 11so1020846wwg.1
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jun 2011 10:45:21 -0700 (PDT)
In-Reply-To: <1309453730.5846.31.camel@tiger.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le jeudi 30 juin 2011 =C3=A0 19:07 +0200, Eric Leblond a =C3=A9crit :

> As the verdict failure is bound to occur in a high load time,
> retransmission of the verdict (which is necessary) will not help the
> system to recover. Userspace has to deal with it but it has another
> consequences which is that userspace software may suffer of case wher=
e
> successive failures occurs.
>=20
> In this scope, Florian's patch "netfilter: nfqueue: batch verdict
> support" could be really useful. It could be used by userspace to
> trigger an decide on all stucked packets. Issuing a massive ACCEPT co=
uld
> lead to dynosaurus packet coming from ancient time but it could be ok=
 if
> batch occurs enough often.
>=20
> Is there a plan to accept it in mainstream ?

Given that apparently some apps are not aware some of their verdicts ar=
e
lost, I consider the BATCH idea would be a bad idea, unless DROP is
used.

If you have any doubt, only sane thing is to drop packets, not accept
them.

Maybe a single queue flag is needed : DROP_OLD_PACKETS, if user
application is handling packets in order.

Every time a verdict is given by application, automatically DROP all
previous un-verdicted packets.



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
