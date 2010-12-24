From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: inconsistent address treatment.
Date: Fri, 24 Dec 2010 22:48:27 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	netfilter-devel@vger.kernel.org
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32972 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753162Ab0LXVs3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Dec 2010 16:48:29 -0500
In-Reply-To: <4D14BD05.8020509@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-12-24 16:32, Stephen Clark wrote:
>>>> Because -d takes a prefix and --to-source takes an address range.
>>>
>>>So? you can't parse
>>>205.201.149.214/32-205.201.149.218/32
>>
>>a.b.c.d/32 is a prefix notation, even though it represents a single
>>address. IMO it does not make sense to use a prefix notation in an
>>interval, so I don't see why the parser should handle it. AFAICS, other
>>commands such as 'ip' from iproute don't accept /32 prefixes where a
>>single address is expected either.
>
>Well It is just one more idiosyncrasy one has to remember, when to me there
>is no obvious reason

Historical reasons.

Possible extra explanations:

- DNAT was added later than the -s argument, and someone thought
  it's better to use a range, since a range can be more expressive
  than addr[/prefixlen] for the same memory usage.
- On the other hand, since iptables also accepts addr[/mask], and it
  also allows /masks that are not representable as a /prefixlen, it
  is not necessarily specifying a contiguous range which may be
  useless to use with DNAT to some.
