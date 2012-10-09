From: "Katia S." <katias@iit.demokritos.gr>
Subject: Re: iptables-dev Source Example
Date: Tue, 9 Oct 2012 18:33:44 +0300 (EEST)
Message-ID: <2aa140973d7d5a320bd1402da1647a26.squirrel@webmail.iit.demokritos.gr>
References: <5072D6F8.2010707@iit.demokritos.gr> <20121008152237.GA8350@1984>
    <CAHo-OoyUUHju8du-Otd6vfgv_ORz-Y_PrPB0VDKbU74jYy9hjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org,
	"Pablo Neira Ayuso" <pablo@netfilter.org>
To: Maciej =?UTF-8?Q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from zeus.iit.demokritos.gr ([143.233.226.2]:34150 "EHLO
	zeus.iit.demokritos.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2JIPdr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Oct 2012 11:33:47 -0400
In-Reply-To: <CAHo-OoyUUHju8du-Otd6vfgv_ORz-Y_PrPB0VDKbU74jYy9hjg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Well, I have been running "tc" commands like "tc qdisc" or "tc class" to
get some information I need on various devices and interfaces.

Right now I need to implement the exact same feature in a program of mine,
but I don't want to just externally call the "tc" command and read its
output... So I was searching for an API to use it in my source code. My
search led me to the iptc-dev and iptables-dev libraries, but those have
no tutorial or how-tos so I'm kinda lost...

So, that's my story and that's why I posted the initial question in this
mailing list.

I guess I'm gonna have to read the "tc" source codes and find a way on my
own.. Sounds like fun...not :p



>>> What I want to do is to write my very own program using the iptables
>>> library to query the interface information
>>> of various machines (queues, lost packets, total packets etc).
>
> I'm also not sure why you're even thinking about the 'iptables'
> library - it has to do with firewall management.
> Sounds like what you're wanting to query is basic interface statistics.
> I would suggest looking at programs like ip (iproute / iproute2)
> and/or netlink libraries (or worst case the obsolete ifconfig).
>
> - Maciej
>


-- 
Katia Sarsempagieva
-----
Research Associate
Media Networks Laboratory
Institute of Networks and Telecommunications
NCSR Demokritos

