From: "Preston A. Elder" <prez@srealm.net.au>
Subject: Re: [netfilter-core] iptables/conntrack in enterprise environment.
Date: Thu, 29 May 2003 10:16:07 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.33.0305291009480.21132-100000@castle.srealm.net.au>
References: <Pine.LNX.4.33.0305291422290.8961-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0305291422290.8961-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 May 2003, Jozsef Kadlecsik wrote:

> > The conntrack table itself very quickly grows - but it does not clean itself
> > up when the connection itself dissapears, instead it waits for some
>
> But how those connections disappear? Normal TCP closing?
The majority, I believe so, however, that is beside the point.  Should it
really matter if it was closed with a RST or a FIN/FINACK/ACK?  conntrack
should realise the connection is closed either way, and stop tracking it.

Hell, even if it didn't even get a RST *OR* FIN (ie. the lan cable was
unplugged or something, which is NOT happening), these are connections
to the LOCAL machine.  TCP keepalive should take care of it regardless.
In any case, the kernel TCP stack knows the connection is no longer valid
(and that port is now available for use again), why does connection
tracking still keep the connection tracked.

OK, I realise the connection tracking subsystem is keeping track of the
connection that is supposed to go to a remote machine, so it can't rely on
the local TCP stack, however, I'm pretty sure that every connection in
this case is getting either a RST or a FIN/FINACK/ACK to close down the
socket, so I really can't see why connection tracking has to wait for the
pre-set expiry time (ie. leave stale entries), it just seems sloppy.

Thanks,

PreZ (using a different email client, which is why this email is not
signed).
