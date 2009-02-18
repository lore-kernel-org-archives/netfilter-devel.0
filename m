From: Jianqing Zhang <arrow.jianqing@gmail.com>
Subject: Re: iptables vs. IPsec SP
Date: Wed, 18 Feb 2009 12:15:18 -0600
Message-ID: <8a38e1330902181015u65b2820w3a96340ec341073c@mail.gmail.com>
References: <8a38e1330902180817h6a2f9017v1b38b7f6a75fd6b3@mail.gmail.com>
	 <alpine.LSU.2.00.0902181728190.26536@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.180]:25466 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZBRSPU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:15:20 -0500
Received: by el-out-1112.google.com with SMTP id b25so14879elf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Feb 2009 10:15:18 -0800 (PST)
In-Reply-To: <alpine.LSU.2.00.0902181728190.26536@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes, that is also what I thought.

However it does not work in my test.
I add a SNAT rule on the host of 192.168.1.20 as following:

 iptables -t nat -A POSTROUTING -p udp --dport 5002 -o eth0 -j SNAT
--to-source 192.168.1.55

to change the source address of outgoing upd packets with port 5002 to
192.168.1.55.

I also insert one SPs as follows (output of "ip xfrm policy list"):

...
src 192.168.1.55/32 dst 192.168.1.21/32
	dir out priority 2080 ptype main
	tmpl src 192.168.1.20 dst 192.168.1.21
		proto esp reqid 16409 mode tunnel
...

Then I send udp multicast at the port 5002.

But, I cannot see any ESP packets by tcpdump. Furthermore, on the
recipient side, I can get the muliticast udp with the changed source
IP (192.168.1.55). Actually I have stopped IPsec on the recipient
side. It looks that IPsec on the sender side is bypassed. Do I miss
something?

Thanks


On 2/18/09, Jan Engelhardt <jengelh@medozas.de> wrote:
>
> On Wednesday 2009-02-18 17:17, Jianqing Zhang wrote:
>
>>If I configure both IPsec SPs and iptables, when an IP packet is going
>>out or coming,  which will process the packet first? SP or iptables
>>(netfilters) rules?
>
> On the input path, obviously ESP is the first one seen, then the unpacked
> one;
> on the output path this is precisely reversed.
>
