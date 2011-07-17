From: =?UTF-8?B?S3J6eXN6dG9mIE9sxJlkemtp?= <ole@ans.pl>
Subject: Re: NAT66 : A first implementation
Date: Sun, 17 Jul 2011 07:09:17 +0200
Message-ID: <4E226E7D.6050800@ans.pl>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Miller <davem@davemloft.net>, T.Moes@student.ulg.ac.be,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:52563 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab1GQFaV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 01:30:21 -0400
In-Reply-To: <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2011-07-15 01:55, Jan Engelhardt wrote:
> On Friday 2011-07-15 01:17, David Miller wrote:
>
>> From: Jan Engelhardt<jengelh@medozas.de>
>> Date: Fri, 15 Jul 2011 01:15:47 +0200 (CEST)
>>
>>> Of course yours is feature-richer. But the topic of IPv6 NAT has ha=
d
>>> come up a number of unrecollectable times, and the response has bee=
n the
>>> same everytime - NAT is still an ugly undesired hack whose recurren=
ce
>>> wants to be avoided.
>>
>> People want to hide the details of the topology of their
>> internal networks,
>
> And IPv6 Privacy w.r.t. random address selection, combined with a
> firewall, won't do that?

Be rational.

How would you imagine managing and maintaining a typical corporate=20
network (1K+ devices) of different devices and operating systems -=20
workstations (Windows, Mac, Linux), servers (Windows, Linux, BSD)=20
routers, switches (radius), firewalls, APs, etc; without static IP=20
addresses? Static =3D not random.

Also, how would you imagine readressing such network one day, when you=20
decide to change your ISP?

Without NAT (and BTW without working and complete L3 security in=20
switches) no one will consider IPv6 seriously nor dare to implement it=20
in production. Of course NAT does not provide security but it provides =
a=20
real and useful privacy, opposite to annoying randomness.

Best regards,

				Krzysztof Ol=C4=99dzki
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
