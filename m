From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: high latency with ipset-4.2 and 2.6.27.45 kernel.
Date: Tue, 22 Jun 2010 10:51:28 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1006221046110.13935@obet.zrqbmnf.qr>
References: <AANLkTimikytx8wGmEtC0gbOng_vAyDUPVHRJWMmnm6p9@mail.gmail.com> <alpine.DEB.2.00.1006211518090.32109@blackhole.kfki.hu> <AANLkTin1A2whIiaHWa4k0NZcdGqJhpk511hBSuLZd-pB@mail.gmail.com> <alpine.LSU.2.01.1006211846000.17820@obet.zrqbmnf.qr>
 <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: krunal patel <krunal.raj@gmail.com>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org
To: Nishit Shah <nsshah.82@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55395 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753938Ab0FVIv3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Jun 2010 04:51:29 -0400
In-Reply-To: <AANLkTil7HS75O5WO3Bxz1S7CF5D4r1om0iWD8vSF3bF6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2010-06-22 07:41, Nishit Shah wrote:
>> On Monday 2010-06-21 17:18, krunal patel wrote:
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set ! --set tes=
tip src
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set ! --set tes=
tip src
>>>>> =C2=A0 =C2=A0 =C2=A0 =C2=A0iptables -A FORWARD -m set --set testi=
p src
>>
>> No question that reevaluating the same thing over and over
>> increases runtime...
>
>Well, that is not the case. With 2.6.18.8 latency is same as 6 msecs.

I think what you see could be noise.

See commit 848484c08cb4ad161074262994410387585259ff in
xtables-addons. There I needed 3000 ping packets (sent with ping -f)
*and* a linear search of 10000 ranges to get above 2000 msec overhead
for a single rule.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
