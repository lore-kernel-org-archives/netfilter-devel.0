From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 21:52:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F943CE5.80809@trash.net>
References: <20031020071545.GA21521@sunbeam.de.gnumonks.org> <3F9426C1.6070908@trash.net> <20031020185258.GD20288@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020185258.GD20288@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>Actually, another point is what to do with expectations.  
>
>It's not as problematic as with conntrack's, but in general it's the
>same.  Let's say:
>
>- conntrack helper creates expectation for typle xyz
>- userspace gets a list of unconfirmed expects
>- expectation for tuple xyz is confirmed
>- conntrack helper creates a new expectation for tuple xyz
>- userspace wants to remove expectation by referring to tuple xyz.
>
>At least in this case, that might actually be what the user wants -
>since there is not much difference between the two expectations, other
>than time passing in between.
>
>If the helper is automatically re-adding expectation upon confirmation,
>than the user can race with incoming connections in order to 'break the
>circle' ;) 
>
>I think there is not too much point in removing expect's anyway.  The
>real need is for adding and modyfing expectations, in case there is a
>userspace conntrack/nat helper.
>
>What do you think?
>

I agree. Removing is not very important. Modifying also requires a way to
identify the expectation. Currently (as you might have noticed) the
expectations also include an id. The namespace could probably be smaller
than for conntracks but I need to think about this some more after catching
breakfast.

BTW: I thought a bit about userspace helpers, they need to be synchronous
like they are now so we don't get races were an expectation arrives before
it's registered. So they should probably receive their packets though
ip_queue. How realistic do you think is it to move ftp/irc/amanda... to
userspace ? All of them operate on low traffic protocols, but if they sent
packets to userspace through netlink sockets operation can easily be
interrupted be sending lots of traffic that will fill up the socket buffer.

>btw: In the failover code, I have another problem with regard to
>expect's:  A sibling conntrack has a pointer to the master expect, not
>the master conntrack.  But i somehow need to replicate that pointer.
>Without Krisztians idmap (that I've already ripped out), I'm now passing
>the master conntrack's tuple and the expectation's tuple.    This works
>while doing normal sync:  There can always be only one unconfirmed
>expectation for every tuple.
>
>However, when doing a initial sync (or a full-resync), I cannot
>replicate the whole tree of master and siblings - because I first
>replicate the conntracks and then later have to fill in the [confirmed]
>expectations as glue in between.  
>
>The only idea I have is to use the 'seq' number.  However, this again
>only works for TCP.
>
>Any other options?
>

I have not studied the code intensively, but can't you just sync the tables
in order of the hierachie:

conntrack
conntrack, master-expect, sibling-conntrack, sibling-conntrack, ...
conntrack
...

Best regards,
Patrick

>(in the Future, I think we will at least optionally have per-connection
>byte and packet counters.  Then the 'seq' field could be initialized to
>the byte counter at the time the expectation was raised.  This would
>solve the udp case [and other udp races which Patrick can tell us
>nightmares of]. However, this is once again enlarging conntrack - but
>only if somebody wants to use 'connbytes' match or create netflow-style
>connection logs.  But we could require that compile option in case
>somebody wants to enable failover)
>
