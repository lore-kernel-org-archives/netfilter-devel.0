From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [RELEASE]  Condition variable match module
Date: Thu, 13 Feb 2003 10:53:57 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030213095357.GB14794@sunbeam.de.gnumonks.org>
References: <3E497F9F.5000608@videotron.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>
Content-Disposition: inline
In-Reply-To: <3E497F9F.5000608@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2003 at 05:56:31PM -0500, Stephane Ouellette wrote:
> Folks,
>=20
>    here's the second version of the condition variable match module.=20
> There are two separate sets of patches in order to support ip6tables.

Nice work.  I'm still not decided on whether this is really something
useful or rather consider it as some 'hack' ;)

Anyway, I'll put it in patch-o-matic, if a couple of issues are
resolved:

- adhere to /usr/src/linux/Documentation/CodingStyle, esp.
	- indentation
	- opening braces '{' not at seperate line
	- No C++ comments in C code
	- if and for are not functions, space before '('
	- return is not a function, no () around retval.
- indicate on top of the sourcecode that the code is released under the
  terms of GNU GPL

> Regards,
> Stephane Ouellette.

--=20
- Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+S2s1XaXGVTD0i/8RAiDZAJwJ2ASnaLj53ctRG5CfcMLMPjxOqgCgsrZf
GD7qwrb7k+gLkRyEcNJjVa0=
=UUwI
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
