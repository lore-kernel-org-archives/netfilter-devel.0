From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] TCPOPTSTRIP target
Date: Fri, 28 Sep 2007 17:34:49 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0709281734400.25099@fbirervta.pbzchgretzou.qr>
References: <873awz2s7u.fsf@begreifnix.intranet.astaro.de>
 <Pine.LNX.4.64.0709281607250.25099@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0709281643520.25099@fbirervta.pbzchgretzou.qr>
 <46FD1798.2020302@trash.net> <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Sven Schnelle <svens@bitebene.org>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46449 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776AbXI1Peu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:34:50 -0400
In-Reply-To: <Pine.LNX.4.64.0709281722060.25099@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Sep 28 2007 17:33, Jan Engelhardt wrote:
>>
>>For TCPOPTSTRIP I would expect either real stripping or replacement
>>by TCPOPT_NOP. In which cases does replacement by something else
>>make sense?
>>
>In case sends the layer4, layer3 or layer2 size of a packet in
>layer7 data.
>
>Come to think of it, replacing by NOP is needed during
>PMTUD where packets have to-be-stripped options.
>
>Consider a three-machine setup with sender, iptables and receiver,
>connected through MTU=1500 Ethernet. Assume a hypothethical TCP SYN
>packet with lots of strip-me options that totals up at 2000 bytes.
>Because of -j TCPOPTSTRIP, the packet will be reduced to, say, 80
>bytes. The packet will pass, and the receiving end will confirm the
>SYN. Now, the sending side believes the minimum MTU is 1600, since
>its initial SYN was successfully replied to with SYN ACK. => Problem.

er, 2000. Whatever, just something >1500.
