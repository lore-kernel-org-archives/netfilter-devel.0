From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 19:19:50 +0100
Message-ID: <4B7D84C6.2040102@trash.net>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>	 <1266270757.2859.27.camel@edumazet-laptop>	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>	 <1266271377.2859.28.camel@edumazet-laptop>	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>	 <1266515463.2877.10.camel@edumazet-laptop>	 <48ceaa831002180955v4fd87e20o4e116c87f4f4b259@mail.gmail.com>	 <1266516452.2877.12.camel@edumazet-laptop> <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Afi Gjermund <afigjermund@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38121 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab0BRSTx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:19:53 -0500
In-Reply-To: <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Afi Gjermund wrote:
> On Thu, Feb 18, 2010 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>>>> Shouldn't the value after the flush be 0? The traffic that has created
>>>>> this mess is from a REDIRECT rule in the PREROUTING chain of the 'nat'
>>>>> table.
>>>> Could you post a copy of these rules ?
>>>>
>>> iptables -t nat -A PREROUTING -p tcp -s X.X.X.X -d X.X.X.X --sport X
>>> --dport X -j REDIRECT --to-port X
>> Yes I understood you were using such rules, but I cannot understand how
>> it can trigger without real nics being plugged. So I asked you some
>> details, apprently you dont want to provide them and prefer to hide from
>> us :)
>>
> Lol, sorry. The X values are dynamic and depend on what network the
> device happens to be on, as well as the ephemeral source port.
> 
> iptables -t nat -A PREROUTING -p tcp -s 172.168.8.45 -d 172.168.8.200
> --sport 4351 --dport 4500 -j REDIRECT --to-port 45001

NAT is unlikely to be the cause since its widely used and there
are no other reports of leaks. Please describe your full setup,
especially things like traffic scheduling, network devices,
userspace queueing etc etc.
