From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 18:04:11 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281802330.25099@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr>
 <46FD2173.8030403@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40086 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbXI1QEN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:04:13 -0400
In-Reply-To: <46FD2173.8030403@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 28 2007 17:44, Patrick McHardy wrote:
>
>> Come to think of it, replacing by NOP is needed during
>> PMTUD where packets have to-be-stripped options.
>> 
>> Consider a three-machine setup with sender, iptables and receiver,
>> connected through MTU=1500 Ethernet. Assume a hypothethical TCP SYN
>> packet with lots of strip-me options that totals up at 2000 bytes.
>> Because of -j TCPOPTSTRIP, the packet will be reduced to, say, 80
>> bytes. The packet will pass, and the receiving end will confirm the
>> SYN. Now, the sending side believes the minimum MTU is 2000, since
>> its initial SYN was successfully replied to with SYN ACK. => Problem.
>> 
>> Makes sense?
>
>Hardly, the TCP header can contain a maximum of 40 bytes options :)

Well, then let it have [tcphdr] [stripopt] [lots of data] so that
the sum of it is 1504 if you want, and that by stripping one
option, it fits into the allotted 1500.

>Besides that: if the options are contained in every packet (lets
>say timestamp option) and is always stripped, the sender *should*
>assume the bigger MTU. And if it really overestimates it will
>receive a frag. needed message and learn the correct one.

It will not receive a frag on the SYN, but later on.
Does that work? I.e. subsequently change the tcp connection's base mtu?
