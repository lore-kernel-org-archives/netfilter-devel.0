From: Harald Welte <laforge@netfilter.org>
Subject: Re: extra/pptp-conntrack-nat.patch
Date: Mon, 31 Mar 2003 15:07:15 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030331130715.GR7718@sunbeam.de.gnumonks.org>
References: <3E8832B4.8030901@fl.priv.at> <20030331123134.GN7718@sunbeam.de.gnumonks.org> <3E883849.3050706@fl.priv.at>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MOLI6A2k/lnHENyK"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Friedrich Lobenstock <fl@fl.priv.at>
Content-Disposition: inline
In-Reply-To: <3E883849.3050706@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--MOLI6A2k/lnHENyK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2003 at 02:44:57PM +0200, Friedrich Lobenstock wrote:
> Harald Welte wrote:
> >
> >actually, _with_ the '//' in front, it accepts packets with broken
> >checksums.  If you remove the '//' in front, it will not consider
> >packets with broken checksums.
> >
> >So W2k should work with the shipped patch ! (IIRC, it works in both
> >cases)
> >
>=20
> So I conclude that there is not a W2k at the other side (I missinterpreted
> the comment ion the patch the other way round) because I needed to remove
> the '//' to get it working. But when I ask the people what they've got
> as PPTP-Server they tell me it's a W2k server.
>
> At least it works now but it looks like a mistery now.

indeed. can anybody else on the mailinglist confirm this observation?

> Friedrich Lobenstock

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--MOLI6A2k/lnHENyK
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+iD2DXaXGVTD0i/8RAnA5AJ9A3mxpQiweTbsX1K8mCUYBttI6ZQCfaIHK
UxMh9oG1H6XyXQqOHbW6Kd8=
=5Y7a
-----END PGP SIGNATURE-----

--MOLI6A2k/lnHENyK--
