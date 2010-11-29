From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Xtables2 Netlink spec
Date: Mon, 29 Nov 2010 13:39:24 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1011291336400.27282@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr> <4CEE4B94.8010307@netfilter.org> <alpine.LNX.2.01.1011251327140.21752@obet.zrqbmnf.qr> <4CEE70CE.60502@netfilter.org> <alpine.LNX.2.01.1011251525490.3245@obet.zrqbmnf.qr> <4CEF6F12.7080601@netfilter.org>
 <alpine.LNX.2.01.1011261055210.24563@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262045410.18201@blackhole.kfki.hu> <alpine.LNX.2.01.1011262053470.30581@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011262057450.18326@blackhole.kfki.hu> <alpine.LNX.2.01.1011262159310.4752@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1011270951330.20431@blackhole.kfki.hu> <alpine.LNX.2.01.1011271319330.24289@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011271741030.21709@blackhole.kfki.hu> <alpine.LNX.2.01.1011271828270.28539@obet.zrqbmnf.qr> <alpine.DEB.2.00.1011272053230.22091@blackhole.kfki.hu>
 <4CF39CD2.50107@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:46110 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab0K2Mj0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:39:26 -0500
In-Reply-To: <4CF39CD2.50107@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 29 Nov 2010, Pablo Neira Ayuso wrote:

> On 27/11/10 21:42, Jozsef Kadlecsik wrote:
> > On Sat, 27 Nov 2010, Jan Engelhardt wrote:
> > 
> > > On Saturday 2010-11-27 18:04, Jozsef Kadlecsik wrote:
> > > > 
> > > > AFAIK when the kernel dumps and the skb is full, it's not returned
> > > > directly to the userspace but first enqueued.
> > > 
> > > I don't recognize that inside the code however.
> > > 
> > > In netlink_dump(), there is the cb->dump call. There are no loops
> > > inside this function. Neither are there in the two parents,
> > > netlink_dump_start() and netlink_recvmsg().
> > 
> > In netlink_dump() after the call to cb->dump, you can see the call to
> > skb_queue_tail. So the message is queued.
> > 
> > Where the looping happens, I do not know. Some socket magic?
> 
> 1) you send a NLM_F_DUMP request.
> 2) the kernel fills one skb and enqueue it into the socket buffer.
> 3) the process invokes recvmsg(), it gets the datagram, then go back to step
> 2).
> 
> Thus, the dump only consumes 1 memory page per recv() invocation. That's the
> magic.

So Jan has got right: if the process which initiated the dumping is 
suspended and locking is used, then the suspended process locks out all 
other processes.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
