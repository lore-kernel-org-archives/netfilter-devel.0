From: =?ISO-8859-1?Q?C=E9dric?= de Launois <delaunois@info.ucl.ac.be>
Subject: Re: How to change a packet's arriving interface? -j ROUTE?
Date: 06 Dec 2002 18:27:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1039195669.3355.68.camel@descartes.info.ucl.ac.be>
References: <3DF0D338.C2F4E50@Gallantry.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jason Liao <maillist@gallantry.com>
In-Reply-To: <3DF0D338.C2F4E50@Gallantry.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> I have a firewall running iptables with 3 interfaces: LAN, WAN and DMZ.=
=20
> The LAN IP address is 10.0.0.1/24, WAN 66.134.34.157/28, and DMZ
> 66.134.34.249/28.  The WAN interface connects to the Internet and the
> DMZ interface connects to a stub network.
>=20
> When someone sends a packet to the IP address of the DMZ interface from
> the Internet, the packet x.x.x.x->66.134.34.249 arrives at the WAN
> interface.  I want to know if there is a way using iptables (maybe with
> other tools such as iproute2) to make this packet to appear as if it
> arrives at the DMZ interface.  The packet itself should not be
> modified.  I need this to work because I am running an IPSec VPN with
> FreeS/WAN on the DMZ interface.  When the ESP packets arrives on the WA=
N
> interface, they cannot be properly processed by IPSec because the ipsec=
0
> interface is tied to the DMZ interface directly. =20
>=20
> I looked at the mangle table but could not figure out if it is the righ=
t
> direction.  I read about the ROUTE target but do not know if this targe=
t
> is for diverting packets to be sent OUT on another interface, or can it
> be used to change a packet's arriving interface.

With the ROUTE target, if you send a received packet to another
interface, it will go out through this interface and will not appear
as an incoming packet.

And if you use a rule such as :
iptables -A PREROUTING -t mangle -i eth0 -j ROUTE --to
<OTHER_IF__IP_ADDRESS>

then the packet will be sent through the local interface (this rule
tells the kernel to route the packet as if the destination IP address
was the address of the other interface).

Thus, at first look and as it is implemented now, the ROUTE target seems
to be unable to help you.

>=20
> Thanks in advance.
>=20
> Jason Liao
>=20
>=20

C=E9dric de Launois
