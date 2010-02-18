From: Douglas Diniz <dgdiniz@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 16:12:58 -0200
Message-ID: <5415ae081002181012x4f7c95a4ncec563f69ae3562e@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <1266264287.2859.0.camel@edumazet-laptop>
	 <alpine.LSU.2.01.1002152132250.21055@obet.zrqbmnf.qr>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
	 <1266515463.2877.10.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Afi Gjermund <afigjermund@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f200.google.com ([209.85.221.200]:47356 "EHLO
	mail-qy0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932Ab0BRSS4 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:18:56 -0500
Received: by qyk38 with SMTP id 38so3058283qyk.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 10:18:55 -0800 (PST)
In-Reply-To: <1266515463.2877.10.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm facing the same problem. I'm working in a embedded system with
kernel 2.6.20-6. When I send a ping (or any other protocol) through
eth0 to eth1 (or vice versa) the conntrack count isn't decremented. If
I send the ping through any other interface (eth0 to wifi, eth1 to
wifi, wifi to eth0 and wifi to eth1) I have no problem.
The problem seems to be only between the ethernet interfaces.
I debug the netfilter and I saw that when the problem occurs the "use"
variable inside conntract structure in > 1, so this variable is only
decremented by 1, not reaching in 0, and then the destroy_conntrack
function is not called.

So I think that the problem is more low level, and some events aren't
reaching netfilter, and the "use"variable isn't decremented properly.

This could be a problem with the ethernet driver?

Thanks....

On Thu, Feb 18, 2010 at 3:51 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le jeudi 18 f=E9vrier 2010 =E0 09:40 -0800, Afi Gjermund a =E9crit :
>> I am still trying to figure out why the nf_conntrack_count differs
>> from the table system. =A0I decided I would use the conntrack usersp=
ace
>> tools.
>> Both of my NICs are unplugged with no other userspace applications
>> running to affect connection tracking counts.
>>
>>
>> root@titan ~# date
>> Thu Feb 18 17:35:21 UTC 2010
>>
>> root@titan ~# ./conntrack -C conntrack
>> 351
>>
>> root@titan ~# date
>> Thu Feb 18 17:35:24 UTC 2010
>>
>> root@titan ~# ./conntrack -F conntrack
>> conntrack v0.9.14 (conntrack-tools): connection tracking table has b=
een emptied.
>>
>> root@titan ~# date
>> Thu Feb 18 17:35:31 UTC 2010
>>
>> root@titan ~# ./conntrack -C conntrack
>> 351
>>
>> root@titan ~# date
>> Thu Feb 18 17:35:36 UTC 2010
>>
>> Shouldn't the value after the flush be 0? The traffic that has creat=
ed
>> this mess is from a REDIRECT rule in the PREROUTING chain of the 'na=
t'
>> table.
>
> Could you post a copy of these rules ?
>
> Thanks
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-d=
evel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
