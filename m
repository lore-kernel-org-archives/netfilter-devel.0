From: Alexander Samad <alex@samad.com.au>
Subject: Re: IPSEC and NAT
Date: Sat, 16 Oct 2004 11:18:06 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041016011805.GB2682@samad.com.au>
References: <1097877726.2771.47.camel@localhost>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vGgW1X5XWziG23Ko"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--vGgW1X5XWziG23Ko
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 16, 2004 at 12:03:44AM +0200, Emiel Mols wrote:
> Well, I only control one end of the link :). This one ip address is assig=
ned
> to me and I have to find a way to NAT it :(.

if you know the IP address why not use snat, this is how I used to do it
?

Alex

>=20
> netfilter-devel@lists.netfilter.org
> -----Original Message-----
> From: John A. Sullivan III [mailto:john.sullivan@nexusmgmt.com]=20
> Sent: zaterdag 16 oktober 2004 0:02
> To: Emiel Mols
> Cc: netfilter-devel@lists.netfilter.org
> Subject: Re: IPSEC and NAT
>=20
> On Fri, 2004-10-15 at 14:00, Emiel Mols wrote:
> > Hi,
> >=20
> > =20
> >=20
> > I've managed to setup a host-to-net ipsec connection with a remote netw=
ork
> > on a linux router using (ported) isakmpd and kernel 2.6.8.1. However, I
> want
> > to be able to 'share' this ipsec connection with the rest of the networ=
k,
> > but since no ipsecn virtual interface is created in the 2.6 kernels I
> can't
> > use ordinary SNAT/MASQUERADE targets in iptables: ipsec packets get
> > encrypted before entering the POSTROUTING table :(, so the source addre=
ss
> of
> > the encapsulated packet can't be changed anymore. I've read
> >
> http://lists.netfilter.org/pipermail/netfilter-devel/2004-January/thread.=
htm
> > l#13879, but the supplied patch doesn't work very well.
> >=20
> > =20
> >=20
> > Does anyone have any suggestions on how to get this working?
> <snip>
> I may be a bit tired at the end of a long week and have thus missed your
> point . . . but why not set it up as a net-to-net connection? - John
> --=20
> John A. Sullivan III
> Chief Technology Officer
> Nexus Management
> +1 207-985-7880
> john.sullivan@nexusmgmt.com
> ---
> If you are interested in helping to develop a GPL enterprise class
> VPN/Firewall/Security device management console, please visit
> http://iscs.sourceforge.net=20
>=20
>=20
>=20
>=20

--vGgW1X5XWziG23Ko
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBcHbNkZz88chpJ2MRAkN4AJ4ug6/LF+WBjE7bVM4xsdg2YfXhnwCeN15O
OXfrezDZ8XPvUXYyFwpO2q8=
=iX+Y
-----END PGP SIGNATURE-----

--vGgW1X5XWziG23Ko--
