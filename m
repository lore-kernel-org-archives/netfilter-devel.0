From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 16:46:22 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409281642500.32737@filer.marasystems.com>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1095993739.1044.9.camel@jzny.localdomain>
	<20040925075253.GQ3236@sunbeam.de.gnumonks.org>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<1096377276.8661.252.camel@jzny.localdomain>
	<1096379957.1026.5.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jamal Hadi Salim <hadi@znyx.com>
In-Reply-To: <1096379957.1026.5.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004, Jamal Hadi Salim wrote:

> Ok, I think this is Henrik may be saying as well:
> For each of the active nodes, you give it a range of ports to use.
> Maybe 1K ports each to start and then the ct_sync allows for nodes to
> ask for more. A port marked as "in use" by other nodes should not be
> used for simplicity. A node should also gc ports to the general pool.
> Thoughts?

Any controlled division of the tuple address space would solve the 
NAT problem.

I would use IP addresses in this scheme.. it is very nice to have NAT as 
non-intrusive as possible preserving what can be preserved of the original 
tuple.

There remains some delicate thinking on how to manage the traffic flows in 
a sane manner to make sure the correct traffic is forwarded by the correct 
node, considering failovers, recoveries etc.

Regards
Henrik
