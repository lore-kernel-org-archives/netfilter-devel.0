From: Greg Stark <gsstark@mit.edu>
Subject: Handling a protocol through SNAT
Date: 10 Mar 2003 19:11:34 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87bs0ikbih.fsf@stark.dyndns.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


[Originally sent on netfilter-devel, I intended this to be more of a bug
report but by the time I finished writing it it turned into a plea for help.
So I guess it belongs here more than there]


I'm trying to get a protocol that doesn't deal well with NATS to work through
an iptables Masq/SNAT. I've solved a number of small problems already in
user-space but I think I'm stuck with two main problems that might require a
kernel module.

The next hurdle I'm facing is that one part of the protocol involves the
servers sending a packet to the client on a port the client is listening on.
The client doesn't normally send anything from that port.

I've modified the client to send a packet from that port to each server on
startup to tickle the SNAT. However that only seems to be working for the last
server it contacts. It seems the SNAT is only looking at the local port not
the remote ip address and port. I need to allow all the servers to reach the
client.

This seems like a bug in iptables that it isn't considering every flow
independently. Two remote ip addresses can contact the same port independently
and should be treated as separate flows, not be bucketed together.

Barring fixing this in iptables, how can I create a manual rule to forward all
packets coming in on the port the client is listening on to the client
regardless of which server it's being sent from? The next step would be to
make a module that did that automatically, but a manual rule would make me
happy for now.


-- 
greg
