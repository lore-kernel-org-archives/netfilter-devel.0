From: Harald Welte <laforge@netfilter.org>
Subject: Re: [TYPO] patch to cvs libipt_string.c
Date: Wed, 30 Apr 2003 18:01:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430160134.GF685@sunbeam.de.gnumonks.org>
References: <Pine.LNX.4.44.0304281524370.22672-100000@blimp.psdhost.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="maH1Gajj2nflutpK"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: ofudd@psdhost.net
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0304281524370.22672-100000@blimp.psdhost.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--maH1Gajj2nflutpK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 28, 2003 at 03:29:31PM -0700, ofudd@psdhost.net wrote:
> Hi!
>=20
> I downloaded iptables from CVS today, enabled the string matching
> feature, and tried to compile the userspace tools.  Compilation failed
> due to a typo.
>=20
> In ./netfilter/userspace/extensions/libipt_string.c:

This is bugzilla bug 89, which has been fixed now.

> ofudd@psdhost.net
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--maH1Gajj2nflutpK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+r/NeXaXGVTD0i/8RApSnAJ9iCncYygwgX8h18I3aDsN1a36ePQCfSL1c
TXd3nfKGl+KZmVjywcYSHqM=
=MofM
-----END PGP SIGNATURE-----

--maH1Gajj2nflutpK--
