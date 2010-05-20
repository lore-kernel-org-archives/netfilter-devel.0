From: Patrick McHardy <kaber@trash.net>
Subject: Re: Any Performance benchmark on a Million conntracks
Date: Thu, 20 May 2010 16:03:55 +0200
Message-ID: <4BF5414B.4090609@trash.net>
References: <AANLkTinGFeinOo2LfMU_6jcNewuFxXkZL1f9vAE-SXBe@mail.gmail.com> <1274360664.4046.36.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Anand Raj Manickam <anandrm@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53214 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab0ETODz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 May 2010 10:03:55 -0400
In-Reply-To: <1274360664.4046.36.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Dumazet wrote:
> Le jeudi 20 mai 2010 =E0 18:21 +0530, Anand Raj Manickam a =E9crit :
>> Hi,
>> Is there any performance bench mark on conntrack response to 1 milli=
on
>> conntrack entries in the conntrack table.
>> Since conntrack uses Hashing to lookup the entries i had some doubts
>> on the scalability. Can someone shed some light please?
>=20
> Question is not about number of conntrack entries in hash table, but
> number of inserts and deletes per second.
>=20
> For persistent connections, if you use a hash table of one million
> slots, performance will be very good, since the chain length is small=
=2E
> Its scalable because each cpu can access conntrack table without lock=
s,
> in parallel.

Actually the recommended hash table size is twice the number of
expected connections since each conntrack is hashed twice :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
