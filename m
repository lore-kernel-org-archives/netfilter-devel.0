From: marian stagarescu <marian@ti.com>
Subject: how to flush ip conntrack entries ?
Date: 09 Oct 2002 17:55:44 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034200544.30113.140.camel@gt4rvnd11.telogy.design.ti.com>
References: <3DA48D59.7060109@secureinteriors.com>
	<20021009204018.GA15171@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20021009204018.GA15171@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i run into the problem described here and i wondered if someone knows of
a solution:

       +----------+
       |  SNAT    |
private|--------> |(eth1: public ip)
  ip   +----------+

1) setup masquerading 
(iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADING)

and ping continuously from private to public. all ok.

2) flush the NAT

iptables -t nat -F

(ping will stop working obviously but i don't kill the ping process,
just keep sending echo, no reply)

3) put back nat:
(iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADING)

!!! ping does not come back !!!

4) I have to stop the pings and 

5) restart them to make it work.

looking at the ip_conntrack proc entry it was noticed that:

after flushing (step 2) an UNREPLIED entry for icmp is there
(no reply hence unreplied) but its ttl does not decrement.
(ping echos are still hitting the nat box from private side)

stoping the ping (step 4) allows the ttl timer of the conntrack entry 
to start decrementing (30 sec)

restaring the pings (i don't have to wait till ttl goes to zero ?!?)
(step 5) but now with nat back on (step 3) I don;t get the icmp entry on
conntrack but all is ok (pings goes thru).

question is: is there a way to achieve this (looks like start
decrementing that ttl or reseting it to zero in conntrack) in the nat
box without having to stop the pings on the host side ?

thanks,
marian
