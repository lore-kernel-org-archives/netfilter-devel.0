From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file
 descriptor
Date: Wed, 05 Dec 2007 09:05:07 +0100
Message-ID: <47565BB3.9030500@trash.net>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>	 <47551A83.80009@trash.net>	 <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>	 <475561C6.4030704@trash.net>	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>	 <47556D32.1060901@trash.net>	 <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>	 <475578F1.8060600@trash.net>	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>	 <47557D04.1040101@trash.net> <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Salatiel Filho <salatiel.filho@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54968 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbXLEIFX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2007 03:05:23 -0500
In-Reply-To: <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Salatiel Filho wrote:
> On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
>
>> Right, we only recently added it. Are you compiling against your
>> kernel source? Otherwise check in /usr/include/linux/...
>>
> How do i know if i am compiling against my kernel source ?
> Does it auto use /usr/src/linux/... ?
> anyway , i changed /usr/include/linux/linux/netfilter/x_tables.h but
> still the same problem.
> 
> 
> # iptables -L
> iptables v1.3.8: can't initialize iptables table `filter': Invalid argument
> Perhaps iptables or your kernel needs to be upgraded.

Perhaps the 32/64 bit hacks that are still included in 1.3.8
are falsely enabled. Please post a few lines from the iptables
compilation output.
