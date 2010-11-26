From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Fri, 26 Nov 2010 20:55:33 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:60867 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab0KZTze (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Nov 2010 14:55:34 -0500
In-Reply-To: <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-11-26 20:48, Jozsef Kadlecsik wrote:
>> >
>> >What is that initial data handling in dumps for?
>> 
>> Making an atomic snapshot/copy of the table. A userspace client
>> could take almost indefinitely on retrieving a table, so it is
>> possible that something else changes tables meanwhile.
>
>Why don't you lock the tables during dumping? That way the tables won't 
>change, whatever long time the dump takes. Snapshotting the table looks as 
>wasting memory and time.

For that to work, I would have to use a locking primitive that can be
held across returns to userspace, which leaves semaphores as the only
option and, ya, I didn't quite feel like using _that_. Also sounds a
bit like a killer if an admin cannot update a table just because he
forgot some dumper process in the background in suspended state. :-/
