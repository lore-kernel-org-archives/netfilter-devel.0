From: Balazs Scheidler <bazsi@balabit.hu>
Subject: conntrack and ICMP errors
Date: Thu, 10 Apr 2003 20:20:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030410182056.GA17723@bzorp.balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I've ran into a fact recently which may or may not be intended behaviour for
conntrack. Given a connection in the ESTABLISHED state and a related ICMP
error is received by conntrack the connection state is not affected in any
ways.  In practice this might mean that when a connection is terminated by
an ICMP destination unreachable instead of a normal TCP packet the
connection will not terminate.

I encountered this problem when proxying UDP based protocols: a connection
is NATed to the proxy and when the proxy quits the stack returns ICMP errors
to the sender. The error is correctly deNATed but the connection is not
terminated, thus further packets are still being taken as part of the
previous connection.

UDP session:
192.168.1.1:1025	-> 		1.2.3.4:53
			|
			+> session redirected to the local stack (IP 192.168.1.2:50053)

Proxy runs on port 50053, the conntrack session starts as the first packet
is sent to the server, this triggers the DNAT mapping (1.2.3.4:53 ->
192.168.1.2:50053) to be applied.

Now the proxy exits, the local port 192.168.1.2:50053 is closed. Another
packet is sent by the client within the session timeout, this packet is
assumed to be part of the previously established connection, thus it is
NATed to 192.168.1.2:50053, there is no program listening, thus the stack
returns the ICMP error destination unreachable (port unreachable), this is
taken as a RELATED packet, and correctly deNATed just like anything, but the
conntrack session is still not terminated.

Of course using transparent proxying is still not a common usage scenario,
but the same problem can be applied to other situations as well: you have an
ESTABLISHED TCP connection when one of the endpoints dies (either the host
crashes or the corresponding IP connection is broken), no TCP packets are
sent prior the connection is broken, thus the conntrack session remains in
ESTABLISHED case. Even if the last-hop router returns a host unreachable
error the conntrack entry stays in the table for 5 days.

My question is: is this behaviour intended or simply accidental?


-- 
Bazsi
