From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 Netlink spec
Date: Sat, 27 Nov 2010 18:04:22 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011271741030.21709@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262057450.18326@blackhole.kfki.hu> <alpine.LNX.2.01.1011262159310.4752@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu> <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:54715 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944Ab0K0REY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Nov 2010 12:04:24 -0500
In-Reply-To: <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 27 Nov 2010, Jan Engelhardt wrote:

> On Saturday 2010-11-27 10:06, Jozsef Kadlecsik wrote:
> >
> >a suspended process could cause any problem, we faced it already.
> 
> * let there be a list of 6 entries of data, ABCDEF
> * proc A starts a dump and reads, say, 1 of 10 entries (A)
> * proc B adds a new entry at the start of the list, Z,
>   and deletes an entry, A
>   (and does these two actions atomically)
> * proc A reads the rest
[...] 
> When the kernel dumps however, and the skb is full, and it returns to
> userspace, no rcu and no mutex may be held, which gives away the
> guarantee of an atomic view. The chain might go away inbetween,
> unless I hold the writer lock. To hold the lock across the entire
> dump would require some semaphore, and it does not seem like a good
> idea to block users across returns to userspace either.

AFAIK when the kernel dumps and the skb is full, it's not returned 
directly to the userspace but first enqueued. And if the userspace 
listener is too slow/not ready to receive the netlink messages from the 
queue, then the queue can get full and messages will be lost. So I think 
the steps are:

* let there be a list of 6 entries of data, ABCDEF
* proc A starts a dump, and kernel enqueues the messages, which
  cover all entries. From kernel point of view the dumping is done.
  At the same time Proc A is receiving the messages from the queue...
* proc B adds a new entry at the start of the list, Z,
  and deletes an entry, A (and does these two actions atomically)
* ...proc A reads the rest from the queue.
  If messages are not lost due to the slow userpsace handling, then the 
  received state is correct and corresponds to the one when the dump
  was initiated.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
