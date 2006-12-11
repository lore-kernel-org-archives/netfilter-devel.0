From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: ROUTE target and conntrack
Date: Mon, 11 Dec 2006 15:44:12 +0100
Message-ID: <1165848252.2859.11.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: delaunois@info.ucl.ac.be
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

Hi C=C3=A9dric,

I'm heavily using your excellent ROUTE target from the linux
netfilter patch-o-matic-ng.

Recently, I noticed that outgoing packets routed out with ROUTE
don't seem to trigger connection tracking. E.g. after

iptables -A INPUT -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p udp -j DROP

iptables -t mangle -A POSTROUTING -s $NW1 -j ROUTE --gw $GW1

where NW1 contains my primary address on the uplink interface
kills DNS lookups. I see the udp packets go out and in with
tcpdump, but there's no entry in /proc/net/ip_conntrack, so the
incoming answer is dropped.

If I use this instead, it works:

iptables -t mangle -A POSTROUTING -s $NW1 -j ROUTE --gw $GW1 --continue
iptables -t mangle -A POSTROUTING -s $NW1 -j ACCEPT

Question: is what those 2 lines do (with respect to routing) identical
to what the one line above does?

Is it possible to "fix" the ROUTE target so conntracking is not
bypassed?

Thanks in advance,
Torsten
