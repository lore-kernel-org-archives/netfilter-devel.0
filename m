From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: netfilter queue throughput slowdown
Date: Fri, 01 Jul 2011 18:39:24 +1200
Message-ID: <4E0D6B9C.1000501@treenet.co.nz>
References: <BANLkTinVcuMCoctfuZbUdd_6m8hpbtbwFA@mail.gmail.com>	 <1309340843.2532.112.camel@edumazet-laptop>	 <BANLkTi=C7J0u_kn6UknFsGAx9Z5kHUUBrw@mail.gmail.com>	 <1309342096.2532.116.camel@edumazet-laptop>  <4E0C15A3.9050609@yandex.ru>	 <1309416426.2532.119.camel@edumazet-laptop>  <4E0C278B.7010403@yandex.ru>	 <1309433652.1994.7.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4E0C651A.1000300@trash.net>	 <1309446900.1994.17.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>	 <4E0C8902.8070303@earthlink.net> <4E0C8D7F.3000902@trash.net>	 <1309453730.5846.31.camel@tiger.regit.org> <1309455919.2515.3.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Leblond <eric@regit.org>, Patrick McHardy <kaber@trash.net>,
	sclark46@earthlink.net, Kuzin Andrey <kuzinandrey@yandex.ru>,
	Anders Nilsson Plymoth <lanilsson@gmail.com>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:57902
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754890Ab1GAGjh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Jul 2011 02:39:37 -0400
In-Reply-To: <1309455919.2515.3.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 01/07/11 05:45, Eric Dumazet wrote:
> Le jeudi 30 juin 2011 =C3=A0 19:07 +0200, Eric Leblond a =C3=A9crit :
>
>> As the verdict failure is bound to occur in a high load time,
>> retransmission of the verdict (which is necessary) will not help the
>> system to recover. Userspace has to deal with it but it has another
>> consequences which is that userspace software may suffer of case whe=
re
>> successive failures occurs.
>>
>> In this scope, Florian's patch "netfilter: nfqueue: batch verdict
>> support" could be really useful. It could be used by userspace to
>> trigger an decide on all stucked packets. Issuing a massive ACCEPT c=
ould
>> lead to dynosaurus packet coming from ancient time but it could be o=
k if
>> batch occurs enough often.
>>
>> Is there a plan to accept it in mainstream ?
>
> Given that apparently some apps are not aware some of their verdicts =
are
> lost, I consider the BATCH idea would be a bad idea, unless DROP is
> used.
>
> If you have any doubt, only sane thing is to drop packets, not accept
> them.
>
> Maybe a single queue flag is needed : DROP_OLD_PACKETS, if user
> application is handling packets in order.
>
> Every time a verdict is given by application, automatically DROP all
> previous un-verdicted packets.
>

Would need to be paired with the option to do so for other verdicts.

What about an option of "verdict X on this packet Y on anything older" =
?

AYJ
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
