From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: [PATCHv6 0/3] Interface group patches
Date: Fri, 23 Nov 2007 01:56:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711230153050.11914@bizon.gios.gov.pl>
References: <200711221537.29396.wolfgang.walter@studentenwerk.mhn.de>
 <47461A70.2010201@trash.net> <Pine.LNX.4.64.0711230120560.11776@bizon.gios.gov.pl>
 <474621C7.7040807@trash.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-1521610246-1195779418=:11914"
Cc: Wolfgang Walter <wolfgang.walter@studentenwerk.mhn.de>,
	netfilter-devel@vger.kernel.org, linux-netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:51010 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563AbXKWBDW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Nov 2007 20:03:22 -0500
In-Reply-To: <474621C7.7040807@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-1521610246-1195779418=:11914
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 23 Nov 2007, Patrick McHardy wrote:

> Krzysztof Oledzki wrote:
>>=20
>>=20
>> On Fri, 23 Nov 2007, Patrick McHardy wrote:
>>=20
>>> Wolfgang Walter wrote:
>>>> From: Patrick McHardy
>>>>> I'm working on the incremental ruleset changing API BTW :)
>>>>> One of the changes will be that interface matching is not
>>>>> a default part of every rule, and without wildcards it will
>>>>> use the ifindex. But since the cost of this feature seems
>>>>> pretty low, I don't see a compelling reason against it.
>>>>=20
>>>> Using ifindex instead of string matching the interface name in -i and =
-o=20
>>>> would be a serious problem as it changes the semantics.
>>>>=20
>>>> 1) Now you can match a non existing interface. This is certainly used.=
=20
>>>> I.e. with vlan interfaces, ppp etc.
>>>> 2) Now your rule will match an interface even if the ifindex of the=20
>>>> interface changes. This is used (i.e. you activate a backup interface =
and=20
>>>> rename it, build new bridges etc.).
>>>>=20
>>>> If one wants to use the ifindex instead of a string match on the name =
one=20
>>>> should explicitly request that (i.e. by using "-i =3Deth0" or somethin=
g=20
>>>> like that).
>>>=20
>>>=20
>>> Don't worry, it will subscribe to netdevice events and adjust the
>>> ifindex when necessary. For userspace its still a device name match.
>>=20
>> Also for "-i ppp+"?
>
>
> No, see above :) Its a single device match, for wildcards it will
> still use the pattern-based matching.

Right, sorry. It seems I overlooked the most important part. :(

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-1521610246-1195779418=:11914--
