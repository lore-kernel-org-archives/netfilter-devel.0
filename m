From: Harald Welte <laforge@netfilter.org>
Subject: Re: PPTP conntrack NOT working in kernel 2.6
Date: Tue, 1 Feb 2005 14:16:51 +0100
Message-ID: <20050201131651.GG6878@sunbeam.de.gnumonks.org>
References: <7a182bd905012005523e78f4c6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BWpbUxt7sU2t3mXs"
Cc: netfilter-devel@lists.netfilter.org
To: Laurens Blankers <laurens.blankers@gmail.com>
Content-Disposition: inline
In-Reply-To: <7a182bd905012005523e78f4c6@mail.gmail.com>
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


--BWpbUxt7sU2t3mXs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 20, 2005 at 02:52:16PM +0100, Laurens Blankers wrote:
> Hello Harald & all,
>=20
> I'm having problems with PPTP conntrack when using kernel 2.6.10 and
> pom-ng from SVN. The problem is a bit difficult to explain so please
> read carefully.

There are a number of known issues with the (experimental) 2.6.x port of
the helper.  Due to time constraints, I wasn't able to address those
issues yet.

Please note that I've just committed a few important fixes to svn, so
maybe it already works with what is now in svn. =20

I'll try to get some test setup running tomorrow.

> Also at exactly 60 second intervals the system log shows the following er=
ror:
>=20
> Jan 20 12:40:33 src@beta net/ipv4/netfilter/ip_conntrack_pptp.c: bad csum
>=20

This is mor like an informational message, at least in case you run W2K
PPTP server.  It is buggy and always sends certain packet with broken
tcp checksum.  The packet is ignored, W2K retransmits with correct csum

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--BWpbUxt7sU2t3mXs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB/4FDXaXGVTD0i/8RAre3AKCKJrRnP7nfjwFe+4OmgQUcdqld4gCfZwwX
HxAKKSEJzo6RzpvjS/7AdAc=
=FJKl
-----END PGP SIGNATURE-----

--BWpbUxt7sU2t3mXs--
