From: Harald Welte <laforge@netfilter.org>
Subject: Re: SVN woes
Date: Fri, 8 Oct 2004 02:35:13 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041008003513.GU13901@sunbeam.de.gnumonks.org>
References: <7C9884991ADAE0479C14F10C858BCDF5679559@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0M7E0x35R+W+EAky"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
Content-Disposition: inline
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF5679559@alderaan.smgtec.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--0M7E0x35R+W+EAky
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 07, 2004 at 01:41:49PM -0700, Daniel Chemko wrote:
>  http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk=20
>=20
> An Exception Has Occurred

I'm sorry for this inconvenience.  I have no idea what caused the
problem at this moment.  The repository is now recovered and working
again, but I fear it will get stuck again, since the cause of that
problem is yet unknown.

>     self.repos =3D repos.svn_repos_open(rootpath, self.pool)
> SubversionException: ("Berkeley DB error while opening 'revisions' table
> for filesystem /data/svn/netfilter.org/netfilter/db:\nCannot allocate
> memory", 160029)

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--0M7E0x35R+W+EAky
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBZeDBXaXGVTD0i/8RAjKZAKCP8/wka2OPiDPpkW4C3/YeSDDcsQCfVuqT
jSnwD9Zoodg8kKYP7or0AfA=
=G/KR
-----END PGP SIGNATURE-----

--0M7E0x35R+W+EAky--
