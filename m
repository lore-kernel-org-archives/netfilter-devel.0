From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Tue, 07 Dec 2010 08:49:15 +0100
Message-ID: <4CFDE6FB.4060103@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org> <alpine.LNX.2.01.1012032156100.26825@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51597 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab0LGHt7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:49:59 -0500
In-Reply-To: <alpine.LNX.2.01.1012032156100.26825@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03/12/10 22:03, Jan Engelhardt wrote:
>
> On Friday 2010-11-26 09:25, Pablo Neira Ayuso wrote:
>>
>>> In fact, why don't we just use genetlink for new code instead?
>>
>> Genetlink is similar. The main difference is that the ID family number
>> and multicast groups for each subsystem is not fixed, it's registered in
>> runtime. This means that you have to make the "family name resolution",
>> ie. to send a message to resolve the ID family number and multicast
>> groups before doing any operation.
>>
>> Another reason is consistency, it's a good idea to use the mechanism
>> that other netfilter subsystems already use.
>
> "Look, iptables uses ioctl! Let's use ioctl again for xt2."

It's up to you to use an interface from the stone age.

> I am skeptical about shrinkfitting something onto an older
> interface (nfnetlink) when there is genetlink..

That's an empty argument. Tell me one feature that nfnetlink does not 
have have but genetlink does.

>>>> BTW, I didn't look at your protocol in deep yet but I'd suggest the
>>>> following basis to rework it: one netlink message, one rule operation.
>>>
>>> I can agree with that suggestion, so I will be doing that.
>
> Something else that came to mind -- if ordering of nlattrs is not
> guaranteed inside nlmsg, we could just pack all the data into a
> single attribute and mark it binary, which means potential relays (if
> nl ever gets that far!) won't reorder it.

that's an abuse of netlink.
