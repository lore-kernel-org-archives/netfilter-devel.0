From: Harald Welte <laforge@netfilter.org>
Subject: Re: MARK target extension (fwd)
Date: Fri, 22 Oct 2004 13:51:48 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041022115148.GD3551@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.61.0410211516120.21167@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XrjDSOQsS4AlGTKt"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0410211516120.21167@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--XrjDSOQsS4AlGTKt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 21, 2004 at 03:18:34PM +0200, Henrik Nordstrom wrote:
> Found the CONNMARK mark operations patch by Grzegorz Nosek. It=20
> appears Grzegorz never sent this to the mailinglist and I assumed he did..

Ok, that explains the mystery :)

> I have not verified the patch in detail, but like the idea.

Ok, so let's leave CONNMARK without mark-operations for now, just like
it went into the kernel.  We know it works, and I rather not push a
almost unknown and untested patch directly to the kernel.

If you [or maybe somebody else] ever get a chance to verify, review and
test the patch, maybe at that point we will be able to deal with the
compatibility issues.

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--XrjDSOQsS4AlGTKt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFBePRUXaXGVTD0i/8RAidFAJ0Vy+rjoD3+UrIS33E4Y9uAA3dsjwCePx+l
9EE/jtaCzBfLs5wvWzqkLoM=
=bCLL
-----END PGP SIGNATURE-----

--XrjDSOQsS4AlGTKt--
