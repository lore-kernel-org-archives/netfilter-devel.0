From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] two bugfixes to ownercmd
Date: Sat, 19 Feb 2005 20:02:06 +0100
Message-ID: <20050219190206.GP29256@sunbeam.de.gnumonks.org>
References: <421408A2.1050002@niksula.hut.fi>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Cc: netfilter-devel@lists.netfilter.org
To: Jonas Berlin <jberlin@niksula.hut.fi>
Content-Disposition: inline
In-Reply-To: <421408A2.1050002@niksula.hut.fi>
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


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 17, 2005 at 04:59:46AM +0200, Jonas Berlin wrote:
> I found two bugs in the ownercmd patch in patch-o-matic-ng. The patch=20
> adds the ipv6 version of the same functionality already found in stock=20
> kernels for ipv4.

thanks, applied to svn (3729)

--=20
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFCF40uXaXGVTD0i/8RAn2eAKCrUBSlNhuvfAOp6W6IS0kPiD9kfQCgj+lm
BA8S7eCrJvBfalVsjzHJVKI=
=fIdC
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
