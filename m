From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: Resource temporarily unavailable.
Date: Thu, 11 Nov 2010 16:57:23 +0100
Message-ID: <4CDC1263.8070206@trash.net>
References: <20101111150055.GI15421@fi.muni.cz> <1289489728.17691.1331.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kasprzak <kas@fi.muni.cz>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41483 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071Ab0KKP52 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Nov 2010 10:57:28 -0500
In-Reply-To: <1289489728.17691.1331.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 11.11.2010 16:35, schrieb Eric Dumazet:
> Le jeudi 11 novembre 2010 =C3=A0 16:00 +0100, Jan Kasprzak a =C3=A9cr=
it :
>> 	Hello,
>>
>> I have a iptables-based firewall with ~1200 IPv4 and ~950 IPv6 rules=
=2E
>> When I want to reload its configuration, I often get "Resource tempo=
rarily
>> unavailable" error from iptables.
>>
>> I have a HA setup with two servers, and the error more often happens=
 on
>> a server with four cores and 2 GB of RAM than on a server with two c=
ores
>> and 4 GB of RAM.
>>
>> I have added a band-aid fix to my startup script - sleeping for one =
second
>> and trying again when the error code from iptables is 4, and it appa=
rently
>> helps. But the error messages from the startup script are still a bi=
t ugly.
>> What else can I do in order to fix the problem?
>=20
> Hi
>=20
> Please provide=20
>=20
> cat /proc/meminfo
>=20
> Also please apply this patch :
>=20
> http://git2.kernel.org/?p=3Dlinux/kernel/git/davem/net-2.6.git;a=3Dco=
mmitdiff;h=3D6b1686a71e3158d3c5f125260effce171cc7852b

This problem is usually caused by manipulating the ruleset from multipl=
e
iptables instances concurrently.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
