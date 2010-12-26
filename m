From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: inconsistent address treatment.
Date: Mon, 27 Dec 2010 01:10:31 +1300
Message-ID: <4D1730B7.3090805@treenet.co.nz>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net> <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Stephen Clark <sclark46@earthlink.net>,
	Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:52778
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752086Ab0LZMRr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 07:17:47 -0500
In-Reply-To: <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25/12/10 10:48, Jan Engelhardt wrote:
>
> On Friday 2010-12-24 16:32, Stephen Clark wrote:
>>>>> Because -d takes a prefix and --to-source takes an address range.
>>>>
>>>> So? you can't parse
>>>> 205.201.149.214/32-205.201.149.218/32
>>>
>>> a.b.c.d/32 is a prefix notation, even though it represents a single
>>> address. IMO it does not make sense to use a prefix notation in an
>>> interval, so I don't see why the parser should handle it. AFAICS, other
>>> commands such as 'ip' from iproute don't accept /32 prefixes where a
>>> single address is expected either.
>>
>> Well It is just one more idiosyncrasy one has to remember, when to me there
>> is no obvious reason
>
> Historical reasons.
>
> Possible extra explanations:
>
> - DNAT was added later than the -s argument, and someone thought
>    it's better to use a range, since a range can be more expressive
>    than addr[/prefixlen] for the same memory usage.
> - On the other hand, since iptables also accepts addr[/mask], and it
>    also allows /masks that are not representable as a /prefixlen, it
>    is not necessarily specifying a contiguous range which may be
>    useless to use with DNAT to some.

FWIW: we (Squid project) use the syntax "ip[-ip][/mask]". This is simple 
enough to parse and is a bit more flexible.

/2c

AYJ
