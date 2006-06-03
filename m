From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: [LARTC] iptables CLASSIFY and MARK not working?
Date: Sat, 3 Jun 2006 12:43:08 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255436@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
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

> -----Original Message-----
> From: Patrick McHardy [mailto:kaber@trash.net]
> Sent: Thursday, June 01, 2006 4:02 PM
> To: Eliot, Wireless and Server Administrator, Great Lakes Internet
> Cc: lartc@mailman.ds9a.nl; Netfilter Development Mailinglist
> Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?
>=20
> Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> > Bridged iptables (ebtables) is not enabled in the kernel and I
cannot
> > seem to find a variable "bridge-nf-call-iptables" to set with
sysctl:
> >
> > wireless-r1 linux # sysctl -w bridge-nf-call-iptables=3D0
> > error: "bridge-nf-call-iptables" is an unknown key
> >
> > There is also no /proc/sys/net/*/bridge anything. I assume that
means
> > this is not something I need to worry about?
>=20
> Not sure yet, the problem would be created by CONFIG_BRIDGE_NETFILTER,
> not ebtables itself. Check for
> "/proc/sys/net/bridge/bridge-nf-call-iptables".
>=20
> I'm actually pretty sure that this is indeed what's causing the
problem,
> bridge netfilter defers calling the IP POST_ROUTING hook until the
> packet was already transmitted over the device (and before it goes
> out the underlying device), which means when it hits the CLASSIFY
> target it already passed through the qdisc.

Eh. What a pain. If I disable this, then ebtables will not call iptables
after the ebtables are finished running. I figured out that I could use
ebtables to match the destination MAC address like I needed for the
other problem I posted (See "Bi-directional packet classification with
ACK prioritization" thread for details). However, in order for that to
work, I have to have bridge-nf-call-iptables enabled. Essentially, I can
use the ebtables to flag the packets going to a destination MAC address
and then inside the iptables POSTROUTING mangle chain, I can pick up
that flag and reflag packets based on their Layer 3 and 4 information.
But, then I run right back into the problem of this thread in that the
packets are going through the TC qdiscs and classes before they hit the
POSTROUTING mangle chain.=20

Now, what confuses me is that I have this nice big printout of the order
that the packets traverse ebtables, iptables, and tc which was made by
Josh over at ImageStream (see
http://ebtables.sourceforge.net/br_fw_ia/PacketFlow.png for the image)
which clearly shows that it should go through ebtables POSTROUTING nat,
then iptables POSTROUTING mangle, then iptables POSTROUTING nat, then TC
qdisc classification, then TC qdisc deque. Also, after reading
http://benix.tamu.edu/unix/linux-bridge-ebtables.htm, it seems pretty
clear that the image depiction should be correct. But, since this is not
happening, either the code has changed or both those sources are just
wrong.=20

Do you happen to have any idea how I can get this straightened out? Do
we need to rewrite part of the code to make this work correctly? If that
is what it takes, I would be more than happy to look into doing that.=20

Maybe we can write a --destination-mac option for the iptables MAC
matching module? Is that information available to iptables in the
POSTROUTING mangle or nat chains? If not, would it be at all possible to
make it available? That would solve this problem very nicely.

Eliot Gable
Certified Wireless Network Administrator (CWNA)
Certified Wireless Security Professional (CWSP)
Cisco Certified Network Associate (CCNA)
CompTIA Security+ Certified
CompTIA Network+ Certified
Network and System Engineer
Great Lakes Internet, Inc.
112 North Howard
Croswell, MI 48422
(810) 679-3395
(877) 558-8324
=20
Now offering Broadband Wireless Internet access in Croswell, Lexington,
Brown City, Yale, Worth Township, and Sandusky. Call for details.
