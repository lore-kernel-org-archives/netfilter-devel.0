From: "Drake Henderson" <dhenderson@n2bb.com>
Subject: packet forwarding
Date: Wed, 25 Jun 2003 11:27:42 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <382BC0C28F397F4785E7414B8279F5272BA1BC@n2-atl-exch.it.n2bb.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



I am trying to use libipq to forward packets.

Using the following iptable rules, forwarding works.

A. iptables -t nat -A PREROUTING -d 192.168.0.220 -p udp --dport 4488 -j
DNAT --to-destination 192.168.0.212:4488
B. iptables -t filter -A FORWARD -p udp -d 192.168.0.212 -j ACCEPT

In addition, adding rules to log the path of the packet based on the
script at
http://iptables-tutorial.frozentux.net/scripts/rc.test-iptables.txt, I
can see the packet move along the path

  mangle:prerouting, nat:prerouting, mangle:forward, filter:forward,
mangle:postrouting, nat:postrouting  (the right side path in the picture
at the below link)


http://iptables-tutorial.frozentux.net/chunkyhtml/traversingoftables.htm
l#TRAVERSINGGENERAL


The problem occurs when I change the target in rule A from DNAT to
QUEUE.  The handler program changes the destination of the packet and
then accepts it.  The packet, however, follows the path

  mangle:prerouting, nat:prerouting, mangle:input, filter:input (the
left side path in the picture)

Why, if the destination is changed at the nat:prerouting step, does the
routing decision not branch to the forward path instead of the input
path?

I know that the handler program is receiving the packets because if it
drops them, the path stops after nat:prerouting.


Thanks for you help,

Drake
