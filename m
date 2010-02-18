From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 11:39:04 -0800
Message-ID: <48ceaa831002181139k134dadbp2bc65857eac6af59@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
	 <1266515463.2877.10.camel@edumazet-laptop>
	 <48ceaa831002180955v4fd87e20o4e116c87f4f4b259@mail.gmail.com>
	 <1266516452.2877.12.camel@edumazet-laptop>
	 <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>
	 <4B7D84C6.2040102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:62680 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335Ab0BRTjI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:39:08 -0500
Received: by pxi29 with SMTP id 29so3636322pxi.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 11:39:04 -0800 (PST)
In-Reply-To: <4B7D84C6.2040102@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 18, 2010 at 10:19 AM, Patrick McHardy <kaber@trash.net> wrote:
> Afi Gjermund wrote:
>> On Thu, Feb 18, 2010 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>>> Shouldn't the value after the flush be 0? The traffic that has created
>>>>>> this mess is from a REDIRECT rule in the PREROUTING chain of the 'nat'
>>>>>> table.
>>>>> Could you post a copy of these rules ?
>>>>>
>>>> iptables -t nat -A PREROUTING -p tcp -s X.X.X.X -d X.X.X.X --sport X
>>>> --dport X -j REDIRECT --to-port X
>>> Yes I understood you were using such rules, but I cannot understand how
>>> it can trigger without real nics being plugged. So I asked you some
>>> details, apprently you dont want to provide them and prefer to hide from
>>> us :)
>>>
>> Lol, sorry. The X values are dynamic and depend on what network the
>> device happens to be on, as well as the ephemeral source port.
>>
>> iptables -t nat -A PREROUTING -p tcp -s 172.168.8.45 -d 172.168.8.200
>> --sport 4351 --dport 4500 -j REDIRECT --to-port 45001
>
> NAT is unlikely to be the cause since its widely used and there
> are no other reports of leaks. Please describe your full setup,
> especially things like traffic scheduling, network devices,
> userspace queueing etc etc.
>

The device has 2 network interfaces that are configured in a bridge
(eth0,eth1).  The traffic scheduling has not been changed from the
default kernel configuration.

Problem path:
The problem I am seeing is that my tcp connections enter the
/proc/net/nf_conntrack table, then disappear over time but the
nf_conntrack_count never decreases.  Over time, the nf_conntrack_count
hits the 4096 nf_conntrack_max and the kernel begins to drop packets
even though the /proc/net/nf_conntrack table is not full (has < 100
connections).

In testing I decided to set the nf_conntrack_max to 100, and fill the
table via the connections above.  Then remove both ethernet cables to
ensure no new connections could be made.  I also set the
nf_conntrack_tcp_timeout_established to 60 seconds.  I left this for 2
hours and saw that the /proc/net/nf_conntrack table was empty while
the nf_conntrack_count was still 100.

I also created a kernel module that calls the nf_conntrack_flush()
function, this seems to only clear the /proc/net/nf_conntrack table,
but not the count. If I also do an atomic_set(&nf_conntrack_count,0)
then (obviously) the count becomes 0.  It is as if the connections are
being removed from the table, but the count is not being decremented,
which I am not sure why.  As far as I understand it, they should be in
sync.
