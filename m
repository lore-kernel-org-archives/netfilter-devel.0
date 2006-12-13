From: Patrick McHardy <kaber@trash.net>
Subject: Re: load balacing with https home banking
Date: Wed, 13 Dec 2006 23:45:14 +0100
Message-ID: <4580827A.7090708@trash.net>
References: <BAY103-DAV25AE1C31A08B7725D1CACB2D60@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marco Berizzi <pupilla@hotmail.com>
In-Reply-To: <BAY103-DAV25AE1C31A08B7725D1CACB2D60@phx.gbl>
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

Marco Berizzi wrote:
> [sorry for posting a user question to this
> list, but no luck with netfilter@ and lartc@]
> 
> Hello everybody.
> I'm running linux 2.6.19 (with iptables 1.3.7)
> with nth match to alternatively snat outgoing
> connections to two different ip addresses for
> load balancing between two adsl lines:
> Here is:
> 
> $IPTABLES -t nat -A POSTROUTING -s my_ip --protocol tcp -m
> multiport --dports 80,443 -m statistic --mode nth --every 2 -j SNAT --to
> adslA
> $IPTABLES -t nat -A POSTROUTING -s my_ip --protocol tcp -m
> multiport --dports 80,443 -j SNAT --to adslB

This just does NAT, where is the balancing?

> Things are working pretty good, but some
> applications (https home banking for example),
> don't work correctly (because the remote
> server see two different ip addresses). Is
> there a way to automagically tell netfilter
> to snat always with the same source ip for
> the same destination host? I have also
> modified SNAT with SAME, but no luck.


Multipath routing uses cached routes, so all attempts to communicate
between the same pair of hosts should use the same route. The
solution is to let routing make the decision and just use netfilter
to make sure the same route is used for all packets of a connection,
even if a cached route is evicted.

So you need something like:

ip route add default nexthop dev ppp0 realm 1 table 100
ip rule add fwmark 0x1 lookup 100
ip route add default nexthop dev ppp1 realm 2 table 200
ip rule add fwmark 0x2 lookup 200
ip route add default nexthop dev ppp0 realm 1 nexthop ppp1 realm 2

and:

iptables -A POSTROUTING -m connmark --connmark !0x0 -j RETURN
iptables -A POSTROUTING -m realm --realm 0x1 -j CONNMARK --set-mark 0x1
iptables -A POSTROUTING -m realm --realm 0x2 -j CONNMARK --set-mark 0x2

iptables -t mangle -A PREROUTING -j CONNMARK --restore-mark
iptables -t mangle -A OUTPUT -j CONNMARK --restore-mark

iptables -t nat -A POSTROUTING -o ppp+ -j MASQUERADE

Different TOS values might still break the thing, for it should work for
HTTP/HTTPS.
