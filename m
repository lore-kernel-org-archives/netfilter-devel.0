From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: RE: [PATCH] support --physdev-out for routed packets
Date: Fri, 3 Aug 2007 23:13:10 -0500
Message-ID: <925A849792280C4E80C5461017A4B8A210BA70@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>, "Philip Craig" <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

>>The thing I still don't get
>>is .. if you combine a bunch of devices in a bridge, why would you=20
>>care which port a packet will leave through? If you already know=20
>>behind which port something is reachable, why use a bridge?=20

I just now saw this thread.  I've been struggling with a similar
situation for a while now.  I have two examples why I need to care about
the physical device and still bridge.  First is a network I inherited.
I didn't and wouldn't build it this way.  It has public IP Addresses in
the same subnet on both sides of the bridge.  Some are "inside" systems
that need to be protected, others are "outside" systems, such as the
router that really need to be outside the firewall.  Proxy ARP
definitely does not work in this case because the "inside" segment has a
load balancing system that does its own proxy ARP.  So the firewall
proxy ARP and the load balancer proxy ARP fight with each other and keep
me up all hours trying to figure it out.  The only viable solution is
bridging.  But I still need a way to test for systems connected to which
physical NIC in the firewall. =20

The second example is a videoconferencing system using the H.323
conntrack module.  I have situations with several older Polycom and
Tandberg codecs that never understood how to work in a NAT environment.
These need to have public IP Addresses, but I want them behind the best
firewall I know how to build, mostly so I can do some QOS at the network
boundary.  I've been using proxy ARP for a while, but proxy ARP has its
share of problems.  One problem is, it's very difficult to add new
devices to the network when the firewall proxy ARPs everything!  So the
new device with address a.b.c.d tries to be a good neighbor and does an
ARP request to see if anyone already has the IP Address it wants to
assume.  The proxy ARPed firewall answers - because it answers ARP
requests "in proxy" for everyone and everything, so the new device does
not asume the IP Address and come online.  Bridging would solve this
problem nicely, but I still need a way to do tests based on the physical
interface. =20

Oh yes - proxy ARP also plays havoc with OpenSWAN and IPSEC tunnels.
These need an IP Address that belongs to one and only one interface.  In
the past, I've taken a public IP Address from the block of addresses and
used this new address for tunnels.  Again, bridging would be a great
solution, but it really needs a way to test for the real physical
device.=20

- Greg Scott
