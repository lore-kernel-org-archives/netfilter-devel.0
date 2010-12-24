From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: inconsistent address treatment.
Date: Fri, 24 Dec 2010 10:32:21 -0500
Message-ID: <4D14BD05.8020509@earthlink.net>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-dupuy.atl.sa.earthlink.net ([209.86.89.62]:55025 "EHLO
	elasmtp-dupuy.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752001Ab0LXPcX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:32:23 -0500
In-Reply-To: <4D1457D5.3040305@plouf.fr.eu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/24/2010 03:20 AM, Pascal Hambourg wrote:
> Stephen Clark a =E9crit :
>   =20
>> On 12/23/2010 02:52 PM, Pascal Hambourg wrote:
>>     =20
>>> Stephen Clark a =E9crit :
>>>
>>>       =20
>>>> Why the inconsistency in the way addresses are treated. I can use =
-d
>>>> 2.2.2.2/32
>>>>     but not --to-source 205.201.149.214/32
>>>>
>>>>         =20
>>> Because -d takes a prefix and --to-source takes an address range.
>>>       =20
>> So? you can't parse
>>
>> 205.201.149.214/32-205.201.149.218/32
>>     =20
> a.b.c.d/32 is a prefix notation, even though it represents a single
> address. IMO it does not make sense to use a prefix notation in an
> interval, so I don't see why the parser should handle it. AFAICS, oth=
er
> commands such as 'ip' from iproute don't accept /32 prefixes where a
> single address is expected either.
>   =20
Well It is just one more idiosyncrasy one has to remember, when to me t=
here
is no obvious reason for it to be so. It also means if you are writing=20
some kind
of automated tool to create rules for iptables from a set of address ob=
jects
then you have remember, Oh I have to drop the /32 if this object is use=
d
as an argument for --to-source. That means everyone that trys to develo=
p
an automated tool has to deal with this anomaly instead of  being dealt=
 with
in one place, the parser for iptables.

--=20

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
