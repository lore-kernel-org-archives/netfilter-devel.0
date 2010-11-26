From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 14:59:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr>
 <4CEF6F12.7080601@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36843 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab0KZN7o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 08:59:44 -0500
In-Reply-To: <4CEF6F12.7080601@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-11-26 09:25, Pablo Neira Ayuso wrote:
>
>> In fact, why don't we just use genetlink for new code instead?
>
>Genetlink is similar. The main difference is that the ID family number
>and multicast groups for each subsystem is not fixed, it's registered in
>runtime. This means that you have to make the "family name resolution",
>ie. to send a message to resolve the ID family number and multicast
>groups before doing any operation.

That does not sound like a showstopper, though.

>>> BTW, I didn't look at your protocol in deep yet but I'd suggest the 
>>> following basis to rework it: one netlink message, one rule operation.
>> 
>> I can agree with that suggestion, so I will be doing that.
>
>Great, this approach requires more memory because you spend one netlink
>header for every rule, but the cost is worth since it provides flexibility.

As far as I can see, it won't cost me more memory; char buf[MNL_BUFFER_SIZE]
remains, and the kernel part does not have to keep more state than before
anyway, so it's a zero-sum game.

>> On the other extreme, Perl5 has shown that, when there is no full
>> specification, the code fills in. As it stands, af_netlink.c does
>> support attribute ordering :-)
>
>I agree, it would be great to have some more specifications. However, 1)
>someone would have to like doing that, and 2) Linux kernel evolves so
>quick that documenting aspects remains a daunting task. Anyway, I don't
>throw the towel on documentation, actually I'd like to do that.
>
>You are quite prolific in writing documentation, let me know if you are
>interested if I write some drafts, in case that you want to
>contribute/review. Or let me know if you decide to write something, I'd
>be pleased to contribute of course.

I have in the pipeline an Netlink e-book, though it's more of a large
howto (like "Writing Netfilter Modules") than an academicly dry RFC.

>>[...] memory needs to be allocated and stored, right before
>>netlink_dump_start is called. [But] because nlk->cb->cb_args is
>>inaccessible from outside[...], the lookup and allocation is
>>currently done inside the dump function[...]
>
>What is that initial data handling in dumps for?

Making an atomic snapshot/copy of the table. A userspace client
could take almost indefinitely on retrieving a table, so it is
possible that something else changes tables meanwhile.
