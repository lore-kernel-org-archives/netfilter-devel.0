From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrackd: basic TIPC implementation for NOTRACK mode
Date: Thu, 26 Jan 2012 01:19:28 +0100
Message-ID: <20120126001928.GA10554@1984>
References: <20120121085217.4272940o8fmk4v80@www.usherbrooke.ca>
 <20120122174140.GA18764@1984>
 <20120122162720.10123t2longq3zac@www.usherbrooke.ca>
 <20120123100733.GB23857@1984>
 <20120123132537.198937ydqdx1n3gg@www.usherbrooke.ca>
 <20120124010145.GA28314@1984>
 <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Quentin Aebischer <Quentin.Aebischer@USherbrooke.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40439 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673Ab2AZATa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jan 2012 19:19:30 -0500
Content-Disposition: inline
In-Reply-To: <20120124120058.234342gq75ohof6s@www.usherbrooke.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 24, 2012 at 12:00:58PM -0500, Quentin Aebischer wrote:
> >I think there are other flags that are useful in case you use TIPC in
> >stream mode:
> >
> >CHANNEL_F_STREAM
> >CHANNEL_F_ERRORS
> >
> >BTW, does your patch support selecting what communication semantics you
> >want to use for TIPC? In other words, what TIPC working mode are we
> >using with your patch? (sorry, I'm lazy to look at your original patch
> >to see it by myself). Please, justify.
> 
> We are not using stream mode at the moment. We are using TIPC
> SOCK_RDM, which is like SOCK_DGRAM, but guarantees that every
> messages sent over the network is properly delivered to its
> destination node.
> 
> There's no flow control mechanism when using SOCK_RDM in
> connectionless mode though (which is our case here), so if packets
> are not consumed fast enough on the receiver node side, they are
> queued up until we reach the maximum number of allowed messages in
> the queue. This maximum number is defined by the importance level of
> the TIPC messages sent by the sender (which is now a custom
> parameter in conntrackd.conf like you suggested).
> When we hit the limit, we then enter congestion mode on the receiving node.

Interesting. Please, in your follow-up patch, don't forget to extend
the example files under doc/sync/ to include some examples on how to
configure conntrackd with TIPC.

> Here, depending on the value of SRC_DEST_DROPPABLE, we either
> silently drop the packets, or return them with an error code (which
> we can detect on the sender side by looking for the return value of
> rcv(), that's what I tried to implement for my debug operations).

Thanks, very precise. It would be interesting to account those dropped
packets and to show them in the statistics (conntrackd -s).

> So yeah, basically I don't know what CHANNEL_BUFFER does :X.

if you activate CHANNEL_F_BUFFER, conntrackd may accumulate several
state-change messages in one packet. This reduces the pressure in the
tx path since less packets are transmitted (in datagram mode, you send
one datagram per send system call). It's similar to TCP Nagle but it
is controled by conntrackd, instead of the underlying protocol stack.

If you're using TIPC in datagram mode, this batching can be useful
to reduce CPU consumption. My suggestion is to enable it.
