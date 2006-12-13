From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: load balacing with https home banking
Date: Wed, 13 Dec 2006 15:09:41 +0100
Message-ID: <BAY103-DAV2CEA296D8287F8FFF0075B2D60@phx.gbl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

[sorry for posting a user question to this
list, but no luck with netfilter@ and lartc@]

Hello everybody.
I'm running linux 2.6.19 (with iptables 1.3.7)
with nth match to alternatively snat outgoing
connections to two different ip addresses for
load balancing between two adsl lines:
Here is:

$IPTABLES -t nat -A POSTROUTING -s my_ip --protocol tcp -m
multiport --dports 80,443 -m statistic --mode nth --every 2 -j SNAT --to
adslA
$IPTABLES -t nat -A POSTROUTING -s my_ip --protocol tcp -m
multiport --dports 80,443 -j SNAT --to adslB

Things are working pretty good, but some
applications (https home banking for example),
don't work correctly (because the remote
server see two different ip addresses). Is
there a way to automagically tell netfilter
to snat always with the same source ip for
the same destination host? I have also
modified SNAT with SAME, but no luck.

TIA
