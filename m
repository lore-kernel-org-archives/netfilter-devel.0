From: Daniel Huhardeaux <tech@tootai.net>
Subject: Re: DNAT and source IP
Date: Tue, 20 Oct 2009 16:50:06 +0200
Message-ID: <4ADDCE1E.7080700@tootai.net>
References: <4ADD71D7.7090502@tootai.net> <alpine.LSU.2.00.0910201212490.16728@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Netfilter list <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.tootai.net ([82.231.69.24]:54785 "EHLO mail1.tootai.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbZJTOuD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Oct 2009 10:50:03 -0400
Received: from [192.168.0.4] (unknown [192.168.0.4])
	by mail1.tootai.net (Postfix) with ESMTP id 0690C398C16
	for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2009 16:50:06 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0910201212490.16728@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt a =E9crit :
> On Tuesday 2009-10-20 10:16, Daniel Huhardeaux wrote:
>> I'm running few virtual machines (kvm+libvirt) on a server (Debian L=
enny +
>> backport kernel 2.6.30) with one public IP and having IP private ran=
ge
>> 10.99.0.1 for host, one for mail and web VM (10.99.0.13), another fo=
r telephony
>> VM (10.99.0.11).
>>
>> Everything is working well (DNAT) but something is disturbing me: fo=
r instance,
>> on smtp server, all incoming tcp packets are marked with 10.99.0.1 s=
ource IP
>> and I would like to have "transparent DNAT" which keep the original =
IP.
>=20
> You need tproxy then, and not NAT.
>=20
|[...]
|Others say it's a target rule but I can't get it work
|
|~$ sudo iptables -t mangle -A PREROUTING -p tcp --dport 25 -j TPROXY
|--on-port 25 --on-ip 10.1.70.13
|iptables v1.4.2: Unknown arg `(null)'
|Try `iptables -h' or 'iptables --help' for more information.
|
|Thanks for any hint and good and complete doc if any.

Got it, sorry for the noise: forgot to upgrade iptables to version=20
1.4.4-2 from backports.

--=20
Daniel
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
