From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: inconsistent address treatment.
Date: Fri, 24 Dec 2010 09:20:37 +0100
Message-ID: <4D1457D5.3040305@plouf.fr.eu.org>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bamako.nerim.net ([62.4.17.28]:64934 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542Ab0LXIU3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Dec 2010 03:20:29 -0500
Received: from localhost (localhost [127.0.0.1])
	by bamako.nerim.net (Postfix) with ESMTP id 4BA0439DEB9
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2010 09:20:27 +0100 (CET)
Received: from bamako.nerim.net ([127.0.0.1])
	by localhost (bamako.nerim.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J5nqMY8VSZ2T for <netfilter-devel@vger.kernel.org>;
	Fri, 24 Dec 2010 09:20:26 +0100 (CET)
Received: from [192.168.0.246] (plouf.fr.eu.org [213.41.173.35])
	by bamako.nerim.net (Postfix) with ESMTP id 3D05839DEC4
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2010 09:20:26 +0100 (CET)
In-Reply-To: <4D13D0FF.1010900@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Stephen Clark a =E9crit :
> On 12/23/2010 02:52 PM, Pascal Hambourg wrote:
>>
>> Stephen Clark a =E9crit :
>>   =20
>>> Why the inconsistency in the way addresses are treated. I can use -=
d
>>> 2.2.2.2/32
>>>    but not --to-source 205.201.149.214/32
>>>     =20
>> Because -d takes a prefix and --to-source takes an address range.
>=20
> So? you can't parse
>=20
> 205.201.149.214/32-205.201.149.218/32

a.b.c.d/32 is a prefix notation, even though it represents a single
address. IMO it does not make sense to use a prefix notation in an
interval, so I don't see why the parser should handle it. AFAICS, other
commands such as 'ip' from iproute don't accept /32 prefixes where a
single address is expected either.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
