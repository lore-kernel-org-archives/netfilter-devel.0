From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [feature request] Fixed timeout for conntrack entry
Date: Tue, 24 Jan 2006 01:30:29 +0100
Message-ID: <43D57525.7080907@eurodev.net>
References: <1138008265.11978.29.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: nufw-core-team@nufw.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1138008265.11978.29.camel@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Eric,

Eric Leblond wrote:
> When working on NuFW (http://www.nufw.org), we had to use libconntrack
> to kill some entry at a given time. In fact, we use it to be able to
> have connections that expire at a given time. At the same time we use
> event handling system to be warned of connections that were closed
> before their expiration by the users.
> 
> This works well but there is a synchronisation problem because when the
> NuFW daemon restart you have to synchronise to handle events that have
> occur during shutdown :
> Let's have a connection and let it die when the daemon is off. When
> daemon restart, it could ask kernel to close this connection but it
> could then be another existing connection (with the same IPV4 or id
> parameters). Arghh ...

That's very unlikely to happen. If a new connection is opened with the
same IP information, the ID will be different than the old connection.
So such problem is unlikely to happen. Unless the daemon is so slow that
a wraparound happened to the global ID, eg. 2^32 connections were opened
at the time that the daemon was restarting. That would be really slow :)

> Even if it can be done with current functionnalities of conntrack
> (dumping conntrack table to daemon at start), it seems that this is not
> the cleanest way to do.
> 
> In fact, connection expiration is often a user requested feature
> (independantly of userspace system) and it could be great to have it
> hard wired in the kernel. For example, an iptables match and target
> could use it.
> 
> From a developpement point of view it seems that this is a "small"
> modification of code. It could be done by adding a test when refreshing
> standard connection entry timeout (when receiving a packet) and testing
> if the connection must be destroy and destroy it if needed ?

I think that we could add support for permanent conntracks, eg.
conntracks that never expire. So the userspace program could have their
own timers and kill it whenever it wants to. The problem is that the
userspace program must behave correctly, otherwise we could get tons of
zombie conntracks that never expire.

-- 
Pablo
