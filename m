From: Evan Harris <eharris@puremagic.com>
Subject: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that breaks
 routing?
Date: Wed, 22 Oct 2003 19:46:40 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310221946250.29188-100000@kinison.puremagic.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


(Originally posted to users list, but since it is a possible bug or doc fix,
maybe the developers list is a better place).

I'm trying to setup a linux kernel box that is on an ip-ip vpn tunnel, and
want to DNAT all traffic (except the tunnel payload packets) for the "real"
ip of the other tunnel endpoint to go to its in-tunnel endpoint (so they are
properly encrypted).

The machine in question has a default route going to the tunnel device
(tun0), and a host specific route going out a different device (wlan0) so
the tunnel datagrams can get to the tunnel server.

After setting up the output DNAT, it is correctly rewriting the packets to
go to the in tunnel address.  However, after the rewrite, the kernel is
disregarding the routing that says that packets to the in-tunnel address
should go to the tun0 device, and instead is trying to send them out the
original device the packets would have gone out if they had not been
dnat'ed (wlan0).

According to the documentation for iptables, it appears that the OUTPUT
chain on the nat table should happen before the routing decision is made,
but that appears to not be the case.  Is this a bug, or are the docs wrong?
And if the docs are wrong, what is the correct way to accomplish this?

I am using a stock linux kernel 2.4.20, with iptables 1.2.8.  Please CC me,
as I am not on the mailing list.

Evan
