From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: rules matching ipv6 prefix addrs
Date: Thu, 04 Nov 2010 13:19:33 +0100
Message-ID: <4CD2A4D5.6050503@plouf.fr.eu.org>
References: <4CD12B8B.9090506@plouf.fr.eu.org> <20101103.051925.193703726.davem@davemloft.net> <alpine.LNX.2.01.1011031331170.19124@obet.zrqbmnf.qr> <20101103.145503.104044664.davem@davemloft.net> <5ca75042-e809-4439-856a-e3da43cb6c23@email.android.com> <alpine.LNX.2.01.1011032339220.29167@obet.zrqbmnf.qr> <4CD21679.2070508@zytor.com> <4CD29423.6050009@earthlink.net> <4CD29913.2040903@plouf.fr.eu.org> <4CD2A200.7080204@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "H. Peter Anvin" <hpa@zytor.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from poutre.nerim.net ([62.4.16.124]:59117 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0KDMTf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Nov 2010 08:19:35 -0400
In-Reply-To: <4CD2A200.7080204@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Clark a =E9crit :
> On 11/04/2010 07:29 AM, Pascal Hambourg wrote:
>> Stephen Clark a =E9crit :
>>   =20
>>> Won't this break existing tcp connections if all of a sudden you ge=
t a
>>> new address?
>>>     =20
>> Yes, but the same happened already with a variable IPv4 address, so =
this
>> is not a new problem. [...]
>>   =20
> Yes but when it happens there some kind of well defined event - like=20
> dhcp giving you a new address
> and can trigger scripts that do the necessary updating of whatever ne=
eds=20
> to be updated.

Right, but that does not help much to deal with broken TCP connections.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
