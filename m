From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Thu, 06 Dec 2007 10:51:46 +0100
Message-ID: <4757C632.60503@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <475561C6.4030704@trash.net>	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>	 <47556D32.1060901@trash.net>	 <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>	 <475578F1.8060600@trash.net>	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>	 <47557D04.1040101@trash.net>	 <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>	 <47565BB3.9030500@trash.net> <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58795 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbXLFJwO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Dec 2007 04:52:14 -0500
In-Reply-To: <beb91d720712050339w7daeb392me3e3e3cc44bad0d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> On Dec 5, 2007 5:05 AM, Patrick McHardy <kaber@trash.net> wrote:
>> Salatiel Filho wrote:
>>
>>> iptables v1.3.8: can't initialize iptables table `filter': Invalid argument
>>> Perhaps iptables or your kernel needs to be upgraded.
>> Perhaps the 32/64 bit hacks that are still included in 1.3.8
>> are falsely enabled. Please post a few lines from the iptables
>> compilation output.
>>
> 
> Should i try 1.40 ?

I don't expect it will help, but would still be worth a try.

> # make
> Extensions found: IPv4:CLUSTERIP IPv4:recent IPv6:ah IPv6:esp
> IPv6:frag IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
> cc -O2 -Wall -Wunused -I"/lib/modules/2.6.12.6-arm2/build"/include
> -Iinclude/ -DIPTABLES_VERSION=\"1.3.8\"  -fPIC -o
> extensions/libipt_ah_sh.o -c extensions/libipt_ah.c

This looks OK, the 32/64 bit hacks are not enabled.
