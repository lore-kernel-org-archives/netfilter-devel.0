From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 3/3] pom-ng: update sip-conntrack-nat for 2.6.12
Date: Fri, 29 Jul 2005 12:56:12 +0200
Message-ID: <20050729105612.GC7063@rama.de.gnumonks.org>
References: <20050726190519.GA2128@zion.homelinux.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R+My9LyyhiUvIEro"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schuster <schuster.sven@gmx.de>
Content-Disposition: inline
In-Reply-To: <20050726190519.GA2128@zion.homelinux.com>
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


--R+My9LyyhiUvIEro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 26, 2005 at 09:05:19PM +0200, Sven Schuster wrote:
>=20
> Hi,
>=20
> the attached patch updates the sip-conntrack-nat patchlet in pom-ng
> for 2.6.12.

thanks, applied.

> Compile-tested by me on 2.6.13-rc3-mm1, I haven't been able to verify
> the functionality, but at least the module loads :-)

the changes are non-intrusive and only affect changing from lockhelp
macros to regular locking functions.  I don't see how those four changed
lines would create a bug.

btw: if you do any future merges (2.6.13 and beyond have yet another
change in the helper api...), please just send me an incremental diff to
the last version in patch-o-matic-ng (e.g. to 2.6.12 in the 2.6.13
case).

I will make a 'svn cp' of the 2.6.12 code and then apply your diff on
top of it.  Right now I have to do 'svn cp', apply your patch to some
other location, copy the files over, and then do 'svn diff' in order to
see what you actually changed.

thanks!
--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--R+My9LyyhiUvIEro
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFC6gtMXaXGVTD0i/8RAtyBAJ4vNCn2MR9s61CFl8+3TBx7+o3jsQCff0ZJ
EL/agbKobr+u0RAGb+VXiz0=
=7t28
-----END PGP SIGNATURE-----

--R+My9LyyhiUvIEro--
