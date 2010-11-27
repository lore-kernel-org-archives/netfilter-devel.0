From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Xtables2 Netlink spec
Date: Sat, 27 Nov 2010 14:39:51 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262057450.18326@blackhole.kfki.hu> <alpine.LNX.2.01.1011262159310.4752@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38003 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217Ab0K0NkM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Nov 2010 08:40:12 -0500
In-Reply-To: <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-11-27 10:06, Jozsef Kadlecsik wrote:
>
>a suspended process could cause any problem, we faced it already.

* let there be a list of 6 entries of data, ABCDEF
* proc A starts a dump and reads, say, 1 of 10 entries (A)
* proc B adds a new entry at the start of the list, Z,
  and deletes an entry, A
  (and does these two actions atomically)
* proc A reads the rest

procA read the sequence ACDEF. In case of interfaces or ct entries,
that does not matter, because they are pretty much independent of
another.

However, a ruleset's rules are not independent in this way. Suppose:

   Z = -A INPUT -m conntrack --ctstate ESTABLISHED
   A = -A INPUT -p icmp -j ACCEPT
   B = -A INPUT -p tcp --dport 22 -j ACCEPT
   C = -A INPUT -j DROP
   D = -A OUTPUT -p icmp -j ACCEPT
   E = -A OUTPUT -p tcp --dport 22 -j ACCEPT
   F = -A OUTPUT -j DROP

One would want to either see ABCDEF, or ZBCDEF, because
presenting ACDEF to the user,

	(a) -A INPUT -p icmp -j ACCEPT
	(c) -A INPUT -j DROP

would mean to him that SSH cannot be accessed, which is not the case.
We needs locks, yeah.

The entire ruleset and chains are RCU-protected, and the actual
packet processing holds rcu_read_lock for the entire period, so it is
already guaranteed to see either ABCDEF or ZBCDEF, which is fine.

When the kernel dumps however, and the skb is full, and it returns to
userspace, no rcu and no mutex may be held, which gives away the
guarantee of an atomic view. The chain might go away inbetween,
unless I hold the writer lock. To hold the lock across the entire
dump would require some semaphore, and it does not seem like a good
idea to block users across returns to userspace either.

Currently, the writer lock (mutex) is held as short as possible, to
make a snapshot, or to actually do the replacement. It sort of
works..

Does that help?
