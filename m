From: Sven Schuster <schuster.sven@gmx.de>
Subject: Re: Logging NAT translations?
Date: Mon, 2 Aug 2004 18:11:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040802161124.GA20307@zion.homelinux.com>
References: <87isc7on6q.fsf@ion.xlipstream.com> <20040801170153.GC14539@sunbeam2>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HlL+5n6rz5pIUxbD"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, Chris Green <cmg@dok.org>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040801170153.GC14539@sunbeam2>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hi Harald, hi Chris,

On Sun, Aug 01, 2004 at 07:01:53PM +0200, Harald Welte told us:
> On Wed, Jul 28, 2004 at 05:07:41PM -0400, Chris Green wrote:
>=20
> > The closest I've found is nfnetlink-ctnetlink. =20
>=20
> Yes, this should provide you with all information you need.
>=20
> > Anyone know what the status of this is?  I know it doesn't work with
> > 2.6 and I've been told it doesn't work with recent 2.4s either.
>=20
> then someone needs to do some porting/merging work... patches
> appreciated ;)


just jumping in here as I've done some basic porting work on
nfnetlink-ctnetlink some time ago which wasn't a big pain to get it
working on a 2.6.x kernel.  But in the meantime there were some changes
in the NAT/conntrack subsystem which I had to resolve to get the patch
working and still have to, but, you know, no time left for this :-) I
think those changes were around 2.6.3 kernel.
I'll see if I still can find my old work and if I can do something
to get it working on a recent 2.6.x kernel. But don't hold your
breath, time is quite limited as always (like probably everybody
here knows :-)


Sven

>=20
> This is still not in the mainline kernel, because the netlink message
> format is still not stable.
>=20
> > Cheers,
> > Chris
>=20
> --=20
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.o=
rg/

--=20
Linux zion 2.6.8-rc2 #1 Sun Jul 18 15:00:48 CEST 2004 i686 athlon i386 GNU/=
Linux
 18:10:07  up 14 days, 19:38,  1 user,  load average: 0.00, 0.03, 0.00

--HlL+5n6rz5pIUxbD
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFBDmeso4FAdB2PneQRArUOAJ9Na1y6fLUEhxlL6nY24LjYjcpvvgCdFQt5
47qr98Jj3ECf7nd/n4kOQ8w=
=W/lT
-----END PGP SIGNATURE-----

--HlL+5n6rz5pIUxbD--
