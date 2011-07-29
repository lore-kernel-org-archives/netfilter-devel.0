From: Patrick McHardy <kaber@trash.net>
Subject: Re: ULOG and vlans
Date: Fri, 29 Jul 2011 16:23:24 +0200
Message-ID: <4E32C25C.8080003@trash.net>
References: <CAL-yc8_nbzJu8FxAVBycdeXtciz=FGYxXzQtT88xYQ3wX60hBQ@mail.gmail.com>	<4E3144DA.7060009@trash.net> <CAL-yc88wjr-0H1LF+x5FLf=h1XhswbQ78McHvZ4NL5+p08gUTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stig <stig@ubnt.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56287 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab1G2OX2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:23:28 -0400
In-Reply-To: <CAL-yc88wjr-0H1LF+x5FLf=h1XhswbQ78McHvZ4NL5+p08gUTw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28.07.2011 19:00, Stig wrote:
> On Thu, Jul 28, 2011 at 4:15 AM, Patrick McHardy <kaber@trash.net> wrote:
>> On 27.07.2011 20:59, Stig wrote:
>>> I'm using ULOG iptables target to capture packets for pmacct (a
>>> netflow exporter).  I noticed when ulog gets a packet from a vlan
>>> interface that the ulog header shows a mac_len of 18 bytes, but it
>>> appears that the vlan tag has already been stripped from the packet
>>> header:
>>>
>>> (gdb) p/x *ulog_pkt
>>> $7 = {
>>>   mark = 0x0,
>>>   timestamp_sec = 0x4e2f6077,
>>>   timestamp_usec = 0x222f3,
>>>   hook = 0x0,
>>>   indev_name = {0x65, 0x74, 0x68, 0x31, 0x2e, 0x31, 0x30, 0x30, 0x0, 0x0, 0x0,
>>>     0x0, 0x0, 0x0, 0x0, 0x0},
>>>   outdev_name = {0x0, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0x5, 0xf, 0x0,
>>>     0x0, 0x5, 0xf, 0x0, 0x0},
>>>   data_len = 0x40,
>>>   prefix = {0x0, 0x0, 0x2, 0x0, 0x72, 0x60, 0x2f, 0x4e, 0xed, 0x6, 0x0, 0x0,
>>>     0xa, 0x40, 0x80, 0xfd, 0x2, 0x0, 0x0, 0x0, 0x14, 0x0, 0x1, 0x0, 0xfe,
>>>     0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0},
>>>   mac_len = 0x12,
>>>   mac = {0x0, 0xd, 0xb9, 0x15, 0x6d, 0x1, 0x0, 0xf, 0x30, 0x4, 0x35, 0x4f,
>>>     0x8, 0x0, 0x45, 0x0, 0x0, 0x54, 0xff, 0x21, 0x12, 0x0, 0x0, 0x21, 0x12,
>>>     0x0, 0x0, 0x40, 0x0, 0x0, 0x0, 0x14, 0x0, 0x2, 0x0, 0x72, 0x60, 0x2f,
>>>     0x4e, 0xed, 0x6, 0x0, 0x0, 0xa, 0x40, 0x80, 0xfd, 0x3, 0x0, 0x0, 0x0,
>>>     0x14, 0x0, 0x1, 0x0, 0xfe, 0x80, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x2, 0xd,
>>>     0xb9, 0xff, 0xfe, 0x15, 0x6d, 0x1, 0x14, 0x0, 0x6, 0x0, 0xff, 0xff, 0xff,
>>>     0xff, 0xff},
>>>   payload = 0x941cc35
>>> }
>>>
>>>
>>> If the vlan has been remove, shouldn't the mac_len be reduced to 14?
>>
>> Yes. How is your vlan device configured (ip -s link show vlanX)?
> 
> vyatta@vyatta:~$ ip -s link show eth1.100
> 4: eth1.100@eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue stat
>     link/ether 00:0d:b9:15:6d:01 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast
>     296652     3372     0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     344216     3376     0       0       0       0

Sorry, I actually meant ip -d link show vlanX. Also, what driver are
you using?
