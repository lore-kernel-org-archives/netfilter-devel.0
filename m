From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l'
 count
Date: Mon, 15 Feb 2010 20:00:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>  <4B798487.6040304@trash.net>  <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr> <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47279 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab0BOTAs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:00:48 -0500
In-Reply-To: <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2010-02-15 19:04, Afi Gjermund wrote:
>>>>
>>>> I am running into an odd issue where the kernel begins to drop packets
>>>> because the connection tracking table is full. (I am running
>>>> 2.6.26.5).
>>>>
>>>> A 'cat /proc/sys/net/netfilter/nf_conntrack_count' says 4096.  But if
>>>> I do a 'cat /proc/net/nf_conntrack | wc -l' then it says 4.
>>>
>>>Conntracks might exist and not be in the global table anymore,
>>>f.i. when referenced by a packet. The difference in your case
>>>seems pretty extreme, so I'd guess that packets are leaked
>>>somewhere.
>>
>> So, that would make for 4092 expected connections then?
>>
>> Afi, what would `conntrack -L expect` give?
   (meant: conntrack -L expect | wc -l)

>One thing to
>note is, I have stopped any traffic flowing through the device, and
>yet I am still receiving the kernel drop messages.  Any change its
>connection tracking on the loopback? ( I use the loopback for IPC ).

Yes. conntrack does not care about what interface packets
come in or go out on. Unless it's NOTRACKed, it's counted.
