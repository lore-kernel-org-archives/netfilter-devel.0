From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ippool -X not working
Date: Fri, 05 Dec 2003 18:44:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1070646289.22338.3.camel@tux.rsn.bth.se>
References: <Pine.LNX.4.44.0312051604100.3680-300000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ed7sEKVKZ38Lr1EKXlWO"
Cc: Rodrigo Severo <rodrigo.lists@fabricadeideias.com>,
	Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312051604100.3680-300000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Ed7sEKVKZ38Lr1EKXlWO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2003-12-05 at 16:10, Henrik Nordstrom wrote:
> On Fri, 5 Dec 2003, Rodrigo Severo wrote:
>=20
> > I can't make neither -x nor the -X POOL options work. I always get a=20
> > "IP_POOL_DESTROY POOL failed: Device or resource busy" message. The POO=
L=20
> > isn't used yet anywhere, I'm justing testing pool creation by now.
>=20
> These operations are not implemented in the ippool version in=20
> base/ippool.patch.
>=20
> Attached is a patch implementing the flush and destroy ippool operations.=
 =20
> We have had this patch for a while but not posted it yet as there was tal=
k
> about replacing the ippool implementation with the new modularized
> implementation by Joakim Axelsson and that the current implementation is
> not actively maintained and we did not want to stir up confusion on that
> subject. The patch obviously depends on the base/ippool.patch.

The latest "semi-released" version of the new ippool can be found at:
http://gandalf.hjorten.nu/ippool/ippool-0.3.2b.tgz

It's not a nice patch, it needs some file-copying and manual chaning of
Makefile etc...

I use it in production here, works great.

--=20
/Martin

--=-Ed7sEKVKZ38Lr1EKXlWO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQA/0MQRWm2vlfa207ERAlSrAKCLZKz9f8EAbd8JxaGuavTP4pY5TACeMIof
E9ojBFJhR+gVywsZS3nJAmw=
=rRL5
-----END PGP SIGNATURE-----

--=-Ed7sEKVKZ38Lr1EKXlWO--
