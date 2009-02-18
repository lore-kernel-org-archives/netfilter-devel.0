From: Jianqing Zhang <arrow.jianqing@gmail.com>
Subject: Re: iptables vs. IPsec SP
Date: Wed, 18 Feb 2009 12:17:25 -0600
Message-ID: <8a38e1330902181017o6892d93ek53162ceafa9b136d@mail.gmail.com>
References: <8a38e1330902180817h6a2f9017v1b38b7f6a75fd6b3@mail.gmail.com>
	 <alpine.LSU.2.00.0902181728190.26536@fbirervta.pbzchgretzou.qr>
	 <8a38e1330902181015u65b2820w3a96340ec341073c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.217.174]:58715 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZBRSX2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 13:23:28 -0500
Received: by gxk22 with SMTP id 22so85284gxk.13
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Feb 2009 10:23:27 -0800 (PST)
In-Reply-To: <8a38e1330902181015u65b2820w3a96340ec341073c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Oops, I get it. SP does not catch multicast address in this case.
Sorry about that.


On 2/18/09, Jianqing Zhang <arrow.jianqing@gmail.com> wrote:
> Yes, that is also what I thought.
>
> However it does not work in my test.
> I add a SNAT rule on the host of 192.168.1.20 as following:
>
>  iptables -t nat -A POSTROUTING -p udp --dport 5002 -o eth0 -j SNAT
> --to-source 192.168.1.55
>
> to change the source address of outgoing upd packets with port 5002 to
> 192.168.1.55.
>
> I also insert one SPs as follows (output of "ip xfrm policy list"):
>
> ...
> src 192.168.1.55/32 dst 192.168.1.21/32
> 	dir out priority 2080 ptype main
> 	tmpl src 192.168.1.20 dst 192.168.1.21
> 		proto esp reqid 16409 mode tunnel
> ...
>
> Then I send udp multicast at the port 5002.
>
> But, I cannot see any ESP packets by tcpdump. Furthermore, on the
> recipient side, I can get the muliticast udp with the changed source
> IP (192.168.1.55). Actually I have stopped IPsec on the recipient
> side. It looks that IPsec on the sender side is bypassed. Do I miss
> something?
>
> Thanks
>
>
> On 2/18/09, Jan Engelhardt <jengelh@medozas.de> wrote:
>>
>> On Wednesday 2009-02-18 17:17, Jianqing Zhang wrote:
>>
>>>If I configure both IPsec SPs and iptables, when an IP packet is going
>>>out or coming,  which will process the packet first? SP or iptables
>>>(netfilters) rules?
>>
>> On the input path, obviously ESP is the first one seen, then the unpacked
>> one;
>> on the output path this is precisely reversed.
>>
>
