From: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Subject: RE: POSTROUTING hooks
Date: Mon, 5 Jun 2006 13:32:51 -0400
Message-ID: <0633E0EDB4F25F43A2D7179CA11FAFAB255456@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: "Patrick Schaaf" <bof@bof.de>
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
> From: Patrick Schaaf [mailto:bof@bof.de]
> Sent: Monday, June 05, 2006 1:25 PM
> To: Eliot, Wireless and Server Administrator, Great Lakes Internet
> Cc: Patrick Schaaf; Netfilter Development Mailinglist
> Subject: Re: POSTROUTING hooks
>=20
> > So, given that the kernel keeps a mapping of the IP->MAC and the
packet
> > contains the destination IP, why can't we just look up the
destination
> > MAC for that IP in the kernel table, if it exists.
>=20
> I think that's what destination MAC matching did, before it was
removed.
>=20
> If I remember correctly, ARP stuff happens in a sufficiently different
> locking context from iptables processing, so nobody wanted to (could
> sanely)
> maintain an external access to the ARP structures just for the sake of
a
> destination MAC iptables match.
>=20
> Maybe I misremember. Corrections welcome.
>=20

I don't ever recall seeing destination MAC matching support. Do you know
what version of the code this was in?
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
