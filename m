From: Daniel Huhardeaux <daniel.huhardeaux@tootai.com>
Subject: Re: IP traffic rerouting
Date: Fri, 14 Aug 2009 12:57:38 +0200
Message-ID: <4A854322.8050705@tootai.com>
References: <4A849733.4020404@tootai.com> <alpine.LSU.2.00.0908140126250.28623@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ns1.tootai.net ([82.231.69.24]:38143 "EHLO mail1.tootai.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbZHNK5k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Aug 2009 06:57:40 -0400
Received: from [192.168.0.4] (unknown [192.168.0.4])
	by mail1.tootai.net (Postfix) with ESMTP id BF018398D80
	for <netfilter-devel@vger.kernel.org>; Fri, 14 Aug 2009 12:57:38 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0908140126250.28623@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt a =E9crit :
> On Friday 2009-08-14 00:44, Daniel Huhardeaux wrote:
>  =20
>> is there a solution to reroute all traffic (icmp, udp, tcp, ...) fro=
m
>> one IP address to another one?
>>    =20
>
>
> Routing tables are controlled with iproute2. Replace the variables by=
=20
> something appropriate. The freely choosable $number usually wants to =
be =20
>  =20
>> =3D 1 to avoid surprises.
>>    =20
>
> ip rule add from $srcaddr table $number prio $prio
> ip route add default via $toaddr table $number
>
> (The main routing table has number 254, and is usually at the lowest=20
> prio of 32767. The "prio $prio" part is thus usually optional in=20
> practice.)
>  =20
Thanks for your answer Jan.

This means that if I want to redirect all traffic to an IP to another=20
one, and changing the sorce address as if packet came from the IP from=20
redirected machine I would have to create:

ip rule add to $iptoredirect table $number prio $prio
ip route add default via $toaddr src $iptoredirect table $number

Without changing the source address it would be:

ip rule add to $iptoredirect table $number prio $prio
ip route add default via $toaddr table $number

Would be the NAT option not a possibility? Something like

ip route add nat $iptoredirect via $toaddr

Regards

--=20
Daniel Huhardeaux       _____ ____ ____ _____ _____ _
enum   +33 368 460 088 (_  __) _  ) _  (_  __) _  _(_)  +48 222 472 472
iaxtel  1-700-849-6983  / / / // / // / / / / /_/ / /  GIZMO,SKYPE,GTAL=
K
sip/iax:callto 101@sip./_/ ( ___( ___/ /_/ (_/ (_/_/.net   tootaiNET

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
