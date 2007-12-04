From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Tue, 04 Dec 2007 16:07:30 +0100
Message-ID: <47556D32.1060901@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <4753B957.2000207@trash.net>	 <beb91d720712030435t3b8f6164p3a489880618ebee9@mail.gmail.com>	 <47550D5C.8090004@trash.net>	 <Pine.LNX.4.64.0712040950390.11746@fbirervta.pbzchgretzou.qr>	 <47551A83.80009@trash.net>	 <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>	 <475561C6.4030704@trash.net> <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34037 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557AbXLDPHd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:07:33 -0500
In-Reply-To: <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[netfilter-devel re-added. Please don't drop CCs]

Salatiel Filho wrote:
> On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
>
>>> I tried the patch but it didn`t work.
>>>
>>> ~# iptables --version [patched now]
>>> iptables v1.3.8
>>>
>>> ~# iptables -L
>>> iptables v1.3.8: can't initialize iptables table `filter': Invalid argument
>>> Perhaps iptables or your kernel needs to be upgraded.
>>
>> Could you send another strace please?
>>

> getsockopt(3, SOL_IP, 0x40 /* IP_??? */,
> "filter\0\0\0\0\0\0\340?\3@\310[\1@\1\0\0\0\244\213\0\0"..., [84]) = 0
> brk(0)                                  = 0x1c000
> brk(0x3d000)                            = 0x3d000
> getsockopt(3, SOL_IP, 0x41 /* IP_??? */, 0x1c0c0, 0xbea55c24) = -1


Thanks. The invalid fd usage is gone, this seems to be a problem
in the interaction between kernel and userspace. Please enable
debugging as I wrote a couple of mails ago and post the output.
