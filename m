From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 10:04:59 -0800
Message-ID: <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:55833 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0BOSFA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 13:05:00 -0500
Received: by pzk35 with SMTP id 35so488225pzk.33
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 10:04:59 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2010 at 9:46 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2010-02-15 18:29, Patrick McHardy wrote:
>>Afi Gjermund wrote:
>>>
>>> I am running into an odd issue where the kernel begins to drop packets
>>> because the connection tracking table is full. (I am running
>>> 2.6.26.5).
>>>
>>> A 'cat /proc/sys/net/netfilter/nf_conntrack_count' says 4096.  But if
>>> I do a 'cat /proc/net/nf_conntrack | wc -l' then it says 4.
>>
>>Conntracks might exist and not be in the global table anymore,
>>f.i. when referenced by a packet. The difference in your case
>>seems pretty extreme, so I'd guess that packets are leaked
>>somewhere.
>
> So, that would make for 4092 expected connections then?
>
> Afi, what would `conntrack -L expect` give?
>

Jan, I am running this on an embedded system and will have to
cross-compile the userspace tools and get back to you.  One thing to
note is, I have stopped any traffic flowing through the device, and
yet I am still receiving the kernel drop messages.  Any change its
connection tracking on the loopback? ( I use the loopback for IPC ).
