From: Harald Welte <laforge@netfilter.org>
Subject: Re: Logging NAT translations?
Date: Sun, 1 Aug 2004 19:01:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040801170153.GC14539@sunbeam2>
References: <87isc7on6q.fsf@ion.xlipstream.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Green <cmg@dok.org>
Content-Disposition: inline
In-Reply-To: <87isc7on6q.fsf@ion.xlipstream.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 28, 2004 at 05:07:41PM -0400, Chris Green wrote:

> The closest I've found is nfnetlink-ctnetlink. =20

Yes, this should provide you with all information you need.

> Anyone know what the status of this is?  I know it doesn't work with
> 2.6 and I've been told it doesn't work with recent 2.4s either.

then someone needs to do some porting/merging work... patches
appreciated ;)

This is still not in the mainline kernel, because the netlink message
format is still not stable.

> Cheers,
> Chris

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBDSIBXaXGVTD0i/8RAktGAKC085vxEGMYvbnoqkYuEyubr+VWuwCgjjeZ
nBkLrcVkBFbzRkwlMEobP4Y=
=ljVf
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
