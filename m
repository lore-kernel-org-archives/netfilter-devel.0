From: "Nikolai Dahlem" <Nikolai.Dahlem@epygi.de>
Subject: UDP-conntrack/nat question
Date: Thu, 25 Sep 2003 09:13:08 +0200
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <DAELKAPIKOFAFFKELNHOIEADCAAA.Nikolai.Dahlem@epygi.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-admin@lists.netfilter.org>
To: <netfilter@lists.netfilter.org>, <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm trying to conntrack/nat a udp-based protocol with a server listening on
port x. My problem is, that the conntrack-helper sees all incoming and
outgoing packets of the control connection, while the nat-helper is only
called for outgoing packets. Due to the nature of the protocol I need
IP_NAT_HELPER_F_ALWAYS to mangle the contents of both outgoing and incoming
packets (even when there are no expected connections).

The scenario is the following:

PC1 -> MASQ -> server

The conntrack module gets a packet from PC1 (src port x, dst port x) and
parses the protocol.
The nat_module mangles the packet content and the packet is send of to the
server with the source address of MASQ (src port x, dst port x).
The conntrack_module receives a packet from Server (src port: high, dst port
x) and parses the protocol.
The nat_module isn't called.

I reqister my modules with the following tuples:

nat_module:
hlpr->tuple.dst.protonum = IPPROTO_UDP;
hlpr->tuple.src.u.udp.port = port x;
hlpr->mask.src.u.udp.port = 0xFFFF;
hlpr->mask.dst.protonum = 0xFFFF;
hlpr->flags = IP_NAT_HELPER_F_ALWAYS;

conntrack_module:
hlpr->tuple.src.u.udp.port = port x;
hlpr->tuple.dst.protonum = IPPROTO_UDP;
hlpr->mask.src.u.udp.port = 0xFFFF;
hlpr->mask.dst.protonum = 0xFFFF;


/proc/net/ip_conntrack lists both connections (answer&reply) as unreplied.
Can someone explain to me why the reply is seen as a new connection ?


regards

Nikolai Dahlem
