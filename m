From: Christian Riechmann <riechmann@fgan.de>
Subject: Change proposal for consistent "skb->pkt_type" after re-injection
Date: Tue, 29 Jun 2004 11:48:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040629094835.GA3141@rie.rie.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bus@fgan.de
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

Hello,

sometimes ago I came up with a question to this list asking,
whether iptables would allow the following processing:

Iptables filters and queues broadcasted or multicasted
UDP packets for a user space program:

   iptables -t mangle -A PREROUTING -i eth0 -p udp \
	--destination-port 140 -j QUEUE

Such packets are bearing an encapsulated TCP packet, which by the user
space program is decapsulated and re-injected by ipq_set_verdict 
into the normal kernel processing.

The answer was YES.

But when I tested this situation, the TCP-packet were "lost"
and the TCP connection was not installed.

Michael Bussmann <bus@fgan.de> found out that the TCP packet
were not LOST, but they were DISCARDED within the kernel function
tcp_v4_rcv resp. tcp_v6_rcv, each doing an initial test:

	if (skb->pkt_type!=PACKET_HOST)
		goto discard_it;

Apparantly the skb->pkt_type is set very early within one of the
kernel IP routines passed by the broadcasted or multicasted packet
BEFORE iptables gave it to the user space program and the
modified (now TCP packet with a host address) packet is re-injected
into the kernel processing. Unfortunately an update of 
skb->pkt_type does not occur. This leads to the DISCARD of the
TCP packet.

We have the same behaviour within IPv4 and IPv6.

One - bad - solution for this problem could be to delete the above
test within the TCP functions, but this would produce difficulties,
if some people (hacker?) would send IP/TCP packets with multicast or
broadcast addresses.

As a better solution I would propose, that the processing initiated
by ipq_set_verdict should update the packet type (skb->pkt_type)
according to the re-injected packet.
This would lead to a consistent state of the re-injected packet and
the kernel status indicator.

I do not know, whether there exist other status indicators set before
and not updated after the re-injection, but if yes, they should be
updated as well.

Regards

Christian Riechmann
-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany
