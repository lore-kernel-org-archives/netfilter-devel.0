From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Sat, 27 Nov 2010 12:10:48 +0100
Message-ID: <4CF0E738.3050805@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org> <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49896 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab0K0LK5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Nov 2010 06:10:57 -0500
In-Reply-To: <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/11/10 14:59, Jan Engelhardt wrote:
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
> 
> That does not sound like a showstopper, though.
>
>>>> BTW, I didn't look at your protocol in deep yet but I'd suggest the 
>>>> following basis to rework it: one netlink message, one rule operation.
>>>
>>> I can agree with that suggestion, so I will be doing that.
>>
>> Great, this approach requires more memory because you spend one netlink
>> header for every rule, but the cost is worth since it provides flexibility.
> 
> As far as I can see, it won't cost me more memory; char buf[MNL_BUFFER_SIZE]
> remains, and the kernel part does not have to keep more state than before
> anyway, so it's a zero-sum game.

I meant that less rule-set data will fit into one buffer, but that extra
memory consumption gives you flexibility comes in return.

>>> On the other extreme, Perl5 has shown that, when there is no full
>>> specification, the code fills in. As it stands, af_netlink.c does
>>> support attribute ordering :-)
>>
>> I agree, it would be great to have some more specifications. However, 1)
>> someone would have to like doing that, and 2) Linux kernel evolves so
>> quick that documenting aspects remains a daunting task. Anyway, I don't
>> throw the towel on documentation, actually I'd like to do that.
>>
>> You are quite prolific in writing documentation, let me know if you are
>> interested if I write some drafts, in case that you want to
>> contribute/review. Or let me know if you decide to write something, I'd
>> be pleased to contribute of course.
> 
> I have in the pipeline an Netlink e-book, though it's more of a large
> howto (like "Writing Netfilter Modules") than an academicly dry RFC.

I have a 25 pages document that looks like a HOWTO for libmnl and
Netlink sockets in general that I'll release soon. I didn't publish it
yet because I wanted to release the library first. It comes after my
article.

But you are free not to cooperate and do the "lone rider" thing, of course.

>>> [...] memory needs to be allocated and stored, right before
>>> netlink_dump_start is called. [But] because nlk->cb->cb_args is
>>> inaccessible from outside[...], the lookup and allocation is
>>> currently done inside the dump function[...]
>>
>> What is that initial data handling in dumps for?
> 
> Making an atomic snapshot/copy of the table. A userspace client
> could take almost indefinitely on retrieving a table, so it is
> possible that something else changes tables meanwhile.

Why don't you lock the table during the dump?
