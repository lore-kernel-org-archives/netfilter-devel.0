From: Harald Welte <laforge@netfilter.org>
Subject: Re: [Debian Bug#218837] limit match not working on sparc64
Date: Fri, 7 Nov 2003 01:03:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031107000324.GC5741@sunbeam.de.gnumonks.org>
References: <20031106160055.GA25555@absolom.libra.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JlJsEFsx9RQyiX4C"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20031106160055.GA25555@absolom.libra.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JlJsEFsx9RQyiX4C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2003 at 11:00:56AM -0500, Laurence J. Lane wrote:
> I received a bug report [0] regarding the limit match not working
> on sparc64 with kernel 2.4.22. It references an earlier report [1]
> of the problem on this list. Harald Welete commented on it [2] and
> asked for additional information, but there is no clear resolution.
>=20
> Anyone?

this is most likely never going to get fixed.   the problem is that the
limit match does an ugly hack: it stores a pointer in it's struct
matchinfo.  That pointer is 64bits in the kernel, but userspace is
32bits, and thus the compilar only allocates 32bit for the pointer in
the structure: boom.

The structure was commented by the original author with:
        /* Ugly, ugly fucker. */

:(

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JlJsEFsx9RQyiX4C
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/quFMXaXGVTD0i/8RAvc9AKCv2KDIwkyW4JqOZbA2sE1EG9sVzACeNtoW
cSnlYOJDKT62tEgcC1NrNIU=
=2oir
-----END PGP SIGNATURE-----

--JlJsEFsx9RQyiX4C--
