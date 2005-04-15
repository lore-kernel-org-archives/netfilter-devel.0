From: Hadrien HAMEL <hamel@enseirb.fr>
Subject: Pb using DROP in a PREROUTING hook with ip6tables
Date: Fri, 15 Apr 2005 17:54:46 +0200
Message-ID: <425FE3C6.6070807@enseirb.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm trying to develop a match module for filtering MLDv2 Reports packets
(multicast group management protocol in an IPv6 context). My module is
ready and works fine (at least, from what I see of the kernel messages I
print during the tests in the match function), and so I try to use it to
drop MLDv2 Reports.
Since MLDv2 is addressed to multicast group and not to a host address,
it is handled by the kernel before the routing stuff, so that I can't
use INPUT or FORWARD hooks. I must use the PREROUTING hook :

#ip6tables -t raw -A PREROUTING -p ipv6-icmp -m mldv2 -j DROP

Kernel messages show that the mldv2 packets are recognized (and so the
match function returns 1) but the packet aren't dropped. I've tried the
"mangle" table and the "raw" table, but both were ineffective. To be
sure that my module wasn't misbehaving, I tried to drop all the packets
in PREROUTING, with no effects. In comparison, the same command with
iptables (thus in IPv4) has blocked all the incoming packets (which is a
normal behaviour!).

Does anybody know if there is such a bug in ip6tables? Or is this a
misuse of it?

Thanks a lot!
Hadrien
