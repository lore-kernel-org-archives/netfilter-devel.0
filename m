From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH] Trivial space char fix for --log-prefix
Date: Thu, 11 Dec 2003 14:06:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211130633.GB22826@sunbeam.de.gnumonks.org>
References: <20031208094557.GA16116@orthanc.gambrl01.md.comcast.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8YbZbqleQryf2nq"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Rash <mbr@cipherdyne.org>
Content-Disposition: inline
In-Reply-To: <20031208094557.GA16116@orthanc.gambrl01.md.comcast.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--B8YbZbqleQryf2nq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 08, 2003 at 04:45:57AM -0500, Michael Rash wrote:
> Hello -
>=20
> This patch adds a space character to the --log-prefix string if the
> user did not have it already.  This prevents the "IN=3D" field in
> iptables log messages from being obscured by a --log-prefix that
> doesn't have a space.
>=20
> (Resending this since my original post did not seem to make it
> through).
>=20

We have received such a patch numerous times.  However, we felt that
changing the behaviour now is bad - everybody knows about the old
behaviour by now, and all the scripts that have been written in the last
couple of years assume it to _not_ automatically add the space.

Yes, I regard it a bug.  But we'd rather stick with it for compatibility
reasons :(

> --Mike
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--B8YbZbqleQryf2nq
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/2GvZXaXGVTD0i/8RAtvzAJ92NGRe9Ur92i6Ktv4YB8VDBLX4bgCfRfML
rO6AXogig4sLuIciVQKfEDQ=
=Kl0g
-----END PGP SIGNATURE-----

--B8YbZbqleQryf2nq--
