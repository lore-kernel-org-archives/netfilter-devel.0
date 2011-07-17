From: =?UTF-8?B?S3J6eXN6dG9mIE9sxJlkemtp?= <ole@ans.pl>
Subject: Re: NAT66 : A first implementation
Date: Mon, 18 Jul 2011 01:54:50 +0200
Message-ID: <4E23764A.1080404@ans.pl>
References: <alpine.LNX.2.01.1107141818500.10490@frira.zrqbmnf.qr> <4E1F1902.9020605@student.ulg.ac.be> <alpine.LNX.2.01.1107141915580.10781@frira.zrqbmnf.qr> <20110714.161717.1387261665409519132.davem@davemloft.net> <alpine.LNX.2.01.1107150151390.20658@frira.zrqbmnf.qr> <4E226E7D.6050800@ans.pl> <4E2360C9.20304@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([195.187.34.71]:47157 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978Ab1GQXy6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Jul 2011 19:54:58 -0400
In-Reply-To: <4E2360C9.20304@wildgooses.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2011-07-18 00:23, Ed W wrote:
> Hi
Hi,


>> Also, how would you imagine readressing such network one day, when y=
ou
>> decide to change your ISP?
>
> Aha.  This is a statement that you don't believe PI space will become
> easier to access when requesting IPV6 space?

IPv6 PI for everyone? Forget about it, we would shortly hit 1M or even=20
10M+ IPv6 prefixes and this way make BGP unreliable.

> There seems to be sufficient space for PI to become the norm to hand
> out.  However, the current state of routing appears to struggle with
> IPV4 taken to the limit, and so there seems to be understandable
> reluctance to actually fix all the issues we have with IPV4 since som=
e
> facets of the solution kill current routing hardware..?
>
> Mobile phone numbers are now interchangeable between phone companies =
in
> under 24 hours in the UK.  Lets hope that PI space allocations become
> the norm under IPv6..?

You must not compare PSTN with IP this way. How many GSM operators are=20
there in UK with own network prefix? 50? 100? Now: compare it to BGP=20
AS'es. How long you need to wait to initiate a call. Finally, how many=20
calls do you make per second? ;)

BTW: phone numbers are interchangeable not only in UK and not only=20
mobile. ;)

>> Without NAT (and BTW without working and complete L3 security in
>> switches) no one will consider IPv6 seriously nor dare to implement =
it
>> in production. Of course NAT does not provide security but it provid=
es a
>> real and useful privacy, opposite to annoying randomness.
>
> It's not clear to me that NAT solves L3 security any better than a
> non-nat firewall?

Sorry, english is not my native language, maybe I was not clear enough.=
=20
By L3 security in switches I meant:

  - DHCPv6-snooping, like dhcp-snooping in IPv4, which protects your=20
network from unauthorized dhcp-servers. Just think of someone enabling=20
connection sharing in windows, grrr!

  - ND-protect, like arp-protect in IPv4 - there is no ARP for IPv6

  - "ipv6 source-lockdown", like "ip source-lockdown" [1]) to protect=20
from arp/ip spoofings/takeovers.

Such mechanisms are standard for enterprise and nowadays even soho edge=
=20
switches, but only for IPv4.

However, as IPv6 is totally different to IPv6, you also need many=20
additional mechanisms. For example, several IPv6 stacks are vulnerable=20
to RA DoS attack (google: "vulnerable ra ipv6"), and you would like to=20
filter unauthorized routers anyway.

But this little offtopic to Netfilter. ;)

[1] HP Procurve terminology.

Best regards,

				Krzysztof Ol=C4=99dzki
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
