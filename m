From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Help: Cycle through iptables rules
Date: Wed, 26 May 2010 11:47:40 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1005261142470.8695@obet.zrqbmnf.qr>
References: <AANLkTiliv-YLViJ9hgnRY_rnFYYIfjnupo-NOE9tru1y@mail.gmail.com> <1274861468.2672.9.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Felipe W Damasio <felipewd@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38617 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756684Ab0EZJrl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 May 2010 05:47:41 -0400
In-Reply-To: <1274861468.2672.9.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-05-26 10:11, Eric Dumazet wrote:
>Le mardi 25 mai 2010 =C3=A0 21:31 -0300, Felipe W Damasio a =C3=A9crit=
 :
>>
>>   So I'd like to know if I can cycle through all these rules based o=
n
>> the number of connections.
>>=20
>>   Is it possible?
>>=20
>>   If it isn't currently, can this functionality be added? How can I =
help?
>
>So all connections are coming from the NAT device, with a single IP, a=
nd
>ports from say 30000 to 60000 (check your NAT device)
>
>iptables -t mangle -A PREROUTING -i eth0 -p tcp --dport 80 -m multipor=
t=20
>--source-ports 30000:31000 -j TPROXY --tproxy-mark 0x1/0x1 --on-port 3=
127

There may be a non-uniform distribution so it may not be advisable.
Instead perhaps,

-A PREROUTING -m conntrack --ctstate NEW -j extrachain
for (I =3D 0; I < N; ++I)
	-A extrachain -m statistic --mode nth --every I \
		-j CONNMARK --set-mark I
for (I =3D 0; I < N; ++I)
	-A PREROUTING -m connmark --mark I -j TPROXY \
		--tproxy-mark I/0xff --on-port I+3127
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
