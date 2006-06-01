From: "Eliot, Wireless and Server Administrator,  Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: iptables CLASSIFY and MARK not working?
Date: Thu, 1 Jun 2006 15:58:44 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB25541A@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: lartc@mailman.ds9a.nl,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <lartc-bounces@mailman.ds9a.nl>
Content-class: urn:content-classes:message
To: "Patrick McHardy" <kaber@trash.net>
List-Unsubscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=unsubscribe>
List-Archive: <http://mailman.ds9a.nl/pipermail/lartc>
List-Post: <mailto:lartc@mailman.ds9a.nl>
List-Help: <mailto:lartc-request@mailman.ds9a.nl?subject=help>
List-Subscribe: <http://mailman.ds9a.nl/cgi-bin/mailman/listinfo/lartc>,
	<mailto:lartc-request@mailman.ds9a.nl?subject=subscribe>
Sender: lartc-bounces@mailman.ds9a.nl
Errors-To: lartc-bounces@mailman.ds9a.nl
List-Id: netfilter-devel.vger.kernel.org

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Thursday, June 01, 2006 3:44 PM
To: Eliot, Wireless and Server Administrator, Great Lakes Internet
Cc: lartc@mailman.ds9a.nl; Netfilter Development Mailinglist
Subject: Re: [LARTC] iptables CLASSIFY and MARK not working?

> Eliot, Wireless and Server Administrator, Great Lakes Internet wrote:
> > Both devices (br1 and wivl4) are bridged interfaces with spanning
tree
> > turned on. They also do VLANs. Specifically, vconfig was used to
create
> > a VLAN (in this case, VLAN 4) on two interfaces: eth2 and eth3.
These
> > two VLAN interfaces were called e2v4 and e3v4. Then, brctl was used
to
> > bridge the two VLAN interfaces (e2v4 and e3v4) into a new interface
> > called wivl4. Spanning tree was then enabled on wivl4. The MTU size
was
> > then adjusted -4 bytes to accommodate the VLAN tagging.=20
>=20
> Any chance you got bridge netfilter enabled? If so please disable
> it and try again (or set the bridge-nf-call-iptables sysctl to 0).
>=20
> Also, did you happen to try my specific rules (under different
devices)
> to see if they work?=20
>=20
> No, just tried CLASSIFY with my own HFSC setup, which is pretty
> similar.
>=20
> > If possible, could you try creating a VLAN interface and test on
that
> > interface? Then try a bridged interface. And finally, a bridged VLAN
> > interface.=20
> >=20
> > I will try to set this all up on a different machine without the
bridged
> > VLANs and see if it works there.
>=20
> I checked the code, neither VLAN nor bridge should matter.


Bridged iptables (ebtables) is not enabled in the kernel and I cannot
seem to find a variable "bridge-nf-call-iptables" to set with sysctl:

wireless-r1 linux # sysctl -w bridge-nf-call-iptables=3D0
error: "bridge-nf-call-iptables" is an unknown key

There is also no /proc/sys/net/*/bridge anything. I assume that means
this is not something I need to worry about?

=20
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
