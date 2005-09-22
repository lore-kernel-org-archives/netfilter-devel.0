From: Harald Welte <laforge@netfilter.org>
Subject: Re: hashlimit module parameters
Date: Thu, 22 Sep 2005 23:51:04 +0200
Message-ID: <20050922215104.GU26520@sunbeam.de.gnumonks.org>
References: <43329209.8040607@astral.ro>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h5TCuzcqTWZxfGfk"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Imre Gergely <imre.gergely@astral.ro>
Content-Disposition: inline
In-Reply-To: <43329209.8040607@astral.ro>
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


--h5TCuzcqTWZxfGfk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 22, 2005 at 02:14:17PM +0300, Imre Gergely wrote:
>=20
> hi
>=20
> i was wondering about something. i want to use this hashlimit module,
> and the doc says the --hashlimit parameter is just like the one in the
> limit match, but when i want to do
>=20
> /usr/local/iptables-1.3.3-20050921/sbin/iptables -A INPUT -s 1.1.1.1 -m
> hashlimit --hashlimit ! 5/sec --hashlimit-mode srcip --hashlimit-name
> test -j ACCEPT
>=20
> it gives me an error:
>=20
> iptables v1.3.3-20050921: hashlimit does not support invert
> Try `iptables -h' or 'iptables --help' for more information.
>=20
> is there a way to specify an invert to this ?

I don't think so, sorry :(  Seems like I forgot to take care of limit
inversion.  Patches welcome.

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--h5TCuzcqTWZxfGfk
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDMydIXaXGVTD0i/8RAjqcAJ4l64FV4VHNU2KKrATDKV1oxwdzbgCeI2qK
RnwRMKXCva+eLjUUk3UoQJY=
=ulnQ
-----END PGP SIGNATURE-----

--h5TCuzcqTWZxfGfk--
