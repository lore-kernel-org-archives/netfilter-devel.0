From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Set default policy of chains in filter tables to DROP/ACCEPT
Date: Thu, 24 Jan 2008 16:12:29 +0100
Message-ID: <4798AADD.5070706@trash.net>
References: <1201183885868-git-send-email-panther@balabit.hu> <4798A23C.5030904@trash.net> <4798A604.8020308@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: panther@balabit.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45371 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYAXPMe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 10:12:34 -0500
In-Reply-To: <4798A604.8020308@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Laszlo Attila Toth wrote:
> Patrick McHardy =EDrta:
>> Laszlo Attila Toth wrote:
>>> Set the default policy of INPUT/FORWARD/OUTPUT chains of IPv4/IPv6=20
>>> filter
>>> tables to DROP or ACCEPT in kernel configuration. It can be overrid=
e by
>>> a module parameter (defaultdrop for IPv4 and defaultdropv6 for IPv6=
).
>>
>>
>> Whats the point of this? You can simply execute the corresponding
>> iptables commands early during boot ...
>=20
> Yes, that's right. But in case of a security audit unfortunatelly it =
is=20
> not enough, the only acceptable way is to set the policy to DROP. In =
our=20
> kernel the default policy is DROP because of it.


=46rankly, any "audit" that insists on this while ignoring that the
policy can be set before any network interface is up or even
drivers loaded deserves to go to the trash. Thats just as stupid
as "icmp is bad" dogma and similar crap.

So I'm not going to apply this, sorry.

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
