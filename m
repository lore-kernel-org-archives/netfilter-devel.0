From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: [nf-failover] Re: [RFC] ct_sync 0.15 (corrected)
Date: Tue, 28 Sep 2004 10:24:38 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a040928072462b9f44@mail.gmail.com>
References: <1092407190.2402.120.camel@nienna.balabit>
	<1096290473.1075.64.camel@jzny.localdomain>
	<20040927133904.GP3236@sunbeam.de.gnumonks.org>
	<1096339276.8660.30.camel@jzny.localdomain>
	<Pine.LNX.4.61.0409280834520.29563@filer.marasystems.com>
	<1096369001.8661.165.camel@jzny.localdomain>
	<1096374273.7192.27.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281432550.31930@filer.marasystems.com>
	<1096376252.7192.47.camel@nienna.balabit>
	<Pine.LNX.4.61.0409281554150.32381@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>, hadi@cyberus.ca,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>,
	KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0409281554150.32381@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 28 Sep 2004 15:58:52 +0200 (CEST), Henrik Nordstrom
<hno@marasystems.com> wrote:
> On Tue, 28 Sep 2004, KOVACS Krisztian wrote:
> 
> > There are other solutions for that problem, for example Harald's
> > ClusterIP code. If we could integrate that with ct_sync we would be able
> > to do multi-master packet filter clusters without any load balancers
> > before the cluster. If the NAT core would be integrated with ClusterIP's
> > hash to avoid conntrack clashes we could do this without statically
> > assigning different NAT addresses to each node.
> 
> Any ideas on how would this work?
> 
> Lets reason around the common MASQUERADE case where an internal network
> needs to be SNAT:ed when going out to the Internet.

Forgive me for bringing this back up, but...

I believe that Saru handles this problem by assigning "blocks" (a
block being a fixed-sized range of units, e.g. 512 source ports in
sequence) of IPs and ports to various nodes in the cluster and each
node only handles the IP/ports in its assigned blocks. The lookup is
just a bitop so its fast and this would handle the MASQUERADE case
mentioned above nicely. The blocks are handed out by a userspace
daemon as nodes enter and leave the cluster.

Would this not work?

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
