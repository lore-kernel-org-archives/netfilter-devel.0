From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connection tracking question
Date: Thu, 13 May 2004 01:00:59 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405130052490.7624-100000@filer.marasystems.com>
References: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Paul Albert <palbert@rovingplanet.com>
In-Reply-To: <6A94CF724B046C4FB3434D14A49A58BF1CB7D3@pluto.rovingplanet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 12 May 2004, Paul Albert wrote:

> Specifically, I would like to know when the ESTABLISHED state is set in
> the kernel.

In principle whenever there is a bare ACK.

For full details decode the state table in 
net/ipv4/netfilter/conntrack_proto_tcp.c, there you can see the exact TCP 
flag states that can cause a transition to ESTABLISHED.

Remember that the purpose of the conntrack TCP states is to try to deduce 
the TCP state of the endpoints, not to implement a TCP.

> I realize that it is when iptables sees an ACK of a SYN packet, for
> example, but if I have a firewall rule in the nat/PREROUTING chain that
> checks to ensure that the connection is ESTABLISHED, will the ACK packet
> cause the rule to be hit?

How do you match for ESTABLISHED?

ESTABLISHED != CONNECTED. The two is inherently different.

ESTABLISHED is a TCP state of ip_conntrack_proto_tcp indicating the type 
of packets currently seen on the connection and also used in conntrack 
expiration calculations.

CONNECTED is a state of conntrack indicating the nature of the flow of 
packets seen on the connection, or put simply that there is traffic in 
both directions.

> Does the connection tracking take place before the mangle/PREROUTING
> chain?

Yes. Connection tracking takes place before mostly everything. conntrack
runs in it's own hook very early in the packet processing.

Regards
Henrik
