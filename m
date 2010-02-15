From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Mon, 15 Feb 2010 11:30:44 -0800
Message-ID: <48ceaa831002151130j3c96c72an40653869aac63814@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <4B798487.6040304@trash.net>
	 <alpine.LSU.2.01.1002151844400.18430@obet.zrqbmnf.qr>
	 <48ceaa831002151004w16b548f4tc627252e94a632b6@mail.gmail.com>
	 <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f197.google.com ([209.85.222.197]:64558 "EHLO
	mail-pz0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0BOTao (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 14:30:44 -0500
Received: by pzk35 with SMTP id 35so566199pzk.33
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Feb 2010 11:30:44 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002151959460.6158@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 15, 2010 at 11:00 AM, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Monday 2010-02-15 19:04, Afi Gjermund wrote:
>>>>>
>>>>> I am running into an odd issue where the kernel begins to drop packets
>>>>> because the connection tracking table is full. (I am running
>>>>> 2.6.26.5).
>>>>>
>>>>> A 'cat /proc/sys/net/netfilter/nf_conntrack_count' says 4096.  But if
>>>>> I do a 'cat /proc/net/nf_conntrack | wc -l' then it says 4.
>>>>
>>>>Conntracks might exist and not be in the global table anymore,
>>>>f.i. when referenced by a packet. The difference in your case
>>>>seems pretty extreme, so I'd guess that packets are leaked
>>>>somewhere.
>>>
>>> So, that would make for 4092 expected connections then?
>>>
>>> Afi, what would `conntrack -L expect` give?
>   (meant: conntrack -L expect | wc -l)
>
>>One thing to
>>note is, I have stopped any traffic flowing through the device, and
>>yet I am still receiving the kernel drop messages.  Any change its
>>connection tracking on the loopback? ( I use the loopback for IPC ).
>
> Yes. conntrack does not care about what interface packets
> come in or go out on. Unless it's NOTRACKed, it's counted.
>
Okay, after some tinkering I was able to get the userspace application
going.  The results, however, do not seem that helpful.

root@00:00:10:73:77:64 ~# ./conntrack -L expect | wc -l
conntrack v0.9.14 (conntrack-tools): 0 expectations have been shown.
0

root@titan ~# ./conntrack -L conntrack
udp      17 179 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=89099
bytes=12968758 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=110358
bytes=17041625 [ASSURED] mark=0 use=1
udp      17 179 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=87867
bytes=12816098 src=0.0.0.0 dst=0.0.0.0 sport=0 dport=0 packets=107497
bytes=16573614 [ASSURED] mark=0 use=1
conntrack v0.9.14 (conntrack-tools): 2 flow entries have been shown.

root@titan ~# cat /proc/sys/net/netfilter/nf_conntrack_count
4096

root@titan ~# ./conntrack -S
entries                 4096
searched                2525930
found                   418064263
new                     295548
invalid                 1509
ignore                  233351
delete                  291452
delete_list             280256
insert                  280258
insert_failed           0
drop                    69960
early_drop              173185
icmp_error              45
expect_new              0
expect_create           0
expect_delete           0
