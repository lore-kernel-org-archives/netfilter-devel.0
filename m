From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Mon, 21 Jun 2010 18:46:51 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com> <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu> <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: krunal patel <krunal.raj@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:40158 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932633Ab0FUQqw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jun 2010 12:46:52 -0400
In-Reply-To: <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-06-21 17:18, krunal patel wrote:
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set ! --set testi=
p src
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set ! --set testi=
p src
>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set --set testip =
src
>>
>> You do not measure ipset definitely. Because there is no target in t=
he
>> rules, all of them are evaluated one after another, regardless of th=
e
>> previous ones: netfilter just increases the packet/byte counters of =
the
>> matching rules, but continues by processing the next rule(s).
>
>No, we are measuring only ipset. What we are suspecting is, as number
>of ipset matches increases in packet path latency is increasing.
>
>1000 msecs is just by adding 1 more rule. 3 rules took it to around
>3000 to 4000 msecs.

No question that reevaluating the same thing over and over
increases runtime...

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
