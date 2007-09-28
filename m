From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 17:44:51 +0200
Message-ID: <46FD2173.8030403@trash.net>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de> <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr> <46FD1798.2020302@trash.net> <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55057 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbXI1PpU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:45:20 -0400
In-Reply-To: <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Sep 28 2007 17:02, Patrick McHardy wrote:
> 
>>For TCPOPTSTRIP I would expect either real stripping or replacement
>>by TCPOPT_NOP. In which cases does replacement by something else
>>make sense?
>>
> 
> In case sends the layer4, layer3 or layer2 size of a packet in
> layer7 data.


Thats a reason for using NOPs, but whats the reason for allowing
to use something different?

> Come to think of it, replacing by NOP is needed during
> PMTUD where packets have to-be-stripped options.
> 
> Consider a three-machine setup with sender, iptables and receiver,
> connected through MTU=1500 Ethernet. Assume a hypothethical TCP SYN
> packet with lots of strip-me options that totals up at 2000 bytes.
> Because of -j TCPOPTSTRIP, the packet will be reduced to, say, 80
> bytes. The packet will pass, and the receiving end will confirm the
> SYN. Now, the sending side believes the minimum MTU is 1600, since
> its initial SYN was successfully replied to with SYN ACK. => Problem.
> 
> Makes sense?


Hardly, the TCP header can contain a maximum of 40 bytes options :)
Besides that: if the options are contained in every packet (lets
say timestamp option) and is always stripped, the sender *should*
assume the bigger MTU. And if it really overestimates it will
receive a frag. needed message and learn the correct one.


