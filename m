From: Harald Welte <laforge@netfilter.org>
Subject: Re: libfnetlink_queue patch
Date: Fri, 23 Sep 2005 15:56:48 +0200
Message-ID: <20050923135648.GA731@sunbeam.de.gnumonks.org>
References: <54076.195.7.127.249.1126863075.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f8lmXUvqnCdFQPaI"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
Content-Disposition: inline
In-Reply-To: <54076.195.7.127.249.1126863075.squirrel@mail.inl.fr>
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


--f8lmXUvqnCdFQPaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 16, 2005 at 11:31:15AM +0200, Eric Leblond wrote:
> Hi,
>=20
> I've resend you two days a go a user level API implementation using
> pablo's macro.

sorry for causing delays.  I'm reviewing your patches and I'll submit
them ASAP.  A first release of libnfnetlink and libnfnetlink_queue is
immediate.

btw: if you could look into the build problems, that would be fine (i.e.
the test program being linked against the system-wide installed (old)
version of the library, instead of the just-built (new) version.

I really don't know anything about autoconf/automake

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--f8lmXUvqnCdFQPaI
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDNAmgXaXGVTD0i/8RAmhxAKCCof0tJBu5p/rlJgk7dwSmEiWEPwCeO11Y
zFmTYvKh4TNbxDd19lIsiJ8=
=zzg/
-----END PGP SIGNATURE-----

--f8lmXUvqnCdFQPaI--
