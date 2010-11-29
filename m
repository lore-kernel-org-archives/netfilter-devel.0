From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Xtables2 Netlink spec
Date: Mon, 29 Nov 2010 13:23:36 +0100
Message-ID: <4CF39B48.4090300@netfilter.org>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org> <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60631 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839Ab0K2MWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:22:55 -0500
In-Reply-To: <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/11/10 20:55, Jan Engelhardt wrote:
>
> On Friday 2010-11-26 20:48, Jozsef Kadlecsik wrote:
>>>>
>>>> What is that initial data handling in dumps for?
>>>
>>> Making an atomic snapshot/copy of the table. A userspace client
>>> could take almost indefinitely on retrieving a table, so it is
>>> possible that something else changes tables meanwhile.
>>
>> Why don't you lock the tables during dumping? That way the tables won't
>> change, whatever long time the dump takes. Snapshotting the table looks as
>> wasting memory and time.
>
> For that to work, I would have to use a locking primitive that can be
> held across returns to userspace, which leaves semaphores as the only
> option and, ya, I didn't quite feel like using _that_.

Abusing the Netlink protocol to overcome the "supposed to be" limitation 
does not seem to me the way to go. Moreover, if we ever have more than X 
bytes rule-sets (I don't remember that limit that you have previously 
mentioned), you'll have to add some locking strategy anyway.

The locking is the way to go.

> Also sounds a
> bit like a killer if an admin cannot update a table just because he
> forgot some dumper process in the background in suspended state. :-/

He will notice that he did that because he hits EAGAIN, so he can kill 
the process in background and retry.
