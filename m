From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: inconsistent address treatment.
Date: Sat, 08 Jan 2011 17:20:29 +1300
Message-ID: <4D27E60D.6080205@treenet.co.nz>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net> <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr> <4D1730B7.3090805@treenet.co.nz> <4D17B6FB.5020807@plouf.fr.eu.org> <alpine.LNX.2.01.1012262309540.5681@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Stephen Clark <sclark46@earthlink.net>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:53146
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1AHEUj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Jan 2011 23:20:39 -0500
In-Reply-To: <alpine.LNX.2.01.1012262309540.5681@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27/12/10 11:16, Jan Engelhardt wrote:
> On Sunday 2010-12-26 22:43, Pascal Hambourg wrote:
>
>> Amos Jeffries a =C3=A9crit :
>>>
>>> FWIW: we (Squid project) use the syntax "ip[-ip][/mask]".
>>
>> I'm being curious : what is the meaning of "ip-ip/mask" when both th=
e
>> range and mask are present ?
>
> Sounds like
>
> 192.168.0.64-192.168.191/255.255.255.253
> <=3D>
> 192.168.0.{64 65 68 69 72 73 76 77 77...}
>
> Well, it's probably of use... to someone.

=46or yourselves I was thinking limit it to CIDR masks.
As in:
  192.168.0.0/24               =3D=3D> 19.168.0.0-192.168.0.255
  192.168.1.0-192.168.10.0/23  =3D=3D> 192.168.1.0-192.168.11.255
  192.168.0.0-192.168.100.0/24 =3D=3D> 192.168.0.0-192.168.100.255

Netmasks get a bit tricky and as you say you don't have enough storage=20
space to hold the mask as well.

AYJ
Ps. sorry for the slow reply, holidays.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
