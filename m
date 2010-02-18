From: Afi Gjermund <afigjermund@gmail.com>
Subject: Re: nf_conntrack_count versus '/proc/net/nf_conntrack | wc -l' count
Date: Thu, 18 Feb 2010 10:13:31 -0800
Message-ID: <48ceaa831002181013q46d4d623xcd88f6164a088729@mail.gmail.com>
References: <48ceaa831002150927q166b5955gfa0e1e465903d29d@mail.gmail.com>
	 <48ceaa831002151308y5bb2606n2058599f3ec4b82@mail.gmail.com>
	 <1266270757.2859.27.camel@edumazet-laptop>
	 <48ceaa831002151400q4178d121h28887cfdf6625499@mail.gmail.com>
	 <1266271377.2859.28.camel@edumazet-laptop>
	 <48ceaa831002151410j1dbdfce3tcbdb5ceaa86b0e2b@mail.gmail.com>
	 <48ceaa831002180940y65af65b4p5d887f2f1a50b4b@mail.gmail.com>
	 <1266515463.2877.10.camel@edumazet-laptop>
	 <48ceaa831002180955v4fd87e20o4e116c87f4f4b259@mail.gmail.com>
	 <1266516452.2877.12.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:57051 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab0BRSNe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:13:34 -0500
Received: by pxi29 with SMTP id 29so3587807pxi.1
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Feb 2010 10:13:34 -0800 (PST)
In-Reply-To: <1266516452.2877.12.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 18, 2010 at 10:07 AM, Eric Dumazet <eric.dumazet@gmail.com>=
 wrote:
> Le jeudi 18 f=E9vrier 2010 =E0 09:55 -0800, Afi Gjermund a =E9crit :
>> On Thu, Feb 18, 2010 at 9:51 AM, Eric Dumazet <eric.dumazet@gmail.co=
m> wrote:
>> > Le jeudi 18 f=E9vrier 2010 =E0 09:40 -0800, Afi Gjermund a =E9crit=
 :
>> >> I am still trying to figure out why the nf_conntrack_count differ=
s
>> >> from the table system.  I decided I would use the conntrack users=
pace
>> >> tools.
>> >> Both of my NICs are unplugged with no other userspace application=
s
>> >> running to affect connection tracking counts.
>> >>
>> >>
>> >> root@titan ~# date
>> >> Thu Feb 18 17:35:21 UTC 2010
>> >>
>> >> root@titan ~# ./conntrack -C conntrack
>> >> 351
>> >>
>> >> root@titan ~# date
>> >> Thu Feb 18 17:35:24 UTC 2010
>> >>
>> >> root@titan ~# ./conntrack -F conntrack
>> >> conntrack v0.9.14 (conntrack-tools): connection tracking table ha=
s been emptied.
>> >>
>> >> root@titan ~# date
>> >> Thu Feb 18 17:35:31 UTC 2010
>> >>
>> >> root@titan ~# ./conntrack -C conntrack
>> >> 351
>> >>
>> >> root@titan ~# date
>> >> Thu Feb 18 17:35:36 UTC 2010
>> >>
>> >> Shouldn't the value after the flush be 0? The traffic that has cr=
eated
>> >> this mess is from a REDIRECT rule in the PREROUTING chain of the =
'nat'
>> >> table.
>> >
>> > Could you post a copy of these rules ?
>> >
>> > Thanks
>> >
>> >
>> >
>> iptables -t nat -A PREROUTING -p tcp -s X.X.X.X -d X.X.X.X --sport X
>> --dport X -j REDIRECT --to-port X
>
> Yes I understood you were using such rules, but I cannot understand h=
ow
> it can trigger without real nics being plugged. So I asked you some
> details, apprently you dont want to provide them and prefer to hide f=
rom
> us :)
>
>
>
>
>
Lol, sorry. The X values are dynamic and depend on what network the
device happens to be on, as well as the ephemeral source port.

iptables -t nat -A PREROUTING -p tcp -s 172.168.8.45 -d 172.168.8.200
--sport 4351 --dport 4500 -j REDIRECT --to-port 45001
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
