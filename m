From: Christopher Hassell <jeezfrk-vger@jeezfrk.homeip.net>
Subject: live TCP connections run via iptables-intercepted packets??
Date: Wed, 16 Jun 2004 16:14:55 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087424095.1427.2.camel@lobotomus.homeip.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Hello (this was posted to netdev also), 

I would like to know if anyone has the data structures and call 
points which would allow use of the Linux TCP stack on its own
(unhashed, packets and initiation supplied elsewhere) with timers
going off as needed.

The idea being a "transducer" to translate a stream of TCP
data (normal TCP session) into a stream of UDP packets.

Yes this changes an ordered reliable stream into an unordered 
and unreliable stream but this is made for tunnelling over 
a reliable link.  (Latency is an issue, and TCP does NOT help
itself with added latency).  Consider it arbitrarily-addressed 
kernel-speed transparent proxying.

NO I'd not prefer a userland solution via DNAT or QUEUE, because 
latency-reduction is the question and it's not too complex a 
concept to just change TCP data to UDP and back.

How would it work for an end user you ask?

It would essentially convert incoming TCP connections into 
identically structured (IP:IP port:port) UDP packets and vice versa.
In the same way, on the far end, a UDP packet could initiate a kernel-
socket's
attempted connect() to the remote destination of the UDP packet.

A zero-length UDP packet would close the connection in the stack
and, yeah, no other TCP tricks could be controlled via the UDP stream.

It requires that...

        1) packets are intercepted and delivered via an IPTables target
           that routes all packets to the running TCP stack (not unlike
           the initial DNAT or SNAT packet does).
  
        2) acks or data packets can be sent any fashion needed
           as long as they proceed to normal routing as their addr
           befits

        3) no need for valid local IP address is needed

        4) timing events are fed to the code somehow

Is it reasonable?  Very few modules use TCP that I can see, 
from inside the kernel.

        -- CH
