From: "Ferry Huberts" <ferry@hupie.com>
Subject: Multicast & iptables
Date: Tue, 6 Jul 2004 11:35:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <62095.217.169.232.210.1089106503.squirrel@hupie.xs4all.nl>
Reply-To: ferry@hupie.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Hello guys & gals

I have a question w.r.t. multicast and iptables for a very 'unique'
application. It's a kind of 'box in the middle' application.
So that you're warned :-)

I have a userspace application opening a socket on the external interface
and subscribing itself to a multicast address.

When the box receives a packet addressed to itself on its internal
interface, it does a PREROUTING/DNAT to the multicast address and a
POSTROUNTING/SNAT to its external interface.

When the box receives a packet addressed to itself on its external
interface, it does a PREROUTING/DNAT to the internal default gateway for
multicast and a POSTROUNTING/SNAT to its internal interface.

I do have ip_forwarding on 1 in /proc :-)

However, this does not seem to work :-(
When I sniff traffic I do see that IGMP is ok, so my userspace app. is
doing ok, but I don't see the NATted traffic at all.
Are multicast addresses 'blocked' by iptables or am I making a mistake here?

much appreciated

Ferry Huberts
