From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: pppoe with NAT not working
Date: Fri, 21 Oct 2005 20:46:08 +0200
Message-ID: <20051021184608.GA27002@zion.homelinux.com>
References: <23027.::ffff:195.115.41.103.1129902602.squirrel@webmail.nerim.net>
	<435921A7.6050703@nerim.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="azLHFNyN32YCQGCU"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: =?iso-8859-1?Q?S=E9bastien?= Bernard <sbernard@nerim.net>
Content-Disposition: inline
In-Reply-To: <435921A7.6050703@nerim.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi S=E9bastien,

On Fri, Oct 21, 2005 at 07:13:11PM +0200, S=E9bastien Bernard told us:
> I figured out the problem.
>=20
> NAT is not working with the rp-pppoe.so plugin.
> I moved back to the
>=20
> pty "/usr/sbin/pppoe -I eth0 -T 80 -m 1452"
>=20
> Which worked now (go figure...).
> And NAT is working again.
>=20
> Any reason for this ?

sorry, I don't know the reason, but the only thing I can say here is
"works for me" and has been working for the last 2 1/2 years, at first
on redhat 9, now I currently have fedora core 4 on my home internet
machine with two other machines on my internal network...


Sven

--=20
Linux zion.homelinux.com 2.6.14-rc4-mm1_11 #11 Tue Oct 18 13:24:39 CEST 200=
5 i686 athlon i386 GNU/Linux
 20:43:32 up 2 days, 20:28,  1 user,  load average: 0.05, 0.03, 0.00

--azLHFNyN32YCQGCU
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDWTdwo4FAdB2PneQRAu8bAKCCMmB18+ffDhDBFfSBPzPH5AesfgCfenVn
OgtSEKApR+g+rTXIEKIO+7k=
=0Peq
-----END PGP SIGNATURE-----

--azLHFNyN32YCQGCU--
