From: Harald Welte <laforge@netfilter.org>
Subject: Re: string patch for 2.6
Date: Tue, 4 Jan 2005 11:59:30 +0100
Message-ID: <20050104105930.GV11370@sunbeam.de.gnumonks.org>
References: <41D3BB89.6040609@pwn.emphyrio.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eG64T7htjB593fMc"
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Dimitris Kotsonis <jnk@pwn.emphyrio.org>
Content-Disposition: inline
In-Reply-To: <41D3BB89.6040609@pwn.emphyrio.org>
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


--eG64T7htjB593fMc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 30, 2004 at 10:25:45AM +0200, Dimitris Kotsonis wrote:
> This is a patch against pong-20041229 that will add string support for=20
> kernel 2.6

sorry if I'm sounding rude, but it has been discussed on this list _OVER
AND OVER AGAIN_.  And patches like yours can be found alrady in the archive.

still it is broken.  think of non-linear skbs.

> Dimitris
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--eG64T7htjB593fMc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)

iD8DBQFB2ncSXaXGVTD0i/8RAscyAKCMNJ1bmL0l9D+9UTZiBfD2J3gZlgCgr+qH
hz661f0mBG/J8v9BZL/k1iI=
=1hFe
-----END PGP SIGNATURE-----

--eG64T7htjB593fMc--
