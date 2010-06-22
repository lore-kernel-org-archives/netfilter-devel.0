From: Nishit Shah <nsshah.82@gmail.com>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Tue, 22 Jun 2010 11:11:14 +0530
Message-ID: <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com>
	<alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu>
	<AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com>
	<alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: krunal patel <krunal.raj@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52158 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0FVFlP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:41:15 -0400
Received: by vws9 with SMTP id 9so498436vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2010 22:41:14 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jun 21, 2010 at 10:16 PM, Jan Engelhardt <jengelh@medozas.de> w=
rote:
>
> On Monday 2010-06-21 17:18, krunal patel wrote:
>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set ! --set testip src
>>>> =A0 =A0 =A0 =A0iptables -A FORWARD -m set --set testip src
>>>
>>> You do not measure ipset definitely. Because there is no target in =
the
>>> rules, all of them are evaluated one after another, regardless of t=
he
>>> previous ones: netfilter just increases the packet/byte counters of=
 the
>>> matching rules, but continues by processing the next rule(s).
>>
>>No, we are measuring only ipset. What we are suspecting is, as number
>>of ipset matches increases in packet path latency is increasing.
>>
>>1000 msecs is just by adding 1 more rule. 3 rules took it to around
>>3000 to 4000 msecs.
>
> No question that reevaluating the same thing over and over
> increases runtime...

Well, that is not the case. With 2.6.18.8 latency is same as 6 msecs.
i.e. it is not increasing with number of ipset rules. Also, if our
traffic load is around 1 to 1.4 Gbps, even in 2.6.27.45 we are not
experiencing the latency with increasing the number of rules.

Rgds,
Nishit Shah.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
